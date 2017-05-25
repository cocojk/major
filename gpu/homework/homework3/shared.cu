#include <stdio.h>
#include "common.h"

#define BLOCK_SIZE 1

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
    CHECK(cudaMemset(d_C,0,sizeof(int)*size));

    // copy data from host to device
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(d_A,A,BufferSize,cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(d_B,B,BufferSize,cudaMemcpyHostToDevice));


    // kernel function : run the matrixmultiplication
    matrixMul<<<grid,block>>> (d_A,d_B,d_C,nx);

    CHECK(cudaMemcpy (C,d_C,BufferSize,cudaMemcpyDeviceToHost));


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








