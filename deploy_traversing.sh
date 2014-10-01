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

echo "import db.sql..."
mysql -uroot -p123456 -P8066<./app/doc/databases/db.sql

echo "import traversing_master.sql..."
mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<./app/doc/databases/traversing_master.sql
echo "import traversing.sql..."
mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<./app/doc/databases/traversing.sql
echo "import account.sql..."
mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<./app/doc/databases/account.sql
echo "import config_data.sql..."
mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<./app/doc/databases/config_data.sql

echo "create mysql db & table success."

echo "start traversing server..."

nohup python startmaster.py &
echo "start traversing server success!"
