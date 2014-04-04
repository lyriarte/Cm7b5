%{
#include <stdio.h>

void yyerror(char *s) {
	printf("error: %s\n",s);
}

int yywrap(void) {
	return 1;
}

int jmpstack[64];
int jmptop = -1;
int jmpcnt = 0;
%}

%union {
  int integer;
  char * identifier;
}

%token <integer> INT
%token <identifier> IDENT
%token TYPE_INT
%token EQ NE LE GE
%token WHILE
%token IF ELSE

%%

S			: BLOC	
	{
		return(0);
	}
;

BLOC			: '{' '}'
			| '{' STATEMENT_LIST '}'
			| '{' DECLARATION_LIST '}'
			| '{' DECLARATION_LIST STATEMENT_LIST '}'

DECLARATION	: VARIABLE ';'

DECLARATION_LIST : DECLARATION
			| DECLARATION_LIST DECLARATION

STATEMENT	: ';'
			| ASSIGNMENT ';'
			| WHILE_BEGIN '(' CONDITION ')' BLOC
	{
		gen_jmp("begin", jmpstack[jmptop]);
		gen_label("end", jmpstack[jmptop--]);
	}
			| IF '(' CONDITION ')' BLOC
			| IF '(' CONDITION ')' BLOC ELSE BLOC
			
WHILE_BEGIN	: WHILE
	{
		jmpstack[++jmptop] = ++jmpcnt;
		gen_label("begin", jmpstack[jmptop]);
	}

STATEMENT_LIST : STATEMENT
			| STATEMENT_LIST STATEMENT
			
CONDITION	: EXPRESSION
	{
		gen_jmpcond32(0  , "end", jmpstack[jmptop]);
	}
			| EXPRESSION EQ  EXPRESSION
	{
		gen_jmpcond32(NE , "end", jmpstack[jmptop]);
	}
			| EXPRESSION NE  EXPRESSION
	{
		gen_jmpcond32(EQ , "end", jmpstack[jmptop]);
	}
			| EXPRESSION LE  EXPRESSION
	{
		gen_jmpcond32('>', "end", jmpstack[jmptop]);
	}
			| EXPRESSION GE  EXPRESSION
	{
		gen_jmpcond32('<', "end", jmpstack[jmptop]);
	}
			| EXPRESSION '<' EXPRESSION
	{
		gen_jmpcond32(GE , "end", jmpstack[jmptop]);
	}
			| EXPRESSION '>' EXPRESSION
	{
		gen_jmpcond32(LE , "end", jmpstack[jmptop]);
	}

VARIABLE	: TYPE_INT IDENT
	{
		declare_intvar($2);
	}


ASSIGNMENT	: IDENT '=' EXPRESSION
	{
		assign_intvar($1);
	}

EXPRESSION	: TERM
			| EXPRESSION '+' TERM 	
	{
		gen_op32('+');
	}
			| EXPRESSION '-' TERM 	
	{
		gen_op32('-');
	}
;

TERM			: FACTOR
			| TERM '*' FACTOR 	
	{
		gen_op32('*');
	}
			| TERM '/' FACTOR 	
	{
		gen_op32('/');
	}
;

FACTOR		: INT
	{
		gen_int($1);
	}
			| IDENT
	{
		gen_intvar($1);
	}
			| '(' EXPRESSION ')'
			| '-' FACTOR
	{
		gen_negative();
	}
;

%%
