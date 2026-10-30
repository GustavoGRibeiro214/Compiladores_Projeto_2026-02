#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Erro: Informe o arquivo-fonte."
    echo "Uso: $0 <arquivo_fonte>"
    exit 1
fi

FONTE="$1"

if [ ! -f "$FONTE" ]; then
    echo "Erro: O arquivo '$FONTE' não foi encontrado."
    exit 1
fi

ARQUIVO_FLEX="lexer.l"
ARQUIVO_BISON="parser.y"

if [ ! -f "$ARQUIVO_FLEX" ]; then
    echo "Erro: O arquivo '$ARQUIVO_FLEX' não foi encontrado."
    exit 1
fi

if [ ! -f "$ARQUIVO_BISON" ]; then
    echo "Erro: O arquivo '$ARQUIVO_BISON' não foi encontrado."
    exit 1
fi

echo "==> Gerando o analisador sintático com Bison..."
bison -d -o parser.tab.c parser.y

if [ $? -ne 0 ]; then
    echo "Erro durante a execução do Bison."
    exit 1
fi

echo "==> Gerando o analisador léxico com Flex..."
flex -o scanner.yy.c lexer.l

if [ $? -ne 0 ]; then
    echo "Erro durante a execução do Flex."
    exit 1
fi

echo "==> Compilando o código C..."
gcc -o main parser.tab.c scanner.yy.c -lfl

if [ $? -ne 0 ]; then
    echo "Erro durante a compilação com GCC."
    exit 1
fi

echo "==> Executando o analisador em '$FONTE'..."
echo "----------------------------------------"

./main "$FONTE"

echo "----------------------------------------"

rm -f parser.tab.c parser.tab.h scanner.yy.c main
