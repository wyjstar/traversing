# -*- coding:utf-8 -*-
"""
created by sphinx on
"""

from gtwisted.core import reactor
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
from app.transit.root.messagecache import message_cache
from shared.db_opear.configs_data import game_configs
from gfirefly.dbentrust.redis_mode import RedisObject
tb_pvp_rank = RedisObject('tb_pvp_rank')
#from app.game.redis_mode import tb_pvp_rank
import time
import traceback
from shared.utils.mail_helper import deal_mail
from gfirefly.dbentrust.redis_mode import RedisObject
from shared.tlog import tlog_action

tb_pvp_rank = RedisObject('tb_pvp_rank')

groot = GlobalObject().root


PVP_TABLE_NAME = 'tb_pvp_rank'


def pvp_award_tick():
    tick_time = game_configs.base_config.get('arena_shorttime_points_time')
    reactor.callLater(tick_time, pvp_award_tick)
    try:
        pvp_award()
    except Exception, e:
        logger.exception(e)
    except:
        logger.error(traceback.format_exc())


def pvp_award():
    arena_award = game_configs.base_config.get('arena_shorttime_points')

    records = tb_pvp_rank.zrangebyscore(0, 10000, withscores=True)

    childs = groot.childsmanager.childs
    for k, v in records:
        rank = int(v)
        character_id = int(k)
        if character_id < 10000:
            continue
        for up, down, score in arena_award.values():
            if rank >= up and rank <= down:
                award = score
                break
        else:
            logger.error('pvp award error:%s', k)
            continue

        for child in childs.values():
            if 'gate' in child.name:
                result = child.pull_message_remote('pvp_award_remote',
                                                   character_id,
                                                   (award,))
                if type(result) is bool and result:
                    logger.debug('pvp_award_tick result:%s,%s,%s',
                                 result, k, award)
                    break
        else:
            logger.debug('pvp_award_tick cache:%s,%s', k, award)
            message_cache.cache('pvp_award_remote', character_id, award)


def pvp_daily_award_tick():
    award_time_x = game_configs.base_config.get('arena_day_points_time')
    award_time = time.strftime("%Y-%m-%d %X", time.localtime())[0:-8]
    award_time += award_time_x
    now_time = int(time.time())
    award_strptime = time.strptime(award_time, "%Y-%m-%d %X")
    award_mktime = time.mktime(award_strptime)
    time_long = award_mktime - now_time
    if time_long >= 0:
        time_interval = time_long
    else:
        time_interval = 60*60*24 + time_long
    logger.debug('pvp daily award -tick interval time:%s', time_interval)
    reactor.callLater(time_interval, do_pvp_daily_award_tick)


def do_pvp_daily_award_tick():
    # reactor.callLater(60*60*24, do_pvp_daily_award_tick)
    try:
        pvp_daily_award()
    except Exception, e:
        logger.exception(e)
    except:
        logger.error(traceback.format_exc())


def pvp_daily_award():
    logger.debug('pvp daily send award mail ')
    arena_award = game_configs.base_config.get('arena_day_points')
    records = tb_pvp_rank.zrangebyscore(0, 10000, withscores=True)

    childs = groot.childsmanager.childs
    for k, v in records:
        rank = int(v)
        character_id = int(k)
        if character_id < 10000:
            continue
        for up, down, mail_id in arena_award.values():
            if rank >= up and rank <= down:
                break
        else:
            logger.error('pvp daily award error:%s-%s', rank, character_id)
            continue

        mail_data, _ = deal_mail(conf_id=mail_id, receive_id=character_id)

        for child in childs.values():
            if 'gate' in child.name:
                result = child.pull_message_remote('receive_mail_remote',
                                                   character_id,
                                                   (mail_data,))
                if type(result) is bool and result:
                    break
                else:
                    logger.debug('pvp_daily_award_tick result:%s,%s,%s',
                                 result, k, mail_data)
        else:
            message_cache.cache_time('receive_mail_remote', character_id, 60*60*24*180, mail_data)
        tlog_action.log('PvpDailyAward', character_id, mail_id, rank)
