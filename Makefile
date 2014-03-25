all : compiler

compiler : lex.yy.c y.tab.c x86.c
	gcc -o $@ lex.yy.c y.tab.c x86.c

lex.yy.c : tokenizer.l
	lex tokenizer.l

y.tab.c : parser.y
	yacc -d parser.y

clean :
	rm *.yy.* y.tab.*
