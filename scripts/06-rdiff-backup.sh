#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/06-rdiff-backup.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "rdiff-backup ?"
echo "Source: https://github.com/rdiff-backup/rdiff-backup"
echo "(y/N)"
read accept 

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group

# Installation des paquets essentiels
apk add rdiff-backup
mkdir -p /home/${name}/.rdiff/
cat > /home/${name}/.rdiff/basic-example << EOF; $(echo)
#!/bin/sh
# Setup
SOURCE="/source/folder/"
DESTINATION="/destination/folder/"

runuser -u ${name} rdiff-backup ${SOURCE} ${DESTINATION}
runuser -u ${name} rdiff-backup --force --remove-older-than 4B ${DESTINATION}
EOF
chown ${name}:${group} -R /home/${name}/.rdiff/

echo "rdiff-backup - Incremental backups" >> ${ROOT_DIR}/motd
echo "    - Create a script like /home/${name}/.rdiff/basic-example" >> ${ROOT_DIR}/motd
echo "    - Make it executable and put it on a /etc/periodic subfolder" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd