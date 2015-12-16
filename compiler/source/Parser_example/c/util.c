/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the C-minus compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "util.h"

int count = 0;

/* Procedure printToken prints a token 
 * and its lexeme to the listing file
 */
void printToken(TokenType token, const char* tokenString)
{
	switch (token)
	{
	case IF:
	case ELSE:
	case INT:
	case RETURN:
	case VOID:
	case WHILE:
		fprintf(listing, "reserved word: %s\n", tokenString);
		break;
	case PLUS:
		fprintf(listing, "+\n");
		break;
	case MINUS:
		fprintf(listing, "-\n");
		break;
	case TIMES:
		fprintf(listing, "*\n");
		break;
	case OVER:
		fprintf(listing, "/\n");
		break;
	case LT:
		fprintf(listing, "<\n");
		break;
	case LE:
		fprintf(listing, "<=\n");
		break;
	case GT:
		fprintf(listing, ">\n");
		break;
	case GE:
		fprintf(listing, ">=\n");
		break;
	case EQ:
		fprintf(listing, "==\n");
		break;
	case NE:
		fprintf(listing, "!=\n");
		break;
	case ASSIGN:
		fprintf(listing, "=\n");
		break;
	case SEMI:
		fprintf(listing, ";\n");
		break;
	case COMMA:
		fprintf(listing, ",\n");
		break;
	case LPAREN:
		fprintf(listing, "(\n");
		break;
	case RPAREN:
		fprintf(listing, ")\n");
		break;
	case LBRACE:
		fprintf(listing, "{\n");
		break;
	case RBRACE:
		fprintf(listing, "}\n");
		break;
	case LBRACKET:
		fprintf(listing, "[\n");
		break;
	case RBRACKET:
		fprintf(listing, "]\n");
		break;
	case ENDFILE:
		fprintf(listing, "EOF\n");
		break;
	case NUM:
		fprintf(listing, "NUM, val: %s\n", tokenString);
		break;
	case ID:
		fprintf(listing, "ID, name: %s\n", tokenString);
		break;
	case ERROR:
		fprintf(listing, "ERROR: %s\n", tokenString);
		break;
	default: /* should never happen */
		fprintf(listing, "Unknown token: %d\n", token);
	}
}

/* Function newDecNode creates a new decaration
 * node for syntax tree construction
 */

TreeNode * newDecNode(DecKind kind)
{
	TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
	int i;
	if (t == NULL)
		fprintf(listing, "Out of memory error at line %d\n", lineno);
	else
	{
		for (i = 0; i < MAXCHILDREN; i++)
			t->child[i] = NULL;
		t->sibling = NULL;
		t->nodekind = DecN;
		t->kind.dec = kind;
		t->lineno = lineno;
	}
	return t;
}

/* Function newParamNode creates a new parameter
 * node for syntax tree construction
 */

TreeNode * newParamNode()
{
	TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
	int i;
	if (t == NULL)
		fprintf(listing, "Out of memory error at line %d\n", lineno);
	else
	{
		for (i = 0; i < MAXCHILDREN; i++)
			t->child[i] = NULL;
		t->sibling = NULL;
		t->nodekind = ParamN;
		t->lineno = lineno;
	}
	return t;
}

/* Function newStmtNode creates a new statement
 * node for syntax tree construction
 */

TreeNode * newStmtNode(StmtKind kind)
{
	TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
	int i;
	if (t == NULL)
		fprintf(listing, "Out of memory error at line %d\n", lineno);
	else
	{
		for (i = 0; i < MAXCHILDREN; i++)
			t->child[i] = NULL;
		t->sibling = NULL;
		t->nodekind = StmtN;
		t->kind.stmt = kind;
		t->lineno = lineno;
	}
	return t;
}

/* Function newExpNode creates a new expression 
 * node for syntax tree construction
 */

TreeNode * newExpNode(ExpKind kind)
{
	TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
	int i;
	if (t == NULL)
		fprintf(listing, "Out of memory error at line %d\n", lineno);
	else
	{
		for (i = 0; i < MAXCHILDREN; i++)
			t->child[i] = NULL;
		t->sibling = NULL;
		t->nodekind = ExpN;
		t->kind.exp = kind;
		t->lineno = lineno;
	}
	return t;
}


/* Function copyString allocates and makes a new
 * copy of an existing string
 */
char *
copyString(char * s)
{
	int n;
	char * t;
	if (s == NULL)
		return NULL;
	n = strlen(s) + 1;
	t = malloc(n);
	if (t == NULL)
		fprintf(listing, "Out of memory error at line %d\n", lineno);
	else
		strcpy(t, s);
	return t;
}

/* Variable indentno is used by printTree to
 * store current number of spaces to indent
 */
static indentno = 0;

/* macros to increase/decrease indentation */
#define INDENT indentno+=2
#define UNINDENT indentno-=2

/* printSpaces indents by printing spaces */
static void printSpaces(void)
{
	int i;
	for (i = 0; i < indentno; i++)
		fprintf(listing, " ");
}

/* procedure printTree prints a syntax tree to the 
 * listing file using indentation to indicate subtrees
 */

void printTree(TreeNode * tree)
{
	int i;
	//printf("**in\n");
	INDENT;
	while (tree != NULL)
	{
		printSpaces();
		//선언부 노드 출력
		if (tree->nodekind == DecN)
		{
			switch (tree->kind.dec)
			{
			case VarD:
				fprintf(listing, "Variable Declaration: %s", tree->attr.name->name);
				if (tree->isArray)	//배열인 경우
				{
					if (tree->array_len > 0)
						fprintf(listing, ", array length: %d\n",
								tree->array_len);
					else	//배열의 인덱스 범위가 0 이하인 경우는 에러 처리
					{
						fprintf(listing,
								"\n\n** Array index interval error: %d **\n\n",
								tree->array_len);
						break;
					}
				}
				else
					fprintf(listing, "\n");
				break;
			case FuncD:
				if (tree->type == Integer)
				{
					fprintf(listing, "Int Function Declaration: %s\n",
							tree->attr.name->name);
				}
				else if (tree->type == Void)
				{
					fprintf(listing, "Void Function Declaration: %s\n",
							tree->attr.name->name);
				}
				else
				{
					fprintf(listing, "Function Declaration Type Error!\n");
					break;
				}
				break;
			default:
				fprintf(listing, "Unknown DecNode kind\n");
				break;
			}
		}
		//파라미터 노드 출력
		else if (tree->nodekind == ParamN)
		{
			if(strlen(tree->attr.name->name) > 0)	//parameter with name
			{
				if (tree->type == Integer)	//int parameter
				{
					fprintf(listing, "Para: (Int) %s", tree->attr.name->name);
					if (tree->isArray)
						fprintf(listing, " (array)");
					fprintf(listing, "\n");
				}
				else if (tree->type == Void)	//void parameter
				{
					fprintf(listing, "Para: (Void) %s", tree->attr.name->name);
					if (tree->isArray)
						fprintf(listing, " (array)");
					fprintf(listing, "\n");
				}
				else
					fprintf(listing, "Parameter Type Error!\n");
			}
			else 	//void type-specifier only parameter
			{
				if (tree->type == Void)
					fprintf(listing, "Para: Void\n");
				else
					fprintf(listing, "Parameter Type Error!\n");
			}
		}
		//문장 노드 출력
		else if (tree->nodekind == StmtN)
		{
			switch (tree->kind.stmt)
			{
			case CompS:
				fprintf(listing, "Compound Statement\n");
				break;
			case SelS:
				fprintf(listing, "If(cond, body, (opt)else)\n");
				break;
			case IterS:
				fprintf(listing, "While(cond, body)\n");
				break;
			case RetS:
				fprintf(listing, "Return\n");
				break;
			default:
				fprintf(listing, "Unknown StmtNode kind\n");
				break;
			}
		}
		//표현식 노드 출력
		else if (tree->nodekind == ExpN)
		{
			switch (tree->kind.exp)
			{
			case OpE:
				if (tree->attr.op == ASSIGN)
				{
					fprintf(listing, "Assign (dest) (src)\n");
				}
				else
				{
					fprintf(listing, "Op: ");
					printToken(tree->attr.op, "\0");
				}
				break;
			case ConstE:
				fprintf(listing, "Const: %d\n", tree->attr.val);
				break;
			case IdE:
				fprintf(listing, "Id: %s\n", tree->attr.name->name);
				break;
			case CallE:
				fprintf(listing, "Call(followings are args): %s\n", tree->attr.name->name);
				break;
			default:
				fprintf(listing, "Unknown ExpNode kind\n");
				break;
			}
		}
		else
			fprintf(listing, "Unknown node kind\n");
		for (i = 0; i < MAXCHILDREN; i++)
			printTree(tree->child[i]);

		tree = tree->sibling;
	}//end of while(tree != NULL)
	UNINDENT;
}

