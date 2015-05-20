#coding: utf-8
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
remote_gate = GlobalObject().remote['gate']

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
        if player.rebate.need_mail(rid, game_configs.recharge_config[plat][rid].get('giftDays')):
            if recharge_item.get('giftDays') == 30:
                mail_id = game_configs.base_config.get('moonCardRemindMail')
                mail = db_pb2.Mail_PB()
                mail.config_id = mail_id
                mail.receive_id = player.base_info.id
                mail.send_time = int(time.time())
                mail.mail_type = 4
                mail_data = mail.SerializePartialToString()
                netforwarding.push_message('receive_mail_remote', player.base_info.id, mail_data)
                player.rebate.send_mail(rid)
            else:
                mail_id = game_configs.base_config.get('weekCardRemindMail')
                mail = db_pb2.Mail_PB()
                mail.config_id = mail_id
                mail.receive_id = player.base_info.id
                mail.send_time = int(time.time())
                mail.mail_type = 4
                mail_data = mail.SerializePartialToString()
                netforwarding.push_message('receive_mail_remote', player.base_info.id, mail_data)
                player.rebate.send_mail(rid)
            player.rebate.save_data()

def rebate_info(player):
    """
    获取返利卡状态
    """
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
        player.rebate.save_data()

        notify = rebate_info(player)
        remote_gate.push_object_remote(5432,
                                           notify.SerializePartialToString(),
                                           [player.dynamic_id])
