function IJFormat()
{
	inicio=${1: 0: 3}
    final=${1: 3: 3}

    case "$inicio" in
	000)
		case "$final" in
		000)
		;;
		001)
		;;
		010)
		;;
		011)
		;;
		100)
		;;
		101)
		;;
		110)
		;;
		111)
		;;
        esac
	;;
	001)
		case "$final" in
		
		000)
		;;
		001)
		;;
		010)
		;;
		011)
		;;
		100)
		;;
		101)
		;;
		110)
		;;
		111)
		;;
		esac
	;;
	010)
		case "$final" in
		000)
		;;
		001)
		;;
		esac
	;;
	100)
		case "$final" in
		000)
		;;
		001)
		;;
		010)
		;;
		011)
		;;
		100)
		;;
		101)
		;;
		110)
		;;
		esac
	;;
	101)
		case "$final" in
		000)
		;;
		001)
		;;
		010)
		;;
		011)
		;;
		110)
		;;
		esac
	;;
    110)
		case "$final" in
		000)
		;;
		001)
		;;
    ;;
    111)
		case "$final" in
		000)
		;;
		001)
		;;
    ;;
	esac

}