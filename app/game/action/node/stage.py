# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:21.
"""
from app.game.logic.stage import get_stage_info, get_chapter_info
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file import stage_pb2


@remote_service_handle
def get_stages_901(dynamic_id, pro_data):
    """取得关卡信息
    """
    request = stage_pb2.StageInfoRequest()
    stage_id = request.stage_id

    stages_obj = get_stage_info(dynamic_id, stage_id)

    response = stage_pb2.StageInfoResponse()
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
    request = stage_pb2.ChapterInfoRequest()
    chapter_id = request.chapter_id

    chapters_id = get_chapter_info(dynamic_id, chapter_id)

    response = stage_pb2.ChapterInfoResponse()
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
    request = stage_pb2.StageStartRequest()
    stage_id = request.stage_id




