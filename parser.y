
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

int main(int argc, char *argv[]) {

    /* Verificar se o arquivo foi informado */
    if (argc < 2) {
        printf("Uso: %s arquivo.txt\n", argv[0]);
        return 1;
    }

    /* Abrir o arquivo de entrada */
    yyin = fopen(argv[1], "r");

    if (yyin == NULL) {
        printf("Erro ao abrir o arquivo.\n");
        return 1;
    }

    /* Definir a saida dos resultados */
    yyout = stdout;

    /* Executar o analisador sintatico do Bison */
    int resultado = yyparse();

    /* Exibir a tabela de simbolos */
    exibirTabela();

    /* Fechar o arquivo */
    fclose(yyin);

    return resultado;
}

/*Passa a Coluna e a linha para o Parser para informar no erro sintatico*/
void yyerror(const char *s) {
    fprintf(stderr,
        "Erro sintatico na linha %d, coluna %d: %s\n",
        token_line, token_column, s);
}