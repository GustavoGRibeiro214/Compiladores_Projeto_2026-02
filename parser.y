
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

/* Precedencia dos Operadores Logicos*/

%left OR
%left AND
%right NOT

/* Precedecia dos Operadores Aritimeticos*/

%left PLUS MINUS
%left MULT DIV MOD
%right UMINUS

%%

/* Todos os comandos passam por aqui */

/* Blocos de comandos */

bloco : /* vazio */
      | comandos
      ;

comandos : comando
         | comandos comando
         ;

comando : decl
        | atrib
        | cond
        | loop
	| OPEN_BRACES bloco CLOSE_BRACES   /* bloco solto entre chaves solto*/
        | error SEMI { yyerrok; }
        ;



/* Declaracoes e atribuicoes */

decl : type ID list_decl SEMI
     ;

list_decl : /* vazio */
          | ATTRIBUTION expr_ari
          | ATTRIBUTION expr_ari COMMA ID list_decl
          | COMMA ID list_decl
          ;

atrib : ID ATTRIBUTION expr_ari SEMI
      ;

/* Valores usados nas atribuicoes */

operando : ID 
	 | INT_NUMBER 
	 | FLOAT_NUMBER 
	 ;


/* Entrada e Saída (Print/Read)*/

io	: PRINT OPEN_PARENTHESES ID CLOSE_PARENTHESES SEMI
	| READ OPEN_PARENTHESES 

/* Condicionais IF e ELSE */

cond : IF OPEN_PARENTHESES expr_cond CLOSE_PARENTHESES OPEN_BRACES bloco CLOSE_BRACES
     /* IF e ELSE casado */
     | IF OPEN_PARENTHESES expr_cond CLOSE_PARENTHESES OPEN_BRACES bloco CLOSE_BRACES ELSE OPEN_BRACES bloco CLOSE_BRACES
     ;


/* Loop while */
loop : WHILE OPEN_PARENTHESES expr_cond CLOSE_PARENTHESES OPEN_BRACES bloco CLOSE_BRACES
     ;

/* EXPRESSÕES CONDICIONAIS servem para a definir as condições no IF/ELSE E WHILE */

expr_cond : expr_cond OR expr_cond
          | expr_cond AND expr_cond
          | NOT expr_cond
          | OPEN_PARENTHESES expr_cond CLOSE_PARENTHESES
	  /* Comparação entre calculos aritimeticos EX: (1+x >= 4-y) */
          | expr_ari relop expr_ari
          ;

/* Aritimetica */

expr_ari : expr_ari PLUS expr_ari
     	| expr_ari MINUS expr_ari
     	| expr_ari MULT expr_ari
     	| expr_ari DIV expr_ari
     	| expr_ari MOD expr_ari
     	| MINUS expr_ari %prec UMINUS
     	| OPEN_PARENTHESES expr_ari CLOSE_PARENTHESES
     	| operando
     	;



/* Operadores Relacionais */
relop : GT
      | LT
      | GE
      | LE
      | EE
      | NE
      ;

type : INT | FLOAT
     ;

%%