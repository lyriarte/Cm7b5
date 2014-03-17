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
int EXPRESSION() {
	if (TERM())
		return -1;
	if (!token)
		return 0;
	if (lookahead('+')) {
		return EXPRESSION();
	}
	if (lookahead('-')) {
		return EXPRESSION();
	}
	return -1;
}


/*
TERM			: FACTOR
			| FACTOR '*' TERM 	
			| FACTOR '/' TERM 	
*/
int TERM() {
	if (FACTOR())
		return -1;
	if (!token)
		return 0;
	if (lookahead('*')) {
		return TERM();
	}
	if (lookahead('/')) {
		return TERM();
	}
	return 0;
}



/*
FACTOR		: INT
*/
int FACTOR() {
	if (lookahead(INT)) {
		return 0;
	}
	return -1;
}

int main(void) {
	int err;
	token = yylex();
	err = EXPRESSION();
	if (err)
		yyerror("parse error");
	return 0;
}
