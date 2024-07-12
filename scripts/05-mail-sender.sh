#!/bin/sh

echo "--------------------------------------------------------"
echo "scripts/05-mail-sender.sh"
echo "--------------------------------------------------------"


ROOT_DIR=$(dirname $(readlink -f $0))/..

echo "Envoi de mail ( mailx + msmtp) ?"
echo "(o/N)"
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

echo "root: <email de root>" > /etc/aliases
echo "${name}: <email de ${name}>" >> /etc/aliases
echo "default: <email par defaut autrement>" >> /etc/aliases

echo "Mail client pour envoi" >> ${ROOT_DIR}/motd
echo "    1 - paramètrer le fichier /etc/msmtprc pour la connexion à votre fournisseur de mail" >> ${ROOT_DIR}/motd
echo "    2 - modifier le fichier /etc/aliases pour indiquer les adresses emails des utilisateurs" >> ${ROOT_DIR}/motd
echo "Une fois fait pour envoyer un email:" >> ${ROOT_DIR}/motd
echo '    echo "Corps de mail" | mail -s "Sujet du mail" <mail du destinataire>' >> ${ROOT_DIR}/motd
printf "\n" >> ${ROOT_DIR}/motd