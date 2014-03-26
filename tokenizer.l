%{
#include "y.tab.h"
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
				return 0;
			}

%%
