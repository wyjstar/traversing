#!/bin/bash
# create db && restart cobar && check redis available
cobar_path="../cobar/bin/"


echo "start cobar for mysql..."
eval $cobar_path"restart.sh"
echo "start cobar success."


echo "create mysql db & table..."
mysql_root="mysql -uroot -p123456 -P8066<../app/doc/databases/"
mysql_test="mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<../app/doc/databases/"


echo "import traversing_master.sql..."
eval ${mysql_test}"traversing_master.sql"

echo "import traversing.sql..."
eval ${mysql_test}"traversing.sql"

echo "import modify.sql..."
eval ${mysql_test}"modify.sql"


echo "create mysql db & table success."
