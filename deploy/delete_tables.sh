#!/usr/bin/env bash

mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<../app/doc/databases/delete_all_tables.sql
echo 'flush_all' | nc localhost 1121
redis-cli flushall
