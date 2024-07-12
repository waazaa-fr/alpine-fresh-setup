#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/00-create-user-sudo.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "Nom de l'utilisateur à créer: "
read user_name
# Vérifications de saisie
while id ${user_name} &>/dev/null;
do
    echo "Cet utilisateur existe déja."
    echo "Nom de l'utilisateur à créer: (Ctrl+c pour annuler)"
    read user_name
done

echo "Son id: (vide = defaut: 99)"
read user_id
# Vérifications de saisie
while getent passwd ${user_id} >/dev/null;
do
    echo "L'id ${user_id} est déja pris."
    echo "Son id: (Ctrl+c pour annuler)"
    read user_id
done


echo "Son groupe: (vide = defaut: users)"
read user_group
# Vérifications de saisie
while ! getent group ${user_group} >/dev/null;
do
    echo "Le groupe ${user_group} n'existe pas."
    echo "Son groupe: (Ctrl+c pour annuler)"
    read user_group
done


if [[ -z ${user_id} ]] && [[ -z ${user_group} ]]
    then
        user_id=99
        user_group=users
        adduser -u 99 -G users ${user_name} 
    elif  [[ -z ${user_id} ]]
    then
        user_id=99
        adduser -u ${user_id} -G ${user_group} ${user_name}         
    elif  [[ -z ${user_group} ]]
    then
        user_group=users
        adduser -u ${user_id} -G ${user_group} ${user_name} 
    else
        adduser -u ${user_id} -G ${user_group} ${user_name} 
fi


echo "Ajout de l'utilisateur dans le groupe wheel"
adduser ${user_name} wheel

# Stockage de variable dans des fichiers individuels pour utilisation ultèrieure si besoin
echo ${user_id} >> ${ROOT_DIR}/user_id
echo ${user_group} >> ${ROOT_DIR}/user_group
echo ${user_name} >> ${ROOT_DIR}/user_name


echo "Votre utilisateur avec les droits sudo est: ${user_name}" >> ${ROOT_DIR}/motd
echo "    Son home est /home/${user_name}" >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd

