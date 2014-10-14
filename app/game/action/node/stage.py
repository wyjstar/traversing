# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:21.
"""
from app.game.logic.stage import get_chapter_info, stage_sweep
from app.game.logic.stage import get_stage_info
from app.game.logic.stage import fight_start
from app.game.logic.stage import fight_settlement
from app.game.logic.stage import get_warriors
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file import stage_request_pb2
from app.proto_file import stage_response_pb2
from gfirefly.server.logobj import logger


@remote_service_handle
def get_stages_901(dynamic_id, pro_data):
    """取得关卡信息
    """
    request = stage_request_pb2.StageInfoRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id

    stages_obj = get_stage_info(dynamic_id, stage_id)

    response = stage_response_pb2.StageInfoResponse()
    for stage_obj in stages_obj:
        add = response.stage.add()
        add.stage_id = stage_obj.stage_id
        add.attacks = stage_obj.attacks
        add.state = stage_obj.state

    return response.SerializePartialToString()


@remote_service_handle
def get_chapter_902(dynamic_id, pro_data):
    """取得章节奖励信息
    """
    request = stage_request_pb2.ChapterInfoRequest()
    request.ParseFromString(pro_data)
    chapter_id = request.chapter_id

    chapters_id = get_chapter_info(dynamic_id, chapter_id)

    response = stage_response_pb2.ChapterInfoResponse()
    for chapter_obj in chapters_id:
        stage_award_add = response.stage_award.add()
        stage_award_add.chapter_id = chapter_obj.chapter_id

        for award in chapter_obj.award_info:
            stage_award_add.award.append(award)

        stage_award_add.dragon_gift = chapter_obj.dragon_gift

    return response.SerializePartialToString()


@remote_service_handle
def stage_start_903(dynamic_id, pro_data):
    """开始战斗
    """
    request = stage_request_pb2.StageStartRequest()
    request.ParseFromString(pro_data)

    stage_id = request.stage_id  # 关卡编号
    unparalleled = request.unparalleled  # 无双编号
    fid = request.fid  # 好友ID

    line_up = {}  # {hero_id:pos}
    for line in request.lineup:
        if not line.hero_id:
            continue
        line_up[line.hero_id] = line.pos

    stage_info = fight_start(dynamic_id, stage_id, line_up, unparalleled, fid)
    result = stage_info.get('result')

    response = stage_response_pb2.StageStartResponse()

    res = response.res
    res.result = result
    if stage_info.get('result_no'):
        res.result_no = stage_info.get('result_no')

    if not result:
        logger.info('进入关卡返回数据:', response)
        return response.SerializePartialToString(), stage_id

    red_units = stage_info.get('red_units')
    blue_units = stage_info.get('blue_units')
    drop_num = stage_info.get('drop_num')
    monster_unpara = stage_info.get('monster_unpara')
    f_unit = stage_info.get('f_unit')
    replace_unit = stage_info.get('replace_unit')
    response.replace_index = stage_info.get('replace_index')

    response.drop_num = drop_num
    for red_unit in red_units:
        if not red_unit:
            continue
        red_add = response.red.add()
        assemble(red_add, red_unit)
    for blue_group in blue_units:
        blue_group_add = response.blue.add()
        for blue_unit in blue_group:
            if not blue_unit:
                continue
            blue_add = blue_group_add.group.add()
            assemble(blue_add, blue_unit)

    unpara = response.monster_unpara
    if monster_unpara:
        unpara.id = monster_unpara[0]
        buffs = unpara.buffs
        for buff in monster_unpara[1:]:
            buffs.append(buff)
    if f_unit:
        friend = response.friend
        assemble(friend, f_unit)
    if replace_unit:
        assemble(response.replace, replace_unit)
    logger.info('进入关卡返回数据:', response)
    return response.SerializePartialToString()


@remote_service_handle
def fight_settlement_904(dynamic_id, pro_data):
    request = stage_request_pb2.StageSettlementRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id
    result = request.result
    drops = fight_settlement(dynamic_id, stage_id, result)

    return drops


@remote_service_handle
def get_warriors_906(dynamic_id, pro_data):
    """请求无双
    """
    return get_warriors(dynamic_id)


@remote_service_handle
def stage_sweep_907(dynamic_id, pro_data):
    request = stage_request_pb2.StageSweepRequest()
    request.ParseFromString(pro_data)
    stage_id = request.stage_id
    times = request.times
    drops = stage_sweep(dynamic_id, stage_id, times)

    return drops


def assemble(unit_add, unit):
    unit_add.no = unit.no
    unit_add.quality = unit.quality

    normal_skill = unit_add.normal_skill
    if unit.normal_skill:
        normal_skill.id = unit.normal_skill[0]
        buffs = normal_skill.buffs
        for buff in unit.normal_skill[1:]:
            buffs.append(buff)

    rage_skill = unit_add.rage_skill
    if unit.rage_skill:
        rage_skill.id = unit.rage_skill[0]
        buffs = rage_skill.buffs
        for buff in unit.rage_skill[1:]:
            buffs.append(buff)

    if unit.break_skills:
        for break_skill in unit.break_skills:
            if break_skill:
                break_skill_add = unit_add.break_skill.add()
                break_skill_add.id = break_skill[0]
                buffs = break_skill_add.buffs
                for buff in break_skill[1:]:
                    buffs.append(buff)

    unit_add.hp = unit.hp
    unit_add.atk = unit.atk
    unit_add.physical_def = unit.physical_def
    unit_add.magic_def = unit.magic_def
    unit_add.hit = unit.hit
    unit_add.dodge = unit.dodge
    unit_add.cri = unit.cri
    unit_add.cri_coeff = unit.cri_coeff
    unit_add.cri_ded_coeff = unit.cri_ded_coeff
    unit_add.block = unit.block

    unit_add.base_hp = unit.base_hp
    unit_add.base_atk = unit.base_atk
    unit_add.base_physical_def = unit.base_physical_def
    unit_add.base_magic_def = unit.base_magic_def
    unit_add.base_hit = unit.base_hit
    unit_add.base_dodge = unit.base_dodge
    unit_add.base_cri = unit.base_cri
    unit_add.base_cri_coeff = unit.base_cri_coeff
    unit_add.base_cri_ded_coeff = unit.base_cri_ded_coeff
    unit_add.base_block = unit.base_block

    unit_add.level = unit.level
    unit_add.break_level = unit.break_level

    unit_add.position = unit.position
    unit_add.is_boss = unit.is_boss
