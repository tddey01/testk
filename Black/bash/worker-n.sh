#!/bin/bash

push() {
  if [ -f /root/push.pid ]; then
    return 1
  else
    address=$(lotus-miner actor control list --verbose | grep worker | awk '{print $3}')
    push_time=$(date +%Y%m%d%H%M%S)
    echo $push_time
    line=$(lotus mpool pending --local --from $address --cids | wc -l)
    if [ $line -gt 5 ]; then
      echo $RANDOM >/root/push.pid
      for i in $(lotus mpool pending --local --from $address --cids | head -1); do
        sleep 1
        lotus mpool replace --gas-feecap 18000000000 --gas-premium 2708563 --gas-limit 60490216 $i
      done
      rm -f /root/push.pid
    fi
  fi
}

push
