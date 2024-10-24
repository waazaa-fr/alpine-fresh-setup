#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/10-tmate.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "tmate ?"
echo "https://tmate.io"
echo "(y/N)"
read accept 

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group


wget https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-amd64.tar.xz
tar xf tmate-2.4.0-static-linux-amd64.tar.xz
cd tmate-2.4.0-static-linux-amd64/
cp tmate /usr/local/bin/
cd .. 
rm -R tmate-2.4.0*
