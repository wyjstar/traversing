# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:28.
"""
from app.gate.action.node.net import push_all_objects
from app.proto_file.notice_pb2 import NoticeResponse

def push_notice(notice_id, player_name="", hero_no=0, hero_break_level="", equipment_no=""):
    response = NoticeResponse()
    response.notice_id = notice_id
    response.player_name = player_name
    response.hero_no = hero_no
    response.hero_break_level = hero_break_level
    response.equipment_no = equipment_no
    push_all_objects(2000, response.SerializePartialToString())
