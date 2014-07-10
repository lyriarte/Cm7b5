%{
#include <stdio.h>

void yyerror(char *s) {
	printf("error: %s\n",s);
}

int yywrap(void) {
	return 1;
}

int jmpstack[64];
int jmptop = -1;
int jmpcnt = 0;
%}

%union {
  int integer;
  char * identifier;
}

%token <integer> INT
%token <identifier> IDENT
%token TYPE_INT
%token EQ NE LE GE
%token WHILE
%token IF ELSE
%token RETURN
%type <identifier> VARIABLE
%type <integer> EXPRESSION_LIST

%%

S			: FUNCTION_LIST
	{
		return(0);
	}
;

FUNCTION		: FUNC_DECL ')' BLOC
	{
		end_func();
	}
			| FUNC_DECL VARIABLE_LIST ')' BLOC
	{
		end_func();
	}

FUNC_DECL	: TYPE_INT IDENT '('
	{
		begin_func($2);
	}

FUNCTION_LIST : FUNCTION
			| FUNCTION_LIST FUNCTION

BLOC			: '{' '}'
			| '{' STATEMENT_LIST '}'
			| '{' DECLARATION_LIST '}'
			| '{' DECLARATION_LIST STATEMENT_LIST '}'

DECLARATION	: VARIABLE ';'
	{
		declare_intvar($1);
	}

DECLARATION_LIST : DECLARATION
			| DECLARATION_LIST DECLARATION

STATEMENT	: ';'
			| ASSIGNMENT ';'
			| FUNC_CALL ';'
			| RETURN EXPRESSION ';'
	{
		gen_return();
	}
			| WHILE_BEGIN '(' CONDITION ')' BLOC
	{
		gen_jmp("begin", jmpstack[jmptop]);
		gen_label("end", jmpstack[jmptop--]);
	}
			| IF_BEGIN '(' CONDITION ')' BLOC
	{
		gen_label("end", jmpstack[jmptop--]);
	}
			| IF_COND_BLOC_ELSE BLOC
	{
		gen_label("final", jmpstack[jmptop--]);
	}

WHILE_BEGIN	: WHILE
	{
		jmpstack[++jmptop] = ++jmpcnt;
		gen_label("begin", jmpstack[jmptop]);
	}

IF_BEGIN	: IF
	{
		jmpstack[++jmptop] = ++jmpcnt;
	}

IF_COND_BLOC_ELSE	: IF_BEGIN '(' CONDITION ')' BLOC ELSE
	{
		gen_jmp("final", jmpstack[jmptop]);
		gen_label("end", jmpstack[jmptop]);
	}

STATEMENT_LIST : STATEMENT
			| STATEMENT_LIST STATEMENT
			
CONDITION	: EXPRESSION
	{
		gen_jmpcond32(0  , "end", jmpstack[jmptop]);
	}
			| EXPRESSION EQ  EXPRESSION
	{
		gen_jmpcond32(NE , "end", jmpstack[jmptop]);
	}
			| EXPRESSION NE  EXPRESSION
	{
		gen_jmpcond32(EQ , "end", jmpstack[jmptop]);
	}
			| EXPRESSION LE  EXPRESSION
	{
		gen_jmpcond32('>', "end", jmpstack[jmptop]);
	}
			| EXPRESSION GE  EXPRESSION
	{
		gen_jmpcond32('<', "end", jmpstack[jmptop]);
	}
			| EXPRESSION '<' EXPRESSION
	{
		gen_jmpcond32(GE , "end", jmpstack[jmptop]);
	}
			| EXPRESSION '>' EXPRESSION
	{
		gen_jmpcond32(LE , "end", jmpstack[jmptop]);
	}

VARIABLE	: TYPE_INT IDENT
	{
		$$ = $2;
	}

VARIABLE_LIST : VARIABLE
	{
		declare_intarg($1);
	}
			| VARIABLE_LIST ',' VARIABLE
	{
		declare_intarg($3);
	}
			
ASSIGNMENT	: IDENT '=' EXPRESSION
	{
		assign_intvar($1);
	}

FUNC_CALL	: IDENT '(' ')'
	{
		gen_call($1, 0);
	}
			| IDENT '(' EXPRESSION_LIST ')' 	
	{
		gen_call($1, $3);
	}

EXPRESSION_LIST : EXPRESSION
	{
		$$ = 1;
	}
			| EXPRESSION_LIST ',' EXPRESSION
	{
		$$ = 1 + $1;
	}

EXPRESSION	: TERM
			| EXPRESSION '+' TERM 	
	{
		gen_op32('+');
	}
			| EXPRESSION '-' TERM 	
	{
		gen_op32('-');
	}
;

TERM			: FACTOR
			| TERM '*' FACTOR 	
	{
		gen_op32('*');
	}
			| TERM '/' FACTOR 	
	{
		gen_op32('/');
	}
;

FACTOR		: INT
	{
		gen_int($1);
	}
			| IDENT
	{
		gen_intvar($1);
	}
			| FUNC_CALL
	{
		gen_callresult();
	}
			| '(' EXPRESSION ')'
			| '-' FACTOR
	{
		gen_negative();
	}
;

%%
