# -*- coding:utf-8 -*-
"""
created by server on 14-7-18下午3:44.
"""
import time
from app.game.core.fight.battle_unit import BattleUnit
from app.game.logic.common.check import have_player
from app.game.logic.item_group_helper import gain, get_return
from app.game.redis_mode import tb_character_lord
from app.proto_file import stage_response_pb2
from gtwisted.utils import log
from shared.db_opear.configs_data import game_configs


@have_player
def get_stage_info(dynamic_id, stage_id, **kwargs):
    """取得关卡信息
    """
    player = kwargs.get('player')

    response = []
    if stage_id:  # 根据关卡ID
        stage_obj = player.stage_component.get_stage(stage_id)
        response.append(stage_obj)
    else:  # 全部
        stages_obj = player.stage_component.get_stages()
        response.extend(stages_obj)

    return response


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

    if game_configs.special_stage_config.get('elite_stages').get(stage_id):  # 精英关卡
        conf = game_configs.special_stage_config.get('elite_stages').get(stage_id)
        #星期限制
        if conf.weeklyControl[time.localtime().tm_wday]:
            return {'result': False, 'result_no': 804}  # 804 今日不开启
        #次数限制
        if time.localtime(player.stage_component.elite_stage_info[1]).tm_mday == time.localtime().tm_mday \
                and time.localtime(player.stage_component.elite_stage_info[0]).tm_mday >= \
                game_configs.vip_config.get(player.vip_component.vip_level).eliteCopyTimes:
            return {'result': False, 'result_no': 805}  # 805 次数已用完

    elif game_configs.special_stage_config.get('act_stages').get(stage_id):  # 活动关卡
        conf = game_configs.special_stage_config.get('act_stages').get(stage_id)
        #时间限制
        open_time = time.mktime(time.strptime(conf.open_time, '%Y-%m-%d %H:%M'))
        close_time = time.mktime(time.strptime(conf.close_time, '%Y-%m-%d %H:%M'))
        if open_time <= time.time() <= close_time:
            return {'result': False, 'result_no': 804}  # 806 不在活动时间内
        #次数限制
        if time.localtime(player.stage_component.act_stage_info[1]).tm_mday == time.localtime().tm_mday \
                and time.localtime(player.stage_component.act_stage_info[0]).tm_mday >= \
                game_configs.vip_config.get(player.vip_component.vip_level).activityCopyTimes:
            return {'result': False, 'result_no': 805}  # 805 次数已用完

    # 保存阵容
    player.line_up_component.line_up_order = line_up
    player.line_up_component.save_data()

    fight_cache_component = player.fight_cache_component
    fight_cache_component.stage_id = stage_id

    red_units, blue_units, drop_num, monster_unpara = fight_cache_component.fighting_start()

    # 好友
    lord_data = tb_character_lord.getObjData(fid)
    f_unit = None
    if lord_data:
        info = lord_data.get('info')
        f_unit = BattleUnit.loads(info)

    return {'result': True, 'red_units': red_units, 'blue_units': blue_units, 'drop_num': drop_num,
            'monster_unpara': monster_unpara, 'f_unit': f_unit, 'result_no': result_no}


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

    settlement_drops = fight_cache_component.fighting_settlement(stage_id, result)
    data = gain(player, settlement_drops)
    get_return(player, data, drops)

    if result:
        if game_configs.stage_config.get('stages').get(stage_id):  # 关卡
            player.stamina -= game_configs.stage_config.get('stages').get(stage_id).vigor
            player.save_data()
        else:
            if game_configs.special_stage_config.get('elite_stages').get(stage_id):  # 精英关卡
                if time.localtime(player.stage_component.elite_stage_info[1]).tm_mday == time.localtime().tm_mday:
                    player.stage_component.elite_stage_info[0] += 1
                else:
                    player.stage_component.elite_stage_info = [1, str(time.time())]
            elif game_configs.special_stage_config.get('act_stages').get(stage_id):  # 活动关卡
                if time.localtime(player.stage_component.act_stage_info[1]).tm_mday == time.localtime().tm_mday:
                    player.stage_component.act_stage_info[0] += 1
                else:
                    player.stage_component.act_stage_info = [1, str(time.time())]
            player.stage_component.update()

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
    log.msg('warriors: %s' % response)
    return response.SerializePartialToString()





