%{
#include "y.tab.h"
%}


%%

[0-9]+		{
				sscanf(yytext,"%d",&yylval.integer);
				return(INT);
			}

[a-zA-Z_][0-9a-zA-Z_]* {
				return(IDENT);
			}

[\+\-\*\/\(\)\=]	{
				return(*yytext);
			}

[ \t\n]+		;

.			{
				return 0;
			}

%%
