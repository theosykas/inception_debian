FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
	openssl \
	nginx

# supprime config de base pour la notre
RUN rm -rf /etc/nginx/nginx.conf

# cp ma config dans le path de base ngnix
COPY ./config/nginx.conf /etc/nginx/nginx.conf

# cp my_sh a la racine (VMs)  CIBLE/cp
COPY scripts/setup_nginx.sh /setup_nginx.sh
RUN chmod -R +x /setup_nginx.sh

# --(https)
EXPOSE 443

ENTRYPOINT ["/setup_nginx.sh"]

CMD ["nginx", "-g", "daemon off;"]