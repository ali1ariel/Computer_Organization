
function RFormat()
{
	inicio=${1: -6: 3}
    final=${1: -3}


	reg1=${1:6:5}
	reg2=${1:11:5}
	regDest=${1:16:5}

	case "$inicio" in
	000)
		case "$final" in
		000)
			shamt=${1: -11: 5}
			sll $reg1 $shamt $regDest
		;;
		010)
			shamt=${1: -11: 5}
			srl $reg1 $shamt $regDest
		;;
		011)
			shamt=${1: -11: 5}
			sra $reg1 $shamt $regDest
		;;
		100) sllv $reg1 $reg2 $regDest
		;;
		110) srlv $reg1 $reg2 $regDest
		;;
		111) srav $reg1 $reg2 $regDest
		;;
		esac
	;;
	001)
		case "$final" in
		000) jr $reg1
		;;
		001) jalr $reg1 $regDest
		;;
		100) syscall
		;;
		101) breakfunc ${1:6:20}
		;;
		esac
	;;
	010)
		case "$final" in
		000) mfhi $regDest
		;;
		001) mthi $reg1	
		;;
		010) mflo $regDest
		;;
		011) mtlo $reg1
		;;
		esac
	;;
	011)
		case "$final" in
		000) mult $reg1 $reg2
		;;
		001) multu $reg1 $reg2
		;; 
		010) div $reg1 $reg2
		;;
		011) divu $reg1 $reg2
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

}





function jr()
{
    echo "pula para o valor contido no registrador $(binToDec $1)"
}

function jalr()
{
    echo "salva o endereço atual em $(binToDec $2) e pula para o valor contido no registrador $(binToDec $1)"
}

function syscall()
{
    echo "executa a syscall que consta no registrador v0"
}

function breakfunc()
{
    echo "para o programa com erros $(binToDec $1)"
}

function mult()
{
    echo "multiplica os registradores $(binToDec $1) e  $(binToDec $2) e salva em \$lo"
}

function multu()
{
    echo "multiplica os registradores sem sinal ????? $(binToDec $1) e  $(binToDec $2) e salva em \$lo"
}

function div()
{
    echo "divide o registrador $(binToDec $1) pelo  $(binToDec $2) e salva em \$lo"
}

function divu()
{
    echo "divide sem sinal ?????? o registrador $(binToDec $1) pelo  $(binToDec $2) e salva em \$lo"
}


function mflo()
{
    echo "move do registrador lo para o registrador $(binToDec $1)"
}

function mfhi()
{
    echo "move do registrador hi para o registrador $(binToDec $1)"
}

function mtlo()
{
    echo "move do registrador $(binToDec $1) para o registrador hi"
}

function mthi()
{
    echo "move do registrador $(binToDec $1) para o registrador hi"
}


function sll()
{
    echo "Faz logical shift para a esquerda do registrador $(binToDec $1) em $(binToDec $2) bits e salva no registrador $(binToDec $3)"
}

function srl()
{
    echo "Faz logical shift para a direita do registrador $(binToDec $1) em $(binToDec $2) bits e salva no registrador $(binToDec $3)"
}


function sra()
{
    echo "Faz aritimetical shift para a direita do registrador $(binToDec $1) em $(binToDec $2) bits e salva no registrador $(binToDec $3)"
}

function sllv()
{
    echo "Faz logical shift para a esquerda do registrador $(binToDec $1) no valor de bits contidos no registrador (binToDec $2) e salva no registrador $(binToDec $3)"
}


function srlv()
{
    echo "Faz logical shift para a direita do registrador $(binToDec $1) no valor de bits contidos no registrador (binToDec $2) e salva no registrador $(binToDec $3)"
}


function srav()
{
    echo "Faz aritimetical shift para a direita do registrador $(binToDec $1) no valor de bits contidos no registrador (binToDec $2) e salva no registrador $(binToDec $3)"
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
