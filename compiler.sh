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

if [ ! -f "$ARQUIVO_FLEX" ]; then
    echo "Erro: O arquivo '$ARQUIVO_FLEX' não foi encontrado."
    exit 1
fi

echo "==> Gerando o analisador léxico com Flex..."
flex "$ARQUIVO_FLEX"

if [ $? -ne 0 ]; then
    echo "Erro durante a execução do Flex."
    exit 1
fi

echo "==> Compilando o código C..."
gcc lex.yy.c -o compilador

if [ $? -ne 0 ]; then
    echo "Erro durante a compilação com GCC."
    exit 1
fi

echo "==> Executando o analisador em '$FONTE'..."
echo "----------------------------------------"

./compilador "$FONTE"

echo "----------------------------------------"

rm -f lex.yy.c compilador