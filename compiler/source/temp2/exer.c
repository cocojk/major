#include <stdio.h>
#include <string.h>

int main(void)
{
union {int num;char* temp2;}attr;

char temp[50];
char * input2 ="hello";
sprintf(temp,"%s%s%s","[",input2,"]");
attr.temp2=temp;
printf("%s\n",temp);
printf("%s\n",attr.temp2);
return 0;
}

