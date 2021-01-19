#!/bin/bash

# v0.1

################################################
#               User variables                 #
################################################

operatorAddress="cro1k7yvmaffyp8nnp7xepcx0rashu8rv3yu4uvvgd" # tcro1...
validatorAddress="crocncl1k7yvmaffyp8nnp7xepcx0rashu8rv3yuk30923" # tcrocncl1...
keyName="cross-fire-testing" # Keyring name (often `Default`)
keyPassword="qwertyabcd" # Keyring password
gasPrices="0.1basetcro" # For fee calculation
timeBetweenDelegating="1" # Time to wait before next delegation attempt, in minutes

################################################
#            End of user variables             #
################################################

show_cursor() {
    tput cnorm
    clear
    exit
}
hide_cursor() {
    tput civis
}

trap show_cursor INT TERM

hide_cursor
clear
printf "\e[35mOperator address:\e[0m $operatorAddress\n\e[35mValidator address:\e[0m $validatorAddress\n\e[35mGas price:\e[0m $gasPrices\n\e[35mTime to sleep between delegating:\e[0m $timeBetweenDelegating minute(s)\n\n"
sleep 3s

while [ true ]
do
    printf "\r\e[K\e[33mDelegating\e[0m rewards..."
    echo $keyPassword | ./chain-maind tx staking delegate crocncl1k7yvmaffyp8nnp7xepcx0rashu8rv3yuk30923 1tcro --from $keyName --chain-id "crossfire" --gas-prices=gasPrices --keyring-backend file -y > /dev/null 2>&1
    sleepTime=$(($timeBetweenDelegating*60))
    printf "\r\e[K\e[32mDone!\e[0m Delegated 1tcro to validator.\n"
    while [ $sleepTime -gt 0 ]
    do
    	sleepTime=$(($sleepTime-1))
	printf "\r\e[KSleeping for $timeBetweenDelegating minute(s)... $sleepTime"
	sleep 1s
    done
    printf "\e[1K\e[1A"
done

show_cursor
