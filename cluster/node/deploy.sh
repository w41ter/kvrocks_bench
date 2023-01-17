#!/bin/bash
set -ue

source config.sh
source cluster/config.sh

bash ~/cluster/node/download.sh
bash ~/cluster/node/install.sh
bash ~/cluster/node/update_config.sh
systemctl start kvrocks-${KVROCKS_PORT}.service
systemctl enable kvrocks-${KVROCKS_PORT}.service
