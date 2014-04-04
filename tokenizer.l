%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}


%%

int			{
				return(TYPE_INT);
			}

while		{
				return(WHILE);
			}

if			{
				return(IF);
			}

else		{
				return(ELSE);
			}

[0-9]+		{
				sscanf(yytext,"%d",&yylval.integer);
				return(INT);
			}

[a-zA-Z_][0-9a-zA-Z_]* {
				yylval.identifier = strdup(yytext);
				return(IDENT);
			}

\=\=			{
				return(EQ);
			}

\!\=			{
				return(NE);
			}

\<\=			{
				return(LE);
			}

\>\=			{
				return(GE);
			}

[\+\-\*\/\(\)\=\;\{\}\<\>]	{
				return(*yytext);
			}

[ \t\n]+		;

.			{
				return 0;
			}

%%
