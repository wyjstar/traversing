#!/bin/bash
# create db && restart cobar && check redis available


echo "start ....."


echo "create mysql db & table..."
mysql -h127.0.0.1 -uroot -p123456 -Ddb_traversing<../app/doc/databases/account.sql
redis-cli flushall

echo "clear mysql db & redis"

