#!/bin/bash
# create db && restart cobar && check redis available


echo "start ....."

redis-cli del "tb_rank:WorldBossDemage"
for i in `redis-cli keys tb_worldboss*`
do
    redis-cli del $i
done




