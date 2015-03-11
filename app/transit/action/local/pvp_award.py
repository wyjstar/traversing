# -*- coding:utf-8 -*-
"""
created by sphinx on
"""

from gtwisted.core import reactor
from gfirefly.dbentrust import util
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
from app.transit.root.messagecache import message_cache
from shared.db_opear.configs_data import game_configs
from app.proto_file.db_pb2 import Mail_PB
import time
import traceback


groot = GlobalObject().root


PVP_TABLE_NAME = 'tb_pvp_rank'


def pvp_award_tick():
    reactor.callLater(game_configs.base_config.get('arena_shorttime_points_time'), pvp_award_tick)
    try:
        pvp_award()
    except Exception, e:
        logger.exception(e)
    except:
        logger.error(traceback.format_exc())


def pvp_award():
    arena_award = game_configs.base_config.get('arena_shorttime_points')
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
                    logger.debug('pvp_award_tick result:%s,%s,%s', result, k, award)
                    break
        else:
            logger.debug('pvp_award_tick cache:%s,%s', k, award)
            message_cache.cache('pvp_award_remote', k['character_id'], award)


def pvp_daily_award_tick():
    award_time_x = game_configs.base_config.get('arena_day_points_time')
    award_time = time.strftime("%Y-%m-%d %X", time.localtime())[0:-8]
    award_time += award_time_x
    award_strptime = time.strptime(award_time, "%Y-%m-%d %X")
    award_mktime = time.mktime(award_strptime)
    time_interval = 60*60*24 - abs(time.time() - award_mktime)
    reactor.callLater(time_interval, do_pvp_daily_award_tick)


def do_pvp_daily_award_tick():
    reactor.callLater(60*60*24, pvp_daily_award_tick)
    try:
        pvp_daily_award()
    except Exception, e:
        logger.exception(e)
    except:
        logger.error(traceback.format_exc())


def pvp_daily_award():
    arena_award = game_configs.base_config.get('arena_day_points')
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME,
                                     'character_id>1000',
                                     ['id', 'character_id'])

    for k in records:
        childs = groot.childsmanager.childs
        rank = k['id']
        for up, down, mail_id in arena_award.values():
            if rank >= up and rank <= down:
                mail = mail_id
                break
        else:
            logger.error('pvp daily award error:%s', k)
            continue

        # mail_conf = game_configs.mail_config.get(mail_id)
        mail = Mail_PB()
        mail.config_id = mail_id
        mail.receive_id = k['character_id']
        mail.send_time = int(time.time())
        mail_data = mail.SerializePartialToString()

        for child in childs.values():
            if 'gate' in child.name:
                result = child.pull_message_remote('receive_mail_remote',
                                                   k['character_id'],
                                                   (mail_data,))
                if type(result) is bool and result:
                    break
                else:
                    logger.debug('pvp_daily_award_tick result:%s,%s,%s',
                                 result, k, mail_data)
        else:
            message_cache.cache('receive_mail_remote', k['character_id'],
                                mail_data)
