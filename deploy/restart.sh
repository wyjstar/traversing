
cd ..

wget localhost:20098/stop
if [ $? -eq 0 ];then
    echo "server stop success!"
else
    echo "server stop failure!"
fi


sh cobar/bin/restart.sh

if [ $? -eq 0 ];then
    echo "cobar restart success!"
else
    echo "cobar restart failure!"
fi

sleep 3

cd app/doc/databases/
#mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<insert_all.sql
mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<modify.sql
echo "update mysql  finish"

cd ../../../

echo "{
    \"server_name\": \"waiwang\",">my.json

echo "plesae input login_id:"
read login_id
echo "    \"login_ip\": \"$login_id\",">>my.json

echo "plesae input front_ip:"
read front_ip
echo "    \"front_ip\": \"$front_ip\"
}">>my.json


nohup python startmaster.py &
if [ $? -eq 0 ];then
    echo "server start success!"
else
    echo "server start failure!"
fi
