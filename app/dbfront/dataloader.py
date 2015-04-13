# coding:utf8
"""

"""
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.logobj import logger
from gfirefly.dbentrust import util
from gtwisted.core import reactor
import cPickle

reactor = reactor

tb_character_info = RedisObject('tb_character_info')

CHARACTER_TABLE_NAME = 'tb_character_info'
ALL_CHARACTER_IDS = []


def check_mem_db(delta):
    """同步内存数据到数据库
    """
    new_character_ids = tb_character_info.smem('new')
    for char_id in new_character_ids:
        if char_id >= 10000:
            character_obj = tb_character_info.getObj(char_id)
            character_info = character_obj.hgetall()
            user_data = dict(id=char_id,
                             base_info=cPickle.dumps(character_info))
            insert_result = util.InsertIntoDB(CHARACTER_TABLE_NAME, user_data)
            if not insert_result:
                logger.error('insert id:%s error', char_id)
            else:
                tb_character_info.sadd('all', char_id)
                tb_character_info.srem('new', char_id)
                logger.info('new character:%s', char_id)
            break
        else:
            pass

    global ALL_CHARACTER_IDS
    if not ALL_CHARACTER_IDS:
        ALL_CHARACTER_IDS = tb_character_info.smem('all')

    for char_id in ALL_CHARACTER_IDS:
        character_obj = tb_character_info.getObj(char_id)
        character_info = character_obj.hgetall()
        user_data = dict(base_info=cPickle.dumps(character_info))
        pwere = dict(id=char_id)
        result = util.UpdateWithDict(CHARACTER_TABLE_NAME, user_data, pwere)
        if not result:
            logger.error('update id:%s error', char_id)
        else:
            ALL_CHARACTER_IDS.remove(char_id)
            # logger.info('save character:%s', char_id)
        break

    reactor.callLater(delta, check_mem_db, delta)
