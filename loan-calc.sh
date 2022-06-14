#!/bin/bash

PROGNAME="${0##*/}"

usage(){
    echo "Usage: $PROGNAME [PRINCIPAL INTEREST MONTHS | -i]
    Where:
    
    PRINCIPAL is the amount of the loan.
    INTEREST is the APR as a number (7% = 0.07).
    MONTHS is the length of the loan's term.
    
    -i, --interactive 
        allows for interactive mode."

    return
}

take_ramdom(){
    local number
    number=$((1 + $RANDOM % 9))
    until [[ ! " ${espacos_disponiveis[*]} " =~ " ${number} " ]]; do
        number=$((1 + $RANDOM % 9))
    done
    echo "$number"
}
#Shell function to check if a given string is a int or float
check_number(){
    local temp
    read -p "Please enter the $1 value: " temp
    until [[  $temp =~ ^-?[[:digit:]]*(\.)?[[:digit:]]+$ ]]; do 
        echo "Oops! User input was not a number!"
        read -p "Please enter the $1 value: " temp
    done

    echo "$temp"
}

if (( ($# != 3) && ($# != 1) )); then
    usage
    exit 1
fi

interactive=

if [[ $1 = "-i" || $1 = "--interactive" ]]; then
    interactive=1
else 
    interactive=0
fi

if (( interactive == 1 )); then
    #to-do: The interactive mode currently has two problems. It doesn't output
    #the error message ("Oops!.."). And any invalid input messes the
    #script's workflow. Looking for a solution.
    principal="$(check_number principal)"
    interest="$(check_number interest)"
    months="$(check_number months)"
else
    principal=$1
    interest=$2
    months=$3
fi

bc <<- _EOF_ 
    scale = 10
    i = $interest / 12
    p = $principal
    n = $months
    a = p * ((i * ((1 + i) ^ n )) / (((1 + i) ^ n) - 1))
    print "The monthly payment will be ", a, " dollars for ", n, " months.", "\n"
_EOF_