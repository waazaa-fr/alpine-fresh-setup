#!/bin/sh

echo "--------------------------------------------------------"
echo "complements/scripts/02-python3-pip.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/../..

echo "Voulez vous installer python3 pip ?"
echo "(o/N)"
read accept

case ${accept} in n|N) 
    exit
esac

apk add py3-pip

