#include <stdio.h>
/* A program for the hardest operations! */

int add(int x, int y)
{
 printf("add %d\n",(x+y));
	return (x + y);
}

int sub(int x, int y)
{
printf("sub %d\n",(x-y));
	return (x - y);
}

int mul(int x, int y)
{
printf("mul %d\n",(x*y));
	return (x * y);
}

int div(int x, int y)
{
printf("div %d\n",x);
printf("div %d\n",y);
printf("div %d\n",x/y);
	return (x / y);
}

int isEqual(int x, int y)
{
	if(x == y)	return 1;
	else		return 0;
}

int hardOperation(int a, int b, int c, int d, int e, int f, int g, int h, int i)
{
	int resultA;	int resultB;
	resultA = (a + (b - c) + ((e * f / g) * h)) - i;
	printf("resulta %d\n",resultA);
	resultB = sub(add(add(a, sub(b, c)), mul(div(mul(e, f), g), h)), i);
	printf("resultb %d\n",resultB);

	if(isEqual(resultA, resultB))
		return 1;
	else
		return 0;
}

int main()
{
printf("%d\n",hardOperation(10,3,2,5,2,4,5,2,3));



}

