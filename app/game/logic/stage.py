# -*- coding:utf-8 -*-
"""
created by server on 14-7-18下午3:44.
"""
import random
import time
from app.game.core.drop_bag import BigBag
from app.game.core.fight.battle_unit import BattleUnit
from app.game.logic.common.check import have_player
from app.game.logic.item_group_helper import gain, get_return
from app.game.redis_mode import tb_character_lord
from app.proto_file import stage_response_pb2
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs


@have_player
def get_stage_info(dynamic_id, stage_id, **kwargs):
    """取得关卡信息
    """
    player = kwargs.get('player')

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


@have_player
def get_chapter_info(dynamic_id, chapter_id, **kwargs):
    """取得章节奖励信息
    """
    player = kwargs.get('player')

    response = []

    if chapter_id:
        chapter_obj = player.stage_component.get_chapter(chapter_id)
        response.append(chapter_obj)
    else:
        chapters_obj = player.stage_component.get_chapters()
        response.extend(chapters_obj)

    return response


@have_player
def fight_start(dynamic_id, stage_id, line_up, unparalleled, fid, **kwargs):
    """开始战斗
    """
    player = kwargs.get('player')
    result_no = 0

    # 校验关卡是否开启
    state = player.stage_component.check_stage_state(stage_id)
    if state == -2:
        return {'result': False, 'result_no': 803}  # 803 未开启

    conf = 0
    if game_configs.special_stage_config.get('elite_stages').get(stage_id):  # 精英关卡
        conf = game_configs.special_stage_config.get('elite_stages').get(stage_id)

        #次数限制
        if time.localtime(player.stage_component.elite_stage_info[1]).tm_mday == time.localtime().tm_mday \
                and game_configs.vip_config.get(player.vip_component.vip_level).eliteCopyTimes - player.stage_component.elite_stage_info[0] < conf.timesExpend:
            return {'result': False, 'result_no': 805}  # 805 次数不足

    elif game_configs.special_stage_config.get('act_stages').get(stage_id):  # 活动关卡
        conf = game_configs.special_stage_config.get('act_stages').get(stage_id)

        #次数限制
        if time.localtime(player.stage_component.act_stage_info[1]).tm_mday == time.localtime().tm_mday \
                and game_configs.vip_config.get(player.vip_component.vip_level).activityCopyTimes - player.stage_component.act_stage_info[0] < conf.timesExpend:
            return {'result': False, 'result_no': 805}  # 805 次数不足

    else:  # 普通关卡
        if time.localtime(player.stage_component.stage_up_time).tm_mday == time.localtime().tm_mday:
            if player.stage_component.get_stage(stage_id).attacks >= game_configs.stage_config.get('stages').\
                    get(stage_id).limitTimes:
                return {'result': False, 'result_no': 810}  # 810 本关卡攻击次数不足
        else:
            player.stage_component.stage_up_time = int(time.time())
            player.stage_component.update_stage_times()
            player.stage_component.update()

    if conf:
        #星期限制
        if conf.weeklyControl:
            if conf.weeklyControl[time.localtime().tm_wday]:
                return {'result': False, 'result_no': 804}  # 804 不在活动时间内

        #时间限制
        open_time = time.mktime(time.strptime(conf.open_time, '%Y-%m-%d %H:%M'))
        close_time = time.mktime(time.strptime(conf.close_time, '%Y-%m-%d %H:%M'))
        if not open_time <= time.time() <= close_time:
            return {'result': False, 'result_no': 804}  # 804 不在活动时间内

    # 保存阵容
    player.line_up_component.line_up_order = line_up
    player.line_up_component.save_data()

    fight_cache_component = player.fight_cache_component
    fight_cache_component.stage_id = stage_id

    red_units, blue_units, drop_num, monster_unpara,replace_units, replace_no = fight_cache_component.fighting_start()

    # 好友
    lord_data = tb_character_lord.getObjData(fid)
    f_unit = None
    if lord_data:
        info = lord_data.get('attr_info').get('info')
        f_unit = BattleUnit.loads(info)
    else:
        logger.info('can not find friend id :%d' % fid)

    return {'result': True, 'red_units': red_units, 'blue_units': blue_units, 'drop_num': drop_num,
            'monster_unpara': monster_unpara, 'f_unit': f_unit, 'result_no': result_no,
            'replace_unit': replace_units, 'replace_no': replace_no}


@have_player
def fight_settlement(dynamic_id, stage_id, result, **kwargs):
    player = kwargs.get('player')

    response = stage_response_pb2.StageSettlementResponse()
    drops = response.drops
    res = response.res
    res.result = True

    # 校验是否保存关卡
    fight_cache_component = player.fight_cache_component
    if stage_id != fight_cache_component.stage_id:
        res.result = False
        res.message = u"关卡id和战斗缓存id不同"
        return response.SerializeToString()

    settlement_drops = fight_cache_component.fighting_settlement(result)
    data = gain(player, settlement_drops)
    get_return(player, data, drops)

    if result:
        if game_configs.stage_config.get('stages').get(stage_id):  # 关卡
            conf = game_configs.stage_config.get('stages').get(stage_id)
            player.stamina.stamina -= conf.vigor
            player.stamina.save_data()
        else:
            if game_configs.special_stage_config.get('elite_stages').get(stage_id):  # 精英关卡
                conf = game_configs.special_stage_config.get('elite_stages').get(stage_id)
                if time.localtime(player.stage_component.elite_stage_info[1]).tm_mday == time.localtime().tm_mday:
                    player.stage_component.elite_stage_info[0] += conf.timesExpend
                else:
                    player.stage_component.elite_stage_info = [conf.timesExpend, int(time.time())]
            elif game_configs.special_stage_config.get('act_stages').get(stage_id):  # 活动关卡
                conf = game_configs.special_stage_config.get('act_stages').get(stage_id)
                if time.localtime(player.stage_component.act_stage_info[1]).tm_mday == time.localtime().tm_mday:
                    player.stage_component.act_stage_info[0] += conf.timesExpend
                else:
                    player.stage_component.act_stage_info = [conf.timesExpend, int(time.time())]
            player.stage_component.update()

    # 经验
    for (slot_no, lineUpSlotComponent) in player.line_up_component.line_up_slots.items():
        print lineUpSlotComponent,
        hero = lineUpSlotComponent.hero_slot.hero_obj
        if hero:
            hero.upgrade(conf.HeroExp)
    # 玩家金钱
    player.finance.coin += conf.currency
    # 玩家经验
    player.level.addexp(conf.playerExp)
    player.save_data()

    res.message = u'成功返回'
    return response.SerializePartialToString()


@have_player
def get_warriors(dynamic_id, **kwargs):
    player = kwargs.get('player')
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


@have_player
def stage_sweep(dynamic_id, stage_id, times, **kwargs):
    response = stage_response_pb2.StageSweepResponse()
    drops = response.drops
    res = response.res

    player = kwargs.get('player')
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
