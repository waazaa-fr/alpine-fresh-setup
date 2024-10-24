#!/bin/sh

VERSION="v0.1.0"

SYSTEM_USER_NAME=$(id -un)
if [[ ${SYSTEM_USER_NAME} != 'root'  ]]
then
    echo "ERREUR - Ne peut être exécuté que par root."
    exit 1
fi


echo "-------------------------------------------------------------------------------"
echo "        Install script for Alpine Linux. waazaa / ${VERSION} " 
echo "   Support: https://github.com/waazaa-fr/alpine-fresh-setup/issues              "
echo "   Licence: https://github.com/waazaa-fr/alpine-fresh-setup/blob/main/LICENSE   "
echo "-------------------------------------------------------------------------------"

echo "This script is provided as is. No guarantee of results and under the BSD 2-Clause Simplified License."
echo "Do you understand and accept these terms? (y/N)"
read accept

case ${accept} in n|N) 
    exit
    rm -R install.sh
esac


#################################################################
##  Les dépôts de départ avec le community activé
#################################################################
echo "---- Repository Changes"
cat > /etc/apk/repositories << EOF; $(echo)
https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/main/
https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/community/
#https://dl-cdn.alpinelinux.org/alpine/edge/testing/
EOF

#################################################################
##  Préparation du terrain
#################################################################
echo "---- Install base packages: nano git sudo curl tree htop rsync runuser ntfs-3g fuse util-linux"
apk update > /dev/null && apk add nano git sudo curl tree htop rsync runuser ntfs-3g fuse util-linux > /dev/null

# On active le module fuse
modprobe fuse
# On fait en sorte qu'il soit activé au boot
echo "fuse" >> /etc/modules
# On autorise la commande ping aux users
# De suite
echo "0 2147483647" > /proc/sys/net/ipv4/ping_group_range
# Et au boot
echo "net.ipv4.ping_group_range = 0 2147483647" >> /etc/sysctl.conf

echo "---- The wheel group will be allowed to sudo"
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

echo "---- Auto-mount enabled for remote shares listed in /etc/fstab"
rc-update add netmount boot

echo "---- Enabling crond - The scripts are to be placed in the subfolders of /etc/periodic/"
rc-service crond start && rc-update add crond

#################################################################
##  On récupère les sources sur github
#################################################################
echo "---- Retrieving the scripts from github"
if [ -d "workdir" ]
then
    rm -R workdir/
fi
git clone --quiet https://github.com/waazaa-fr/alpine-fresh-setup.git workdir
cd workdir
ROOT_DIR=$(dirname $(readlink -f $0))
chmod a+x scripts/*.sh complements/scripts/*.sh

# Pour que la commande proxmox soit assurée dans alpine
cp maintenance/shutdown /sbin/
chmod 0777 /sbin/shutdown
chmod a+x /sbin/shutdown


echo "Installation using https://github.com/waazaa-fr/alpine-fresh-setup/tree/main" >> motd
echo "This memo is on /etc/motd" >> motd
printf "\n" >> motd


#################################################################
##  On exécute les scripts un à un
#################################################################
for f in ${ROOT_DIR}/scripts/*.sh; do
    sh "$f"
done


echo "---- Do you want the step-by-step complementary proposals ?"
echo "(y/N)"
read complementaires

case ${complementaires} in o|O|y|Y) 
    #################################################################
    ##  On exécute les complements/scripts un à un
    #################################################################
    for f in ${ROOT_DIR}/complements/scripts/*.sh; do
        sh "$f"
    done
esac

# Le motd sera remplacé par celui remplis au fil des scripts
rm /etc/motd
cp ${ROOT_DIR}/motd /etc/motd


read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group
chown ${name}:${group} -R /home/${name} /home/${name}/*

#################################################################
##  Ménage
#################################################################
echo "---- Cleanup"
cd .. && rm -R workdir/ install.sh

echo "-------------------- Terminé -----------------------"
exit 0