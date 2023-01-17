#!/bin/bash

source config.sh

for ip in ${HOST_KVROCKS_NODES[@]}; do
    scp -r cluster/config.sh ${USER}@${ip}:~/cluster/config.sh
done
