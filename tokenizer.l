%{
#include <stdio.h>
#include "definitions.h"
%}


%%

[0-9]+		{
				sscanf(yytext,"%d",&yylval.integer);
				return(INT);
			}

[\+\-\*\/]	{
				return(*yytext);
			}

[ \t\n]+		;

.			{
				yyerror(yytext);
				return 0;
			}

%%

YYSTYPE yylval;

void yyerror(char *s) {
	printf("error: %s\n",s);
}

int yywrap(void) {
    return 1;
}

int main(void) {
	int token;
	while(token = yylex()) {
		if (token == INT)
			printf("integer: %d\n", yylval.integer);
		else
			printf("operator: %c\n", (char) token);
	}
	return 0;
}
