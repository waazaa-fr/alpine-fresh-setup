#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/02-zerotier.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "zerotier-one v1.10.2 ?"
echo "(y/N)"
read accept

case ${accept} in n|N) 
    exit
esac

modprobe tun

wget https://dl-cdn.alpinelinux.org/alpine/v3.17/community/x86_64/zerotier-one-openrc-1.10.2-r0.apk
wget https://dl-cdn.alpinelinux.org/alpine/v3.17/community/x86_64/zerotier-one-1.10.2-r0.apk
apk add zerotier-one-1.10.2-r0.apk 
apk add zerotier-one-openrc-1.10.2-r0.apk 
rc-update add zerotier-one
service zerotier-one start
rm -R zerotier-one-*



echo "ZEROTIER (help: sudo zerotier-cli -h)" >> ${ROOT_DIR}/motd
echo "    Join network: sudo zerotier-cli join <network-id>" >> ${ROOT_DIR}/motd
echo "    Leave network:   sudo zerotier-cli leave <network-id>" >> ${ROOT_DIR}/motd
echo "    List networks:  sudo zerotier-cli listnetworks" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd