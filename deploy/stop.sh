p_name="python"
for p_id in `ps -aef | grep $p_name | grep $USER |  grep -v grep | awk '{print $2}'`
do
    eval "kill -9 ${p_id}"
    echo "kill -9 ${p_id}"
done

eval "ps -aef | grep python"
