#!/bin/sh
 for i in *.sql
 do
    if [[ $i == delete* ]] || [[ $i == traversing_master* ]]
    then
        echo "filter the file $i"
        continue
    fi
    echo "file=$i"
    mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<$i
 done
