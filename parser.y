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
}

%token INT

%%

S			: EXPRESSION	
	{
		return(0);
	}
;

EXPRESSION	: TERM
			| EXPRESSION '+' TERM 	
			| EXPRESSION '-' TERM 	
;

TERM			: FACTOR
			| TERM '*' FACTOR 	
			| TERM '/' FACTOR 	
;

FACTOR		: INT
			| '(' EXPRESSION ')'
;

%%

main()
{
	yyparse();
}
