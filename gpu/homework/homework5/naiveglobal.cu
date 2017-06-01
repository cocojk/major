#include <stdio.h>
#include "common.h"


// matrix multiplcation kernel function 
// we assume that input matrix is always square
// parameter : int* A (input matrix)
//             int* B (input matrix)
//             int* C (output matrix, C= AB)
//             int  nx (size of the matrix size)
__global__ void matrixMul (double *A, double *B, double *C, int nx)
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



int main (int argc, char **argv)
{

    double* A;
    double* B;
    double* C;


    int nx = 1024;
    int ny = 1024;
    int dimx = 32;
    int dimy = 32;
    int size = nx * ny;
    const int BufferSize = size * sizeof(double);

    dim3 block(dimx,dimy);
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




