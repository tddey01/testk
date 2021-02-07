#!/usr/bin/env bash
uuid=$(lsblk -f | grep md0 | sort -n | uniq -c | awk '{print $4}')

cat >/root/yungo/script/mount.sh <<EOF
#!/usr/bin/env bash
if [ -d /mnt/md0/ipfs ]; then
  if [ $(mount -l | grep 172.168.3.32 | wc -l) -eq 1 ]; then
    exit 0
  else
    mount -t nfs -o noatime 172.168.3.32:/mnt/md0/ipfs /mnt/md0/ipfs
  fi
else
  mount /dev/disk/by-uuid/$uuid /mnt/md0
  mount -t nfs -o noatime 172.168.3.32:/mnt/md0/ipfs /mnt/md0/ipfs
fi
EOF

#  if [ $(mount -l | grep " /mnt/172.168.3.$ip/disk22 " | wc -l) -eq 1 ] || (if [ -d /mnt/$ip/disk22 ]; then mount -t nfs -o noatime $ip:/mnt/disk22 /mnt/$ip/disk22; else mkdir -pv /mnt/$ip/disk22 && mount -t nfs -o noatime $ip:/mnt/disk22 /mnt/$ip/disk22; fi); then
#    echo "ok"

#  fi

/usr/bin/bash -x /mnt/md0/ipfs/script/mount-nfs.sh

/usr/bin/bash -x /root/yungo/script/mount.sh
lotus_id=$(ps aux | grep "lotus daemon" | grep -v grep)


 [ $(mount -l | grep " /mnt/md0/ipfs " | wc -l) -eq 1 ] || ( if [ -d /mnt/md0/ipfs ]; then  mount -t nfs -o noatime 172.168.3.32:/mnt/md0/ipfs /mnt/md0/ipfs; else  mkdir  -pv /mnt/md0/ipfs &&  mount -t nfs -o noatime $ip:/mnt/md0/ipfs /mnt/md0/ipfs ; fi ) }


 if [ $(ifconfig |grep 172 |awk  '{print $2}'|awk -F/ '{print $1}') -eq $ip ] ;then
    echo "ok"
 else
   echo "no"
 fi


e