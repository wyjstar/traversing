#coding:utf8

import action
from gfirefly.server.logobj import logger
from gtwisted.core import reactor
from gfirefly.server.globalobject import GlobalObject
from shared.utils.ranking import Ranking


front_ip = GlobalObject().json_config['front_ip']
front_port = GlobalObject().json_config['front_port']
name = GlobalObject().json_config['name']


def init_guild_rank():
    try:
        level_configs = GlobalObject().json_config.get('Ranking_configs')
    except Exception, e:
        logger.exception(e)
        logger.error('Could not import the json config config.json')
    Ranking.init(level_configs)


def tick():
    result = GlobalObject().remote['login'].callRemote('server_sync',
                                                       name, front_ip,
                                                       front_port,
                                                       'recommend')
    if result is False:
        reactor.callLater(1, tick)
    else:
        reactor.callLater(60, tick)

reactor.callLater(1, tick)