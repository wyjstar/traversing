#-*- coding:utf-8 -*-
"""
created by sphinx.
"""
import cPickle
import copy
import random
import json
from gfirefly.dbentrust import util
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.dbentrust.memclient import mclient
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import log_init_only_out
from shared.db_opear.configs_data.game_configs import robot_born_config, rand_name_config, hero_config

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
    log_init_only_out()

    mconfig = json.load(open('../models.json', 'r'))
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
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)
    mclient.connect(["127.0.0.1:11211"], 'robot')
    from app.game.core.character.PlayerCharacter import PlayerCharacter
    from app.game.logic.line_up import line_up_info

    rank_length = 30

    nickname_set = set()
    while len(nickname_set) < rank_length + 5:
        pre1 = random.choice(rand_name_config.get('pre1'))
        pre2 = random.choice(rand_name_config.get('pre2'))
        str = random.choice(rand_name_config.get('str'))
        nickname_set.add(pre1 + pre2 + str)

    player = PlayerCharacter(1, dynamic_id=1)
    player.create_character_data()
    for k, val in hero_config.items():
        if val.type == 0:
            hero1 = player.hero_component.add_hero(k)
            hero1.hero_no = k
            hero1.level = 1
            hero1.break_level = 1
            hero1.exp = 0

    pvp_rank = {}
    for rank in range(1, rank_length):
        for k, v in robot_born_config.items():
            rank_period = v.get('period')
            if rank in range(rank_period[0] - 1, rank_period[1] + 1):
                level_period = v.get('level')
                level = random.randint(level_period[0], level_period[1])
                hero_ids = init_line_up(player, v, level)
                red_units = cPickle.dumps(player.fight_cache_component.red_unit, -1)
                slots = line_up_info(player)
                protobuf_slots = slots.SerializePartialToString()

                rank_item = dict(nickname=nickname_set.pop(),
                                 character_id=1,
                                 level=level,
                                 id=rank,
                                 hero_ids=cPickle.dumps(hero_ids),
                                 ap=player.line_up_component.combat_power,
                                 units=red_units,
                                 slots=protobuf_slots)
                pvp_rank[rank] = rank_item

    util.DeleteFromDB(PVP_TABLE_NAME)
    for _ in pvp_rank.values():
        print _.get('id'), _.get('nickname'), _.get('character_id')
        util.InsertIntoDB(PVP_TABLE_NAME, _)

if __name__ == '':
    log_init_only_out()

    hostname = "127.0.0.1"
    user = "test"
    password = "test"
    port = 8066
    dbname = "db_traversing"
    charset = "utf8"
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)
    records = util.GetSomeRecordInfo(PVP_TABLE_NAME, 'id<=10', ['id', 'nickname', 'level', 'ap'])
    for r in records:
        print r.get('nickname'), r.get('level'), r.get('id'), r.get('ap')
