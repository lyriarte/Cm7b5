%{
#include <stdio.h>

void yyerror(char *s) {
	printf("error: %s\n",s);
}

int yywrap(void) {
	return 1;
}
%}

%union {
  int integer;
  char * identifier;
}

%token <integer> INT
%token IDENT

%%

S			: STATEMENT	
	{
		return(0);
	}
;

STATEMENT	: ';'
			| ASSIGNMENT ';'
			| '{' STATEMENT_LIST '}'

STATEMENT_LIST : STATEMENT
			| STATEMENT_LIST STATEMENT

ASSIGNMENT	: IDENT '=' EXPRESSION

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
			| '(' EXPRESSION ')'
			| '-' FACTOR
	{
		gen_negative();
	}
;

%%
