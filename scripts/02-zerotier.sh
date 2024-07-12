#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/02-zerotier.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "zerotier-one ?"
echo "(o/N)"
read accept

case ${accept} in n|N) 
    exit
esac

modprobe tun
apk add zerotier-one
rc-update add zerotier-one default
service zerotier-one start

echo "ZEROTIER (aide: sudo zerotier-cli -h)" >> ${ROOT_DIR}/motd
echo "    Rejoindre un rezal: sudo zerotier-cli join <identifiant-rezal>" >> ${ROOT_DIR}/motd
echo "    Quitter un rezal:   sudo zerotier-cli leave <identifiant-rezal>" >> ${ROOT_DIR}/motd
echo "    Lister les rezals:  sudo zerotier-cli listnetworks" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd