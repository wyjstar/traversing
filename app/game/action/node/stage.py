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
from shared.db_opear.configs_data.game_configs import special_stage_config
from app.game.core.drop_bag import BigBag
from app.game.core.lively import task_status
from app.game.core.item_group_helper import gain, get_return
from app.game.component.achievement.user_achievement import EventType
from app.game.component.achievement.user_achievement import CountEvent
from app.game.component.fight.stage_factory import get_stage_by_stage_type
from app.game.action.node._fight_start_logic import pve_process, pve_assemble_units, pve_assemble_friend


remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def get_stages_901(pro_data, player):
    """取得关卡信息
    """
    request = stage_request_pb2.StageInfoRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id

    stages_obj, elite_stage_times, act_stage_times = get_stage_info(stage_id, player)

    response = stage_response_pb2.StageInfoResponse()
    for stage_obj in stages_obj:
        add = response.stage.add()
        add.stage_id = stage_obj.stage_id
        add.attacks = stage_obj.attacks
        add.state = stage_obj.state
        add.reset.times = stage_obj.reset[0]
        add.reset.time = stage_obj.reset[1]
    response.elite_stage_times = elite_stage_times
    response.act_stage_times = act_stage_times
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def get_chapter_902(pro_data, player):
    """取得章节奖励信息
    """
    request = stage_request_pb2.ChapterInfoRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id

    chapters_id = get_chapter_info(chapter_id, player)

    response = stage_response_pb2.ChapterInfoResponse()
    for chapter_obj in chapters_id:
        if len(chapter_obj.award_info) == 0:
            continue
        stage_award_add = response.stage_award.add()
        stage_award_add.chapter_id = chapter_obj.chapter_id
        for award in chapter_obj.award_info:
            stage_award_add.award.append(award)
        stage_award_add.dragon_gift = chapter_obj.dragon_gift
    # logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def stage_start_903(pro_data, player):
    """pve开始战斗
    """
    request = stage_request_pb2.StageStartRequest()
    request.ParseFromString(pro_data)

    stage_id = request.stage_id          # 关卡编号
    stage_type = request.stage_type      # 关卡类型
    line_up = request.lineup            # 阵容顺序
    red_best_skill_id = request.unparalleled  # 无双编号
    fid = request.fid                    # 好友ID

    logger.debug("red_best_skill_id,%s" % red_best_skill_id)
    logger.debug("fid,%s" % fid)

    stage_info = pve_process(stage_id, stage_type, line_up, fid, player)
    result = stage_info.get('result')

    response = stage_response_pb2.StageStartResponse()
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
    red_best_skill_no, red_best_skill_level = player.line_up_component.get_skill_info_by_unpar(red_best_skill_id)
    response.hero_unpar = red_best_skill_id
    response.hero_unpar_level = red_best_skill_level

    response.drop_num = drop_num
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def fight_settlement_904(pro_data, player):
    request = stage_request_pb2.StageSettlementRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id
    result = request.result
    stage = get_stage_by_stage_type(request.stage_type, stage_id, player)
    res = fight_settlement(stage, result, player)

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
    logger.info('warriors: %s' % response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def stage_sweep_907(pro_data, player):
    request = stage_request_pb2.StageSweepRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id
    times = request.times
    lively_event = {}
    if game_configs.stage_config.get('stages').get(stage_id):  # 关卡
        lively_event = CountEvent.create_event(EventType.STAGE_1, times, ifadd=True)
    elif special_stage_config.get('elite_stages').get(stage_id):  # 精英关卡
        lively_event = CountEvent.create_event(EventType.STAGE_2, times, ifadd=True)
    elif special_stage_config.get('act_stages').get(stage_id):  # 活动关卡
        lively_event = CountEvent.create_event(EventType.STAGE_3, times, ifadd=True)

    tstatus = player.tasks.check_inter(lively_event)
    player.tasks.save_data()
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])

    return stage_sweep(stage_id, times, player)


def get_stage_info(stage_id, player):
    """取得关卡信息
    """
    if time.localtime(player.stage_component.stage_up_time).tm_mday != time.localtime().tm_mday:
        player.stage_component.stage_up_time = int(time.time())
        player.stage_component.update_stage_times()
        player.stage_component.update()

    response = []
    if stage_id:  # 根据关卡ID
        stage_obj = player.stage_component.get_stage(stage_id)
        response.append(stage_obj)
    else:  # 全部
        stages_obj = player.stage_component.get_stages()
        response.extend(stages_obj)

    if time.localtime(player.stage_component.elite_stage_info[1]).tm_yday == time.localtime().tm_yday:
        elite_stage_times = player.stage_component.elite_stage_info[0]
    else:
        elite_stage_times = 0

    if time.localtime(player.stage_component.act_stage_info[1]).tm_yday == time.localtime().tm_yday:
        act_stage_times = player.stage_component.act_stage_info[0]
    else:
        act_stage_times = 0

    return response, elite_stage_times, act_stage_times


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

def fight_settlement(stage, result, player):
    response = stage_response_pb2.StageSettlementResponse()
    res = response.res
    res.result = True
    stage_id = stage.stage_id

    # 校验是否保存关卡
    fight_cache_component = player.fight_cache_component
    if stage_id != fight_cache_component.stage_id:
        res.result = False
        res.message = u"关卡id和战斗缓存id不同"
        return response.SerializeToString()

    stage.settle(result, response)
    return response.SerializePartialToString()


def stage_sweep(stage_id, times, player):
    response = stage_response_pb2.StageSweepResponse()
    res = response.res

    if time.localtime(player.stage_component.stage_up_time).tm_yday != time.localtime().tm_yday:
        player.stage_component.stage_up_time = int(time.time())
        player.stage_component.update_stage_times()
        player.stage_component.update()

    if times == 1:
        if not game_configs.vip_config.get(player.vip_component.vip_level).openSweep:
            logger.error('result_no = 803')
            res.result = False
            res.result_no = 803
            return response.SerializePartialToString()
    if times > 1:
        if not game_configs.vip_config.get(player.vip_component.vip_level).openSweepTen:
            logger.error('result_no = 803')
            res.result = False
            res.result_no = 803
            return response.SerializePartialToString()

    state = player.stage_component.check_stage_state(stage_id)
    if state != 1:
        logger.error('result_no = 803')
        res.result = False
        res.result_no = 803
        return response.SerializePartialToString()

    stage_config = game_configs.stage_config.get('stages').get(stage_id)

    if player.stage_component.get_stage(stage_id).attacks + times > stage_config.limitTimes:
        logger.error('result_no = 810')
        res.result = False
        res.result_no = 810
        return response.SerializePartialToString()

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

        elite_bag = BigBag(stage_config.eliteDrop)
        elite_drop = elite_bag.get_drop_items()
        drop.extend(elite_drop)

        data = gain(player, drop)
        get_return(player, data, drops)

        player.stamina.stamina -= stage_config.vigor
        # 经验
        for (slot_no, lineUpSlotComponent) in player.line_up_component.line_up_slots.items():
            print lineUpSlotComponent,
            hero = lineUpSlotComponent.hero_slot.hero_obj
            if hero:
                hero.upgrade(stage_config.HeroExp, player.level.level)
                hero.save_data()
        # 玩家金钱
        player.finance.coin += stage_config.currency
        # 玩家经验
        player.level.addexp(stage_config.playerExp)

    # 活跃度
    lively_event = CountEvent.create_event(EventType.STAGE_1, times, ifadd=True)
    # 保存活跃度
    tstatus = player.tasks.check_inter(lively_event)
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])

    player.stage_component.get_stage(stage_id).attacks += times
    player.stage_component.update()

    player.stamina.save_data()
    player.save_data()
    player.finance.save_data()

    res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def reset_stage_908(pro_data, player):
    request = stage_request_pb2.ResetStageRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id

    response = stage_response_pb2.ResetStageResponse()

    stage_obj = player.stage_component.get_stage(stage_id)

    if time.localtime(stage_obj.reset[1]).tm_year == time.localtime().tm_year \
            and time.localtime(stage_obj.reset[1]).tm_yday == time.localtime().tm_yday:
        if game_configs.vip_config.get(player.vip_component.vip_level).buyStageResetTimes <= stage_obj.reset[0]:
            logger.error("stage reset times not enough")
            response.res.result = False
            response.res.result_no = 830
            return response.SerializePartialToString()
        else:
            stage_obj.reset[0] += 1
    else:
        stage_obj.reset = [1, int(time.time())]
    need_gold = game_configs.base_config.get('stageResetPrice')[stage_obj.reset[0] - 1]
    if player.finance.gold < need_gold:
        logger.error("gold not enough")
        response.res.result = False
        response.res.result_no = 102
        return response.SerializePartialToString()

    stage_obj.attacks = 0
    player.finance.gold -= need_gold

    player.stage_component.update()
    player.finance.save_data()

    response.res.result = True
    logger.debug('reset stage 908 success')
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def get_award_909(pro_data, player):
    """取得章节奖励信息
    """
    return get_award(pro_data, player)

@remoteserviceHandle('gate')
def get_award_910(pro_data, player):
    """取得章节奖励信息
    """
    return get_award(pro_data, player)

def get_award(pro_data, player):

    request = stage_request_pb2.StarAwardRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id
    award_type = request.award_type
    response = stage_response_pb2.StarAwardResponse()

    chapters_info = get_chapter_info(chapter_id, player)
    if len(chapters_info) != 1 or chapter_id == 1 or (chapter_id == 2 and award_type ==2) or len(chapters_info[0].award_info) == 0:
        logger.error("chapter_info dont find,or (chapter_id == 1 and award_type == 2 ) or ")
        response.res.result = False
        response.res.result_no = 831
        return response.SerializePartialToString()
    else:
        chapter_obj = chapters_info[0]

    conf = chapter_obj.get_conf()

    if 0 <= award_type <= 2:
        if chapter_obj.award_info[award_type] != 0:
            logger.error("already receive or can`t receive")
            response.res.result = False
            response.res.result_no = 832
            return response.SerializePartialToString()
        else:
            chapter_obj.award_info[award_type] = 1
            bag_id = conf.starGift[award_type]

    else:
        if chapter_obj.award_info[-1] == -1:
            logger.error("can`t receive")
            response.res.result = False
            response.res.result_no = 833
            return response.SerializePartialToString()
        else:
            chapter_obj.dragon_gift = 1
            bag_id = conf.dragonGift

    drop = get_drop(bag_id)
    return_data = gain(player, drop)
    get_return(player, return_data, response.drops)

    player.stage_component.update()

    response.res.result = True
    logger.debug(response)
    return response.SerializePartialToString()

def get_drop(bag_id):
    drops = []
    common_bag = BigBag(bag_id)
    common_drop = common_bag.get_drop_items()
    drops.extend(common_drop)
    return drops
