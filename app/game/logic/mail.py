# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午6:32.
"""
from app.proto_file.mailbox_pb2 import GetMailInfos, ReadMailRequest, ReadMailResponse
from app.proto_file.common_pb2 import CommonResponse
from app.game.logic.common.check import have_player
from app.game.logic.item_group_helper import gain, get_return


@have_player
def get_mails(dynamic_id, **kwargs):
    """获取所有邮件"""
    player = kwargs.get('player')
    mails = player.mail_component.get_mails()

    response = GetMailInfos()

    for mail in mails:
        mail_pb = response.mails.add()
        mail.update(mail_pb)

    return response.SerializePartialToString()


@have_player
def read_mail(dynamic_id, mail_ids, mail_type, **kwargs):
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
        player.mail_component.get_gives(mail_ids)

    elif mail_type == 2:
    # 领取奖励
        get_prize(player, mail_ids, response)

    elif mail_type == 3:
    # 公告
        pass

    elif mail_type == 4:
    # 消息
        pass

    response.res.result = True
    return response.SerializePartialToString()


def check_gives(mail_ids, player):
    if len(mail_ids) + player.get_give_stamina_times > 15:
        # 一天领取邮件不超过15个
        return {'result': False, 'result_no': 1302}


def get_prize(player, mail_ids, response):
    """领取奖励"""
    for mail_id in mail_ids:
        mail = player.mail_component.get_mail(mail_id)
        return_data = gain(player, mail.bag)
        get_return(player, return_data, response.gain)


@have_player
def delete_mail(dynamic_id, mail_ids, **kwargs):
    """删除邮件"""
    player = kwargs.get('player')

    player.mail_component.delete_mails(mail_ids)
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()




