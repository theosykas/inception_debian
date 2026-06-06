#!/bin/bash

set -e

cd /var/www/html

if [ -z "${DOMAIN_NAME}" ] || \
	[ -z "${WP_SUPER_USER}" ] || \
	[ -z "${MYSQL_DATABASE}" ]; then
	echo "Error environement variable not valid"
	exit 1
fi

if [ ! -f "/run/secrets/wp_guest_password" ] || \
	[ ! -f "/run/secrets/wp_root_password" ] || \
	[ ! -f "/run/secrets/db_password" ]; then
	echo "Error file /secrets is not detected"
	exit 1
fi

if [ ! -f "wp-settings.php" ]; then
	echo "Wordpress not found, init in progress"
	wp core download --allow-root --force

	# stock pass in var : db to log
	DB_PASSWORD=$(cat /run/secrets/db_password)

	wp config create \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${DB_PASSWORD}" \
		--dbhost="mariadb" \
		--allow-root


	WP_ROOT_PASS=$(cat /run/secrets/wp_root_password)

	# create admin user + init WP
	wp core install \
		--url=${DOMAIN_NAME} \
		--title="inception_wp" \
		--admin_user="${WP_SUPER_USER}" \
		--admin_password="${WP_ROOT_PASS}" \
		--admin_email="${WP_SUPER_MAIL}" \
		--allow-root

	WP_GUEST_PASSWD=$(cat /run/secrets/wp_guest_password)

	# guest user
	wp user create \
		"${WP_USER_GUEST}" \
		"${WP_GUEST_MAIL}" \
		--user_pass="${WP_GUEST_PASSWD}" \
		--role=author \
		--allow-root

	echo "wordpress init completed succesfully"

else
	echo "wordpress already exist and configurated"

fi

chown -R www-data:www-data /var/www/html

echo "lunching PHP_FPM..."
exec "$@"