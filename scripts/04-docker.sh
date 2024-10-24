#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/04-docker.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "Docker ?"
echo "(y/N)"
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


###############
## Portainer ##
###############

echo "Portainer ?"
echo "(y/N)"
read portainer

case ${portainer} in o|O|y|Y) 

    sudo -u ${name} mkdir -p /home/${name}/.compose/portainer/ /home/${name}/portainer/

    echo "Portainer Port listening ? (empty = defaut : 9000)"
    read portainer_port

    if [[ -z "${portainer_port}" ]]
    then
        portainer_port=9000
    fi

    # On doit vérifier que le port n'est pas utilisé
    while netstat -tulpn | grep :${portainer_port} >/dev/null;
    do
        echo "Port ${portainer_port} is already used. Choose another one."
        echo "Portainer Port listening ? (empty = defaut : 9000)"
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

    echo "Portainer running on port ${portainer_port}" >> ${ROOT_DIR}/motd
    printf "\n" >> ${ROOT_DIR}/motd
            
    echo "Portainer custom commands" >> ${ROOT_DIR}/motd
    echo "    portainer_stop | portainer_start | portainer_restart | portainer_update" >> ${ROOT_DIR}/motd
    printf "\n" >> ${ROOT_DIR}/motd
    
esac


################
## Lazydocker ##
################
echo "Lazydocker ?"
echo "Source: https://github.com/jesseduffield/lazydocker"
echo "(y/N)"
read lazydocker

case ${lazydocker} in n|N) 
    exit
esac

mkdir -pm 0777 /home/${name}/.config/lazydocker
wget https://github.com/jesseduffield/lazydocker/releases/download/v0.23.3/lazydocker_0.23.3_Linux_x86_64.tar.gz
tar xf lazydocker_0.23.3_Linux_x86_64.tar.gz
cp lazydocker /usr/local/bin/
rm -R lazydocker* LICENSE README.md

