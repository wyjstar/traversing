# -*- coding: utf-8 -*-
"""
created by wzp on 14-6-19下午7: 51.
"""
import time
from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager
from app.proto_file.game_pb2 import GameLoginResponse
from app.game.action.node.player import init_player
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from app.game.component.fight.hero_attr_cal.combat_power import combat_power_hero_lineup
from gfirefly.server.globalobject import GlobalObject
from shared.utils.const import const

remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def enter_scene_remote(dynamic_id, character_id, pay_arg):
    """进入场景"""
    is_new_character = 1
    player = PlayersManager().get_player_by_id(character_id)
    if not player:
        logger.debug('player login:%s', character_id)
        player = PlayerCharacter(character_id, dynamic_id=dynamic_id)
        is_new_character = init_player(player)
        PlayersManager().add_player(player)
    else:
        if player.dynamic_id != dynamic_id:
            logger.error('dynamic id is not same:%s,%s:%s',
                         character_id,
                         dynamic_id,
                         player.dynamic_id)
        player.dynamic_id = dynamic_id
    player.pay.set_pay_arg(pay_arg) # 设置支付参数

    remote_gate.pull_message_remote(character_id)

    responsedata = GameLoginResponse()
    responsedata.res.result = True
    responsedata.id = player.base_info.id
    responsedata.nickname = player.base_info.base_name

    responsedata.level = player.base_info.level
    responsedata.exp = player.base_info.exp
    responsedata.gag = player.base_info.gag
    responsedata.closure = player.base_info.closure

    for k, i in enumerate(player.finance._finances):
        responsedata.finances.append(i)

    responsedata.fine_hero = player.last_pick_time.fine_hero
    responsedata.excellent_hero = player.last_pick_time.excellent_hero
    responsedata.fine_equipment = player.last_pick_time.fine_equipment
    responsedata.excellent_equipment = player.last_pick_time.excellent_equipment

    responsedata.pvp_times = player.base_info.pvp_times
    responsedata.pvp_refresh_count = player.base_info.pvp_refresh_count

    responsedata.combat_power = player.line_up_component.combat_power
    responsedata.newbee_guide_id = player.base_info.newbee_guide_id

    if player.guild.g_id != 'no':
        responsedata.guild_id = player.guild.g_id

    responsedata.vip_level = player.base_info.vip_level
    # 体力
    responsedata.get_stamina_times = player.stamina.get_stamina_times
    responsedata.buy_stamina_times = player.stamina.buy_stamina_times
    responsedata.last_gain_stamina_time = player.stamina.last_gain_stamina_time
    responsedata.server_time = int(time.time())
    responsedata.register_time = player.base_info.register_time
    # responsedata.soul_shop_refresh_times = player.soul_shop.refresh_times
    if player.base_info.heads.head:
        for head in player.base_info.heads.head:
            responsedata.head.append(head)
    responsedata.now_head = player.base_info.heads.now_head
    for _id in player.base_info.first_recharge_ids:
        responsedata.first_recharge_ids.append(_id)

    responsedata.recharge = player.base_info.recharge # 累计充值
    logger.debug("character info:----------------------")
    logger.debug("vip_level:%d", player.base_info.vip_level)
    logger.debug("recharge:%d", player.base_info.recharge)
    logger.debug("register_time:%d", player.base_info.register_time)
    logger.debug("buy_stamina_times:%d", player.stamina.buy_stamina_times)
    # logger.debug("coin:%d", player.finance.coin)
    # logger.debug("gold:%d", player.finance.gold)
    # logger.debug("hero_soul:%d", player.finance.hero_soul)
    # logger.debug("soul_shop_refresh_times:%d", player.soul_shop.refresh_times)

    if const.DEBUG:
        for slot_no, slot in player.line_up_component.line_up_slots.items():
            hero = slot.hero_slot.hero_obj
            if not hero:
                continue
            combat_power_hero_lineup(player, hero, slot_no)
            awake_hero = player.fight_cache_component.change_hero(hero, hero.hero_info["awakeHeroID"])

            combat_power_hero_lineup(player, awake_hero, slot_no, "awake")

    logger.debug('login:<%s>%s:%s %s:%s',
                 player,
                 character_id,
                 responsedata.level,
                 dynamic_id,
                 player.dynamic_id)

    return {'player_data': responsedata.SerializeToString(),
            'is_new_character': is_new_character}
