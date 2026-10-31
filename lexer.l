%option noyywrap yylineno

%{

/*-------------------- Definitions --------------------*/
#include<stdio.h>
#include<string.h>
#include "parser.tab.h"

int yyparse(void);

int column_number = 1;

/* Retornam a coluna e a linha do erro sintatico */
int token_column = 1;
int token_line = 1;

/* Retorna no Caso de Erro */
int erro_sintatico = 0;
int erro_lexico = 0;

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

/* Lexema do token atual e do anterior (usados nas mensagens de erro).
   Guardamos o TAMANHO de cada lexema em vez de depender do fim de string. */
char lexema_atual[64];
char lexema_anterior[64];
int  tam_atual = 0;            /* caracteres guardados do token atual */
int  tam_anterior = 0;         /* caracteres guardados do token anterior */
int  tam_real_atual = 0;       /* tamanho real do token atual (yyleng) */
int  linha_anterior = 1;       /* onde o token anterior terminou */
int  coluna_fim_anterior = 1;

/* Chamada no inicio da ação de cada token */
void registrar_token(void) {
	int i;

	/* O token atual passa a ser o anterior */
	linha_anterior      = token_line;
	coluna_fim_anterior = token_column + tam_real_atual;
	tam_anterior        = tam_atual;

	for (i = 0; i < tam_atual; i++) {
		lexema_anterior[i] = lexema_atual[i];
	}

	/* Registra o novo token atual (guarda no maximo 63 caracteres) */
	token_line     = yylineno;
	token_column   = column_number;
	tam_real_atual = yyleng;

	if (yyleng < 63) {
		tam_atual = yyleng;
	} else {
		tam_atual = 63;
	}
	for (i = 0; i < tam_atual; i++) {
		lexema_atual[i] = yytext[i];
	}

	column_number += yyleng;
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
	registrar_token();
	return INT;
}

"float" {
	registrar_token();
	return FLOAT;
}

%{
/* Palavras Reservadas */
%}

"if" {
	registrar_token();
	return IF;
}


"else" {
	registrar_token();
	return ELSE;
}


"while" {
	registrar_token();
	return WHILE;
}


"print" {
	registrar_token();
	return PRINT;
}


"read" {	
	registrar_token();
	return READ;
}

%{
/* Operadores Aritméticos */
%}

"+" {
	registrar_token();
	return PLUS;
}

"-" {
	registrar_token();
	return MINUS;
}


"*" {
	registrar_token();
	return MULT;
}


"/" {
	registrar_token();
	return DIV;
}


"%" {
	registrar_token();
	return MOD;
}

"=" {
	registrar_token();
	return ATTRIBUTION;
}


%{
/* Operadores Lógicos */
%}

"and"|"&&" {
	registrar_token();
	return AND;
}

"or"|"||" {
	registrar_token();
	return OR;
}


"not"|"!" {
	registrar_token();
	return NOT;
}

%{
/* Operadores Relacionais */
%}

">="|"<="|"=="|"!="|">"|"<" {
    registrar_token();
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
	registrar_token();

	/* So insere na tabela se o nome couber no buffer (50 posicoes) */
	if (yyleng < 50) {
		buscaNaTabela(yytext);
	}
	return ID;
}

%{
/* Números */
%}

{float_number} {
	registrar_token();
	return FLOAT_NUMBER;
}


{int_number} {
	registrar_token();
	return INT_NUMBER;
}

%{
/* Símbolos de Pontuação */
%}

";" {
	registrar_token();
	return SEMI;
}


"," {
	registrar_token();
	return COMMA;
}


"(" {
	registrar_token();
	return OPEN_PARENTHESES;
}


")" {
	registrar_token();
	return CLOSE_PARENTHESES;
}


"{" {
	registrar_token();
	return OPEN_BRACES;
}


"}" {
	registrar_token();
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
    erro_lexico = 1;

    /* Só executa a ação depois de casar o comentário inteiro */
    int linha_inicio = yylineno;
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] == '\n') {
            linha_inicio--;
        }
    }
    fprintf(yyout,
        "Erro: comentario de multiplas linhas iniciado "
        "na linha %d e coluna %d nao foi fechado.\n",
        linha_inicio, column_number);
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
	erro_lexico = 1;
	
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

    /* Verificar se a analise foi realizada sem erros */
    if (erro_sintatico == 0) {
        printf("Analise sintatica realizada com sucesso.\n");
    }
    else {
        printf("Analise sintatica encontrou erro(s).\n");
    }

    if (erro_lexico == 0) {
        printf("Analise lexica realizada com sucesso.\n");
    }
    else {
        printf("Analise lexica encontrou erro(s).\n");
    }

    /* Fechar o arquivo */
    fclose(yyin);

    return resultado;
}

/* Informa linha, coluna e token inesperado do erro sintatico */
void yyerror(const char *s) {
    erro_sintatico = 1;

    fprintf(stderr,
        "Erro sintatico na linha %d, coluna %d: %s, "
        "token inesperado '%.*s'\n",
        token_line, token_column, s, tam_atual, lexema_atual);

    /* Aponta onde o token anterior terminou (util quando falta ';') */
    if (tam_anterior > 0) {
        fprintf(stderr,
            "  (token anterior: '%.*s', terminou na linha %d, coluna %d)\n",
            tam_anterior, lexema_anterior,
            linha_anterior, coluna_fim_anterior);
    }
}
