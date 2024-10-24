#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/07-restic.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "restic ?"
echo "https://restic.net"
echo "(y/N)"
read accept 

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group

apk add restic

echo "restic" >> ${ROOT_DIR}/motd
echo "    - Command: restic -r /repo/folder init" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd