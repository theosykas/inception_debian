FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
	openssl \
	nginx

# remove origin conf
RUN rm -rf /etc/nginx/nginx.conf

COPY ./config/nginx.conf /etc/nginx/nginx.conf

# cp my_sh at root (VMs) CIBLE/cp
COPY scripts/setup_nginx.sh /setup_nginx.sh
RUN chmod -R +x /setup_nginx.sh

# --(https)
EXPOSE 443

ENTRYPOINT ["/setup_nginx.sh"]

CMD ["nginx", "-g", "daemon off;"]