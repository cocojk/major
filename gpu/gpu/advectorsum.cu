#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>
#include <sys/time.h>


void CHECK (cudaError_t error)
{                     

    if (error != cudaSuccess)
    {
        printf("Error : %s : %d, ",__FILE__,__LINE__);
        printf("code : %d, reason : %s\n",error,cudaGetErrorString(error));
        exit(1);
    }
}
__global__ void VectorAdd (int* a, int* b, int* c,int nx)
{
    unsigned int ix = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int iy = blockIdx.y * blockDim.y + threadIdx.y;
    unsigned int idx = iy*nx + ix;
    c[idx] = a[idx] + b[idx];
}


double cpuSecond () {
    struct timeval tp;
    gettimeofday(&tp,NULL);
    return ((double)tp.tv_sec + (double)tp.tv_usec*1.e-6);
}


int main (int argc, char** argv) 
{
  //  double iStart = cpuSecond();

    const int nx = 8192;
    const int ny = 8192;
    int blockX =32;
    int blockY =32;
/*
    if (argc > 2 ) {
        blockX = atoi(argv[1]);
        blockY = atoi(argv[2]);
    }
    else 
    {
        exit(0);
    }
*/
    dim3 block (blockX,blockY);
    dim3 grid ( (nx + block.x -1)/block.x , (ny + block.y -1)/block.y);



    const int BufferSize = nx*ny*sizeof(int);

    int* A;
    int* B;
    int* Sum;

    A = (int*)malloc(BufferSize);
    B = (int*)malloc(BufferSize);
    Sum = (int*)malloc(BufferSize);

    int i = 0;

    for (int i = 0; i < (nx*ny); i++)
    {
        A[i] = i;
        B[i] = i;
        Sum[i] = 0;
    }

    int* d_A;
    int* d_B;
    int* d_Sum;

    CHECK(cudaMalloc((void**)&d_A,BufferSize));
    CHECK(cudaMalloc((void**)&d_B,BufferSize));
    CHECK(cudaMalloc((void**)&d_Sum,BufferSize));

    CHECK(cudaMemcpy(d_A,A,BufferSize,cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(d_B,B,BufferSize,cudaMemcpyHostToDevice));

    VectorAdd<<<grid,block>>> (d_A,d_B,d_Sum,nx);


    CHECK(cudaMemcpy (Sum,d_Sum,BufferSize,cudaMemcpyDeviceToHost));

    for (i = 0; i < 5; i++) {
        printf("Result[%d] : %d\n",i,Sum[i]);}


    for (i = nx*ny-5; i < (nx*ny); i++) {
        printf("Result[%d] : %d\n",i,Sum[i]);}

    cudaDeviceSynchronize();

    CHECK(cudaFree(d_A));
    CHECK(cudaFree(d_B));
    CHECK(cudaFree(d_Sum));

    free(A);
    free(B);
    free(Sum);

//    double iElaps = cpuSecond() - iStart;

//    printf("cpu time : %lf\n",iElaps);
    return 0;
}

