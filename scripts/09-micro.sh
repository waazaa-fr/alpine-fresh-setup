#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/09-micro.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "micro (terminal-based text editor) ?"
echo "Source: https://github.com/zyedidia/micro"
echo "(y/N)"
read accept 

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group


wget https://github.com/zyedidia/micro/releases/download/v2.0.14/micro-2.0.14-linux64.tar.gz
tar xf micro-2.0.14-linux64.tar.gz
cd micro-2.0.14/
cp micro /usr/local/bin/
cd .. 
rm -R micro-2.0.14/
