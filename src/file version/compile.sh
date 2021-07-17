#!/bin/bash

yacc -d cloudian.y
lex cloudian.l
gcc -o exe lex.yy.c y.tab.c