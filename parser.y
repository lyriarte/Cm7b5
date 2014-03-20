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

%token <integer> INT

%%

S			: EXPRESSION	
	{
		return(0);
	}
;

EXPRESSION	: TERM
			| EXPRESSION '+' TERM 	
	{
		printf(" +");
	}
			| EXPRESSION '-' TERM 	
	{
		printf(" -");
	}
;

TERM			: FACTOR
			| TERM '*' FACTOR 	
	{
		printf(" *");
	}
			| TERM '/' FACTOR 	
	{
		printf(" /");
	}
;

FACTOR		: INT
	{
		printf(" %d",$1);
	}
;

%%

main()
{
	yyparse();
}
