#!/bin/sh

ip_addr="$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d' ' -f2)"
/usr/local/bin/php -S ${ip_addr}:8080 -t /usr/local/www/adminer
