#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <cusparse_v2.h>
#include <cuda.h>

/*
 * This is an example demonstrating usage of the cuSPARSE library to perform a
 * sparse matrix-vector multiplication on randomly generated data.
 */

/*
 * M = # of rows
 * N = # of columns
 */
int M = 1024;
int N = 1024;

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

int main(int argc, char **argv)
{
    double *A, *dA;
    double *B, *dB;
    double *C, *dC;
    int *dANnzPerRow;
    int totalANnz;
    double alpha = 1.0;
    double beta = 4.0;
    cusparseHandle_t handle = 0;
    cusparseHybMat_t hybA;
    cusparseMatDescr_t Adescr = 0;

    // Generate input
    srand(9384);
    int trueANnz = generate_random_dense_matrix(M, N, &A);
    int trueBNnz = generate_random_dense_matrix(N, M, &B);
    C = (double *)malloc(sizeof(double) * M * M);

    printf("A:\n");
    print_partial_matrix(A, M, N, 10, 10);
    printf("B:\n");
    print_partial_matrix(B, N, M, 10, 10);

    // Create the cuSPARSE handle
    // return : cusparseStatus_t 
    // parameter : cusparseHandle_t * handle 
    // initialize the cuSPARSE library and creates a handle on the cuSPARSE context. it allocates hardware resources necessary for accessing the GPU
    CHECK_CUSPARSE(cusparseCreate(&handle));

    // Allocate device memory for vectors and the dense form of the matrix A
    // return : cudaError_t 
    // parameter : void** devPtr, size_t size 
    // allocates (size) bytes of lineare memory on the device and returns in (*devPtr) a pointer to the allocated memory 
    CHECK(cudaMalloc((void **)&dA, sizeof(double) * M * N));
    CHECK(cudaMalloc((void **)&dB, sizeof(double) * N * M));
    CHECK(cudaMalloc((void **)&dC, sizeof(double) * M * M));
    CHECK(cudaMalloc((void **)&dANnzPerRow, sizeof(int) * M));

    // Construct a descriptor of the matrix A
    // return : cusparseStatus_t
    // parameter : cudsparseMatDescr_t * descrA
    // the function initialize the matrix descriptor. 
    // It sets the fields MatrixType and IndexBase to the default values CUSPARSE_MATRIX_TYPE_GENERAL and CUSPARSE_INDEX_BASE_ZERO 
    CHECK_CUSPARSE(cusparseCreateMatDescr(&Adescr));
   
    // create and initialize the hybA opaque data structure
    // return : cusparseStatus_t 
    // parameter : cusparseHybMat_t * hybA 
    CHECK_CUSPARSE(cusparseCreateHybMat(&hybA));

    // set the MatrixType field of the matrix descriptor descrA 
    // return : cusparseStatus_t 
    // parameter : cusparseMatDescr_t descrA, cusparseMatrixType_t type 
    CHECK_CUSPARSE(cusparseSetMatType(Adescr, CUSPARSE_MATRIX_TYPE_GENERAL));
    
    // set the IndexBase field of the matrix descriptor descrA 
    // return : cusparseStatus_t 
    // parameter : cusparseMatDescr_t descrA , cusparseIndexBase_t base 
    CHECK_CUSPARSE(cusparseSetMatIndexBase(Adescr, CUSPARSE_INDEX_BASE_ZERO));

    // Transfer the input vectors and dense matrix A to the device
    // return : cudaError_t 
    // parameter : void* dst, const void* src, size_t count, enum cudaMemcpyKind kind 
    // copies (count) bytes from the memory area pointed by (src) to the memory area pointed to by (dst), where (kind) is one of enum type
    CHECK(cudaMemcpy(dA, A, sizeof(double) * M * N, cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(dB, B, sizeof(double) * N * M, cudaMemcpyHostToDevice));
    CHECK(cudaMemset((void*)dC, 0, sizeof(double) * M * M));

    // Compute the number of non-zero elements in A and compute the number of non-zero elements in A per row 
    // return : cusparseStatus_t 
    // parameter : cusparseHandle_t handle , cusparseDirection_t dirA, int m, int n, const cusparseMatDescr_t descrA, const double *A, int lda, int* nnzPerRowColumn, int* nnzTotalDevHostPtr 
    // input : handle - handle to the cuSPARSE library context 
    //         dirA   - direction that specifies whether to count nonzero elements by CUSPARSE_DIRECTION_ROW or by CUSPARSE_DIRECTION_COLUMN
    //         m      - number of rows of matrix A 
    //         n      - number of columns of matrix A
    //         descrA - the descriptor of matrix A 
    //         A      - array of dimensions (lda,n)
    //         lda    - leading dimension of dense array A 
    // output: nnzPerRowColumn - array of size m 
    CHECK_CUSPARSE(cusparseDnnz(handle, CUSPARSE_DIRECTION_ROW, M, N, Adescr,
                                dA, M, dANnzPerRow, &totalANnz));

    if (totalANnz != trueANnz)
    {
        fprintf(stderr, "Difference detected between cuSPARSE NNZ and true "
                "value: expected %d but got %d\n", trueANnz, totalANnz);
        return 1;
    }

    // convert matrix A in dense format into a sparse matrix in HYB format. 
    // return : cusparseStatus_t 
    // parameter : cusparseHandle_t handle, int m, int n, const cusparseMatDescr_t descrA, const double *A, int lda, const int *nnzperRow, cusparseHybMat_t hybA, int userEllWidth, cusparseHybPartition_t partitionType 
    CHECK_CUSPARSE(cusparseDdense2hyb(handle,M,N,Adescr,dA,M,dANnzPerRow,hybA,0,CUSPARSE_HYB_PARTITION_AUTO));



    
    // Perform matrix-vector multiplication with the hyb-formatted matrix A
    // there is no direct way to calculate hyb matrix multiplication so, we use serveral matrix-vector multiplication to get a result. 
    for (int i = 0; i < M ; i++)
    {
        // perform the matrix-vector operation 
        // return : cusparseStatus_t 
        // parameter : cusparseHandle_t handle, cusparseOperation_t transA, const double * alpha, const cusparseMatDescr_t descrA, const cusparseHybMat_t hybA, const double *x, const double *beta, double *y 
        CHECK_CUSPARSE(cusparseDhybmv(handle,CUSPARSE_OPERATION_NON_TRANSPOSE,&alpha,Adescr,hybA,&dB[i*N],&beta,&dC[i*M]));
    }
    
    // Copy the result vector back to the host
    CHECK(cudaMemcpy(C, dC, sizeof(double) * M * M, cudaMemcpyDeviceToHost));

    // print the result partial matrix
    printf("C:\n");
    print_partial_matrix(C, M, M,10,10);

    // free the memory 
    free(A);
    free(B);
    free(C);

    CHECK(cudaFree(dA));
    CHECK(cudaFree(dB));
    CHECK(cudaFree(dC));
    CHECK(cudaFree(dANnzPerRow));

    // destroys and releases any memory required by the hybA structure.
    // return : cusparseStatus_t 
    // parameter : cusparseHybMat_t hybA
    CHECK_CUSPARSE(cusparseDestroyHybMat(hybA));

    // releases the memory allocated for the matrix descriptor
    // return : cusparseStatus_t 
    // parameter : cusparseDescr_t descrA 
    CHECK_CUSPARSE(cusparseDestroyMatDescr(Adescr));
    
    // releases CPU-side resources used by the cuSPARSE library. 
    // return : cusparseStatus_t 
    // parameter : cusparseHandle_t handle
    CHECK_CUSPARSE(cusparseDestroy(handle));

    return 0;
}
