#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void VectorAdd (int* a, int* b, int* c)
{
int tid = blockIdx.x * blockDim.x + threadIdx.x;
printf("blockIdx : %d, blockDim : %d\n",blockIdx.x,blockDim.x);
c[tid] = a[tid] + b[tid];
}

int main () 
{
const int size = 512*65535;
const int BufferSize = size*sizeof(int);

int* A;
int* B;
int* Sum;

A = (int*)malloc(BufferSize);
B = (int*)malloc(BufferSize);
Sum = (int*)malloc(BufferSize);

int i = 0;

for (int i = 0; i < size; i++)
{
A[i] = i;
B[i] = i;
Sum[i] = 0;
}

int* d_A;
int* d_B;
int* d_Sum;

cudaMalloc((void**)&d_A,size*sizeof(int));
cudaMalloc((void**)&d_B,size*sizeof(int));
cudaMalloc((void**)&d_Sum,size*sizeof(int));

cudaMemcpy(d_A,A,size*sizeof(int),cudaMemcpyHostToDevice);
cudaMemcpy(d_B,B,size*sizeof(int),cudaMemcpyHostToDevice);

VectorAdd<<<65535,512>>> (d_A,d_B,d_Sum);

cudaMemcpy (Sum,d_Sum,size*sizeof(int),cudaMemcpyDeviceToHost);

for (i = 0; i < 5; i++) {
printf("Result[%d] : %d\n",i,Sum[i]);}


for (i = size-5; i < size; i++) {
printf("Result[%d] : %d\n",i,Sum[i]);}


cudaFree(d_A);
cudaFree(d_B);
cudaFree(d_Sum);

free(A);
free(B);
free(Sum);

return 0;
}

