#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/10-dua.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "dua (Disk Usage Analyzer) ?"
echo "Source: https://github.com/Byron/dua-cli"
echo "(y/N)"
read accept 

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group


wget https://github.com/Byron/dua-cli/releases/download/v2.29.2/dua-v2.29.2-x86_64-unknown-linux-musl.tar.gz
tar xf dua-v2.29.2-x86_64-unknown-linux-musl.tar.gz
cd dua-v2.29.2-x86_64-unknown-linux-musl/
cp dua /usr/local/bin/
cd .. 
rm -R dua-v2.29.2*
