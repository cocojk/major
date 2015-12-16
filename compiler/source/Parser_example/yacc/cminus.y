/****************************************************/
/* File: cminus.y                                     */
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

#define YYSTYPE TreeNode *
static char *savedArrLen;
static TokenType relop, addop, mulop;
static int flag = 0, io;
static int savedLineNo;  /* ditto */
static TreeNode *savedTree; /* stores syntax tree for later return */
static int yylex(void); // added 11/2/11 to ensure no conflict with lex
%}

%token IF ELSE INT RETURN VOID WHILE
%token ID NUM 
%token PLUS MINUS TIMES OVER LT LE GT GE EQ NE ASSIGN SEMI COMMA LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
%token ERROR 

%% /* Grammar for C-Minus */

program	:	dec_list	{ savedTree = $1; } 
            ;
            
dec_list	:	dec_list type_first
				{ 
					YYSTYPE t = $1;
					if (t != NULL)
					{ 
						while (t->sibling != NULL)	t = t->sibling;
						t->sibling = $2;
						$$ = $1; 
					} 
					else $$ = $2;   
				}       
			|	type_first	{ $$ = $1; }
            ;
            
identifier	:	ID	
				{ 
					$$ = newAttrNode(); 
					$$->attr.name = copyString(tokenString);
				}
			;
//type으로 시작하는 문법들의 공통 부분(좌측 인수분해)

type_first	:	INT identifier type_first_cases
				{ 
					$$ = $3; 
					$$->attr.name = $2->attr.name;
					$$->type = Integer;
				}
			|	VOID identifier type_first_cases	
				{ 
					$$ = $3;
					$$->attr.name = $2->attr.name;
					$$->type = Void;
				}
			;			
//type_first의 세부 문법
type_first_cases	:	//case #1: 파라미터
						{
							$$ = newParamNode();	
							$$->isArray = FALSE; 
						}
					|	SEMI	//case #2: 변수
						{
							$$ = newDecNode(VarD);	
							$$->isArray = FALSE; 
						}						
					|	//case #3: 함수
						LPAREN params RPAREN compound_stmt
						{
							$$ = newDecNode(FuncD);	
							$$->child[0] = $2;	//parameters
							$$->child[1] = $4;	//function body
						}
					|
						LBRACKET array_dec	//case #4: 배열 및 배열 파라미터
						{ $$ = $2; }
					;
//배열 및 배열 파라미터 규칙
array_dec	:	RBRACKET	//배열 파라미터
				{
					$$ = (TreeNode *)newParamNode();
					$$->isArray = TRUE; 
				}
			|	//배열 변수
				NUM	{ savedArrLen = copyString(tokenString); }
				RBRACKET SEMI	
				{
					$$ = newDecNode(VarD);	
					$$->isArray = TRUE;
					$$->array_len = atoi(savedArrLen);
				}	
			;
//괄호 안에 들어가는 파라미터 목록, void 포함	
params		:	param_list	{ $$ = $1; }
			|	VOID	
				{
					$$ = newParamNode();
					$$->type = Void;
					$$->attr.name = "\0";
				}
			;
//실제 파라미터 목록, 1개 이상의 경우
param_list	:	param_list COMMA type_first
				{
					YYSTYPE t = $1;
					if (t != NULL)
					{ 
						while (t->sibling != NULL)	t = t->sibling;
						t->sibling = $3;
						$$ = $1; 
					}
					else $$ = $3;  
				}
			|	type_first	{ $$ = $1; }
			;

//함수의 본체가 되는 블록문 규칙
compound_stmt	:	LBRACE local_dec stmt_list RBRACE
					{
						$$ = newStmtNode(CompS);
						$$->child[0] = $2;	//지역 변수 선언부
						$$->child[1] = $3;	//문장 집합
					}
				;
//지역 변수 선언부
local_dec	:	local_dec type_first
				{
					YYSTYPE t = $1; 
					if (t != NULL)
					{ 
						while (t->sibling != NULL)	t = t->sibling;
						t->sibling = $2;
						$$ = $1; 
					}
					else $$ = $2;
				}
			|	{ $$ = NULL; }		
			;
//문장 집합
stmt_list	:	stmt_list stmt
				{
					YYSTYPE t = $1; 
					if (t != NULL)
					{ 
						while (t->sibling != NULL)	t = t->sibling;
						t->sibling = $2;
						$$ = $1; 
					}
					else $$ = $2;
				}
			|	{ $$ = NULL; }	
			;

stmt	:	expression_stmt	{ $$ = $1; }
		|	compound_stmt		{ $$ = $1; }
		|	selection_stmt	{ $$ = $1; }
		|	iteration_stmt	{ $$ = $1; }
		|	return_stmt		{ $$ = $1; }
		;

expression_stmt	:	expression SEMI	{ $$ = $1; }
					|	SEMI	{ $$ = NULL; }
					;

selection_stmt	:	IF LPAREN expression RPAREN stmt
                 		{ 
                 			$$ = newStmtNode(SelS);
                   		$$->child[0] = $3;
                   		$$->child[1] = $5;
                 		}
					|	IF LPAREN expression RPAREN stmt ELSE stmt
						{ 
							$$ = newStmtNode(SelS);
							$$->child[0] = $3;
							$$->child[1] = $5;
							$$->child[2] = $7;
						}
					;

iteration_stmt	:	WHILE LPAREN expression RPAREN stmt
						{
							$$ = newStmtNode(IterS);
							$$->child[0] = $3;
							$$->child[1] = $5;
						}
					;		

return_stmt	:	RETURN SEMI	{ $$ = newStmtNode(RetS); }
				|	RETURN expression SEMI
					{
						$$ = newStmtNode(RetS);
						$$->child[0] = $2;
					}
					
expression	:	id_first ASSIGN expression
				{
					$$ = newExpNode(OpE);
					$$->attr.op = ASSIGN;
					$$->child[0] = $1;
					$$->child[1] = $3;
				}
			|	simple_expression	{ $$ = $1; }
			;

id_first	:	identifier id_first_cases	
				{ 
					$$ = $2;
					$$->attr.name = $1->attr.name;
				}
			;
				

id_first_cases	:	//var
						{ $$ = newExpNode(IdE); }
					|	LBRACKET expression RBRACKET	//array var
						{	
							$$ = newExpNode(IdE);
							$$->child[0] = $2;	//maybe facotr->NUM ...
							$$->isArray = TRUE;
							//only NUM is available for this 'expression'...
							$$->array_len = $$->child[0]->attr.val;
							
						}
					|	LPAREN args RPAREN	//call
						{	
							$$ = newExpNode(CallE);
							$$->child[0] = $2;
						}
					; 

args	:	arg_list	{ $$ = $1; }	|	{ $$ = NULL; }
		;
		
arg_list	:	arg_list COMMA expression
				{
					YYSTYPE t = $1;
					if (t != NULL)
					{ 
						while (t->sibling != NULL)	t = t->sibling;
						t->sibling = $3;
						$$ = $1; 
					}
					else $$ = $3;
				}
			|	expression	{ $$ = $1; }
			;

simple_expression	:	additive_expression relop additive_expression
						{
							$$ = newExpNode(OpE);
							$$->attr.op = $2->attr.op;
							$$->child[0] = $1;
							$$->child[1] = $3;
						}
					|	additive_expression	{ $$ = $1; }
					;

relop	:	GE	
			{ 
				$$ = newAttrNode();
				$$->attr.op = GE;	 
			}	
		|	GT	
			{ 
				$$ = newAttrNode();
				$$->attr.op = GT;	 
			}	
		|	LE
			{ 
				$$ = newAttrNode();
				$$->attr.op = LE;	 
			}	
		|	LT		
			{ 
				$$ = newAttrNode();
				$$->attr.op = LT;	 
			}	
		|	EQ		
			{ 
				$$ = newAttrNode();
				$$->attr.op = EQ;	 
			}	
		|	NE	
			{ 
				$$ = newAttrNode();
				$$->attr.op = NE;	 
			}	
		;
		
additive_expression	:	additive_expression addop term
							{
								$$ = newExpNode(OpE);
								$$->attr.op = $2->attr.op;
								$$->child[0] = $1;
								$$->child[1] = $3;
							}
						|	term	{ $$ = $1; }
						;

addop	:	PLUS	
			{ 
				$$ = newAttrNode();
				$$->attr.op = PLUS;	 
			}
		|	MINUS
			{ 
				$$ = newAttrNode();
				$$->attr.op = MINUS;	 
			}
		;

term	:	term mulop factor
			{
				$$ = newExpNode(OpE);
				$$->attr.op = $2->attr.op;
				$$->child[0] = $1;
				$$->child[1] = $3;
			}
		|	factor	{ $$ = $1; }
		;

mulop	:	TIMES
			{ 
				$$ = newAttrNode();
				$$->attr.op = TIMES;	 
			}
		|	OVER
			{ 
				$$ = newAttrNode();
				$$->attr.op = OVER;	 
			}
		;	
		
factor	:	LPAREN expression RPAREN	{ $$ = $2; }
		|	id_first	{ $$ = $1; }
		|	NUM
			{
				$$ = newExpNode(ConstE);
				$$->attr.val = atoi(tokenString);
			}
		;
%%
		
int yyerror(char * message)
{ 
	fprintf(listing,"Syntax error at line %d: %s\n",lineno,message);
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
{ 
	yyparse();
	return savedTree;
}

