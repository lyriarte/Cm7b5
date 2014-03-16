all : rpn

rpn : rpn.c lex.yy.c definitions.h
	gcc -o $@ rpn.c lex.yy.c

lex.yy.c : tokenizer.l
	lex tokenizer.l

clean :
	rm *.yy.*
