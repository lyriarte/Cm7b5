%{
#include <stdio.h>
#include "definitions.h"
%}


%%

[0-9]+		{
				sscanf(yytext,"%d",&yylval.integer);
				return(INT);
			}

[\+\-\*\/\(\)]	{
				return(*yytext);
			}

[ \t\n]+		;

.			{
				yyerror(yytext);
				return 0;
			}

%%
