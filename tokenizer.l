%{
#include <stdio.h>

#define INT 257

void yyerror(char *);
%}


%%

[0-9]+		{
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


void yyerror(char *s) {
	printf("error: %s\n",s);
}

int yywrap(void) {
    return 1;
}

int main(void) {
	int token;
	while(token = yylex()) {
		printf("token: %d, text: %s\n", token, yytext);
	}
	return 0;
}
