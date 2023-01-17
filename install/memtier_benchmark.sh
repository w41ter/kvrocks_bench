#!/bin/bash

apt-get install -y libpcre3-dev libevent-dev pkg-config zlib1g-dev libssl-dev
git clone https://github.com/RedisLabs/memtier_benchmark.git
cd memtier_benchmark
autoreconf -ivf
./configure
make -j`nproc`
sudo make install
