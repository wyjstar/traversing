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
from test.init_data.init_data import init
from gfirefly.server.logobj import logger
from app.proto_file.player_request_pb2 import CreatePlayerRequest
from app.proto_file.player_request_pb2 import NewbeeGuideStepRequest, ChangeHeadRequest
from app.proto_file.player_response_pb2 import NewbeeGuideStepResponse, ChangeHeadResponse
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.game.core.item_group_helper import gain, get_return
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import is_afford
from shared.utils.const import const
from app.game.component.character_stamina import max_of_stamina
from app.game.action.node.line_up import change_hero_logic
from app.game.action.node.equipment import enhance_equipment
from app.game.action.node.hero import hero_upgrade_with_item_logic, do_hero_refine
from app.game.action.node.runt import do_runt_set
from app.game.action.node.hero import hero_break_logic


remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def nickname_create_5(request_proto, player):
    argument = CreatePlayerRequest()
    argument.ParseFromString(request_proto)
    nickname = argument.nickname
    response = CommonResponse()

    match = re.search(u'[\uD800-\uDBFF][\uDC00-\uDFFF]', nickname)
    if match:
        response.result = False
        response.result_no = 1
        logger.info('not support emoji')
        return response.SerializeToString()

    if trie_tree.check.replace_bad_word(nickname) != nickname:
        response.result = False
        response.result_no = 1
        return response.SerializeToString()

    # 判断昵称是否重复
    nickname_obj = tb_character_info.getObj('nickname')
    result = nickname_obj.hsetnx(nickname, player.base_info.id)
    print 'is new player:', result
    if not result:
        response.result = False
        response.result_no = 1
        return response.SerializeToString()

    character_obj = tb_character_info.getObj(player.base_info.id)
    if not character_obj:
        response.result_no = 2
        return response.SerializeToString()
    player.base_info.base_name = nickname
    character_obj.hset('nickname', nickname)

    # 加入聊天
    remote_gate.login_chat_remote(player.dynamic_id,
                                  player.base_info.id,
                                  player.guild.g_id,
                                  nickname,
                                  player.base_info.gag)

    response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def buy_stamina_6(request_proto, player):
    """购买体力"""
    response = CommonResponse()

    current_vip_level = player.base_info.vip_level
    current_buy_stamina_times = player.stamina.buy_stamina_times
    # current_stamina = player.stamina.stamina
    current_gold = player.finance.gold

    available_buy_stamina_times = game_configs.vip_config.get(current_vip_level).get("buyStaminaMax")

    logger.debug("available_buy_stamina_times:%s,%s", available_buy_stamina_times,
                 current_buy_stamina_times)
    # 校验购买次数上限
    if current_buy_stamina_times >= available_buy_stamina_times:
        response.result = False
        response.result_no = 11
        return response.SerializePartialToString()

    need_gold = game_configs.base_config.get("price_buy_manual").get(current_buy_stamina_times+1)[1]
    logger.debug("need_gold++++++++++++++++%s", need_gold)
    # 校验金币是否不足
    if need_gold > current_gold:
        logger.debug("gold not enough++++++++++++")
        response.result = False
        response.result_no = 102
        return response.SerializePartialToString()

    player.finance.consume_gold(need_gold)
    player.finance.save_data()

    player.stamina.buy_stamina_times += 1

    player.stamina.stamina += 120
    player.stamina.last_buy_stamina_time = int(time.time())
    player.stamina.save_data()


    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def add_stamina_7(request_proto, player):
    """按时自动增长体力"""
    response = CommonResponse()

    # 校验时间是否足够
    current_time = int(time.time())
    last_gain_stamina_time = player.stamina.stamina

    if current_time - last_gain_stamina_time < 270:
        logger.debug("add stamina time not enough +++++++++++++++++++++")
        response.result_no = 12
        response.result = False
        return response.SerializePartialToString()

    max_stamina = max_of_stamina()
    if player.stamina.stamina >= max_stamina:
        logger.debug("has reach max stamina ++++++++++++++++++++++")
        response.result_no = 13
        response.result = False
        return response.SerializePartialToString()
    player.stamina.stamina += 1

    player.stamina.last_gain_stamina_time = current_time
    player.stamina.save_data()
    response.result = True
    return response.SerializePartialToString()


GUIDE_SET_RUNT = [50029, 50032, 50035]
GUIDE_REFINE = 60014
GUIDE_LINE_UP = 20034
GUIDE_EQUIP_STRENGTH = [40031, 40032, 40033]
GUIDE_HERO_UPGRADE = 30013
GUIDE_HERO_BREAK = 40008
GUIDE_EQUIP_SHOP = 40044


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

    #if request.step_id == GUIDE_LINE_UP:
        #hero_no = int(request.common_id)
        #res = change_hero_logic(hero_no, new_guide_item.get("Special")[1], 0, player)
        #if not res.get("result"):
            #logger.debug("hero already in the line up+++++++")
            #response.res.result = res.get("result")
            #response.res.result_no = res.get("result_no")
            #return response.SerializePartialToString()
    #elif request.step_id in GUIDE_SET_RUNT:
        #runt_po = new_guide_item.get("Special")[0]
        #runt_type = new_guide_item.get("Special")[1]
        #runt_no = request.sub_common_id
        #hero_no = int(request.common_id)

        #res = do_runt_set(hero_no, runt_type, runt_po, runt_no, player)
        #if not res.get("result"):
            #logger.debug("new guide ,runt set  error========= %s" % res.get("result_no"))
            #response.res.result = res.get("result")
            #if res.get('result_no'):
                #response.res.result_no = res.get("result_no")
            #return response.SerializePartialToString()
    #elif request.step_id == GUIDE_REFINE:
        #refine = request.sub_common_id
        #hero_no = int(request.common_id)

        #res = do_hero_refine(player, hero_no, refine)
        #if not res.get("result"):
            #logger.debug("new guide ,runt set  error========= %s" % res.get("result_no"))
            #response.res.result = res.get("result")
            #response.res.result_no = res.get("result_no")
            #return response.SerializePartialToString()
    #elif request.step_id in GUIDE_EQUIP_STRENGTH:
        #res = enhance_equipment(request.common_id, 1, player)
        #if not res.get("result"):
            #logger.debug("equipment strength error========= %s" % res.get("result_no"))
            #response.res.result = res.get("result")
            #if res.get('result_no'):
                #response.res.result_no = res.get("result_no")
            #return response.SerializePartialToString()
    #elif request.step_id == GUIDE_HERO_UPGRADE:
        #logger.debug("step_id %s %s" % (request.common_id, request.step_id))
        #hero_no = int(request.common_id)
        #hero = player.hero_component.get_hero(hero_no)
        #total_exp = 0
        ## 计算装备升级需要的经验丹数量
        #for level in range(player.base_info.level, hero.level):
            #total_exp += game_configs.hero_exp_config.get(level)
        #exp_item_no = 10001
        #item_info = game_configs.item_config.get(exp_item_no)
        #exp_item_num = (total_exp - hero.exp) / item_info.get("funcArg1") + 1

        #res = hero_upgrade_with_item_logic(hero_no, exp_item_no, exp_item_num, player)
        #if not res.get("result"):
            #logger.debug("hero_upgrade_with_item_logic error========= %s" % res.get("result_no"))
            #response.res.result = res.get("result")
            #response.res.result_no = res.get("result_no")
            #return response.SerializePartialToString()
    #elif request.step_id == GUIDE_HERO_BREAK:
        #logger.debug("step_id %s" % request.common_id)
        #hero_no = int(request.common_id)
        #res = hero_break_logic(hero_no, player, response)
        #if not res.get("result"):
            #logger.debug("hero_upgrade_with_item_logic error========= %s" % res.get("result_no"))
            #response.res.result = res.get("result")
            #response.res.result_no = res.get("result_no")
            #return response.SerializePartialToString()
    #elif request.step_id == GUIDE_EQUIP_SHOP:
        #shop_info = game_configs.shop_config.get(new_guide_item.get('Special')[0])
        #consume_config = shop_info.get('consume')
        #result = is_afford(player, consume_config)  # 校验
        #if not result.get('result'):
            #logger.error('newbee guide comsume:%s', consume_config)
            #response.res.result = res.get("result")
            #response.res.result_no = res.get("result_no")
            #return response.SerializePartialToString()
        #else:
            #consume_data = consume(player, consume_config)
            #get_return(player, consume_data, response.consume)


    logger.info('newbee:%s step:%s=>%s',
                player.base_info.id,
                player.base_info.newbee_guide_id,
                request.step_id)
    my_newbee_sequence = 0
    if player.base_info.newbee_guide_id:
        my_newbee_sequence = game_configs.newbee_guide_config.get(player.base_info.newbee_guide_id).get('Sequence')
    if my_newbee_sequence < new_guide_item.get('Sequence'):
        gain_data = new_guide_item.get('rewards')
        return_data = gain(player, gain_data, const.NEW_GUIDE_STEP)
        get_return(player, return_data, response.gain)
        logger.debug('new bee id:%s step:%s reward:%s',
                     player.base_info.id,
                     request.step_id, gain_data)
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
    else:
        consume_data = consume(player, consume_config)
        get_return(player, consume_data, response.consume)

    # logger.debug("gain_data %s %s" % (gain_data, request.step_id))
    # logger.debug(player.finance.coin)

    if my_newbee_sequence < new_guide_item.get('Sequence'):
        player.base_info.newbee_guide_id = request.step_id
        player.base_info.save_data()
    response.res.result = True

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


def init_player(player):
    new_character = player.is_new_character()
    if new_character:
        player.create_character_data()
    player.init_player_info()
#     if new_character:
#         logger.debug("mock player info.....")
#         init(player)
    return new_character
