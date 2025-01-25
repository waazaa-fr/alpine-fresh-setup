#!/bin/sh

echo "--------------------------------------------------------"
echo "complements/scripts/00-bash.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/../..

echo "bash instead of ash ?"
echo "(y/N)"
read accept

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies ultèrieurement et stockées dans des fichiers individuels
read -r name < ${ROOT_DIR}/user_name
read -r group < ${ROOT_DIR}/user_group

apk add bash bash-doc bash-completion ncurses util-linux-bash-completion
touch /etc/profile.d/bash_completion.sh

# On va créer .profile et .bashrc
echo "exec /bin/bash" > /home/${name}/.profile

echo "source /etc/profile.d/bash_completion.sh" > /home/${name}/.bashrc
echo "PATH=$PATH:/home/${name}/.local/bin" >> /home/${name}/.bashrc
echo "alias dir='ls --color=never -alh'" >> /home/${name}/.bashrc
echo "alias lsa='ls -alh'" >> /home/${name}/.bashrc
echo "alias mkdir='mkdir --verbose'" >> /home/${name}/.bashrc    
echo 'export PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\\$ "' >> /home/${name}/.bashrc
echo 'export EDITOR="nano"' >> /home/${name}/.bashrc

mkdir -pm 0777 /home/${name}/.config
chown ${name}:${group} -R /home/${name}/.bashrc /home/${name}/.profile /home/${name}/.config

echo "exec /bin/bash" > /root/.profile

echo "source /etc/profile.d/bash_completion.sh" > /root/.bashrc
echo "PATH=$PATH:/root/.local/bin" >> /root/.bashrc
echo "alias dir='ls --color=never -alh'" >> /root/.bashrc
echo "alias lsa='ls -alh'" >> /root/.bashrc
echo "alias mkdir='mkdir --verbose'" >> /root/.bashrc
echo 'export PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\$ "' >> /root/.bashrc
echo 'export EDITOR="nano"' >> /root/.bashrc

# On change de shell pour les users actuels
sed -e 's;/bin/ash$;/bin/bash;g' -i /etc/passwd
