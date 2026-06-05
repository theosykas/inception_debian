FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
	curl \
	php7.4-fpm \
	php7.4-mysql \
	php7.4-cli \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

# cli for WP service
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY config/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY scripts/wordpress.sh /wordpress.sh
RUN chmod -R +x /wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/wordpress.sh"]

# -F enforce PID 1
CMD [ "php-fpm7.4", "-F" ]