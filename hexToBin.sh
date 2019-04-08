#!/bin/bash
. IJFunctions.sh
function returnBinFromHex()
{
	case "$1" in
	0) echo "0000"
		return
	;;
	1) echo "0001"
	;;
	2) echo "0010"
	;;
	3) echo "0011"
	;;
	4) echo "0100"
	;;
	5) echo "0101"
	;;
	6) echo "0110"
	;;
	7) echo "0111"
	;;
	8) echo "1000"
	;;
	9) echo "1001"
	;;
	a) echo "1010"
	;;
	b) echo "1011"
	;;
	c) echo "1100"
	;;
	d) echo "1101"
	;;
	e) echo "1110"
	;;
	f) echo "1111"
	;;	

	esac
}

tam="${#1}"
value=0
pos=0
while [ $pos -le $tam ]
do 
	inf=${1: pos: 1}
	var=$(returnBinFromHex $inf)
	if [ "$pos" = 0 ]; then
		value=$var
	else 
		value=$value$var
	fi
	((pos=$pos+1))

done
    
echo "$value"   
echo "$(binToDec $value)"
RIJFormat $value
