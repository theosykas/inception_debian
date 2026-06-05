FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
	mariadb-server

COPY scripts/mariadb.sh /mariadb.sh
RUN chmod -R +x /mariadb.sh

COPY /config/listen.conf /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306

ENTRYPOINT ["/mariadb.sh"]

CMD  [ "mysqld", "--user=mysql" ]