# alpine-fresh-setup

  

Script facilitant la mise en place de son utilisateur avec les droits sudo ainsi qu'une sélection d'applications pour l'os **Alpine Linux**.

  

# Utilisation

  

Depuis votre système Alpine fraîchement installé et en tant que root lancez le pas à pas avec:

    wget https://raw.githubusercontent.com/waazaa-fr/alpine-fresh-setup/main/install.sh; chmod a+x install.sh; ./install.sh

  
  

# Les étapes du pas à pas

- création de votre utilisateur avec droits sudo - NON OPTIONNEL

- proposition: **CIFS /SAMBA**

- proposition: **ZeroTier**

- proposition: **QEMU Guest Agent**

- proposition: environnement **Docker + Docker Compose**

- proposition: **Portainer** si vous avez choisis **Docker**

  Ces étapes se déroulent les unes après les autres. Des vérifications de saisies sont faites pour éviter au maximum de mauvaises saisies.
  

# Exécutables mis en place durant le pas à pas

Si vous choisissez d'installer Portainer alors vous aurez accès à différents exécutables qui sont logés dans le PATH (dans /usr/local/bin précisément). Ces exécutables s'exécutent simplement en lançant leurs noms en console.

**portainer-restart**  | **portainer-start** | **portainer-stop** | **portainer-update**

Portainer est installé via docker compose. 
Son **docker-compose.yml** se trouvera dans le home de votre user dans **~/.compose/portainer/**.
Il contient les paramètres saisies durant le pas à pas concernant le port coté hôte notamment.

Du coup si il y a une version plus récente de Portainer le script **portainer-update** fait ceci:

    cd ~/.compose/portainer/ && docker-compose pull && docker-compose up -d

Ce qui fait un pull qui ne fera quelque chose que si il y a une version différente et un up si quelque chose a changée. 
Comme l'utilisateur créé fait partie du groupe docker il ne faut pas manipuler Portainer avec root ou sudo.
Ces scripts ne peuvent pas être exécutés en tant que root ou sudo.



# Conseils d'utilisation

Ce script est au départ pour mon propre usage mais libre à vous de l'améliorer.

Dans le dossier scripts/ chaque fichier .sh s'y trouvant est traité dans une boucle les uns après les autres par ordre alphanumérique.

Si vous souhaitez ajouter votre propre script créez simplement un fichier dans ce dossier scripts/ en vous inspirant des autres.

  

Le script scripts/00-create-user-sudo.sh s'occupe de la création de l'utilisateur qui pourra sudo et créés à la fin de sa procédure 3 fichiers:

- **user_id** qui contient l'id spécifié

- **user_name** contient le nom d'utilisateur spécifié

- **user_group** contient le groupe spécifié

  

Ces fichiers sont supprimés à la fin du pas à pas mais sont disponible tout le long.

Donc si dans vos propres scripts vous avez besoin de ces infos vous pouvez les obtenir de la manière suivante:

  

id d'utilisateur créé:

    read -r uid < user_id    
    echo ${uid}

  

nom d'utilisateur créé:

    read -r name < user_name
    echo ${name}

  

groupe de cet utilisateur créé:

    read -r group < user_group
    echo ${group}



If you like this, consider buing me a coffee: https://buymeacoffee.com/waazaa

If you need an UnRAID license follow this link: https://unraid.net/pricing?via=4c3f80
