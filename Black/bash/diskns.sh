#!/usr/bin/env bash
#net="192.168.100.1/24"
read -p "请输入NFS服务器IP地址0.0.0.0/24:" net
id1="b c d e f g h i j k l m  n o p q r s t u v w x y"
echo "$id1 案例"
#id="b c d e f g h i j k l m  n o p q r s t u v w x y"
read -p "请输入硬盘盘符最后一位字母" id

delline() {
  ulimit -n 1048576
  sed -i "/nofile/d" /etcn/security/limits.conf
  echo "* hard nofile 1048576" >>/etc/security/limits.conf
  echo "* soft nofile 1048576" >>/etc/security/limits.conf
  echo "root hard nofile 1048576" >>/etc/security/limits.conf
  echo "root soft nofile 1048576" >>/etc/security/limits.conf
  ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  timedatectl set-timezone Asia/Shanghai
  apt-get update
  apt-get install smartmontools hdparm nfs-common ntpdate xfsprogs chrony nfs-kernel-server iperf3 -y

  sed -i s/\#cron/cron/ /etc/rsyslog.d/50-default.conf
  echo '*.=info;*.=warn;mail.none;authpriv.none;cron.none   -/var/log/messages' >>/etc/rsyslog.d/50-default.conf
  systemctl restart rsyslog
  cat <<EOF >/etc/ntp.conf
driftfile /var/lib/ntp/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited
restrict 127.0.0.1
restrict ::1
restrict source notrap nomodify noquery
server 172.168.1.201
EOF
  apt-get install chrony
  systemctl restart ntp
  systemctl enable ntp
  ntpq -p
  cd /mnt
  mkdir disk1 disk2 disk3 disk4 disk5 disk6 disk7 disk8 disk9 disk10 disk11 disk12 disk13 disk14 disk15 disk16 disk17 disk18 disk19 disk20 disk21 disk22 disk23 disk24

}
delline

for i in $id; do
  ns=$(smartctl -a /dev/sd$i | grep Serial)
  echo sd$i $ns >>/tmp/disk.ns.txt
done

for i in $id; do
  parted /dev/sd$i mklabel gpt
  printf "Ignore\n" | parted /dev/sd$i mkpart primary 1 100%
done

for i in $id; do
  mkfs.xfs -f /dev/sd${i}1
done

uuid=$(lsblk -f | grep xfs | grep -Ev "(sda1|sda2)" | sort | awk '{print $NF}')

num=0
#mount /dev/disk/by-uuid/7485b12e-50ba-4a37-b05b-575f7d0b352a /mnt/disk24
for i in $uuid; do
  unm=$(expr $unm + 1)
  if [ -d /root/yungo/script ]; then
    rm /root/yungo/script/mount.sh
    echo "mount /dev/disk/by-uuid/$i  /mnt/disk$unm" >>/root/yungo/script/mount.sh
  else
    mkdir -pv /root/yungo/script
    echo "mount /dev/disk/by-uuid/$i  /mnt/disk$unm" >>/root/yungo/script/mount.sh
  fi
done

for i in $(seq 1 24); do
  mkdir /mnt/disk$i -p
  sed -i "/\/mnt\/disk$i/d" /etc/exports
  echo "/mnt/disk$i  $net(rw,no_root_squash,no_subtree_check,async)" >>/etc/exports
done
systemct restart nfs-server

exit 0

if [ $(ps -ef | grep lotus-worker | grep -v grep | awk '{print $2}' | wc -l) -eq 1 ]; then
  echo "进程存在 退出"
  exit 0
elif [ $(ps -ef | grep lotus-worker | grep -v grep | awk '{print $2}' | wc -l) -eq 0 ]; then
  /usr/bin/bash /mnt/md0/ipfs/script/run_worker.sh
  echo "$DATE restarted ${IP}" >>/mnt/md0/ipfs/log/restart_worker.log
fi

if [ $(ps -ef | grep lotus-worker | grep -v grep | awk '{print $2}' | wc -l) -eq 1 ]; then
  echo "进程存在 退出"
  exit 0
else
  /usr/bin/bash /mnt/md0/ipfs/script/run_worker.sh
  echo "$DATE restarted ${IP}" >>/mnt/md0/ipfs/log/restart_worker.log
fi
cat <<EOF >/etc/exports
  /mnt/disk1  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk2  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk3  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk4  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk5  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk6  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk7  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk8  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk9  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk10  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk11  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk12  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk13  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk14  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk15  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk16  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk17  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk18  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk19  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk20  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk21  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk22  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk23  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
  /mnt/disk24  172.168.0.0/16(rw,no_root_squash,no_subtree_check,async)
EOF

id="c  e"

if [ ! -d /root/yungo/script ]; then
  mkdir -vp /root/yungo/script
  echo "mount /dev/disk/by-uuid/$uuid  /mnt/md0" >/root/yungo/script/mount.sh
  echo "mount -t nfs -o noatime 172.168.3.32:/mnt/md0/ipfs  /mnt/md0/ipfs" >>/root/yungo/script/mount.sh
else
  if [ ! -f /root/yungo/script/mount.sh ]; then
    echo "mount /dev/disk/by-uuid/$uuid  /mnt/md0" >/root/yungo/script/mount.sh
    echo "mount -t nfs -o noatime 172.168.3.32:/mnt/md0/ipfs  /mnt/md0/ipfs" >>/root/yungo/script/mount.sh
  else
    echo "退出 exit"
  fi
fi

uuid=$(lsblk -f | grep md0 | sort -n | uniq -c | awk '{print $4}')
if [ ! -f /root/yungo/script/mount.sh ]; then
  mkdir -vp /root/yungo/script
  echo "mount /dev/disk/by-uuid/$uuid  /mnt/md0" >/root/yungo/script/mount.sh
  echo "mount -t nfs -o noatime 172.168.3.32:/mnt/md0/ipfs  /mnt/md0/ipfs" >>/root/yungo/script/mount.sh
else
  echo "退出 exit" && exit 0
fi

uuid=$(lsblk -f | grep md0 | sort -n | uniq -c | awk '{print $4}')
echo "mount /dev/disk/by-uuid/$uuid  /mnt/md0" >/root/yungo/script/mount.sh
echo "mount -t nfs -o noatime 172.168.3.32:/mnt/md0/ipfs  /mnt/md0/ipfs" >>/root/yungo/script/mount.sh

lotus-miner sealing workers | grep Worker | grep -v miner | awk '{print $4}' | awk -F: '{print $1}' | while read line; do echo $line && lotus-miner sealing jobs | grep -v ret-wait | grep -w $line | wc -l; done





#!/usr/bin/env bash
id="f0114687"
workdir="/mnt/md0/ipfs/script/log"
cd $workdir
tail -f miner.log | while read line
do
  echo $line | grep "mined new block" | grep "\"took\"\:" &> /dev/null
  if [ X$? = "X0" ]
  then
     #datetime1=`date +'%Y-%m-%d'`
     datetime=`date +'%Y-%m-%d %H:%M:%S'`
     block=`cat  $workdir/miner.log|grep block |grep took|wc -l`
     time=`echo $line |grep block |grep "\"took\"\:" | jq .took|awk -F. '{print $1}'`
     /bin/bash /mnt/md0/ipfs/script/send_message.sh   "========恭喜出块 ======= \n 矿工集群 ：${id} \n 出块时间 : ${datetime} \n 计算时间 : ${time}秒 \n共计出块:  ${block}    \n  ========end=========== \n"
     echo "========恭喜出块 ======= \n 矿工集群 ：${id} \n 出块时间 : ${datetime} \n 计算时间 : ${time}秒 \n共计出块:  ${block}    \n  ========end=========== \n" >> /mnt/md0/ipfs/log/check_new_block.log

done