#!/bin/bash
# traversing project deploy scripts.
# include:
# . start cobar for mysql
# . create mysql db & table
# . import config data
# . test port available && start traversing server
cobar_path="./cobar/bin/"


echo "start cobar for mysql..."
. $cobar_path"restart.sh"
echo "start cobar success."

#check redis port aviable....
redis-cli -p 6379 INFO>/dev/null

echo "create mysql db & table..."

mysql_root_info="mysql -h127.0.0.1 -uroot -p123456 -P8066<./app/doc/databases/"
. $mysql_root_info"db.sql"
mysql_test_info="mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<./app/doc/databases/"
. $mysql_test_info"traversing_master.sql"
. $mysql_test_info"traversing.sql"
. $mysql_test_info"account.sql"
. $mysql_test_info"config_data.sql"

echo "create mysql db & table success."

echo "start traversing server..."

nohup python startmaster.py &
echo "start traversing server success!"
