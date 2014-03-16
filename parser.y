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
%type <integer> EXPRESSION TERM FACTOR

%%

S			: EXPRESSION	
	{
		printf("%d\n",$1);
		return(0);
	}
;

EXPRESSION	: TERM
	{
		$$ = $1;
	}
			| EXPRESSION '+' TERM 	
	{
		$$ = $1 + $3;
	}
			| EXPRESSION '-' TERM 	
	{
		$$ = $1 - $3;
	}
;

TERM			: FACTOR
	{
		$$ = $1;
	}
			| TERM '*' FACTOR 	
	{
		$$ = $1 * $3;
	}
			| TERM '/' FACTOR 	
	{
		$$ = $1 / $3;
	}
;

FACTOR		: INT
	{
		$$ = $1;
	}
;

%%

main()
{
	yyparse();
}
