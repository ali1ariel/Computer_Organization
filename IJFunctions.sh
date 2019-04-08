. RFunctions.sh
. binToDec.sh
function RIJFormat()
{
	inicio=${1: 0: 3}
    final=${1: 3: 3}

    case "$inicio" in
	000)
		case "$final" in
		000) RFormat $1
		;;
		001)
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
	001)
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
		111) lui $1
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
	100)
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
function addi()
{
	echo "adiciona ao registrador $(binToDec ${1: 11: 5}) o valor do registrador $(binToDec ${1:6:5}) mais $(binToDec ${1:16}) unidades"
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
}

function bne()
{
	echo "compara os registradores $(binToDec ${1: 6: 5}) e $(binToDec ${1:11:5}), se não são iguais pula para o endereço $(binToDec ${1:16})"
}

function blez()
{
}

function bgtz()
{
}


