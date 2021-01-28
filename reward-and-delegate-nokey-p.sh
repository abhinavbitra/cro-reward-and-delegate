#!/bin/bash --

echo "Crypto.com Automatic Validator Operations inspired by Christian Vari"

if [ "$#" == 0 ]
then
    echo "Please run the script as:"
    echo "./reward-and-delegate-nokey-p.sh <operatorAddress> <validatorAddress> <keyPassword> <node>"
    exit 0
fi

operatorAddress=$1
validatorAddress=$2
keyPassword=$3
while [ true ]
do
    currentBalance=`./chain-maind query bank balances $operatorAddress --output=json --node $node | jq -r ".balances[0].amount"`
    echo "Current balance: $currentBalance"
    currentAvailableReward=`./chain-maind query distribution rewards $operatorAddress --output=json --node $node  | jq -r ".total[0].amount"`
    echo "Current Available Delegator Rewards: $currentAvailableReward"
    if (( $(echo "$currentAvailableReward > 100000000" |bc -l) )) 
    then
            echo "Withdrawing rewards...."
            echo $keyPassword | ./chain-maind tx distribution withdraw-rewards $validatorAddress --commission --from cross-fire-testing --gas 80000000 --gas-prices 0.1basetcro --chain-id "crossfire" --node https://crossfire.crypto.com:443  -y
    fi
    if (( $(echo "$currentBalance > 100000000" |bc -l) )) 
    then
            echo "Re-delegating rewards...."
            echo $keyPassword | ./chain-maind tx staking delegate $validatorAddress 0.0001tcro --from cross-fire-testing --gas 80000000 --gas-prices 0.1basetcro --chain-id "crossfire" --node https://crossfire.crypto.com:443  -y
    fi
    sleep 2s
done
