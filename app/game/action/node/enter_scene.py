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
from app.game.core import rank_helper

remote_gate = GlobalObject().remote.get('gate')
server_open_time = int(time.mktime(time.strptime(GlobalObject().allconfig[
    'open_time'], '%Y-%m-%d %H:%M:%S')))

SDK360_RECHARGE_URL = GlobalObject().allconfig["360sdk"]["recharge_url"]
OPEN_REGISTER = int(GlobalObject().allconfig["open_register"])


@remoteserviceHandle('gate')
def enter_scene_remote(dynamic_id, character_id, pay_arg):
    """进入场景"""
    is_new_character = 0
    player = PlayersManager().get_player_by_id(character_id)
    if not player:
        logger.debug('player login:%s', character_id)
        player = PlayerCharacter(character_id, dynamic_id=dynamic_id)

        if player.is_new_character() and not OPEN_REGISTER:
            PlayersManager().drop_player_by_id(character_id)
            logger.debug('player login, 4005 open register:%s', OPEN_REGISTER)
            return {'player_data': 4005}

        is_new_character = init_player(player)
        PlayersManager().add_player(player)
    else:
        if player.is_new_character() and not OPEN_REGISTER:
            PlayersManager().drop_player_by_id(character_id)
            logger.debug('player login, 4005 open register:%s', OPEN_REGISTER)
            return {'player_data': 4005}

        logger.debug('player exsit! player.dynamic_id %s new dynamic_id %s' %
                     (player.dynamic_id, dynamic_id))
        if player.dynamic_id != dynamic_id:
            logger.error('dynamic id is not same:%s,%s:%s', character_id,
                         dynamic_id, player.dynamic_id)
        player.dynamic_id = dynamic_id
    player.pay.set_pay_arg(pay_arg)  # 设置支付参数
    player.base_info.plat_id = pay_arg.get("plat_id")  # ios 0 android 1
    logger.debug("plat_id %s" % pay_arg.get("plat_id"))

    remote_gate.pull_message_remote(character_id)
    remote_gate['push'].online_offline_remote(player.base_info.id, 1)

    responsedata = GameLoginResponse()
    responsedata.res.result = True
    responsedata.id = player.base_info.id
    responsedata.nickname = player.base_info.base_name
    print server_open_time, '======================'
    responsedata.server_open_time = server_open_time

    responsedata.level = player.base_info.level
    responsedata.exp = player.base_info.exp
    responsedata.gag = player.base_info.gag
    responsedata.closure = player.base_info.closure

    for k, i in enumerate(player.finance._finances):
        print(k, i)
        responsedata.finances.append(int(i))

    responsedata.fine_hero = player.last_pick_time.fine_hero
    responsedata.excellent_hero = player.last_pick_time.excellent_hero
    responsedata.fine_equipment = player.last_pick_time.fine_equipment
    responsedata.excellent_equipment = player.last_pick_time.excellent_equipment
    responsedata.fine_hero_times = player.shop.single_coin_draw_times
    responsedata.excellent_hero_times = player.shop.single_gold_draw_times

    responsedata.pvp_times = player.pvp.pvp_times
    responsedata.pvp_refresh_count = player.pvp.pvp_refresh_count
    responsedata.pvp_overcome_index = player.pvp.pvp_overcome_current
    responsedata.pvp_overcome_stars = player.pvp.pvp_overcome_stars
    responsedata.pvp_overcome_refresh_count = player.pvp.pvp_overcome_refresh_count

    combat_power = player.line_up_component.combat_power
    responsedata.combat_power = combat_power

    hight_power = player.line_up_component.hight_power
    if hight_power and hight_power >= combat_power:
        responsedata.hight_power = hight_power
    else:
        responsedata.hight_power = combat_power
        player.line_up_component.hight_power = combat_power
        player.line_up_component.save_data()

    responsedata.hight_power = player.line_up_component.hight_power
    responsedata.newbee_guide_id = player.base_info.current_newbee_guide

    if player.guild.g_id != 0:
        responsedata.guild_id = player.guild.g_id

    responsedata.vip_level = player.base_info.vip_level
    # 体力
    responsedata.get_stamina_times = player.stamina.get_stamina_times
    responsedata.buy_stamina_times = player.stamina.buy_stamina_times
    responsedata.last_gain_stamina_time = player.stamina.last_gain_stamina_time
    responsedata.server_time = int(time.time())
    responsedata.register_time = player.base_info.register_time
    # responsedata.soul_shop_refresh_times = player.soul_shop.refresh_times
    buy_times_pb = responsedata.buy_times
    for item in player.stamina._stamina.stamina:
        item_pb = buy_times_pb.add()
        item_pb.resource_type = item.resource_type
        item_pb.buy_stamina_times = item.buy_stamina_times
        item_pb.last_gain_stamina_time = item.last_gain_stamina_time
        logger.debug("stami %s buy_stamina_times %s last_gain_stamina_time %s"
                     % (item.resource_type, item.buy_stamina_times,
                        item.last_gain_stamina_time))

    logger.debug("stamina %s" % buy_times_pb)
    if player.base_info.heads.head:
        for head in player.base_info.heads.head:
            responsedata.head.append(head)
    responsedata.now_head = player.base_info.heads.now_head
    for _id in player.base_info.first_recharge_ids:
        responsedata.first_recharge_ids.append(_id)

    responsedata.recharge = player.base_info.recharge  # 累计充值
    responsedata.tomorrow_gift = player.base_info.tomorrow_gift
    responsedata.battle_speed = player.base_info.battle_speed
    responsedata.story_id = player.base_info.story_id
    for k, i in enumerate(player.base_info._button_one_time):
        responsedata.button_one_time.append(int(i))
    logger.debug("button_one_time %s" % player.base_info._button_one_time)
    # 战力排行
    if rank_helper.flag_doublu_day():
        rank_name = 'PowerRank2'
    else:
        rank_name = 'PowerRank1'
    rank_no = rank_helper.get_rank_by_key(rank_name, player.base_info.id)
    responsedata.fight_power_rank = rank_no

    responsedata.is_open_next_day_activity = player.base_info.is_open_next_day_activity
    responsedata.first_recharge_activity = player.base_info.first_recharge_activity
    responsedata.one_dollar_flowid = str(player.base_info.one_dollar_flowid)

    responsedata.q360_recharge_url = SDK360_RECHARGE_URL
    logger.debug("character info:----------------------id: %s" %
                 player.base_info.id)
    logger.debug("stage_id: %s" % player.fight_cache_component.stage_id)
    logger.debug("vip_level:%d", player.base_info.vip_level)
    logger.debug("recharge:%d", player.base_info.recharge)
    logger.debug("register_time:%d", player.base_info.register_time)
    logger.debug("buy_stamina_times:%d", player.stamina.buy_stamina_times)
    logger.debug("first_recharge_activity:%d",
                 player.base_info.first_recharge_activity)
    logger.debug("newbee_guide_id:%d", player.base_info.current_newbee_guide)
    # logger.debug("coin:%d", player.finance.coin)
    # logger.debug("gold:%d", player.finance.gold)
    # logger.debug("hero_soul:%d", player.finance.hero_soul)
    # logger.debug("soul_shop_refresh_times:%d", player.soul_shop.refresh_times)
    # mock guild
    # player.guild.g_id = 1989
    # 更新7日奖励的状态
    # player.start_target.update_29()

    if const.DEBUG:
        for slot_no, slot in player.line_up_component.line_up_slots.items():
            hero = slot.hero_slot.hero_obj
            if not hero:
                continue
            combat_power_hero_lineup(player, hero, slot_no)
            # awake_hero = player.fight_cache_component.change_hero(hero, hero.hero_info["awakeHeroID"])

            # combat_power_hero_lineup(player, awake_hero, slot_no, "awake")
    logger.debug('login:<%s>%s:%s %s:%s', player, character_id,
                 responsedata.level, dynamic_id, player.dynamic_id)

    return {'player_data': responsedata.SerializeToString(),
            'is_new_character': is_new_character}


@remoteserviceHandle('gate')
def enter_scene_9(data, player):
    responsedata = GameLoginResponse()
    responsedata.res.result = True

    player.pvp.check_time()
    responsedata.pvp_times = player.pvp.pvp_times
    responsedata.pvp_refresh_count = player.pvp.pvp_refresh_count
    responsedata.pvp_overcome_index = player.pvp.pvp_overcome_current
    responsedata.pvp_overcome_stars = player.pvp.pvp_overcome_stars
    responsedata.pvp_overcome_refresh_count = player.pvp.pvp_overcome_refresh_count

    if rank_helper.flag_doublu_day():
        rank_name = 'PowerRank2'
    else:
        rank_name = 'PowerRank1'
    rank_no = rank_helper.get_rank_by_key(rank_name, player.base_info.id)
    responsedata.fight_power_rank = rank_no

    player.stamina.check_time_all()
    buy_times_pb = responsedata.buy_times
    for item in player.stamina._stamina.stamina:
        item_pb = buy_times_pb.add()
        item_pb.resource_type = item.resource_type
        item_pb.buy_stamina_times = item.buy_stamina_times
        item_pb.last_gain_stamina_time = item.last_gain_stamina_time
        logger.debug("stami %s buy_stamina_times %s last_gain_stamina_time %s"
                     % (item.resource_type, item.buy_stamina_times,
                        item.last_gain_stamina_time))

    return responsedata.SerializeToString()
