# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import rob_treasure_pb2
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import is_afford
from shared.db_opear.configs_data.data_helper import parse
import random
import time
from shared.utils.pyuuid import get_uuid
import copy
from shared.utils.const import const
from app.game.core.activity import target_update
from app.game.redis_mode import tb_character_info
from app.game.core.drop_bag import BigBag
from app.proto_file.db_pb2 import Heads_DB
from app.game.core import rank_helper
from app.game.core.item_group_helper import gain, get_return
from app.game.core.equipment.equipment import init_equipment_attr
import types
from shared.tlog import tlog_action
from app.game.core.activity import target_update


@remoteserviceHandle('gate')
def rob_treasure_truce_859(data, player):
    """夺宝休战"""
    args = rob_treasure_pb2.RobTreasureTruceRequest()
    args.ParseFromString(data)
    num = args.num

    response = rob_treasure_pb2.RobTreasureTruceResponse()

    price = game_configs.base_config.get('indianaIteam')
    is_afford_res = is_afford(player, price, multiple=num)  # 校验

    if not is_afford_res.get('result'):
        logger.error('rob_treasure_truce_859, item not enough')
        response.res.result = False
        response.res.result_no = is_afford_res.get('result_no')
        return response.SerializeToString()

    truce_item_num_day = player.rob_treasure.truce_item_num_day
    use_truce_item_max = game_configs.vip_config. \
        get(player.base_info.vip_level).indiana_TruceTime
    if (truce_item_num_day + num) > use_truce_item_max:
        logger.error('rob_treasure_truce_859, use item times not enough')
        response.res.result = False
        response.res.result_no = is_afford_res.get('result_no')
        return response.SerializeToString()

    use_num, use_time, use_num_day = player.rob_treasure.do_truce(num)
    return_data = consume(player, price, const.ROB_TREASURE_TRUCE,
                          multiple=num)
    get_return(player, return_data, response.consume)
    player.rob_treasure.save_data()
    tlog_action.log('RobTreasureTruce', player, num, use_num_day)

    response.truce_item_num = use_num
    response.start_truce = use_time
    response.truce_item_num_day = use_num_day

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def rob_treasure_init_858(data, player):
    """夺宝初始化"""
    response = rob_treasure_pb2.RobTreasureInitResponse()

    use_num_day = player.rob_treasure.truce_item_num_day
    truce_info = player.rob_treasure.truce

    response.start_truce = truce_info[1]
    if truce_info[1]:
        response.truce_item_num = truce_info[0]
    response.truce_item_num_day = use_num_day

    deal_player_infos(player, response)
    response.refresh_time = player.rob_treasure.refresh_time
    print response, '===============init rob response'
    return response.SerializeToString()


@remoteserviceHandle('gate')
def compose_rob_treasure_860(data, player):
    """夺宝合成"""
    args = rob_treasure_pb2.ComposeTreasureRequest()
    args.ParseFromString(data)
    treasure_id = args.treasure_id

    response = rob_treasure_pb2.ComposeTreasureResponse()

    chips = game_configs.chip_config.get('map').get(treasure_id)

    for chip_no in chips:
        chip = player.equipment_chip_component.get_chip(chip_no)
        # 没有碎片
        if not chip:
            logger.error('rob_treasure_truce_841, use item times not enough')
            response.res.result = False
            response.res.result_no = 8601
            return response.SerializeToString()

        compose_num = chip.compose_num
        chip_num = chip.chip_num
        # 碎片不足
        if chip_num < compose_num:
            logger.error('rob_treasure_truce_841, use item times not enough')
            response.res.result = False
            response.res.result_no = 8601
            return response.SerializeToString()

    equipment_obj = player.equipment_component.add_equipment(treasure_id)
    for chip_no in chips:
        chip = player.equipment_chip_component.get_chip(chip_no)
        chip.chip_num -= compose_num
    player.equipment_chip_component.save_data()
    player.act.add_treasure(equipment_obj.equipment_config_info.type, equipment_obj.equipment_config_info.quality)
    target_update(player, [60, 61, 62, 63])

    equ = response.equ
    equipment_obj.update_pb(equ)

    tlog_action.log('ComposeTreasure', player, equipment_obj.base_info.id, treasure_id)
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def buy_truce_item_861(data, player):
    """买休战符"""
    args = rob_treasure_pb2.BuyTruceItemRequest()
    args.ParseFromString(data)
    num = args.num

    response = rob_treasure_pb2.BuyTruceItemResponse()

    price = game_configs.base_config.get('indianaTrucePrice')
    is_afford_res = is_afford(player, price, multiple=num)  # 校验

    """
    if not is_afford_res.get('result'):
        logger.error('rob_treasure_truce_841, item not enough')
        response.res.result = False
        response.res.result_no = is_afford_res.get('result_no')
        return response.SerializeToString()

    return_data = consume(player, price, const.BUY_TRUCE_ITEM, multiple=num)  # 消耗
    get_return(player, return_data, response.consume)

    """
    gain_items = game_configs.base_config.get('indianaIteam')
    return_data = gain(player, gain_items, const.BUY_TRUCE_ITEM, multiple=num)
    get_return(player, return_data, response.gain)

    response.res.result = True
    return response.SerializeToString()


def deal_player_infos(player, response):
    player_ids = player.pvp.rob_treasure
    rank_name, last_rank_name = rank_helper.get_power_rank_name()
    for player_id, ap in player_ids:
        if player_id >= 10000:
            player_data = tb_character_info.getObj(player_id)
            isexist = player_data.exists()
            if not isexist:
                logger.error('deal_player_infos, player id error')
                continue
            player_info = player_data.hmget(['id', 'nickname',
                                             'heads', 'vip_level',
                                             'guild_id'])
            player_pb = response.player_info.add()
            player_pb.color = player.rob_treasure.get_target_color_info(player_id).id
            player_pb.id = player_info.get('id')
            player_pb.nickname = player_info.get('nickname', 'nickname')
            player_pb.vip_level = player_info.get('vip_level')
            if player_info.get('guild_id') and type(player_info.get('guild_id')) is types.StringType:
                player_pb.guild_id = player_info.get('guild_id')

            player_heads = Heads_DB()
            player_heads.ParseFromString(player_info['heads'])
            player_pb.now_head = player_heads.now_head

            rank_no = rank_helper.get_rank_by_key(rank_name,
                                                  player_id)
            if not rank_no:
                logger.error('deal_player_infos, rank_no is None')
                continue

            [(_id, rankinfo)] = rank_helper.get_rank(rank_name,
                                                     rank_no, rank_no)
            player_pb.power = int(rankinfo/const.power_rank_xs)
            player_pb.level = int(rankinfo % const.power_rank_xs)
        else:
            robot_obj = tb_character_info.getObj('robot')
            data = robot_obj.hget(player_id)

            player_pb = response.player_info.add()
            player_pb.color = player.rob_treasure.get_target_color_info(player_id).id
            player_pb.id = player_id
            player_pb.nickname = data.get('nickname')
            player_pb.vip_level = 0
            player_pb.now_head = data.get('head_no', 0)
            player_pb.guild_id = ''

            player_pb.power = int(data.get('attackPoint'))
            player_pb.level = data.get('level')


@remoteserviceHandle('gate')
def refresh_rob_treasure_862(data, player):
    """刷新列表"""
    response = rob_treasure_pb2.RefreshRobTreasureResponse()

    jiange_time = game_configs.base_config.get('indianaRefreshCoolTime')
    allow_refresh_time = player.rob_treasure.refresh_time + jiange_time * 60
    now = int(time.time())
    if allow_refresh_time > now:
        logger.error('refresh_rob_treasure, dont allow refresh')
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    response.refresh_time = now
    player.rob_treasure.refresh_time = now
    player.pvp.reset_rob_treasure()
    player.pvp.save_data()
    player.rob_treasure.save_data()
    deal_player_infos(player, response)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def rob_treasure_reward_863(data, player):
    """选择战利品"""
    response = rob_treasure_pb2.RobTreasureRewardResponse()
    if not player.rob_treasure.can_receive:
        logger.error('rob_treasure_reward_863, can not receive')
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    indiana_conf = game_configs.indiana_config.get('indiana').get(player.rob_treasure.can_receive)
    common_bag = BigBag(indiana_conf.reward)
    drops = common_bag.get_drop_items()

    # drops = []
    # common_bag = BigBag(self._common_drop)
    # common_drop = common_bag.get_drop_items()
    # drops.extend(common_drop)

    x = [0, 1, 2]
    random.shuffle(x)
    return_data = [[drops[x[0]].item_type, drops[x[0]].num, drops[x[0]].item_no]]
    # gain(player, [drops[x[0]]], const.ROB_TREASURE_REWARD)
    get_return(player, return_data, response.look_gain.add())

    # return_data = gain(player, [drops[x[1]]], const.ROB_TREASURE_REWARD)
    return_data = [[drops[x[1]].item_type, drops[x[1]].num, drops[x[1]].item_no]]
    get_return(player, return_data, response.look_gain.add())

    return_data = gain(player, [drops[x[2]]],
                       const.ROB_TREASURE_REWARD)
    get_return(player, return_data, response.gain)

    player.rob_treasure.can_receive = 0
    player.rob_treasure.save_data()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def rob_treasure_enhance_866(data, player):
    """宝物饰品强化"""
    args = rob_treasure_pb2.RobTreasureEnhanceRequest()
    args.ParseFromString(data)
    no = args.no
    use_nos = args.use_no
    response = rob_treasure_pb2.RobTreasureEnhanceResponse()

    result = enhance_treasure(no,
                              use_nos,
                              player)
    if not result:
        response.res.result = False
        response.res.message = 800
        return response.SerializePartialToString()

    response.res.result = True
    return response.SerializeToString()


def enhance_treasure(no, use_nos, player):
    treasure_obj = player.equipment_component.get_equipment(no)

    if not treasure_obj:
        logger.debug('enhance_treasure dont have this treasure!')
        return {'result': False, 'result_no': 800, 'message': u''}

    treasure_id = treasure_obj.base_info.equipment_no
    equ_conf = game_configs.equipment_config.get(treasure_id)
    equ_type = equ_conf.type
    if equ_type not in [5, 6]:
        logger.debug('rob_treasure_enhance_866: type error!')
        return {'result': False, 'result_no': 800, 'message': u''}
    if equ_type == 5:
        need_type = [5, 7]
    else:
        need_type = [6, 8]

    all_exp = 0
    for use_no in use_nos:
        use_treasure_obj = player.equipment_component.get_equipment(use_no)
        use_treasure_level = use_treasure_obj.attribute.strengthen_lv
        use_equ_conf = game_configs.equipment_config.get(use_treasure_obj.base_info.equipment_no)

        key_num = use_equ_conf.currencyDir
        key_str = 'experienceCost' + str(key_num)

        if use_equ_conf.type not in need_type:
            logger.debug('rob_treasure_enhance_866: item error!')
            return {'result': False, 'result_no': 800, 'message': u''}

        use_all_exp = use_equ_conf.exp + use_treasure_obj.attribute.exp
        for x in range(1, use_treasure_level):
            str_config_obj = game_configs.equipment_strengthen_config.get(x)
            use_all_exp += str_config_obj.get(key_str)

        if use_treasure_level != 1:
            use_all_exp *= game_configs.base_config.get('indianaExpImpairment')
        all_exp += int(use_all_exp)
    equ_exp = treasure_obj.attribute.exp
    equ_level = treasure_obj.attribute.strengthen_lv
    level_max = player.base_info.level + game_configs.base_config.get('max_equipment_special_strength')
    all_max_level = game_configs.base_config.get('equ_special_level_max')
    if equ_level >= level_max or equ_level >= all_max_level:
        logger.debug('rob_treasure_enhance_866: level is max!')
        return {'result': False, 'result_no': 800, 'message': u''}

    key_num = equ_conf.currencyDir
    key_str = 'experienceCost' + str(key_num)

    attr_variety = equ_conf.attrVariety
    attr_v_keys1 = attr_variety.keys()
    attr_v_keys = []
    for x in attr_v_keys1:
        attr_v_keys.append(int(x))
    attr_v_keys.sort()
    before_attr_id = 0

    while level_max > equ_level and all_max_level > equ_level:
        str_config_obj = game_configs.equipment_strengthen_config.get(equ_level)
        up_level_exp = str_config_obj.get(key_str)
        if all_exp > (up_level_exp-equ_exp):
            all_exp -= (up_level_exp - equ_exp)
            equ_level += 1
            equ_exp = 0
        else:
            equ_exp += all_exp
            break
    treasure_obj.attribute.exp = equ_exp
    treasure_obj.attribute.strengthen_lv = equ_level

    after_attr_id = 0
    for x in attr_v_keys:
        after_attr_id = attr_variety[str(x)][0]
        if equ_level < x:
            break

    if after_attr_id != before_attr_id:
        mainAttr, minorAttr, prefix, equip_attr_id = init_equipment_attr(treasure_obj.base_info.equipment_no, after_attr_id)
        treasure_obj.attribute.main_attr = mainAttr
        treasure_obj.attribute.minor_attr = minorAttr
        treasure_obj.attribute.attr_id = equip_attr_id
    treasure_obj.save_data()
    for use_no in use_nos:
        # 删除装备
        player.equipment_component.delete_equipment(use_no)

    return {'result': True}


def change_attr(treasure_obj):
    mainAttr, minorAttr, prefix, equip_attr_id = init_equipment_attr(treasure_obj, attr_id)
