#!/bin/sh

echo "--------------------------------------------------------"
echo "complements/scripts/03-build-tools.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/../..

echo "Voulez vous installer les paquets nécessaires aux compilations ?"
echo "(o/N)"
read accept

case ${accept} in n|N) 
    exit
esac

apk add build-base cmake

