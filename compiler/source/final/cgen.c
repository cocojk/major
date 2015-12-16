/****************************************************/
/* File: cgen.c                                     */
/* The code generator implementation                */
/* for the TINY compiler                            */
/* (generates code for the TM machine)              */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "symtab.h"
#include "code.h"
#include "cgen.h"
#include "string.h"
/* tmpOffset is the memory offset for temps
   It is decremented each time a temp is
   stored, and incremeted when loaded again
*/
int debug3 =1;
static int tmpOffset = 0;
static int globaloff =0;
static int localoff =1;
static int stackvalue=0;
static int framenum=0;
static int parameternum=0;
/* prototype for internal recursive code generator */
static void cGen (TreeNode * tree);
static void push ();
static void pop ();
static void initglobal(TreeNode * tree);
static void generate(TreeNode* tree);
static void generate2(TreeNode* tree);
static void predefined()
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

	insertSymbol2("input",input,0,0,0,0);
	insertSymbol2("output",output,0,0,0,0);
}



/* Procedure genStmt generates code at a statement node */
static void genStmt( TreeNode * tree)
{ TreeNode * p1, * p2, * p3,*param;
  int savedLoc1,savedLoc2,currentLoc,savedLoc3;
  int loc;
  int i;
  int savedpoint=0;
  BucketList temp,temp1;
  switch (tree->kind.stmt) {

      case IfK :
         emitComment("-> if") ;
         p1 = tree->child[0] ;
         p2 = tree->child[1] ;
         p3 = tree->child[2] ;
         /* generate code for test expression */
         emitComment("if test start");
	 generate(p1);
	 emitComment("if test end");
         savedLoc1 = emitSkip(1) ;
         emitComment("if: jump to else belongs here");
         /* recurse on then part */
	 emitComment("if true start");
         generate(p2);
	 emitComment("if true end");
         savedLoc2 = emitSkip(1) ;
         emitComment("if: jump to end belongs here");
         currentLoc = emitSkip(0) ;
         emitBackup(savedLoc1) ;
         emitRM_Abs("JEQ",ac,currentLoc,"if: jmp to else");
         emitRestore() ;
         /* recurse on else part */
	 emitComment("if false start");
         generate(p3);
	 emitComment("if false end");
         currentLoc = emitSkip(0) ;
         emitBackup(savedLoc2) ;
         emitRM_Abs("LDA",pc,currentLoc,"jmp to end") ;
         emitRestore() ;
          emitComment("<- if") ;
         break; /* if_k */

      case WhileK:
         emitComment("-> while") ;
         p1 = tree->child[0] ;
         p2 = tree->child[1] ;
	emitComment("while test start");
	savedLoc1 = emitSkip(0);
         generate(p1);
	 emitComment("while test end");
	 savedLoc2 = emitSkip(1);
         emitComment("while start");
         generate(p2);
	 emitComment("while end");
	 emitRM("LDA",pc,savedLoc1,5,"return test");
	 currentLoc =emitSkip(0);
	 emitBackup(savedLoc2);
         emitRM_Abs("JEQ",ac,currentLoc,"while : jmp to false");
         emitRestore();
	 emitComment("<- while") ;
         break; 


      case ReturnK:
         p1=tree->child[0];
	 generate(p1);
         break;

      case CompK:
      if(debug3) printf("enter compound\n");
	++scopeDepth;
	p1=tree->child[0];
	p2=tree->child[1];
	generate(p1);
	generate(p2);
	deletescope();
	scopeDepth--;
	break;



      case ExpressK:
      break;

   
      case CallK: 
       if(strcmp(tree->name,"output")==0)
       {
         p1=tree->child[0];
	 generate(p1);
	 emitRO("OUT",ac,0,0,"standard output");
          
	  
       }
       else if(strcmp(tree->name,"input")==0)
       {
         emitRO("IN",ac,0,0,"standard input");


       }
       else
       {

     temp1 =lookupSymbol2(tree->name,framenum);
     if(temp1==NULL)
     {
      printf("lookupsymbol error %s\n",tree->name);
     }
     
     //////////////////////////
      param= tree->declaration->child[0];
      
      int tempparameternum =0;
       p1=tree->child[0];
      p2 = p1->declaration;
      
      if(p2!=NULL)
      {
      switch(p2->kind.declar)
      {
      case VarK:
        temp =lookupSymbol2(p2->name,framenum);
	if(temp!=NULL)
	{

	switch(temp->disting)
	{
	case 0:
	param->isglobal =1;
	param->declaration = p2;
	break;

	case 1:
	param->isglobal=0;
       emitComment("function call use var or fun");
      generate2(p1);
       emitRM("ST",ac,0,sp,"insert parameter ");
       tempparameternum++;
       push();
       break;

	}

	}
	else
	{
	printf("lookup symbol error id %s\n",p2->name);

	}
       break;

      case FunK:
      emitComment("function call use var or fun");
      generate2(p1);
       emitRM("ST",ac,0,sp,"insert parameter ");
       tempparameternum++;
       push();
      break;

      case VararrayK:
       p3 = p1->child[0];

       if(p3==NULL) //use by array like x
       {

       temp = lookupSymbol2(p2->name,framenum);
       
       if(temp!=NULL)
       {
       emitComment("function call use vararray");
       switch(temp->disting)
       {
       case 0:
       param->isglobal =1;
       param->declaration = p2;
    /*   for(i=0;i<p2->val;i++)
       {
       emitRM("LD",ac,temp->offset+i,gp,"load global array at ac");
       emitRM("ST",ac,0,sp,"insert array parameter ");
       tempparameternum++;
       push();
       }*/
       break;

       case 1:
       param->isglobal=0;
       for(i=0;i<p2->val;i++)
       {
       emitRM("LD",ac,temp->offset+i,fp,"load local array at ac");
       emitRM("st",ac,0,sp,"insert array parameter");
       tempparameternum++;
       push();
       }
       break;

       default :
       printf("disting error at line %d\n",193);
       break;
       }

       }
       else
       {
       printf("lookupsymbol error call vararray %s\n",p2->name);

       }

       }
       else //use by integer like x[0]
       {

       temp = lookupSymbol2(p2->name,framenum);
       if(temp!=NULL)
       {
       switch(temp->disting)
       {
       case 0: //global no insert
       param->isglobal=1;
       param->declaration = p2;
       break;

       case 1: //not global
       param->isglobal=0;
       emitComment("functin call use vararray but int like x[0] ");
      generate2(p1);
       emitRM("ST",ac,0,sp,"insert parameter  ");
       tempparameternum++;
       push();
       break;

        }
	}
	else
	{
         printf("lookup symbol error %s \n",p2->name);
	}


       }

      break;
      }

      

      }
      else
      {

        emitComment("no delclration parameter insert");
        generate2(p1);
       emitRM("ST",ac,0,sp,"insert parameter ");
       tempparameternum++;
       push();

      }


       p1=p1->sibling;
       param = param->sibling;
       while(p1!=NULL)
       {
      p2 = p1->declaration;
      
      if(p2!=NULL)
      {
      switch(p2->kind.declar)
      {
      case VarK:
        temp =lookupSymbol2(p2->name,framenum);
	if(temp!=NULL)
	{

	switch(temp->disting)
	{
	case 0:
	param->isglobal=1;
	param->declaration =p2;
	break;

	case 1:
	param->isglobal=0;
      emitComment("function call use var or fun");
      generate2(p1);
       emitRM("ST",ac,0,sp,"insert parameter ");
       tempparameternum++;
       push();
       break;

	}

	}
	else
	{
	printf("lookup symbol error id %s\n",p2->name);
        }
	break;
      case FunK:
      emitComment("function call use var or fun");
      generate2(p1);
       emitRM("ST",ac,0,sp,"insert parameter ");
       tempparameternum++;
       push();
      break;

      case VararrayK:
       p3 = p1->child[0];

       if(p3==NULL) //use by array like x
       {

       temp = lookupSymbol2(p2->name,framenum);
       
       if(temp!=NULL)
       {
       emitComment("function call use vararray");
       switch(temp->disting)
       {
       case 0:
       param->isglobal=1;
       param->declaration =p2;
       /*for(i=0;i<p2->val;i++)
       {
       emitRM("LD",ac,temp->offset+i,gp,"load global array at ac");
       emitRM("ST",ac,0,sp,"insert array parameter ");
       tempparameternum++;
       push();
       }*/
       break;

       case 1:
       param->isglobal=0;
       for(i=0;i<p2->val;i++)
       {
       emitRM("LD",ac,temp->offset+i,fp,"load local array at ac");
       emitRM("ST",ac,0,sp,"insert array parameter");
       tempparameternum++;
       push();
       }
       break;

       default :
       printf("disting error at line %d\n",193);
       break;
       }

       }
       else
       {
       printf("lookupsymbol error call vararray %s\n",p2->name);

       }

       }
       else //use by integer like x[0]
       {
       temp = lookupSymbol2(p2->name,framenum);
       if(temp!=NULL)
       {
       switch(temp->disting)
       {
       case 0: //global no insert
       param->isglobal=1;
       param->declaration =p2;
       break;

       case 1: //not global
       param->isglobal=0;
       emitComment("functin call use vararray but int like x[0] ");
      generate2(p1);
       emitRM("ST",ac,0,sp,"insert parameter  ");
       tempparameternum++;
       push();
       break;

        }
	}
	else
	{
         printf("lookup symbol error %s \n",p2->name);


       }
       }

      break;
      }

      

      }
      else
      {

        emitComment("no delclration parameter insert");
        generate2(p1);
       emitRM("ST",ac,0,sp,"insert parameter ");
       tempparameternum++;
       push();

      }
 
        param = param->sibling;
        p1 = p1->sibling;
       }

      
     if(temp1->calllocation==-1)
     {
    
      savedpoint=emitSkip(0);


       emitRM("ST",fp,0,sp,"save old fp");
       push();
       emitRO("ADD",fp,sp,zp,"sp->fp");
       emitRM("LDC",ac,(tempparameternum+1),0,"parameternum -> ac");
       emitRM("ST",ac,0,sp,"save old sp");
       push();
       //return address ??
       printf("paramter num : %d\n",tempparameternum);
      scopeDepth++;         
       framenum++;
       if(tree->declaration!=NULL)
       {
       parameternum = tempparameternum;
       generate(tree->declaration->child[0]);

      temp1->calllocation = savedpoint;

      generate(tree->declaration->child[1]);
       }
       else
       {
       printf("function call doesn't have declaration\n");
       }

       framenum--;
      deletescope();
      --scopeDepth;
       parameternum=0;

       emitRM("LD",ac1,0,fp,"old sp ->ac");
       emitRO("SUB",sp,fp,ac1,"reset old sp");
       emitRM("LD",fp,-1,fp,"reset old fp");
       

      }
      else
      {

      emitRM("LDC",pc,temp1->calllocation,0,"jmp to defined function");

      }

}
        break;


      default:
         break;
    }
} /* genStmt */

/* Procedure genExp generates code at an expression node */
static void genExp( TreeNode * tree)
{ int loc;
  TreeNode * p1, * p2;
  BucketList temp;
  switch (tree->kind.exp) {

    case ConstK :
      emitComment("-> Const") ;
      /* gen code to load integer constant using LDC */
      emitRM("LDC",ac,tree->val,0,"load const");
      emitComment("<- Const") ;
      break; /* ConstK */
    
    case IdK :
      emitComment("-> Id") ;
      p1 = tree->child[0];
      
      if(p1==NULL)  //id
      {
      temp = lookupSymbol2(tree->name,framenum);
      if(temp!=NULL)
      {
      switch(temp->disting)
      {
      case 0:

      emitRM("LD",ac,temp->offset,gp,"load global id value");
            
      break;

      case 1:
      emitRM("LD",ac,temp->offset,fp,"load local id value");
      
      break;
      
      default:
      break;
      printf("unkwon variable\n");
      }

      }
      else
      {
      printf("lookupsymbol error id %s\n",tree->name);
      }

      emitComment("<- Id") ;
      
      }
      else //idarray
      {
      
      emitComment("-> Idarray") ;
      generate(p1);
      temp = lookupSymbol2(tree->name,framenum);
      if(temp!=NULL)
      {
      switch(temp->disting)
      {
      case 0:
      emitRM("LDC",ac1,temp->offset,0,"load index");
      emitRO("ADD",ac,ac1,ac,"offset + index value");
      emitRO("ADD",ac,ac,gp,"offset + index value + gp");
      emitRM("LD",ac,0,ac,"load global idarray value");
      
      break;

      case 1:
      emitRM("LDC",ac1,temp->offset,0,"load index");
      emitRO("ADD",ac,ac1,ac,"offset + index value");
      emitRO("ADD",ac,ac,fp,"offset + index value + fp");
      emitRM("LD",ac,0,ac,"load global idarray value");
      
      break;
      
      default:
      printf("unkwon variable\n");
      break;
      }

      }
      else
      {
      printf("lookupsymbol error id\n",tree->name);
      }

      emitComment("<- Idarray") ;
      }
      break;

    case OpK :
         if (TraceCode) emitComment("-> Op") ;
         p1 = tree->child[0];
         p2 = tree->child[1];
         /* gen code for ac = left arg */
         generate(p1);
         /* gen code to push left operand */
         emitRM("ST",ac,0,sp,"op: push left");
	 push();
         /* gen code for ac = right operand */
         generate(p2);
         /* now load left operand */
	 pop();
         emitRM("LD",ac1,0,sp,"op: load left");
         switch (tree->op) {
            case PLUS :
               emitRO("ADD",ac,ac1,ac,"op +");
               break;
            case MINUS :
               emitRO("SUB",ac,ac1,ac,"op -");
               break;
            case TIMES :
               emitRO("MUL",ac,ac1,ac,"op *");
               break;
            case OVER :
               emitRO("DIV",ac,ac1,ac,"op /");
               break;
            case LESS :
               emitRO("SUB",ac,ac1,ac,"op <") ;
               emitRM("JLT",ac,2,pc,"br if true") ;
               emitRM("LDC",ac,0,ac,"false case") ;
               emitRM("LDA",pc,1,pc,"unconditional jmp") ;
               emitRM("LDC",ac,1,ac,"true case") ;
               break;

	    case LESSEQ:
               emitRO("SUB",ac,ac1,ac,"op <=") ;
               emitRM("JLE",ac,2,pc,"br if true") ;
               emitRM("LDC",ac,0,ac,"false case") ;
               emitRM("LDA",pc,1,pc,"unconditional jmp") ;
               emitRM("LDC",ac,1,ac,"true case") ;
	       break;

	    case GREATER:
               emitRO("SUB",ac,ac1,ac,"op >") ;
               emitRM("JGT",ac,2,pc,"br if true") ;
               emitRM("LDC",ac,0,ac,"false case") ;
               emitRM("LDA",pc,1,pc,"unconditional jmp") ;
               emitRM("LDC",ac,1,ac,"true case") ;
               break;


	    case GREATEREQ:
               emitRO("SUB",ac,ac1,ac,"op >=") ;
               emitRM("JGE",ac,2,pc,"br if true") ;
               emitRM("LDC",ac,0,ac,"false case") ;
               emitRM("LDA",pc,1,pc,"unconditional jmp") ;
               emitRM("LDC",ac,1,ac,"true case") ;
	       break;

	    case EQ:
               emitRO("SUB",ac,ac1,ac,"op ==") ;
               emitRM("JEQ",ac,2,pc,"br if true");
               emitRM("LDC",ac,0,ac,"false case") ;
               emitRM("LDA",pc,1,pc,"unconditional jmp") ;
               emitRM("LDC",ac,1,ac,"true case") ;
               break;

            case NOTEQ:
                emitRO("SUB",ac,ac1,ac,"op !=");
               emitRM("JNE",ac,2,pc,"br if true");
               emitRM("LDC",ac,0,ac,"false case") ;
               emitRM("LDA",pc,1,pc,"unconditional jmp") ;
               emitRM("LDC",ac,1,ac,"true case") ;
	    break;


	    
            default:
               emitComment("BUG: Unknown operator");
               break;
         } /* case op */
          emitComment("<- Op") ;
         break; /* OpK */

    case AssignK:
    emitComment("-> assign");
    p1 = tree->child[0];
    if(p1!=NULL)
    p1 = p1->child[0];

    if(p1==NULL) //id
    {
    p2 = tree->child[1];
    generate(p2);
      
     p1 = tree->child[0];
     temp = lookupSymbol2(p1->name,framenum);
      if(temp!=NULL)
      {
      switch(temp->disting)
      {
      case 0:
      emitRM("ST",ac,temp->offset,gp,"load global id value");
      
      break;

      case 1:
      emitRM("ST",ac,temp->offset,fp,"load local id value");
      
      break;
      
      default:
      printf("unkwon variable\n");
      break;
      }

      }
      else
      {
      printf("lookupsymbol error id %s \n",p1->name);
      }
    
    }
    else //idarray
    {
    emitComment("idarray in index start");
    generate(p1);
    emitComment("idarray in index end");
    emitRO("ADD",ip,ac,zp,"move ac -> ip");
    emitComment("assign rvalue start");
    p2 = tree->child[1];
    generate(p2);
    emitComment("assign rvalue end");
      
      p1 = tree->child[0];
      temp = lookupSymbol2(p1->name,framenum);
      if(temp!=NULL)
      {
      switch(temp->disting)
      {
      case 0:
      
      emitRM("LDC",ac1,temp->offset,0,"load offset");
      emitRO("ADD",ip,ip,ac1,"load offset+index");
      emitRO("ADD",ip,ip,gp,"load offset+index+gp");
      emitRM("ST",ac,0,ip,"load global idarray value");
      
      break;

      case 1:
      emitRM("LDC",ac1,temp->offset,0,"load offset");
      emitRO("ADD",ip,ip,ac1,"load offset+index");
      emitRO("ADD",ip,ip,fp,"load offset+index+gp");
      emitRM("ST",ac,0,ip,"load local idarray value");
      
      break;
      
      default:
      printf("unkwon variable\n");
      break;
      }

      }
      else
      {
      printf("lookupsymbol error idarray %s \n",p1->name);
      }
    }
    break;

    default:
      break;
  }
} /* genExp */

/* Procedure cGen recursively generates code by
 * tree traversal
 */
static void cGen( TreeNode * syntaxTree)
{ 

clear();
predefined();
initglobal(syntaxTree);

while (syntaxTree != NULL)
  { 
      {
      
      if((syntaxTree->nodekind == DeclarK) &&(syntaxTree->kind.declar ==FunK))
      {
      if(strcmp(syntaxTree->name,"main")==0)
      {
      if(debug3) printf("enter main function\n");
      ++scopeDepth;
      framenum++;
      emitRO("ADD",fp,sp,zp,"move sp -> fp");
      push();
     // generate(syntaxTree->child[0]);
      generate(syntaxTree->child[1]);
      deletescope();
      --scopeDepth;
      }

      }

      
     }
    syntaxTree = syntaxTree->sibling;
  }

}

static void push()
{
//temp use zp 
emitRM("LDC",zp,1,0,"temp use zp for push");
emitRO("ADD",sp,sp,zp,"push stack address");
emitRM("LDC",zp,0,0,"return zp 0");
}

static void pop()
{
//temp use zp
emitRM("LDC",zp,1,0,"temp use zp for pop");
emitRO("SUB",sp,sp,zp,"pop stack address");
emitRM("LDC",zp,0,0,"return zp 0");

}


static void initglobal(TreeNode* syntaxTree)
{

if(syntaxTree!=NULL)
{


		if (syntaxTree->nodekind == DeclarK)
		{

			if(((syntaxTree->kind.declar == VarK)&&(syntaxTree->type==Void))||((syntaxTree->kind.declar==VararrayK)&&(syntaxTree->type==Void)))
			{
				printf("error variable or variable array  type cannot be void \n");  
			}
			else
	         	{
			insertSymbol2(syntaxTree->name, syntaxTree, syntaxTree->lineno,0,globaloff,0);

if(syntaxTree->kind.declar ==VarK)
{
emitRM("LDC",ac,0,0,"global variable store at ac");
emitRM("ST",ac,globaloff,gp,"global variable store at globaloff(gp)");
globaloff++;
push();
}

if(syntaxTree->kind.declar ==VararrayK)
{
int i;
for(i=0;i<syntaxTree->val;i++)
{
emitRM("LDC",ac,0,0,"global variable store at ac");
emitRM("ST",ac,globaloff,gp,"global variable store at globaloff(gp)");
globaloff++;
push();
}

}

                         }

		} 
		


initglobal(syntaxTree->sibling);
}
}

static void genDeclar(TreeNode * tree)
{

int i=0;
if(tree!=NULL)
{

switch(tree->kind.declar)
{
case VarK:
if(debug3) printf("local variable %s insert\n",tree->name);
insertSymbol2(tree->name, tree, tree->lineno,1,localoff,framenum);
emitRM("LDC",ac,0,0,"local variable store at ac");
emitRM("ST",ac,localoff,fp,"local variable store at localoff(fp)");
localoff++;
push();
break;

case VararrayK :
if(debug3) printf("local variable %s insert\n",tree->name);
insertSymbol2(tree->name, tree, tree->lineno,1,localoff,framenum);
for(i=0;i<tree->val;i++)
{
emitRM("LDC",ac,0,0,"local variablearray store at ac");
emitRM("ST",ac,localoff,fp,"local variablearray store at localoff(fp)");
localoff++;
push();
}
break;

default:
break;
}
}

}

static void genParam(TreeNode * tree)
{

int i=0;
BucketList temp;
if(tree!=NULL)
{

switch(tree->kind.param)
{
case Param:
if(debug3) printf("parameter variable %s insert\n",tree->name);
if(tree->isglobal==0)
{
insertSymbol2(tree->name, tree, tree->lineno,1,-(parameternum+1),framenum);
parameternum--;
}
else
{
if(debug3) printf("parameter variable %s insert global\n",tree->name);

temp =lookupSymbol2(tree->declaration->name,framenum);
if(temp!=NULL)
{
insertSymbol2(tree->name,tree,tree->lineno,0,temp->offset,0);
}
else
{
if(debug3) printf("global variable not found in parameter\n");
}

}


break;

case ParamarrayK :
///modify!!
if(tree->isglobal==0)
{
if(debug3) printf("parameterarray variable %s insert\n",tree->name);
insertSymbol2(tree->name, tree, tree->lineno,1,-(parameternum+1),framenum);

for(i=0;i<tree->val;i++)
{
parameternum--;
}

}
else
{
if(debug3) printf("parameterarray  variable %s insert global\n",tree->name);

temp =lookupSymbol2(tree->declaration->name,framenum);
if(temp!=NULL)
{
insertSymbol2(tree->name,tree,tree->lineno,0,temp->offset,0);
}
else
{
if(debug3) printf("global variable not found in parameterarray\n");
}

}
break;

default:
break;
}
}

}

static void generate(TreeNode * tree)
{
if(tree!=NULL)
{
switch(tree->nodekind)
{
case StmtK:
genStmt(tree);
break;

case ExpK:
genExp(tree);
break;

case DeclarK:
genDeclar(tree);
break;

case ParamK:
genParam(tree);
default:
break;
}



generate(tree->sibling);
}
}

static void generate2(TreeNode* tree)
{
if(tree!=NULL)
{
switch(tree->nodekind)
{
case StmtK:
genStmt(tree);
break;

case ExpK:
genExp(tree);
break;

case DeclarK:
genDeclar(tree);
break;

case ParamK:
//genParam(tree);
default:
break;
}
}
}

/**********************************************/
/* the primary function of the code generator */
/**********************************************/
/* Procedure codeGen generates code to a code
 * file by traversal of the syntax tree. The
 * second parameter (codefile) is the file name
 * of the code file, and is used to print the
 * file name as a comment in the code file
 */
void codeGen(TreeNode * syntaxTree, char * codefile)
{  char * s = malloc(strlen(codefile)+7);
   strcpy(s,"File: ");
   strcat(s,codefile);
   emitComment("TINY Compilation to TM Code");
   emitComment(s);
   /* generate standard prelude */
   emitComment("Standard prelude:");
   emitComment("End of standard prelude.");
   /* generate code for TINY program */
   cGen(syntaxTree);
   /* finish */
   emitComment("End of execution.");
   emitRO("HALT",0,0,0,"");
}
