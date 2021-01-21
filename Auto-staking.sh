#!/bin/bash --

echo "Crypto.com Automatic staker abhi"

if [ "$#" == 0 ]
then
    echo "Please run the script as:"
    echo "./Auto-staking.sh <operatorAddress> <validatorAddress> <keyPassword> <node>"
    exit 0
fi

operatorAddress=$1
validatorAddress=$2
keyPassword=$3
node=$4
while [ true ]
do
            echo "Re-delegating rewards...."
            echo $keyPassword | ./chain-maind tx staking delegate $validatorAddress 1tcro --from cross-fire-testing --gas 80000000 --gas-prices 0.1basetcro --chain-id "crossfire" --node $node  -y
    fi
    sleep 1s
done
