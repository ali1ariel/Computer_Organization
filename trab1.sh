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
        *) "opção inválida";echo;exit;;
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
		if [ -z "$byte" ]; then
			continue
		fi
        echo "B-> $byte"
        init="$( echo $byte | head -c 6 )"
        echo "A -> $init"
        if [  "$init" = "000000" ]; then
        	RFormat $byte
        else
            IJFormat $byte $init
	fi
	done < "$1"

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

function RFormat()
{
	inicio="$(echo ${1: -6: 3})"
    final="$(echo ${1: -3})"
    echo "$1 - $inicio - $final"


	reg1=${1:0:5}
	reg2=${1:5:5}
	regDest=${1:10:5}

	case "$inicio" in
	000)
		case "$final" in
		000) sll
		;;
		010) srl
		;;
		011) sra
		;;
		100) sllv
		;;
		110) srlv
		;;
		111) srav
		;;
		esac
	;;
	001)
		case "$final" in
		000) jr
		;;
		001) jalr
		;;
		100) syscall
		;;
		101) breakfunc
		;;
		esac
	;;
	010)
		case "$final" in
		000) mfhi
		;;
		001) mthi
		;;
		010) mflo
		;;
		011) mtlo
		;;
		esac
	;;
	011)
		case "$final" in
		000) mult
		;;
		001) multu
		;; 
		010) div
		;;
		011) divu
		;;
		esac
	;;
	100)
		case "$final" in
		000) add $reg1 $reg2 $regDest
		;;
		001) addu $reg1 $reg2 $regDest
		;;
		010) subtract $reg1 $reg2 $regDest
		;;
		011) subu $reg1 $reg2 $regDest
		;;
		100) and $reg1 $reg2 $regDest
		;;
		101) or $reg1 $reg2 $regDest
		;;
		110) xor $reg1 $reg2 $regDest
		;;
		111) nor $reg1 $reg2 $regDest
		;;
		esac
	;;
	101)
		case "$final" in
		010) setLT $reg1 $reg2 $regDest
		;;
		011) setLTUnsigned $reg1 $reg2 $regDest
		;;
		esac
	;;
	esac

    if [ "$final" = "100000" ] 
    then 
        soma $reg1 $reg2 $regDest
    elif [ "$final" = "100010" ]
    then 
        sub $reg1 $reg2 $regDest
    fi
}


function IJFormat()
{
	echo "entrou - $1"
}

function and()
{
    echo "Operador AND entre os registradores $(binToDec $1) e $(binToDec $2) e salvar no $(binToDec $3)"
}

function or()
{
    echo "Operador OR entre os registradores $(binToDec $1) e $(binToDec $2) e salvar no $(binToDec $3)"
}

function xor()
{
    echo "Operador XOR entre os registradores $(binToDec $1) e $(binToDec $2) e salvar no $(binToDec $3)"
}

function nor()
{
    echo "Operador NOR entre os registradores $(binToDec $1) e $(binToDec $2) e salvar no $(binToDec $3)"
}

function add()
{
    echo "Somar registrador $(binToDec $1) com o $(binToDec $2) e salvar no $(binToDec $3)"
}

function addu()
{
    echo "Somar registrador $(binToDec $1) com o $(binToDec $2) e salvar no $(binToDec $3)"
}

function subtract()
{
    echo "SUBTRAIR registrador $(binToDec $2) do $(binToDec $1) e salvar no $(binToDec $3)"
}

function subu()
{
    echo "SUBTRAIR registrador $(binToDec $2) do $(binToDec $1) e salvar no $(binToDec $3)"
}

function setLT()
{
	echo "Se os registradores $(binToDec $1) e $(binToDec $2) tiverem o mesmo valor, o $(binToDec $3) recebe 1, se não, recebe zero"
}

function setLTUnsigned()
{
	echo "Se os registradores $(binToDec $1) e $(binToDec $2) tiverem o mesmo valor, o $(binToDec $3) recebe 1, se não, recebe zero"
}


function binToDec()
{
	value=0
	pos=-1
    while [ "$pos" -ge -5 ]
    do 
        comp=${1: pos: 1}
        if [ "$comp" = "1" ]
        then
            if [ "$pos" = "-1" ]
            then
                value=1
            else
                ((pos=pos+1))
                ((value=value+$(returnBin $pos)))
                ((pos=pos-1))
            fi
        fi
        ((pos=pos-1))
    
    done
        
    echo "$value"    
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
