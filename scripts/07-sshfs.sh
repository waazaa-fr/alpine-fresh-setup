#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/07-sshfs.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "SSHFS ?"
echo "(y/N)"
read accept 

case ${accept} in n|N) 
    exit
esac


# Installation des paquets essentiels
apk add sshfs

echo "SSHFS" >> ${ROOT_DIR}/motd
echo "    - Command: sshfs <user>@<ip.target>:/target/folder /local/folder/" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd