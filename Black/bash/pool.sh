#!/bin/bash
set -e
datetime=$(date +'%Y-%m-%d %H:%M:%S')
export RUST_BACKTRACE=full
export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1
export RUST_LOG=info

export LOTUS_PATH="/mnt/md0/data/lotus"
export LOTUS_MINER_PATH="/mnt/md0/data/lotusminer"
export LOTUS_BACKUP_BASE_PATH="/mnt/md1/metadata"

export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"
export FIL_PROOFS_PARAMETER_CACHE="/mnt/md0/filecoin-proof-parameters"
export FIL_PROOFS_PARENT_CACHE="/mnt/md0/filecoin-parents/"

export FIL_PROOFS_MAXIMIZE_CACHING=1
export SKIP_BASE_EXP_CACHE=1
#export TRUST_PARAMS=1
export FULLNODE_API_INFO="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.phDbosxVtxGk85YWEvfSCNWpNmMJF1Qrjlb4wdah0gA:/ip4/172.18.60.200/tcp/1234/http"
export GOLOG_LOG_FMT=json

pid=$(ps -ef | grep 'lotus-miner run' | egrep -v "log|grep" | awk '{print $2}')

if [ x"$pid" = "x" ]; then
  nvidia-smi
  if [ $? -ne 0 ]; then
    echo "ERROR: no GPU detected $IP"
    exit
  fi
  /mnt/md0/data/script/mount_hdd.sh
  /mnt/md0/data/script/lotus-miner run &
  sudo prlimit --nofile=1048576 --nproc=unlimited --rtprio=99 --nice=-19 --pid $!
  echo "${datetime}  lotus-miner restarted  successfully!" >>/mnt/md0/data/log/restart_press.log
else
  echo "${datetime}  lotus RUNNING  successfully!"
fi

wait
