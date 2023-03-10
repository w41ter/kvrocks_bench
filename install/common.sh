#!/bin/bash

sudo apt update
sudo apt-get install -y apt-transport-https

# install essential tools
sudo apt-get install -y \
    software-properties-common \
    build-essential \
    libtool \
    python3 \
    libssl-dev \
    wget \
    curl \
    vim \
    tmux \
    linux-perf \
    git \
    gdb \
    sshpass \
    numactl \
    tar \
    jq \
    lsof \
    bc

# install monitors
# - htop
# - iotop
# - sysstat:            iostat sar psstat
# - smartmontools:      smartctl
# - nvme-cli:           nvme smart-log / list
sudo apt-get install -y \
    htop \
    iotop \
    sysstat \
    smartmontools \
    nvme-cli \
    tcpdump

# install bpf/bcc
sudo apt-get install -y \
	bpfcc-tools \
	linux-headers-`uname -r`

# install tcmalloc & cargo
sudo apt-get install -y \
    libtcmalloc-minimal4 \
    cargo

# install prometheus node exporter
# maybe import grafana dashboard from https://github.com/rfmoz/grafana-dashboards/blob/master/prometheus/node-exporter-full.json
sudo apt-get install -y \
    prometheus-node-exporter
