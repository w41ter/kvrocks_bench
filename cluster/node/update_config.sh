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

# Config descriptions:
# - block cache: 48GB, shared by subkey and metadata.
# - enable dynamic level bytes
# - disable wal
# - no compression
# - write buffer size 64MB
# - target file size base 128MB
cat >${WDR}/kvrocks.conf <<EOF
# daemonize yes
logbuflevel 0
minloglevel 0
bind 0.0.0.0
port ${KVROCKS_PORT}
cluster-enabled ${CLUSTER_MODE:-no}
log-dir ${WDR}/log/
dir ${WDR}/data/
max_io_mb 1024
rocksdb.max_write_buffer_number 128
rocksdb.cache_index_and_filter_blocks yes
rocksdb.level0_slowdown_writes_trigger 128
rocksdb.level0_stop_writes_trigger 512
rocksdb.level_compaction_dynamic_level_bytes yes
rocksdb.share_metadata_and_subkey_block_cache yes
rocksdb.subkey_block_cache_size 24576
rocksdb.metadata_block_cache_size 24576
rocksdb.write_options.disable_wal ${KVROCKS_DISABLE_WAL:-yes}
EOF
