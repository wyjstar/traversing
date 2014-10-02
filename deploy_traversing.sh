#!/bin/bash
# traversing project deploy scripts.
# include:
# . start cobar for mysql
# . create mysql db & table
# . import config data
# . test port available && start traversing server
cobar_path="./cobar/bin/"


echo "start cobar for mysql..."
eval $cobar_path"restart.sh"
echo "start cobar success."

#check redis port aviable....
redis-cli -p 6379 INFO>/dev/null

echo "create mysql db & table..."
mysql_root="mysql -uroot -p123456 -P8066<./app/doc/databases/"
mysql_test="mysql -h127.0.0.1 -utest -ptest -P8066 -Ddb_traversing<./app/doc/databases/"

echo "import db.sql..."
eval ${mysql_root}"db.sql"

echo "import traversing_master.sql..."
eval ${mysql_test}"traversing_master.sql"

echo "import traversing.sql..."
eval ${mysql_test}"traversing.sql"

echo "import account.sql..."
eval ${mysql_test}"account.sql"

echo "import config_data.sql..."
eval ${mysql_test}"config_data.sql"

echo "create mysql db & table success."

echo "start traversing server..."
p_name="startmaster"
p_ids=`ps -aef | grep $p_name | grep $USER |  grep -v grep | awk '{print $2}'`
for p_id in `ps -aef | grep $p_name | grep $USER |  grep -v grep | awk '{print $2}'`
do
    eval "kill -9 ${p_id}"
    echo "kill -9 ${p_id}"
done

p_name="appmain"
for p_id in `ps -aef | grep $p_name | grep $USER |  grep -v grep | awk '{print $2}'`
do
    eval "kill -9 ${p_id}"
    echo "kill -9 ${p_id}"
done

# eval "nohup python startmaster.py &"


echo "start traversing server success!"
