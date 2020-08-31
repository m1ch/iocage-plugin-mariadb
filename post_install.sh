
sysrc mysql_enable="YES"

service mysql-server start

USER="root"
DB=""
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 > /root/mysqlrootpassword
PASS=`cat /root/dbpassword`

#if [ -e "/root/.mysql_secret" ] ; then
#   # Mysql > 57 sets a default PW on root
#   TMPPW=$(cat /root/.mysql_secret | grep -v "^#")
#   echo "SQL Temp Password: $TMPPW"

# Configure mysql
mysql -u root -p"${TMPPW}" --connect-expired-password <<-EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${PASS}';
CREATE USER '${USER}'@'localhost' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${DB}.* TO '${USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Save the config values 
echo "$DB" > /root/dbname
echo "$USER" > /root/dbuser


mysql_secure_installation --defaults-file=/tmp/mariadbharden
rm -f /tmp/mariadbharden

#    Set Database root user password
#    Remove anonymous users
#    Disallow root user remote logins
#    Remove test database and access to it
