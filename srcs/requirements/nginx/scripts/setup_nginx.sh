#!/bin/bash

set -e

if [ -z "${DOMAIN_NAME}" ]; then
	echo "Error domain nam var not found"
	exit 1

fi

if [ ! -f "/etc/ssl/certs/nginx.crt" ]; then
	echo "create ssl certificate"
	openssl req -x509 -nodes -newkey rsa:4096 -days 3650 \
	-keyout /etc/ssl/private/nginx.key \
	-out  /etc/ssl/certs/nginx.crt \
	-sha256 \
	-subj "/CN=${DOMAIN_NAME}"
	echo "domain name configurated with succes"
fi

# take pid1 position replace bash
echo "lunching nginx service deamon_off ..."
exec "$@"  # lunch serv ngnix (CMD/Dockerfile)