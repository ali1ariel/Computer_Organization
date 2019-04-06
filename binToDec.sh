
function binToDec()
{
	tam="${#1}"
	value=0
	pos=-1
    while [ "$pos" -ge -$tam ]
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


