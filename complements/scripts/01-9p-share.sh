#!/bin/sh

echo "--------------------------------------------------------"
echo "complements/scripts/01-9p-share.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/../..

echo "Voulez vous monter un share 9p ?"
echo "(o/N)"
read accept

case ${accept} in n|N) 
    exit
esac

echo "Quel est le mount tag (nom du share 9p) ?"
read mount_tag

echo "Dans quel dossier le monter (ATTENTION: ce dossier va être créé) ?"
read mount_folder

mkdir -p ${mount_folder}
chmod -R 0777 ${mount_folder}
echo "${mount_tag}        ${mount_folder}            9p         trans=virtio,version=9p2000.L,_netdev,rw 0 0" >> /etc/fstab
mount -a

echo "Montage partage 9p" >> ${ROOT_DIR}/motd
echo "    - Pour le montage auto regardez le fichier /etc/fstab" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd