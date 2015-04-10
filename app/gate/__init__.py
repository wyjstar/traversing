#coding:utf8

import action
from gfirefly.server.logobj import logger
from app.gate.core.users_manager import UsersManager
from gtwisted.core import reactor
from gfirefly.server.globalobject import GlobalObject
from shared.utils.ranking import Ranking


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

reactor.callLater(1, tick)
# 初始化工会排行
Ranking.init('GuildLevel', 9999)
