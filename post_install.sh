#!/usr/local/bin/bash
sysrc mysql_enable="YES"
sysrc mysql_pidfile=/var/db/mysql/mysql.pid
sysrc mysql_optfile=/usr/local/etc/my.cnf

mkdir /var/log/mysql
chown mysql /var/log/mysql

service mysql-server start

USER="root"
openssl rand -base64 23  > /root/mysqlrootpassword
PASS=$(</root/mysqlrootpassword)

# set mysql-password
mysqladmin --user=root password "$PASS"

# Configure mysql
mysql -u root -p"${PASS}" <<-EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${USER}'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
DROP DATABASE IF EXISTS test;
EOF

chmod +x /usr/local/bin/adminer.sh
echo "@reboot /usr/locat/bin/adminer.sh" | crontab -

# /usr/local/www/adminer # php -S ip:8080
# php -S `ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d" " -f2`:8080
# sudo -u www php /usr/local/www/nextcloud/occ

# Save the config values 
echo "$DB" > /root/dbname
echo "$USER" > /root/dbuser
