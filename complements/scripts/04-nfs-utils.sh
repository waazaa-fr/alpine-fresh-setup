#!/bin/sh

echo "--------------------------------------------------------"
echo "complements/scripts/04-nfs-utils.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/../..

echo "NFS client ?"
echo "(y/N)"
read accept

case ${accept} in n|N) 
    exit
esac

apk add nfs-utils
rc-update add nfsmount
rc-service nfsmount start