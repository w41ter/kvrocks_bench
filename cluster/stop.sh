#!/bin/bash

source config.sh
source cluster/config.sh

for node in ${HOST_KVROCKS_NODES[@]}; do
    ssh ${USER}@${node} "systemctl stop kvrocks-*.service" </dev/null
done
