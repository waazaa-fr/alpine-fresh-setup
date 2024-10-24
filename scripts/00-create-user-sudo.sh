#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/00-create-user-sudo.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "Your username: "
read user_name
# Vérifications de saisie
while id ${user_name} &>/dev/null;
do
    echo "This user already exists."
    echo "Your username: (Ctrl+c to cancel)"
    read user_name
done

echo "User Id:"
read user_id
# Vérifications de saisie
while getent passwd ${user_id} >/dev/null;
do
    echo "Id ${user_id} already used."
    echo "Id: (Ctrl+c to cancel)"
    read user_id
done


echo "User Group:"
read user_group
# Vérifications de saisie
while ! getent group ${user_group} >/dev/null;
do
    echo "Group ${user_group} didn't exists."
    echo "Group: (Ctrl+c to cancel)"
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


echo "Add user ${user_name} to group wheel"
adduser ${user_name} wheel


# Stockage de variable dans des fichiers individuels pour utilisation ultèrieure si besoin
echo ${user_id} >> ${ROOT_DIR}/user_id
echo ${user_group} >> ${ROOT_DIR}/user_group
echo ${user_name} >> ${ROOT_DIR}/user_name


