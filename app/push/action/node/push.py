# -*- coding:utf-8 -*-
"""
created by server on 14-5-20下午12:11.
"""
from app.proto_file import push_pb2
from app.push.core.pusher import pusher
from shared.db_opear.configs_data import game_configs

from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def register_push_message_remote(uid, device_token):
    """
    消息推送注册
    @param device_token: 注册设备ID
    """
    pusher.regist(uid, device_token)
    return True


@remoteserviceHandle('gate')
def set_push_switch_remote(uid, data):
    """
    设置推送消息开关
    @param msg_type: 消息类型
    @param oper: 0关闭，1打开
    """
    request = push_pb2.msgSwitchReq()
    request.ParseFromString(data)
    for msg in request.switch:
        pusher.set_switch(uid, msg.msg_type, msg.switch)
    return True


@remoteserviceHandle('gate')
def get_push_switch_remote(uid):
    switches = push_pb2.msgSwitchRes()
    user_switch = pusher.get_switch(uid)
    push_config = game_configs.push_config
    for push in push_config.values():
        if push.switch == 1:
            one_switch = switches.switch.add()
            one_switch.msg_type = push.event
            if push.event in user_switch:
                one_switch.switch = user_switch[push.event]
            else:
                one_switch.switch = 1
    return switches.SerializePartialToString()


@remoteserviceHandle('gate')
def add_push_message_remote(uid, msg_type, message, send_time):
    """
    添加发送推送消息的任务
    @param msg_type: 消息类型
    @param message: 发送消息
    @param send_time: 发送时间
    """
    pusher.add_message(uid, msg_type, message, send_time)
    return True

# def del_push_message(dynamic_id, msg_type):
#     """
#     删除推送消息
#     @param msg_type: 消息类型
#     """
#     pass


@remoteserviceHandle('gate')
def online_offline_remote(uid, on_or_off):
    """
    在线离线通知
    @param on_or_off: 0离线，1在线
    """
    pusher.on_offf(uid, on_or_off)
    return True
