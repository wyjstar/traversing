#!/bin/bash
# create db && restart cobar && check redis available
cobar_path="../cobar/bin/"


echo "start cobar for mysql..."
eval $cobar_path"restart.sh"
echo "start cobar success."

#check redis port aviable....
redis-cli -p 6379 INFO>/dev/null

echo "create mysql db & table..."
mysql_root="mysql -uroot -p123456 -P8066<../app/doc/databases/"
mysql_test="mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<../app/doc/databases/"

echo "import db.sql..."
eval ${mysql_root}"db.sql"

echo "import traversing_master.sql..."
eval ${mysql_test}"traversing_master.sql"

echo "import traversing.sql..."
eval ${mysql_test}"traversing.sql"

echo "import account.sql..."
eval ${mysql_test}"account.sql"

echo "import config_data.sql..."
eval ${mysql_test}"config_data.sql"

echo "create mysql db & table success."

redis-cli flushdb

echo "clear redis..."
