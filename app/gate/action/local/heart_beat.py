# -*- coding:utf-8 -*-
"""
created by server on 14-8-11下午5:11.
"""

from app.gate.service.local.gateservice import local_service_handle


@local_service_handle
def heart_beat_88(command_id, dynamic_id, request_proto):
    """心跳函数，用来测试连接"""
    return "88"