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

* Le test ultime de l'évaluation : Un évaluateur va taper make fclean puis make up. Si ton WordPress se réinstalle tout seul et que tu peux te reconnecter sans erreur, tu as le 100/100.