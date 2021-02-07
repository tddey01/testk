#!/usr/bin/env bash

if [ -d "/mnt/md0/ipfs/script" ]; then
  echo "目录存在 "
else
  bash -x /root/yungo/script/mount.sh
  if [ -d "/mnt/md0/ipfs/script" ]; then
    bash -x /mnt/md0/ipfs/script/mount/mount_nfs.sh
  else
    echo "ok"
  fi
fi


if [ -d "mnt/172.168.3.44/lotusminer"] && [ -d "mnt/172.168.3.43/lotusminer"] ;then


mnt/172.168.3.43/lotusminer

mnt/172.168.3.42/lotusminer
mnt/172.168.3.45/lotusminer



if [ X$? = "X0" ]
then
/usr/sbin/bash -x /mnt/md0/ipfs/script/mount/mount_nfs.sh
else
  exit 0
fi


