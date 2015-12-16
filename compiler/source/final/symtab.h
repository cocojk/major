/****************************************************/
/* File: symtab.h                                   */
/* Symbol table interface for the TINY compiler     */
/* (allows only one symbol table)                   */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#ifndef _SYMTAB_H_
#define _SYMTAB_H_
#include "globals.h"
/* Procedure st_insert inserts line numbers and
 * memory locations into the symbol table
 * loc = memory location is inserted only the
 * first time, otherwise ignored
 */
extern int scopeDepth;
void insertSymbol( char * name, TreeNode* declaration, int lineno );
void insertSymbol2( char * name,TreeNode* declaration,int lineno, int disting,int offset,int frame); 
void clear(void);
typedef struct BucketListRec
   { char * name;
      int lineno;
      TreeNode * declaration;
     struct BucketListRec * next;
     int disting; //0:global 1:local
     int offset; //global -> offset from gp, local -> offset from fp
     int frame;
     int calllocation;
} * BucketList;
/* Function st_lookup returns the memory 
 * location of a variable or -1 if not found
 */
 BucketList lookupSymbol( char * name );
 BucketList lookupSymbol2(char*name,int frame);
void deletescope(void);
/* Procedure printSymTab prints a formatted 
 * listing of the symbol table contents 
 * to the listing file
 */
void printSymTab(int scope,TreeNode* input);

#endif
