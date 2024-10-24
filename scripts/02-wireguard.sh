#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/02-wireguard.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "wireguard-tools ?"
echo "(y/N)"
read accept

case ${accept} in n|N) 
    exit
esac

apk add wireguard-tools wireguard-tools-wg
modprobe wireguard

