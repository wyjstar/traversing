#!/usr/bin/bash

databases_dir="app/doc/databases"
cobar_connect="mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing"

echo "modify database"
eval "$cobar_connect < $databases_dir/modify.sql"

echo "done"
exit 0
