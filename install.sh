#!/bin/sh

VERSION="v0.0.8"

SYSTEM_USER_NAME=$(id -un)
if [[ ${SYSTEM_USER_NAME} != 'root'  ]]
then
    echo "ERREUR - Ne peut être exécuté que par root."
    exit 1
fi


echo "-------------------------------------------------------------------------------"
echo "        Script d'installation de base pour Alpine Linux. waazaa / ${VERSION} " 
echo "   Support: https://github.com/waazaa-fr/alpine-fresh-setup/issues              "
echo "   Licence: https://github.com/waazaa-fr/alpine-fresh-setup/blob/main/LICENSE   "
echo "-------------------------------------------------------------------------------"

echo "Ce script est fourni comme tel. Sans garantie de résultat et sous la Licence BSD 2-Clause Simplified License."
echo "Vous comprenez et acceptez ces termes ? (o/N)"
read accept

case ${accept} in n|N) 
    exit
    rm -R install.sh
esac


#################################################################
##  Les dépôts de départ avec le community activé
#################################################################
echo "---- Modifications des dépôts"
cat > /etc/apk/repositories << EOF; $(echo)
https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/main/
https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/community/
#https://dl-cdn.alpinelinux.org/alpine/edge/testing/
EOF

#################################################################
##  Préparation du terrain
#################################################################
echo "---- Installation de paquets utiles: nano git sudo curl tree runuser ntfs-3g fuse"
apk update > /dev/null && apk add nano git sudo curl tree runuser ntfs-3g fuse > /dev/null

modprobe fuse

echo "---- Le groupe wheel sera autorisé à sudo"
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

echo "---- Montage auto activé pour les partages distants listés dans /etc/fstab"
rc-update add netmount boot

echo "---- Activation de crond - Les scripts sont à placer dans les sous dossiers de /etc/periodic/"
rc-service crond start && rc-update add crond

#################################################################
##  On récupère les sources sur github
#################################################################
echo "---- Récupération des scripts sur github"
if [ -d "workdir" ]
then
    rm -R workdir/
fi
git clone --quiet https://github.com/waaman/alpine-fresh-setup.git workdir
cd workdir
ROOT_DIR=$(dirname $(readlink -f $0))
chmod a+x scripts/*.sh

echo "Installation via https://github.com/waaman/alpine-fresh-setup/" >> motd
echo "Ce pense bête se trouve dans /etc/motd" >> motd
printf "\n" >> motd


#################################################################
##  On exécute les scripts un à un
#################################################################
for f in ${ROOT_DIR}/scripts/*.sh; do
    sh "$f"
done


echo "---- Voulez vous le pas-à-pas de propositions des complémentaires ?"
echo "(o/N)"
read complementaires

case ${complementaires} in o|O) 
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


#################################################################
##  Ménage
#################################################################
echo "---- Ménage"
cd .. && rm -R workdir/ install.sh


echo "-------------------- Terminé -----------------------"
exit 0