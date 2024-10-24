#!/bin/sh

echo "--------------------------------------------------------"
echo "complements/scripts/02-python3-pip.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/../..

echo "python3 pip ?"
echo "(y/N)"
read accept

case ${accept} in n|N) 
    exit
esac

apk add build-base musl-dev linux-headers musl-locales python3-dev py3-pip 

# Lecture des données saisies ultèrieurement et stockées dans des fichiers individuels
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group

# La conf pour permettre de pip sans venv
mkdir -pm 0777 /home/${name}/.config/pip/
echo "[global]" > /home/${name}/.config/pip/pip.conf
echo "break-system-packages = true" >> /home/${name}/.config/pip/pip.conf

# Mise à jour pip
pip install --upgrade pip