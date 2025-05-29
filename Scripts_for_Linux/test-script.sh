#!/bin/bash
#-----------------------------------------------------------------------------------
# It is simple script for test
# Prod by Alexander Guzeev in 2023
# All Rights reserved by the LICENSE. Copyright © 2023 Guzeew Alexander
#-----------------------------------------------------------------------------------
echo -e "This script outputs date and time in YYYY.MM.DD HH:MM:SS format for the number of iterations you specify.\n"
sleep 1s

read -p "Please, type number of iteration: " numberIteration

case $numberIteration in 

[1-9] | [1-9][0-9]* )
    echo -e "$numberIteration iterations will be executed!\n"
    for (( i = 1; i <= $numberIteration; i++ ))
    do
    date +"%Y.%m.%d %H:%M:%S"
    sleep 1s
    echo -e "Number of iterations performed: $i\n"
    done
;;

[-_.,\*\&?!@/a-zA-ZА-Яа-я]* )
    echo -e "You have entered a non-numeric value."
;;

"" )
    echo -e "Error! You have not entered anything"
;;

esac