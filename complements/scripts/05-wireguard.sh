#!/bin/sh

echo "--------------------------------------------------------"
echo "complements/scripts/05-wireguard.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/../..

echo "Voulez vous installer wireguard-tools ?"
echo "(o/N)"
read accept

case ${accept} in n|N) 
    exit
esac

apk add wireguard-tools wireguard-tools-wg
modprobe wireguard

