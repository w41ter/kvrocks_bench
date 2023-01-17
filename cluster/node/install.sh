#!/bin/bash

# This script will install kvrocks binaries and config files.
source config.sh
source cluster/config.sh

set -ue

WDR=${DEPLOY_DIR}/kvrocks-${KVROCKS_PORT}/
mkdir -p ${WDR}

if [[ ! -f ~/cluster/node/host ]]; then
    echo "host file '~/cluster/node/host' is lost"
    exit 1
fi
host=$(cat ~/cluster/node/host)

if systemctl is-active kvrocks-${KVROCKS_PORT}.service </dev/null >/dev/null; then
    echo "kvrocks-${KVROCKS_PORT}.service is still serving, please stop it first"
    exit 1
fi

function install_binary() {
    if [ ! -f ~/packages/${PACKAGE_NAME}.tar.gz ]; then
        echo "tarball ~/packages/${PACKAGE_NAME}.tar.gz is missing, please download it first"
        exit 1
    fi

    rm -rf ~/packages/${PACKAGE_NAME}/
    mkdir -p ~/packages/${PACKAGE_NAME}/
    tar zxf ~/packages/${PACKAGE_NAME}.tar.gz -C ~/packages/${PACKAGE_NAME}/
    rm -rf ${WDR}/bin
    ln -s ${HOME}/packages/${PACKAGE_NAME} ${WDR}/bin
}

function install_service() {
    # Directive        ulimit equivalent     Unit
    # LimitCPU=        ulimit -t             Seconds
    # LimitFSIZE=      ulimit -f             Bytes
    # LimitDATA=       ulimit -d             Bytes
    # LimitSTACK=      ulimit -s             Bytes
    # LimitCORE=       ulimit -c             Bytes
    # LimitRSS=        ulimit -m             Bytes
    # LimitNOFILE=     ulimit -n             Number of File Descriptors
    # LimitAS=         ulimit -v             Bytes
    # LimitNPROC=      ulimit -u             Number of Processes
    # LimitMEMLOCK=    ulimit -l             Bytes
    # LimitLOCKS=      ulimit -x             Number of Locks
    # LimitSIGPENDING= ulimit -i             Number of Queued Signals
    # LimitMSGQUEUE=   ulimit -q             Bytes
    # LimitNICE=       ulimit -e             Nice Level
    # LimitRTPRIO=     ulimit -r             Realtime Priority
    # LimitRTTIME=     No equivalent

    cat >/etc/systemd/system/kvrocks-${KVROCKS_PORT}.service <<EOF
[Unit]
Description=Kvrocks Service
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
LimitNOFILE=1000000
LimitSTACK=10485760
LimitCORE=infinity
User=root
ExecStart=${WDR}/scripts/run.sh
Restart=no
RestartSec=15s

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
}

function build_scripts() {
    mkdir -p ${WDR}/scripts

    local ENABLE_TCMALLOC_TEXT=""

    if [[ ${ENABLE_TCMALLOC:-false} == "true" ]]; then
        ENABLE_TCMALLOC_TEXT="export LD_PRELOAD=libtcmalloc_minimal.so.4"
    fi

    cat >${WDR}/scripts/run.sh <<EOF
#!/bin/bash

# enable kvrocks exporter
pkill kvrocks_exporter
setsid /root/kvrocks_exporter >/var/log/kvrocks-exporter.log 2>&1 &

${ENABLE_TCMALLOC_TEXT}
export TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES=${TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES:-1073741824}

cd ${WDR}
exec ${WDR}/bin/kvrocks -c ${WDR}/kvrocks.conf >${WDR}/log 2>&1

EOF
    chmod +x ${WDR}/scripts/run.sh
}

install_binary
build_scripts
install_service
