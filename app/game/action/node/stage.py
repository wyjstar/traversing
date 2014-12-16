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

    stages_obj, elite_stage_times, act_stage_times, sweep_times = get_stage_info(stage_id, player)

    response = stage_response_pb2.StageInfoResponse()
    for stage_obj in stages_obj:
        add = response.stage.add()
        add.stage_id = stage_obj.stage_id
        add.attacks = stage_obj.attacks
        add.state = stage_obj.state
    response.elite_stage_times = elite_stage_times
    response.act_stage_times = act_stage_times
    response.sweep_times = sweep_times
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
        stage_award_add = response.stage_award.add()
        stage_award_add.chapter_id = chapter_obj.chapter_id

        for award in chapter_obj.award_info:
            stage_award_add.award.append(award)

        stage_award_add.dragon_gift = chapter_obj.dragon_gift

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
    red_best_skill_id = request.unparalleled # 无双编号
    fid = request.fid                    # 好友ID

    logger.debug("red_best_skill_id,%s" % red_best_skill_id)
    logger.debug("fid,%s" % fid)

    stage_info = pve_process(stage_id, stage_type, line_up, fid, player)
    result = stage_info.get('result')

    response = stage_response_pb2.StageStartResponse()
    res = response.res
    res.result = result

    if not result:
        logger.info('进入关卡返回数据:%s', response)
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

    if time.localtime(player.stage_component.elite_stage_info[1]).tm_mday == time.localtime().tm_mday:
        elite_stage_times = player.stage_component.elite_stage_info[0]
    else:
        elite_stage_times = 0

    if time.localtime(player.stage_component.act_stage_info[1]).tm_mday == time.localtime().tm_mday:
        act_stage_times = player.stage_component.act_stage_info[0]
    else:
        act_stage_times = 0

    if time.localtime(player.stage_component.sweep_times[1]).tm_mday == time.localtime().tm_mday:
        sweep_times = player.stage_component.sweep_times[0]
    else:
        sweep_times = 0
    return response, elite_stage_times, act_stage_times, sweep_times


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
    drops = response.drops
    res = response.res

    need_money = 0
    if times == 1:
        if not game_configs.vip_config.get(player.vip_component.vip_level).openSweep:
            res.result = False
            res.result_no = 803
            return response.SerializePartialToString()
    if times == 10:
        if not game_configs.vip_config.get(player.vip_component.vip_level).openSweepTen:
            res.result = False
            res.result_no = 803
            return response.SerializePartialToString()

    if time.localtime(player.stage_component.sweep_times[1]).tm_mday == time.localtime().tm_mday \
            and game_configs.vip_config.get(player.vip_component.vip_level).freeSweepTimes - player.stage_component.sweep_times[0] < times:
        need_money = times-(game_configs.vip_config.get(player.vip_component.vip_level).freeSweepTimes-player.stage_component.sweep_times[0])
        if need_money > player.finance.gold:
            res.result = False
            res.result_no = 102
            return response.SerializePartialToString()
    state = player.stage_component.check_stage_state(stage_id)
    if state != 1:
        res.result = False
        res.result_no = 803
        return response.SerializePartialToString()

    stage_config = game_configs.stage_config.get('stages').get(stage_id)

    if player.stage_component.get_stage(stage_id).attacks + times > stage_config.limitTimes:
        res.result = False
        res.result_no = 810
        return response.SerializePartialToString()

    drop = []
    for _ in range(times):
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

    if time.localtime(player.stage_component.sweep_times[1]).tm_mday == time.localtime().tm_mday:
        player.stage_component.sweep_times[0] += times
    else:
        player.stage_component.sweep_times[0] = times
        player.stage_component.sweep_times[1] = int(time.time())

    player.stage_component.get_stage(stage_id).attacks += times
    player.stage_component.update()

    player.stamina.stamina -= stage_config.vigor
    player.stamina.save_data()
    # 经验
    for (slot_no, lineUpSlotComponent) in player.line_up_component.line_up_slots.items():
        print lineUpSlotComponent,
        hero = lineUpSlotComponent.hero_slot.hero_obj
        if hero:
            hero.upgrade(stage_config.HeroExp)
    # 玩家金钱
    player.finance.coin += stage_config.currency
    player.finance.gold -= need_money
    # 玩家经验
    player.level.addexp(stage_config.playerExp)
    player.save_data()

    res.result = True
    return response.SerializePartialToString()
