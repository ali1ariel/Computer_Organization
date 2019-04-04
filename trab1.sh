#!/bin/bash

function menu()
{
    echo "$1"
    case "$1" in 
        l) leitura $2
        ;;
        r) simulacao $2
        ;;
        d) registradores
        ;;
        m) memoria $2 $3
        ;;
        *) "opção inválida";echo;menu;;
    esac

}
function leitura()
{
    if [ -z "$1" ]
    then
        echo "faltou o nome do arquivo";
        return;
    fi

    while read -n32 byte
    do 
        echo "$byte"
        init="$(echo $byte | head -c 6)"
        echo "$init"
        if (init==0)
        final="$(echo ${byte: -6})"
        echo "$final"

    done < "$1"

    echo "leitura: $1"
}

function simulacao()
{
    if [ -z "$1" ]
    then
        echo "faltou o numero de simulações";
        return;
    fi
    echo "simulação: $1"
}

function registradores()
{
    echo "registradores"
}

function memoria()
{
    if [ -z "$1" ]||[ -z "$2" ]
    then
        echo "faltou o endereço inicial ou o número de endereços";
        return;
    fi
    echo "memória, endereço inicial: $1, quantidade de endereços $2"
}

menu $1 $2 $3