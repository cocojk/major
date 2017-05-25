#include <stdio.h>
#include "common.h"

#define BLOCK_SIZE 32

// matrix multiplcation kernel function 
// we assume that input matrix is always square
// parameter : int* A (input matrix)
//             int* B (input matrix)
//             int* C (output matrix, C= AB)
//             int  nx (size of the matrix size)
__global__ void matrixMul (int* A, int* B, int* C, int size)
{

    // shared memory area , we assign the same size of current block size 
    __shared__ int subA [BLOCK_SIZE][BLOCK_SIZE];
    __shared__ int subB [BLOCK_SIZE][BLOCK_SIZE];

    
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    
    
    // get the current matrix index to be calculated
    int idx = blockIdx.x*BLOCK_SIZE + tx;
    int idy = blockIdx.y*BLOCK_SIZE + ty;
    int currentVal = 0;

    // we calculate the matrix by partitioning the problem into smaller problem. each time we perform the subMatrix multiplication one by one. 
    // the size of smaller problem is BLOCK_SIZE 
    for (int i = 0; i < (size + BLOCK_SIZE -1) /BLOCK_SIZE ; i++)
    {
        
        // each thread in a block load the data from global memory to the shared memory corresponding their matrix index 
        if ( idx < size && idy < size)
        {
            subA[ty][tx] = A[idy*size + i*BLOCK_SIZE + tx];
            subB[ty][tx] = B[(i*BLOCK_SIZE+ty)*size + idx];
        }
        else
        {
            subA[ty][tx] = 0;
            subB[ty][tx] = 0;
        }

        // wait all of the thread in the block to ensure correct program answer.
        __syncthreads();

        // calculate subMatrix multiplication 
        for (int j = 0; j < BLOCK_SIZE; j++)
            currentVal += subA[ty][j] * subB[j][tx];

        // wait all of the thread in the block to ensure correct program answer.
        __syncthreads();
    }

    // finally update the corresponding value to the proper location
    if (idx < size && idx < size)
        C[idy*size + idx] = currentVal;
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
        for (int row = 0; row < size; row++)
        {
            int outidx = col*size  + row;
            for (int idx = 0; idx < size; idx++) 
            {
                hostCheck[outidx] += A[col*size + idx]*B[idx*size + row];
            }
        }


    // compare the answer
    for (int col = 0; col < size; col++)
        for (int row = 0; row < size; row++)
        {
            if (hostCheck[col*size + row] != C[col*size + row])
                return 0;
        }

    return 1;
}

int main (int argc, char ** argv) {

    int *A;
    int *B;
    int *C;
    int *hostCheck;


    int nx = 512;
    int ny = 512;
    int size = nx * ny;
    const int BufferSize = size * sizeof(int);

    dim3 block(BLOCK_SIZE,BLOCK_SIZE);
    dim3 grid ( (nx + block.x -1)/block.x, (ny + block.y -1)/block.y);

    // allocate unified memory 
    // return cudaError_t 
    // parameter : T** devPtr, size_t size, unsigned int flags 
    // allocate memory that will be automatically managed by the unified memory system
    CHECK(cudaMallocManaged((void**)&A,BufferSize));
    CHECK(cudaMallocManaged((void**)&B,BufferSize));
    CHECK(cudaMallocManaged((void**)&C,BufferSize));
    CHECK(cudaMallocManaged((void**)&hostCheck,BufferSize));


    // init the value
    for (int i = 0; i < size; i++)
    {
        A[i] = i % 1000;
        B[i] = i % 1000;
        C[i] = 0;
        hostCheck[i] = 0;
    }


    // kernel function : run the matrixmultiplication
    matrixMul<<<grid,block>>> (A,B,C,nx);


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
    CHECK(cudaFree(A));
    CHECK(cudaFree(B));
    CHECK(cudaFree(C));
    CHECK(cudaFree(hostCheck));
    
    // reset device
    // return : cudaError_t 
    // parameter : void 
    // explicitly destoys and cleans up all resources associated with the current device in the current process 
    CHECK(cudaDeviceReset());

    return 0;
}








