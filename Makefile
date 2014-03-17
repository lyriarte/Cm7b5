all : recursive

recursive : recursive.c lex.yy.c definitions.h
	gcc -o $@ recursive.c lex.yy.c

lex.yy.c : tokenizer.l
	lex tokenizer.l

clean :
	rm *.yy.*
