# -*- coding:utf-8 -*-
"""
created by sphinx on
"""

from gtwisted.core import reactor
from gfirefly.dbentrust import util
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
from app.transit.root.messagecache import message_cache
from shared.db_opear.configs_data.game_configs import base_config


groot = GlobalObject().root


tick_peroid = base_config.get('arena_shorttime_points_time')
PVP_TABLE_NAME = 'tb_pvp_rank'


def pvp_award_tick():
    reactor.callLater(tick_peroid, pvp_award_tick)
    try:
        pvp_award()
    except Exception, e:
        logger.exception(e)
    except:
        logger.error(traceback.format_exc())


def pvp_award():
    arena_award = base_config.get('arena_shorttime_points')
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'character_id>1000', ['id', 'character_id'])

    for k in records:
        childs = groot.childsmanager.childs
        rank = k['id']
        for up, down, score in arena_award.values():
            if rank >= up and rank <= down:
                award = score
                break
        else:
            logger.error('pvp award error:%s', k)
            continue

        for child in childs.values():
            if 'gate' in child.name:
                result = child.pull_message_remote('pvp_award_remote', k['character_id'], (award,))
                if type(result) is bool and result:
                    break
                else:
                    logger.debug('pvp_award_tick result:%s,%s,%s', result, k, award)
        else:
            message_cache.cache('pvp_award_remote', k['character_id'], award)
