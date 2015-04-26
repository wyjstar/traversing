#coding:utf8

import action
from gfirefly.server.logobj import logger
from app.gate.core.users_manager import UsersManager
from gtwisted.core import reactor
from gfirefly.server.globalobject import GlobalObject
from shared.utils.ranking import Ranking
from shared.tlog import tlog_action
from app.gate.redis_mode import tb_character_info
from shared.utils.const import const


front_ip = GlobalObject().json_config['front_ip']
front_port = GlobalObject().json_config['front_port']
name = GlobalObject().json_config['name']


def tick():
    result = GlobalObject().remote['login'].server_sync_remote(name, front_ip,
                                                               front_port,
                                                               'recommend')
    if result is False:
        reactor.callLater(1, tick)
    else:
        reactor.callLater(60, tick)
    logger.info('server online num:%s', UsersManager().get_online_num())
    tlog_action.log('OnlineNum', UsersManager().get_online_num())

reactor.callLater(1, tick)
# 初始化工会排行
Ranking.init('GuildLevel', 9999)
Ranking.init('LevelRank1', 99999)
Ranking.init('LevelRank2', 99999)
Ranking.init('PowerRank1', 99999)
Ranking.init('PowerRank2', 99999)
Ranking.init('StarRank1', 99999)
Ranking.init('StarRank2', 99999)


def add_level_rank_info(instance, users):
    for uid in users:
        character_obj = tb_character_info.getObj(uid)
        character_info = character_obj.hmget(['level', 'attackpoint'])
        if character_info['attackpoint']:
            rank_value = character_info['attackpoint']
        else:
            rank_value = 0
        value = character_info['level'] * const.rank_xs + rank_value
        instance.add(uid, value)  # 添加rank数据

users = tb_character_info.smem('all')
print users

instance = Ranking.instance('LevelRank1')
add_level_rank_info(instance, users)

instance = Ranking.instance('LevelRank2')
add_level_rank_info(instance, users)
