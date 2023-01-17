#!/bin/bash

source config.sh
source cluster/config.sh

name=kvrocks-${KVROCKS_PORT}.service
systemctl stop ${name}
systemctl disable ${name}
rm -rf /etc/systemd/system/${name}
systemctl daemon-reload

WDR=${DEPLOY_DIR}/kvrocks-${KVROCKS_PORT}/
rm -rf ${WDR}/
