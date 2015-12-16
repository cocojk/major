/****************************************************/
/* File: symtab.c                                   */
/* Symbol table implementation for the TINY compiler*/
/* (allows only one symbol table)                   */
/* Symbol table is implemented as a chained         */
/* hash table                                       */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

/* SIZE is the size of the hash table */
#define SIZE 211
#define NESTEDSIZE 50

/* SHIFT is the power of two used as multiplier
   in hash function  */
#define SHIFT 4
int scopeDepth=0;
int debug=0;
/* the hash function */
static int hash ( char * key )
{ 
	if(debug) printf("in hash function start\n");
	int temp = 0;
	int i = 0;
	while (key[i] != '\0')
	{ temp = ((temp << SHIFT) + key[i]) % SIZE;
		++i;
	}

	if(debug) printf("%s hash value : %d\n",key,temp);
	return temp;
}

/* the list of line numbers of the source 
 * code in which a variable is referenced
 */

/* The record in the bucket lists for
 * each variable, including name, 
 * assigned memory location, and
 * the list of line numbers in which
 * it appears in the source code
 */

/* the hash table */
static BucketList hashTable[SIZE][NESTEDSIZE];

/* Procedure st_insert inserts line numbers and
 * memory locations into the symbol table
 * loc = memory location is inserted only the
 * first time, otherwise ignored
 */
void clear()
{
int i=0;
int j=0;
for(i=0;i<SIZE;i++)
{

for(j=0;j<NESTEDSIZE;j++)
{
hashTable[i][j]=NULL;


}

}

scopeDepth=0;
}

void insertSymbol( char * name, TreeNode* declaration,int lineno)
{
	//if(debug) printf("before hashfunction %s\n",name);
	int h = hash(name);
	BucketList l =  hashTable[h][scopeDepth];
	if(debug) printf("insert in hashtable[%d][%d]\n",h,scopeDepth);

	while ((l != NULL) && (strcmp(name,l->name) != 0))
	{
		if(debug) printf("next exist\n");
		l = l->next;
	}


	if (l == NULL) /* variable not yet in table */
	{ 
		if(debug) printf("no variable yet in table\n");
		l = (BucketList) malloc(sizeof(struct BucketListRec));
		l->name = name;
		l->lineno = lineno;
		l->declaration=declaration;
		l->next = hashTable[h][scopeDepth];
		hashTable[h][scopeDepth] = l;
		if(debug) printf("insert in table name : %s \n",name);
	}
	else /* found in table, so just add line number */
	{ 
		printf("alreay in symboltable\n");
	}
} /* st_insert */

/* Function st_lookup returns the memory 
 * location of a variable or -1 if not found
 */

void insertSymbol2( char * name, TreeNode* declaration,int lineno,int disting,int offset,int frame)
{
	//if(debug) printf("before hashfunction %s\n",name);
	int h = hash(name);
	BucketList l =  hashTable[h][scopeDepth];
	if(debug) printf("insert in hashtable[%d][%d]\n",h,scopeDepth);

	while ((l != NULL) && (strcmp(name,l->name) != 0))
	{
		if(debug) printf("next exist\n");
		l = l->next;
	}


	if (l == NULL) /* variable not yet in table */
	{ 
		if(debug) printf("no variable yet in table\n");
		l = (BucketList) malloc(sizeof(struct BucketListRec));
		l->name = name;
		l->lineno = lineno;
		l->disting = disting;
		l->offset = offset;
		l->frame =frame;
		l->declaration=declaration;
		l->next = hashTable[h][scopeDepth];
		l->calllocation =-1;
		hashTable[h][scopeDepth] = l;
		if(debug) printf("insert in table name : %s \n",name);
	}
	else /* found in table, so just add line number */
	{ 
	//	printf("alreay in symboltable\n");
	}
} /* st_insert */


BucketList lookupSymbol ( char * name )
{
        if(debug) printf("lookupsymbol %s",name);
	int h = hash(name);
	int temp = scopeDepth;
	int check=0;
	while(temp>=0)
	{

		if(debug) printf("hashTable[%d][%d] \n",h,temp);
		BucketList l =  hashTable[h][temp];


		while(l!=NULL)
		{
			if(debug) printf("look %s current %s \n",name,l->name);
			if(strcmp(name,l->name)==0)
			{
				check=1;
				break;

			}

			l=l->next;
		}

		if (check ==1)
			return l;

		temp--;
	}

	return NULL;
}

BucketList lookupSymbol2 ( char * name,int frame )
{
        if(debug) printf("lookupsymbol %s",name);
	int h = hash(name);
	int temp = scopeDepth;
	int check=0;
	while(temp>=0)
	{

		if(debug) printf("hashTable[%d][%d] \n",h,temp);
		BucketList l =  hashTable[h][temp];


		while(l!=NULL)
		{
			if(debug) printf("look %s current %s \n",name,l->name);
			if(strcmp(name,l->name)==0)
			{
			  if((frame ==l->frame)||(l->frame==0))
				check=1;
				break;

			}

			l=l->next;
		}

		if (check ==1)
			return l;

		temp--;
	}

	return NULL;
}
/* Procedure printSymTab prints a formatted 
 * listing of the symbol table contents 
 * to the listing file
 */
void deletescope()
{

	int i=0;
	for(i=0;i<SIZE;i++)
	{
		hashTable[i][scopeDepth]=NULL;
	}


}


void printSymTab(int depth,TreeNode* infunction)
{
	int i=0;
	BucketList temp;

	if((depth==1)||(depth==2))
	{
   if(depth==2)
   {
   printf("\n\n");
  printf("<Function parameters and local variables>\n");
			printf("function name : %s (nested level :1)\n",infunction->name);
		printf("ID name    ID type    data type \n");
	
	}
	
	}
	else if(depth==0)
	{
printf("\n\n");
		printf("<Functions and global variables>\n  ");
		printf("ID name    ID type    data type \n");
	} 
	else
	{
	printf("\n\n");
		printf("function name : %s (nested level :%d)\n",infunction->name,depth-1);
		printf("ID name    ID type    data type \n");
	}

	for(i=0;i<SIZE;i++)
	{
		temp = hashTable[i][depth];

		if(temp!=NULL)
		{


			if(temp->declaration->nodekind==DeclarK)
			{
				switch (temp->declaration->kind.declar)
				{

					case VarK:
						switch(temp->declaration->type)
						{

							case Void:
								printf("%s    variable   void\n",temp->declaration->name);
								break;

							case Integer:
								printf("%s    variable  Integer\n",temp->declaration->name);
								break;

							default :
								printf("Unkown type-specifier\n");
								break;

						}
						break;

					case VararrayK:
						switch(temp->declaration->type)
						{

							case Void:
								printf("%s    variable   voidarray\n",temp->declaration->name);
								break;

							case Integer:
								printf("%s    variable  Integerarray\n",temp->declaration->name);
								break;

							default :
								printf("Unkown type-specifier\n");
								break;

						}
						break;

					case FunK:
						switch(temp->declaration->type)
						{
							case Void:
								printf("%s    Function   void\n",temp->declaration->name);
								break;

							case Integer:
								printf("%s    Function  Integer\n",temp->declaration->name);
								break;

							default :
								printf("Unkown type-specifier\n");
								break;

						}
						break;

					default :
						fprintf(listing,"unknown expnode kind\n");
						break;

				}
			}
			else if (temp->declaration->nodekind==ParamK)
			{
				switch(temp->declaration->kind.param)
				{
					case Param:
						switch(temp->declaration->type)
						{

							case Void:
								printf("%s    variable   void\n",temp->declaration->name);
								break;

							case Integer:
								printf("%s    variable  Integer\n",temp->declaration->name);
								break;

							default :
								printf("Unkown type-specifier\n");
								break;

						}
						break;

					case ParamarrayK:
						switch(temp->declaration->type)
						{

							case Void:
								printf("%s    variable   voidarray\n",temp->declaration->name);
								break;

							case Integer:
								printf("%s    variable  Integerarray\n",temp->declaration->name);
								break;

							default :
								printf("Unkown type-specifier\n");
								break;
						}
						break;

					default:
						fprintf(listing,"Unknown ExpNode kind\n");
						break;
				}

			}
		}
	}

}
