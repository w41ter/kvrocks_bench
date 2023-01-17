#!/bin/bash

source config.sh
source cluster/config.sh

echo "Master node is ${INIT_NODE}"
for HOST in ${HOST_KVROCKS_NODES}; do
    if [[ $host == ${INIT_NODE} ]]; then
        redis-cli -p ${KVROCKS_PORT} -h ${host} slaveof no one
    else
        redis-cli -p ${KVROCKS_PORT} -h ${host} slaveof ${INIT_NODE} ${KVROCKS_PORT}
    fi
done
