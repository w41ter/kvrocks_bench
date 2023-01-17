#!/bin/bash

source config.sh
source cluster/config.sh

if [[ "${CLUSTER_MODE}" == "yes" ]]; then
    redis-cli -c -h ${HOST_KVROCKS_1} -p ${KVROCKS_PORT}
else
    redis-cli -h ${HOST_KVROCKS_1} -p ${KVROCKS_PORT}
fi
