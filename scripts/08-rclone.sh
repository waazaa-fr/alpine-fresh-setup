#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/08-rclone.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "rclone ?"
echo "(o/N)"
read accept 

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group


curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
cp rclone /usr/local/bin/
chown ${name}:${group} /usr/local/bin/rclone
chmod 755 /usr/local/bin/rclone
cd .. 
rm -R rclone-*

echo "rclone" >> ${ROOT_DIR}/motd
echo "    - Commande: rclone config" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd