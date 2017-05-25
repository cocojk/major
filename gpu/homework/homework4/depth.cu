
#include "common.h"
#include <stdio.h>
#include <cuda_runtime.h>



// number of stream in the program 
#define NSTREAM 8


// host program to calculate the correct answer 
// parameter : int* A (input matrix)
//             int* B (input matrix)
//             int* C (output matrix)
//             int  N (size of the matrix)
void sumArraysOnHost(int *A, int *B, int *C, const int N)
{
    // calculate the answer 
    for (int idx = 0; idx < N; idx++)
        C[idx] = A[idx] + B[idx];
}

// matrix addition kernel function 
// parameter : int* A (input matrix)
//             int* B (input matrix)
//             int* C (output matrix, C)
//             int  N (size of the matrix )
__global__ void sumArrays(int *A, int *B, int *C, const int N)
{
    // calculate the unique threadId 
    // unique threadId can be used to determine the position of addition 
    int ix = blockIdx.x * blockDim.x + threadIdx.x;
    int iy = blockIdx.y * blockDim.y + threadIdx.y;

    unsigned int idx = iy * blockDim.x * gridDim.x + ix; 

    if (idx < N)
    {
      C[idx] = A[idx] + B[idx];
    }
}

// host and kernel result compare function
// parameter : int* hostRef (host result)
//             int* gpuRef (kernel result)
//             int  N (size of the matrix)
void checkResult(int *hostRef,int *gpuRef, const int N)
{
    bool match = 1;

    for (int i = 0; i < N; i++)
    {
        // if the result is not same 
        if (hostRef[i] != gpuRef[i]) 
        {
            match = 0;
            printf("Arrays do not match!\n");
            printf("host %d gpu %d at %d\n", hostRef[i], gpuRef[i], i);
            break;
        }
    }

    // if the result is same 
    if (match) printf("Arrays match.\n\n");
}

int main(int argc, char **argv)
{

    int dev = 0;
    
    cudaDeviceProp deviceProp;
    
    // get device information 
    // return : cudaError_t
    // parameter : cudaDeviceProp* prop , int device 
    // returns cudaGetDeviceProperties of device 
    CHECK(cudaGetDeviceProperties(&deviceProp, dev));
    printf("> Using Device %d: %s\n", dev, deviceProp.name);
    
    // return : cudaError_t 
    // parameter : int device (device on which the active host thread should execute the device code)
    // records device as the device on which the active host thread executes the device code 
    CHECK(cudaSetDevice(dev));


    // set up max connectioin
    setenv ("CUDA_DEVICE_MAX_CONNECTIONS", "4", 1);

    int nx = 8192;
    int ny = 8192;
    int dimx = 32;
    int dimy = 32;

    // each stream subset problem size 
    int subset = nx*ny/ NSTREAM;
    
    // kernel configuration
    // we just slice the x-axis to divide the problem
    dim3 block(dimx,dimy);
    dim3 grid((nx/NSTREAM+block.x-1)/block.x,(ny+block.y-1)/block.y);


    
    // malloc pinned host memory for async memcpy
    // return : cudaError_t 
    // parameter : void** pHost, size_t size , unsigned int flags 
    // allocates (size) bytes of host memory that is page-locked and accessible to the device 
    int *h_A, *h_B, *hostRef, *gpuRef;
    CHECK(cudaHostAlloc((void**)&h_A, nx*ny*sizeof(int), cudaHostAllocDefault));
    CHECK(cudaHostAlloc((void**)&h_B, nx*ny*sizeof(int), cudaHostAllocDefault));
    CHECK(cudaHostAlloc((void**)&gpuRef, nx*ny*sizeof(int), cudaHostAllocDefault));
    CHECK(cudaHostAlloc((void**)&hostRef, nx*ny*sizeof(int), cudaHostAllocDefault));

    // init the data 
    for (int i = 0; i < (nx*ny); i++)
    {
        h_A[i] = i;
        h_B[i] = i;
        hostRef[i] = 0;
        gpuRef[i] = 0;
    }
    

    // add vector at host side for result checks
    sumArraysOnHost(h_A, h_B, hostRef, nx*ny);

    // malloc device global memory
    int *d_A, *d_B, *d_C;
    // return : cudaError_t 
    // parameter : void** devPtr, size_t size 
    // allocates (size) bytes of lineare memory on the device and returns in (*devPtr) a pointer to the allocated memory 
    CHECK(cudaMalloc((int**)&d_A, nx*ny*sizeof(int)));
    CHECK(cudaMalloc((int**)&d_B, nx*ny*sizeof(int)));
    CHECK(cudaMalloc((int**)&d_C, nx*ny*sizeof(int)));




    // stream declare 
    cudaStream_t stream[NSTREAM];

    // create a new asynchronous stream 
    // return : cudaError_t 
    // parameter : cudaStream_t* pStream 
    for (int i = 0; i < NSTREAM; ++i)
    {
        CHECK(cudaStreamCreate(&stream[i]));
    }


    // initiate all work on the device asynchronously in depth-first order
    for (int i = 0; i < NSTREAM; ++i)
    {
        int ioffset = i * subset;
        CHECK(cudaMemcpyAsync(&d_A[ioffset], &h_A[ioffset], subset*sizeof(int),
                              cudaMemcpyHostToDevice, stream[i]));
        CHECK(cudaMemcpyAsync(&d_B[ioffset], &h_B[ioffset], subset*sizeof(int),
                              cudaMemcpyHostToDevice, stream[i]));
        sumArrays<<<grid, block, 0, stream[i]>>>(&d_A[ioffset], &d_B[ioffset],
                &d_C[ioffset], subset);
        CHECK(cudaMemcpyAsync(&gpuRef[ioffset], &d_C[ioffset], subset*sizeof(int),
                              cudaMemcpyDeviceToHost, stream[i]));
    }


    
    // return : cudaError_t 
    // parameter : void 
    // blocks until the device has completed all preceding requsted tasks.
    CHECK(cudaDeviceSynchronize());
    

    // check device results
    checkResult(hostRef, gpuRef, nx*ny);

    // free device global memory
    // return : cudaError_t 
    // parameter : void* devPtr 
    // free the memory space pointed to by devPtr 
    CHECK(cudaFree(d_A));
    CHECK(cudaFree(d_B));
    CHECK(cudaFree(d_C));

    // free page-locked memory 
    // return : cudaError_t 
    // parameter : void* ptr 
    CHECK(cudaFreeHost(h_A));
    CHECK(cudaFreeHost(h_B));
    CHECK(cudaFreeHost(hostRef));
    CHECK(cudaFreeHost(gpuRef));


    // destroys and cleans up an asynchronous stream 
    // return : cudaError_t 
    // parameter : cudaStream_t stream  
    for (int i = 0; i < NSTREAM; ++i)
    {
        CHECK(cudaStreamDestroy(stream[i]));
    }

    // reset device
    // return : cudaError_t 
    // parameter : void 
    // explicitly destoys and cleans up all resources associated with the current device in the current process 
    CHECK(cudaDeviceReset());
    return(0);
}
