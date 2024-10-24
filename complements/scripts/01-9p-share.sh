#!/bin/sh

echo "--------------------------------------------------------"
echo "complements/scripts/01-9p-share.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/../..

echo "Mount an 9p share ?"
echo "(y/N)"
read accept

case ${accept} in n|N) 
    exit
esac

echo "Mount tag (name of 9p share) ?"
read mount_tag

echo "Where to mount (BE CAREFUL: this folder will be created) ?"
read mount_folder

mkdir -p ${mount_folder}
chmod -R 0777 ${mount_folder}
echo "${mount_tag}        ${mount_folder}            9p         trans=virtio,version=9p2000.L,_netdev,rw 0 0" >> /etc/fstab
mount -a
