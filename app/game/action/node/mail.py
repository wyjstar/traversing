# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:16.
"""
from app.proto_file.mailbox_pb2 import GetMailInfos, \
    ReadMailRequest, DeleteMailRequest, SendMailRequest
from app.proto_file.common_pb2 import CommonResponse
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from app.proto_file.mailbox_pb2 import ReadMailResponse, ReceiveMailResponse
from app.game.core.item_group_helper import gain, get_return
from app.game.action.root import netforwarding
import time
from shared.db_opear.configs_data import data_helper


@remoteserviceHandle('gate')
def get_all_mail_info_1301(proto_data, player):
    """获取所有邮件"""
    mails = player.mail_component.get_mails()

    response = GetMailInfos()

    expire_ids = []
    for mail in mails:
        if is_expire_notice(mail):
            expire_ids.append(mail.mail_id)
            continue
        mail_pb = response.mails.add()
        mail.update(mail_pb)

    # 删除过期公告
    player.mail_component.delete_mails(expire_ids)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def read_mail_1302(proto_data, player):
    """读邮件，更改邮件状态"""
    request = ReadMailRequest()
    request.ParseFromString(proto_data)
    return read_mail(request.mail_ids, request.mail_type, player)


@remoteserviceHandle('gate')
def delete_mail_1303(proto_data, player):
    """删除邮件"""
    request = DeleteMailRequest()
    mail_ids = request.mail_ids
    player.mail_component.delete_mails(mail_ids)
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def send_mail_1304(proto_data, player):
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
    """发送邮件， mail为json类型"""
    mail['send_time'] = int(time.time())
    receive_id = mail['receive_id']
    # command:id 为收邮件的命令ID
    response.result = netforwarding.push_message('receive_mail_remote', receive_id, mail)
    logger.debug('send_mail_1304 %s', response.result)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def receive_mail_remote(mail, is_online, player):
    """接收邮件"""
    mail_type = mail.get("mail_type")
    sender_id = mail.get("sender_id")
    sender_name = mail.get("sender_name")
    sender_icon = mail.get("sender_icon")
    title = mail.get("title")
    content = mail.get("content")
    send_time = mail.get("send_time")
    prize = mail.get("prize")
    mail = player.mail_component.add_mail(sender_id, sender_name, title,
                                          content, mail_type, send_time, prize, 
                                          sender_icon=sender_icon)

    if is_online:
        response = ReceiveMailResponse()
        mail.update(response.mail)
        netforwarding.push_object(1305,
                                  response.SerializePartialToString(),
                                  [player.dynamic_id])
    return True


@remoteserviceHandle('gate')
def receive_mail_from_client_1306(receive_id, proto_data, player):
    """在线/登录时，接收邮件"""
    mail_type = proto_data.get("mail_type")
    sender_id = proto_data.get("sender_id")
    sender_name = proto_data.get("sender_name")
    title = proto_data.get("title")
    content = proto_data.get("content")
    send_time = proto_data.get("send_time")
    bag = proto_data.get("bag")

    player.mail_component.add_mail(sender_id, sender_name, title,
                                   content, mail_type, send_time, bag)


def is_expire_notice(mail):
    """判断公告是否过期"""
    if mail.read_time and time.time() - mail.read_time > 7 * 24 * 60 * 60:
        return True
    return False


def read_mail(mail_ids, mail_type, player):
    """读取邮件"""
    response = ReadMailResponse()
    if mail_type == 1:
        # 领取赠送体力
        result = check_gives(mail_ids, player)
        if not result.get('result'):
            response.res.result = False
            response.res.result_no = result.get('result_no')
            return response.SerializePartialToString()
#         for mail_id in mail_ids:
#             # 发送反馈体力
#             mail = player.mail_component.get_mail(mail_id)
#             mail_return = {'sender_id': player.base_info.id,
#                            'sender_name': player.base_info.base_name,
#                            'receive_id': mail.sender_id,
#                            'receive_name': mail.sender_name,
#                            'title': mail.title,
#                            'content': mail.content,
#                            'mail_type': mail_type,
#                            'send_time': int(time.time()),
#                            'prize': 0}
#             netforwarding.push_message('receive_mail_remote', mail.sender_id, mail_return)
        player.stamina.add_stamina(len(mail_ids)*2)
        player.stamina.save_data()
        player.mail_component.delete_mails(mail_ids)

    elif mail_type == 2:
        # 领取奖励
        get_prize(player, mail_ids, response)
        player.mail_component.delete_mails(mail_ids)

    elif mail_type == 3 or mail_type == 4:
        # 公告
        for mail_id in mail_ids:
            mail = player.mail_component.get_mail(mail_id)
            mail.is_readed = True
            mail.read_time = int(time.time())

    response.res.result = True
    return response.SerializePartialToString()


def check_gives(mail_ids, player):
    if len(mail_ids) + player.stamina.get_stamina_times > 15:
        # 一天领取邮件不超过15个
        return {'result': False, 'result_no': 1302}

    return {'result': True}


def get_prize(player, mail_ids, response):
    """领取奖励"""
    for mail_id in mail_ids:
        mail = player.mail_component.get_mail(mail_id)

        prize = data_helper.parse(mail.prize)
        return_data = gain(player, prize)
        get_return(player, return_data, response.gain)
