# -*- coding:utf-8 -*-
"""
created by server on 14-9-22下午2:49.
"""
from gfirefly.server.globalobject import GlobalObject
import time


def strdatetime():
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time()))

def stamina_flow():
    pass


def money_flow(player, addorreduce, moneytype, money, reason, subreason=0, cpoint=0, cpoints=1):
    # after_money = player.player_info.coin if moneytype == 0 else player.player_info.money
    if moneytype == 0:
        after_money = player.finance.coin
    elif moneytype == 1:
        after_money = player.finance.gold
    elif moneytype == 2:
        after_money = player.finance.hero_soul
    elif moneytype == 3:
        after_money = player.finance.junior_stone
    elif moneytype == 4:
        after_money = player.finance.middle_stone
    elif moneytype == 5:
        after_money = player.finance.high_stone
    send_message(title='MoneyFlow',Uid=player.base_info.id, GameSvrId=1, dtEventTime=strdatetime(), Sequence=0, \
                                      GameAppID=player.appid, PlatID=player.os, \
                                      OpenID=player.openid, Level=player.player_info.grade, AfterMoney=after_money, \
                                      Money=money, \
                                      Reason=reason, SubReason=subreason, AddOrReduce=addorreduce, MoneyType=moneytype,
                                      Cpoint=cpoint, Cpoints=cpoints)



def send_message(**kwargs):
    message = []
    for k, v in kwargs:
        message.append(k)
    sendmsg = _format(message)
    GlobalObject().logclient.gethandler().send_msg(sendmsg + '\n')

def _format(message):
    return '|'.join(map(str, message))
