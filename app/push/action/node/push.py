# -*- coding:utf-8 -*-
"""
created by server on 14-5-20下午12:11.
"""
from app.push.service.node.pushgateservice import nodeservice_handle
from app.proto_file import push_pb2
from app.push.core.pusher import Pusher

@nodeservice_handle
def register_push_message(uid, device_token):
    """
    消息推送注册
    @param device_token: 注册设备ID
    """
    Pusher().register(uid, device_token)
    return True

@nodeservice_handle
def set_push_switch(uid, data):
    """
    设置推送消息开关
    @param msg_type: 消息类型
    @param oper: 0关闭，1打开
    """
    request = push_pb2.msgSwitchReq()
    request.ParseFromString(data)
    for msg in request.switch:
        Pusher().set_switch(uid, msg.msg_type, msg.switch)
        
    return True

@nodeservice_handle
def add_push_message(uid, msg_type, message, send_time):
    """
    添加发送推送消息的任务
    @param msg_type: 消息类型
    @param message: 发送消息
    @param send_time: 发送时间
    """
    Pusher().add_message(uid, msg_type, message, send_time)
    return True

# @nodeservice_handle
# def del_push_message(dynamic_id, msg_type):
#     """
#     删除推送消息
#     @param msg_type: 消息类型
#     """
#     pass

@nodeservice_handle
def online_offline(uid, on_or_off):
    """
    在线离线通知
    @param on_or_off: 0离线，1在线
    """
    Pusher().on_offf(uid, on_or_off)
    return True