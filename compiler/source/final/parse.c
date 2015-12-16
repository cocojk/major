/****************************************************/
/* File: parse.c                                    */
/* The parser implementation for the TINY compiler  */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "util.h"
#include "scan.h"
#include "parse.h"

static TokenType token; /* holds current token */

/* function prototypes for recursive calls */
static TreeNode * declaration_list(void);
static TreeNode * declaration(void);
static TreeNode * params(void);
static TreeNode * param(void);
static TreeNode * comp_stmt(void);
static TreeNode * local_declaration(void);
static TreeNode * var_declaration(void);
static TreeNode * statement_list(void);
static TreeNode * statement(void);
static TreeNode * if_stmt(void);
static TreeNode * while_stmt(void);
static TreeNode * return_stmt(void);
static TreeNode * expression_stmt(void);
static TreeNode * expression(void);
static TreeNode * distinguish(void);
static TreeNode * simple_expression(TreeNode* down);
static TreeNode * additive_expression(TreeNode* down);
static TreeNode * term(TreeNode* down);
static TreeNode * factor(TreeNode* down);
static TreeNode * args(void);
static TreeNode * arg_list(void);



static void syntaxError(char * message)
{ fprintf(listing,"\n>>> ");
	fprintf(listing,"Syntax error at line %d: %s",lineno,message);
	Error = TRUE;
}

static ExpType matchType()
{
	ExpType temp;

	switch(token)
	{
		case INT: temp =Integer;
			  token=getToken();
			  break;

		case VOID: temp = Void;
			   token=getToken();
			   break;

		default : printf("match type error\n");
			  break;



	}

	return temp;

}
static void match(TokenType expected)
{ if (token == expected) token = getToken();
	else {
		syntaxError("unexpected token -> ");
		printToken(token,tokenString);
		fprintf(listing,"      ");
	}
}

TreeNode * declaration_list(void)
{ TreeNode * t = declaration();
	TreeNode * p = t;
	while (token!=ENDFILE)
	{ TreeNode * q;
		q = declaration();
		if (q!=NULL) {
			if (t==NULL) t = p = q;
			else 
			{ p->sibling = q;
				p = q;
			}
		}
	}
	return t;
}

TreeNode * declaration(void)
{
	TreeNode * t = NULL;
	ExpType type;
	char* id;
	type = matchType();
	id = copyString(tokenString);
	match(ID);

	switch(token) 
	{

		case SEMI :
			t = newDeclarNode(VarK);
			if(t!=NULL)
			{
				t->type = type;
				t->name = id;

			}

			match(token);
			break;

		case SLBRACKET :
			match(SLBRACKET);
			t = newDeclarNode(VararrayK);
			if(t!=NULL)
			{
				t->type= type;
				t->name=id;
				t->val = atoi(tokenString);
			}
			match(NUM);
			match(SRBRACKET);
			match(SEMI);
			break;

		case LPAREN :
			t = newDeclarNode(FunK);
			match(token);
			if(t!=NULL)
			{
				t->type = type;
				t->name = id;
				t->child[0] = params();
				match(RPAREN);
				t->child[1] = comp_stmt();

			}
			break;

		default :
			syntaxError("unexpected token -> ");
			printToken(token,tokenString);
			fprintf(listing,"      ");
			break;
	}

	return t;
}

TreeNode * params (void)
{
	TreeNode * t;
	TreeNode * p;
	TreeNode * q;

	if(token==VOID)
	{
		t = newParamNode(Param);
		t->type = Void;
		match(VOID);
	}
	else
	{
		t =param();
		p = t;

		while((t!=NULL)&&(token==COMMA))
		{
			match(COMMA);
			q = param();
			if(q!=NULL)
			{
				p->sibling=q;
				p =q;
			}

		}

	}

	return t;
}

TreeNode * param (void)
{
	TreeNode *t ;
	ExpType type;
	char* id;

	type =matchType();
	id = copyString(tokenString);
	match(ID);

	if(token ==SLBRACKET)
	{ 
		match(SLBRACKET);
		match(SRBRACKET);
		t = newParamNode(ParamarrayK);

	}
	else
		t = newParamNode(Param);

	if(t!=NULL)
	{
		t->name = id;
		t->type=type;

	}

	return t;
}

TreeNode * comp_stmt(void)
{
	TreeNode *t = NULL;
	match(LBRACKET);


	if(token!=RBRACKET)
	{
		t=newStmtNode(CompK);

		if((token==INT)||(token==VOID))
			t->child[0] = local_declaration();


		if(token!=RBRACKET)
			t->child[1] = statement_list();

	}

	match(RBRACKET);
	return t;
}

TreeNode * local_declaration(void)
{

	TreeNode* t;
	TreeNode* p;
	TreeNode* q;
	if((token==INT)||(token==VOID))
		t = var_declaration();

	if(t!=NULL)
	{
		p = t;

		while((token==INT)||(token==VOID))
		{
			q= var_declaration();
			if(q!=NULL)
			{
				p->sibling = q;
				p = q;
			}

		}

	}
	return t;
}



TreeNode * var_declaration(void)
{
	TreeNode * t = NULL;
	ExpType type;
	char* id;

	type = matchType();
	id = copyString(tokenString);
	match(ID);

	switch(token) 
	{

		case SEMI :
			t = newDeclarNode(VarK);
			if(t!=NULL)
			{
				t->type = type;
				t->name = id;

			}

			match(token);
			break;

		case SLBRACKET :
			match(token);
			t = newDeclarNode(VararrayK);
			if(t!=NULL)
			{
				t->type= type;
				t->name=id;
				t->val = atoi(tokenString);
			}
			match(NUM);
			match(SRBRACKET);
			match(SEMI);
			break;

		default: 
			syntaxError("unexpected token -> ");
			printToken(token,tokenString);
			fprintf(listing,"      ");
			break;
	}

	return t;
}


TreeNode* statement_list(void)
{
	TreeNode *t=NULL;
	TreeNode *p;
	TreeNode *q;
	if(token!=RBRACKET)
	{
		t=statement();
		p=t;

		while(token!=RBRACKET)
		{
			q = statement();
			if((p!=NULL)&&(q!=NULL))
			{
				p->sibling=q;
				p =q;

			}

		}


	}

	return t;
}


TreeNode * statement(void)
{
	TreeNode * t =NULL;
	switch(token) 
	{

		case IF: t= if_stmt(); break;
		case WHILE: t =while_stmt(); break;
		case RETURN: t=return_stmt(); break;
		case LBRACKET: t=comp_stmt(); break;
		case ID :
		case SEMI:
		case LPAREN:
		case NUM:
			       t=expression_stmt();
			       break;

                defualt: 
			       syntaxError("unexpected token -> ");
			       printToken(token,tokenString);
			       fprintf(listing,"      ");
			       break;
	}

	return t;
}

TreeNode* if_stmt(void)
{
	TreeNode * t =newStmtNode(IfK);
	match(IF);
	match(LPAREN);
	if(t!=NULL) t->child[0] =expression();
	match(RPAREN);
	if(t!=NULL) t->child[1] = statement();
	if(token==ELSE)
	{
		match(ELSE);
		if(t!=NULL) t->child[2] =statement();
	}
	return t;
}

TreeNode* while_stmt(void)
{
	TreeNode* t =newStmtNode(WhileK);
	match(WHILE);
	match(LPAREN);
	if(t!=NULL) t->child[0]=expression();
	match(RPAREN);
	if(t!=NULL) t->child[1]=statement();

	return t;
}

TreeNode* return_stmt(void)
{
	TreeNode* t =newStmtNode(ReturnK);
	match(RETURN);


	if((token!=SEMI)&&(t!=NULL))
	{
		t->child[0] = expression();

	}
	match(SEMI);


	return t;
}

TreeNode* expression_stmt(void)
{
	TreeNode *t = NULL;
	if(token==SEMI)
		match(SEMI);
	else if(token !=RBRACKET)
	{
		t=expression();
		match(SEMI);

	}

	return t;
}

TreeNode* expression(void)
{
	TreeNode* t =NULL;
	TreeNode* lvalue=NULL;
	TreeNode* rvalue=NULL;
	int check =0;
	if(token ==ID)
	{
		lvalue=distinguish();
		check=1;
	}

	if((check==1)&&(token==ASSIGN))
	{
		if((lvalue!=NULL)&&(lvalue->nodekind==ExpK)&&(lvalue->kind.exp=IdK))
		{
			match(ASSIGN);
			rvalue=expression();
			t= newExpNode(AssignK);
			if(t!=NULL)
			{
				t->child[0]=lvalue;
				t->child[1]=rvalue;

			}

		}
		else
		{
			syntaxError("unexpected token -> ");
			printToken(token,tokenString);
			fprintf(listing,"      ");
		}

	}
	else
		t = simple_expression(lvalue);

	return t;
}

TreeNode* distinguish(void)
{
	TreeNode* t;
	TreeNode* exp=NULL;
	TreeNode* arg=NULL;
	char* id;

	if(token==ID)
		id=copyString(tokenString);
	match(ID);

	if(token==LPAREN)
	{
		match(LPAREN);
		arg=args();
		match(RPAREN);
		t= newStmtNode(CallK);
		if(t!=NULL)
		{
			t->child[0] =arg;
			t->name = id;

		}

	}
	else
	{
		if(token==SLBRACKET)
		{
			match(SLBRACKET);
			exp=expression();
			match(SRBRACKET);
		}

		t= newExpNode(IdK);

		if(t!=NULL)
		{
			t->child[0]=exp;
			t->name=id;

		}

	}

	return t;
}

TreeNode* simple_expression(TreeNode* down)
{
	TreeNode* t;
	TreeNode* lexpr=NULL;
	TreeNode* rexpr=NULL;
	TokenType operator;

	lexpr=additive_expression(down);
	if((token==LESSEQ)||(token==LESS)||(token==GREATEREQ)||(token==GREATER)||(token==EQ)||(token==NOTEQ))
	{
		operator=token;
		match(token);
		rexpr=additive_expression(NULL);
		t=newExpNode(OpK);
		if(t!=NULL)
		{
			t->child[0]=lexpr;
			t->child[1]=rexpr;
			t->op=operator;

		}

	}
	else
		t=lexpr;

	return t;

}
TreeNode *additive_expression(TreeNode *down)
{
	TreeNode *tree;
	TreeNode *newNode;

	tree = term(down);

	while ((token == PLUS) || (token == MINUS))
	{
		newNode = newExpNode(OpK);
		if (newNode != NULL)
		{
			newNode->child[0] = tree;
			newNode->op = token;
			tree = newNode;
			match(token);
			tree->child[1] = term(NULL);
		}
	}

	return tree;
}


TreeNode *term(TreeNode *down)
{
	TreeNode *tree;
	TreeNode *newNode;

	tree = factor(down);

	while ((token == TIMES) || (token == OVER))
	{
		newNode = newExpNode(OpK);

		if (newNode != NULL)
		{
			newNode->child[0] = tree;
			newNode->op = token;
			tree = newNode;
			match(token);
			newNode->child[1] = factor(NULL);
		}
	}
	return tree;
}

TreeNode *factor(TreeNode *down)
{
	TreeNode *tree = NULL;


	/* If the subtree in "passdown" is a Factor, pass it back. */
	if (down != NULL)
	{
		return down;
	}

	if (token == ID)
	{
		tree = distinguish();
	}
	else if (token == LPAREN)
	{
		match(LPAREN);
		tree = expression();
		match(RPAREN);
	}
	else if (token == NUM)
	{
		tree = newExpNode(ConstK);
		if (tree != NULL)
		{
			tree->val = atoi(tokenString);
			tree->type = Integer;
		}
		match(NUM);
	}
	else
	{
		syntaxError("unexpected token ");
		printToken(token, tokenString);
		fprintf(listing, "  ");
	}

	return tree;
}

TreeNode *args(void)
{
	TreeNode *t =NULL;
	if(token!=RPAREN)
		t = arg_list();

	return t;
}

TreeNode *arg_list(void)
{
	TreeNode *tree;
	TreeNode *ptr;
	TreeNode *newNode;


	tree = expression();
	ptr = tree;

	while (token == COMMA)
	{
		match(COMMA);
		newNode = expression();

		if ((ptr != NULL) && (tree != NULL))
		{
			ptr->sibling = newNode;
			ptr = newNode;
		}
	}

	return tree;
}

/****************************************/
/****************************************/
/* Function parse returns the newly 
 * constructed syntax tree
 */
TreeNode * parse(void)
{ TreeNode * t;
	token = getToken();
	t = declaration_list();
	if (token!=ENDFILE)
		syntaxError("Code ends before file\n");
	return t;
}
