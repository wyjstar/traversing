# -*- coding:utf-8 -*-
"""
created by sphinx.
"""
from gevent import monkey
monkey.patch_all()
import cPickle
import copy
import random
import json
from gfirefly.dbentrust import util
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.dbentrust.dbpool import get_connection
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import log_init_only_out
from gfirefly.distributed.node import RemoteObject
from shared.db_opear.configs_data import game_configs
from gfirefly.dbentrust.redis_mode import MAdmin
from gfirefly.dbentrust.redis_manager import redis_manager


GlobalObject().remote['gate'] = RemoteObject('gate')

PVP_TABLE_NAME = 'tb_pvp_rank'


def init_line_up(player, robot_config, level):
    player.init_player_info()
    hero_ids = []
    pos1 = robot_config.get(u'pos_1')
    pos2 = robot_config.get(u'pos_2')
    pos1, pos2 = copy.copy(pos1), copy.copy(pos2)
    random.shuffle(pos1)
    random.shuffle(pos2)
    while len(pos1) > 3:
        pos1.pop()
    while len(pos2) > 3:
        pos2.pop()
    hero_ids.extend(pos1)
    hero_ids.extend(pos2)

    for index in range(6):
        slot = player.line_up_component.line_up_slots[index + 1]

        slot.activation = True
        slot.hero_slot.hero_no = hero_ids[index]
        slot.hero_slot.activation = True
    return hero_ids


if __name__ == '__main__':
    redis_config = ["127.0.0.1:11211"]
    redis_manager.connection_setup(redis_config)
    pvp_rank = MAdmin('pvp_rank', 'id')
    log_init_only_out()

    mconfig = json.load(open('models.json', 'r'))
    model_default_config = mconfig.get('model_default', {})
    model_config = mconfig.get('models', {})
    GlobalObject().json_model_config = model_config
    GlobalObject().json_model_default_config = model_default_config

    hostname = "127.0.0.1"
    user = "test"
    password = "test"
    port = 8066
    dbname = "db_traversing"
    charset = "utf8"
    # dbpool.initPool(host=hostname, user=user,
    #                 passwd=password, port=port,
    #                 db=dbname, charset=charset)
    from app.game.core.character.PlayerCharacter import PlayerCharacter
    from app.game.action.node.line_up import line_up_info

    rank_length = 300

    nickname_set = set()
    while len(nickname_set) < rank_length + 5:
        pre1 = random.choice(game_configs.rand_name_config.get('pre1'))
        pre2 = random.choice(game_configs.rand_name_config.get('pre2'))
        str = random.choice(game_configs.rand_name_config.get('str'))
        nickname_set.add(pre1 + pre2 + str)

    player = PlayerCharacter(1, dynamic_id=1)
    player.create_character_data()
    for k, val in game_configs.hero_config.items():
        if val.type == 0:
            hero1 = player.hero_component.add_hero(k)
            hero1.hero_no = k
            hero1.level = 1
            hero1.break_level = 1
            hero1.exp = 0

    pvp_ranks = {}
    for rank in range(1, rank_length+1):
        for k, v in game_configs.robot_born_config.items():
            rank_period = v.get('period')
            if rank in range(rank_period[0] - 1, rank_period[1] + 1):
                level_period = v.get('level')
                level = random.randint(level_period[0], level_period[1])
                hero_ids = init_line_up(player, v, level)
                red_units = player.fight_cache_component.red_unit
                print red_units
                red_units = cPickle.dumps(red_units)
                slots = cPickle.dumps(line_up_info(player))

                rank_item = dict(nickname=nickname_set.pop(),
                                 character_id=1,
                                 level=level,
                                 id=rank,
                                 best_skill=0,
                                 unpar_skill=0,
                                 unpar_skill_level=0,
                                 hero_ids=cPickle.dumps(hero_ids),
                                 ap=player.line_up_component.combat_power,
                                 units=red_units,
                                 slots=slots)
                pvp_ranks[rank] = rank_item

    for _ in pvp_ranks.values():
        print _.get('id'), _.get('nickname'), _.get('character_id')
        rank_obj = pvp_rank.getObj(_.get('id'))
        rank_obj.hmset(_)


def dbpool_get():
    result = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'id<10',
                                    ['id', 'nickname', 'level', 'units'])
    print len(result)


@get_connection
def nopool_get(conn):
    # hostname = "192.168.10.27"
    # user = "test"
    # password = "test"
    # port = 8066
    # dbname = "db_traversing"
    # charset = "utf8"
    # import pymysql
    from pymysql.cursors import DictCursor
    # con = pymysql.Connect(host=hostname, user=user,
    #                       passwd=password, port=port,
    #                       db=dbname, charset=charset)
    # result = conn.query('select * from %s where id<10' % PVP_TABLE_NAME)
    # print result
    cursor = conn.cursor(cursor=DictCursor)
    cursor.execute('select * from %s where id<10' % PVP_TABLE_NAME)
    result = cursor.fetchall()
    print len(result)
    cursor.close()
    # con.close()


def test_db():
    print 'begin get db'
    for i in range(10):
        dbpool_get()
    print 'end get db'


if __name__ == '':
    log_init_only_out()

    hostname = "127.0.0.1"
    user = "test"
    password = "test"
    port = 8066
    dbname = "db_traversing"
    charset = "utf8"
    dbpool.initPool(host=hostname, user=user,
                    passwd=password, port=port,
                    db=dbname, charset=charset)
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME,
                                     'id=10',
                                     ['id', 'nickname', 'level', 'units'])
    for r in records:
        # u = cPickle.loads(u)
        print r.get('nickname'), r.get('level'), r.get('id')  # r.get('units')

    import gevent
    thread1 = gevent.spawn(test_db)
    thread2 = gevent.spawn(test_db)
    gevent.joinall([thread1, thread2])
