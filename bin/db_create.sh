#!/usr/bin/bash

databases_dir="app/doc/databases"
#cobar_connect="mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing"
cobar_connect="mysql -h127.0.0.1 -utest -ptest -P3306 -Ddb_traversing"

echo "rebuild acccount database"
eval "$cobar_connect < $databases_dir/account.sql"

echo "rebuild traversing database"
eval "$cobar_connect < $databases_dir/traversing.sql"
eval "$cobar_connect < $databases_dir/traversing_master.sql"

echo "done"
exit 0
