/****************************************************/
/* File: tiny.l                                     */
/* Lex specification for TINY                       */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%

"if"            {return IF;}
"else"          {return ELSE;}
"int"          {return INT;}
"return"           {return RETURN;}
"void"        {return VOID;}
"while"         {return WHILE;}
"+"            {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"<"             {return LESS;}
"<="             {return LESSEQ;}
">"             {return GREATER;}
">="             {return GREATEREQ;}
"=="             {return EQ;}
"!="             {return NOTEQ;}
"="              {return ASSIGN;}
";"              {return SEMI;}
","              {return COMMA;}
"("              {return LPAREN;}
")"              {return RPAREN;}
"["              {return SLBRACKET;}
"]"              {return SRBRACKET;}
"{"              {return LBRACKET;}
"}"              {return RBRACKET;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"/*"             {
                   
		   char c='a';
                   int breaknum=1;
		   int returnvalue=0;
		  do
                  { /*c = input();*/
                   
		    
		    if (c == EOF) break;
                    if (c == '\n') lineno++;
                    char c2;
		    
		    
		    do
		    {

                     if(returnvalue==0)
		     {
                     c2 = input();
		     }
		    if (c2 == EOF) 
		    {
		    breaknum =0;
		    break;
                    }
		    if (c2 == '\n') lineno++;
		    }while (c2 !='*');

                    if(breaknum==0)
		    break;
		    
                    c = input();
                    if(c =='*')
		    {
		    c2 = '*';
		    returnvalue=1;
		    }
		    else
		    {
                    returnvalue=0;
		    }
                  } while (c != '/');
               
		}
.               {return ERROR;}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = listing;
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  if (0) {
    fprintf(listing,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  }
  return currentToken;
}

