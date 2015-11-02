# -*- coding:utf-8 -*-
"""
created by sphinx.
"""
from gevent import monkey
monkey.patch_all()
import sys
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
from gfirefly.dbentrust.redis_manager import redis_manager
from shared.utils.const import const


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
    if len(sys.argv) == 1:
        rank_length = const.ROBOT_NUM
    else:
        rank_length = int(sys.argv[1])

    mconfig = json.load(open('config.json', 'r'))
    GlobalObject().allconfig = mconfig

    redis_config = mconfig.get('redis').get('urls')
    redis_manager.connection_setup(redis_config)
    log_init_only_out()

    # dbpool.initPool(host=mconfig['host'],
    #                 user=mconfig['user'],
    #                 passwd=mconfig['passwd'],
    #                 port=mconfig['port'],
    #                 db=mconfig['db'],
    #                 charset=mconfig['charset'])

    from app.game.core.character.PlayerCharacter import PlayerCharacter
    from app.game.action.node.line_up import line_up_info
    from app.game.redis_mode import tb_character_info, tb_pvp_rank

    nickname_set = set()
    nickname_set2 = set()
    while len(nickname_set) < rank_length + 5:
        pre1 = random.choice(game_configs.rand_name_config.get('pre1'))
        pre2 = random.choice(game_configs.rand_name_config.get('pre2'))
        str = random.choice(game_configs.rand_name_config.get('str'))
        nickname_set.add(pre1 + pre2 + str)
        nickname_set2.add(pre1 + pre2 + str)

    player = PlayerCharacter(1, dynamic_id=1)
    player.create_character_data()
    for k, val in game_configs.hero_config.items():
        if val.type == 0:
            hero1 = player.hero_component.add_hero(k)
            hero1.hero_no = k
            hero1.level = 1
            hero1.break_level = 1
            hero1.exp = 0

    pvp_rank = {}
    for rank in range(1, rank_length+1):
        for k, v in game_configs.robot_born_config.items():
            if v.get('group') != 1:
                continue
            rank_period = v.get('period')
            if rank in range(rank_period[0] - 1, rank_period[1] + 1):
                level_period = v.get('level')
                level = random.randint(level_period[0], level_period[1])
                hero_ids = init_line_up(player, v, level)
                # set player level to hero level
                for t_hero in player.hero_component.get_heros():
                    if t_hero.hero_no in hero_ids:
                        t_hero.level = level
                hero_levels = player.line_up_component.hero_levels
                red_units = player.fight_cache_component.red_unit
                # print red_units
                red_units = red_units
                slots = line_up_info(player).SerializeToString()
                ap = int(player.line_up_component.combat_power)

                rank_item = dict(nickname=nickname_set.pop(),
                                 character_id=rank, level=level, id=rank,
                                 hero_ids=hero_ids,
                                 hero_levels=hero_levels,
                                 attackPoint=ap,
                                 best_skill=0,
                                 unpar_skill=0,
                                 unpar_skill_level=0,
                                 copy_units=red_units,
                                 copy_slots=slots)
                print("hero_levels========", hero_levels)
                pvp_rank[rank] = rank_item
                break

    pvp_rank2 = {}
    for rank in range(1, rank_length+1):
        for k, v in game_configs.robot_born_config.items():
            if v.get('group') != 3:
                continue
            rank_period = v.get('period')
            if rank in range(rank_period[0] - 1, rank_period[1] + 1):
                level_period = v.get('level')
                level = random.randint(level_period[0], level_period[1])

                hero_ids = init_line_up(player, v, level)
                # set player level to hero level
                for t_hero in player.hero_component.get_heros():
                    if t_hero.hero_no in hero_ids:
                        t_hero.level = level
                hero_levels = player.line_up_component.hero_levels
                red_units = player.fight_cache_component.red_unit
                # print red_units
                red_units = red_units
                slots = line_up_info(player).SerializeToString()
                ap = int(player.line_up_component.combat_power)

                rank_item = dict(nickname=nickname_set2.pop(),
                                 character_id=rank, level=level, id=rank,
                                 hero_ids=hero_ids,
                                 hero_levels=hero_levels,
                                 attackPoint=ap,
                                 best_skill=0,
                                 unpar_skill=0,
                                 unpar_skill_level=0,
                                 copy_units=red_units,
                                 copy_slots=slots)
                pvp_rank2[rank] = rank_item
                break

    tb_robot = tb_character_info.getObj('robot')
    tb_robot2 = tb_character_info.getObj('robot2')
    if tb_robot.exists():
        tb_robot.delete()
        tb_robot2.delete()
        tb_pvp_rank.delete()
        tb_pvp_rank.getObj('incr').delete()

    for _ in pvp_rank.values():
        print _.get('id'), _.get('nickname'), _.get('character_id'), _.get('attackPoint')
        tb_robot.hsetnx(_['id'], _)
        tb_pvp_rank.zadd(_['id'], _['id'])
        tb_pvp_rank.getObj('incr').incr()

    for _ in pvp_rank2.values():
        print 'robot2', _.get('id'), _.get('nickname'), _.get('character_id'), _.get('attackPoint')
        tb_robot2.hsetnx(_['id'], _)


def dbpool_get():
    result = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'id<10',
                                    ['id', 'nickname', 'level', 'units'])
    print len(result)


@get_connection
def nopool_get(conn):
    from pymysql.cursors import DictCursor
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


