# coding: utf-8
# Created on 2013-8-28
# Author: Panjiang

from utils import log4tx
from func import xtime
from conf import ZONE_ID
from utils.log import log_except
import friend_action
from models.user_map import UserMap

def player_register(handler, user):
    log4tx.player_register(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, ClientVersion=handler.game_version,
                        SystemSoftware=handler.os, SystemHardware=handler.machine, TelecomOper=handler.isp, Network=handler.network, ScreenWidth=handler.screen_width,
                        ScreenHight=handler.screen_hight, Density=handler.density, RegChannel=user.channel, UUID=user.mac, CpuHardware=handler.hardware, Memory=handler.memory,
                        GLRender=handler.glrender, GLVersion=handler.glversion, DeviceId=user.mac, Nickname=user.nickname)

def player_login(handler, user):
    log4tx.player_login(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), GameAppID=user.appid, \
                                PlatID=handler.client_version, OpenID=user.openid, Level=user.user_info.grade, PlayerFriendsNum=user.user_friends.friend_num,
                                ClientVersion=handler.game_version, SystemSoftware=handler.os, SystemHardware=handler.machine, TelecomOper=handler.isp, \
                                Network=handler.network, ScreenWidth=handler.screen_width, \
                                ScreenHight=handler.screen_hight, Density=handler.density, LoginChannel=handler.released_channel, UUID=user.mac, CpuHardware=handler.hardware, Memory=handler.memory, \
                                GLRender=handler.glrender, GLVersion=handler.glversion, DeviceId=user.mac, IPAddress=user.ip)
    
def player_logout(handler, user, onlinetime):
    log4tx.player_logout(Uid=user.uid, vGameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), vGameAppID=user.appid, vOpenID=user.openid, iOnlineTime=onlinetime,
                                     iLevel=user.user_info.grade, PlatID=handler.client_version, ClientVersion=handler.game_version,
                                     SystemSoftware=handler.os, SystemHardware=handler.machine, TelecomOper=handler.isp, Network=handler.network, ScreenWidth=handler.screen_width,
                                     ScreenHight=handler.screen_hight, Density=handler.density, Channel=user.channel, UUID=user.mac,
                                     CpuHardware=handler.hardware, Memory=handler.memory, GLRender=handler.glrender, GLVersion=handler.glversion, DeviceId=user.mac, PlayerFriendsNum=user.user_friends.friend_num)

def money_flow(user, addorreduce, moneytype, money, reason, subreason=0, cpoint=0, cpoints=1):
    # after_money = user.user_info.coin if moneytype == 0 else user.user_info.money
    if moneytype == 0:
        after_money = user.user_info.coin
    elif moneytype == 1:
        after_money = user.user_info.money
    elif moneytype == 2:
        after_money = user.user_other_info.other_info.get('hero_soul', 0)
    elif moneytype == 3:
        after_money = user.user_other_info.other_info.get('hero_soul_unusual', 0)
    elif moneytype == 4:
        after_money = user.user_info.smelt_point
    elif moneytype == 5:
        after_money = user.user_info.smelt_deluxe_point
    elif moneytype == 6:
        after_money = user.user_pvp.honor   
    log4tx.money_flow(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=0, \
                                      GameAppID=user.appid, PlatID=user.os, \
                                      OpenID=user.openid, Level=user.user_info.grade, AfterMoney=after_money, \
                                      Money=money, \
                                      Reason=reason, SubReason=subreason, AddOrReduce=addorreduce, MoneyType=moneytype, Cpoint=cpoint, Cpoints=cpoints)
    
def item_flow(user, addorreduce, itemtype, itemnum, itemid, itid, reason, subreason=0, after_num=None):
    if after_num is None:
        after_num = 0
        if itemtype == 4:
            after_num = user.user_heros.hero_num  
        elif itemtype == 5:
            after_num = user.user_items.item_num
    log4tx.item_flow(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=0, \
                                     GameAppID=user.appid, OpenID=user.openid, PlatID=user.os, ItemID=itemid, ItemType=itemtype, \
                                     AfterCount=after_num, Count=itemnum, AddOrReduce=addorreduce, Reason=reason, SubReason=subreason, Itid=itid)
    
def item_money_flow(user, itemtype, itemnum, itemid, moneytype, moneyprice):
    log4tx.item_money_flow(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=0, \
                               GameAppID=user.appid, OpenID=user.openid, PlatID=user.os, ItemType=itemtype, ItemId=itemid, \
                               Count=itemnum, Money=moneyprice, MoneyType=moneytype, Level=user.user_info.grade)
    
def sns_flow(user, recnum, count, suptype, subtype=0):
    log4tx.sns_flow(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), GameAppID=user.appid, \
                            PlatID=user.os, ActorOpenID=user.openid, RecNum=recnum, Count=count, SNSType=suptype, SNSSubType=subtype)
    
def round_flow(user, fighting, result, score, ranking, gain_coin, gain_exp):
    log4tx.round_flow(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), \
                          GameAppID=user.appid, OpenID=user.openid, PlatID=user.os, \
                          BattleID=fighting.stage_id, BattleType=fighting.stage_type, \
                          RoundScore=score, Result=result, Rank=ranking, Gold=gain_coin, isQuick=fighting.is_quick, ExpChange=gain_exp)

def round_flow_item_output(user, fighting, itemtype, itemnum, itemid):
    log4tx.round_flow_item_output(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), \
                                                      GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                                                      BattleID=fighting.stage_id, BattleType=fighting.stage_type, \
                                                      ItemType=itemtype, ItemId=itemid, ItemNum=itemnum)
    
def player_exp_flow(user, beforelevel, gain_exp, upgrade_duration, reason):
    log4tx.player_exp_flow(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), GameAppID=user.appid, \
                                       OpenID=user.openid, PlatID=user.os, ExpChange=gain_exp, \
                                       BeforeLevel=beforelevel, AfterLevel=user.user_info.grade, Time=upgrade_duration, Reason=reason)
    
def log_anti_data(user, hex_msg):
    log4tx.log_anti_data(Uid=user.uid, vGameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), iSequence=xtime.timestamp(),
                                 vGameAppID=user.appid, vOpenID=user.openid, PlatID=user.os, strData=hex_msg)
    
def card_star_lvup(user, item_type, item_id, before, after, coin, soul, cost_item_type, cost_item_id):
    log4tx.card_star_lvup(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), GameAppID=user.appid, \
                                    PlatID=user.os, OpenID=user.openid, Itemtype=item_type, Itemid=item_id, Before=before, After=after, \
                                    Coin=coin, Soul=soul, Costtype=cost_item_type, Cost_id=cost_item_id)
    
def item_flow_drop(user, reason, drop_list, costtype=0, costprice=0, fighting=None, item_subreason=0):
    """
    掉落包掉道具
    """
    for drops in drop_list:
        dtype, itemid, _, quantity = drops[:4]
        if dtype in [1, 2]:
            continue
        if len(drops[4:]) == 0:
            item_flow(user, 0, dtype, quantity, itemid, 0, reason, subreason=item_subreason)
        after_num = 0
        if dtype == 4:
            after_num = user.user_heros.hero_num
        elif dtype == 5:
            after_num = user.user_items.item_num
        cur_after_num = after_num - len(drops[4:])
        for itid in drops[4:]:
            cur_after_num += 1
            item_flow(user, 0, dtype, quantity, itemid, itid, reason, subreason=item_subreason, after_num=cur_after_num)
            if costprice > 0:
                item_money_flow(user, dtype, quantity, itemid, costtype, costprice)
            if fighting:
                round_flow_item_output(user, fighting, dtype, quantity, itemid)
            
def drop(user, gain_coin, money_sum, drop_list, moneyreason, itemreason, costtype=0, costprice=0, money_subreason=0, item_subreason=0):
    """
    掉落包所有掉落统一记录
    """
    if gain_coin > 0:
        money_flow(user, 0, 0, gain_coin, moneyreason, subreason=money_subreason)
    if money_sum > 0:
        money_flow(user, 0, 1, money_sum, moneyreason, subreason=money_subreason)
    item_flow_drop(user, itemreason, drop_list, costtype, costprice, item_subreason=item_subreason)
    
def boss_attack(user, result, damage, coin, rank):
    log4tx.boss_attack(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(),
                                 GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, Result=result, Damage=damage, Money=coin, Rank=rank)
    
def boss_rank(user, rank):
    log4tx.boss_rank(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(),
                                 GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, Rank=rank)
    
def use_pet(user, petid, opt):
    log4tx.use_pet(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(),
                                 GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, ItemType=5, ItemId=petid, Type=opt)

def tower_round_flow(user, grade, stage_num, result, starnum, relive_num, buff, stage_id, frozen=0, itemid=0, backup_itemid=0):
    log4tx.tower_round_flow(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), \
                            BattleType=5, FloorNum=stage_num, Result=result, StarNum=starnum, Frozen=frozen, \
                            ItemId=itemid, BackupItemId=backup_itemid, ReliveNum=relive_num, Buff=buff, \
                            GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, BattleID=stage_id, Level=grade)
    
def player_hero_info(user, hero_id, hrid, grade, breakup, skill1, skill2, skill3, skill4, item1, item2, item3, item4, item5, item6):
    log4tx.player_hero_info(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, HeroItemId=hero_id, HeroUid=hrid, HeroLevel=grade, HeroStarLevel=breakup,
                     Skill1Level=skill1, Skill2Level=skill2, Skill3Level=skill3, Skill4Level=skill4,
                     Item1Level=item1, Item2Level=item2, Item3Level=item3, Item4Level=item4, Item5Level=item5, Item6Level=item6)
    
def pvp_purchase_vigor(user, costmoney):
    log4tx.pvp_purchase_vigor(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, CostMoney=costmoney)

def pvp_battle_info(user, teamid, petid1, petid2, heroid1, hero_typeid1, heroid2, hero_typeid2, heroid3, hero_typeid3, heroid4, hero_typeid4, heroid5, hero_typeid5):
    combat = friend_action.another_info(user, user.uid, "group_abi")
    log4tx.pvp_battle_info(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                          Level=user.user_info.grade, Combat=combat, TeamID=teamid, PetID1=petid1, PetID2=petid2, HoreID1=heroid1, HoreTypeID1=hero_typeid1, HoreID2=heroid2, \
                          HoreTypeID2=hero_typeid2, HoreID3=heroid3, HoreTypeID3=hero_typeid3, HoreID4=heroid4, HoreTypeID4=hero_typeid4, HoreID5=heroid5, HoreTypeID5=hero_typeid5)
    
def pvp_result(user, opponent_uid, teamid, result, rank):
    log4tx.pvp_result(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                      OpponentUid=opponent_uid, TeamID=teamid, Result=result, Rank=rank)

def pvp_award(user, honor):
    log4tx.pvp_award(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                    Honor=honor)
    
def pvp_honor_exchange(user, itemid):
    log4tx.pvp_honor_exchange(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                              ItemID=itemid)
    
def item_remove(user, item_type, itemid, cost_item_type, cost_itemid, cost_item_num, out_put_item_type, out_put_itemid, out_put_item_num):
    log4tx.item_remove(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                          ItemType=item_type, ItemId=itemid, CostItemType=cost_item_type, CostItemId=cost_itemid, CostItemNum=cost_item_num, OutputItemType=out_put_item_type, \
                          OutputItemId=out_put_itemid, OutputItemNum=out_put_item_num)
    
def item_decompose(user, item_type, itemid, smelt_point, smelt_deluxe_point):
    log4tx.item_decompose(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                          ItemType=item_type, ItemId=itemid, SmeltPoint=smelt_point, SmeltDeluxePoint=smelt_deluxe_point)
    
def item_purify(user, itemtype, itemid, cost_item_num, get_gold, get_diamond, get_smelt_point, get_smelt_deluxe_point):
    log4tx.item_purify(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                       ItemType=itemtype, ItemId=itemid, CostItemNum=cost_item_num, GetGold=get_gold, GetDiamond=get_diamond, GetSmeltPoint=get_smelt_point, \
                       GetSmeltDeluxePoint=get_smelt_deluxe_point)

def item_strengthen(user, item_type, itemid, cost_item_num, cost_money, before_level, after_level, strengthen_type):
    log4tx.item_strengthen(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                           ItemType=item_type, ItemId=itemid, CostItemNum=cost_item_num, CostMoney=cost_money, BeforeLevel=before_level, AfterLevel=after_level, \
                           StrengthenType=strengthen_type)

def item_attr_streng(user, itemtype, itemid, strength_type, cost_item_num, cost_sup_item_num, cost_money, cost_diamond, add_index, add_id):
    log4tx.item_attr_streng(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                            ItemType=itemtype, ItemId=itemid, StrengthType=strength_type, CostItemNum=cost_item_num, CostSupItemNum=cost_sup_item_num, \
                            CostMoney=cost_money, CostDiamond=cost_diamond, AddIndex=add_index, AddID=add_id)
    
def invitation_code_write(user, invitation_code):
    registration_time = UserMap.get(user.username).register_time
    log4tx.invitation_code_write(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                                 RegistrationTime=xtime.strdatetimefromts_ss(registration_time), InvitationCode=invitation_code)
    
def invitation_code_receive_award(user, award_type):
    log4tx.invitation_code_receive_award(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, \
                                         OpenID=user.openid, AwardType=award_type)

def chat_room_speak(user, channel):
    log4tx.chat_room_speak(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, Channel=channel)
    
def chat_room_gag(user):
    log4tx.chat_room_gag(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid)
    
def multi_lineup(user, operate_type):
    log4tx.multi_lineup(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                        OperateType=operate_type)
    
def link_skill(user, main_card_typeid, main_cardid, card_typeid, cardid, skill_id):
    log4tx.link_skill(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                      MainCardTypeID=main_card_typeid, MainCardID=main_cardid, CardTypeID=card_typeid, CardID=cardid, SkillID=skill_id)
    
def supplicaion_do(user, itemid, itemnum):
    log4tx.supplicaion_do(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                          ItemID=itemid, ItemNum=itemnum)
    
def supplicaion_select(user, itemid):
    log4tx.supplicaion_select(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                          ItemID=itemid)
    
def supplicaion_refresh(user, refresh_type, cost_itemnum):
    log4tx.supplicaion_refresh(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                               RefreshType=refresh_type, CostItemNum=cost_itemnum)
    
def continuous_mop_up(user, stageid, mop_up_type, mop_up_num, cost_money):
    log4tx.continuous_mop_up(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                             StageID=stageid, MopUpType=mop_up_type, MopUpNum=mop_up_num, CostMoney=cost_money)
    
def luck_hero_select(user, heroid):
    log4tx.luck_hero_select(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                            HeroID=heroid)
    
def luck_hero_refresh(user, cost_money):
    log4tx.luck_hero_refresh(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                             CostMoney=cost_money)
    
def luck_hero_get(user, luck_points, heroid, heronum):
    log4tx.luck_hero_get(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                         LuckPoints=luck_points, HeroID=heroid , HeroNum=heronum)
    
def luck_drop_select(user, stageid, drop_type, dropid):
    log4tx.luck_drop_select(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                            StageID=stageid, DropType=drop_type, DropID=dropid)
    
def luck_drop_get(user, stageid, luck_points, drop_type, dropid, dropnum):
    log4tx.luck_drop_get(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                         StageID=stageid, LuckPoints=luck_points, DropType=drop_type, DropID=dropid, DropNum=dropnum)
    
def execute_pay(user, cost_type, money):
    log4tx.execute_pay(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                       CostType=cost_type, Money=money)
    
def GM_reward(user, drop_type, dropid, drop_grade, drop_quantity):
    log4tx.GM_reward(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                     DropType=drop_type, DropID=dropid, DropGrade=drop_grade, DropQuantity=drop_quantity)
    
def GM_update(user, update_type, update_value):
    log4tx.GM_update(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                     UpdateType=update_type, UpdateValue=update_value)
    
def skill_level_up(user, heroid, hero_typeid, before_skillid, after_skill_id):
    log4tx.skill_level_up(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                          HoreID=heroid, HoreTypeID=hero_typeid, BeforeSkillID=before_skillid, AfterSkillID=after_skill_id)
    
def hero_chip(user, add_or_reduce, reason, chipid, amount):
    log4tx.hero_chip(Uid=user.uid, GameSvrId=ZONE_ID, dtEventTime=xtime.strdatetime(), Sequence=xtime.timestamp(), GameAppID=user.appid, PlatID=user.os, OpenID=user.openid, \
                     AddOrReduce=add_or_reduce, Reason=reason, ChipID=chipid, Amount=amount)
    
# TLOG分类打印函数
tlog_funcs = {}
tlog_funcs['PlayerLogin'] = player_login
tlog_funcs['PlayerRegister'] = player_register
tlog_funcs['MoneyFlow'] = money_flow
tlog_funcs['ItemFlow'] = item_flow
tlog_funcs['ItemFlowDrop'] = item_flow_drop
tlog_funcs['Drop'] = drop
tlog_funcs['PlayerLogout'] = player_logout
tlog_funcs['ItemMoneyFlow'] = item_money_flow
tlog_funcs['SNSFlow'] = sns_flow
tlog_funcs['RoundFlow'] = round_flow
tlog_funcs['PlayerExpFlow'] = player_exp_flow
tlog_funcs['LogAntiData'] = log_anti_data
tlog_funcs['CardStarLvUp'] = card_star_lvup
tlog_funcs['BossAttack'] = boss_attack
tlog_funcs['BossRank'] = boss_rank
tlog_funcs['TowerRoundFlow'] = tower_round_flow
tlog_funcs['UsePet'] = use_pet
tlog_funcs['PlayerHeroInfo'] = player_hero_info
tlog_funcs['PVPPurchaseVigor'] = pvp_purchase_vigor  # PVP购买体力
tlog_funcs['PVPBattleInfo'] = pvp_battle_info  # PVP对战信息
tlog_funcs['PVPResult'] = pvp_result  # PVP对战结果
tlog_funcs['PVPAward'] = pvp_award  # PVP奖励
tlog_funcs['PVPHonorExchange'] = pvp_honor_exchange  # PVP荣誉兑换
tlog_funcs['ItemRemove'] = item_remove  # 装备拆解
tlog_funcs['ItemDecompose'] = item_decompose  # 装备熔炼
tlog_funcs['ItemPurify'] = item_purify  # 装备净化
tlog_funcs['ItemStrengthen'] = item_strengthen  # 装备强化
tlog_funcs['ItemAttrStreng'] = item_attr_streng  # 装备洗练
tlog_funcs['InvitationCodeWrite'] = invitation_code_write  # 邀请码填写
tlog_funcs['InvitationCodeReceiveAward'] = invitation_code_receive_award  # 邀请码领取奖励
tlog_funcs['ChatRoomSpeak'] = chat_room_speak  # 聊天室发言
tlog_funcs['ChatRoomGag'] = chat_room_gag  # 聊天室禁言
tlog_funcs['MultiLineup'] = multi_lineup  # 多阵容选择
tlog_funcs['SupplicaionDo'] = supplicaion_do  # 进行祈愿
tlog_funcs['SupplicaionSelect'] = supplicaion_select  # 选择祈愿
tlog_funcs['SupplicaionRefresh'] = supplicaion_refresh  # 刷新祈愿列表
tlog_funcs['ContinuousMopUp'] = continuous_mop_up  # 连续扫荡
tlog_funcs['LinkSkill'] = link_skill  # 技能连锁
tlog_funcs['LuckHeroSelect'] = luck_hero_select  # 选择幸运英雄
tlog_funcs['LuckHeroRefresh'] = luck_hero_refresh  # 刷新幸运英雄列表
tlog_funcs['LuckHeroGet'] = luck_hero_get  # 兑换幸运英雄
tlog_funcs['LuckDropSelect'] = luck_drop_select  # 选择幸运掉落物
tlog_funcs['LuckDropGet'] = luck_drop_get  # 获得幸运掉落物
tlog_funcs['ExecutePay'] = execute_pay  # 执行云支付
tlog_funcs['GMReward'] = GM_reward  # GM奖励
tlog_funcs['GMUpdate'] = GM_update  # GM更新用户信息
tlog_funcs['SkillLevelUP'] = skill_level_up  # 技能升级
tlog_funcs['HeroChip'] = hero_chip  # 英雄碎片

def log(mod, *args, **kwds):
    """
    打印TLOG
    """
    try:
        tlog_funcs[mod](*args, **kwds)
    except:
        log_except(mod)
        
