# coding: utf-8

from shared.tlog import logclient
from gfirefly.server.logobj import logger

debug = 0
LOG_FOR_SELF = 1


def _format(message):
    return '|'.join(map(str, message))


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


def inherit(GameSvrId=0, dtEventTime=0, GameAppID=0,
            PlatID=0, OpenID=0, InheritType=0, OriginId=0, OriginItemId=0,
            TargetId=0, TargetItemId=0):

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
               PlatID=0, OpenID=0, StageId=0, Times=0):

    message = ['SweepFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageId)
    message.append(Times)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def creat_guild(GameSvrId=0, dtEventTime=0, GameAppID=0,
                PlatID=0, OpenID=0, GuildId=0, UserLevel=0):

    message = ['CreatGuild']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(UserLevel)

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
                  PlatID=0, OpenID=0, GuildId=0, WorshipType=0):

    message = ['GuildWorship']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(GuildId)
    message.append(WorshipType)

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
                    GLVersion=0, DeviceId=0, Nickname=0):

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

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_login(GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0,
                 Level=0, PlayerFriendsNum=0, ClientVersion=0,
                 SystemSoftware=0, SystemHardware=0, TelecomOper=0, Network=0,
                 ScreenWidth=0, ScreenHight=0, Density=0, LoginChannel=0,
                 UUID=0, CpuHardware=0, Memory=0, GLRender=0,
                 GLVersion=0, DeviceId=0):

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
              Reason=0, SubReason=0, AddOrReduce=0, Itid=0):

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
    message.append(AddOrReduce)
    message.append(Itid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def recharge(GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0,
             OpenID=0, Isfirst=0, RechargeId=0):

    message = ['Recharge']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Isfirst)
    message.append(RechargeId)

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
