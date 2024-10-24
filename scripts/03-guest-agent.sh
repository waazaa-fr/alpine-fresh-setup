#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/03-guest-agent.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "qemu-guest-agent ?"
echo "(y/N)"
read accept

case ${accept} in n|N) 
    exit
esac

apk add qemu-guest-agent
rc-update add qemu-guest-agent default
service qemu-guest-agent start

