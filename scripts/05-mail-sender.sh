#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/05-mail-sender.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "Mail sending ( mailx + msmtp) ?"
echo "(y/N)"
read accept 

case ${accept} in n|N) 
    exit
esac

# Lecture des données saisies
read -r name < ${ROOT_DIR}/user_name

# Installation des paquets essentiels
apk add msmtp mailx

# On déplace fs/mail/etc/* dans /etc
cp ${ROOT_DIR}/complements/fs/mail/etc/msmtprc /etc/

mkdir -p /etc/local.d/
cat > /etc/local.d/msmtp-sendmail.start << EOF; $(echo)
#!/bin/sh
ln -sf /usr/bin/msmtp /usr/bin/sendmail
ln -sf /usr/bin/msmtp /usr/sbin/sendmail
EOF
# On donne drois d'exécution
chmod +x /etc/local.d/msmtp-sendmail.start

# On exécute manuellement pour la prmière fois, ça évitera de redémarrer
/etc/local.d/msmtp-sendmail.start   

echo "root: <root email>" > /etc/aliases
echo "${name}: <${name} email>" >> /etc/aliases
echo "default: <others email>" >> /etc/aliases

echo "Mail Client for smtp sending" >> ${ROOT_DIR}/motd
echo "    1 - setup file /etc/msmtprc" >> ${ROOT_DIR}/motd
echo "    2 - edit file /etc/aliases" >> ${ROOT_DIR}/motd
echo "To send an email:" >> ${ROOT_DIR}/motd
echo '    echo "Mail content" | mail -s "Subject of email" ${name}' >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd