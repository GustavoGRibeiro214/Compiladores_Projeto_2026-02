
%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *s);

%}

%token INT FLOAT ID INT_NUMBER FLOAT_NUMBER
%token IF ELSE WHILE PRINT READ
%token PLUS MINUS MULT DIV MOD
%token ATTRIBUTION AND OR NOT RELOP
%token SEMI COMMA
%token OPEN_PARENTHESES CLOSE_PARENTHESES
%token OPEN_BRACES CLOSE_BRACES

%%

/*Declaração de tipos*/

declaracao : decl
	   | declaracao decl
	   ;
 
decl : type ID list
     /*Atribuição junto ao tipo*/
     | type ID attri
     /*Atribuição depois da definição do tipo*/      
     | ID attri
     /*Encontra o erro mas não para o programa*/
     | error SEMI { yyerrok; }

     ;

/*Atribuição*/
attri : ATTRIBUTION expr SEMI
     ;

expr : 

/*condicionais*/

cond : IF OPEN_PARENTHESES CLOSE_PARENTHESES

type : INT | FLOAT
     ;

list : COMMA ID list
     | SEMI
     ;

%%