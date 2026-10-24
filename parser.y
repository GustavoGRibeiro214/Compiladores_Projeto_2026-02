
%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *s);

%}

%token INT FLOAT ID INT_NUMBER FLOAT_NUMBER
%token IF ELSE WHILE PRINT READ
%token PLUS MINUS MULT DIV MOD
%token ATTRIBUTION AND OR NOT
%token GT LT GE LE EE NE
%token SEMI COMMA
%token OPEN_PARENTHESES CLOSE_PARENTHESES
%token OPEN_BRACES CLOSE_BRACES

%%

/* Todos os comandos passam por aqui */

comandos : comando
         | comandos comando
         ;

comando : decl
        | condicionais
        ;

/* Declaracoes e atribuicoes */

decl : type ID list
     | type ID ATTRIBUTION attri SEMI
     | ID ATTRIBUTION attri SEMI
     | error SEMI { yyerrok; }
     ;

/* Valores usados nas atribuicoes */

attri : INT_NUMBER
      | FLOAT_NUMBER
      | ID
      ;

/* Blocos de comandos */

bloco : /* vazio */
      | comandos
      ;

/* Condicionais IF e ELSE */

condicionais : IF OPEN_PARENTHESES expr_cond CLOSE_PARENTHESES OPEN_BRACES bloco CLOSE_BRACES
    	     | IF OPEN_PARENTHESES expr_cond CLOSE_PARENTHESES OPEN_BRACES bloco CLOSE_BRACES ELSE OPEN_BRACES bloco CLOSE_BRACES
	     ;

/*EXPRESSÕES CONDICIONAIS servem para a definir as condições no IF/ELSE E WHILE*/
expr_cond : ID relop INT_NUMBER
	  | ID relop FLOAT_NUMBER
	  | ID relop ID
	  ;

/*Operadores Relacionais*/
relop : GT
      | LT
      | GE
      | LE
      | EE
      | NE
      ;

type : INT | FLOAT
     ;

list : COMMA ID list
     | SEMI
     ;

%%