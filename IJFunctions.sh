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
		010) jump
		;;
		011) jal
		;;
		100) beq
		;;
		101) bne
		;;
		110) blez
		;; 
		111) bgtz
		;;
        esac
	;;
	001)
		case "$final" in
		
		000) addi
		;;
		001) addiu
		;;
		010) slti
		;;
		011) sltiu
		;;
		100) andi
		;;
		101) ori
		;;
		110) xori
		;;
		111) lui
		;;
		esac
	;;
	010)
		case "$final" in
		000) TLB
		;;
		001) flPt
		;;
		esac
	;;
	100)
		case "$final" in
		000) load_byte
		;;
		001) load_half
		;;
		010) lwl
		;;
		011) load_word
		;;
		100) load_byte_unsigned
		;;
		101) lwr
		;;
		esac
	;;
	101)
		case "$final" in
		000) store_byte
		;;
		001) store_half
		;;
		010) swl
		;;
		011) store_word
		;;
		110) swr
		;;
		esac
	;;
    110)
		case "$final" in
		000) load_linked_word
		;;
		001) lwc1
		;;
		esac
    ;;
    111)
		case "$final" in
		000) store_cond_word
		;;
		001) swc1
		;;
		esac
    ;;
	esac

}