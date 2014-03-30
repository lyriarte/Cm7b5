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
