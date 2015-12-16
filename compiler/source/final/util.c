/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "util.h"

/* Procedure printToken prints a token 
 * and its lexeme to the listing file
 */
 static int debug =0;

void printToken( TokenType token, const char* tokenString )
{ switch (token)
  { case ELSE:
    case IF:
    case INT:
    case RETURN:
    case VOID:
    case WHILE:
      fprintf(listing,
         "reserved word: %s\n",tokenString);
      break;

    case PLUS: fprintf(listing,"+\n"); break;
    case MINUS: fprintf(listing,"-\n"); break;
    case TIMES: fprintf(listing,"*\n"); break;
    case OVER: fprintf(listing,"/\n"); break;
    case LESS: fprintf(listing,"<\n"); break;
    case LESSEQ: fprintf(listing,"<=\n"); break;
    case GREATER: fprintf(listing,">\n"); break;
    case GREATEREQ: fprintf(listing,">=\n"); break;
    case EQ: fprintf(listing,"==\n"); break;
    case NOTEQ: fprintf(listing,"!=\n"); break;
    case ASSIGN: fprintf(listing,"=\n"); break;
    case SEMI: fprintf(listing,";\n"); break;
    case COMMA: fprintf(listing,",\n"); break;
    case LPAREN: fprintf(listing,"(\n"); break;
    case RPAREN: fprintf(listing,")\n"); break;
    case SLBRACKET: fprintf(listing,"[\n"); break;
    case SRBRACKET: fprintf(listing,"]\n"); break;
    case LBRACKET: fprintf(listing,"{\n"); break;
    case RBRACKET: fprintf(listing,"}\n"); break; 
    case ENDFILE : fprintf(listing,"EOF\n"); break;
    case NUM:
    fprintf(listing,
          "NUM, val= %s\n",tokenString);
      break;
    case ID:
      fprintf(listing,
          "ID, name= %s\n",tokenString);
      break;
    case ERROR:
      fprintf(listing,
          "ERROR: %s\n",tokenString);
      break;
    default: /* should never happen */
      fprintf(listing,"Unknown token: %d\n",token);
  }
}

/* Function newStmtNode creates a new statement
 * node for syntax tree construction
 */
TreeNode * newStmtNode(StmtKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    fprintf(listing,"Out of memory error at line %d\n",lineno);
  else {
    for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
    t->sibling = NULL;
    t->name =NULL;
    t->nodekind = StmtK;
    t->kind.stmt = kind;
    t->lineno = lineno;
  }
  return t;
}

/* Function newStmtNode creates a new statement
 *H node for syntax tree construction
 */
/* Function newStmtNode creates a new param
 * node for syntax tree construction
 */
TreeNode * newParamNode(ParamKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
 int i;
 if (t==NULL)
     fprintf(listing,"Out of memory error at line %d\n",lineno);
 else
     {
     for (i=0;i<MAXCHILDREN;i++) t->child[i] =NULL;
     t->sibling =NULL;
     t->nodekind =ParamK;
     t->kind.param = kind;
     t->lineno = lineno;
     t->name =NULL;
     t->isglobal=0; //local
     }
  return t;
}

/* Function newStmtNode creates a new declaration
 * node for syntax tree construction
 */
TreeNode * newDeclarNode(DeclarKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
 int i;
 if (t==NULL)
     fprintf(listing,"Out of memory error at line %d\n",lineno);
 else
     {
     for (i=0;i<MAXCHILDREN;i++) t->child[i] =NULL;
     t->sibling =NULL;
     t->nodekind =DeclarK;
     t->lineno = lineno;
     t->kind.declar = kind;
     t->name=NULL;
     }
  return t;
}
/* Function newExpNode creates a new expression 
 * node for syntax tree construction
 */
TreeNode * newExpNode(ExpKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    fprintf(listing,"Out of memory error at line %d\n",lineno);
  else {
    for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
    t->sibling = NULL;
    t->nodekind = ExpK;
    t->kind.exp = kind;
    t->lineno = lineno;
    t->type = Void;
    t->name=NULL;
  }
  return t;
}

/* Function copyString allocates and makes a new
 * copy of an existing string
 */
char * copyString(char * s)
{ int n;
  char * t;
  if (s==NULL) return NULL;
  n = strlen(s)+1;
  t = malloc(n);
  if (t==NULL)
    fprintf(listing,"Out of memory error at line %d\n",lineno);
  else strcpy(t,s);
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
{ int i;
  for (i=0;i<indentno;i++)
    fprintf(listing," ");
}

/* procedure printTree prints a syntax tree to the 
 * listing file using indentation to indicate subtrees
 */
void printTree( TreeNode * tree )
{ int i;
  while (tree != NULL) {
    printSpaces();
    if (tree->nodekind==StmtK)
    {
       if(debug) printf("enter StmtK\n");

       switch (tree->kind.stmt) {
        case IfK:
          fprintf(listing,"If stmt\n");
          break;
        case WhileK:
          fprintf(listing,"while stmt\n");
          break;
        case ReturnK:
          fprintf(listing,"return stmt\n");
          break;
        case CompK:
          fprintf(listing,"Compound stmt\n");
          break;
        case ExpressK:
          fprintf(listing,"expression stmt\n");
          break;
	case CallK:
	  fprintf(listing,"call(followings are args) : %s \n",tree->name);
	  break;
        default:
          fprintf(listing,"Unknown ExpNode kind\n");
          break;
      }
    }
    else if (tree->nodekind==DeclarK)
    {
    if(debug) printf("enter declarK\n");
      switch (tree->kind.declar)
      {

     // if(debug) printf("enter declarK switch\n");

         case VarK:
	 switch(tree->type)
	 {

	 case Void:
	 fprintf(listing,"void var-declar: %s\n",tree->name);

	 case Integer:
          fprintf(listing,"int var-declar: %s\n",tree->name);
break;

         default :
	 fprintf(listing,"Unkown type-specifier\n");
break;

         }
	 break;
	
	case VararrayK:
	switch(tree->type)
	{

	case Void:
	  fprintf(listing,"void var-declar : %s [ %d ] \n",tree->name,tree->val);
	  break;

	  case Integer:
	  fprintf(listing,"int var-declar: %s [ %d ] \n",tree->name,tree->val);
	  break;
         
	 default :
	 fprintf(listing,"unkwon type-specifier\n");
         break;

	  }
	  break;

	case FunK:
	switch(tree->type)
	{
          case Void:
          fprintf(listing,"void fun-declar: %s\n",tree->name);
	  break;

	  case Integer:
	  fprintf(listing,"int fun-declar: %s\n",tree->name);
          break; 

          default :
          fprintf(listing,"Unknown type-specifier\n");
          break;
	 }
	 break;

	 default :
	 fprintf(listing,"unknown expnode kind\n");
	 break;

      }
    }
    else if (tree->nodekind==ParamK)
    {
    if(debug) printf("enter paramK\n");
       switch(tree->kind.param)
       {
          case Param:
	  switch(tree->type)
	  {

	  case Void:
          fprintf(listing,"void param \n"); 
	  break;

	  case Integer:
	  fprintf(listing,"int param : %s \n",tree->name);
	  break;
	  
	  default :
	  fprintf(listing,"unknown type-specifier\n");
	  //fprintf(listing,tree->attr.name);
          break;
	  }
	  break;
	  
	  case ParamarrayK:
	  switch(tree->type)
	  {

	  case Void:
	  fprintf(listing,"void param: %s [ ] \n",tree->name);
	  break;

	  case Integer:
	  fprintf(listing,"int param: %s [ ] \n",tree->name);
	  break;

	  default :
	  fprintf(listing,"unknown type-specifier\n");
	  break;
	  }
	  break;

        default:
          fprintf(listing,"Unknown ExpNode kind\n");
          break;
       }

    }
    else if (tree->nodekind==ExpK)
    { 
    if(debug) printf("enter ExpK\n");
     switch (tree->kind.exp) {
        case OpK:
          fprintf(listing,"Op: ");
          printToken(tree->op,"\0");
          break;

        case ConstK:
          fprintf(listing,"Const: %d\n",tree->val);
          break;

        case IdK:
          fprintf(listing,"Id: %s\n",tree->name);
          break;

        case AssignK:
	  fprintf(listing,"assign (dest) (source)\n");
	  break;
        
	case IdarrayK:
	fprintf(listing,"idarray : %s (following [expression]) \n",tree->name);
        break;
	default:
          fprintf(listing,"Unknown ExpNode kind\n");
          break;
      }
    }
    else fprintf(listing,"Unknown node kind\n");
    for (i=0;i<MAXCHILDREN;i++)
         printTree(tree->child[i]);
   
    tree = tree->sibling;
    
  }
  
}
