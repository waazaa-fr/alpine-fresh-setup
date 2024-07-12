#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/04-docker.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "Environnement docker ?"
echo "(o/N)"
read accept

case ${accept} in n|N) 
    exit
esac

    
# Lecture des données saisies ultèrieurement et stockées dans des fichiers individuels
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group

apk add docker
apk add docker-compose
rc-update add docker default
service docker start
adduser ${name} docker

echo "Docker en tant que user (aide: docker -h)" >> ${ROOT_DIR}/motd
echo "    Démarrer|Arrêter|Redémarrer un container: docker container start|stop|restart <container_name>" >> ${ROOT_DIR}/motd
echo "    Supprimer un container: docker container rm <container_name>" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd

###############
## Portainer ##
###############

echo "Installer Portainer ?"
echo "(o/N)"
read portainer

case ${portainer} in n|N) 
    exit
esac

sudo -u ${name} mkdir -p /home/${name}/.compose/portainer/ /home/${name}/portainer/

echo "Sur quel port coté hôte doit-il écouter ? (vide = defaut : 9000)"
read portainer_port

if [[ -z "${portainer_port}" ]]
then
    portainer_port=9000
fi

# On doit vérifier que le port n'est pas utilisé
while netstat -tulpn | grep :${portainer_port} >/dev/null;
do
    echo "Le port ${portainer_port} est déja occupé. Désignez-en un autre."
    echo "Sur quel port coté hôte doit-il écouter ? (vide = defaut : 9000)"
    read portainer_port
    if [[ -z "${portainer_port}" ]]
    then
        portainer_port=9000
    fi
done

# On déplace le docker-compose.yml de portainer dans le dossier .compose/portainer du user
cp ${ROOT_DIR}/complements/portainer-compose.yml /home/${name}/.compose/portainer/docker-compose.yml
chown ${name}:${group} -R /home/${name}/.compose/portainer/docker-compose.yml

# On modifie notre compose
sudo -u ${name} sed -i "s/NAME/${name}/g" /home/${name}/.compose/portainer/docker-compose.yml
sudo -u ${name} sed -i "s/PORT/${portainer_port}/g" /home/${name}/.compose/portainer/docker-compose.yml


# Scripts de maintenance dans /usr/local/bin, on les chmod
chmod -R 0777 ${ROOT_DIR}/maintenance/portainer/portainer-*
chmod a+x ${ROOT_DIR}/maintenance/portainer/portainer-*      
cp ${ROOT_DIR}/maintenance/portainer/* /usr/local/bin/

# On installe portainer via docker-compose ce qui permettra un update simplifié
cd /home/${name}/.compose/portainer/ && sudo -u ${name} docker-compose pull && sudo -u ${name} docker-compose up -d 

echo "Portainer tourne sur le port ${portainer_port}" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd
        
echo "Portainer commandes (scripts présents dans /usr/local/bin)" >> ${ROOT_DIR}/motd
echo "    portainer_stop | portainer_start | portainer_restart | portainer_update" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd