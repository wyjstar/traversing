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

def rebate_info(player):
    """
    获取返利卡状态
    """

    response = rebateInfo()
    plat = 'ios'
    if player.base_info.plat_id == 1:
        plat = 'android'

    for rid in game_configs.recharge_config[plat].keys():
        recharge_item = game_configs.recharge_config[plat][rid]
        if recharge_item.get('type') == 2:
            switch, last, can_draw = player.rebate.rebate_status(recharge_item.id, recharge_item.get('giftDays'))
            rebate = response.rebates.add()
            print 'rebate.rid', type(rebate.rid), recharge_item.id
            rebate.rid = recharge_item.id
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
            send_mail(conf_id=mail_id, receive_id=player.base_info.id)
        player.rebate.save_data()

        notify = rebate_info(player)
        remote_gate.push_object_remote(5432,
                                           notify.SerializePartialToString(),
                                           [player.dynamic_id])
