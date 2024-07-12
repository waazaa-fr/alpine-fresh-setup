#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/07-sshfs.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "SSHFS (montage de dossier distant via ssh) ?"
echo "(o/N)"
read accept 

case ${accept} in n|N) 
    exit
esac


# Installation des paquets essentiels
apk add sshfs

echo "SSHFS - Montage de dossiers distants via ssh" >> ${ROOT_DIR}/motd
echo "    - Commande: sshfs <user>@<ip.distante>:/dossier/distant /dossier/local/" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd