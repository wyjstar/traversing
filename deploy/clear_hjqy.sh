#!/bin/bash
# create db && restart cobar && check redis available


echo "start ....."

redis-cli del "tb_rank:HjqyBossDemage"
for i in `redis-cli keys tb_hjqyboss*`
do
    redis-cli del $i
done




