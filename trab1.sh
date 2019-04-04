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
        init="$( echo $byte | head -c 6 )"
        echo "$init"
        if [  "$init" = "000000" ]
		then
        	final="$(echo ${byte: -6})"
        	echo "$final"
			if [ "$final" = "100000" ] 
			then 
				soma ${byte:6:20}
			fi
		fi
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

function soma()
{
	reg1=${1:0:5}
	reg2=${1:5:5}
	regDest=${1:10:5}

	echo "\$reg1 = $reg1, \$reg2 = $reg2, \$regDest = $regDest"

	binToDec $reg1
}

function binToDec()
{
	value=0
	pos=-1
    while [ "$pos" -ge -5 ]
    do 
        comp=${1: pos: 1}
        echo "o numero pra comparar: $comp - $1"
        if [ "$comp" = "1" ]
        then
            if [ "$pos" = "-1" ]
            then
                value=1
            else
                echo "entrou"
                ((pos=pos+1))
                ((value=value+$(returnBin $pos)))
                ((pos=pos-1))
            fi
        fi
        echo "$pos"
        ((pos=pos-1))
    
    done
        
    echo "resp -> $value"    
}

function returnBin()
{
	e=$(returnPositive $1)
	echo "((e=2**$e))"
}


function returnPositive()
{
	((e=$1**2))
	e=$(echo "sqrt($e)" | bc)
	echo "$e"
}



menu $1 $2 $3
