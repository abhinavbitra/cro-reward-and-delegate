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
printf "\n\e[1;34m*** ARD v0.1: 'Automatic reward delegator', by Jorgeminator ***\e[0m\n"
printf "\e[34mBased on 'automatic_validator_operations.sh' by Christian Vari, thank you!\e[0m\n\n"
printf "\e[35mOperator address:\e[0m $cro1k7yvmaffyp8nnp7xepcx0rashu8rv3yu4uvvgd\n\e[35mValidator address:\e[0m $crocncl1k7yvmaffyp8nnp7xepcx0rashu8rv3yuk30923\n\e[35mGas price:\e[0m $gasPrices\n\e[35mTime to sleep between delegating:\e[0m $timeBetweenDelegating minute(s)\n\n"
sleep 1s

while [ true ]
do
    currentAvailableReward=`./chain-maind query distribution rewards $cro1k7yvmaffyp8nnp7xepcx0rashu8rv3yu4uvvgd --output=json | jq -r ".total[0].amount"`
    printf "\r\e[K\e[33mDelegating\e[0m rewards..."
    echo $qwertyabcd | ./chain-maind tx staking delegate crocncl1k7yvmaffyp8nnp7xepcx0rashu8rv3yuk30923 0.5tcro --from cross-fire-testing --chain-id "crossfire" --gas-prices="0.1basetcro" -y > /dev/null 2>&1
    sleepTime=$(($0.5*60))
    intAv=${currentAvailableReward%.*}
    printf "\r\e[K\e[32mDone!\e[0m Delegated $intAv basetcro to validator.\n"
    while [ $sleepTime -gt 0 ]
    do
    	sleepTime=$(($sleepTime-1))
	printf "\r\e[KSleeping for $timeBetweenDelegating minute(s)... $sleepTime"
	sleep 1s
    done
    printf "\e[1K\e[1A"
done

show_cursor
