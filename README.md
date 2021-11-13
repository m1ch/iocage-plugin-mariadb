## iocage-plugin-mariadb

This service provides a mysql server and nothing more! 

### create the plugin
    iocage fetch --plugin-name "mariadb" --git_repository https://github.com/m1ch/iocage-plugin-index --branch mariadb --name mariadb vnet=On dhcp=Off nat=On
 
### Clean-up after testing
ATTENTION: This deletes the jail and all contianing data!

    iocage destroy --recursive mariadb

## Use the server from the host
### Login to a MySQL-root shell from the host
    iocage exec mariadb bash -c 'PASS=$(</root/mysqlrootpassword); mysql -u root -p"${PASS}"'

### Execude SQL from the host shell
    iocage exec mariadb bash -c 'PASS=$(</root/mysqlrootpassword); mysql -u root -p"${PASS}" -e "SHOW DATABASES"'
or

    iocage exec mariadb bash -c 'PASS=$(\</root/mysqlrootpassword); mysql -u root -p"${PASS}"' << EOF
    SHOW DATABASES;
    USE MYSQL;
    SHOW TABLES;
    EOF

## Connect the server to an other jail
    set jail_name=mariadb
    set socket=`zfs list -o mountpoint | grep "iocage/.*${jail_name}/root" | head -n 1`/var/run/mysql
    
    iocage exec second_jail mkdir /var/run/mysql
    iocage fstab -a second_jail $socket /var/run/mysql nullfs ro 0 0
    
