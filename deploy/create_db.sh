#!/bin/bash
# create db && restart cobar && check redis available
cobar_path="../cobar/bin/"


echo "start cobar for mysql..."
eval $cobar_path"restart.sh"
echo "start cobar success."

sleep 3

echo "create mysql db & table..."
mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<../app/doc/databases/traversing.sql
#mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<../app/doc/databases/modify.sql

echo "create mysql db & table success."

