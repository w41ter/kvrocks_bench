#!/bin/bash

# This scripts will generate config file for this server.

set -ue

source config.sh
source cluster/config.sh

WDR=${DEPLOY_DIR}/kvrocks-${KVROCKS_PORT}/
mkdir -p ${WDR}

# save former config.
if [ -e ${WDR}/kvrocks.conf ]; then
    mv ${WDR}/kvrocks.conf ${WDR}/kvrocks.conf.$(date +'%Y%d%m')
fi

cat >${WDR}/kvrocks.conf <<EOF
# daemonize yes
logbuflevel 0
minloglevel 0
bind 0.0.0.0
port ${KVROCKS_PORT}
cluster-enabled ${CLUSTER_MODE:-no}
log-dir ${WDR}/log/
dir ${WDR}/data/
EOF
