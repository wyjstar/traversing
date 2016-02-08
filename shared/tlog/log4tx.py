# coding: utf-8

from shared.tlog import logclient
from gfirefly.server.logobj import logger

debug = 1
LOG_FOR_SELF = 1


def _format(message):
    return '|'.join(map(str, message))


def equipment_compose(GameSvrId=0, dtEventTime=0, GameAppID=0,
                      PlatID=0, OpenID=0, EquipmentNo=0, EquipmentId=0):

    message = ['EquipmentCompose']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(EquipmentNo)
    message.append(EquipmentId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def equipment_enhance(GameSvrId=0, dtEventTime=0, GameAppID=0,
                      PlatID=0, OpenID=0, EquipmentNo=0, EquipmentId=0,
                      BeforeLevel=0, AfterLevel=0):

    message = ['EquipmentEnhance']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(EquipmentNo)
    message.append(EquipmentId)
    message.append(BeforeLevel)
    message.append(AfterLevel)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def line_up_change(GameSvrId=0, dtEventTime=0, GameAppID=0,
                   PlatID=0, OpenID=0, Slot=0, HeroId=0, AfterHeroId=0,
                   ChangeType=0):

    message = ['LineUpChange']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Slot)
    message.append(HeroId)
    message.append(AfterHeroId)
    message.append(ChangeType)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def hero_break(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, HeroId=0, Level=0):

    message = ['HeroBreak']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HeroId)
    message.append(Level)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def hero_sacrifice(GameSvrId=0, dtEventTime=0, GameAppID=0,
                   PlatID=0, OpenID=0, HeroId=0):

    message = ['HeroSacrifice']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HeroId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def inherit(GameSvrId=0, dtEventTime=0, GameAppID=0,
            PlatID=0, OpenID=0, InheritType=0, OriginId=0, OriginItemId=0,
            TargetId=0, TargetItemId=0, InheritValue=0):

    message = ['Inherit']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(InheritType)
    message.append(OriginId)
    message.append(OriginItemId)
    message.append(TargetId)
    message.append(TargetItemId)
    message.append(InheritValue)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def stage_flow(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, StageId=0, Result=0):

    message = ['StageFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageId)
    message.append(Result)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def sweep_flow(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, StageId=0, Times=0, ReasonEventID=0):

    message = ['SweepFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageId)
    message.append(Times)
    message.append(ReasonEventID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def guild_build_up(GameSvrId=0, dtEventTime=0, GameAppID=0,
                   PlatID=0, OpenID=0, GuildId=0, BuildLevel=0,
                   BuildType=0):

    message = ['GuildBuildUp']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(BuildLevel)
    message.append(BuildType)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def creat_guild(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, GuildId=0, UserLevel=0,
                Icon=0):

    message = ['CreatGuild']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(UserLevel)
    message.append(Icon)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def deal_join_guild(GameSvrId=0, dtEventTime=0, GameAppID=0,
                    PlatID=0, OpenID=0, GuildId=0, BeHandler=0, ResType=0):

    message = ['DealJoinGuild']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(BeHandler)
    message.append(ResType)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def exit_guild(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, GuildId=0):

    message = ['ExitGuild']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def guild_change_president(GameSvrId=0, dtEventTime=0, GameAppID=0,
                           PlatID=0, OpenID=0, GuildId=0, TargetId=0):

    message = ['GuildChangePresident']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(TargetId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def guild_kick(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, GuildId=0, TargetId=0):

    message = ['GuildKick']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(TargetId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def guild_promotion(GameSvrId=0, dtEventTime=0, GameAppID=0,
                    PlatID=0, OpenID=0, GuildId=0, BeId=0):

    message = ['GuildPromotion']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(BeId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def guild_worship(GameSvrId=0, dtEventTime=0, GameAppID=0,
                  PlatID=0, OpenID=0, GuildId=0, WorshipType=0,
                  WorshipTimes=0):

    message = ['GuildWorship']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(WorshipType)
    message.append(WorshipTimes)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def guild_worship_gift(GameSvrId=0, dtEventTime=0, GameAppID=0,
                       PlatID=0, OpenID=0, GuildId=0, BuildLevel=0,
                       GiftNo=0):

    message = ['GuildWorshipGift']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(BuildLevel)
    message.append(GiftNo)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def travel_settle(GameSvrId=0, dtEventTime=0, GameAppID=0,
                  PlatID=0, OpenID=0, Stage=0, EventId=0,
                  Parameter=0, Res=0, IsFastSettle=0):

    message = ['TravelSettle']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Stage)
    message.append(EventId)
    message.append(Parameter)
    message.append(Res)
    message.append(IsFastSettle)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def auto_travel(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, Stage=0, Time=0):

    message = ['AutoTravel']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Stage)
    message.append(Time)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def hero_upgrade(GameSvrId=0, dtEventTime=0, GameAppID=0,
                 PlatID=0, OpenID=0, HeroId=0, ChangeLevel=0,
                 Level=0, Type=0, ExpItemNum1=0, ExpItemNum2=0,
                 ExpItemNum3=0, ExpItemNo=0):

    message = ['HeroUpgrade']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HeroId)
    message.append(ChangeLevel)
    message.append(Level)
    message.append(Type)
    message.append(ExpItemNum1)
    message.append(ExpItemNum2)
    message.append(ExpItemNum3)
    message.append(ExpItemNo)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def hero_refine(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, HeroId=0, Refine=0):

    message = ['HeroRefine']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HeroId)
    message.append(Refine)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_register(GameSvrId=0, dtEventTime=0, GameAppID=0,
                    PlatID=0, OpenID=0, ClientVersion=0,
                    SystemSoftware=0, SystemHardware=0, TelecomOper=0,
                    Network=0, ScreenWidth=0, ScreenHight=0, Density=0,
                    RegChannel=0, UUID=0, CpuHardware=0, Memory=0, GLRender=0,
                    GLVersion=0, DeviceId=0, Nickname=0, IP=0):

    message = ['PlayerRegister']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(ClientVersion)
    message.append(SystemSoftware)
    message.append(SystemHardware)
    message.append(TelecomOper)
    message.append(Network)
    message.append(ScreenWidth)
    message.append(ScreenHight)
    message.append(Density)
    message.append(RegChannel)
    message.append(UUID)
    message.append(CpuHardware)
    message.append(Memory)
    message.append(GLRender)
    message.append(GLVersion)
    message.append(DeviceId)
    message.append(Nickname)
    message.append(IP)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_login(GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0,
                 Level=0, PlayerFriendsNum=0, ClientVersion=0,
                 SystemSoftware=0, SystemHardware=0, TelecomOper=0, Network=0,
                 ScreenWidth=0, ScreenHight=0, Density=0, LoginChannel=0,
                 UUID=0, CpuHardware=0, Memory=0, GLRender=0,
                 GLVersion=0, DeviceId=0, IP=0):

    message = ['PlayerLogin']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Level)
    message.append(PlayerFriendsNum)
    message.append(ClientVersion)
    message.append(SystemSoftware)
    message.append(SystemHardware)
    message.append(TelecomOper)
    message.append(Network)
    message.append(ScreenWidth)
    message.append(ScreenHight)
    message.append(Density)
    message.append(LoginChannel)
    message.append(UUID)
    message.append(CpuHardware)
    message.append(Memory)
    message.append(GLRender)
    message.append(GLVersion)
    message.append(DeviceId)
    message.append(IP)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_logout(GameSvrId=0, dtEventTime=0, GameAppID=0, OpenID=0,
                  OnlineTime=0, Level=0, PlatID=0, ClientVersion=0,
                  SystemSoftware=0, SystemHardware=0, TelecomOper=0, Network=0,
                  ScreenWidth=0, ScreenHight=0, Density=0, Channel=0, UUID=0,
                  CpuHardware=0, Memory=0, GLRender=0, GLVersion=0,
                  DeviceId=0, PlayerFriendsNum=0):

    message = ['PlayerLogout']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(OnlineTime)
    message.append(Level)
    message.append(PlayerFriendsNum)
    message.append(ClientVersion)
    message.append(SystemSoftware)
    message.append(SystemHardware)
    message.append(TelecomOper)
    message.append(Network)
    message.append(ScreenWidth)
    message.append(ScreenHight)
    message.append(Density)
    message.append(Channel)
    message.append(UUID)
    message.append(CpuHardware)
    message.append(Memory)
    message.append(GLRender)
    message.append(GLVersion)
    message.append(DeviceId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_flow(PlatID=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0,
              OpenID=0, ItemType=0, ItemID=0, AfterCount=0, Count=0,
              Reason=0, SubReason=0, ReasonEventID=0, AddOrReduce=0, Itid=0):

    message = ['ItemFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(ItemType)
    message.append(ItemID)
    message.append(AfterCount)
    message.append(Count)
    message.append(Reason)
    message.append(SubReason)
    message.append(ReasonEventID)
    message.append(AddOrReduce)
    message.append(Itid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def recharge(GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0,
             OpenID=0, Isfirst=0, RechargeId=0, Channel=0):

    message = ['Recharge']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Isfirst)
    message.append(RechargeId)
    message.append(Channel)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_exp_flow(GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0,
                    OpenID=0, ExpChange=0, BeforeLevel=0, AfterLevel=0,
                    Time=0, Reason=0, SubReason=0, Exp=0):

    message = ['PlayerExpFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(ExpChange)
    message.append(BeforeLevel)
    message.append(AfterLevel)
    message.append(Time)
    message.append(Reason)
    message.append(SubReason)
    message.append(Exp)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def round_flow(GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0,
               OpenID=0, BattleID=0, BattleType=0, isQuick=0, Result=0,
               Score=0, Rank=0, Gold=0, ExpChange=0, BattleSoleId=0):

    message = ['RoundFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(BattleID)
    message.append(BattleType)
    message.append(isQuick)
    message.append(Result)
    message.append(Score)
    message.append(Rank)
    message.append(Gold)
    message.append(ExpChange)
    message.append(BattleSoleId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def new_guide(GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0,
               OpenID=0, Sequence=0, MySequence=0):

    message = ['NewGuide']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Sequence)
    message.append(MySequence)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def online_num(GameSvrId=0, dtEventTime=0, GameAppID=0,
               Num=0):

    message = ['OnlineNum']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)

    message.append(Num)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def money_flow(PlatID=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0,
               OpenID=0, Level=0, AfterMoney=0, Money=0, Reason=0, SubReason=0,
               ReasonEventID=0, AddOrReduce=0, MoneyType=0, itemId=0, itemAmount=0):

    message = ['MoneyFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Level)
    message.append(AfterMoney)
    message.append(Money)
    message.append(Reason)
    message.append(SubReason)
    message.append(ReasonEventID)
    message.append(AddOrReduce)
    message.append(MoneyType)
    message.append(itemId)
    message.append(itemAmount)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_money_flow(PlatID=0, GameSvrId=0, dtEventTime=0, Sequence=0,
                    GameAppID=0, OpenID=0, ItemType=0, ItemID=0,
                    Count=0, Money=0, Level=0, MoneyType=0,
                    DiscountMoney=0, DiscountMoneyType=0,
                    LimitVipEveryday=0, LimitVip=0, IsDiscount=0):

    message = ['ItemMoneyFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemType)
    message.append(ItemID)
    message.append(Count)
    message.append(Money)
    message.append(Level)
    message.append(MoneyType)
    message.append(DiscountMoney)
    message.append(DiscountMoneyType)
    message.append(LimitVipEveryday)
    message.append(LimitVip)
    message.append(IsDiscount)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def equipment_melting(GameSvrId=0, dtEventTime=0, GameAppID=0,
                      PlatID=0, OpenID=0, EquipmentNo=0, EquipmentId=0):

    message = ['EquipmentMelting']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(EquipmentNo)
    message.append(EquipmentId)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def create_nickname(GameSvrId=0, dtEventTime=0, GameAppID=0,
                    PlatID=0, OpenID=0, Nickname=0):

    message = ['CreateNickname']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Nickname)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def start_target_get_gift(GameSvrId=0, dtEventTime=0, GameAppID=0,
                          PlatID=0, OpenID=0, TargetID=0):

    message = ['StartTargetGetGift']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(TargetID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def sign_in(GameSvrId=0, dtEventTime=0, GameAppID=0,
            PlatID=0, OpenID=0, Day=0, IsDouble=0, ConfigID=0):

    message = ['SignIn']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Day)
    message.append(IsDouble)
    message.append(ConfigID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def continus_sign_in(GameSvrId=0, dtEventTime=0, GameAppID=0,
                     PlatID=0, OpenID=0, Day=0, ConfigID=0):

    message = ['ContinusSignIn']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Day)
    message.append(ConfigID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def repair_sign_in(GameSvrId=0, dtEventTime=0, GameAppID=0,
                   PlatID=0, OpenID=0, Day=0, Day1=0, ConfigID=0):

    message = ['RepairSignIn']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Day)
    message.append(Day1)
    message.append(ConfigID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def sign_in_box(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, BoxID=0, ConfigID=0):

    message = ['SignInBox']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(BoxID)
    message.append(ConfigID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def online_gift(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, GiftID=0):

    message = ['OnlineGift']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GiftID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def login_gift(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, ActivityID=0):

    message = ['LoginGift']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ActivityID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def feast(GameSvrId=0, dtEventTime=0, GameAppID=0,
          PlatID=0, OpenID=0, Stamina=0):

    message = ['Feast']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Stamina)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def activity(GameSvrId=0, dtEventTime=0, GameAppID=0,
             PlatID=0, OpenID=0, ActivityID=0, Arg=0):

    message = ['Activity']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ActivityID)
    message.append(Arg)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def level_gift(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, ActivityID=0, Level=0):

    message = ['LevelGift']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ActivityID)
    message.append(Level)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def share(GameSvrId=0, dtEventTime=0, GameAppID=0,
          PlatID=0, OpenID=0, TaskID=0, ShareType=0):

    message = ['Share']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(TaskID)
    message.append(ShareType)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def draw_rebate(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, RebateID=0):

    message = ['DrawRebate']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(RebateID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def buy_coin(GameSvrId=0, dtEventTime=0, GameAppID=0,
             PlatID=0, OpenID=0, NeedGold=0, BuyTimes=0, CoinNum=0):

    message = ['BuyCoin']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(NeedGold)
    message.append(BuyTimes)
    message.append(CoinNum)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def god_hero_exchange(GameSvrId=0, dtEventTime=0, GameAppID=0,
                      PlatID=0, OpenID=0, ActivityID=0, ExchangeNum=0):

    message = ['GodHeroExchange']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ActivityID)
    message.append(ExchangeNum)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def trigger_hjqy(GameSvrId=0, dtEventTime=0, GameAppID=0,
                 PlatID=0, OpenID=0, StageID=0, HJQYStageID=0):

    message = ['TriggerHJQY']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageID)
    message.append(HJQYStageID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def battle_hjqy(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, BossID=0, IsKill=0):

    message = ['TriggerHJQY']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(BossID)
    message.append(IsKill)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def open_chest(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, StageID=0, StageType=0):

    message = ['OpenChest']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageID)
    message.append(StageType)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def open_star_chest(GameSvrId=0, dtEventTime=0, GameAppID=0,
                    PlatID=0, OpenID=0, ChapterID=0, AwardType=0):

    message = ['OpenStarChest']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ChapterID)
    message.append(AwardType)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def star_random(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, RandomNum=0, Times=0,
                ChapterID=0):

    message = ['StarRandom']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(RandomNum)
    message.append(Times)
    message.append(ChapterID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def deal_star_random(GameSvrId=0, dtEventTime=0, GameAppID=0,
                     PlatID=0, OpenID=0, RandomNum=0, DealType=0, ChapterID=0):

    message = ['DealStarRandom']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(RandomNum)
    message.append(DealType)
    message.append(ChapterID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def hero_runt_set(GameSvrId=0, dtEventTime=0, GameAppID=0,
                  PlatID=0, OpenID=0, HeroId=0,
                  Now=0, RuntNo=0, RuntPo=0, RuntID=0):

    message = ['HeroRuntSet']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HeroId)
    message.append(Now)
    message.append(RuntNo)
    message.append(RuntPo)
    message.append(RuntID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def hero_runt_pick(GameSvrId=0, dtEventTime=0, GameAppID=0,
                   PlatID=0, OpenID=0, HeroID=0, RuntType=0,
                   Now=0, RuntNo=0, RuntPo=0, RuntID=0):

    message = ['HeroRuntPick']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HeroID)
    message.append(RuntType)
    message.append(Now)
    message.append(RuntNo)
    message.append(RuntPo)
    message.append(RuntID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def make_runt(GameSvrId=0, dtEventTime=0, GameAppID=0,
              PlatID=0, OpenID=0, RuntID1=0, RuntID2=0,
              RuntID3=0, RuntID4=0, RuntID5=0, Num=0,
              ResRuntID=0, ResRuntNo=0):

    message = ['MakeRunt']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(RuntID1)
    message.append(RuntID2)
    message.append(RuntID3)
    message.append(RuntID4)
    message.append(RuntID5)
    message.append(Num)
    message.append(ResRuntID)
    message.append(ResRuntNo)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def hero_awake(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, HeroID=0, Num=0,
               Level=0):

    message = ['HeroAwake']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HeroID)
    message.append(Num)
    message.append(Level)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def buy_elite_stage_times(GameSvrId=0, dtEventTime=0, GameAppID=0,
                          PlatID=0, OpenID=0, BuyTimes=0, Num=0,
                          GoldNum=0):

    message = ['BuyEliteStageTimes']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(BuyTimes)
    message.append(Num)
    message.append(GoldNum)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def pvp_daily_award(GameSvrId=0, dtEventTime=0, GameAppID=0,
                    PlatID=0, OpenID=0, MailID=0, Rank=0):

    message = ['PvpDailyAward']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(MailID)
    message.append(Rank)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def mine_harvest(GameSvrId=0, dtEventTime=0, GameAppID=0,
                 PlatID=0, OpenID=0, Position=0, Normal=0, Lucky=0):

    message = ['MineHarvest']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Position)
    message.append(Normal)
    message.append(Lucky)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def mine_acc(GameSvrId=0, dtEventTime=0, GameAppID=0,
             PlatID=0, OpenID=0, LastTime=0):

    message = ['MineAcc']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(LastTime)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def mine_accelerate(GameSvrId=0, dtEventTime=0, GameAppID=0,
                    PlatID=0, OpenID=0, GoldNum=0):

    message = ['MineAccelerate']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GoldNum)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def mine_box(GameSvrId=0, dtEventTime=0, GameAppID=0,
             PlatID=0, OpenID=0):

    message = ['MineBox']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def mine_reset(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, ResetTimes=0, ResetPos=0):

    message = ['MineReset']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ResetTimes)
    message.append(ResetPos)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def overcome_reset(GameSvrId=0, dtEventTime=0, GameAppID=0,
                   PlatID=0, OpenID=0, ResetTimes=0):

    message = ['OvercomeReset']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ResetTimes)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def overcome_award(GameSvrId=0, dtEventTime=0, GameAppID=0,
                   PlatID=0, OpenID=0, Index=0):

    message = ['OvercomeAward']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Index)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def overcome_Buy_Buff(GameSvrId=0, dtEventTime=0, GameAppID=0,
                      PlatID=0, OpenID=0, Num=0, BuffType=0,
                      ValueType=0, Value=0):

    message = ['OvercomeBuyBuff']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Num)
    message.append(BuffType)
    message.append(ValueType)
    message.append(Value)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def compose_treasure(GameSvrId=0, dtEventTime=0, GameAppID=0,
                     PlatID=0, OpenID=0, EquNo=0, EquID=0):

    message = ['ComposeTreasure']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(EquNo)
    message.append(EquID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def rob_treasure_truce(GameSvrId=0, dtEventTime=0, GameAppID=0,
                       PlatID=0, OpenID=0, Num=0, NumDay=0):

    message = ['RobTreasureTruce']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Num)
    message.append(NumDay)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def world_boss_rank_reward(GameSvrId=0, dtEventTime=0, GameAppID=0,
                           PlatID=0, OpenID=0, Rank=0, Damage=0,
                           MailID=0):

    message = ['WorldBossRankReward']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Rank)
    message.append(Damage)
    message.append(MailID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def world_boss_add_up_reward(GameSvrId=0, dtEventTime=0, GameAppID=0,
                             PlatID=0, OpenID=0, Damage=0, MailID=0):

    message = ['WorldBossAddUpReward']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Damage)
    message.append(MailID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def world_boss_in_reward(GameSvrId=0, dtEventTime=0, GameAppID=0,
                         PlatID=0, OpenID=0, MailID=0):

    message = ['WorldBossInReward']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(MailID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def world_boss_encourage(GameSvrId=0, dtEventTime=0, GameAppID=0,
                         PlatID=0, OpenID=0, Type=0, Times=0):

    message = ['WorldBossEncourage']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Type)
    message.append(Times)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def unpar_upgrade(GameSvrId=0, dtEventTime=0, GameAppID=0,
                  PlatID=0, OpenID=0, Level=0):

    message = ['UnparUpgrade']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Level)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def up_guide(GameSvrId=0, dtEventTime=0, GameAppID=0,
             PlatID=0, OpenID=0, ID=0):

    message = ['UpGuide']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def captain_receive_zan(GameSvrId=0, dtEventTime=0, GameAppID=0,
                        PlatID=0, OpenID=0, GuildID=0, Num=0,
                        MoneyNum=0):

    message = ['CaptainReceiveZan']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildID)
    message.append(Num)
    message.append(MoneyNum)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def mine_help(GameSvrId=0, dtEventTime=0, GameAppID=0,
              PlatID=0, OpenID=0, GuildID=0, BeHelpIds=0):

    message = ['MineHelp']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildID)
    message.append(BeHelpIds)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def trigger_boss(GameSvrId=0, dtEventTime=0, GameAppID=0,
                 PlatID=0, OpenID=0, GuildID=0, BossType=0):

    message = ['TriggerBoss']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildID)
    message.append(BossType)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def guild_boss_battle(GameSvrId=0, dtEventTime=0, GameAppID=0,
                      PlatID=0, OpenID=0, GuildID=0, BossType=0,
                      Result=0):

    message = ['GuildBossBattle']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildID)
    message.append(BossType)
    message.append(Result)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def upgrade_guild_skill(GameSvrId=0, dtEventTime=0, GameAppID=0,
                        PlatID=0, OpenID=0, GuildID=0, SkillType=0,
                        Level=0, Num=0):

    message = ['UpgradeGuildSkill']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildID)
    message.append(SkillType)
    message.append(Level)
    message.append(Num)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def refresh_escort_tasks(GameSvrId=0, dtEventTime=0, GameAppID=0,
                         PlatID=0, OpenID=0, Times=0):

    message = ['RefreshEscortTasks']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Times)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def receive_escort_task(GameSvrId=0, dtEventTime=0, GameAppID=0,
                        PlatID=0, OpenID=0, TaskID=0):

    message = ['ReceiveEscortTask']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(TaskID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def receive_rob_escort_task(GameSvrId=0, dtEventTime=0, GameAppID=0,
                            PlatID=0, OpenID=0, TaskID=0, TaskGuildID=0):

    message = ['ReceiveRobEscortTask']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(TaskID)
    message.append(TaskGuildID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def cancel_escort_task(GameSvrId=0, dtEventTime=0, GameAppID=0,
                       PlatID=0, OpenID=0, TaskID=0, TaskGuildID=0):

    message = ['CancelEscortTask']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(TaskID)
    message.append(TaskGuildID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def guild_task_invite(GameSvrId=0, dtEventTime=0, GameAppID=0,
                      PlatID=0, OpenID=0, TaskID=0, TaskGuildID=0,
                      SendOrIn=0, ProtectOrRob=0, RobNo=0):

    message = ['GuildTaskInvite']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(TaskID)
    message.append(TaskGuildID)
    message.append(SendOrIn)
    message.append(ProtectOrRob)
    message.append(RobNo)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def start_protect_escort(GameSvrId=0, dtEventTime=0, GameAppID=0,
                         PlatID=0, OpenID=0, TaskID=0, TaskGuildID=0):

    message = ['StartProtectEscort']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(TaskID)
    message.append(TaskGuildID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def start_rob_escort(GameSvrId=0, dtEventTime=0, GameAppID=0,
                     PlatID=0, OpenID=0, TaskID=0, TaskGuildID=0):

    message = ['StartRobEscort']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(TaskID)
    message.append(TaskGuildID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def join_guild(GameSvrId=0, dtEventTime=0, GameAppID=0,
               PlatID=0, OpenID=0, GuildID=0):

    message = ['JoinGuild']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def refresh_shop(GameSvrId=0, dtEventTime=0, GameAppID=0,
                 PlatID=0, OpenID=0, ShopType=0, Times=0):

    message = ['RefreshShop']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ShopType)
    message.append(Times)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def shop_buy1(GameSvrId=0, dtEventTime=0, GameAppID=0,
              PlatID=0, OpenID=0, ShopID=0):

    message = ['ShopBuy1']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ShopID)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def shop_buy(GameSvrId=0, dtEventTime=0, GameAppID=0,
             PlatID=0, OpenID=0, Ids=0, ItemsCount=0):

    message = ['ShopBuy']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Ids)
    message.append(ItemsCount)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def buy_stamina(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, ResourceType=0, Num=0):

    message = ['BuyStamina']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ResourceType)
    message.append(Num)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def reset_stage(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, StageID=0, Times=0):

    message = ['ResetStage']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageID)
    message.append(Times)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg
