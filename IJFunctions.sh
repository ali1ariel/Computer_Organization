. RFunctions.sh
. binToDec.sh
function RIJFormat()
{
	inicio=${1: 0: 3}
    final=${1: 3: 3}

    case "$inicio" in
	000) #Completo
		case "$final" in
		000) RFormat $1
		;;
		010) jump $1
		;;
		011) jal $1
		;;
		100) beq $1
		;;
		101) bne $1
		;;
		110) blez $1
		;; 
		111) bgtz $1
		;;
    esac
	;;
	001) #Completo
		case "$final" in
		
		000) addi $1
		;;
		001) addiu $1
		;;
		010) slti $1
		;;
		011) sltiu $1
		;;
		100) andi $1
		;;
		101) ori $1
		;;
		110) xori $1
		;;
		111) load_upper_imediate $1
		;;
		esac
	;;
	010)
		case "$final" in
		000) TLB $1
		;;
		001) flPt $1
		;;
		esac
	;;
	100) #VERIFICAR
		case "$final" in
		000) load_byte $1
		;;
		001) load_half $1
		;;
		010) lwl $1
		;;
		011) load_word $1
		;;
		100) load_byte_unsigned $1
		;;
		101) lwr $1
		;;
		esac
	;;
	101)
		case "$final" in
		000) store_byte $1
		;;
		001) store_half $1
		;;
		010) swl $1
		;;
		011) store_word $1
		;;
		110) swr $1
		;;
		esac
	;;
    110)
		case "$final" in
		000) load_linked_word $1
		;;
		001) lwc1 $1
		;;
		esac
    ;;
    111)
		case "$final" in
		000) store_cond_word $1
		;;
		001) swc1 $1
		;;
		esac
    ;;
	esac

}

function load_byte()
{
    echo "passa temporariamente os valores relacionados a $(binToDec ${1:16}) para o registrador \$1 que irá ser encaminhado para o registrador $(binToDec ${1:6:5}) atráves da function lui"
    
    load_upper_imediate
}


function addi()
{
	echo "adiciona ao registrador $(binToDec ${1: 11: 5}) o valor do registrador $(binToDec ${1:6:5}) mais $(binToDec ${1:16}) unidades"
} 

function andi()
{
	echo "realiza operação bitwise AND entre o registrador $(binToDec ${1: 6: 5}) e o valor de $(binToDec ${1:16}) unidades, salvando no registrador $(binToDec ${1:11:5})"
}

function ori()
{
 	echo "realiza operação bitwise OR entre o registrador $(binToDec ${1: 6: 5}) e o valor de $(binToDec ${1:16}) unidades, salvando no registrador $(binToDec ${1:11:5})"
}

function xori()
{
	echo "realiza operação bitwise XOR entre o registrador $(binToDec ${1: 6: 5}) e o valor de $(binToDec ${1:16}) unidades, salvando no registrador $(binToDec ${1:11:5})"
}

function load_upper_imediate()
{
    echo "carrega a constante $(binToDec ${1:16}) para os 16 bits mais significantes \do registrador $(binToDec ${1:11:5})"
}

function slti()
{
	echo " compara se o registrador $(binToDec ${1: 6: 5}) é menor que o valor de $(binToDec ${1:16}) unidades, se sim, o registrador $(binToDec ${1:11:5}) recebe 1, se não, recebe 0"
} 

function sltiu()
{
	echo " compara se o registrador $(binToDec ${1: 6: 5}) é menor que o valor de $(binToDec ${1:16}) unidades sem sinal, se sim, o registrador $(binToDec ${1:11:5}) recebe 1, se não, recebe 0"
} 

function addi()
{
	echo "adiciona ao registrador $(binToDec ${1: 11: 5}) o valor do registrador $(binToDec ${1:6:5}) mais $(binToDec ${1:16}) unidades"
} 

function addiu()
{
	echo "adiciona ao registrador $(binToDec ${1: 11: 5}) o valor do registrador $(binToDec ${1:6:5}) mais $(binToDec ${1:16}) unidades sem sinal"
} 

function jump()
{
	echo "pula para o endereço ${1:6}"
}

function jal()
{
	echo "pula para o endereço ${1:6}, salvando o atual em \$ra"
}

function beq()
{
		echo "compara os registradores $(binToDec ${1: 6: 5}) e $(binToDec ${1:11:5}), se são iguais pula $(binToDec ${1:16}) instruções"
}

function bne()
{
	echo "compara os registradores $(binToDec ${1: 6: 5}) e $(binToDec ${1:11:5}), se não são iguais pula $(binToDec ${1:16}) instruções"
}

function blez()
{
		echo "se registrador $(binToDec ${1: 6: 5}) \for menor ou igual a zero pula $(binToDec ${1:16}) instruções"
}

function bgtz()
{
		echo "se registrador $(binToDec ${1: 6: 5}) \for maior ou igual a zero pula $(binToDec ${1:16}) instruções"
}


