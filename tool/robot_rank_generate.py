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


if __name__ == '__main__':
    log_init_only_out()

    mconfig = json.load(open('../models.json', 'r'))
    model_default_config = mconfig.get('model_default', {})
    model_config = mconfig.get('models', {})
    GlobalObject().json_model_config = model_config
    GlobalObject().json_model_default_config = model_default_config

    hostname = "127.0.0.1"
    user = "root"
    password = "123456"
    port = 3306
    dbname = "test"
    charset = "utf8"
    dbpool.initPool(host=hostname, user=user, passwd=password, port=port, db=dbname,
                    charset=charset)
    mclient.connect(["127.0.0.1:11211"], 'robot')
    from app.game.core.character.PlayerCharacter import PlayerCharacter

    rank_length = 30

    nickname_set = set()
    while len(nickname_set) < rank_length:
        pre1 = random.choice(rand_name_config.get('pre1'))
        pre2 = random.choice(rand_name_config.get('pre2'))
        str = random.choice(rand_name_config.get('str'))
        nickname_set.add('r' + pre1 + pre2 + str)

    player = PlayerCharacter(1, dynamic_id=1)
    player.create_character_data()
    for k, val in hero_config.items():
        if val.toGet != 0:
            hero1 = player.hero_component.add_hero(k)
            hero1.hero_no = k
            hero1.level = 1
            hero1.break_level = 1
            hero1.exp = 0

    pvp_rank = {}
    for rank in range(rank_length):
        for k, v in robot_born_config.items():
            rank_period = v.get('period')
            if rank in range(rank_period[0], rank_period[1]):
                level_period = v.get('level')
                level = random.randint(level_period[0], level_period[1])
                init_line_up(player, v, level)
                red_units = cPickle.dumps(player.fight_cache_component.red_unit, -1)

                rank_item = dict(nickname=nickname_set.pop(),
                                 level=level,
                                 id=rank,
                                 units=red_units)
                pvp_rank[rank] = rank_item

    util.DeleteFromDB('tb_pvp_rank')
    for _ in pvp_rank.values():
        util.InsertIntoDB('tb_pvp_rank', _)
