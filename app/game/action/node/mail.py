# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:16.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.mail import get_mails, read_mail, delete_mail, \
    receive_mail, send_mail
from app.proto_file.mailbox_pb2 import GetMailInfos, \
    ReadMailRequest, DeleteMailRequest, SendMailRequest
from app.proto_file.common_pb2 import CommonResponse


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
    mail = request.mail
    mail = {'sender_id': mail.sender_id,
            'sender_name': mail.sender_name,
            'receive_id': mail.receive_id,
            'receive_name': mail.receive_name,
            'title': mail.title,
            'content': mail.content,
            'mail_type': mail.mail_type,
            'send_time': mail.send_time,
            'prize': mail.prize}
    send_mail(dynamic_id, mail)
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()


@remote_service_handle
def receive_mail_1305(dynamic_id, proto_data):
    """接收邮件"""
    receive_mail(dynamic_id, proto_data)










