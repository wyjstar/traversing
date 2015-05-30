# coding: utf-8
'''
Created on 2015-4-28

@author: hack
'''
from app.proto_file.rebate_pb2 import rebateInfo
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import db_pb2
import time
from app.game.action.root import netforwarding
from app.game.core.mail_helper import send_mail
remote_gate = GlobalObject().remote.get('gate')


def notify_mail(player):
    """
    通知可以购买返利卡了
    """
    plat = 'ios'
    if player.base_info.plat_id == 1:
        plat = 'android'
    all_rebates = player.rebate.all_rebates()
    for rid in all_rebates:
        recharge_item = game_configs.recharge_config[plat].get(rid)
        if not recharge_item:
            continue
        
        if player.rebate.need_mail(rid, recharge_item.get('giftDays')):
            if recharge_item.get('giftDays') == 30:
                mail_id = game_configs.base_config.get('moonCardRemindMail')
                send_mail(conf_id=mail_id, receive_id=player.base_info.id)
                player.rebate.send_mail(rid)
            else:
                mail_id = game_configs.base_config.get('weekCardRemindMail')
                send_mail(conf_id=mail_id, receive_id=player.base_info.id)
            player.rebate.save_data()

def rebate_info(player):
    """
    获取返利卡状态
    """
    
    notify_mail(player)
    response = rebateInfo()
    plat = 'ios'
    if player.base_info.plat_id == 1:
        plat = 'android'

    for rid in game_configs.recharge_config[plat].keys():
        if game_configs.recharge_config[plat][rid].get('type') == 2:
            switch, last, can_draw = player.rebate.rebate_status(game_configs.recharge_config[plat][rid].id, game_configs.recharge_config[plat][rid].get('giftDays'))
            rebate = response.rebates.add()
            print 'rebate.rid', type(rebate.rid), game_configs.recharge_config[plat][rid].id
            rebate.rid = game_configs.recharge_config[plat][rid].id
            rebate.switch = switch
            rebate.last = last
            rebate.draw = can_draw
    return response

def rebate_call(player, recharge_item):
    """
    购买返利卡
    """
    rid = recharge_item.get('id')
    days = recharge_item.get('giftDays')
    switch, _, _ = player.rebate.rebate_status(rid, days)
    if switch:
        rebate = player.rebate.rebate_info(rid)
        rebate.new_rebate(days)
        player.rebate.set_rebate(rid, rebate)
        if days == 30:
            player.rebate.month_start(recharge_item.get('mailForEver'))
        mail_id, times = player.rebate.month_mails()
        for _ in range(times):
            send_mail(conf_id=mail_id, receive_id=player._owner.base_info.id)
        player.rebate.save_data()

        notify = rebate_info(player)
        remote_gate.push_object_remote(5432,
                                           notify.SerializePartialToString(),
                                           [player.dynamic_id])
