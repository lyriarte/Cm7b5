all : tokenizer

tokenizer : lex.yy.c
	gcc -o $@ lex.yy.c

lex.yy.c : tokenizer.l
	lex tokenizer.l

clean :
	rm *.yy.*
