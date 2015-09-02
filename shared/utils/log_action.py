# -*- coding:utf-8 -*-
"""
created by server on 14-9-22下午2:49.
"""
from gfirefly.server.globalobject import GlobalObject
import time


def strdatetime():
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time()))

#-----------------------------player-------------------------------------------------

def player_money_flow(player, money_type, add_or_reduce, money, after_money, reason):
    """money flow"""
    if money_type == 0:
        after_state = player.finance.coin
    elif money_type == 1:
        after_state = player.finance.gold
    elif money_type == 2:
        after_state = player.finance.hero_soul
    elif money_type == 3:
        after_state = player.finance.junior_stone
    elif money_type == 4:
        after_state = player.finance.middle_stone
    elif money_type == 5:
        after_state = player.finance.high_stone
    send_message(title='MoneyFlow', Uid=player.base_info.id, MoneyType=money_type,  \
                                    AddOrReduce=add_or_reduce, AfterMoney=after_money, \
                                    Money=money, Reason=reason)


def player_level_flow(player, level, exp, after_level, after_exp, reason):
    """level flow"""
    send_message(title='LevelFlow', Uid=player.base_info.id, Level=level,  \
                                    Exp=exp, AfterLevel=after_level, \
                                    AfterExp=after_exp, Reason=reason)


def player_stamina_flow(player, add_or_reduce, stamina, after_stamina, reason):
    """stamina flow"""
    send_message(title='StaminaFlow', Uid=player.base_info.id, AddOrReduce=add_or_reduce,  \
                                    AfterStamina=after_stamina, Stamina=stamina, Reason=reason)


def player_combat_power_flow(player, add_or_reduce, combat_power, after_combat_power, reason):
    """战斗力 flow"""
    send_message(title='CombatPowerFlow', Uid=player.base_info.id, AddOrReduce=add_or_reduce,  \
                                    AfterCombatPower=after_combat_power, CombatPower=combat_power, Reason=reason)


def player_info(player):
    """登录/登出时，记录玩家信息"""
    send_message(title='PlayerInfo', Uid=player.base_info.id, Name=player.base_info.base_name,  \
                     Level=player.base_info.level, Exp=player.base_info.exp, Stamina=player.stamina)
    player_heros_info(player)
    player_equipments_info(player)


#-----------------------------hero-------------------------------------------------

def player_heros_info(player, oper_type):
    """登录/登出时，记录武将信息
    oper_type: 1 login; 0 logout
    """
    for hero_no, hero in player.hero_component.heros:
        send_message(title='HerosInfo', Uid=player.base_info.id, HeroNo=hero_no,  \
                     Level=hero.level, Exp=hero.exp, BreakLevel=hero.break_level)


def hero_flow(player, hero_no, add_or_reduce, reason):
    """hero flow
    reason: 1  --compose
    reason: 2  --shop
    reason: 3  --battle
    """
    send_message(title='EquipmentsInfo', Uid=player.base_info.id, HeroNo=hero_no,  \
                     AddOrReduce=add_or_reduce, Reason=reason)


def hero_upgrade_flow(player):
    """level, exp, """
    pass


def hero_sacrifice_flow(player):
    pass


#-----------------------------equipment-------------------------------------------------

def player_equipments_info(player):
    """登录/登出时，记录装备信息"""
    for equipment_id, equip in player.hero_component.heros:
        send_message(title='EquipmentsInfo', Uid=player.base_info.id, EquipmentID=equipment_id,  \
                     No=equip.base_info.equipment_no, \
                     StrengthLV=equip.attribute.strength_lv, \
                     EnhanceRecord=str(equip.enhance_record.enhance_record))


#-----------------------------chip-------------------------------------------------

def chip_flow(player, chip_no, chip_type, add_or_reduce, chip_num, after_chip_num, reason):
    """chip
    reason: 1  --compose
    reason: 2  --shop
    reason: 3  --battle
    reason: 4  --hero shop
    """
    send_message(title='EquipmentsInfo', Uid=player.base_info.id, ChipNo=chip_no,  \
                     ChipType=chip_type, AddOrReduce=add_or_reduce, ChipNum=chip_num, \
                     AfterChipNum=after_chip_num, Reason=reason)


#-----------------------------item-------------------------------------------------

def item_flow(player, item_no, add_or_reduce, item_num, after_item_num, reason):
    """item
    reason: 1  --hero upgrade with item
    reason: 2  --shop
    reason: 3  --battle
    reason: 4  --hero sacrifice
    """
    send_message(title='EquipmentsInfo', Uid=player.base_info.id, ItemNo=item_no,  \
                     AddOrReduce=add_or_reduce, ItemNum=item_num, \
                     AfterItemNum=after_item_num, Reason=reason)


def send_message(**kwargs):
    message = []
    message.append(strdatetime())  # insert time
    message.append(1)  # game_server_id
    for k, v in kwargs.items():
        message.append(k)
    sendmsg = _format(message)
    # GlobalObject().logclient.send_msg(sendmsg + '\n')


def _format(message):
    return '|'.join(map(str, message))
