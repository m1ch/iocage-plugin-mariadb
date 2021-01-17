#!/bin/sh

cd /usr/local/www/adminer
php -S `ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d" " -f2`:8080
