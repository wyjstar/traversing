# -*- coding:utf-8 -*-
"""
created by server on 14-8-14下午3:16.
"""
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.item_group_helper import gain, get_return
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data import data_helper
from app.proto_file.common_pb2 import CommonResponse
from app.game.action.root import netforwarding
from gfirefly.server.logobj import logger
from app.proto_file import mailbox_pb2
from app.proto_file.db_pb2 import Mail_PB
from shared.utils.const import const
import time
from app.game.core.mail_helper import send_mail
from app.game.core.task import hook_task, CONDITIONId


remote_gate = GlobalObject().remote.get('gate')


def notify_mail(player):
    """
    通知可以购买返利卡了
    """
    plat = 'ios'
    if player.base_info.plat_id == 1:
        plat = 'android'
    recharge_items = {}
    all_rebates = player.rebate.all_rebates()
    for item in game_configs.recharge_config[plat].values():
        recharge_items[item.id] = item
    for rid in all_rebates:
        recharge_item = recharge_items.get(rid)
        if not recharge_item:
            continue
        if player.rebate.need_mail(rid, recharge_item.get('giftDays')):
            if recharge_item.get('giftDays') == 30:
                mail_id = game_configs.base_config.get('moonCardRemindMail')
                send_mail(conf_id=mail_id, receive_id=player.base_info.id)
            else:
                mail_id = game_configs.base_config.get('weekCardRemindMail')
                send_mail(conf_id=mail_id, receive_id=player.base_info.id)
            player.rebate.send_mail(rid)
            player.rebate.save_data()


def month_reward(player):
    """
    发放月卡永久奖励
    """
    mail_id, times = player.rebate.month_mails()
    for _ in range(times):
        send_mail(conf_id=mail_id, receive_id=player.base_info.id)
    player.rebate.save_data()


@remoteserviceHandle('gate')
def get_all_mail_info_1301(proto_data, player):
    """获取所有邮件"""
    mails = player.mail_component.get_mails()

    response = mailbox_pb2.GetMailInfos()
    month_reward(player)
    notify_mail(player)
    expire_ids = []
    for mail in mails:
        if is_expire_notice(mail):
            expire_ids.append(mail.mail_id)
            continue
        mail_pb = response.mails.add()
        mail_pb.CopyFrom(mail)
    response.target = game_configs.base_config['times_get_vigor_from_friend']
    response.current = player.stamina.get_stamina_times
    # 删除过期公告
    player.mail_component.delete_mails(expire_ids)
    print response, '====================mails'
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def read_mail_1302(proto_data, player):
    """读邮件，更改邮件状态"""
    request = mailbox_pb2.ReadMailRequest()
    request.ParseFromString(proto_data)
    result = read_mail(request.mail_ids, request.mail_type, player)
    return result


@remoteserviceHandle('gate')
def delete_mail_1303(proto_data, player):
    """删除邮件"""
    request = mailbox_pb2.DeleteMailRequest()
    request.ParseFromString(proto_data)
    mail_ids = request.mail_ids
    player.mail_component.delete_mails(mail_ids)
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def receive_mail_remote(mail_data, is_online, player):
    """接收邮件"""
    mail = Mail_PB()
    mail.ParseFromString(mail_data)
    logger.debug('receive_mail:%s', mail)
    if mail.mail_type == 1:
        if mail.sender_id in player.stamina.contributors:
            logger.error('this contributor has already given stamina:%s',
                         mail.sender_id)
            return True
        else:
            player.stamina.contributors.append(mail.sender_id)
    if mail.config_id == game_configs.base_config.get('guildInviteMail'):
        mails = player.mail_component.get_mails()
        for mail_pb in mails:
            if mail.guild_id and mail_pb.guild_id == mail.guild_id:
                return True

    player.mail_component.add_mail(mail)
    player.mail_component.save_data()

    if is_online:
        response = mailbox_pb2.ReceiveMailResponse()
        response.mail.CopyFrom(mail)
        remote_gate.push_object_remote(1305,
                                       response.SerializePartialToString(),
                                       [player.dynamic_id])
    return True


def is_expire_notice(mail):
    """判断公告是否过期"""
    if mail.mail_type == 2:
        if 100 * 24 * 60 * 60 + mail.send_time <= time.time():
            return True
    else:
        if mail.config_id:
            mail_conf = game_configs.mail_config.get(mail.config_id)
            if mail_conf.days != -1 and \
                    mail_conf.days*24*60*60 + mail.send_time <= time.time():
                return True
        else:
            if mail.effec * 24 * 60 * 60 + mail.send_time <= time.time():
                return True

    return False


def read_mail(mail_idss, mail_type, player):
    """读取邮件"""
    response = mailbox_pb2.ReadMailResponse()
    mail_ids = []
    for mail_id in mail_idss:
        mail = player.mail_component.get_mail(mail_id)
        if mail:
            mail_ids.append(mail_id)
            mail.is_readed = True
            player.mail_component.save_mail(mail_id)
    if mail_type == 1:
        # 领取赠送体力
        result = check_gives(mail_ids, player)
        if not result.get('result'):
            response.res.result = False
            response.res.result_no = result.get('result_no')
            return response.SerializePartialToString()

        # player.stamina.add_stamina(len(mail_ids)*2)
        get_prize(player, mail_ids, response)
        last_times = player.stamina.get_stamina_times
        player.stamina.get_stamina_times = last_times + len(mail_ids)
        player.stamina.save_data()
        player.mail_component.delete_mails(mail_ids)
        response.target = game_configs.base_config['times_get_vigor_from_friend']
        response.current = player.stamina.get_stamina_times
        response.mail_type = mail_type
        hook_task(player, CONDITIONId.RECEIVE_STAMINA, 1)

    response.res.result = True
    return response.SerializePartialToString()


def check_gives(mail_ids, player):
    if len(mail_ids) + player.stamina.get_stamina_times > game_configs.base_config['times_get_vigor_from_friend']:
        # 一天领取邮件不超过15个
        return {'result': False, 'result_no': 1302}

    return {'result': True}


def get_prize(player, mail_ids, response):
    """领取奖励"""
    for mail_id in mail_ids:
        mail = player.mail_component.get_mail(mail_id)
        if not mail:
            continue

        if mail.prize:
            if isinstance(eval(mail.prize), dict):
                prize = data_helper.parse(eval(mail.prize))
                return_data = gain(player, prize, const.MAIL)
                get_return(player, return_data, response.gain)
            elif isinstance(eval(mail.prize), list):
                for prize_data in eval(mail.prize):
                    prize = data_helper.parse(prize_data)
                    return_data = gain(player, prize, const.MAIL)
                    get_return(player, return_data, response.gain)
            continue
        if mail.config_id:
            # if mail.config_id != game_configs.base_config.get('warFogRobbedMail'):
                # 除了附文矿被抢
            mail_conf = game_configs.mail_config.get(mail.config_id)
            prize = data_helper.parse(mail_conf.rewards)
            return_data = gain(player, prize, const.MAIL)
            get_return(player, return_data, response.gain)


@remoteserviceHandle('gate')
def get_prize_1306(proto_data, player):
    """获取奖励"""
    request = mailbox_pb2.GetPrizeRequest()
    request.ParseFromString(proto_data)
    mail_id = request.mail_id
    response = mailbox_pb2.GetPrizeResponse()
    # 标记已经领取
    mail = player.mail_component.get_mail(mail_id)
    if mail.is_got_prize:
        response.res.result = False
        response.res.result_no = 863
        return response.SerializePartialToString()

    num = 0
    if mail.prize and isinstance(eval(mail.prize), list):
        for xx in eval(mail.prize):
            for x in xx.items():
                if int(x[0]) == 108:
                    num += int(x[1][1])

    if player.runt.bag_is_full(num):
        response.res.result = False
        response.res.result_no = 824
        return response.SerializePartialToString()

    mail.is_got_prize = True
    mail.is_readed = True
    player.mail_component.save_mail(mail_id)

    get_prize(player, [mail_id], response)
    response.res.result = True
    return response.SerializePartialToString()
