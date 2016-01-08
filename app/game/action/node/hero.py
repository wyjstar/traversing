# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import hero_request_pb2
from app.proto_file import hero_response_pb2
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import is_afford, consume, gain, get_return
from shared.utils import log_action
from app.game.core.pack.item import Item
from shared.db_opear.configs_data.data_helper import parse
from shared.utils.const import const
from app.game.core.notice import push_notice
from shared.tlog import tlog_action
from app.game.core.activity import target_update
import random
from shared.utils.date_util import days_to_current, get_current_timestamp
from shared.common_logic.feature_open import is_not_open, FO_HERO_BREAK, FO_HERO_AWAKE, FO_HERO_SACRIFICE, FO_HERO_COMPOSE, FO_REFINE


@remoteserviceHandle('gate')
def get_heros_101(pro_data, player):
    """取得武将列表 """
    response = hero_response_pb2.GetHerosResponse()

    clear_or_not = days_to_current(player.base_info._hero_awake_time) > 0

    for hero in player.hero_component.get_heros():
        if clear_or_not:
            logger.debug("clear hero awake")
            hero.awake_exp = 0
            hero.save_data()
        hero_pb = response.heros.add()
        hero.update_pb(hero_pb)
        #if hero_pb.hero_no == 10045:
            #logger.debug("%s %s " % (hero.hero_no, hero_pb.is_guard))

    player.base_info._hero_awake_time = get_current_timestamp()
    player.base_info.save_data()
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def hero_upgrade_with_item_103(data, player):
    """武将升级，使用经验药水"""
    args = hero_request_pb2.HeroUpgradeWithItemRequest()
    args.ParseFromString(data)
    response = hero_response_pb2.HeroUpgradeResponse()
    hero_no = args.hero_no
    exp_item_no = args.exp_item_no
    exp_item_num = args.exp_item_num
    # 服务器验证
    res = hero_upgrade_with_item_logic(hero_no, exp_item_no, exp_item_num, player)
    if not res.get("result"):
        response.res.result = res.get("result")
        response.res.result_no = res.get("result_no")
        return response.SerializeToString()
    # 返回
    hero = res.get("hero")
    response.res.result = True
    response.level = hero.level
    response.exp = hero.exp
    # 更新 七日奖励
    target_update(player, [55])
    return response.SerializeToString()


def hero_upgrade_with_item_logic(hero_no, exp_item_no, exp_item_num, player):
    """docstring for hero_upgrade_with_item_logic"""
    exp_item = player.item_package.get_item(exp_item_no)
    if not exp_item:
        logger.error('item package can not get item:%d' % exp_item_no)
        return {"result": False}
    # 服务器验证
    if exp_item.num < exp_item_num:
        return {"result": False, "result_no": 106}
    exp = game_configs.item_config.get(exp_item_no).get('funcArg1')
    hero = player.hero_component.get_hero(hero_no)
    beforelevel = hero.level
    hero.upgrade(exp * exp_item_num, player.base_info.level)
    afterlevel = hero.level
    hero.save_data()
    changelevel = afterlevel-beforelevel
    tlog_action.log('HeroUpgrade', player, hero_no, changelevel, afterlevel, 2,
                    exp_item_num, 0, 0, exp_item_no)
    player.item_package.consume_item(exp_item_no, exp_item_num)
    return {"result": True, "hero": hero}


@remoteserviceHandle('gate')
def one_key_hero_upgrade_with_item_120(data, player):
    """阵容界面武将一键升级"""
    args = hero_request_pb2.HeroRequest()
    args.ParseFromString(data)
    response = hero_response_pb2.OneKeyHeroUpgradeRespone()
    hero_no = args.hero_no
    # 服务器验证
    res = one_key_hero_upgrade_logic(hero_no, player)
    if not res.get("result"):
        response.res.result = res.get("result")
        response.res.result_no = res.get("result_no")
        return response.SerializeToString()
    # 返回
    hero = res.get("hero")
    response.res.result = True
    response.level = hero.level
    response.exp = hero.exp
    response.exp_item_num.append(res.get('small_exp_num'))
    response.exp_item_num.append(res.get('middle_exp_num'))
    response.exp_item_num.append(res.get('big_exp_num'))
    # 更新 七日奖励
    target_update(player, [55])
    # logger.debug(res)
    # logger.debug(response)
    return response.SerializeToString()

def one_key_hero_upgrade_logic(hero_no, player):
    hero = player.hero_component.get_hero(hero_no)
    total_exp = 0
    small_exp_item = player.item_package.get_item(10001)
    middle_exp_item = player.item_package.get_item(10002)
    big_exp_item = player.item_package.get_item(10003)
    small_exp = game_configs.item_config.get(10001).get('funcArg1')
    middle_exp = game_configs.item_config.get(10002).get('funcArg1')
    big_exp = game_configs.item_config.get(10003).get('funcArg1')
    need_total_exp = hero.need_exp_to_max(player.base_info.level)
    logger.debug('need_total_exp %s' % need_total_exp)
    if small_exp_item:
        logger.debug("small_exp_item num %s" % small_exp_item.num)
    if middle_exp_item:
        logger.debug("middle_exp_item num %s" % middle_exp_item.num)
    if big_exp_item:
        logger.debug("big_exp_item num %s" % big_exp_item.num)

    small_exp_num = 0
    middle_exp_num = 0
    big_exp_num = 0
    if small_exp_item:
        for i in range(small_exp_item.num):
            if total_exp > need_total_exp:
                break
            total_exp += small_exp
            small_exp_num = i + 1

    if middle_exp_item:
        for i in range(middle_exp_item.num):
            if total_exp > need_total_exp:
                break
            total_exp += middle_exp
            middle_exp_num = i + 1

    if big_exp_item:
        for i in range(big_exp_item.num):
            if total_exp > need_total_exp:
                break
            total_exp += big_exp
            big_exp_num = i + 1

    beforelevel = hero.level
    hero.upgrade(small_exp * small_exp_num + middle_exp * middle_exp_num + big_exp * big_exp_num, player.base_info.level)
    hero.save_data()
    afterlevel = hero.level
    changelevel = afterlevel-beforelevel
    tlog_action.log('HeroUpgrade', player, hero_no, changelevel, afterlevel, 3,
                    small_exp_num, middle_exp_num, big_exp_num, 0)

    player.item_package.consume_item(10001, small_exp_num)
    player.item_package.consume_item(10002, middle_exp_num)
    player.item_package.consume_item(10003, big_exp_num)

    return {"result": True, "hero": hero, "small_exp_num": small_exp_num, "middle_exp_num": middle_exp_num, "big_exp_num": big_exp_num}


@remoteserviceHandle('gate')
def hero_break_104(data, player):
    """武将突破"""
    args = hero_request_pb2.HeroBreakRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    response = hero_response_pb2.HeroBreakResponse()

    res = hero_break_logic(hero_no, player, response)
    if not res.get('result'):
        response.res.result = False
        response.res.result_no = res.get('result_no')
        return response.SerializeToString()
    # 更新 七日奖励
    target_update(player, [55])
    response.res.result = True
    response.break_level = res.get("break_level")
    response.break_item_num = res.get("break_item_num")
    return response.SerializeToString()


def hero_break_logic(hero_no, player, response):
    if is_not_open(player, FO_HERO_BREAK):
        return {'result': False, 'result_no': 837}
    hero = player.hero_component.get_hero(hero_no)
    hero_info = game_configs.hero_config.get(hero_no)
    break_through = game_configs.base_config.get('breakthrough')
    target_break_level = hero.break_level + 1
    logger.debug("target_break_level %s" % target_break_level)
    if target_break_level not in break_through:
        logger.debug("hero_break_logic can find target break level %s" % target_break_level)
        return {"result": False, "result_no": 10401}

    if hero.level < break_through[target_break_level][0]:
        logger.debug("hero_break_logic level is not enough %s" % hero.level)
        return {"result": False, "result_no": 10402}

    # 验证武将是否突破到上限
    if hero.break_level == hero_info.breakLimit:
        return {"result": False, "result_no": 201}

    consume_info = hero_info.get('consume' + str(hero.break_level+1))
    item_group = parse(consume_info)
    hero_info = game_configs.hero_config.get(hero.hero_no)
    # 判断是否足够
    result = is_afford(player, item_group)  # 校验
    if not result.get('result'):
        return {"result": False, "result_no": result.get('result_no')}

    # 返回消耗
    return_data = consume(player, item_group, const.HERO_BREAK)
    get_return(player, return_data, response.consume)

    for item in item_group:
        if item.item_type == 105 and item.item_no == 20006:
            hero.break_item_num += item.num
            hero.save_data()

    hero.break_level += 1
    notice_item = game_configs.notes_config.get(2003)
    if hero.break_level in notice_item.parameter1:
        push_notice(2003, player_name=player.base_info.base_name, hero_no=hero.hero_no, hero_break_level=hero.break_level)
    hero.save_data()
    # 3、返回
    tlog_action.log('HeroBreak', player, hero_no, hero.break_level)
    return {"result": True, "break_level": hero.break_level, "break_item_num": hero.break_item_num}


@remoteserviceHandle('gate')
def hero_sacrifice_105(data, player):
    """武将献祭"""
    args = hero_request_pb2.HeroSacrificeRequest()
    args.ParseFromString(data)
    response = hero_response_pb2.HeroSacrificeResponse()

    heros = player.hero_component.get_heros_by_nos(args.hero_nos)
    if len(heros) == 0:
        logger.error("hero %s is not exists." % str(args.hero_nos))
    response = hero_sacrifice_oper(heros, player)
    # remove hero
    player.hero_component.delete_heros_by_nos(args.hero_nos)

    # hero chip
    for hero_chip in args.hero_chips:
        sacrifice_gain = game_configs.chip_config.get("chips").get(hero_chip.hero_chip_no).sacrificeGain
        return_data = gain(player,
                           sacrifice_gain,
                           const.HERO_CHIP_SACRIFICE_OPER,
                           multiple=hero_chip.hero_chip_num)
        get_return(player, return_data, response.gain)
        # remove hero_chip
        temp = player.hero_chip_component.get_chip(hero_chip.hero_chip_no)
        if temp:
            temp.consume_chip(hero_chip.hero_chip_num)  # 消耗碎片
    player.hero_chip_component.save_data()
    logger.debug(response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def hero_compose_106(data, player):
    """武将合成"""
    args = hero_request_pb2.HeroComposeRequest()
    args.ParseFromString(data)
    hero_chip_no = args.hero_chip_no
    response = hero_response_pb2.HeroComposeResponse()
    if is_not_open(player, FO_HERO_COMPOSE):
        response.res.result = False
        response.res.result_no = 837
        return response
    hero_no = game_configs.chip_config.get("chips").get(hero_chip_no).combineResult
    need_num = game_configs.chip_config.get("chips").get(hero_chip_no).needNum
    if not hero_no or not need_num:
        logger.error("chip_config数据不全!")
    hero_chip = player.hero_chip_component.get_chip(hero_chip_no)
    # 服务器校验
    if hero_chip.num < need_num:
        response.res.result = False
        response.res.message = u"碎片不足，合成失败！"
        logger.error("碎片不足，合成失败！")
        return response.SerializeToString()
    if player.hero_component.contain_hero(hero_no):
        response.res.result = False
        response.res.result_no = 202
        logger.error("武将已存在，合成失败！")
        response.res.message = u"武将已存在，合成失败！"
        return response.SerializeToString()
    hero = player.hero_component.add_hero(hero_no)
    hero_chip.consume_chip(need_num)  # 消耗碎片
    player.hero_chip_component.save_data()
    notice_item = game_configs.notes_config.get(2008)
    logger.debug("=================%s %s" % (hero.hero_info.quality, notice_item.parameter1))
    if hero.hero_info.quality in notice_item.parameter1:
        push_notice(2008, player_name=player.base_info.base_name, hero_no=hero_no)

    # tlog
    log_action.hero_flow(player, hero.hero_no, 1, 1)
    log_action.chip_flow(player, hero_chip.chip_no, 1, 0,
                         need_num, hero_chip.num, 1)
    # 3、返回
    response.res.result = True
    hero.update_pb(response.hero)
    logger.debug(response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def hero_sell_107(data, player):
    """武将出售"""
    args = hero_request_pb2.HeroSellRequest()
    args.ParseFromString(data)
    hero_nos = args.hero_nos

    response = hero_response_pb2.HeroSellResponse()
    for hero_no in hero_nos:
        sell_gain = game_configs.hero_config.get(hero_no).sellGain
        return_data = gain(player, sell_gain, const.HERO_SELL)
        get_return(player, return_data, response.gain)

    response.res.result = True
    return response


@remoteserviceHandle('gate')
def hero_refine_118(data, player):
    request = hero_request_pb2.HeroRefineRequest()
    request.ParseFromString(data)
    response = hero_response_pb2.HeroRefineResponse()
    hero_no = request.hero_no
    refine = request.refine

    res = do_hero_refine(player, hero_no, refine, response)

    response.res.result = res.get('result')
    if res.get('result_no'):
        response.res.result_no = res.get('result_no')
    logger.debug(response)
    return response.SerializeToString()


def do_hero_refine(player, hero_no, refine, response):
    if is_not_open(player, FO_REFINE):
        return {"result": False, "result_no": 837}
    hero = player.hero_component.get_hero(hero_no)
    _refine_item = game_configs.seal_config.get(refine)
    if not hero:
        logger.error('cant find hero:%s', hero_no)
        return {'result': False, 'result_no': 11801}
    if not _refine_item:
        logger.error('cant find refine item:%s', refine)
        return {'result': False, 'result_no': 11802}

    if _refine_item.get('heroLevelRestrictions') > hero.level:
        logger.error('refine player level is error:%s-%s',
                     _refine_item.get('heroLevelRestrictions'),
                     hero.level)
        return {'result': False, 'result_no': 11805}

    current_refine_item = game_configs.seal_config.get(hero.refine)
    if current_refine_item and _refine_item.id != current_refine_item.get('next'):
        logger.error('not next refine item:%s', refine)
        return {'result': False, 'result_no': 11803}

    result = is_afford(player, _refine_item.expend)  # 校验
    if not result.get('result'):
        logger.error('cant afford refine:%s:cur%s',
                     _refine_item.expend,
                     player.brew.nectar)
        return {'result': False, 'result_no': 11804}

    tlog_action.log('HeroRefine', player, hero_no, refine)

    return_data = consume(player, _refine_item.expend, const.HERO_REFINE)
    get_return(player, return_data, response.consume)

    hero.refine = refine
    player.brew.save_data()
    hero.save_data()

    return {'result': True}


def hero_sacrifice_oper(heros, player):
    """
    武将献祭，返回总武魂、经验药水
    :param heros: 被献祭的武将
    :return total_hero_soul:总武魂数量, exp_item_no:经验药水编号, exp_item_num:经验药水数量
    """
    total_exp = 0
    exp_item_no = 0
    exp_item_num = 0
    awake_item_no = 90001
    awake_item_num = 0
    break_item_no = 20006
    break_item_num = 0

    response = hero_response_pb2.HeroSacrificeResponse()
    if is_not_open(player, FO_HERO_SACRIFICE):
        response.res.result = False
        response.res.result_no = 837
        return response
    gain_response = response.gain
    for hero in heros:
        sacrifice_gain = game_configs.hero_config.get(hero.hero_no).sacrificeGain
        return_data = gain(player, sacrifice_gain, const.HERO_SACRIFICE_OPER)
        get_return(player, return_data, gain_response)
        # 经验
        exp = hero.get_all_exp()
        total_exp += exp
        tlog_action.log('HeroSacrifice', player, hero.hero_no)
        # 觉醒丹
        awake_item_num += hero.awake_item_num
        # 突破丹
        break_item_num += hero.break_item_num

    # baseconfig {1000000: 'item_id'}

    logger.debug("total_exp %s" % total_exp)
    formula_info = game_configs.formula_config.get("sacrificeExp_3")
    pre_formula = formula_info.get("precondition")
    formula = formula_info.get("formula")
    cal_vars = dict(expHero=total_exp)
    if eval(pre_formula, cal_vars):
        exp_item_no = 10003
        exp_item_num = eval(formula, cal_vars)
    formula_info = game_configs.formula_config.get("sacrificeExp_2")
    pre_formula = formula_info.get("precondition")
    formula = formula_info.get("formula")
    cal_vars = dict(expHero=total_exp)
    if eval(pre_formula, cal_vars):
        exp_item_no = 10002
        exp_item_num = eval(formula, cal_vars)
    formula_info = game_configs.formula_config.get("sacrificeExp_1")
    pre_formula = formula_info.get("precondition")
    formula = formula_info.get("formula")
    cal_vars = dict(expHero=total_exp)
    if eval(pre_formula, cal_vars):
        exp_item_no = 10001
        exp_item_num = eval(formula, cal_vars)
    heroAwakeBack = game_configs.base_config.get('heroAwakeBack')
    heroBreakBack = game_configs.base_config.get('heroBreakBack')
    awake_item_num = int(awake_item_num * heroAwakeBack)
    break_item_num = int(break_item_num * heroBreakBack)

    player.item_package.add_item(Item(exp_item_no, exp_item_num))
    player.item_package.add_item(Item(awake_item_no, awake_item_num))
    player.item_package.add_item(Item(break_item_no, break_item_num))
    player.item_package.save_data()
    if exp_item_no:
        item_pb = gain_response.items.add()
        item_pb.item_no = exp_item_no
        item_pb.item_num = exp_item_num
    if awake_item_num:
        item_pb = gain_response.items.add()
        item_pb.item_no = awake_item_no
        item_pb.item_num = awake_item_num
    if break_item_num:
        item_pb = gain_response.items.add()
        item_pb.item_no = break_item_no
        item_pb.item_num = break_item_num
    response.res.result = True
    # print "*"*80
    # print response
    return response


@remoteserviceHandle('gate')
def hero_awake_121(data, player):
    """觉醒"""
    request = hero_request_pb2.HeroAwakeRequest()
    request.ParseFromString(data)
    response = hero_response_pb2.HeroAwakeResponse()
    hero_no = request.hero_no
    awake_item_num = request.awake_item_num

    res = do_hero_awake(player, hero_no, awake_item_num, response)
    response.res.result = res.get('result')
    if res.get('result_no'):
        response.res.result_no = res.get('result_no')
    logger.debug("response %s" % response)
    return response.SerializeToString()

def do_hero_awake(player, hero_no, awake_item_num, response):
    """docstring for do_hero_awake"""
    if is_not_open(player, FO_HERO_AWAKE):
        return {'result': False, 'result_no': 837}

    hero = player.hero_component.get_hero(hero_no)
    if not hero:
        logger.error("hero not exist! hero_no %s" % hero_no)
        return {'result': False, 'result_no': 11901}

    awake_info = game_configs.awake_config.get(hero.awake_level)
    logger.debug("hero.awake_level %s, hero_no %s, awake_item_num %s" % (hero.awake_level, hero_no, awake_item_num))

    singleConsumption = awake_info.singleConsumption
    logger.debug("singleConsumption %s" % singleConsumption)
    singleCoin = awake_info.silver

    if not is_afford(player, singleConsumption).get("result"):
        logger.error("singleConsumption is not afford!")
        return {'result': False, 'result_no': 11902}

    if not is_afford(player, singleCoin).get("result"):
        logger.error("singleCoin is not afford!")
        return {'result': False, 'result_no': 11903}

    if hero.awake_level >= 10:
        logger.error("the hero has reached the max awake level!")
        return {'result': False, 'result_no': 11904}

    singleConsumptionNum = singleConsumption[0].num
    left_awake_item = awake_item_num


    before_num = hero.awake_item_num

    while left_awake_item >= singleConsumptionNum:
        # consume
        if not is_afford(player, singleConsumption) or \
            not is_afford(player, singleCoin):
                break
        return_data1 = consume(player, singleConsumption, const.HERO_AWAKE)
        return_data2 = consume(player, singleCoin, const.HERO_AWAKE)
        get_return(player, return_data1, response.consume)
        get_return(player, return_data2, response.consume)

        # record awake item num
        hero.awake_item_num += singleConsumptionNum

        # trigger or not, add exp, add level
        exp_percent = hero.awake_exp * 1.0 / awake_info.experience
        is_trigger = False
        for k in sorted(awake_info.triggerProbability.keys(), reverse=True):
            if exp_percent > k:
                v = awake_info.triggerProbability[k]
                target_percent = random.uniform(v[0], v[1])
                if random.random() < target_percent:
                    is_trigger = True
                    break

        if is_trigger:  # 触发满级概率
            logger.debug("is_trigger!")
            hero.awake_exp = 0
            hero.awake_level += 1
            break
        else:
            logger.debug("not is_trigger!")
            hero.awake_exp += singleConsumptionNum
            if hero.awake_exp >= awake_info.experience:
                hero.awake_exp = hero.awake_exp - awake_info.experience
                hero.awake_level += 1

        left_awake_item -= singleConsumptionNum

    # actual_consume_item_num = 0
    hero.save_data()
    response.awake_level = hero.awake_level
    response.awake_exp = hero.awake_exp
    response.awake_item_num = hero.awake_item_num
    use_num = hero.awake_item_num - before_num
    tlog_action.log('HeroAwake', player, hero_no, use_num, hero.awake_level-1)

    return {'result': True}


@remoteserviceHandle('gate')
def hero_break_sync_info_122(data, player):
    """
    同步武将突破信息
    """
    request = hero_request_pb2.HeroBreakRelatedInfoRequest()
    request.ParseFromString(data)
    response = hero_response_pb2.HeroBreakRelatedInfoResponse()
    hero_no = request.hero_no

    item = player.item_package.get_item(20006)
    if item:
        response.break_item_num = item.num
    else:
        response.break_item_num = 0

    chip_no = game_configs.chip_config.get("mapping").get(hero_no).get("id")
    response.hero_chip_num = player.hero_chip_component.get_num(chip_no)
    logger.debug(response)


    return response.SerializeToString()

