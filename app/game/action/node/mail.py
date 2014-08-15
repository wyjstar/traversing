# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:16.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.mail import get_mails, read_mail, delete_mail
from app.proto_file.mailbox_pb2 import GetMailInfos, \
    ReadMailRequest, DeleteMailRequest


@remote_service_handle
def get_all_mail_info_1301(dynamic_id, proto_data):
    """获取所有邮件"""
    return get_mails()


@remote_service_handle
def read_mail_1302(dynamic_id, proto_data):
    """读邮件，更改邮件状态"""
    request = ReadMailRequest()
    read_mail(dynamic_id, request.mail_ids, request.mail_type)


@remote_service_handle
def delete_mail_1303(dynamic_id, proto_data):
    """删除邮件"""
    request = DeleteMailRequest()
    delete_mail(dynamic_id, request.mail_ids)


@remote_service_handle
def get_give_1304(dynamic_id, proto_data):
    """获取赠送的体力， 并进行反馈操作"""
    pass


@remote_service_handle
def get_prize_1305(dynamic_id, proto_data):
    """获取系统奖励"""
    pass


@remote_service_handle
def send_mail_1306(dynamic_id, proto_data):
    """发送邮件"""
    pass


@remote_service_handle
def receive_mail_1307(dynamic_id, proto_data):
    """接受邮件"""
    pass






