#include "common.h"
#include <cuda_runtime.h>
#include <stdio.h>

/*
 * An example of using a statically declared global variable (devData) to store
 * a floating-point value on the device.
 */

__device__ float devData;


// print the current value of the global variable and increase by 2.0 
__global__ void checkGlobalVariable()
{
    // display the original value
    printf("Device: the value of the global variable is %f\n", devData);

    // alter the value
    devData += 2.0f;
}

int main(void)
{
    // initialize the global variable
    float value = 3.14f;
    float* devPtr;

    // get the device global variable address 
    // return : cudaError_t 
    // parameter : void** devPtr, const char* symbol 
    // return in (*devPtr) the address of symbol (symbol) on the devce 
    CHECK(cudaGetSymbolAddress((void**)&devPtr,devData));    

    
    // transfer data from the host to the device
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(devPtr, &value, sizeof(float),cudaMemcpyHostToDevice));
    printf("Host:   copied %f to the global variable\n", value);

    // invoke the kernel
    checkGlobalVariable<<<1, 1>>>();

    // transfer data from the device to the host
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(&value, devPtr, sizeof(float),cudaMemcpyDeviceToHost));
    printf("Host:   the value changed by the kernel to %f\n", value);

    

    // reset device
    // return : cudaError_t 
    // parameter : void 
    // explicitly destroys and cleans up all resources associated with the current device in the current process 
    CHECK(cudaDeviceReset());
    return EXIT_SUCCESS;
}
