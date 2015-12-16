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
static int savednum=0;
static int debug=1;
char * savedName[100]; /* for use in assignments */
static int savedLineNo;  /* ditto */
static TreeNode * savedTree; /* stores syntax tree for later return */
static int yylex(void); // added 11/2/11 to ensure no conflict with lex

%}

%token IF ELSE INT RETURN VOID WHILE
%token ID NUM 
%token PLUS MINUS TIMES OVER LESS LESSEQ GREATER GREATEREQ EQ NOTEQ ASSIGN SEMI COMMA LPAREN RPAREN SLBRACKET SRBRACKET LBRACKET RBRACKET
%token ERROR 

%start program
%% /* Grammar for TINY */

program     : declaration_list
                 { savedTree = $1;} 
            ;
declaration_list    : declaration_list declaration
                 { YYSTYPE t = $1;
		   if(debug) printf("declaration_list declaration\n");
                   if (t != NULL)
                   { while (t->sibling != NULL)
                        t = t->sibling;
                     t->sibling = $2;
                     $$ = $1; }
                     else $$ = $2;
                 }
            | declaration  { $$ = $1;  if(debug)printf("declaration\n"); }
            ;
declaration        : fun_declar { $$ = $1; 
                     if(debug) printf("fun_declar\n"); }
            | var_declar { $$ = $1;  if(debug) printf("var_declar\n"); }
	    ;

var_declar     : type_specifier ID SEMI
                 { $$ = newDeclarNode(VarK);
		   $$->attr.name = savedName[savednum-1];
		   savednum--;
                   $$->child[0] = $1;
		   if(debug) printf("var_declar attr.name:%s\n",savedName[savednum]);
                 }
            | type_specifier ID SLBRACKET NUM SRBRACKET SEMI
                 { $$ = newDeclarNode(VarK);
		   char temp[100];
		   sprintf(temp,"%s%s%s",savedName[savednum-1],"[","]");
		   savednum--;
		   $$->attr.name = temp;
		   if(debug) printf("var_declar attr.name:%s\n",temp);
                   $$->child[0] = $1;
                  } 
		   
                 ;

type_specifier    : INT {$$ =newTypeNode(TYPE);
                         $$->attr.type =INT;
			 if(debug) printf("type_specifier INT\n");
			 } 
                   | VOID {$$ =newTypeNode(TYPE);
		            $$->attr.type=VOID;
			    if(debug) printf("type_specifier VOID\n");
			    }
		    ;


fun_declar        : type_specifier ID LPAREN params RPAREN compound_stmt
                   { $$ = newDeclarNode(FunK);
		     $$->attr.name = savedName[savednum-1];
		     savednum--;
		     if(debug) printf("fun_declar attr.name :%s\n",savedName[savednum]);
		     $$->child[0] = $1;
		     $$->child[1] = $4;
		     $$->child[2] = $6;
		   }
		     
		   ;

params               : param_list { $$= $1;}
                     | VOID { $$ = newParamNode(PARAM);
		              $$->attr.name = "Void";
		           if(debug) printf("param void\n");}
		     ;

param_list           : param_list COMMA param
                    { YYSTYPE t = $1;
		      if(debug) printf("param_list COMMA param");
		      if(t!=NULL)
		      { while(t->sibling !=NULL)
		        t = t->sibling;
		      t->sibling = $3;
		      $$= $1;}
		      else $$ = $3;

/*
                     if((t!=NULL) ||(t->sibling!=NULL))
                    {
		    if(debug) printf("current :%s sibling :%s\n",t->attr.name,t->sibling->attr.name);
 }*/
		     
		     }
		  | param { $$=$1; if(debug) printf("param \n");}
		  ;

param               : type_specifier ID 
                      { $$ = newParamNode(PARAM);
		        $$->attr.name = savedName[savednum-1];
			savednum--;
			$$->child[0] = $1;
			if(debug) printf("INT ID(%s) \n",savedName[savednum]);
		      }
		      | type_specifier ID SLBRACKET SRBRACKET 
                       {
                         $$ = newParamNode(PARAM);
		   char  temp[100];
		   sprintf(temp,"%s%s%s",savedName[savednum-1],"[","]");
		   savednum--;
		   $$->attr.name=temp;
		   $$->child[0] = $1;
		   if(debug) printf("VOID ID(%s) \n",temp);
		       }
		       ;


compound_stmt       : LBRACKET local_declar stmt_list RBRACKET
                      {
		       $$ = newStmtNode(CompK);
		       $$->child[0] = $2;
		       $$->child[1] = $3;
		      }
		      ;

local_declar        : 
                       /* empty */ {$$=NULL;}
                       |local_declar var_declar
                       { 
		       YYSTYPE t = $1;
		      if(t!=NULL)
		      { while(t->sibling !=NULL)
		        t = t->sibling;
		      t->sibling = $2;
		      $$= $1;}
		      else
		      {
		      $$ = $2;
		      
		      }
		      
		      }
                      
		      ;

stmt_list          : 
                       /* empty */ {$$=NULL;}
                     |stmt_list stmt 
                       { YYSTYPE t = $1;
		          if (t!=NULL)
			  {
			    while (t->sibling!=NULL)
			     t = t->sibling;
		            t->sibling = $2;
			    $$ = $1;
			   }
			   else $$ =$2;
			 }
                        
		     ;

stmt               : expression_stmt
                       { $$ = $1;}
                     | compound_stmt
		       { $$ = $1;}
		     | if_stmt
		       { $$ = $1;}
		     | while_stmt
		       { $$= $1;}
		     | return_stmt
		       { $$ = $1;}
		       ;


expression_stmt     : exp SEMI 
                       {
		        $$ =newStmtNode(ExpressK);
			$$->child[0] = $1;
		       }
                     | SEMI
		       {
		        $$ = newStmtNode(ExpressK);
		       }
		       ;

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
		      ;

while_stmt         : WHILE LPAREN exp RPAREN stmt
                      {
                         $$=newStmtNode(WhileK);
			 $$->child[0]=$3;
			 $$->child[1]=$5;
		      }
		      ;

return_stmt       : RETURN SEMI
                    {
                     $$=newStmtNode(ReturnK);
		    }
                   | RETURN exp SEMI
		    {
                     $$=newStmtNode(ReturnK);
		     $$->child[0]=$2;
		    }
		    ;

exp               : var ASSIGN exp 
                    { $$ = newExpNode(OpK);
		      $$->child[0] = $1;
		      $$->child[1] = $3;
		      $$->attr.op = ASSIGN;
		     }
		    | simple_exp {$$=$1;}
                    ;

var               : ID 
                     { $$ = newExpNode(IdK);
		       $$->attr.name= savedName[savednum-1];
		       savednum--;
		       }
		    | ID  SLBRACKET exp SRBRACKET 
		      {
		      $$ =newExpNode(IdK);
		      char * temp2 = $3->attr.name;
		   char  temp[100];
		   sprintf(temp,"%s%s%s%s",savedName[savednum-1],"[",temp2,"]");
                        $$->attr.name=temp;
			savednum--;
			}
			;
		    

simple_exp             : additive_exp LESSEQ additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op =LESSEQ;
			  }
			  | additive_exp LESS additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = LESS;
			  }
			  | additive_exp GREATER additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = GREATER;
			  }
			  | additive_exp GREATEREQ additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = GREATEREQ;
			  }
			  | additive_exp EQ additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = EQ;
			  }
			  | additive_exp NOTEQ additive_exp
                          { $$ =newExpNode(OpK);
			    $$->child[0] = $1;
			    $$->child[1] = $3;
			    $$->attr.op = NOTEQ;
			  }
                         | additive_exp {$$=$1;}
                         ;

additive_exp           : additive_exp PLUS term 
                         {  $$=newExpNode(OpK);
			    $$->child[0] =$1;
			    $$->child[1] =$3;
			    $$->attr.op = PLUS;
			  }
			  | additive_exp MINUS term
                         {  $$=newExpNode(OpK);
			    $$->child[0] =$1;
			    $$->child[1] =$3;
			    $$->attr.op = MINUS;
			  }
			  | term {$$=$1;}
                           ;

term                    : term TIMES factor 
                           {  $$=newExpNode(OpK);
			      $$->child[0] =$1;
			      $$->child[1] =$3;
			      $$->attr.op= TIMES;
			    }
			    | term OVER factor
                         {  $$=newExpNode(OpK);
			    $$->child[0] =$1;
			    $$->child[1] =$3;
			    $$->attr.op = OVER;
			  }
			  | factor {$$=$1;}
                           ;

factor                   : LPAREN exp RPAREN {$$=$2;}
                          |var {$$=$1;}
			  |call {$$=$1;}
			  |NUM { $$ =newExpNode(ConstK);
			         $$->attr.val =atoi(tokenString);}
                           ;


call                    : ID LPAREN args RPAREN                  
                        { $$ = newExpNode(IdK);
                           $$->attr.name = savedName[savednum-1];
			   savednum--;
			   $$->child[0] = $3; }
                           ;

args                    : /* empty */{$$=NULL;}
                          |arg_list {$$=$1;}
                           
			  ;
			  
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
			   ;



              
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
{
int returnvalue = getToken();
if(returnvalue==ID)
{
savedName[savednum] = copyString(tokenString);
savednum++;
}

return returnvalue; 
}

TreeNode * parse(void)
{ yyparse();
  return savedTree;
}

