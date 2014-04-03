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

%token INT
%token IDENT
%token TYPE_INT

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

STATEMENT_LIST : STATEMENT
			| STATEMENT_LIST STATEMENT

VARIABLE	: TYPE_INT IDENT

ASSIGNMENT	: IDENT '=' EXPRESSION

EXPRESSION	: TERM
			| EXPRESSION '+' TERM 	
			| EXPRESSION '-' TERM 	
;

TERM			: FACTOR
			| TERM '*' FACTOR 	
			| TERM '/' FACTOR 	
;

FACTOR		: INT
			| IDENT
			| '(' EXPRESSION ')'
			| '-' FACTOR
;

%%

main()
{
	yyparse();
}
