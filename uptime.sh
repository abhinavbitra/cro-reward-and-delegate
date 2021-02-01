#!/bin/bash

address=$1
hist=$2

if [ -z "$hist" ] || [ -z $address ] || [ ! $hist -gt 0 ] ; then
    echo ""
    echo -e "Usage:\n\t$0 validator_address number_of_history_blocks"
    echo ""
    echo -e "Example:\n\t$0 0E0DA7A5005429525A080C026D8DB0E7C85C5A11 20"
    echo ""
    echo "Hint: you can find your validator with the command:"
    echo -e "\tjq -r '.address' ~/.chain-maind/config/priv_validator_key.json"
    echo ""
    exit
fi

cheight=$(curl -s http://127.0.0.01:26657/commit | jq -r .result.signed_header.header.height)
lheight=$(expr $cheight - $hist)
address="B61C9F0D8BAF75AC5E35437221C869EE86A320AC"

sigs=0
for (( height=$lheight ; height < $cheight ; height++)); do
    sig=$( curl -s http://127.0.0.1:26657/block?height=$height | jq -r .result.block.last_commit.signatures | grep -c $address )
    echo "$height: $sig"
    sigs=$(( $sigs + $sig ))
done

perc=$( echo "$sigs / ( $hist / 100 )" | bc -l )
missed=$(( $hist - $sigs ))

printf '\nValidator %s signed %.2f%s of the last %d blocks.\n' $address $perc '%' $hist
echo "Number of missed signatures: ${missed}."
