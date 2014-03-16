all : parser

parser : lex.yy.c y.tab.c
	gcc -o $@ lex.yy.c y.tab.c

lex.yy.c : tokenizer.l
	lex tokenizer.l

y.tab.c : parser.y
	yacc -d parser.y

clean :
	rm *.yy.* y.tab.*
