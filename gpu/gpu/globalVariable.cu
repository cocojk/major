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

    // return : cudaError_t 
    // parameter : const char* symbol, const void* src, size_t count, size_t offset = 0, enum cudaMemcpyKind kind = cudaMemcpyHostToDevice 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (offset) bytes from the start of symbol (symbol) 
    CHECK(cudaMemcpyToSymbol(devData, &value, sizeof(float)));
    printf("Host:   copied %f to the global variable\n", value);

    // invoke the kernel
    checkGlobalVariable<<<1, 1>>>();

    // copy the global variable back to the host
    // return : cudaError_t 
    // parameter : void* dst, const char* symbol, size_t count, size_t offset = 0, enum cudaMemcpyKind kind = cudaMemcpyDeviceToHost 
    // copies (count) bytes from the memory area pointed by (offset) bytes from the start of symbol (symbol) to the memory area pointed to by (dat)
    CHECK(cudaMemcpyFromSymbol(&value, devData, sizeof(float)));
    printf("Host:   the value changed by the kernel to %f\n", value);

    

    // reset device
    // return : cudaError_t 
    // parameter : void 
    // explicitly destroys and cleans up all resources associated with the current device in the current process 
    CHECK(cudaDeviceReset());
    return EXIT_SUCCESS;
}
