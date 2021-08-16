# iocage-plugin-mariadb

## create the jail
iocage fetch -P ~/iocage-plugin-index/mariadb-kiss.json --name "test_mariadb" ip4_addr="vnet0|10.23.10.61/24" interfaces="vnet0:bridge10" vnet=1 defaultrouter="10.23.10.1"

iocage fetch --plugin-name "mariadb-kiss" --git_repository https://github.com/m1ch/iocage-plugin-index --branch kiss --name "test_redis" interfaces="vnet0:bridge10" vnet=1 defaultrouter="10.23.10.1" resolver="search local;nameserver 1.1.1.1"
