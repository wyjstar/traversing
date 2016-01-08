# -*- coding:utf-8 -*-
"""
created by server on 14-7-21下午2:17.
"""
import time
import re
from app.game.redis_mode import tb_character_info
from app.proto_file.common_pb2 import CommonResponse
from shared.utils import trie_tree
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.proto_file import player_request_pb2
from app.proto_file import recharge_pb2
from app.proto_file import player_pb2, chat_pb2
from app.proto_file.player_request_pb2 import CreatePlayerRequest
from app.proto_file.player_request_pb2 import NewbeeGuideStepRequest, \
    ChangeHeadRequest, UpGuideRequest
from app.proto_file.player_response_pb2 import NewbeeGuideStepResponse, \
    ChangeHeadResponse, UpdateHightPowerResponse
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.game.core.item_group_helper import gain, get_return
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import get_consume_gold_num
from shared.utils.const import const
from app.game.component.character_stamina import max_of_stamina
from shared.tlog import tlog_action
from app.proto_file.game_pb2 import HeartBeatResponse, StaminaOperRequest, StaminaOperResponse
from gfirefly.dbentrust.redis_mode import RedisObject


remote_gate = GlobalObject().remote.get('gate')
tb_base_info_chat_record = RedisObject('tb_base_info:chat_record')


@remoteserviceHandle('gate')
def nickname_create_5(request_proto, player):
    argument = CreatePlayerRequest()
    argument.ParseFromString(request_proto)
    nickname = argument.nickname
    response = CommonResponse()

    # match = re.search(u'[\uD800-\uDBFF][\uDC00-\uDFFF]', nickname)
    match = re.search(u'^[a-zA-Z0-9\u4e00-\u9fa5]+$', nickname)
    if not match:
        response.result = False
        response.result_no = 868
        logger.info('not support emoji')
        return response.SerializeToString()

    if trie_tree.check.replace_bad_word(nickname) != nickname:
        response.result = False
        response.result_no = 869
        return response.SerializeToString()

    # 判断昵称是否重复
    nickname_obj = tb_character_info.getObj('nickname')
    result = nickname_obj.hsetnx(nickname, player.base_info.id)
    print 'is new player:', result
    if not result:
        response.result = False
        response.result_no = 870
        return response.SerializeToString()

    print type(nickname), '===============222'
    player.base_info.base_name = nickname
    player.base_info.save_data()

    # 加入聊天
    remote_gate.login_chat_remote(player.dynamic_id,
                                  player.base_info.id,
                                  player.guild.g_id,
                                  nickname,
                                  player.base_info.gag)

    tlog_action.log('CreateNickname', player, nickname)

    response.result = True
    return response.SerializeToString()






GUIDE_SET_RUNT = [50029, 50032, 50035]
GUIDE_REFINE = 60014
GUIDE_LINE_UP = 20034
GUIDE_EQUIP_STRENGTH = [40031, 40032, 40033]
GUIDE_HERO_UPGRADE = 30013
GUIDE_HERO_BREAK = 40008
GUIDE_EQUIP_SHOP = 40044


@remoteserviceHandle('gate')
def up_guide_1816(data, player):
    request = UpGuideRequest()
    request.ParseFromString(data)
    response = CommonResponse()
    guide_id = request.guide_id

    tlog_action.log('UpGuide', player, guide_id)
    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def new_guide_step_1802(data, player):
    request = NewbeeGuideStepRequest()
    request.ParseFromString(data)
    response = NewbeeGuideStepResponse()

    new_guide_item = game_configs.newbee_guide_config.get(request.step_id)
    if not new_guide_item:
        logger.error('error newbee id:%s', request.step_id)
        response.res.result = False
        return response.SerializePartialToString()
    new_guide_type = new_guide_item.get('SequenceType')

    logger.info('newbee:%s step:%s=>%s',
                player.base_info.id,
                player.base_info.newbee_guide,
                request.step_id)
    my_newbee_sequence = 0
    if player.base_info.newbee_guide.get(new_guide_type):
        my_newbee_sequence = game_configs.newbee_guide_config.get(player.base_info.newbee_guide[new_guide_type]).get('Sequence')
    if my_newbee_sequence < new_guide_item.get('Sequence'):
        gain_data = new_guide_item.get('rewards')
        return_data = gain(player, gain_data, const.NEW_GUIDE_STEP)
        get_return(player, return_data, response.gain)
        logger.debug('new bee id:%s step:%s reward:%s response:%s',
                     player.base_info.id, request.step_id,
                     gain_data, response.gain)
    else:
        response.res.result_no = 111
        logger.debug("new bee reward repeated, id:%s step:%s %s %s",
                     player.base_info.id,
                     request.step_id,
                     my_newbee_sequence,
                     new_guide_item.get('Sequence'))

    consume_config = new_guide_item.get('consume')
    result = is_afford(player, consume_config)  # 校验
    if not result.get('result'):
        logger.error('newbee guide comsume:%s', consume_config)
        response.res.result = False
        response.res.result_no = 1802
        return response.SerializePartialToString()

    need_gold = get_consume_gold_num(consume_config)
    def func():
        consume_data = consume(player, consume_config, const.NEW_GUIDE_STEP)
        get_return(player, consume_data, response.consume)

        # logger.debug("gain_data %s %s" % (gain_data, request.step_id))
        # logger.debug(player.finance.coin)
        tlog_action.log('NewGuide', player, new_guide_item.get('Sequence'),
                        request.step_id)

        if my_newbee_sequence < new_guide_item.get('Sequence'):
            player.base_info.newbee_guide[new_guide_type] = request.step_id
            player.base_info.current_newbee_guide = request.step_id
            player.base_info.save_data()
    player.pay.pay(need_gold, const.NEW_GUIDE_STEP, func)
    response.res.result = True
    response.step_id = request.step_id

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def change_head_847(data, player):
    request = ChangeHeadRequest()
    request.ParseFromString(data)
    response = ChangeHeadResponse()
    if request.hero_id in player.base_info.heads.head:
        player.base_info.heads.now_head = request.hero_id
        player.base_info.save_data()
    else:
        response.res.result = False
        response.res.result_no = 834
        return response.SerializePartialToString()

    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def change_battle_speed_848(data, player):
    request = player_request_pb2.ChangeBattleSpeed()
    request.ParseFromString(data)
    player.base_info.battle_speed = request.speed
    player.base_info.save_data()
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def recharge_11010(data, player):
    response = recharge_pb2.InitRecharge()
    for recharge_id in player.base_info.first_recharge_ids:
        response.recharge_ids.append(recharge_id)

    return response.SerializePartialToString()

def init_player(player):
    new_character = player.is_new_character()
    if new_character:
        player.create_character_data()
    player.init_player_info()
#     if new_character:
#         logger.debug("mock player info.....")
#         init(player)
    return new_character

@remoteserviceHandle('gate')
def heartbeat_88(data, player):
    response = HeartBeatResponse()
    response.server_time = int(time.time())
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def buy_stamina_2201(request_proto, player):
    """购买可恢复资源"""
    request = StaminaOperRequest()
    request.ParseFromString(request_proto)
    resource_type = request.finance_changes.item_no
    num = request.finance_changes.item_num
    item = player.stamina.get_item(resource_type)
    info = player.stamina.get_info(resource_type, player, item.buy_stamina_times)
    current_value = player.finance[resource_type]

    response = StaminaOperResponse()
    response.finance_changes.item_type = 107
    response.finance_changes.item_no = resource_type
    response.finance_changes.item_num = num

    current_buy_stamina_times = item.buy_stamina_times
    need_gold = info.get("need_gold")
    logger.debug("need_gold++++++++++++++++%s", need_gold)
    current_gold = player.finance.gold

    available_buy_stamina_times = info.get("can_buy_times")
    logger.debug("available_buy_stamina_times:%s,%s", available_buy_stamina_times,
                 current_buy_stamina_times)
    # 校验购买次数上限
    if current_buy_stamina_times + num > available_buy_stamina_times:
        response.res.result = False
        response.res.result_no = 11
        return response.SerializePartialToString()

    # 校验金币是否不足
    if need_gold*num > current_gold:
        logger.debug("gold not enough++++++++++++")
        response.res.result = False
        response.res.result_no = 102
        return response.SerializePartialToString()

    if current_value >= info.get("max_value"):
        logger.debug("stamina is full++++++++++++")
        response.res.result = False
        response.res.result_no = 220101
        return response.SerializePartialToString()

    def func():
        item.buy_stamina_times += num
        player.finance.add(resource_type, info.get("one_buy_value")*num, reason=const.BUY_STAMINA)
        item.last_buy_stamina_time = int(time.time())
        player.finance.save_data()
        player.stamina.save_data()
        logger.debug("buy stamina++++++++++++++++++++")
        tlog_action.log('BuyStamina', player, resource_type, num)

    player.pay.pay(need_gold*num, const.BUY_STAMINA, func)
    response.buy_times = item.buy_stamina_times
    logger.debug("buy stamina times %s" % (response.buy_times))

    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def add_stamina_2202(request_proto, player):
    """按时自动增长资源"""
    request = StaminaOperRequest()
    request.ParseFromString(request_proto)
    logger.debug("request %s" % request)

    response = StaminaOperResponse()
    resource_type = request.finance_changes.item_no
    num = request.finance_changes.item_num
    item = player.stamina.get_item(resource_type)
    if not item:
        logger.error("resource type %s not exist!" % resource_type)
        response.res.result_no = 22023
        response.res.result = False
        return response.SerializePartialToString()
    info = player.stamina.get_info(resource_type, player, item.buy_stamina_times)
    current_value = player.finance[resource_type]

    response.finance_changes.item_type = 107
    response.finance_changes.item_no = resource_type
    response.finance_changes.item_num = num

    # 校验时间是否足够
    current_time = int(time.time())
    last_gain_stamina_time = item.last_gain_stamina_time

    if current_time - last_gain_stamina_time < info.get("recover_period"):
        logger.debug("add stamina time not enough +++++++++++++++++++++")
        response.res.result_no = 22021
        response.res.result = False
        return response.SerializePartialToString()

    if current_value >= info.get("max_value"):
        logger.debug("has reach max stamina ++++++++++++++++++++++")
        response.res.result_no = 22022
        response.res.result = False
        return response.SerializePartialToString()

    player.finance.add(resource_type, info.get("recover_unit"), reason=const.AUTO_ADD)

    item.last_gain_stamina_time = current_time
    player.stamina.save_data()
    player.finance.save_data()
    logger.debug("add stmina %s %s" % (resource_type, info.get("recover_unit")))
    response.res.result = True
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def button_one_time_2203(request_proto, player):

    request = player_request_pb2.ButtonOneTimeRequest()
    request.ParseFromString(request_proto)
    button_id = request.button_id
    logger.debug("button_one_time request %s" % button_id)
    player.base_info._button_one_time[button_id] = 1
    player.base_info.save_data()
    logger.debug("button_one_time %s" % player.base_info._button_one_time)
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def first_recharge_activity_2204(request_proto, player):
    """
    首次充值
    """
    response = recharge_pb2.GetRechargeGiftResponse()
    response.res.result = True
    if player.base_info.recharge == 0:
        response.res.result = False
        response.res.result_no = 22041
        return response.SerializePartialToString()

    if player.base_info._button_one_time[const.FIRST_RECHARGE_BUTTON] == 1:
        response.res.result = False
        response.res.result_no = 22042
        return response.SerializePartialToString()

    activity_info = game_configs.activity_config.get(7)[0]
    if activity_info:
        logger.error("activity not exist!")

    player.base_info._button_one_time[const.FIRST_RECHARGE_BUTTON] = 1
    player.base_info.save_data()
    return_data = gain(player, activity_info.get('reward', {}), const.FIRST_RECHARGE)
    get_return(player, return_data, response.gain)

    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def heartbeat_1833(data, player):
    response = UpdateHightPowerResponse()

    player.line_up_component.combat_power
    hight_power = player.line_up_component.hight_power
    player.line_up_component.save_data()
    response.hight_power = hight_power
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def change_stage_story_2205(data, player):
    request = player_request_pb2.ChangeStageStory()
    request.ParseFromString(data)
    player.base_info.story_id = request.story_id
    player.base_info.save_data()
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def chat_record_1004(data, player):
    # 获取聊天记录
    response = chat_pb2.GetChatHistoryResponse()
    guild_id = player.guild.g_id
    guild_res = tb_base_info_chat_record.lrange(guild_id, 0, -1)
    for record in guild_res:
        record_pb = response.guild_chat_history.add()
        record_pb.ParseFromString(record)

    world_res = tb_base_info_chat_record.lrange(1, 0, -1)
    for record in world_res:
        record_pb = response.world_chat_history.add()
        record_pb.ParseFromString(record)

    logger.debug(response)
    return response.SerializePartialToString()
