# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午6:32.
"""
from app.proto_file.mailbox_pb2 import GetMailInfos, ReadMailRequest, ReadMailResponse, ReceiveMailResponse
from app.proto_file.common_pb2 import CommonResponse
from app.game.logic.common.check import have_player
from app.game.logic.item_group_helper import gain, get_return
from app.game.action.root import netforwarding
import time
from app.game.core.drop_bag import BigBag
from shared.db_opear.configs_data import data_helper


@have_player
def get_mails(player):
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


def is_expire_notice(mail):
    """判断公告是否过期"""
    if mail.read_time and time.time() - mail.read_time > 7 * 24 * 60 * 60:
        return True
    return False


@have_player
def read_mail(mail_ids, mail_type, **kwargs):
    """读取邮件"""
    player = kwargs.get('player')
    response = ReadMailResponse()
    if mail_type == 1:
        # 领取赠送体力
        result = check_gives(mail_ids, player)
        if not result.get('result'):
            response.res.result = False
            response.res.result_no = result.get('result_no')
            return response.SerializePartialToString()
        for mail_id in mail_ids:
            player.stamina += 2
            # 发送反馈体力
            mail = player.mail_component.get_mail(mail_id)
            mail_return = {'sender_id': player.base_info.id,
                           'sender_name': player.base_info.base_name,
                           'receive_id': mail.sender_id,
                           'receive_name': mail.sender_name,
                           'title': mail.title,
                           'content': mail.content,
                           'mail_type': mail_type,
                           'send_time': int(time.time()),
                           'prize': 0}
            netforwarding.push_message(1305, mail.sender_id, mail_return)
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
    if len(mail_ids) + player.get_stamina_times > 15:
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


@have_player
def delete_mail(mail_ids, player):
    """删除邮件"""
    player.mail_component.delete_mails(mail_ids)
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()


@have_player
def receive_mail(online, mail, player):
    """在线/登录时，接收邮件"""
    mail_type = mail.get("mail_type")
    sender_id = mail.get("sender_id")
    sender_name = mail.get("sender_name")
    title = mail.get("title")
    content = mail.get("content")
    send_time = mail.get("send_time")
    prize = mail.get("prize")

    mail = player.mail_component.add_mail(sender_id, sender_name, title,
                                   content, mail_type, send_time, prize)

    # print "online", online
    if not online:

        response = ReceiveMailResponse()
        mail.update(response.mail)
        netforwarding.push_object(1305, response.SerializePartialToString(), [player.dynamic_id])


@have_player
def send_mail(mail, player):
    """发送邮件， mail为json类型"""
    mail['send_time'] = int(time.time())
    receive_id = mail['receive_id']
    # command:id 为收邮件的命令ID
    return netforwarding.push_message(1305, receive_id, mail)


@have_player
def receive_mail_from_client_1306(proto_data, player):
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
