
Cm7b5
=====

The half diminished C compiler tutorial.

  * Lex - based tokenizer
  * RPN calculator
  * Recursive descent expression calculator
  * Yacc - based expression calculator
  * x86 assembly overview
  * Code generation for a stack machine
  * global int 32 variables
  * loops
  * if then else
  * Functions call convention


Compiling toolchain
===================

	+------------------+          +------------------+
	|                  | -------> |                  |
	|      Editor      |          |  Source code   __/
	|                  | <------- |             __/
	+------------------+          \____________/
	                                     |
	                                     v
	+------------------+          +------------------+
	|                  | <------- |                  |
	| Assembly code  __/          |     Compiler     |
	|             __/             |                  |
	\____________/                +------------------+
	       |
	       v
	+------------------+          +------------------+
	|                  |          |                  |
	|    Assembler     | -------> |  Object file   __/
	|                  |          |             __/
	+------------------+          \____________/
	                                     |
	                                     v
	+------------------+          +------------------+
	|                  |          |                  |
	|    Executable    | <------- |      Linker      |
	|                  |          |                  |
	+------------------+          +------------------+


Compiler components
===================

### One pass compiler

	+------------------+          +------------------+
	|                  | -------> |                  |
	|   Source code  __/          | Lexical Analyzer |
	|             __/             |                  |
	\____________/                +------------------+
	                                     |
	                                     v
	+------------------+          +------------------+
	|    Syntactic     |          |                  |
	| analyser / Code  | <------- |    Tokens      __/
	|    generator     |          |             __/
	+------------------+          \____________/
	       |
	       v
	+------------------+
	|                  |
	| Assembly code  __/
	|             __/
	\____________/

### Multi pass compiler

	+------------------+          +------------------+
	|                  | -------> |                  |
	|   Source code  __/          | Lexical Analyzer |
	|             __/             |                  |
	\____________/                +------------------+
	                                     |
	                                     v
	+------------------+          +------------------+
	|    Syntactic     |          |                  |
	|    analyser      | <------- |    Tokens      __/
	|                  |          |             __/
	+------------------+          \____________/
	       |
	       v
	+------------------+          +------------------+
	|                  | -------> |                  |
	|   Parse tree   __/ <------- |  Code generator  |
	|             __/             |                  |
	\____________/                +------------------+
	                                     |
	                                     v
	                              +------------------+
	                              |                  |
	                              | Assembly code  __/
	                              |             __/
	                              \____________/


String tokenizer
================

A String tokenizer is the part of a compiler that performs lexical analysis. 

  * Match regular expressions in a text.
  * Return text content associated with the regexp.

### Bare-bones parser
	git checkout tokenizer
	cat tokenizer.l

## Lex-based number tokenizer
	git checkout tokenizer
	git clean -f
	make
	echo "123 * + 456 -" | ./tokenizer

The parser outputs an error for the first non-recognised character.

	echo "123 hello" | ./tokenizer


RPN calculator
==============

## Reverse Polish Notation
RPN, or postfix notation, is a mathematical notation where the operator follows its operands.
  * Can be evaluated without parenthesis as long as arity is fixed.
  * Well fitted for stack-based machines.

Infix notation:

	(123 - 5 * 4 - 3) / 4

Postfix rpn equivalent:

	123 5 4 * - 3 - 4 /

### Bare-bones parser
	git checkout simple_rpn
	cat rpn.c

## Lex-based RPN calculator
	git checkout rpn
	git clean -f
	make
	echo "123 5 4 * - 3 - 4 /" | ./rpn

Semantic errors may cause a stack underflow.


Recursive descent expression calculator
=======================================

## LL(1) grammar
  * Read input from left to right
  * Leftmost derivation

### Bare-bones parser
	git checkout simple_expression_parser_recursive
	cat recursive.c

Example expression:

	a + b + c

Parse tree:

	  +
	 / \
	a   +
	   / \
	  b   c

## Right-recursive expression calculator
	git checkout recursive
	git clean -f
	make
	echo "(123 - 5 * 4 - 3) / 4" | ./recursive

Explicit parenthesis are needed to get a correct interpretation.

	echo "((123 - 5 * 4) - 3) / 4" | ./recursive

Supporting left recursion with a recursive parser is possible by building a parse tree and re-parenting the nodes.


Yacc - based expression calculator
==================================

## LR grammar
  * Read input from left to right
  * Rightmost derivation

### Bare-bones parser
	git checkout simple_expression_parser
	cat parser.y

Example expression:

	a + b + c

Parse tree:

	    +
	   / \
	  +   a
	 / \
	b   c

## Left-recursive expression calculator
	git checkout interpreter
	git clean -f
	make
	echo "(123 - 5 * 4 - 3) / 4" | ./parser

### Stack automaton
	git checkout yydebug
	git clean -f
	make
	cat y.output
	echo "2 * 3" | ./parser


C subset compiler
=================

A one pass compiler generates assembly "on the fly" code during the syntax analysis phase. 

## x86 32 bit assembly

### Register layout

	<-----------  EAX  ------------->
	                <-----  AX  ---->
	+---------------+-------+-------+
	|               |  AH   |  AL   |
	+---------------+-------+-------+
	31              15       7      0

### Register usage

  * All purpose: EAX, EBX, ECX, EDX, ESI, EDI
  * Stack base: EBP, pointer: ESP

### Example program

Assembly code to dump 32 bit register in hex mode.


## Compiling expressions

Like for a RPN machine, the generated code pops the second operand, then the first operand, does the operation and pushes the result. The second operand is stored in register ebx. The first operand and the operation result are computed in eax then pushed on the stack.

Example expression:

	5 - 3

Generated assembly code:

	push 5
	push 3
	pop ebx
	pop eax
	sub eax, ebx
	push eax

## Branches and labels

### Loops

	Begin:
	^      +-----+
	|     /       \
	|    /         \
	|   | Condition |-- false --+
	|    \         /            |
	|     \       /             |
	|      +-----+              |
	|         |                 |
	|         | true            |
	|         v                 |
	|   +-----------+           |
	|   |           |           |
	|   |   Bloc    |           |
	|   |           |           |
	|   +-----------+           |
	|         |                 |
	+---------+                 |
	                            |
	    End:   <----------------+

### Conditions

	       +-----+
	      /       \
	     /         \
	    | Condition |-- false --+
	     \         /            |
	      \       /             |
	       +-----+              |
	          |                 |
	          | true            |
	          v                 |
	    +-----------+           |
	    |           |           |
	    |   Bloc    |           |
	    |           |           |
	    +-----------+           |
	          |                 |
	+---------+                 |
	|                           |
	|   End:  +-----------------+
	|         |
	|         v
	|   +-----------+
	|   |           |
	|   |   Bloc    |
	|   |           |
	|   +-----------+
	|         |
	v         v
	Final:

### Calling convention

	+-------------------------------+
	|           variable 2          | <--- EBP - 8
	+-------------------------------+
	|           variable 1          | <--- EBP - 4
	+-------------------------------+
	|            saved EBP          | <--- EBP
	+-------------------------------+
	|         return address        |
	+-------------------------------+
	|           argument 1          | <--- EBP + 8
	+-------------------------------+
	|           argument 2          | <--- EBP + 12
	+-------------------------------+
	|           argument 3          | <--- EBP + 16
	+-------------------------------+
