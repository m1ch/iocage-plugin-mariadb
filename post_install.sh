#!/usr/local/bin/bash
sysrc mysql_enable="YES"
sysrc mysql_pidfile=/var/db/mysql/mysql.pid

mkdir /var/log/mysql
chown mysql /var/log/mysql

CFG_FILE="/usr/local/etc/mysql/my.cnf"

# sed -e "s/<hostname>/$(hostname)/" ${CFG_FILE}.template > ${CFG_FILE}

echo "Start mariaDB server"
service mysql-server start

MYUSER="root"
(cat /dev/urandom | strings | tr -dc A-Za-z0-9\?\!\.\#\(\)\-\_ | head -c32; echo) > /root/mysqlrootpassword

PASS=$(</root/mysqlrootpassword)

echo "Passwort = $PASS"

# set mysql-password
mysqladmin --user=$MYUSER password "$PASS"
echo "MySQL passwort set"

# Configure mysql
mysql -u $MYUSER -p"${PASS}" << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
DROP DATABASE IF EXISTS test;
EOF
