#include <stdio.h>
#include "common.h"


// matrix multiplcation kernel function 
// we assume that input matrix is always square
// parameter : int* A (input matrix)
//             int* B (input matrix)
//             int* C (output matrix, C= AB)
//             int  nx (size of the matrix size)
__global__ void matrixMul (int *A, int *B, int *C, int nx)
{
    unsigned int ix = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int iy = blockIdx.y * blockDim.y + threadIdx.y;

    // get the current index in matrix C
    unsigned int destIdx = iy * nx + ix;

    if (ix < nx && iy < nx)
    {
        for (int idx = 0; idx < nx; idx++)
        {
            C[destIdx] += A[iy*nx + idx]*B[idx*nx + ix];
            
        }
    }
    
}
   

// host program to check the answer 
// we assume that input matrix is always square
// parameter : int* A (input matrix)
//             int* B (input matrix)
//             int* C (output matrix, C= AB)
//             int  nx (size of the matrix size)
// return : int (1 : correct 0: not correct)
int check (int* A, int* B, int* C, int * hostCheck,int size)
{
    
    // calculate the answer
    for (int col = 0; col < size; col++)
    {
        for (int row = 0; row < size; row++)
        {
            int outidx = col*size  + row;
            for (int idx = 0; idx < size; idx++) 
            {
                hostCheck[outidx] += A[col*size + idx]*B[idx*size + row];
            }
        }
    }


    // compare the answer
    for (int col = 0; col < size; col++)
        for (int row = 0; row < size; row++)
        {
            if (hostCheck[col*size + row] != C[col*size + row])
            {
                printf("[%d , %d] host : %d, device : %d\n",col,row,hostCheck[col*size + row],C[col*size + row]);
                return 0;
            }
        }

    return 1;
}


int main (int argc, char **argv)
{

    int* A;
    int* B;
    int* C;
    int* hostCheck;


    int nx = 512;
    int ny = 512;
    int dimx = 32;
    int dimy = 32;
    int size = nx * ny;
    const int BufferSize = size * sizeof(int);

    dim3 block(dimx,dimy);
    dim3 grid ( (nx + block.x -1)/block.x, (ny + block.y -1)/block.y);

    printf("grid [%d %d], block [%d %d] \n",grid.x,grid.y,block.x,block.y);
    A = (int*)malloc(BufferSize);
    B = (int*)malloc(BufferSize);
    C = (int*)malloc(BufferSize);
    hostCheck = (int*)malloc(BufferSize);

    // init the value 
    for (int i = 0; i < size; i++)
    {
        A[i] = i % 1000;
        B[i] = i % 1000;
        C[i] = 0;
        hostCheck[i] = 0;
    }

    int* d_A;
    int* d_B;
    int* d_C;


    // allocate the device memory
    // return : cudaError_t 
    // parameter : void** devPtr, size_t size 
    // allocates (size) bytes of lineare memory on the device and returns in (*devPtr) a pointer to the allocated memory 
    CHECK(cudaMalloc((void**)&d_A,BufferSize));
    CHECK(cudaMalloc((void**)&d_B,BufferSize));
    CHECK(cudaMalloc((void**)&d_C,BufferSize));
    
    // fills the first (count) bytes of the memory area pointed to by (devPtr) with the constant byte value (value) 
    // return : cudaError_t 
    // parameter : void* devPtr, int value, size_t count 
    CHECK(cudaMemset(d_C,0,BufferSize));

    // copy data from host to device
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(d_A,A,BufferSize,cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(d_B,B,BufferSize,cudaMemcpyHostToDevice));
   
   
    // kernel function : run the matrixmultiplication
    matrixMul<<<grid,block>>> (d_A,d_B,d_C,nx);

    CHECK(cudaMemcpy (C,d_C,BufferSize,cudaMemcpyDeviceToHost));
    
       
    // return : cudaError_t 
    // parameter : void 
    // blocks until the device has completed all preceding requsted tasks.
    CHECK(cudaDeviceSynchronize());
   
    // check the answer 
    if(!check(A,B,C,hostCheck,nx))
    {
        printf("not correct answer\n");
        exit(1);
    }
    else 
    {
        printf("correct answer\n");
    }

    // free host and device memory
    // return : cudaError_t 
    // parameter : void* devPtr 
    // free the memory space pointed to by devPtr 
    CHECK(cudaFree(d_A));
    CHECK(cudaFree(d_B));
    CHECK(cudaFree(d_C));
    
    free(A);
    free(B);
    free(C);
    free(hostCheck);
    
    // reset device
    // return : cudaError_t 
    // parameter : void 
    // explicitly destoys and cleans up all resources associated with the current device in the current process 
    CHECK(cudaDeviceReset());

    return 0;
}




