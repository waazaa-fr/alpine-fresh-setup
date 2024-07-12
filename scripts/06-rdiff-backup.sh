#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/06-rdiff-backup.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "rdiff-backup (sauvegardes incrémentales) ?"
echo "(o/N)"
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
cat > /home/${name}/.rdiff/basic-exemple << EOF; $(echo)
#!/bin/sh
# A modifier
SOURCE="/dossier/source/"
DESTINATION="/dossier/destination/"

runuser -u ${name} rdiff-backup ${SOURCE} ${DESTINATION}
runuser -u ${name} rdiff-backup --force --remove-older-than 4B ${DESTINATION}
EOF
chown ${name}:${group} -R /home/${name}/.rdiff/

echo "rdiff-backup - Sauvegardes incrémentales et versioning" >> ${ROOT_DIR}/motd
echo "    - Créez votre script de sauvegarde en vous inspirant de /home/${name}/.rdiff/basic-exemple" >> ${ROOT_DIR}/motd
echo "    - Rendez le exécutable et déposez le dans un des dossiers de /etc/periodic qui vous convient le mieux" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd