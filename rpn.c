#include <stdio.h>
#include "definitions.h"

#define STACK_SIZE 1024

YYSTYPE yylval;

void yyerror(char *s) {
	printf("error: %s\n",s);
}

int yywrap(void) {
    return 1;
}

int main(void) {
	int stack[STACK_SIZE];
	int sp = 0;
	int token;
	while(token = yylex()) {
		if (token == INT)
			stack[sp++] = yylval.integer;
		else {
			--sp;
			switch (token) {
				case '+':
					stack[sp-1] += stack[sp];
					break;
				case '-':
					stack[sp-1] -= stack[sp];
					break;
				case '*':
					stack[sp-1] *= stack[sp];
					break;
				case '/':
					stack[sp-1] /= stack[sp];
					break;
			}
		}
	}
	printf("%d\n",stack[--sp]);
	return 0;
}
