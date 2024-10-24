#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/10-croc.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "croc ?"
echo "https://github.com/schollz/croc"
echo "(y/N)"
read accept 

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group


wget https://github.com/schollz/croc/releases/download/v10.0.13/croc_v10.0.13_Linux-64bit.tar.gz
tar xf croc_v10.0.13_Linux-64bit.tar.gz
cp croc /usr/local/bin/
rm -R croc* LICENSE
