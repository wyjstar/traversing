# -*- coding:utf-8 -*-
"""
created by server on 14-7-18下午3:44.
"""
from app.game.logic.common.check import have_player
from app.game.logic.item_group_helper import gain, get_return
from app.proto_file import stage_response_pb2

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
def fight_start(dynamic_id, stage_id, **kwargs):
    """开始战斗
    """
    player = kwargs.get('player')

    fight_cache_component = player.fight_cache_component
    fight_cache_component.stage_id = stage_id
    red_units, blue_units, drop_num = fight_cache_component.fighting_start()
    return red_units, blue_units, drop_num


@have_player
def fight_settlement(dynamic_id, stage_id, result, **kwargs):
    player = kwargs.get('player')

    response = stage_response_pb2.StageSettlementResponse()
    drops = response.drops
    drops.res.result = True

    # 校验是否保存关卡
    fight_cache_component = player.fight_cache_component
    if stage_id != fight_cache_component.stage_id:
        drops.res.result = True
        return response.SerializePartialToString()

    player.stage_component.settlement(stage_id, result)

    drops = fight_cache_component.fighting_settlement(stage_id, result)
    data = gain(player, drops)
    get_return(player, data, drops)
    return response.SerializePartialToString()








