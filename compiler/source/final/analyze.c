/****************************************************/
/* File: analyze.c                                  */
/* Semantic analyzer implementation                 */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "symtab.h"
#include "analyze.h"

/* counter for variable memory locations */
static int location = 0;
int debug2 =0;
static void checkNode(TreeNode* t);
static void nullProc(TreeNode* syntaxTree)
{
	if(syntaxTree==NULL)
		return;
	else 

		return;

}
static void traverse( TreeNode * t,
		void (* preProc) (TreeNode *),
		void (* postProc) (TreeNode *) )
{ if (t != NULL)
	{ preProc(t);
		{ int i;
			for (i=0; i < MAXCHILDREN; i++)
				traverse(t->child[i],preProc,postProc);
		}
		postProc(t);
		traverse(t->sibling,preProc,postProc);
	}
}

void typeCheck(TreeNode* syntaxTree)
{
	traverse(syntaxTree,nullProc,checkNode);
}
/* nullProc is a do-nothing procedure to 
 * generate preorder-only or postorder-only
 * traversals from traverse
 */



/* Function buildSymtab constructs the symbol 
 * table by preorder traversal of the syntax tree
 */
void buildSymtab(TreeNode * syntaxTree)
{ 

	if (TraceAnalyze)
	{ fprintf(listing,"\nSymbol table:\n\n");


	}
	predefined();
	prebuildsym(syntaxTree);
	clear();
	predefined();
	buildSymtab2(syntaxTree);

	if(TraceAnalyze) 
		printSymTab(0,syntaxTree);


}

void prebuildsym(TreeNode* syntaxTree)
{
	int         i;         
	BucketList  temp;  
	static TreeNode *inFunction = NULL;

	while (syntaxTree != NULL)
	{

		if (syntaxTree->nodekind == DeclarK)
		{

			if(((syntaxTree->kind.declar == VarK)&&(syntaxTree->type==Void))||((syntaxTree->kind.declar==VararrayK)&&(syntaxTree->type==Void)))
			{
				printf("error variable or variable array  type cannot be void \n");  
			}
			else
				insertSymbol(syntaxTree->name, syntaxTree, syntaxTree->lineno);

		} 
		if (syntaxTree->nodekind == ParamK)
		{

			if(syntaxTree->type!=Void)
			{

				insertSymbol(syntaxTree->name,syntaxTree,syntaxTree->lineno);


			}
			else
			{

			}

		}
		if ((syntaxTree->nodekind == DeclarK)
				&& (syntaxTree->kind.declar == FunK))
		{

			inFunction = syntaxTree;
			++scopeDepth;
		}


		if ((syntaxTree->nodekind == StmtK)
				&& (syntaxTree->kind.stmt == CompK))
		{

			++scopeDepth;
		}

		if ((syntaxTree->nodekind == ExpK) && (syntaxTree->kind.exp == IdK))
		{

			temp = lookupSymbol(syntaxTree->name);
			if (temp == NULL)
			{

				fprintf(listing,"error : undeclared variable %s at line %d\n",syntaxTree->name,syntaxTree->lineno);

			}
			else
			{

				//	syntaxTree->declaration = temp->declaration;
			}		 
		}

		if((syntaxTree->nodekind ==StmtK)&&(syntaxTree->kind.stmt==CallK))
		{

			temp = lookupSymbol(syntaxTree->name);
			if (temp == NULL)
			{

				fprintf(listing,"error : undeclared function %s at line %d\n",syntaxTree->name,syntaxTree->lineno);

			}
			else
			{
				//  syntaxTree->declaration = temp->declaration;	

			}

		}



		if ((syntaxTree->nodekind == StmtK) && (syntaxTree->kind.stmt == ReturnK))
		{
			// syntaxTree->declaration = inFunction;


		}

		for (i=0; i < MAXCHILDREN; ++i)
			prebuildsym(syntaxTree->child[i]);

		if(((syntaxTree->nodekind == StmtK)&&(syntaxTree->kind.stmt==CompK))||((syntaxTree->nodekind==DeclarK)&&(syntaxTree->kind.declar==FunK)))
		{

			if(TraceAnalyze) 
			{
				//   printSymTab(scopeDepth,inFunction);

			}
			deletescope();
			--scopeDepth;

		}

		syntaxTree = syntaxTree->sibling;
	}

}

void buildSymtab2(TreeNode* syntaxTree)
{
	int         i;         
	BucketList  temp;  
	static TreeNode *inFunction = NULL;

	while (syntaxTree != NULL)
	{

		if (syntaxTree->nodekind == DeclarK)
		{

			if(((syntaxTree->kind.declar == VarK)&&(syntaxTree->type==Void))||((syntaxTree->kind.declar==VararrayK)&&(syntaxTree->type==Void)))
			{
				//         printf("error variable or variable array  type cannot be void \n");  
			}
			else
				insertSymbol(syntaxTree->name, syntaxTree, syntaxTree->lineno);

		} 
		if (syntaxTree->nodekind == ParamK)
		{

			if(syntaxTree->type!=Void)
			{

				insertSymbol(syntaxTree->name,syntaxTree,syntaxTree->lineno);
				if(TraceAnalyze)
					switch(syntaxTree->kind.param)
					{
						case  Param :
							printf("%s              Integer\n",syntaxTree->name);
							break;

						case ParamarrayK:
							printf("%s              IntegerArray\n",syntaxTree->name);
							break;

					}

			}
			else
			{
				if(TraceAnalyze)
					printf("Void                Void \n");
			}

		}
		if ((syntaxTree->nodekind == DeclarK)
				&& (syntaxTree->kind.declar == FunK))
		{

			if(TraceAnalyze) 
			{
				printf("\n\n");
				printf("<Function Declaration>\n");
				printf("Function Name      Data type \n");
				switch(syntaxTree->type)
				{
					case Void:
						printf("%s                Void  \n",syntaxTree->name);
						break;

					case Integer:
						printf("%s                Integer  \n",syntaxTree->name);
						break;
				}
				printf("Function parameters      Data type \n");
			}                   
			inFunction = syntaxTree;
			++scopeDepth;
		}


		if ((syntaxTree->nodekind == StmtK)
				&& (syntaxTree->kind.stmt == CompK))
		{

			++scopeDepth;
		}

		if ((syntaxTree->nodekind == ExpK) && (syntaxTree->kind.exp == IdK))
		{

			temp = lookupSymbol(syntaxTree->name);
			if (temp == NULL)
			{

				//		fprintf(listing,"error : undeclared variable %s at line %d\n",syntaxTree->name,syntaxTree->lineno);

			}
			else
			{

				if(debug2) printf("Id at line %d : %s declaration at line %d : %s\n",syntaxTree->lineno,syntaxTree->name,temp->declaration->lineno,temp->declaration->name);
				syntaxTree->declaration = temp->declaration;
			}		 
		}

		if((syntaxTree->nodekind ==StmtK)&&(syntaxTree->kind.stmt==CallK))
		{

			temp = lookupSymbol(syntaxTree->name);
			if (temp == NULL)
			{

				//		fprintf(listing,"error : undeclared function %s at line %d\n",syntaxTree->name,syntaxTree->lineno);

			}
			else
			{
				if(debug2) printf("call at line %d : %s declaration at line %d : %s\n",syntaxTree->lineno,syntaxTree->name,temp->declaration->lineno,temp->declaration->name);
				syntaxTree->declaration = temp->declaration;	

			}

		}



		if ((syntaxTree->nodekind == StmtK) && (syntaxTree->kind.stmt == ReturnK))
		{
			if(debug2) printf("return at line %d : %s declaration at line %d : %s\n",syntaxTree->lineno,syntaxTree->name,inFunction->lineno,inFunction->name);
			syntaxTree->declaration = inFunction;


		}

		for (i=0; i < MAXCHILDREN; ++i)
			buildSymtab2(syntaxTree->child[i]);

		if(((syntaxTree->nodekind == StmtK)&&(syntaxTree->kind.stmt==CompK))||((syntaxTree->nodekind==DeclarK)&&(syntaxTree->kind.declar==FunK)))
		{

			if(TraceAnalyze) 
			{
				printSymTab(scopeDepth,inFunction);

			}
			deletescope();
			--scopeDepth;

		}

		syntaxTree = syntaxTree->sibling;
	}

}

void predefined()
{
	TreeNode * input;
	TreeNode * output;
	TreeNode * temp;

	input = newDeclarNode(FunK);
	input->name = copyString("input");
	input->type = Integer;
	input->expressiontype = Function;

	temp = newParamNode(Param);
	temp->name = copyString("arg");
	temp->type = Integer;
	temp->expressiontype = Integer;

	output = newDeclarNode(FunK);
	output->name = copyString("output");
	output->type= Void;
	output->expressiontype = Function;
	output->child[0] = temp;

	insertSymbol("input",input,0);
	insertSymbol("output",output,0);

}


static void typeError(TreeNode * t, char * message)
{ fprintf(listing,"Type error at line %d: %s\n",t->lineno,message);
	Error = TRUE;
}

/* Procedure checkNode performs
 * type checking at a single tree node
 */
static int checkparam(TreeNode* declar,TreeNode * call)
{
	TreeNode* temp;
	TreeNode* temp1;
	if(declar!=NULL)
	{
	temp= declar->child[0];
	}
	if(call!=NULL)
	{
	temp1= call->child[0];
        }

	while((temp!=NULL)&&(temp1!=NULL))
	{
	   
		if(temp->expressiontype!=temp1->expressiontype)
		{
			return 0;
		}
		else
		{
			if(temp) temp = temp->sibling;
			if(temp1) temp1 = temp1->sibling;

		}


	}

	if(((temp==NULL)&&(temp1!=NULL))||((temp!=NULL)&&(temp1==NULL)))
		return 0;

	return 1;

}

static void checkNode(TreeNode * t)
{    
	switch (t->nodekind)
	{
		case DeclarK:
			switch(t->kind.declar)
			{

				case VarK:
					if(debug2) printf("var-declar : %s at line %d\n",t->name,t->lineno);
					t->expressiontype = t->type;
					break;

				case VararrayK:
					if(debug2) printf("vararray-declar : %s at line %d\n",t->name,t->lineno);
					t->expressiontype = Array;
					break;

				case FunK:
					if(debug2) printf("fun-declar : %s at line %d\n",t->name,t->lineno);
					t->expressiontype = Function;
					break;

			}
			break;

		case ParamK:
			switch(t->kind.param)
			{

				case Param:
					if(debug2) printf("param : %s at line %d\n",t->name,t->lineno);
					t->expressiontype = t->type;
					break;

				case ParamarrayK:
					if(debug2) printf("paramarray : %s at line %d \n",t->name,t->lineno);
					t->expressiontype = Array;
					break;

			}
			break;

		case StmtK:

			switch (t->kind.stmt)
			{

				case CallK:
					if(debug2) printf("call %s at line %d\n",t->name,t->lineno);
					if(checkparam(t->declaration,t))
					{

					}
					else
					{
						printf("type error at line %d invalid function call at line \n",t->lineno);
						
					}
                                         if(t->declaration!=NULL)
                                         t->expressiontype = t->declaration->type;
					break;

				case ReturnK:

					if(debug2) printf("return %s at line %d\n",t->name,t->lineno);

					if (t->declaration->type == Integer)
					{
						if(debug2) 
						{ 
							printf("return declarationt type : Integer\n");
							if(t->child[0]==NULL)
							{
								printf("return null \n");
							}
							else
							{


							if(debug2)
							{

							switch(t->child[0]->nodekind)
							{

							case StmtK:
							printf("return call nodekind : stmtK\n");
							break;

							case ExpK:
							printf("return call nodekind : expK\n");
							break;

							case DeclarK:
							printf("return call nodekind : declarK\n");
							break;

							case ParamK:
							printf("return call nodekind : paramK\n");
							break;



							}



							}
 
                                                              

								switch(t->child[0]->expressiontype)
								{
									case Integer:
										printf("return call type : integer\n");
										break;


									case Void:
										printf("return call type : void\n");
										break;


								}
							}



						}

						if ((t->child[0] == NULL)|| (t->child[0]->expressiontype != Integer))
						{
							//`if(debug2) printf("declaration %s, call %s\n",t->declaration->name,t->name);

							printf("type error at line %d return type inconsistence \n",t->lineno);
						}
					}
					else if (t->declaration->type == Void)
					{
						if(debug2) 
						{ 
							printf("return declarationt type : Void\n");

						}

						if (t->child[0] != NULL)
						{
							printf("type error at line %d return type inconsistence \n",t->lineno);
						}

						break;
			                }


						case CompK:


						t->expressiontype = Void;

						break;
					


			}
			break; 

		case ExpK:

			switch (t->kind.exp)
			{
				case OpK:
					if ((t->op == PLUS) || (t->op == MINUS) ||
							(t->op== TIMES) || (t->op== OVER))
					{
						
						if(debug2) printf("operation +,-,*,/ at line %d \n",t->lineno);

						if ((t->child[0]->expressiontype == Integer) &&
						(t->child[1]->expressiontype == Integer))
						{
							t->expressiontype = Integer;
						}
						else
						{
							printf("type error at line %d lvalue and rvalue inconsistence \n",t->lineno);
						}
					}
					else if ((t->op == GREATER) || (t->op == GREATEREQ) ||
							(t->op == LESS) || (t->op ==LESSEQ) ||
							(t->op == EQ) || (t->op == NOTEQ))
					{
						
						if(debug2) printf("operation < <= > >= == != at line %d \n",t->lineno);

						if ((t->child[0]->expressiontype == Integer) &&
								(t->child[1]->expressiontype == Integer))
							t->expressiontype = Integer;
						else
						{
							printf("type error at line %d lavlue and ravlue inconsistence\n",t->lineno);
						}
					}

					break;
				case IdK:

                                        if(debug2) printf("id : %s at line %d\n",t->declaration->name,t->lineno);

					if (t->declaration->expressiontype == Integer)
					{

					if(debug2) printf("declaration type : Integer\n");

						if (t->child[0] == NULL)
							t->expressiontype = Integer;
						else
						{
							printf("type error at line %d assign error\n");
						}
					}
					else if (t->declaration->expressiontype == Array)
					{

					if(debug2) printf("declaration type : array\n");

						if (t->child[0] == NULL)
							t->expressiontype = Array;
						else
						{
							if (t->child[0]->expressiontype == Integer)
								t->expressiontype = Integer;
							else
							{
								printf("type error at line %d assign error\n");
							}
						}
					}
					else
					{
						printf("type error at line %d assign error\n");
					}

					break;




				case ConstK:
                                        if(debug2) printf("const at line %d \n",t->lineno);
					t->expressiontype = Integer;

					break;

				case AssignK:
				        if(debug2) printf("assign at line %d \n",t->lineno);

					if ((t->child[0]->expressiontype == Integer) &&
							(t->child[1]->expressiontype == Integer))
					{

						t->expressiontype = Integer;
					}
					else
					{

						printf("type error at line %d assign error \n",t->lineno);
					}

					break;	    
			}

			break; 
		default : 
			break;


	}    
}



