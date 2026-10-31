
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

/* Precedencia Menor -> Maior*/
%left OR
%left AND
%left EE NE
%left LT GT LE GE
%left PLUS MINUS
%left MULT DIV MOD
%right NOT UMINUS

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
        | print
        | read
	| bloco_sep
        | error SEMI { yyerrok; }
        ;



/* Declaracoes e atribuições */

decl : type ID list_decl SEMI
     ;

list_decl : /* vazio */
          | ATTRIBUTION expr
          | ATTRIBUTION expr COMMA ID list_decl
          | COMMA ID list_decl
          ;

atrib : ID ATTRIBUTION expr SEMI
      ;

/* Valores usados nas atribuicoes */

operando : ID 
	 | INT_NUMBER 
	 | FLOAT_NUMBER 
	 ;


/* Condicionais IF e ELSE */

cond : IF OPEN_PARENTHESES expr CLOSE_PARENTHESES bloco_sep
     /*IF com ELSE IF*/
     | IF OPEN_PARENTHESES expr CLOSE_PARENTHESES bloco_sep ELSE cond
     /* IF e ELSE casado */
     | IF OPEN_PARENTHESES expr CLOSE_PARENTHESES bloco_sep ELSE bloco_sep
     ;


/* Loop while */
loop : WHILE OPEN_PARENTHESES expr CLOSE_PARENTHESES bloco_sep
     ;

/* Print */

print : PRINT OPEN_PARENTHESES expr CLOSE_PARENTHESES SEMI
      ;

/* Read */

read : READ OPEN_PARENTHESES ID CLOSE_PARENTHESES SEMI
     ;

/* bloco de chaves separado */

bloco_sep : OPEN_BRACES bloco CLOSE_BRACES
          ;

/*EXPRESSÕES*/
expr : expr OR expr /* Operadores Logicos AND/OR*/
     | expr AND expr
     /*EXPRESSÕES RELACIONAIS*/
     | expr EE expr
     | expr NE expr
     | expr LT expr
     | expr GT expr
     | expr LE expr
     | expr GE expr
     /*EXPRESSÕES ARITIMETICAS*/
     | expr PLUS expr
     | expr MINUS expr
     | expr MULT expr
     | expr DIV expr
     | expr MOD expr
     /* Menor precedencia NOT/ MINUS*/
     | NOT expr
     | MINUS expr %prec UMINUS
     /* Parenteses */
     | OPEN_PARENTHESES expr CLOSE_PARENTHESES
     /* Valores que podem ser substituidos nas expressões*/
     | operando ;

type : INT | FLOAT
     ;

%%
