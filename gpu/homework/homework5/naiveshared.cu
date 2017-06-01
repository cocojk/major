#include <stdio.h>
#include "common.h"

#define BLOCK_SIZE 32

// matrix multiplcation kernel function 
// we assume that input matrix is always square
// parameter : double* A (input matrix)
//             double* B (input matrix)
//             double* C (output matrix, C= AB)
//             int  nx (size of the matrix row & column)
__global__ void matrixMul (double* A, double* B, double* C, int size)
{

    // shared memory area , we assign the same size of current block size 
    __shared__ double subA [BLOCK_SIZE][BLOCK_SIZE];
    __shared__ double subB [BLOCK_SIZE][BLOCK_SIZE];


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

/*
 * Generate random dense matrix A in column-major order, while rounding some
 * elements down to zero to ensure it is sparse.
 */
int generate_random_dense_matrix(int M, int N, double **outA)
{
    int i, j;
    double rMax = (double)RAND_MAX;
    double *A = (double *)malloc(sizeof(double) * M * N);
    int totalNnz = 0;

    for (j = 0; j < N; j++)
    {
        for (i = 0; i < M; i++)
        {
            int r = rand();
            double *curr = A + (j * M + i);

            if (r % 3 > 0)
            {
                *curr = 0.0;
            }
            else
            {
                double dr = (double)r;
                *curr = (dr / rMax) * 100.0;
            }

            if (*curr != 0.0)
            {
                totalNnz++;
            }
        }
    }

    *outA = A;
    return totalNnz;
}

// printf the partial matrix 
// return : void
// parameter : double * M - input matrix , int nrows - number of row in matrix, int ncols - number of column in matrix, int max_row - the max row to be printed, int max_col - the max col to be printed 
void print_partial_matrix(double *M, int nrows, int ncols, int max_row,
        int max_col)
{
    int row, col;

    for (row = 0; row < max_row; row++)
    {
        for (col = 0; col < max_col; col++)
        {
            printf("%2.2f ", M[row * ncols + col]);
        }
        printf("...\n");
    }
    printf("...\n");
}




int main (int argc, char ** argv) {

    double *A;
    double *B;
    double *C;


    int nx = 1024;
    int ny = 1024;
    int size = nx * ny;
    const int BufferSize = size * sizeof(double);

    dim3 block(BLOCK_SIZE,BLOCK_SIZE);
    dim3 grid ( (nx + block.x -1)/block.x, (ny + block.y -1)/block.y);

    // Generate input
    srand(9384);
    int trueANnz = generate_random_dense_matrix(nx, ny, &A);
    int trueBNnz = generate_random_dense_matrix(nx, ny, &B);


    C = (double*)malloc(BufferSize);



    double* d_A;
    double* d_B;
    double* d_C;

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

    // reset device
    // return : cudaError_t 
    // parameter : void 
    // explicitly destoys and cleans up all resources associated with the current device in the current process 
    CHECK(cudaDeviceReset());

    return 0;
}








