# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:16.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.mail import get_mails, read_mail, delete_mail, \
    receive_mail, send_mail
from app.proto_file.mailbox_pb2 import GetMailInfos, \
    ReadMailRequest, DeleteMailRequest, SendMailRequest


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
def send_mail_1304(dynamic_id, proto_data):
    """发送邮件"""
    request = SendMailRequest()
    request.ParseFromString(proto_data)
    mail = {'sender_id': request.sender_id,
            'sender_name': request.sender_name,
            'receive_id': request.receive_id,
            'receive_name': request.receive_name,
            'title': request.title,
            'content': request.content,
            'mail_type': request.mail_type,
            'send_time': request.send_time,
            'prize': request.prize}
    send_mail(dynamic_id, mail)


@remote_service_handle
def receive_mail_1305(dynamic_id, proto_data):
    """接收邮件"""
    receive_mail(dynamic_id, proto_data)










