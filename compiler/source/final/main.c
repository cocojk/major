/****************************************************/
/* File: main.c                                     */
/* Main program for TINY compiler                   */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"

/* set NO_PARSE to TRUE to get a scanner-only compiler */
#define NO_PARSE FALSE
/* set NO_ANALYZE to TRUE to get a parser-only compiler */
#define NO_ANALYZE FALSE

/* set NO_CODE to TRUE to get a compiler that does not
 * generate code
 */
#define NO_CODE FALSE

#include "util.h"
//#if NO_PARSE
//#include "scan.h"
//#else
#include "parse.h"

/* allocate global variables */
int lineno = 0;
FILE * source;
FILE * listing;
FILE * code;

/* allocate and set tracing flags */
int EchoSource = FALSE;
int TraceScan = FALSE;
int TraceParse = FALSE;
int TraceAnalyze = TRUE;
int TraceCode = TRUE;

int Error = FALSE;

main( int argc, char * argv[] )
{ TreeNode * syntaxTree;
	char pgm[120]; /* source code file name */
	if (argc != 2)
	{ fprintf(stderr,"usage: %s <filename>\n",argv[0]);
		exit(1);
	}
	strcpy(pgm,argv[1]) ;
	if (strchr (pgm, '.') == NULL)
		strcat(pgm,".tny");
	source = fopen(pgm,"r");
	if (source==NULL)
	{ fprintf(stderr,"File %s not found\n",pgm);
		exit(1);
	}
	listing = stdout; /* send listing to screen */
	fprintf(listing,"\nTINY COMPILATION: %s\n",pgm);

	// while (getToken()!=ENDFILE);
	syntaxTree = parse();
	if (TraceParse) {
		fprintf(listing,"\nSyntax tree:\n");
		printTree(syntaxTree);
	}   

	if(TraceAnalyze)
	{
		fprintf(listing,"Building symbol table\n");
		buildSymtab(syntaxTree);
		printf("type checking .....\n");
		typeCheck(syntaxTree);
		printf("type checking finished\n");

	}


    char * codefile;
    int fnlen = strcspn(pgm,".");
    codefile = (char *) calloc(fnlen+4, sizeof(char));
    strncpy(codefile,pgm,fnlen);
    strcat(codefile,".tm");
    printf("codefile name : %s\n",codefile);
   code = fopen(codefile,"w");
    if (code == NULL)
    { printf("Unable to open %s\n",codefile);
      exit(1);
    }
    codeGen(syntaxTree,codefile);
    fclose(code);
    fclose(source);
	return 0;
}

