/****************************************************/
/* File: tiny.y                                     */
/* The TINY Yacc/Bison specification file           */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/
%{
#define YYPARSER /* distinguishes Yacc output from other code files */

#include "globals.h"
#include "util.h"
#include "scan.h"
#include "parse.h"
#include "string.h"
#include "stdio.h"

#define YYSTYPE TreeNode *
static char * savedName1; /* for use in assignments */
static char * savedName2;
static char * savedName3;
static char * savedName4;
static int savedLineNo;  /* ditto */
static TreeNode * savedTree; /* stores syntax tree for later return */
static int yylex(void); // added 11/2/11 to ensure no conflict with lex

%}

%token IF ELSE INT RETURN VOID WHILE
%token ID NUM 
%token PLUS MINUS TIMES OVER LESS LESSEQ GRATER GREATEREQ EQ NOTEQ ASSIGN SEMI COMMA LPAREN RPAREN SLBRACKET SRBACKET LBRACKET RBRACKET
%token ERROR 

%% /* Grammar for TINY */

program     : declaration_list
                 { savedTree = $1;} 
            ;
declaration_list    : declaration_list declaration
                 { YYSTYPE t = $1;
                   if (t != NULL)
                   { while (t->sibling != NULL)
                        t = t->sibling;
                     t->sibling = $3;
                     $$ = $1; }
                     else $$ = $3;
                 }
            | declaration  { $$ = $1; }
            ;
declaration        : var_declar { $$ = $1; }
            | fun_declar { $$ = $1; }
            | error  { $$ = NULL; }
            ;
var_declar     : type_specifier ID {savedName1 = copyString(tokenString); }
                 { $$ = newDeclarNode(VarK);
		   $$->attr.name = savedName1;
                   $$->child[0] = $1;
                 }
            | type_specifier ID {savedName1 = copyString(tokenString);} SLBRACKET{savedName2 = copyString(tokenString);} NUM {savedName3 =copyString(tokenString);}  SRBRACKET {savedName4 =copyString(tokenString);}
                 { $$ = newDeclarNode(VarK);
		   char * temp;
		   sprintf(temp,"%s%s%s%s",saveName1,saveName2,saveName3,saveName4);
		   $$->attr.name = temp;
                   $$->child[0] = $1;
                 
                 ;

type_specifier    : INT {$$ ==newTypeNode(TypeK)
                         $$->attr.type =INT} 
                   | VOID {$$ =newTypeNode(TypeK)
		            $$->attr.type=VOID}
		    ;

fun_declar        : type_specifier ID {savedName1 = copyString(tokenString);} LPAREN params RPAREN compound_stmt
                   { $$ = newDeclarNode(FunK);
		     $$->attr.name = savedName1;
		     $$->child[0] = $1;
		     $$->child[1] = $4;
		     $$->child[2] = $6;
		   }

params               : param_list { $$= $1;}
                     | VOID { $$ = newParamNode(ParamK); }

param_list           : param_list COMMA param
                    { YYSTYPE t = $1;
		      if(t!=NULL)
		      { while(t->sibling !=NULL)
		        t = t->sibling;
		      t->sibling = $3;
		      $$= $1;}
		      else $$ = $3;
		  | param { $$=$1;}

param               : type-specifier ID{savedName1 = copyString(tokenString);}
                      { $$ = newParamNode(ParamK);
		        $$->attr.name = savedName1;
			$$->child[0] = $1;
		      }
		      | type-specifier ID{savedName1 = copyString(tokenString);} SLBRACKET{savedName2 = copyString(tokenString);} SRBRACKET {savedName3 = copyString(tokenString);}
                       {
                         $$ = newParamNode(ParamK);
		   char * temp;
		   sprintf(temp,"%s%s%s",saveName1,saveName2,saveName3);
		   $$->attr.name=temp;
		   $$->child[0] = $1;
		       }


compound_stmt       : LBRACKET local_declar stmt_list RBRACKET
                      {
		       $$ = newStmtNode(CompK);
		       $$->child[0] = $2;
		       $$->child[1] = $3;
		      }

local_declar        : local_declar var_declar
                       { YYSTYPE t = $1;
		          if (t !=NULL)
			  {while (t->sibling!=NULL)
			        t = t->sibling;
		            t->sibling = $3;
			    $$ = $1;}
			   else $$ = $3;
                      | /* empty */

stmt_list          : stmt_list stmt 
                       { YYSTYPE t = $1;
		          if (t !=NULL)
			  {while (t->sibling!=NULL)
			        t = t->sibling;
		            t->sibling = $3;
			    $$ = $1;}
			    else $$ =$3;
                     | /* empty */

stmt               : expression_stmt
                       { $$ = $1;}
                     | comp_stmt
		       { $$ = $1;}
		     | if_stmt
		       { $$ = $1;}
		     | while_stmt
		       { $$= $1;}
		     | return_stmt
		       { $$ = $1;}


expression_stmt     : express SEMI 
                       {
		        $$ =newStmtNode(ExpressK);
			$$->child[0] = $1;
		       }
                     | SEMI
		       {
		        $$ = newStmtNode(ExpressK);
		       }
if_stmt            : IF LPAREN exp RPAREN stmt
                     {
                        $$=newStmtNode(IfK);
			$$->child[0]=$3;
			$$->child[1]=$5;
                      }
                   | IF LPAREN exp RPAREN stmt ELSE stmt
		     {
		       $$=newStmtNode(IfK);
		       $$->child[0]=$3;
		       $$->child[1]=$5;
		       $$->child[2]=$7;
		      }

while_stmt         : WHILE LPAREN exp RPAREN stmt
                      {
                         $$=newStmtNode(WhileK);
			 $$->child[0]=$3;
			 $$->child[1]=$5;
		      }

return_stmt       : RETURN SEMI
                    {
                     $$=newStmtNode(ReturnK);
		    }
                   | RETURN exp SEMI
		    {
                     $$=newStmtNode(ReturnK);
		     $$->child[0]=$2;
		    }

exp               : var ASSIGN exp 
                    { $$ = newExpNode(OpK);
		      $$->child[0] = $1;
		      $$->child[1] = $3;
		      $$->attr.op = ASSIGN;
		     }
		    | simple_exp {$$=$1;}

var               : ID 
                     { $$ = newExpNode(IdK);
		       $$->attr.name= copyString(tokenString);
		       }
		    | ID {savedName1 =copyString(tokenString); }  SLBRACKET {savedName2 = copyString(tokenString);} exp SRBRACKET {savedName3=copyString(tokenString);}
		      {
		      $$ =newExpNode(IdK);
                     saveName4 = $3->attr.name; 
		   char * temp;
		   sprintf(temp,"%s%s%s",saveName1,saveName2,saveName3,savedName4);
                        $$->attr.name=temp;
			}
		    

simple_exp             : additive_exp LESSEQ additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op =LESSEQ
			  }
			  | additive_exp LESS additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = LESS
			  }
			  | additive_exp GREATER additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = GREATER
			  }
			  | additive_exp GREATEREQ additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = GREATEREQ
			  }
			  | additive_exp EQ additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = EQ
			  }
			  | additive_exp NOTEQ additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = NOTEQ
			  }
                         | additive_exp {$$=$1;}

additive_exp           : additive_exp PLUS term 
                         {  $$=newExpNode(OpK);
			    $$->child[0] =$1;
			    $$->Child[1] =$3;
			    $$->attr.op = PLUS;
			  }
			  | additive_exp MINUS term
                         {  $$=newExpNode(OpK);
			    $$->child[0] =$1;
			    $$->Child[1] =$3;
			    $$->attr.op = MINUS;
			  }
			  | term {$$=$1;}

term                    : term TIMES factor 
                           {  $$=newExpNode(OpK);
			      $$->child[0] =$1;
			      $$->child[1] =$3;
			      $$->attr.op= TIMES;
			    }
			    | term OVER factor
                         {  $$=newExpNode(OpK);
			    $$->child[0] =$1;
			    $$->Child[1] =$3;
			    $$->attr.op = OVER;
			  }
			  | factor {$$=$1;}

factor                   : LPAREN exp RPAREN {$$=$2;}
                          |var {$$=$1;}
			  |call {$$=$1;}
			  |NUM { $$ =newExpNode(ConstK);
			         $$->attr.val =atoi(tokenString);


call                    : ID {savedName1 = copyString(tokenString);} LPAREN args RPAREN                   { $$ = newExpNode(IdK);
                           $$->attr.name = savedName1;
			   $$->child[0] = $3;


args                    : arg_list {$$=$1;}


                          | /* empty */
			  
arg_list                : arg_list COMMA exp
                  { YYSTYPE t = $1;
                   if (t != NULL)
                   { while (t->sibling != NULL)
                        t = t->sibling;
                     t->sibling = $3;
                     $$ = $1; }
                     else $$ = $3;
                   }
                         |exp {$$=$1;}
			  



              
%%

int yyerror(char * message)
{ fprintf(listing,"Syntax error at line %d: %s\n",lineno,message);
  fprintf(listing,"Current token: ");
  printToken(yychar,tokenString);
  Error = TRUE;
  return 0;
}

/* yylex calls getToken to make Yacc/Bison output
 * compatible with ealier versions of the TINY scanner
 */
static int yylex(void)
{ return getToken(); }

TreeNode * parse(void)
{ yyparse();
  return savedTree;
}

