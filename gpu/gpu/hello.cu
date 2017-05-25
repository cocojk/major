#include <stdio.h>

__global__ void funct(void) {
printf("Hello from GPU!\n");
}


int main (void) {



funct<<<1,4>>>();


printf("Hello, World from CPU!\n");

cudaDeviceSynchronize();
	


return 0;
}

