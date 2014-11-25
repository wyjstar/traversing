#!/usr/bin/bash

databases_dir="app/doc/databases"
cobar_connect="mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing"

echo "> recreate acccount"
eval "$cobar_connect < $databases_dir/account.sql"

echo "> recreate traversing"
eval "$cobar_connect < $databases_dir/traversing.sql"
echo "> recreate traversing_master"
eval "$cobar_connect < $databases_dir/traversing_master.sql"

exit 0
