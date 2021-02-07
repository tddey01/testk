#!/usr/bin/env bash
id="f0114687"
workdir="/mnt/md0/ipfs/script/log"
cd $workdir
tail -f lotus-miner.log | while read line
do
  echo $line | grep "mined new block" | grep "\"took\"\:" &> /dev/null
  if [ X$? = "X0" ]
  then
     block=`cat  $workdir/miner.log|grep block |grep took|wc -l`
     datetime=`date +'%Y-%m-%d %H:%M:%S'`
     time=`echo $line |grep block |grep "\"took\"\:" | jq .took|awk -F. '{print $1}'`
        /bin/bash /mnt/md0/ipfs/script/send_message.sh  "========恭喜出块 ======= \n 矿工集群 ：${id} \n 出块时间 : ${datetime} \n 计算时间 : ${time}秒 \n共计出块:  ${block}    \n  ========end=========== \n"
  fi
done

