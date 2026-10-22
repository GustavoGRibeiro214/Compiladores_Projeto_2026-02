%option noyywrap yylineno

%{

/*-------------------- Definitions --------------------*/
#include<stdio.h>
#include<string.h>
#include "parser.tab.h"

int yyparse(void);

int column_number = 1;

int token_column = 1;
int token_line = 1;

typedef struct {

	char nome[50];
	int ID;

} Tabela;

Tabela tabelaDeSimbolos[100];
int totalSimbolos = 0;

int buscaNaTabela (char *nome) {

/* Busca para ver se já tem o token na tabela */

	for (int i = 0; i < totalSimbolos; i++) {
		
		if (strcmp(tabelaDeSimbolos[i].nome, nome) == 0) {

			return i;

		}

	}

/* Coloca o token na tabela se tiver espaço  */

	if (totalSimbolos < 100) {

		strcpy(tabelaDeSimbolos[totalSimbolos].nome, nome);
		totalSimbolos++;
		
		return totalSimbolos - 1;
	}

	return -1;
}


int exibirTabela () {


/* Percorrer a tabela e exiber cada token */
	
	if (totalSimbolos > 0) {

		fprintf(yyout, "\n");
		fprintf(yyout, "TABELA DE SÍMBOLOS \n");

		for (int i = 0; i < totalSimbolos; i++) {
	
			fprintf(yyout,"POSIÇÃO: %d| LEXEMA: %s| \n",i , tabelaDeSimbolos[i].nome);

		}

		fprintf(yyout, "\n");

		return 1;
	}

	return -1;
}


%}


delim		[ \t\r]
ws		{delim}+


letter		[A-Za-z]
digit		[0-9]

int_number	{digit}+
float_number	{digit}+\.{digit}+("E"("+"|"-")?{digit}+)?

ID		{letter}+({letter}|{digit}|"_")*


commentone	"//".*
multcomennt	"/*"([^*]|\*+[^*/])*\*+"/"
multcomennt_sem_fechamento    "/*"([^*]|\*+[^*/])*\**

other		.


%%

%{
/*-------------------- Rules --------------------*/


/* Tipos de Variáveis */
%}

"int" {
	token_column = column_number;
    	token_line = yylineno;
	
	fprintf(yyout, "TOKEN: TYPE | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return INT;
}

"float" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: TYPE | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return FLOAT;
}

%{
/* Palavras Reservadas */
%}

"if" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: IF | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return IF;
}


"else" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: ELSE | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return ELSE;
}


"while" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: WHILE | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return WHILE;
}


"print" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: PRINT | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return PRINT;
}


"read" {	
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: READ | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return READ;
}

%{
/* Operadores Aritméticos */
%}

"+" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: PLUS | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return PLUS;
}

"-" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: MINUS | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return MINUS;
}


"*" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: MULT | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return MULT;
}


"/" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: DIV | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return DIV;
}


"%" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: MOD | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return MOD;
}

"=" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: ATTRIBUTION | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return ATTRIBUTION;
}


%{
/* Operadores Lógicos */
%}

"and"|"&&" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: AND | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return AND;
}

"or"|"||" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: OR | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return OR;
}


"not"|"!" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: NOT | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return NOT;
}

%{
/* Operadores Relacionais */
%}

">="|"<="|"=="|"!="|">"|"<" {
    token_column = column_number;
    token_line = yylineno;

    fprintf(yyout, "TOKEN: RELOP | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
            yytext, yylineno, column_number);

    column_number += yyleng;
    /*Retorna o Respectivo Token para o Bison*/
    if (yyleng == 2) {
        if (yytext[0] == '>')
            return GE;
        else if (yytext[0] == '<')
            return LE;
        else if (yytext[0] == '=')
            return EE;
        else
            return NE;
    }
    else {
        if (yytext[0] == '>')
            return GT;
        else if (yytext[0] == '<')
            return LT;
    }
}

%{
/* Identificadores */
%}

{ID} {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: ID | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	buscaNaTabela(yytext);

	column_number += yyleng;
	return ID;
}

%{
/* Números */
%}

{float_number} {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: FLOAT_NUMBER | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return FLOAT_NUMBER;
}


{int_number} {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: INT_NUMBER | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);


	column_number += yyleng;
	return INT_NUMBER;
}

%{
/* Símbolos de Pontuação */
%}

";" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: SEMICOLON | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return SEMI;
}


"," {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: COMMA | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return COMMA;
}


"(" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: OPEN_PARENTHESES | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return OPEN_PARENTHESES;
}


")" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: CLOSE_PARENTHESES | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return CLOSE_PARENTHESES;
}


"{" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: OPEN_BRACES | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return OPEN_BRACES;
}


"}" {
	token_column = column_number;
    	token_line = yylineno;

	fprintf(yyout, "TOKEN: CLOSE_BRACES | LEXEMA: %s | LINHA: %d | COLUNA: %d\n",
	yytext, yylineno, column_number);

	column_number += yyleng;
	return CLOSE_BRACES;
}

%{
/* Comentários */
%}

{commentone} {
	column_number += yyleng;
}


{multcomennt} {
    /* Percorrer todos os caracteres do comentário */
    for (int i = 0; i < yyleng; i++) {

        /* Verificar se o caractere é uma quebra de linha */
        if (yytext[i] == '\n') {

            /* Reiniciar a coluna ao iniciar uma nova linha */
            column_number = 1;

        } else {

            /* Avançar uma coluna para cada caractere */
            column_number++;

        }
    }
}

{multcomennt_sem_fechamento} {
    fprintf(yyout,
        "Erro: comentario de multiplas linhas iniciado "
        "na linha %d e coluna %d nao foi fechado.\n",
        yylineno, column_number);
}

%{
/* Quebra de linha */
%}

\n { 
	column_number = 1;
}

%{
/* Espaços */
%}

{ws} { 
	column_number += yyleng;	
}

%{
/* Erros */
%}

{other} {
	fprintf(yyout,
		"Lexical error on line %d and column %d. Input -> \"%s\"\n",
		yylineno, column_number, yytext);

	column_number += yyleng;
}


%%


/*-------------------- User subroutines --------------------*/

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