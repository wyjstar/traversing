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

eval "ps -aef | grep python"
