# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:21.
"""
import random
import time
from app.proto_file import stage_request_pb2
from app.proto_file import stage_response_pb2
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data import game_configs
from app.game.core.drop_bag import BigBag
from app.game.core.item_group_helper import gain, get_return
from app.game.component.fight.stage_factory import get_stage_by_stage_type
from app.game.action.node._fight_start_logic import pve_process, pve_process_check
from app.game.action.node._fight_start_logic import pve_assemble_units
from app.game.action.node._fight_start_logic import pve_assemble_friend
from app.game.action.node._fight_start_logic import get_seeds
from shared.utils.const import const
from shared.tlog import tlog_action
from shared.utils.pyuuid import get_uuid
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import get_consume_gold_num
from shared.utils.random_pick import random_pick_with_weight
from app.game.core.mail_helper import send_mail
import cPickle
from app.game.core.task import hook_task, CONDITIONId
import os
from shared.common_logic.feature_open import is_not_open, FO_ACT_STAGE, FO_ELI_STAGE, FO_HJQY_STAGE
from app.game.component.fight.stage_logic.stage_util import get_drop_activity


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def get_stages_901(pro_data, player):
    """取得关卡信息
    """
    request = stage_request_pb2.StageInfoRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id

    stages_obj, elite_stage_times, elite_stage_reset_times, act_coin_stage_times, act_exp_stage_times, act_lucky_heros = get_stage_info(stage_id, player)

    response = stage_response_pb2.StageInfoResponse()
    for stage_obj in stages_obj:
        add = response.stage.add()
        add.stage_id = stage_obj.stage_id
        add.attacks = stage_obj.attacks
        add.state = stage_obj.state

        if time.localtime(stage_obj.reset[1]).tm_yday != time.localtime().tm_yday:
            stage_obj.reset = [0, int(time.time())]
        add.reset.times = stage_obj.reset[0]
        add.reset.time = stage_obj.reset[1]
        add.chest_state = stage_obj.chest_state
        add.star_num = stage_obj.star_num

    response.elite_stage_times = elite_stage_times
    response.elite_stage_reset_times = elite_stage_reset_times
    response.act_coin_stage_times = act_coin_stage_times
    response.act_exp_stage_times = act_exp_stage_times

    construct_lucky_heros(act_lucky_heros, response.stage_lucky_hero)

    response.plot_chapter = player.stage_component.plot_chapter
    player.stage_component.save_data()
    for chapter_id in player.stage_component.already_look_hide_stage:
        response.already_look_hide_stage.append(chapter_id)
    logger.debug(response.stage_lucky_hero)
    logger.debug(response.already_look_hide_stage)
    return response.SerializePartialToString()

def construct_lucky_heros(stage_lucky_heros, response_stage_lucky_hero):
    for stage_id, v in stage_lucky_heros.items():
        stage_lucky_hero_pb = response_stage_lucky_hero.add()
        stage_lucky_hero_pb.stage_id = stage_id

        for k, hero in v.get('heros').items():
            hero_no = hero.get("hero_no")
            lucky_hero_info_id = hero.get("lucky_hero_info_id")
            logger.debug("lucky_hero_info_id %s" % lucky_hero_info_id)
            lucky_hero_info = game_configs.lucky_hero_config.get(lucky_hero_info_id)
            hero_pb = stage_lucky_hero_pb.heros.add()
            hero_pb.hero_no = hero_no
            hero_pb.pos = lucky_hero_info.set
            for k, v in lucky_hero_info.get("attr").items():
                hero_attr = hero_pb.attr.add()
                hero_attr.attr_type = int(k)
                hero_attr.attr_value_type = v[0]
                hero_attr.attr_value = v[1]



@remoteserviceHandle('gate')
def get_chapter_912(pro_data, player):
    """取得剧情提示章节
    """
    request = stage_request_pb2.UpdataPlotChapterRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id
    response = stage_response_pb2.UpdataPlotChapterResponse()

    player.stage_component.plot_chapter = chapter_id
    player.stage_component.save_data()
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_chapter_902(pro_data, player):
    """取得章节奖励信息
    """
    request = stage_request_pb2.ChapterInfoRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id

    chapter_objs = get_chapter_info(chapter_id, player)

    response = stage_response_pb2.ChapterInfoResponse()
    for chapter_obj in chapter_objs:
        if len(chapter_obj.award_info) == 0:
            continue
        stage_award_add = response.stage_award.add()
        stage_award_add.chapter_id = chapter_obj.chapter_id
        for award in chapter_obj.award_info:
            stage_award_add.award.append(award)
        stage_award_add.star_gift = chapter_obj.star_gift
        stage_award_add.now_random = chapter_obj.now_random
        stage_award_add.random_gift_times = chapter_obj.random_gift_times
    # logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def stage_start_903(pro_data, player):
    """pve开始战斗
    """
    request = stage_request_pb2.StageStartRequest()
    request.ParseFromString(pro_data)

    stage_id = request.stage_id          # 关卡编号
    line_up = request.lineup            # 阵容顺序
    red_best_skill_id = request.unparalleled  # 无双编号
    fid = request.fid                    # 好友ID

    # logger.debug("red_best_skill_id,%s" % red_best_skill_id)
    # logger.debug("fid,%s" % fid)
    response = stage_response_pb2.StageStartResponse()
    player.fight_cache_component.stage_id = stage_id
    stage_config = player.fight_cache_component._get_stage_config()
    not_open = False
    if stage_config.type == 6: # 精英
        not_open = is_not_open(player, FO_ELI_STAGE)
    if stage_config.type in [4, 5]: # 活动
        not_open = is_not_open(player, FO_ACT_STAGE)
    if not_open:
        response.res.result = False
        response.res.result_no = 837
        return response.SerializeToString()

    stage_info = pve_process(stage_id, stage_config.type, line_up, fid, player)
    result = stage_info.get('result')

    res = response.res
    res.result = result

    if not result:
        # logger.info('进入关卡返回数据:%s', response)
        res.result_no = stage_info.get('result_no')
        return response.SerializePartialToString()

    red_units = stage_info.get('red_units')
    blue_groups = stage_info.get('blue_units')
    drop_num = stage_info.get('drop_num')
    blue_skill = stage_info.get('monster_unpara')
    f_unit = stage_info.get('f_unit')

    pve_assemble_units(red_units, blue_groups, response)
    pve_assemble_friend(f_unit, response)
    if blue_skill:
        response.monster_unpar = blue_skill
    response.hero_unpar = 0
    response.hero_unpar_level = 0

    response.drop_num = drop_num

    seed1, seed2 = get_seeds()
    player.fight_cache_component.seed1 = seed1
    player.fight_cache_component.seed2 = seed2
    player.fight_cache_component.red_best_skill_id = red_best_skill_id
    player.fight_cache_component.stage_info = stage_info
    response.seed1 = seed1
    response.seed2 = seed2

    if f_unit:
        player.fight_cache_component.fid = fid
    else:
        player.fight_cache_component.fid = 0

    player.fight_cache_component.red_best_skill_id = 0
    logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def fight_settlement_904(pro_data, player):
    request = stage_request_pb2.StageSettlementRequest()
    request.ParseFromString(pro_data)

    logger.debug("fight_settlement_904 id: %s player_id: %s" % (player.fight_cache_component.stage_id, player.base_info.id))

    stage_id = request.stage_id
    result = request.result
    always_win = request.always_win

    # logger.debug("steps:%s", request.steps)
    # player.fight_cache_component.red_units

    stage = player.stage_component.get_stage(stage_id)
    stage_config = player.fight_cache_component._get_stage_config()
    response = stage_response_pb2.StageSettlementResponse()
    res = response.res

    check_res = (True, 1, 1, -1, {})
    if not always_win:
        if (stage_config.type not in [1, 2, 3] or stage.star_num != 3) and request.is_skip:
            logger.error("can not be skip error!================= common stage")
            res.result = False
            res.result_no = 9041
            return response.SerializePartialToString()

        if (stage_config.type == 4 or stage.state != 1) and request.is_skip:
            logger.error("can not be skip error!=================hide stage")
            res.result = False
            res.result_no = 9041
            return response.SerializePartialToString()

        if request.is_skip and stage.state != 1:
            logger.error("can not be skip error!=================2")
            res.result = False
            res.result_no = 9041
            return response.SerializePartialToString()

        if not request.is_skip:
            check_res = pve_process_check(player, result, request.steps, const.BATTLE_PVE)

        if not request.is_skip and not check_res[0]:
            logger.error("pve_process_check error!=================")
            os.system("cp output ..")
            res.result = False
            res.result_no = 9041
            return response.SerializePartialToString()

    # 小伙伴支援消耗
    fid = player.fight_cache_component.fid
    if fid:
        player.friends.check_time()
        friend_fight_times = player.friends.fight_times
        if fid not in friend_fight_times:
            friend_fight_times[fid] = []

        supportPrice = game_configs.base_config.get('supportPrice')
        f_times = len(friend_fight_times[fid])
        price = None
        for _ in sorted(supportPrice.keys()):
            if f_times >= _:
                price = supportPrice[_]
        # todo calculate real price
        if not is_afford(player, price).get('result'):
            logger.error('stage 903 not enough money!:%s', price)
            response.res.result = False
            response.res.result_no = 101
            return response.SerializePartialToString()

        return_data = consume(player, price, const.STAGE)
        get_return(player, return_data, response.consume)

        friend_fight_times[fid].append(int(time.time()))
        player.friends.save_data()

    logger.debug("damage percent: %s" % check_res[1])
    logger.debug("red units: %s" % check_res[2])
    player.fight_cache_component.damage_percent = check_res[1]

    star = 0  # star num
    stage_info = player.fight_cache_component.stage_info
    red_units = stage_info.get('red_units')

    round_to_kill_num = check_res[4]
    red_left_num = check_res[3]
    red_left_hp_percent = check_res[2]
    death_num = len(red_units) - red_left_num
    for i in range(1, 4):
        star_condition = game_configs.base_config.get('star_condition')
        v = star_condition[i]
        if death_num >= v and red_left_num != 0:
            star = i
            break

    if request.is_skip:
        star = 3
    stage = get_stage_by_stage_type(stage_config.type, stage_id, player)
    if stage_config.type == 6 and result:
        logger.debug("it is a elite stage!")
        conditions = stage_config.ClearanceConditions
        for k, cond in conditions.items():
            logger.debug("k %s %s condi %s" % (k, type(k), cond))
            if k == 1 and (cond[0] in round_to_kill_num and round_to_kill_num[cond[0]] < cond[1]):
                logger.debug("elite condition 1 is not met!")
                result = False
                break
            if k == 2 and (death_num > cond[0]):
                logger.debug("elite condition 2 is not met!")
                result = False
                break
            if k == 3 and (red_left_hp_percent < cond[0]):
                logger.debug("elite condition 3 is not met!")
                result = False
                break

    if always_win and stage_id in game_configs.stage_show_config:
        # 新手引导中的假战斗，必胜，三星
        result = True
        star = 3
    res = fight_settlement(stage, result, player, star, response)
    logger.debug("steps:%s", request.steps)
    logger.debug("fight_settlement_904 end: %s" % time.time())

    return res


# @remoteserviceHandle('gate')
def get_warriors_906(pro_data, player):
    """请求无双 """
    response = stage_response_pb2.UnparalleledResponse()

    warriors = player.line_up_component.warriors
    for warrior in warriors:
        unpar_add = response.unpar.add()
        unpar_add.id = warrior
        warriors_cof = game_configs.warriors_config.get(warrior)   # 无双配置

        for i in range(1, 4):
            triggle = getattr(warriors_cof, 'triggle%s' % i)  # 技能编号
            if triggle:
                skill_cof = game_configs.skill_config.get(triggle)  # 技能配置
                group = skill_cof.group

                skill = unpar_add.unpar.add()
                skill.id = triggle

                buffs = skill.buffs

                for buff_id in group:
                    buffs.append(buff_id)
    # logger.info('warriors: %s' % response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def stage_sweep_907(pro_data, player):
    request = stage_request_pb2.StageSweepRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id
    times = request.times
    sweep_type = request.sweep_type

    return stage_sweep(stage_id, times, player, sweep_type)


def get_stage_info(stage_id, player):
    """取得关卡信息
    """
    if time.localtime(player.stage_component.stage_up_time).tm_mday != time.localtime().tm_mday:
        player.stage_component.stage_up_time = int(time.time())
        player.stage_component.update_stage_times()
        player.stage_component.save_data()

    response = []
    if stage_id:  # 根据关卡ID
        stage_obj = player.stage_component.get_stage(stage_id)
        response.append(stage_obj)
    else:  # 全部
        stages_obj = player.stage_component.get_stages()
        response.extend(stages_obj)

    player.stage_component.check_time() #  时间改变，重置数据

    return response, \
        player.stage_component.elite_stage_info[0], \
        player.stage_component.elite_stage_info[1],\
        player.stage_component.act_stage_info[0],\
        player.stage_component.act_stage_info[1],\
        player.stage_component._act_lucky_heros


def get_chapter_info(chapter_id, player):
    """取得章节奖励信息
    """
    response = []

    if chapter_id:
        chapter_obj = player.stage_component.get_chapter(chapter_id)
        response.append(chapter_obj)
    else:
        chapters_obj = player.stage_component.get_chapters()
        response.extend(chapters_obj)

    return response


def fight_settlement(stage, result, player, star_num, response):
    res = response.res
    res.result = True
    stage_id = stage.stage_id

    # 校验是否保存关卡
    fight_cache_component = player.fight_cache_component
    if stage_id != fight_cache_component.stage_id:
        res.result = False
        res.message = u"关卡id和战斗缓存id不同"
        return response.SerializeToString()

    stage.settle(result, response, star_num=star_num)
    # 触发黄巾起义
    hjqy_stage_id = trigger_hjqy(player, result)
    response.hjqy_stage_id = hjqy_stage_id
    if hjqy_stage_id:
        tlog_action.log('TriggerHJQY', player, stage_id, hjqy_stage_id)
    response.battle_res = result
    response.star_num = star_num
    logger.debug("drops %s" % response.drops)
    logger.debug("star_num %s" % response.star_num)
    logger.debug("consume %s" % response.consume)
    return response.SerializePartialToString()


def stage_sweep(stage_id, times, player, sweep_type):
    response = stage_response_pb2.StageSweepResponse()
    res = response.res
    stage_obj = player.stage_component.get_stage(stage_id)
    # 关于关卡挑战次数
    if time.localtime(player.stage_component.stage_up_time).tm_yday != time.localtime().tm_yday:
        player.stage_component.stage_up_time = int(time.time())
        player.stage_component.update_stage_times()
        player.stage_component.save_data()

    # vip等级够不够
    if times == 1:
        if not game_configs.vip_config.get(player.base_info.vip_level).openSweep:
            logger.error('result_no = 803')
            res.result = False
            res.result_no = 803
            return response.SerializePartialToString()
    if times > 1:
        if not game_configs.vip_config.get(player.base_info.vip_level).openSweepTen:
            logger.error('result_no = 803')
            res.result = False
            res.result_no = 803
            return response.SerializePartialToString()

    # 关卡打开没有
    state = player.stage_component.check_stage_state(stage_id)
    if state != 1:
        logger.error('result_no = 803')
        res.result = False
        res.result_no = 803
        return response.SerializePartialToString()

    stage_config = game_configs.stage_config.get('stages').get(stage_id)

    # 限制次数够不够
    if stage_obj.attacks + times > stage_config.limitTimes:
        logger.error('result_no = 810')
        res.result = False
        res.result_no = 810
        return response.SerializePartialToString()

    # 花费
    if sweep_type == 1:
        # 扫荡卷
        sweep_item = game_configs.base_config.get('sweepNeedItem')
    elif sweep_type == 2:
        sweep_item = game_configs.base_config.get('price_sweep')
    else:
        logger.error('result_no = 800 ,sweep type error===========')
        res.result = False
        res.result_no = 800
        return response.SerializePartialToString()

    result = is_afford(player, sweep_item, multiple=times)  # 校验
    if not result.get('result'):
        logger.error('result_no = 839 ,===========')
        res.result = False
        res.result_no = 839
        return response.SerializePartialToString()

    need_gold = get_consume_gold_num(sweep_item, times)

    tlog_event_id = get_uuid()

    def func():

        # 武将乱入
        fight_cache_component = player.fight_cache_component
        fight_cache_component.stage_id = stage_id
        red_units, blue_units, drop_num, monster_unpara = fight_cache_component.fighting_start()

        multiple, part_multiple = get_drop_activity(player, player.fight_cache_component.stage_id, 1, stage_obj.star_num)
        for _ in range(times):
            drop = []

            drops = response.drops.add()
            low = stage_config.low
            high = stage_config.high
            drop_num = random.randint(low, high)

            for __ in range(drop_num):
                common_bag = BigBag(stage_config.commonDrop)
                common_drop = common_bag.get_drop_items()
                drop.extend(common_drop)

            fight_cache_component.get_stage_drop(stage_config, drop)

            data = gain(player, drop, const.STAGE_SWEEP, event_id=tlog_event_id,multiple=multiple, part_multiple=part_multiple)
            get_return(player, data, drops)

            # 乱入武将按概率获取碎片
            break_stage_id = player.fight_cache_component.break_stage_id
            if break_stage_id:
                break_stage_info = game_configs.stage_break_config.get(break_stage_id)
                ran = random.random()
                if ran <= break_stage_info.reward_odds:
                    # logger.debug("break_stage_info=============%s %s" % (break_stage_info.reward, 1))
                    data = gain(player, break_stage_info.reward, const.STAGE_SWEEP)
                    get_return(player, data, drops)

            player.finance.consume(const.STAMINA, stage_config.vigor, const.STAGE_SWEEP)
            # 经验
            for (slot_no, lineUpSlotComponent) in player.line_up_component.line_up_slots.items():
                hero = lineUpSlotComponent.hero_slot.hero_obj
                if hero:

                    beforelevel = hero.level
                    hero.upgrade(stage_config.HeroExp, player.base_info.level)
                    afterlevel = hero.level
                    changelevel = afterlevel-beforelevel
                    hero.save_data()
                    if changelevel:
                        tlog_action.log('HeroUpgrade', player, hero.hero_no, changelevel,
                                        afterlevel, 3, 0, 0, 0, 0)
            # 玩家金钱
            player.finance.coin += stage_config.currency
            # 玩家经验
            player.base_info.addexp(stage_config.playerExp, const.STAGE_SWEEP)
        # 更新等级相关属性
        player.set_level_related()

        # hook task
        hook_task(player, CONDITIONId.ANY_STAGE, times)
        logger.debug("sweep time %s %s" % (times, sweep_item))
        return_data = consume(player, sweep_item, const.STAGE_SWEEP,
                              multiple=times)
        get_return(player, return_data, response.consume)

        player.stage_component.get_stage(stage_id).attacks += times
        player.stage_component.save_data()

        player.stamina.save_data()
        player.base_info.save_data()
        player.finance.save_data()

    player.pay.pay(need_gold, const.STAGE_SWEEP, func)

    # 触发黄巾起义
    hjqy_stage_id = trigger_hjqy(player, result, times)
    response.hjqy_stage_id = hjqy_stage_id
    if hjqy_stage_id:
        tlog_action.log('TriggerHJQY', player, stage_id, hjqy_stage_id)

    res.result = True
    tlog_action.log('SweepFlow', player, stage_id, times, tlog_event_id)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def reset_stage_908(pro_data, player):
    request = stage_request_pb2.ResetStageRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id
    response = stage_response_pb2.ResetStageResponse()

    stage_obj = player.stage_component.get_stage(stage_id)
    is_today = 0
    times_enough = 1

    logger.debug("reset stage  %s" % (stage_obj.reset[0]))
    if time.localtime(stage_obj.reset[1]).tm_year == time.localtime().tm_year \
            and time.localtime(stage_obj.reset[1]).tm_yday == time.localtime().tm_yday:
        is_today = 1
    else:
        stage_obj.reset = [1, int(time.time())]

    if game_configs.vip_config.get(player.base_info.vip_level).buyStageResetTimes <= stage_obj.reset[0]:
        times_enough = 0

    if is_today and not times_enough:
        logger.error("stage reset times not enough")
        response.res.result = False
        response.res.result_no = 830
        return response.SerializePartialToString()

    need_gold = game_configs.base_config.get('stageResetPrice')[stage_obj.reset[0]]
    logger.debug("reset stage %s %s" % (stage_obj.reset[0], need_gold))
    if player.finance.gold < need_gold:
        logger.error("gold not enough")
        response.res.result = False
        response.res.result_no = 102
        return response.SerializePartialToString()

    player.finance.consume_gold(need_gold, const.RESET_STAGE)

    if is_today and times_enough:
        stage_obj.reset[0] += 1
    stage_obj.attacks = 0
    player.stage_component.save_data()
    player.finance.save_data()

    tlog_action.log('ResetStage', player, stage_id, stage_obj.reset[0])
    response.res.result = True
    # logger.debug('reset stage 908 success')
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def get_award_909(pro_data, player):
    """取得章节奖励
    """
    request = stage_request_pb2.StarAwardRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id
    award_type = request.award_type
    response = stage_response_pb2.StarAwardResponse()

    chapters_info = get_chapter_info(chapter_id, player)
    if len(chapters_info) != 1 or chapter_id == 1 or len(chapters_info[0].award_info) == 0:
        logger.error("chapter_info dont find")
        response.res.result = False
        response.res.result_no = 831
        return response.SerializePartialToString()
    else:
        chapter_obj = chapters_info[0]

    conf = chapter_obj.get_conf()
    chapter_obj.update(player.stage_component.calculation_star(chapter_id))

    if 0 <= award_type <= 2:
        if chapter_obj.award_info[award_type] != 0:
            logger.error("already receive or can`t receive")
            response.res.result = False
            response.res.result_no = 832
            return response.SerializePartialToString()
        else:
            chapter_obj.award_info[award_type] = 1
            bag_id = conf.starGift[award_type]

        drop = get_drop(bag_id)
        return_data = gain(player, drop, const.CHAPTER_AWARD)
        get_return(player, return_data, response.drops)
        player.stage_component.save_data()
        tlog_action.log('OpenStarChest', player, chapter_id, award_type)

    else:
        response.res.result = False
        response.res.result_no = 800
        return response.SerializePartialToString()
        # 满星抽奖
        # if chapter_obj.award_info[-1] == -1:
        #     logger.error("can`t receive")
        #     response.res.result = False
        #     response.res.result_no = 833
        #     return response.SerializePartialToString()
        # else:
        #     pass

    response.res.result = True
    # logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def get_star_random_1828(pro_data, player):
    """取得满星抽奖随机倍数
    """
    request = stage_request_pb2.GetStarRandomRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id

    response = stage_response_pb2.GetStarRandomResponse()

    chapters_info = get_chapter_info(chapter_id, player)
    chapter_obj = chapters_info[0]
    chapter_conf = chapter_obj.get_conf()
    chapter_obj.update(player.stage_component.calculation_star(chapter_id))

    if not chapter_conf.starMagnification or len(chapters_info[0].award_info) == 0:
        logger.error("get_star_random_1828, not chapter_conf.starMagnification or len(chapters_info[0].award_info) == 0")
        response.res.result = False
        response.res.result_no = 831
        return response.SerializePartialToString()

    if chapter_obj.star_gift == 1:
        response.res.result = False
        response.res.result_no = 800
        logger.error("get_star_random_1828, alreaday get gift")
        return response.SerializePartialToString()

    # chapter_obj.random_gift_times
    if not chapter_obj.now_random:
        chapter_obj.now_random = chapter_conf.starMagnification

    random_num_conf = game_configs.lottery_config.get(chapter_obj.now_random)
    if not random_num_conf.Probability:
        # 已经达到最大值
        response.res.result = False
        response.res.result_no = 800
        logger.error("get_star_random_1828, now_random  max")
        return response.SerializePartialToString()
    need_gold = game_configs.base_config.\
        get('LotteryPrice')[chapter_obj.random_gift_times]
    if need_gold > player.finance.gold:
        response.res.result = False
        response.res.result_no = 102
        return response.SerializeToString()

    def func():
        random_num = 10005
        if not request.is_newbee:
            random_num = do_get_star_random(random_num_conf)
        response.random_num = random_num
        chapter_obj.now_random = random_num
        chapter_obj.random_gift_times += 1
        chapter_obj.star_gift = 3
        player.stage_component.save_data()
        tlog_action.log('StarRandom', player, random_num, chapter_obj.random_gift_times, chapter_id)

    player.pay.pay(need_gold, const.STAGE_STAR_GIFT, func)

    response.res.result = True
    logger.debug(response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def deal_random_1829(pro_data, player):
    """处理随机出来的倍数，领取或者放弃
    """
    request = stage_request_pb2.DealRandomRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id

    response = stage_response_pb2.DealRandomResponse()

    chapters_info = get_chapter_info(chapter_id, player)
    if len(chapters_info) != 1 or chapter_id == 1 or len(chapters_info[0].award_info) == 0:
        logger.error("deal_random_1829,chapter_info dont find, chapter_id == 1")
        response.res.result = False
        response.res.result_no = 800
        return response.SerializePartialToString()
    else:
        chapter_obj = chapters_info[0]

    chapter_conf = chapter_obj.get_conf()
    chapter_obj.update(player.stage_component.calculation_star(chapter_id))

    if chapter_obj.star_gift != 3 or chapter_obj.random_gift_times == 0:
        response.res.result = False
        response.res.result_no = 800
        logger.error("deal_random_1829, chapter_obj.star_gift != 3 or chapter_obj.random_gift_times == 0")
        return response.SerializePartialToString()

    drop_num = game_configs.lottery_config.get(chapter_obj.now_random).Magnification

    if request.res == 1:

        return_data = gain(player,
                           chapter_conf.dragonGift,
                           const.STAGE_STAR_GIFT,
                           multiple=drop_num)  # 获取

        return_data1 = []
        for rd in return_data:
            if not return_data1:
                return_data1.append(return_data[0])
            else:
                return_data1[0][1] += rd[1]

        get_return(player, return_data1, response.drops)
        chapter_obj.star_gift = 1
    else:  # res 为2， 放弃
        random_num_conf = game_configs.lottery_config.get(chapter_obj.now_random)
        if not random_num_conf.Probability:
            # 已经达到最大值
            response.res.result = False
            response.res.result_no = 800
            logger.error("get_star_random_1828, now_random  max")
            return response.SerializePartialToString()
        chapter_obj.star_gift = 2

    tlog_action.log('DealStarRandom', player, chapter_obj.now_random, request.res, chapter_id)
    player.stage_component.save_data()

    response.res.result = True
    logger.debug(response)
    return response.SerializeToString()


def do_get_star_random(random_id_conf):
    random_num = random.randint(1, 100)
    v = 0
    for random_id, x in random_id_conf.Probability.items():
        v += x * 100
        if v >= random_num:
            return random_id
    else:
        logger.error("get_star_random_1828, do_get_star_random  random_id = 0")
        return 0


def get_drop(bag_id):
    drops = []
    common_bag = BigBag(bag_id)
    common_drop = common_bag.get_drop_items()
    drops.extend(common_drop)
    return drops


@remoteserviceHandle('gate')
def open_chest_1811(pro_data, player):
    request = stage_request_pb2.OpenStageChestRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id
    response = stage_response_pb2.OpenStageChestResponse()

    stage_type = 1
    if game_configs.stage_config.get('stages').get(stage_id):
        stage_config = game_configs.stage_config.get(
            'stages').get(stage_id)
    if game_configs.special_stage_config.get(
            'elite_stages').get(stage_id):
        stage_type = 2
        stage_config = game_configs.special_stage_config.get(
            'elite_stages').get(stage_id)

    if not stage_config:
        response.res.result = False
        response.res.result_no = 800
        return response.SerializePartialToString()

    stage_obj = player.stage_component.get_stage(stage_id)

    if stage_obj.chest_state:
        response.res.result = False
        response.res.result_no = 863
        return response.SerializePartialToString()

    if stage_obj.state != 1:
        response.res.result = False
        response.res.result_no = 864
        return response.SerializePartialToString()

    return_data = gain(player, stage_config.stageBox, const.StageChestGift)
    get_return(player, return_data, response.drops)

    stage_obj.chest_state = 1
    player.stage_component.save_data()
    tlog_action.log('OpenChest', player, stage_id, stage_type)

    response.res.result = True
    # logger.debug(response)
    return response.SerializePartialToString()


def trigger_hjqy(player, result, times=1):
    """docstring for trigger_hjqy 触发黄巾起义
    return: stage id
    """
    if is_not_open(player, FO_HJQY_STAGE):
        return 0
    # 如果战败则不触发
    if not result:
        return 0
    logger.debug("trigger_hjqy")
    # 活动是否开启
    if player.base_info.is_firstday_from_register(const.OPEN_FEATURE_HJQY):
        logger.debug("hjqy have not open.")
        return 0

    # 如果已经触发过hjqy，则不触发
    if not remote_gate['world'].is_can_trigger_hjqy_remote(player.base_info.id):
        return 0

    stage_info = player.fight_cache_component._get_stage_config()
    if stage_info.type not in [1, 2, 3]:
        # 只有在剧情关卡时，才能触发黄巾起义
        return 0
    logger.debug(stage_info.chapter)
    logger.debug(stage_info.type)
    logger.debug(stage_info.id)

    logger.debug("can_trigger_hjqy")
    # 触发hjqy
    open_stage_id = player.stage_component.stage_progress
    player.fight_cache_component.stage_id = open_stage_id
    stage_info = player.fight_cache_component._get_stage_config()

    #rate = 0.01 # for test
    hjqytrigger = game_configs.base_config.get("hjqytrigger")
    hjqyRandomCheckpoint = game_configs.base_config.get("hjqyRandomCheckpoint")
    rate = 1
    for i in range(times):
        rate = random.random()
        if rate <= hjqytrigger[0]:
            break
    logger.debug("rate: %s, hjqytrigger:%s" % (rate, hjqytrigger))
    if rate > hjqytrigger[0]:
        return 0


    info = {}
    for i in range(1, 4):
        info[i] = hjqytrigger[i]

    stage_index = random_pick_with_weight(info)

    logger.debug("chapter: %s, stage_index: %s, stage_id: %s, open_stage_id: %s" % (stage_info.chapter, stage_index, player.fight_cache_component.stage_id, open_stage_id))

    if stage_info.chapter not in hjqyRandomCheckpoint:
        return 0

    stage_id = hjqyRandomCheckpoint.get(stage_info.chapter)[stage_index-1]

    monster_lv = hjqyRandomCheckpoint.get(stage_info.chapter)[3]

    hjqyRule2 = game_configs.base_config.get("hjqyRule2")
    if monster_lv - player.base_info.level > hjqyRule2:
        logger.debug("monster_lv %s, player.base_info.level %s, hjqyRule2 %s" % (monster_lv, player.base_info.level, hjqyRule2))
        if (stage_info.chapter - 1) not in hjqyRandomCheckpoint:
            return 0
        stage_id = hjqyRandomCheckpoint.get(stage_info.chapter-1)[stage_index-1]

    player.fight_cache_component.stage_id = stage_id


    blue_units = player.fight_cache_component._assemble_monster()

    str_blue_units = cPickle.dumps(blue_units[0])
    result = remote_gate['world'].create_hjqy_remote(player.base_info.id, player.base_info.base_name, str_blue_units, stage_id)
    logger.debug("8============= %s %s" % (stage_id, open_stage_id))
    if not result:
        return 0
    # send trigger reward
    hjqyOpenReward = game_configs.base_config.get("hjqyOpenRewardID")
    send_mail(conf_id=hjqyOpenReward, receive_id=player.base_info.id)

    return stage_id


@remoteserviceHandle('gate')
def look_hide_stage_1842(pro_data, player):
    """取得关卡信息
    """
    request = stage_request_pb2.LookHideStageRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id

    if not player.stage_component.already_look_hide_stage.count(chapter_id):
        player.stage_component.already_look_hide_stage.append(chapter_id)
        player.stage_component.save_data()

    response = stage_response_pb2.LookHideStageResponse()
    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def elite_stage_times_reset_1845(pro_data, player):
    """重置精英关卡攻打次数
    """
    response = stage_response_pb2.EliteStageTimesResetResponse()

    tm_time = time.localtime(player.stage_component.elite_stage_info[2])
    max_add_times = game_configs.vip_config.get(player.base_info.vip_level).eliteCopyAdditionalTimes

    if tm_time.tm_yday != time.localtime().tm_yday:
        player.stage_component.elite_stage_info = [0, 0, int(time.time())]

    if player.stage_component.elite_stage_info[1] >= max_add_times:
        logger.error('elite_stage_times_reset_1845,times not enough:%s', player.stage_component.elite_stage_info[1])
        response.res.result = False
        response.res.result_no = 805
        return response.SerializePartialToString()
    need_gold = game_configs.base_config.get('eliteDuplicatePrice')[player.stage_component.elite_stage_info[1]]
    if player.finance.gold < need_gold:
        logger.error("gold not enough")
        response.res.result = False
        response.res.result_no = 102
        return response.SerializePartialToString()

    def func():
        player.stage_component.elite_stage_info[1] += 1
        player.stage_component.elite_stage_info[0] -= 1
        player.stage_component.save_data()

    player.pay.pay(need_gold, const.GUILD_CREATE, func)
    tlog_action.log('BuyEliteStageTimes', player, player.stage_component.elite_stage_info[1],
                    1, need_gold)

    response.res.result = True
    return response.SerializePartialToString()
