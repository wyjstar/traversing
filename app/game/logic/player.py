# -*- coding:utf-8 -*-
"""
created by server on 14-7-21下午5:12.
"""
import time
from app.game.action.root.netforwarding import login_chat

from app.game.logic.common.check import have_player
from app.game.redis_mode import tb_nickname_mapping, tb_character_info
from app.proto_file.common_pb2 import CommonResponse
from shared.utils import trie_tree
from shared.db_opear.configs_data.game_configs import base_config
from shared.db_opear.configs_data.game_configs import vip_config
from gtwisted.utils import log
from app.game.logic.soul_shop import init_soul_shop_items
from test.init_data.init_data import init


def init_player(player):
    new_character = player.is_new_character()
    if new_character:
        player.create_character_data()
    player.init_player_info()
    if new_character:
        log.DEBUG("mock player info.....")
        init(player)
        init_soul_shop_items(player)

@have_player
def nickname_create(dynamic_id, nickname, **kwargs):
    player = kwargs.get('player')
    response = CommonResponse()

    if trie_tree.check.replace_bad_word(nickname) != nickname:
        response.result = False
        response.result_no = 1
        return response.SerializeToString()

    # 判断昵称是否重复
    start_time = time.time()
    data = tb_nickname_mapping.getObjData(nickname)
    end_time = time.time()
    print 'command 5 :', end_time - start_time
    if data:
        response.result = False
        response.result_no = 1
        return response.SerializeToString()

    player.base_info.base_name = nickname
    nickname_data = dict(id=player.base_info.id, nickname=nickname)
    nickname_mmode = tb_nickname_mapping.new(nickname_data)
    nickname_mmode.insert()

    character_obj = tb_character_info.getObj(player.base_info.id)
    if not character_obj:
        response.result_no = 2
        return response.SerializeToString()
    character_obj.update('nickname', nickname)

    # 加入聊天
    login_chat(dynamic_id, player.base_info.id, player.guild.g_id, nickname)

    response.result = True
    return response.SerializeToString()


@have_player
def buy_stamina(dynamic_id, **kwargs):
    """购买体力"""
    player = kwargs.get('player')
    response = CommonResponse()

    current_vip_level = player.vip_component.vip_level
    current_buy_stamina_times = player.stamina.buy_stamina_times
    current_stamina = player.stamina.stamina
    current_gold = player.finance.gold

    available_buy_stamina_times = vip_config.get(current_vip_level).get("buyStaminaMax")

    log.DEBUG("available_buy_stamina_times++++++++++++++++", available_buy_stamina_times, current_buy_stamina_times)
    # 校验购买次数上限
    if current_buy_stamina_times >= available_buy_stamina_times:
        response.result = False
        response.result_no = 11
        return response.SerializePartialToString()

    need_gold = base_config.get("price_buy_manual").get(str(current_buy_stamina_times+1))[1]
    log.DEBUG("need_gold++++++++++++++++", need_gold)
    # 校验金币是否不足
    if need_gold > current_gold:
        log.DEBUG("gold not enough++++++++++++")
        response.result = False
        response.result_no = 102
        return response.SerializePartialToString()

    player.finance.gold -= need_gold
    player.finance.save_data()

    player.stamina.buy_stamina_times += 1
    player.save_data()

    player.stamina.stamina += 120
    player.stamina.save_data()

    response.result = True
    return response.SerializePartialToString()


@have_player
def add_stamina(dynamic_id, **kwargs):
    """按时自动增长体力"""
    player = kwargs.get('player')
    response = CommonResponse()

    # 校验时间是否足够
    current_time = int(time.time())
    last_gain_stamina_time = player.stamina.stamina

    if current_time - last_gain_stamina_time < 270:
        log.DEBUG("add stamina time not enough +++++++++++++++++++++++++++++++")
        response.result_no = 12
        response.result = False
        return response.SerializePartialToString()

    max_stamina = player.stamina.max_of_stamina
    if player.stamina.stamina >= max_stamina:
        log.DEBUG("has reach max stamina +++++++++++++++++++++++++++++++")
        response.result_no = 13
        response.result = False
        return response.SerializePartialToString()
    player.stamina.stamina += 1

    player.stamina.last_gain_stamina_time = current_time
    player.stamina.save_data()
    response.result = True
    return response.SerializePartialToString()
