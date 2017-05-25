#include "common.h"
#include <cuda_runtime.h>
#include <stdio.h>

/*
 * An example of using CUDA's memory copy API to transfer data to and from the
 * device. In this case, cudaMalloc is used to allocate memory on the GPU and
 * cudaMemcpy is used to transfer the contents of host memory to an array
 * allocated using cudaMalloc.
 */

int main(int argc, char **argv)
{

    // memory size
    unsigned int isize;
    unsigned int nbytes;
    
    // get the memory size as a command line argument
    if (argc == 2)
    {
        // its default size is MB
        nbytes = atoi(argv[1]) * (1<<20);
        isize = nbytes>>2;        
    }
    else 
    {
        printf("specify the memory size \n");
        exit(0);
    }

    
    // set up device
    int dev = 0;
    
    // return : cudaError_t 
    // parameter : int device (device on which the active host thread should execute the device code)
    // records device as the device on which the active host thread executes the device code 
    CHECK(cudaSetDevice(dev));


    // get device information
    cudaDeviceProp deviceProp;
    // return : cudaError_t
    // parameter : cudaDeviceProp* prop , int device 
    // returns cudaGetDeviceProperties of device 
    CHECK(cudaGetDeviceProperties(&deviceProp, dev));

    // print the current information 
    printf("%s starting at ", argv[0]);
    printf("device %d: %s memory size nbyte %5.2fMB\n", dev,
           deviceProp.name, nbytes / (1024.0f * 1024.0f));

    // allocate the host memory
    float *h_a = (float *)malloc(nbytes);

    // allocate the device memory
    // return : cudaError_t 
    // parameter : void** devPtr, size_t size 
    // allocates (size) bytes of lineare memory on the device and returns in (*devPtr) a pointer to the allocated memory 
    float *d_a;
    CHECK(cudaMalloc((float **)&d_a, nbytes));

    // initialize the host memory
    for(unsigned int i = 0; i < isize; i++) h_a[i] = 0.5f;

    // transfer data from the host to the device
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(d_a, h_a, nbytes, cudaMemcpyHostToDevice));

    // transfer data from the device to the host
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(h_a, d_a, nbytes, cudaMemcpyDeviceToHost));

    // free memory
    // return : cudaError_t 
    // parameter : void* devPtr 
    // free the memory space pointed to by devPtr 
    CHECK(cudaFree(d_a));
    free(h_a);

    // reset device
    // return : cudaError_t 
    // parameter : void 
    // explicitly destroys and cleans up all resources associated with the current device in the current process 
    CHECK(cudaDeviceReset());
    return EXIT_SUCCESS;
}
