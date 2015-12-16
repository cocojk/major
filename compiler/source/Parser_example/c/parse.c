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
static char *savedName;
static int savedArrLen;

/* function prototypes for recursive calls */
static TreeNode *dec_list(void);
static TreeNode *type_first(void);
static TreeNode *type_first_cases(void);
static TreeNode *array_dec(void);
static TreeNode *params(void);
static TreeNode *param_list(void);
static TreeNode *compound_stmt(void);
static TreeNode *local_dec(void);
static TreeNode *stmt_list(void);
static TreeNode *stmt(void);
static TreeNode *expression_stmt(void);
static TreeNode *selection_stmt(void);
static TreeNode *iteration_stmt(void);
static TreeNode *return_stmt(void);
static TreeNode *expression(void);
static TreeNode *args(void);
static TreeNode *arg_list(void);
static TreeNode *simple_expression(void);
static TreeNode *additive_expression(TreeNode *);
static TreeNode *term(TreeNode *);
static TreeNode *factor(void);

static void syntaxError(char *message)
{
	fprintf(listing, "\n>>> ");
	fprintf(listing, "Syntax error at line %d: %s", lineno, message);
	Error = TRUE;
}

static void match(TokenType expected)
{
	if (token == expected)
		token = getToken();
	else
	{
		syntaxError("unexpected token(in match) -> ");
		printToken(token, tokenString);
		fprintf(listing, "      ");
	}
}

TreeNode * dec_list(void)
{
	TreeNode * t = type_first();
	TreeNode * p = t;
	while (token != ENDFILE)
	{
		TreeNode * q;
		q = type_first();
		if (q != NULL)
		{
			if (t == NULL)
				t = p = q;
			else // now p cannot be NULL either
			{
				p->sibling = q;
				p = q;
			}
		}
	}
	return t;
}

TreeNode *type_first(void)
{
	TreeNode *t = NULL;
	NameNode *n = NULL;
	Type type;
	switch (token)
	{
	case INT:
		match(INT);
		type = Integer;
		break;
	case VOID:
		match(VOID);
		type = Void;
		break;
	default:
		syntaxError("unexpected token -> ");
		printToken(token, tokenString);
		token = getToken();
		break;
	}

	n = newNameNode(tokenString);
	match(ID);
	t = type_first_cases();
	t->attr.name = n;
	t->type = type;

	return t;
}

TreeNode *type_first_cases(void)
{
	TreeNode *t = NULL;

	switch (token)
	{
	case SEMI:	//변수 선언
		match(SEMI);
		t = newDecNode(VarD);
		//t->attr.name = savedName;
		t->isArray = FALSE;
		break;
	case LPAREN:	//함수 선언
		match(LPAREN);
		t = newDecNode(FuncD);
		//t->attr.name = savedName;
		t->child[0] = params();
		match(RPAREN);
		t->child[1] = compound_stmt();
		break;
	case LBRACKET:	//배열의 경우
		match(LBRACKET);
		t = array_dec();
		break;
	default:
		if (token == COMMA || token == RPAREN)
		{	//단순 파라미터
			t = newParamNode();
			//t->attr.name = savedName;
			t->isArray = FALSE;
		}
		else
		{
			syntaxError("unexpected token -> ");
			printToken(token, tokenString);
			token = getToken();
		}
		break;
	}

	return t;
}

TreeNode *array_dec(void)
{
	TreeNode *t = NULL;

	if (token == RBRACKET)	//배열 파라미터
	{
		match(RBRACKET);
		t = newParamNode();
		//t->attr.name = savedName;
		t->isArray = TRUE;
	}
	else if (token == NUM)	//배열 변수 선언
	{
		t = newDecNode(VarD);
		//t->attr.name = savedName;
		t->isArray = TRUE;
		t->array_len = atoi(tokenString);
		match(NUM);
		match(RBRACKET);
		match(SEMI);
	}
	else
	{
		syntaxError("unexpected token -> ");
		printToken(token, tokenString);
		token = getToken();
	}

	return t;
}

TreeNode *params(void)
{
	TreeNode *t = NULL;

	if (token == VOID)
	{
		match(VOID);
		t = newParamNode();
		t->type = Void;
		t->attr.name = "\0";
	}
	else
		t = param_list();

	return t;
}

TreeNode *param_list(void)
{
	TreeNode *t = type_first();
	TreeNode *p = t;
	while (token == COMMA)
	{
		match(COMMA);
		TreeNode *q;
		q = type_first();
		if (q != NULL)
		{
			if (t == NULL)
				t = p = q;
			else // now p cannot be NULL either
			{
				p->sibling = q;
				p = q;
			}
		}
	}
	return t;
}

TreeNode *compound_stmt(void)
{
	TreeNode *t = NULL;

	if (token == LBRACE)
	{
		match(LBRACE);
		t = newStmtNode(CompS);
		t->child[0] = local_dec();
		t->child[1] = stmt_list();
		match(RBRACE);
	}

	return t;
}

TreeNode *local_dec(void)
{
	TreeNode *t = NULL;

	if (token == INT || token == VOID)	//지역 선언이 1개 이상 존재
	{
		TreeNode *p = t = type_first();
		while (token == INT || token == VOID)
		{
			TreeNode *q;
			q = type_first();
			if (q != NULL)
			{
				if (t == NULL)
					t = p = q;
				else // now p cannot be NULL either
				{
					p->sibling = q;
					p = q;
				}
			}
		}
	}

	return t;
}

TreeNode *stmt_list(void)
{
	TreeNode *t = NULL;

	if (token != RBRACE)	//문장이 1개 이상 존재
	{
		TreeNode *p = t = stmt();
		while (token != RBRACE)
		{
			TreeNode *q;
			q = stmt();
			if (q != NULL)
			{
				if (t == NULL)
					t = p = q;
				else // now p cannot be NULL either
				{
					p->sibling = q;
					p = q;
				}
			}
		}
	}

	return t;
}

TreeNode *stmt(void)
{
	TreeNode *t = NULL;
	switch (token)
	{
	case LBRACE:
		t = compound_stmt();
		break;
	case IF:
		t = selection_stmt();
		break;
	case WHILE:
		t = iteration_stmt();
		break;
	case RETURN:
		t = return_stmt();
		break;
	default:
		if (token == ID || token == NUM || token == LPAREN)
			t = expression_stmt();
		else
		{
			syntaxError("unexpected token -> ");
			printToken(token, tokenString);
			token = getToken();
			break;
		}
	} // end case
	return t;
}

TreeNode *expression_stmt(void)
{
	TreeNode *t = NULL;

	if (token != SEMI)
		t = expression();
	match(SEMI);

	return t;
}

TreeNode *selection_stmt(void)
{
	TreeNode *t = NULL;

	if (token == IF)
	{
		match(IF);
		t = newStmtNode(SelS);
		match(LPAREN);
		t->child[0] = expression();
		match(RPAREN);
		t->child[1] = stmt();
		if (token == ELSE)
		{
			match(ELSE);
			t->child[2] = stmt();
		}
	}

	return t;
}

TreeNode *iteration_stmt(void)
{
	TreeNode *t = NULL;

	if (token == WHILE)
	{
		match(WHILE);
		t = newStmtNode(IterS);
		match(LPAREN);
		t->child[0] = expression();
		match(RPAREN);
		t->child[1] = stmt();
	}

	return t;
}

TreeNode *return_stmt(void)
{
	TreeNode *t = NULL;

	if (token == RETURN)
	{
		match(RETURN);
		t = newStmtNode(RetS);
		if (token != SEMI)
			t->child[0] = expression();
		match(SEMI);
	}

	return t;
}

TreeNode *expression(void)
{
	TreeNode *t = NULL, *temp = NULL;

	//simple expression이라고 우선 가정
	//만약 var이 확인된 후 다음 op가 '='인지만 확인하면?
	temp = simple_expression();
	if (temp->kind.exp == IdE && token == ASSIGN)
	{
		match(ASSIGN);
		t = newExpNode(OpE);
		t->attr.op = ASSIGN;
		t->child[0] = temp;
		t->child[1] = expression();
	}
	else
		t = temp;

	return t;
}

TreeNode *simple_expression(void)
{
	TreeNode *t = NULL, *temp = NULL;
	TokenType relop;
	temp = additive_expression(NULL);
	switch (token)
	{
	case GE:
		match(GE);
		relop = GE;
		break;
	case GT:
		match(GT);
		relop = GT;
		break;
	case LE:
		match(LE);
		relop = LE;
		break;
	case LT:
		match(LT);
		relop = LT;
		break;
	case EQ:
		match(EQ);
		relop = EQ;
		break;
	case NE:
		match(NE);
		relop = NE;
		break;
	default:	//just additive_exp only
		t = temp;
		break;
	}
	if (t == NULL)	//relop 노드인 경우
	{
		t = newExpNode(OpE);
		t->attr.op = relop;
		t->child[0] = temp;
		t->child[1] = additive_expression(NULL);
	}
	return t;
}

TreeNode *additive_expression(TreeNode *child)
{
	TreeNode *t = NULL, *temp = NULL;
	TokenType addop;
	if(child == NULL)	//인수로 받은 자식 노드가 없는 경우 -> 처음으로 term에 진입하는 경우
			temp = term(NULL);
		else
			temp = child;
	switch (token)
	{
	case PLUS:
		match(PLUS);
		addop = PLUS;
		break;
	case MINUS:
		match(MINUS);
		addop = MINUS;
		break;
	default:	//just term only
		t = temp;
		break;
	}
	if (t == NULL)	//addop 노드인 경우
	{
		t = newExpNode(OpE);
		t->attr.op = addop;
		t->child[0] = temp;
		t->child[1] = term(NULL);
	}
	if(token == PLUS || token == MINUS)	//뒤이어 mulop를 가지는 연산이 연속되는 경우
	{
		temp = t;
		t = additive_expression(temp);
	}
	return t;
}

TreeNode *term(TreeNode *child)
{
	int i;
	TreeNode *t = NULL, *temp = NULL;
	TokenType mulop;
	if(child == NULL)	//인수로 받은 자식 노드가 없는 경우 -> 처음으로 term에 진입하는 경우
		temp = factor();
	else
		temp = child;

	switch (token)
	{
	case TIMES:
		match(TIMES);	//12
		mulop = TIMES;
		break;
	case OVER:
		match(OVER);	//13
		mulop = OVER;
		break;
	default:	//just factor only
		t = temp;
		break;
	}
	if (t == NULL)	//mulop 노드인 경우
	{
		t = newExpNode(OpE);
		t->attr.op = mulop;
		t->child[0] = temp;
		t->child[1] = factor();
	}
	if(token == TIMES || token == OVER)	//뒤이어 mulop를 가지는 연산이 연속되는 경우
	{
		temp = t;
		t = term(temp);
	}
	return t;
}

TreeNode *factor(void)
{
	TreeNode *t = NULL;
	NameNode * n = NULL;

	switch (token)
	{
	case LPAREN:
		match(LPAREN);
		t = expression();
		match(RPAREN);
		break;
	case ID:	//var or call
		n = newNameNode(tokenString);
		//savedName = copyString(tokenString);
		match(ID);
		if (token == LPAREN)	//call
		{
			match(LPAREN);
			t = newExpNode(CallE);
			//t->attr.name = savedName;
			t->child[0] = args();
			match(RPAREN);
		}
		else if (token == LBRACKET)	//array var
		{
			match(LBRACKET);
			t = newExpNode(IdE);
			//t->attr.name = savedName;
			t->child[0] = expression();
			t->isArray = TRUE;
			if (t->child[0]->kind.exp == ConstE)	//상수인 경우
				t->array_len = t->child[0]->attr.val;
			match(RBRACKET);
		}
		else	//var
		{
			t = newExpNode(IdE);
			//t->attr.name = savedName;
			t->isArray = FALSE;
		}
		t->attr.name = n;
		break;
	case NUM:
		t = newExpNode(ConstE);
		t->attr.val = atoi(tokenString);
		match(NUM);
		break;
	default:
		break;
	}
	return t;
}

TreeNode *args(void)
{
	TreeNode *t = NULL;

	if (token != RPAREN)	//인수가 1개 이상 존재
		t = arg_list();

	return t;
}

TreeNode *arg_list(void)
{
	TreeNode *t = expression();
	TreeNode *temp = t;
	while (token == COMMA)
	{
		match(COMMA);
		TreeNode *next;
		next = expression();
		if (next != NULL)
		{
			if (t == NULL)
				t = temp = next;
			else // now p cannot be NULL either
			{
				temp->sibling = next;
				temp = next;
			}
		}
	}
	return t;
}

/****************************************/
/* the primary function of the parser   */
/****************************************/
/* Function parse returns the newly 
 * constructed syntax tree
 */
TreeNode *
parse(void)
{
	TreeNode * t;	//root or 'program'
	token = getToken();
	t = dec_list();
	if (token != ENDFILE)
		syntaxError("Code ends before file\n");
	return t;
}
