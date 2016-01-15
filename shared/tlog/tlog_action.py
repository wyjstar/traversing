# coding: utf-8

from shared.tlog import log4tx
from shared.utils import xtime
# from utils.log import log_except
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
import time

game_server_id = GlobalObject().allconfig['server_no']
game_app_id = GlobalObject().allconfig['msdk']['appid']
plat_id = 1


def player_register(player_data, handler, ip):
    log4tx.player_register(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id, PlatID=plat_id,
                           OpenID=player_data.id,
                           ClientVersion=handler.client_version,
                           SystemSoftware=handler.system_software,
                           SystemHardware=handler.system_hardware,
                           TelecomOper=handler.telecom_oper,
                           Network=handler.network,
                           ScreenWidth=handler.screen_width,
                           ScreenHight=handler.screen_hight,
                           Density=handler.density,
                           RegChannel=handler.login_channel,
                           UUID=handler.mac,
                           CpuHardware=handler.cpu_hardware,
                           Memory=handler.memory,
                           GLRender=handler.gl_render,
                           GLVersion=handler.gl_version,
                           DeviceId=handler.device_id, Nickname='nickname',
                           IP=ip)


def player_login(player_data, handler, ip):
    log4tx.player_login(GameSvrId=game_server_id,
                        dtEventTime=xtime.strdatetime(),
                        GameAppID=game_app_id,
                        PlatID=plat_id, Level=player_data.level,
                        PlayerFriendsNum=1,
                        ClientVersion=handler.client_version,
                        SystemSoftware=handler.system_software,
                        SystemHardware=handler.system_hardware,
                        TelecomOper=handler.telecom_oper,
                        Network=handler.network,
                        ScreenWidth=handler.screen_width,
                        ScreenHight=handler.screen_hight,
                        Density=handler.density,
                        LoginChannel=handler.login_channel, UUID=handler.mac,
                        CpuHardware=handler.cpu_hardware,
                        Memory=handler.memory, GLRender=handler.gl_render,
                        GLVersion=handler.gl_version,
                        DeviceId=handler.device_id, OpenID=player_data.id,
                        IP=ip)


def player_logout(player_data):
    online_time = int(time.time())-player_data.base_info.login_time
    log4tx.player_logout(GameSvrId=game_server_id,
                         dtEventTime=xtime.strdatetime(),
                         GameAppID=game_app_id,
                         PlatID=plat_id, Level=player_data.base_info.level,
                         OpenID=player_data.base_info.id,
                         OnlineTime=online_time)


def item_flow(player_data, addorreduce, itemtype, itemnum, itemid, itid,
              reason, after_num, event_id):
    log4tx.item_flow(PlatID=plat_id, GameSvrId=game_server_id,
                     dtEventTime=xtime.strdatetime(), GameAppID=game_app_id,
                     OpenID=player_data.base_info.id, ItemID=itemid,
                     ItemType=itemtype, AfterCount=after_num, Count=itemnum,
                     AddOrReduce=addorreduce, Reason=reason, Itid=itid,
                     ReasonEventID=event_id)


def player_exp_flow(player_data, beforelevel, gain_exp, reason):

    log4tx.player_exp_flow(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id,
                           OpenID=player_data.base_info.id,
                           PlatID=plat_id, ExpChange=gain_exp,
                           BeforeLevel=beforelevel,
                           AfterLevel=player_data.base_info.level,
                           Time=player_data.base_info.upgrade_time,
                           Reason=reason, Exp=player_data.base_info.exp)


def line_up_change(player_data, slot, hero_id, after_hero_id,
                   change_type):

    log4tx.line_up_change(GameSvrId=game_server_id,
                          dtEventTime=xtime.strdatetime(),
                          GameAppID=game_app_id,
                          OpenID=player_data.base_info.id,
                          PlatID=plat_id,
                          Slot=slot,
                          HeroId=hero_id,
                          AfterHeroId=after_hero_id,
                          ChangeType=change_type)


def hero_sacrifice(player_data, hero_id):

    log4tx.hero_sacrifice(GameSvrId=game_server_id,
                          dtEventTime=xtime.strdatetime(),
                          GameAppID=game_app_id,
                          OpenID=player_data.base_info.id,
                          PlatID=plat_id,
                          HeroId=hero_id)


def hero_break(player_data, hero_id, level):

    log4tx.hero_break(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,
                      HeroId=hero_id,
                      Level=level)


def inherit(player_data, inherit_type, origin_id, origin_item_id,
            target_id, target_item_id, inherit_value):

    log4tx.inherit(GameSvrId=game_server_id,
                   dtEventTime=xtime.strdatetime(),
                   GameAppID=game_app_id,
                   OpenID=player_data.base_info.id,
                   PlatID=plat_id,
                   OriginId=origin_id,
                   OriginItemId=origin_item_id,
                   TargetId=target_id,
                   TargetItemId=target_item_id,
                   InheritType=inherit_type,
                   InheritValue=inherit_value)


def stage_flow(player_data, stage_id, result):

    log4tx.stage_flow(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,
                      StageId=stage_id,
                      Result=result)


def sweep_flow(player_data, stage_id, times, reason_event_id):

    log4tx.sweep_flow(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,
                      StageId=stage_id,
                      Times=times,
                      ReasonEventID=reason_event_id)


def guild_build_up(player_data, guild_id, build_level, build_type):

    log4tx.guild_build_up(GameSvrId=game_server_id,
                          dtEventTime=xtime.strdatetime(),
                          GameAppID=game_app_id,
                          OpenID=player_data.base_info.id,
                          PlatID=plat_id,
                          GuildId=guild_id,
                          BuildLevel=build_level,
                          BuildType=build_type)


def creat_guild(player_data, guild_id, user_level, icon):

    log4tx.creat_guild(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,
                       GuildId=guild_id,
                       UserLevel=user_level,
                       Icon=icon)


def deal_join_guild(player_data, guild_id, behandler, res_type):

    log4tx.deal_join_guild(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id,
                           OpenID=player_data.base_info.id,
                           PlatID=plat_id,
                           GuildId=guild_id,
                           BeHandler=behandler,
                           ResType=res_type)


def exit_guild(player_data, guild_id):

    log4tx.exit_guild(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,
                      GuildId=guild_id)


def guild_change_president(player_data, guild_id, target_id):

    log4tx.guild_change_president(GameSvrId=game_server_id,
                                  dtEventTime=xtime.strdatetime(),
                                  GameAppID=game_app_id,
                                  OpenID=player_data.base_info.id,
                                  PlatID=plat_id,
                                  GuildId=guild_id,
                                  TargetId=target_id)


def guild_kick(player_data, guild_id, target_id):

    log4tx.guild_kick(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,
                      GuildId=guild_id,
                      TargetId=target_id)


def guild_promotion(player_data, guild_id, be_id):

    log4tx.guild_promotion(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id,
                           OpenID=player_data.base_info.id,
                           PlatID=plat_id,
                           GuildId=guild_id,
                           BeId=be_id)


def guild_worship_gift(player_data, guild_id, build_level, gift_no):

    log4tx.guild_worship_gift(GameSvrId=game_server_id,
                              dtEventTime=xtime.strdatetime(),
                              GameAppID=game_app_id,
                              OpenID=player_data.base_info.id,
                              PlatID=plat_id,
                              GuildId=guild_id,
                              BuildLevel=build_level,
                              GiftNo=gift_no)


def guild_worship(player_data, guild_id, worship_type, worship_times):

    log4tx.guild_worship(GameSvrId=game_server_id,
                         dtEventTime=xtime.strdatetime(),
                         GameAppID=game_app_id,
                         OpenID=player_data.base_info.id,
                         PlatID=plat_id,
                         GuildId=guild_id,
                         WorshipType=worship_type,
                         WorshipTimes=worship_times)


def travel_settle(player_data, stage, event_id, parameter, res,
                  is_fast_settle):

    log4tx.travel_settle(GameSvrId=game_server_id,
                         dtEventTime=xtime.strdatetime(),
                         GameAppID=game_app_id,
                         OpenID=player_data.base_info.id,
                         PlatID=plat_id,
                         Stage=stage,
                         EventId=event_id,
                         Parameter=parameter,
                         Res=res,
                         IsFastSettle=is_fast_settle)


def auto_travel(player_data, stage, time):

    log4tx.auto_travel(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,
                       Stage=stage,
                       Time=time)


def hero_refine(player_data, hero_id, refine):

    log4tx.hero_refine(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,
                       Refine=refine,
                       HeroId=hero_id)


def hero_upgrade(player_data, hero_id, change_level, level, type,
                 exp_item_num1, exp_item_num2, exp_item_num3, exp_item_no):

    log4tx.hero_upgrade(GameSvrId=game_server_id,
                        dtEventTime=xtime.strdatetime(),
                        GameAppID=game_app_id,
                        OpenID=player_data.base_info.id,
                        PlatID=plat_id,
                        Level=level,
                        ChangeLevel=change_level,
                        HeroId=hero_id,
                        Type=type,
                        ExpItemNum1=exp_item_num1,
                        ExpItemNum2=exp_item_num2,
                        ExpItemNum3=exp_item_num3,
                        ExpItemNo=exp_item_no)


def recharge(player_data, isfirst, recharege_id, channel):

    log4tx.recharge(GameSvrId=game_server_id,
                    dtEventTime=xtime.strdatetime(),
                    GameAppID=game_app_id,
                    OpenID=player_data.base_info.id,
                    PlatID=plat_id,
                    Isfirst=isfirst,
                    RechargeId=recharege_id,
                    Channel=channel)


def round_flow(player_data, battle_id, battle_type, is_quick, result):

    log4tx.round_flow(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,

                      BattleID=battle_id,
                      BattleType=battle_type,
                      isQuick=is_quick,
                      Result=result)


def new_guide(player_data, sequence, my_sequence):

    log4tx.new_guide(GameSvrId=game_server_id,
                     dtEventTime=xtime.strdatetime(),
                     GameAppID=game_app_id,
                     OpenID=player_data.base_info.id,
                     PlatID=plat_id,

                     Sequence=sequence,
                     MySequence=my_sequence)


def online_num(num):

    log4tx.online_num(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,

                      Num=num)


def money_flow(player_data, after_money, money, reason, addorreduce,
               money_type):

    log4tx.money_flow(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,

                      Level=player_data.base_info.level,
                      AfterMoney=after_money,
                      Money=money, Reason=reason,
                      AddOrReduce=addorreduce,
                      MoneyType=money_type)


def item_money_flow(player_data, item_type, item_id, count, money,
                    money_type, discount_money, discount_money_type,
                    limit_vip_everyday, limit_vip, is_discount):

    log4tx.item_money_flow(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id,
                           OpenID=player_data.base_info.id,
                           PlatID=plat_id,

                           ItemType=item_type,
                           ItemID=item_id,
                           Count=count,
                           Money=money,
                           Level=player_data.base_info.level,
                           MoneyType=money_type,
                           DiscountMoney=discount_money,
                           DiscountMoneyType=discount_money_type,
                           LimitVipEveryday=limit_vip_everyday,
                           LimitVip=limit_vip,
                           IsDiscount=is_discount)


def equipment_enhance(player_data, equipmeng_no, equipmeng_id,
                      beforelevel, afterlevel):

    log4tx.equipment_enhance(GameSvrId=game_server_id,
                             dtEventTime=xtime.strdatetime(),
                             GameAppID=game_app_id,
                             OpenID=player_data.base_info.id,
                             PlatID=plat_id,

                             EquipmentNo=equipmeng_no,
                             EquipmentId=equipmeng_id,
                             BeforeLevel=beforelevel,
                             AfterLevel=afterlevel)


def equipment_compose(player_data, equipmeng_no, equipmeng_id):

    log4tx.equipment_compose(GameSvrId=game_server_id,
                             dtEventTime=xtime.strdatetime(),
                             GameAppID=game_app_id,
                             OpenID=player_data.base_info.id,
                             PlatID=plat_id,

                             EquipmentNo=equipmeng_no,
                             EquipmentId=equipmeng_id)


def equipment_melting(player_data, equipmeng_no, equipmeng_id):

    log4tx.equipment_melting(GameSvrId=game_server_id,
                             dtEventTime=xtime.strdatetime(),
                             GameAppID=game_app_id,
                             OpenID=player_data.base_info.id,
                             PlatID=plat_id,

                             EquipmentNo=equipmeng_no,
                             EquipmentId=equipmeng_id)


def create_nickname(player_data, nickname):

    log4tx.create_nickname(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id,
                           OpenID=player_data.base_info.id,
                           PlatID=plat_id,

                           Nickname=nickname)


def start_target_get_gift(player_data, target_id):

    log4tx.start_target_get_gift(GameSvrId=game_server_id,
                                 dtEventTime=xtime.strdatetime(),
                                 GameAppID=game_app_id,
                                 OpenID=player_data.base_info.id,
                                 PlatID=plat_id,

                                 TargetID=target_id)


def sign_in(player_data, day, is_double, config_id):

    log4tx.sign_in(GameSvrId=game_server_id,
                   dtEventTime=xtime.strdatetime(),
                   GameAppID=game_app_id,
                   OpenID=player_data.base_info.id,
                   PlatID=plat_id,

                   Day=day,
                   IsDouble=is_double,
                   ConfigID=config_id)


def continus_sign_in(player_data, day, config_id):

    log4tx.continus_sign_in(GameSvrId=game_server_id,
                            dtEventTime=xtime.strdatetime(),
                            GameAppID=game_app_id,
                            OpenID=player_data.base_info.id,
                            PlatID=plat_id,

                            Day=day,
                            ConfigID=config_id)


def repair_sign_in(player_data, day, day1, config_id):

    log4tx.repair_sign_in(GameSvrId=game_server_id,
                          dtEventTime=xtime.strdatetime(),
                          GameAppID=game_app_id,
                          OpenID=player_data.base_info.id,
                          PlatID=plat_id,

                          Day=day,
                          Day1=day1,
                          ConfigID=config_id)


def sign_in_box(player_data, box_id, config_id):

    log4tx.sign_in_box(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,

                       BoxID=box_id,
                       ConfigID=config_id)


def online_gift(player_data, gift_id):

    log4tx.online_gift(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,

                       GiftID=gift_id)


def login_gift(player_data, activity_id):

    log4tx.login_gift(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,

                      ActivityID=activity_id)


def feast(player_data, stamina):

    log4tx.feast(GameSvrId=game_server_id,
                 dtEventTime=xtime.strdatetime(),
                 GameAppID=game_app_id,
                 OpenID=player_data.base_info.id,
                 PlatID=plat_id,

                 Stamina=stamina)


def activity(player_data, activity_id, arg):

    log4tx.activity(GameSvrId=game_server_id,
                    dtEventTime=xtime.strdatetime(),
                    GameAppID=game_app_id,
                    OpenID=player_data.base_info.id,
                    PlatID=plat_id,

                    Arg=arg,
                    ActivityID=activity_id)


def level_gift(player_data, activity_id):

    log4tx.level_gift(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,

                      ActivityID=activity_id,
                      Level=player_data.base_info.level)


def share(player_data, tid, share_type):

    log4tx.share(GameSvrId=game_server_id,
                 dtEventTime=xtime.strdatetime(),
                 GameAppID=game_app_id,
                 OpenID=player_data.base_info.id,
                 PlatID=plat_id,

                 TaskID=tid,
                 ShareType=share_type)


def draw_rebate(player_data, rid):

    log4tx.draw_rebate(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,

                       RebateID=rid)


def buy_coin(player_data, need_gold, buy_times, coin_num):

    log4tx.buy_coin(GameSvrId=game_server_id,
                    dtEventTime=xtime.strdatetime(),
                    GameAppID=game_app_id,
                    OpenID=player_data.base_info.id,
                    PlatID=plat_id,

                    NeedGold=need_gold,
                    BuyTimes=buy_times,
                    CoinNum=coin_num)


def god_hero_exchange(player_data, activity_id, exchange_num):

    log4tx.god_hero_exchange(GameSvrId=game_server_id,
                             dtEventTime=xtime.strdatetime(),
                             GameAppID=game_app_id,
                             OpenID=player_data.base_info.id,
                             PlatID=plat_id,

                             ActivityID=activity_id,
                             ExchangeNum=exchange_num)


def trigger_hjqy(player_data, stage_id, hjqy_stage_id):

    log4tx.trigger_hjqy(GameSvrId=game_server_id,
                        dtEventTime=xtime.strdatetime(),
                        GameAppID=game_app_id,
                        OpenID=player_data.base_info.id,
                        PlatID=plat_id,

                        StageID=stage_id,
                        HJQYStageID=hjqy_stage_id)


def battle_hjqy(player_data, boss_id, is_kill):

    log4tx.battle_hjqy(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,

                       BossID=boss_id,
                       IsKill=is_kill)


def open_chest(player_data, stage_id, stage_type):

    log4tx.open_chest(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,

                      StageID=stage_id,
                      StageType=stage_type)


def open_star_chest(player_data, chapter_id, award_type):

    log4tx.open_star_chest(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id,
                           OpenID=player_data.base_info.id,
                           PlatID=plat_id,

                           ChapterID=chapter_id,
                           AwardType=award_type)


def star_random(player_data, random_num, times, chapter_id):

    log4tx.star_random(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,

                       RandomNum=random_num,
                       ChapterID=chapter_id,
                       Times=times)


def deal_star_random(player_data, random_num, deal_type, chapter_id):

    log4tx.deal_star_random(GameSvrId=game_server_id,
                            dtEventTime=xtime.strdatetime(),
                            GameAppID=game_app_id,
                            OpenID=player_data.base_info.id,
                            PlatID=plat_id,

                            RandomNum=random_num,
                            ChapterID=chapter_id,
                            DealType=deal_type)


def hero_runt_set(player_data, hero_id, now, runt_no, runt_po, runt_id):

    log4tx.hero_runt_set(GameSvrId=game_server_id,
                         dtEventTime=xtime.strdatetime(),
                         GameAppID=game_app_id,
                         OpenID=player_data.base_info.id,
                         PlatID=plat_id,

                         HeroId=hero_id,
                         Now=now,
                         RuntNo=runt_no,
                         RuntPo=runt_po,
                         RuntID=runt_id)


def hero_runt_pick(player_data, hero_id, runt_type, now,
                   runt_no, runt_po, runt_id):

    log4tx.hero_runt_pick(GameSvrId=game_server_id,
                          dtEventTime=xtime.strdatetime(),
                          GameAppID=game_app_id,
                          OpenID=player_data.base_info.id,
                          PlatID=plat_id,

                          HeroID=hero_id,
                          RuntType=runt_type,
                          Now=now,
                          RuntNo=runt_no,
                          RuntPo=runt_po,
                          RuntID=runt_id)


def make_runt(player_data, runt_id1, runt_id2, runt_id3,
              runt_id4, runt_id5, num, res_runt_id,
              res_runt_no):

    log4tx.make_runt(GameSvrId=game_server_id,
                     dtEventTime=xtime.strdatetime(),
                     GameAppID=game_app_id,
                     OpenID=player_data.base_info.id,
                     PlatID=plat_id,

                     RuntID1=runt_id1,
                     RuntID2=runt_id2,
                     RuntID3=runt_id3,
                     RuntID4=runt_id4,
                     RuntID5=runt_id5,
                     Num=num,
                     ResRuntID=res_runt_id,
                     ResRuntNo=res_runt_no)


def hero_awake(player_data, hero_id, num, level):

    log4tx.hero_awake(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,

                      HeroID=hero_id,
                      Num=num,
                      Level=level)


def buy_elite_stage_times(player_data, buy_times, num, gold_num):

    log4tx.buy_elite_stage_times(GameSvrId=game_server_id,
                                 dtEventTime=xtime.strdatetime(),
                                 GameAppID=game_app_id,
                                 OpenID=player_data.base_info.id,
                                 PlatID=plat_id,

                                 BuyTimes=buy_times,
                                 Num=num,
                                 GoldNum=gold_num)


def pvp_daily_award(open_id, mail_id, rank):

    log4tx.pvp_daily_award(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id,
                           PlatID=plat_id,

                           OpenID=open_id,
                           MailID=mail_id,
                           Rank=rank)


def mine_harvest(player_data, position, normal, lucky):

    log4tx.mine_harvest(GameSvrId=game_server_id,
                        dtEventTime=xtime.strdatetime(),
                        GameAppID=game_app_id,
                        OpenID=player_data.base_info.id,
                        PlatID=plat_id,

                        Position=position,
                        Normal=normal,
                        Lucky=lucky)


def mine_acc(player_data, last_time):

    log4tx.mine_acc(GameSvrId=game_server_id,
                    dtEventTime=xtime.strdatetime(),
                    GameAppID=game_app_id,
                    OpenID=player_data.base_info.id,
                    PlatID=plat_id,

                    LastTime=last_time)


def mine_accelerate(player_data, gold_num):

    log4tx.mine_accelerate(GameSvrId=game_server_id,
                           dtEventTime=xtime.strdatetime(),
                           GameAppID=game_app_id,
                           OpenID=player_data.base_info.id,
                           PlatID=plat_id,

                           GoldNum=gold_num)


def mine_box(player_data):

    log4tx.mine_box(GameSvrId=game_server_id,
                    dtEventTime=xtime.strdatetime(),
                    GameAppID=game_app_id,
                    OpenID=player_data.base_info.id,
                    PlatID=plat_id)


def mine_reset(player_data, reset_times, reset_pos):

    log4tx.mine_reset(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,
                      ResetTimes=reset_times,
                      ResetPos=reset_pos)


def overcome_reset(player_data, reset_times):

    log4tx.overcome_reset(GameSvrId=game_server_id,
                          dtEventTime=xtime.strdatetime(),
                          GameAppID=game_app_id,
                          OpenID=player_data.base_info.id,
                          PlatID=plat_id,
                          ResetTimes=reset_times)


def overcome_award(player_data, index):

    log4tx.overcome_award(GameSvrId=game_server_id,
                          dtEventTime=xtime.strdatetime(),
                          GameAppID=game_app_id,
                          OpenID=player_data.base_info.id,
                          PlatID=plat_id,
                          Index=index)


def overcome_Buy_Buff(player_data, num, buff_type, value_type, value):

    log4tx.overcome_Buy_Buff(GameSvrId=game_server_id,
                             dtEventTime=xtime.strdatetime(),
                             GameAppID=game_app_id,
                             OpenID=player_data.base_info.id,
                             PlatID=plat_id,
                             Num=num,
                             BuffType=buff_type,
                             ValueType=value_type,
                             Value=value)


def compose_treasure(player_data, equ_no, equ_id):

    log4tx.compose_treasure(GameSvrId=game_server_id,
                            dtEventTime=xtime.strdatetime(),
                            GameAppID=game_app_id,
                            OpenID=player_data.base_info.id,
                            PlatID=plat_id,
                            EquNo=equ_no,
                            EquID=equ_id)


def rob_treasure_truce(player_data, num, num_day):

    log4tx.rob_treasure_truce(GameSvrId=game_server_id,
                              dtEventTime=xtime.strdatetime(),
                              GameAppID=game_app_id,
                              OpenID=player_data.base_info.id,
                              PlatID=plat_id,
                              Num=num,
                              NumDay=num_day)


def world_boss_rank_reward(player_id, rank, damage, mail_id):

    log4tx.world_boss_rank_reward(GameSvrId=game_server_id,
                                  dtEventTime=xtime.strdatetime(),
                                  GameAppID=game_app_id,
                                  OpenID=player_id,
                                  PlatID=plat_id,
                                  Rank=rank,
                                  Damage=damage,
                                  MailID=mail_id)


def world_boss_add_up_reward(player_id, damage, mail_id):

    log4tx.world_boss_add_up_reward(GameSvrId=game_server_id,
                                    dtEventTime=xtime.strdatetime(),
                                    GameAppID=game_app_id,
                                    OpenID=player_id,
                                    PlatID=plat_id,
                                    Damage=damage,
                                    MailID=mail_id)


def world_boss_in_reward(player_id, mail_id):

    log4tx.world_boss_in_reward(GameSvrId=game_server_id,
                                dtEventTime=xtime.strdatetime(),
                                GameAppID=game_app_id,
                                OpenID=player_id,
                                PlatID=plat_id,
                                MailID=mail_id)


def world_boss_encourage(player_data, type, times):

    log4tx.world_boss_encourage(GameSvrId=game_server_id,
                                dtEventTime=xtime.strdatetime(),
                                GameAppID=game_app_id,
                                OpenID=player_data.base_info.id,
                                PlatID=plat_id,
                                Type=type,
                                Times=times)


def up_guide(player_data, id):

    log4tx.up_guide(GameSvrId=game_server_id,
                    dtEventTime=xtime.strdatetime(),
                    GameAppID=game_app_id,
                    OpenID=player_data.base_info.id,
                    PlatID=plat_id,
                    ID=id)


def unpar_upgrade(player_data, level):

    log4tx.unpar_upgrade(GameSvrId=game_server_id,
                         dtEventTime=xtime.strdatetime(),
                         GameAppID=game_app_id,
                         OpenID=player_data.base_info.id,
                         PlatID=plat_id,
                         Level=level)


def captain_receive_zan(player_data, guild_id, num, money_num):

    log4tx.captain_receive_zan(GameSvrId=game_server_id,
                               dtEventTime=xtime.strdatetime(),
                               GameAppID=game_app_id,
                               OpenID=player_data.base_info.id,
                               PlatID=plat_id,
                               GuildID=guild_id,
                               Num=num,
                               MoneyNum=money_num)


def mine_help(player_data, guild_id, be_help_ids):

    log4tx.mine_help(GameSvrId=game_server_id,
                     dtEventTime=xtime.strdatetime(),
                     GameAppID=game_app_id,
                     OpenID=player_data.base_info.id,
                     PlatID=plat_id,
                     GuildID=guild_id,
                     BeHelpIds=be_help_ids)


def trigger_boss(player_data, guild_id, boss_type):

    log4tx.trigger_boss(GameSvrId=game_server_id,
                        dtEventTime=xtime.strdatetime(),
                        GameAppID=game_app_id,
                        OpenID=player_data.base_info.id,
                        PlatID=plat_id,
                        GuildID=guild_id,
                        BossType=boss_type)


def guild_boss_battle(player_data, guild_id, boss_type, result):

    log4tx.guild_boss_battle(GameSvrId=game_server_id,
                             dtEventTime=xtime.strdatetime(),
                             GameAppID=game_app_id,
                             OpenID=player_data.base_info.id,
                             PlatID=plat_id,
                             GuildID=guild_id,
                             BossType=boss_type,
                             Result=result)


def upgrade_guild_skill(player_data, guild_id, skill_type, level, num):

    log4tx.upgrade_guild_skill(GameSvrId=game_server_id,
                               dtEventTime=xtime.strdatetime(),
                               GameAppID=game_app_id,
                               OpenID=player_data.base_info.id,
                               PlatID=plat_id,
                               GuildID=guild_id,
                               SkillType=skill_type,
                               Level=level,
                               Num=num)


def refresh_escort_tasks(player_data, times):

    log4tx.refresh_escort_tasks(GameSvrId=game_server_id,
                                dtEventTime=xtime.strdatetime(),
                                GameAppID=game_app_id,
                                OpenID=player_data.base_info.id,
                                PlatID=plat_id,
                                Times=times)


def receive_rob_escort_task(player_data, task_id, task_guild_id):

    log4tx.receive_rob_escort_task(GameSvrId=game_server_id,
                                   dtEventTime=xtime.strdatetime(),
                                   GameAppID=game_app_id,
                                   OpenID=player_data.base_info.id,
                                   PlatID=plat_id,
                                   TaskID=task_id,
                                   TaskGuildID=task_guild_id)


def receive_escort_task(player_data, task_id):

    log4tx.receive_escort_task(GameSvrId=game_server_id,
                               dtEventTime=xtime.strdatetime(),
                               GameAppID=game_app_id,
                               OpenID=player_data.base_info.id,
                               PlatID=plat_id,
                               TaskID=task_id)


def cancel_escort_task(player_data, task_id, task_guild_id):

    log4tx.cancel_escort_task(GameSvrId=game_server_id,
                              dtEventTime=xtime.strdatetime(),
                              GameAppID=game_app_id,
                              OpenID=player_data.base_info.id,
                              PlatID=plat_id,
                              TaskID=task_id,
                              TaskGuildID=task_guild_id)


def guild_task_invite(player_data, task_id, task_guild_id, send_or_in,
                      protect_or_rob, rob_no):

    log4tx.guild_task_invite(GameSvrId=game_server_id,
                             dtEventTime=xtime.strdatetime(),
                             GameAppID=game_app_id,
                             OpenID=player_data.base_info.id,
                             PlatID=plat_id,
                             TaskID=task_id,
                             TaskGuildID=task_guild_id,
                             SendOrIn=send_or_in,
                             ProtectOrRob=protect_or_rob,
                             RobNo=rob_no)


def start_protect_escort(player_data, task_id, task_guild_id):

    log4tx.start_protect_escort(GameSvrId=game_server_id,
                                dtEventTime=xtime.strdatetime(),
                                GameAppID=game_app_id,
                                OpenID=player_data.base_info.id,
                                PlatID=plat_id,
                                TaskID=task_id,
                                TaskGuildID=task_guild_id)


def start_rob_escort(player_data, task_id, task_guild_id):

    log4tx.start_rob_escort(GameSvrId=game_server_id,
                            dtEventTime=xtime.strdatetime(),
                            GameAppID=game_app_id,
                            OpenID=player_data.base_info.id,
                            PlatID=plat_id,
                            TaskID=task_id,
                            TaskGuildID=task_guild_id)


def join_guild(player_data, guild_id):

    log4tx.join_guild(GameSvrId=game_server_id,
                      dtEventTime=xtime.strdatetime(),
                      GameAppID=game_app_id,
                      OpenID=player_data.base_info.id,
                      PlatID=plat_id,
                      GuildID=guild_id)


def refresh_shop(player_data, shop_type, times):

    log4tx.refresh_shop(GameSvrId=game_server_id,
                        dtEventTime=xtime.strdatetime(),
                        GameAppID=game_app_id,
                        OpenID=player_data.base_info.id,
                        PlatID=plat_id,
                        ShopType=shop_type,
                        Times=times)


def shop_buy1(player_data, shop_id):

    log4tx.shop_buy1(GameSvrId=game_server_id,
                     dtEventTime=xtime.strdatetime(),
                     GameAppID=game_app_id,
                     OpenID=player_data.base_info.id,
                     PlatID=plat_id,
                     ShopID=shop_id)


def shop_buy(player_data, ids, items_count):

    log4tx.shop_buy(GameSvrId=game_server_id,
                    dtEventTime=xtime.strdatetime(),
                    GameAppID=game_app_id,
                    OpenID=player_data.base_info.id,
                    PlatID=plat_id,
                    Ids=ids,
                    ItemsCount=items_count)


def buy_stamina(player_data, resource_type, num):

    log4tx.buy_stamina(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,
                       ResourceType=resource_type,
                       Num=num)


def reset_stage(player_data, stage_id, times):

    log4tx.reset_stage(GameSvrId=game_server_id,
                       dtEventTime=xtime.strdatetime(),
                       GameAppID=game_app_id,
                       OpenID=player_data.base_info.id,
                       PlatID=plat_id,
                       StageID=stage_id,
                       Times=times)


# TLOG分类打印函数

tlog_funcs = {}
tlog_funcs['PlayerLogin'] = player_login
tlog_funcs['PlayerLogout'] = player_logout
tlog_funcs['PlayerRegister'] = player_register
tlog_funcs['ItemFlow'] = item_flow
tlog_funcs['PlayerExpFlow'] = player_exp_flow
tlog_funcs['LineUpChange'] = line_up_change
tlog_funcs['HeroBreak'] = hero_break
tlog_funcs['Inherit'] = inherit
tlog_funcs['StageFlow'] = stage_flow
tlog_funcs['SweepFlow'] = sweep_flow
tlog_funcs['CreatGuild'] = creat_guild
tlog_funcs['DealJoinGuild'] = deal_join_guild
tlog_funcs['ExitGuild'] = exit_guild
tlog_funcs['GuildChangePresident'] = guild_change_president
tlog_funcs['GuildKick'] = guild_kick
tlog_funcs['GuildPromotion'] = guild_promotion
tlog_funcs['GuildWorship'] = guild_worship
tlog_funcs['GuildWorshipGift'] = guild_worship_gift
tlog_funcs['TravelSettle'] = travel_settle
tlog_funcs['AutoTravel'] = auto_travel
tlog_funcs['HeroRefine'] = hero_refine
tlog_funcs['HeroUpgrade'] = hero_upgrade
tlog_funcs['Recharge'] = recharge
tlog_funcs['RoundFlow'] = round_flow
tlog_funcs['NewGuide'] = new_guide
tlog_funcs['OnlineNum'] = online_num
tlog_funcs['MoneyFlow'] = money_flow
tlog_funcs['ItemMoneyFlow'] = item_money_flow
tlog_funcs['HeroSacrifice'] = hero_sacrifice
tlog_funcs['EquipmentEnhance'] = equipment_enhance
tlog_funcs['EquipmentCompose'] = equipment_compose
tlog_funcs['EquipmentMelting'] = equipment_melting

tlog_funcs['CreateNickname'] = create_nickname
tlog_funcs['StartTargetGetGift'] = start_target_get_gift
tlog_funcs['SignIn'] = sign_in
tlog_funcs['ContinusSignIn'] = continus_sign_in
tlog_funcs['RepairSignIn'] = repair_sign_in
tlog_funcs['SignInBox'] = sign_in_box
tlog_funcs['OnlineGift'] = online_gift
tlog_funcs['LoginGift'] = login_gift
tlog_funcs['Feast'] = feast
tlog_funcs['Activity'] = activity
tlog_funcs['LevelGift'] = level_gift
tlog_funcs['Share'] = share
tlog_funcs['DrawRebate'] = draw_rebate
tlog_funcs['BuyCoin'] = buy_coin
tlog_funcs['GodHeroExchange'] = god_hero_exchange
tlog_funcs['TriggerHJQY'] = trigger_hjqy
tlog_funcs['BattleHJQY'] = battle_hjqy
tlog_funcs['OpenChest'] = open_chest
tlog_funcs['OpenStarChest'] = open_star_chest
tlog_funcs['StarRandom'] = star_random
tlog_funcs['DealStarRandom'] = deal_star_random
tlog_funcs['HeroRuntSet'] = hero_runt_set
tlog_funcs['HeroRuntPick'] = hero_runt_pick
tlog_funcs['MakeRunt'] = make_runt
tlog_funcs['HeroAwake'] = hero_awake
tlog_funcs['BuyEliteStageTimes'] = buy_elite_stage_times
tlog_funcs['PvpDailyAward'] = pvp_daily_award
tlog_funcs['MineHarvest'] = mine_harvest
tlog_funcs['MineAcc'] = mine_acc
tlog_funcs['MineAccelerate'] = mine_accelerate
tlog_funcs['MineBox'] = mine_box
tlog_funcs['MineReset'] = mine_reset
tlog_funcs['OvercomeReset'] = overcome_reset
tlog_funcs['OvercomeAward'] = overcome_award
tlog_funcs['OvercomeBuyBuff'] = overcome_Buy_Buff
tlog_funcs['ComposeTreasure'] = compose_treasure
tlog_funcs['RobTreasureTruce'] = rob_treasure_truce
tlog_funcs['WorldBossRankReward'] = world_boss_rank_reward
tlog_funcs['WorldBossAddUpReward'] = world_boss_add_up_reward
tlog_funcs['WorldBossInReward'] = world_boss_in_reward
tlog_funcs['WorldBossEncourage'] = world_boss_encourage
tlog_funcs['UnparUpgrade'] = unpar_upgrade
tlog_funcs['UpGuide'] = up_guide
tlog_funcs['CaptainReceiveZan'] = captain_receive_zan
tlog_funcs['GuildBuildUp'] = guild_build_up
tlog_funcs['MineHelp'] = mine_help
tlog_funcs['TriggerBoss'] = trigger_boss
tlog_funcs['GuildBossBattle'] = guild_boss_battle
tlog_funcs['UpgradeGuildSkill'] = upgrade_guild_skill
tlog_funcs['RefreshEscortTasks'] = refresh_escort_tasks
tlog_funcs['ReceiveEscortTask'] = receive_escort_task
tlog_funcs['ReceiveRobEscortTask'] = receive_rob_escort_task
tlog_funcs['CancelEscortTask'] = cancel_escort_task
tlog_funcs['GuildTaskInvite'] = guild_task_invite
tlog_funcs['StartProtectEscort'] = start_protect_escort
tlog_funcs['StartRobEscort'] = start_rob_escort
tlog_funcs['JoinGuild'] = join_guild
tlog_funcs['RefreshShop'] = refresh_shop
tlog_funcs['ShopBuy'] = shop_buy
tlog_funcs['ShopBuy1'] = shop_buy1
tlog_funcs['BuyStamina'] = buy_stamina
tlog_funcs['ResetStage'] = reset_stage


def log(mod, *args, **kwds):
    """
    打印TLOG
    """
    # try:
    tlog_funcs[mod](*args, **kwds)
    # except:
    #     pass
    #     log_except(mod)
