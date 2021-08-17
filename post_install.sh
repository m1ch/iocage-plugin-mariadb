#!/usr/local/bin/bash
sysrc mysql_enable="YES"
sysrc mysql_pidfile=/var/db/mysql/mysql.pid
# sysrc mysql_optfile=/usr/local/etc/my.cnf

mkdir /var/log/mysql
chown mysql /var/log/mysql

CFG_FILE="/usr/local/etc/mysql/my.cnf"
sed -e "s/<hostname>/$(hostname)/" ${CFG_FILE}.template > ${CFG_FILE}

echo "Start mariaDB server"
service mysql-server start

MYUSER="root"
# openssl rand -base64 23 | sed -e 's/=//g' > /root/mysqlrootpassword
(cat /dev/urandom | strings | tr -dc A-Za-z0-9\?\!\.\#\(\) | head -c86; echo) > /root/mysqlrootpassword

PASS=$(</root/mysqlrootpassword)

echo "Passwort = $PASS"

# set mysql-password
mysqladmin --user=$MYUSER password "$PASS"
echo "MySQL passwort set"

# Configure mysql
mysql -u $MYUSER -p"${PASS}" << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${MYUSER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO '${MYUSER}'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;
DROP DATABASE IF EXISTS test;
EOF


echo "Configure and start adminer"
chmod +x /usr/local/bin/adminer.sh
chmod +x /usr/local/etc/rc.d/adminer

sysrc adminer_enable="YES"
service adminer start

#echo "@reboot /usr/local/bin/adminer.sh" | crontab -

#daemon -p /var/run/adminer.pid bash -c 'cd /usr/local/www/adminer; php -S `ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d" " -f2`:8080' > /dev/null

# /usr/local/www/adminer # php -S ip:8080
# php -S `ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d" " -f2`:8080
# sudo -u www php /usr/local/www/nextcloud/occ

# Save the config values 
#echo "$DB" > /root/dbname
#echo "$USER" > /root/dbuser
