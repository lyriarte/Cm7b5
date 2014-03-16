#define INT 257

typedef union {
  int integer ;
} YYSTYPE;
extern YYSTYPE yylval;

extern void yyerror(char *);
extern int yywrap(void);
extern int yylex(void);
