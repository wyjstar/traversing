#!/usr/bin/bash

databases_dir="app/doc/databases"
cobar_connect="mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing"

echo "> insert data"
eval "$cobar_connect < $databases_dir/insert_all.sql"

exit 0
