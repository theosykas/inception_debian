#!/bin/bash

set -e

# create sock for 
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod +x /run/mysqld

if [ -z "${MYSQL_USER}" ] || [ -z "${MYSQL_DATABASE}" ]; then
	echo "Error environement variable not valid"
	exit 1

fi

if [ ! -f "/run/secrets/db_root_password" ] || \
	[ ! -f "/run/secrets/db_password" ]; then
	echo "missing secrets passwd"
	exit 1

fi

DB_ADM_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
echo "data base initialisation..."

# pour injecter sql faut que maria db soit bien installer et dans les bon fichiers
mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

# Lance MariaDB en arrière-plan pour ne pas bloquer le script
mysqld_safe &

# Met le script en pause 3s pour laisser le temps à MariaDB de démarrer 
# (et de créer son fichier de socket indispensable à la connexion)
sleep 3

# emmbeded script in script comm with mariadb engine
# flush appliaue les droits
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ADM_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo "db create succesfully"

mysqladmin -u root shutdown
sleep 2

else
	echo "data base already exist"

fi


echo "lunching mariadb..."
exec "$@"