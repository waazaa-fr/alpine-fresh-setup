#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/01-cifs.sh"
echo "--------------------------------------------------------"

ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "CIFS / SAMBA ?"
echo "(o/N)"
read accept

case ${accept} in n|N) 
    exit
esac

apk add cifs-utils samba