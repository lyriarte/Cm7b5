#include <stdio.h>
#include "definitions.h"

YYSTYPE yylval;

void yyerror(char *s) {
	printf("error: %s\n",s);
}

int yywrap(void) {
	return 1;
}

int token;

int lookahead(int match) {
	if (token != match)
		return 0;
	token = yylex();
	return 1;	
}

/*
EXPRESSION	: TERM
			| TERM '+' EXPRESSION 	
			| TERM '-' EXPRESSION 	
*/
int EXPRESSION(int * result) {
	int err = -1;
	int right;
	if (TERM(result))
		return -1;
	if (!token)
		return 0;
	if (lookahead('+')) {
		if (!(err = EXPRESSION(&right)))
			*result += right;
	}
	if (lookahead('-')) {
		if (!(err = EXPRESSION(&right)))
			*result -= right;
	}
	return err;
}


/*
TERM			: FACTOR
			| FACTOR '*' TERM 	
			| FACTOR '/' TERM 	
*/
int TERM(int * result) {
	int err = 0;
	int right;
	if (FACTOR(result))
		return -1;
	if (!token)
		return 0;
	if (lookahead('*')) {
		if (!(err = TERM(&right)))
			*result *= right;
	}
	if (lookahead('/')) {
		if (!(err = TERM(&right)))
			*result /= right;
	}
	return err;
}



/*
FACTOR		: INT
*/
int FACTOR(int * result) {
	if (lookahead(INT)) {
		*result = yylval.integer;
		return 0;
	}
	return -1;
}

int main(void) {
	int err;
	int result;
	token = yylex();
	err = EXPRESSION(&result);
	if (err)
		yyerror("parse error");
	else
		printf("%d\n",result);
	return 0;
}
