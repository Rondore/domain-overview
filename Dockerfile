# syntax=docker/dockerfile:1

FROM debian:latest

RUN apt update \
    && apt upgrade -y \
    && apt install -y nginx php-fpm dnsutils whois netbase openssl \
    && PHP_VER=$(ls /etc/php/ | sort -n | head -1) \
    && ln -s -T /usr/sbin/php-fpm$PHP_VER /usr/sbin/php-fpm

COPY . /var/www/html

WORKDIR /var/www/html

RUN PHP_VER=$(ls /etc/php/ | sort -n | head -1) \
    && sed "s/%PHP_VER%/$PHP_VER/" nginx-config > /etc/nginx/sites-enabled/default

EXPOSE 80

CMD ["/var/www/html/dockerStart.sh"]