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
    new_character_ids = filter(lambda x: x >= 10000, new_character_ids)
    for char_id in new_character_ids:
        character_obj = tb_character_info.getObj(char_id)
        character_info = character_obj.hgetall()
        character_equipments = character_obj.getObj('equipments').hgetall()
        character_mails = character_obj.getObj('mails').hgetall()
        character_heroes = character_obj.getObj('heroes').hgetall()
        user_data = dict(id=char_id,
                         base_info=cPickle.dumps(character_info),
                         heroes=cPickle.dumps(character_heroes),
                         mails=cPickle.dumps(character_mails),
                         equipments=cPickle.dumps(character_equipments))

        insert_result = util.InsertIntoDB(CHARACTER_TABLE_NAME, user_data)
        if not insert_result:
            logger.error('insert id:%s error', char_id)
            result = util.GetOneRecordInfo(CHARACTER_TABLE_NAME,
                                           dict(id=char_id), ['id'])
            if result:
                tb_character_info.sadd('all', char_id)
                tb_character_info.srem('new', char_id)
        else:
            tb_character_info.sadd('all', char_id)
            tb_character_info.srem('new', char_id)
            logger.info('new character:%s', char_id)
        break

    global ALL_CHARACTER_IDS
    if not ALL_CHARACTER_IDS:
        ALL_CHARACTER_IDS = tb_character_info.smem('all')

    for char_id in ALL_CHARACTER_IDS:
        character_obj = tb_character_info.getObj(char_id)
        character_info = character_obj.hgetall()
        character_equipments = character_obj.getObj('equipments').hgetall()
        character_mails = character_obj.getObj('mails').hgetall()
        character_heroes = character_obj.getObj('heroes').hgetall()
        user_data = dict(base_info=cPickle.dumps(character_info),
                         heroes=cPickle.dumps(character_heroes),
                         mails=cPickle.dumps(character_mails),
                         equipments=cPickle.dumps(character_equipments))
        pwere = dict(id=char_id)
        result = util.GetOneRecordInfo(CHARACTER_TABLE_NAME, pwere, ['id'])
        if not result:
            logger.error('all insert id:%s error', char_id)
            tb_character_info.sadd('new', char_id)
        else:
            result = util.UpdateWithDict(CHARACTER_TABLE_NAME,
                                         user_data, pwere)
            if not result:
                logger.error('update id:%s error', char_id)
            # else:
            #     logger.info('save character:%s', char_id)

        ALL_CHARACTER_IDS.remove(char_id)
        break

    if not new_character_ids and not ALL_CHARACTER_IDS:
        reactor.callLater(delta*10, check_mem_db, delta)
    else:
        reactor.callLater(delta, check_mem_db, delta)
