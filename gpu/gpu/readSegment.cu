#include "common.h"
#include <cuda_runtime.h>
#include <stdio.h>

/*
 * This example demonstrates the impact of misaligned reads on performance by
 * forcing misaligned reads to occur on a float*.
 */

// parameter : float * hostRef, float* gpuRef, const int N
// compare the data pointed by (hostRef) and the data pointed by (gpuRef). (N) is the number of compared data 
void checkResult(float *hostRef, float *gpuRef, const int N)
{
    double epsilon = 1.0E-8;
    bool match = 1;

    for (int i = 0; i < N; i++)
    {
        if (abs(hostRef[i] - gpuRef[i]) > epsilon)
        {
            match = 0;
            printf("different on %dth element: host %f gpu %f\n", i, hostRef[i],
                    gpuRef[i]);
            break;
        }
    }

    if (!match)  printf("Arrays do not match.\n\n");
}

// parameter : float *ip, int size 
// init the data pointed by (ip). (size) is the number of inited data
void initialData(float *ip,  int size)
{
    for (int i = 0; i < size; i++)
    {
        ip[i] = (float)( rand() & 0xFF ) / 100.0f;
    }

    return;
}

// parameter : float *A, float *B ,float *C 
// skip the (offset), then add the data pointed by (A) to the data pointed by (B) and save that data to the (C) in the host  
void sumArraysOnHost(float *A, float *B, float *C, const int n, int offset)
{
    for (int idx = offset, k = 0; idx < n; idx++, k++)
    {
        C[k] = A[idx] + B[idx];
    }
}

// parameter : float * A, float * B, float *C 
// skip the (offset), then add the data pointed by (A) to the data pointed by (B) and save that data to the (C) in the device 
__global__ void warmup(float *A, float *B, float *C, const int n, int offset)
{
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int k = i + offset;

    if (k < n) C[i] = A[k] + B[k];
}


// parameter : float * A, float * B, float *C 
// skip the (offset), then add the data pointed by (A) to the data pointed by (B) and save that data to the (C) in the device 
__global__ void readOffset(float *A, float *B, float *C, const int n,
                           int offset)
{
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int k = i + offset;

    if (k < n) C[i] = A[k] + B[k];
}

int main(int argc, char **argv)
{
    // set up device
    int dev = 0;
    cudaDeviceProp deviceProp;
    
    // return : cudaError_t 
    // parameter : int device (device on which the active host thread should execute the device code)
    // records device as the device on which the active host thread executes the device code 
    CHECK(cudaSetDevice(dev));
    
    // get device information
    // return : cudaError_t
    // parameter : cudaDeviceProp* prop , int device 
    // returns cudaGetDeviceProperties of device 
    CHECK(cudaGetDeviceProperties(&deviceProp, dev));
    
    printf("%s starting reduction at ", argv[0]);
    printf("device %d: %s ", dev, deviceProp.name);

    // set up array size
    int nElem = 1 << 20; // total number of elements to reduce
    printf(" with array size %d\n", nElem);
    size_t nBytes = nElem * sizeof(float);

    // set up offset for summary
    int blocksize = 512;
    int offset = 0;

    // get the offset from the argument 
    if (argc > 1) offset    = atoi(argv[1]);

    // get the blocksize from the argument
    if (argc > 2) blocksize = atoi(argv[2]);

    // execution configuration
    dim3 block (blocksize, 1);
    dim3 grid  ((nElem + block.x - 1) / block.x, 1);

    // allocate host memory
    float *h_A = (float *)malloc(nBytes);
    float *h_B = (float *)malloc(nBytes);
    float *hostRef = (float *)malloc(nBytes);
    float *gpuRef  = (float *)malloc(nBytes);

    //  initialize host array
    initialData(h_A, nElem);
    memcpy(h_B, h_A, nBytes);

    //  summary at host side
    sumArraysOnHost(h_A, h_B, hostRef, nElem, offset);

    // allocate device memory
    float *d_A, *d_B, *d_C;
    // allocate the device memory
    // return : cudaError_t 
    // parameter : void** devPtr, size_t size 
    // allocates (size) bytes of lineare memory on the device and returns in (*devPtr) a pointer to the allocated memory 
    CHECK(cudaMalloc((float**)&d_A, nBytes));
    CHECK(cudaMalloc((float**)&d_B, nBytes));
    CHECK(cudaMalloc((float**)&d_C, nBytes));

    // copy data from host to device
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(d_A, h_A, nBytes, cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(d_B, h_A, nBytes, cudaMemcpyHostToDevice));

    //  kernel 1:
    double iStart = seconds();
    warmup<<<grid, block>>>(d_A, d_B, d_C, nElem, offset);
    // return : cudaError_t 
    // parameter : void 
    // blocks until the device has completed all preceding requsted tasks.
    CHECK(cudaDeviceSynchronize());
    double iElaps = seconds() - iStart;
    printf("warmup     <<< %4d, %4d >>> offset %4d elapsed %f sec\n", grid.x,
           block.x, offset, iElaps);
    
    // return : cudaError_t 
    // parameter : void 
    // return the last error 
    CHECK(cudaGetLastError());

    iStart = seconds();
    readOffset<<<grid, block>>>(d_A, d_B, d_C, nElem, offset);
    // return : cudaError_t 
    // parameter : void 
    // blocks until the device has completed all preceding requsted tasks.
    CHECK(cudaDeviceSynchronize());
    iElaps = seconds() - iStart;
    printf("readOffset <<< %4d, %4d >>> offset %4d elapsed %f sec\n", grid.x,
           block.x, offset, iElaps);
    
    // return : cudaError_t 
    // parameter : void 
    // return the last error 
    CHECK(cudaGetLastError());

    // copy kernel result back to host side and check device results
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(gpuRef, d_C, nBytes, cudaMemcpyDeviceToHost));
    checkResult(hostRef, gpuRef, nElem - offset);

    // free host and device memory
    // return : cudaError_t 
    // parameter : void* devPtr 
    // free the memory space pointed to by devPtr 
    CHECK(cudaFree(d_A));
    CHECK(cudaFree(d_B));
    CHECK(cudaFree(d_C));
    free(h_A);
    free(h_B);

    // reset device
    // return : cudaError_t 
    // parameter : void 
    // explicitly destoys and cleans up all resources associated with the current device in the current process 
    CHECK(cudaDeviceReset());
    return EXIT_SUCCESS;
}
