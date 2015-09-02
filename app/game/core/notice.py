# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:28.
"""
from app.proto_file.notice_pb2 import NoticeResponse
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger

remote_gate = GlobalObject().remote.get('gate')

def push_notice(notice_id, player_name="", hero_no=0, hero_break_level=0, equipment_no=0):
    try:
        response = NoticeResponse()
        response.notice_id = notice_id
        response.player_name = player_name
        response.hero_no = hero_no
        response.hero_break_level = hero_break_level
        response.equipment_no = equipment_no
        remote_gate.push_notice_remote(2000, response.SerializePartialToString())
    except Exception, e:
        logger.error("push_notice: %s" % e.message)
