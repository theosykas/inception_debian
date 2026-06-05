1. Structure des dossiers (scripts/ vs tools/)
  Conforme : Oui.
  Le sujet montre un exemple de ls -laR avec des dossiers conf/ et tools/. Le fait que tu aies nommé tes dossiers config/ et scripts/ n'est absolument pas une erreur. Le sujet indique "Below is an example of
  the expected directory structure". Tant que tout est cloisonné dans srcs/ et srcs/requirements/, tu es totalement libre et les évaluateurs valident parfaitement cette nomenclature.


  2. Le piège de la version Debian (Dockerfile)
  Attention requise :
  Dans tes Dockerfiles, tu utilises FROM debian:bookworm. Bookworm (Debian 12) est la version stable actuelle.
  Le sujet (page 7) exige très spécifiquement : "the containers must be built either from the penultimate stable version of Alpine or Debian".
   - La pénultième (l'avant-dernière) version stable de Debian est `bullseye` (Debian 11).
  💡 Indice : Si tu tombes sur un évaluateur pointilleux, il pourrait te pénaliser. Je te conseille vivement de changer debian:bookworm par debian:bullseye dans tes 3 Dockerfiles. Tes scripts fonctionneront
  de manière identique.


  3. Noms des images (docker-compose.yml)
  Attention requise :
  Le sujet demande : "Each Docker image must have the same name as its corresponding service."
  Actuellement, dans ton docker-compose.yml, tu utilises build: ./requirements/nginx. Par défaut, Docker Compose va nommer ton image <nom_du_dossier>-nginx (ex: inception_debian-nginx).
  💡 Indice : Pour forcer le nom exact, ajoute la directive image: sous chaque service dans ton docker-compose.yml :


   1   nginx:
   2     image: nginx    # <--- Ajoute ceci
   3     build: ./requirements/nginx
   4     container_name: nginx
   5     ...
  (Fais de même avec `image: mariadb` et `image: wordpress`).


  4. Le mot de passe Root ignoré (mariadb.sh)
  Attention requise :
  Dans mariadb.sh, tu lis le secret du root : DB_ADM_PASSWORD=$(cat /run/secrets/db_root_password).
  Cependant, dans ton bloc SQL d'initialisation, tu ne l'utilises nulle part !


   1 CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
   2 CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
   3 GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
   4 FLUSH PRIVILEGES;
  Cela signifie que ton utilisateur root de la base de données reste sans mot de passe sécurisé.
  💡 Indice : Ajoute une ligne pour verrouiller l'utilisateur root de MariaDB avec ton mot de passe secret dans ce bloc SQL (ex: ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ADM_PASSWORD}';).


  5. Nom de l'admin WordPress (.env)
  Rappel de sécurité (Sujet page 8) :
  Assure-toi que la valeur de ta variable WP_USER_ADMIN (dans ton fichier .env) ne contient pas le mot admin ou administrator sous aucune forme (ex: pas de admin-123, pas de Admin). Le script wordpress.sh est
  parfait, la contrainte repose uniquement sur ce que tu vas taper dans ton .env lors de l'évaluation !


  6. Ce qui est Parfait (Ne touche à rien ici !)
   * PID 1 & Daemonisation : Tes commandes exec "$@" à la fin de tous tes scripts, combinées à CMD ["nginx", "-g", "daemon off;"], mysqld_safe (puis arrêt propre) et php-fpm -F sont de véritables cas d'école.
     Tu valideras cette partie (très souvent ratée par les élèves) haut la main.
   * Docker Secrets : Le fait que tu utilises les secrets: dans le compose et que tes scripts aillent lire dans /run/secrets/ est fortement récompensé.
   * TLSv1.2/1.3 : Ta configuration ssl_protocols TLSv1.2 TLSv1.3; est exacte.
   * Volumes Locaux : Ta manière de déclarer les volumes dans le compose avec driver: local et device: /home/thsykas/... respecte la demande d'utiliser des "Named Volumes" tout en pointant sur le dossier data
     de l'hôte.


Dernier conseil de "vieux de la vieille" : Juste avant de rendre, fais un git status pour être SÛR que ton fichier .env et tes fichiers dans secrets/ ne sont PAS suivis par Git. C'est l'erreur fatale qui
  donne 0 au projet (Sujet page 9 et 11).

* Le test ultime de l'évaluation : Un évaluateur va taper make fclean puis make up. Si ton WordPress se réinstalle tout seul et que tu peux te reconnecter sans erreur, tu as le 100/100.
   * La partie Bonus (0% actuellement) : Ton projet actuel ne contient pas les bonus (Redis, FTP, Adminer, site statique, etc.).
       * Note importante : Le sujet précise (page 16) que les bonus ne sont comptés que si la partie obligatoire est parfaite. En sécurisant tes 100% sur le obligatoire, tu t'ouvres la porte aux bonus si tu
         décides de les faire.
