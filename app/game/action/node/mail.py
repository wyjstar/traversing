# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:16.
"""
from app.game.logic.mail import get_mails, read_mail, delete_mail, \
    receive_mail, send_mail
from app.proto_file.mailbox_pb2 import GetMailInfos, \
    ReadMailRequest, DeleteMailRequest, SendMailRequest
from app.proto_file.common_pb2 import CommonResponse
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger


@remoteserviceHandle('gate')
def get_all_mail_info_1301(dynamic_id, proto_data):
    """获取所有邮件"""
    return get_mails(dynamic_id)


@remoteserviceHandle('gate')
def read_mail_1302(dynamic_id, proto_data):
    """读邮件，更改邮件状态"""
    request = ReadMailRequest()
    request.ParseFromString(proto_data)
    return read_mail(dynamic_id, request.mail_ids, request.mail_type)


@remoteserviceHandle('gate')
def delete_mail_1303(dynamic_id, proto_data):
    """删除邮件"""
    request = DeleteMailRequest()
    return delete_mail(dynamic_id, request.mail_ids)


@remoteserviceHandle('gate')
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
    response = CommonResponse()
    response.result = send_mail(dynamic_id, mail)
    logger.debug('send_mail_1304 %s', response.result)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def receive_mail_1305(dynamic_id, online, mail):
    """接收邮件"""
    receive_mail(dynamic_id, online, mail)


@remoteserviceHandle('gate')
def receive_mail_from_client_1306(dynamic_id, receive_id, mail):
    """接收邮件"""
    return receive_mail_from_client_1306(dynamic_id, mail)







