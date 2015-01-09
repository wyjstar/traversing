# coding: utf-8

from shared.tlog import logclient

debug = 0
LOG_FOR_SELF = 1


def _format(message):
    return '|'.join(map(str, message))


def player_register(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0, ClientVersion=0,
                    SystemSoftware=0, SystemHardware=0, TelecomOper=0, Network=0, ScreenWidth=0,
                    ScreenHight=0, Density=0, RegChannel=0, UUID=0, CpuHardware=0, Memory=0,
                    GLRender=0, GLVersion=0, DeviceId=0, Nickname=0):
    """ 
    log4tx player register.
    
    record:PlayerRegister|vGameSvrId|dtEventTime|vGameAppID|OpenID|PlatID|ClientVersion|SystemSoftware|SystemHardware|TelecomOper|
    Netword|ScreenWidth|ScreenHight|Density|Channel|UUID|CpuHardware|Memory|GLRender|GLVersion|DeviceId|Nickname
    """
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
    GLVersion = GLVersion.split('\n')[0]
    message.append(GLVersion)
    message.append(DeviceId)
    message.append(Nickname)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_login(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0, Level=0, PlayerFriendsNum=0,
                 ClientVersion=0, SystemSoftware=0, SystemHardware=0, TelecomOper=0, Network=0, ScreenWidth=0,
                 ScreenHight=0, Density=0, LoginChannel=0, UUID=0, CpuHardware=0, Memory=0,
                 GLRender=0, GLVersion=0, DeviceId=0, IPAddress=0):

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
    message.append(IPAddress)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_logout(Uid=0, vGameSvrId=0, dtEventTime=0, vGameAppID=0, vOpenID=0, iOnlineTime=0, iLevel=0,
                  PlatID=0, ClientVersion=0, SystemSoftware=0, SystemHardware=0, TelecomOper=0, Network=0,
                  ScreenWidth=0, ScreenHight=0, Density=0, Channel=0, UUID=0, CpuHardware=0,
                  Memory=0, GLRender=0, GLVersion=0, DeviceId=0, PlayerFriendsNum=0):
    """
    for player logout
    record:PlayerLogout|vGameSvrId|dtEventTime|vGameAppID|vOpenID|iOnlineTime|iLevel|PlatID|ClientVersion|SystemSoftware|
    SystemHardware|TelecomOper|Network|ScreenWidth|ScreenHight|Density|Channel|UUID|CpuHardware|Memory|GLRender|GLVersion|
    DeviceId|PlayerFriendsNum|
    """
    message = ['PlayerLogout']
    message.append(vGameSvrId)
    message.append(dtEventTime)
    message.append(vGameAppID)
    message.append(PlatID)
    message.append(vOpenID)
    message.append(iOnlineTime)
    message.append(iLevel)
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
    GLVersion = GLVersion.split('\n')[0]
    message.append(GLVersion)
    message.append(DeviceId)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def recharge(Uid=0, dtEventTime=0, vGameAppID=0, vOpenID=0, PlatID=0, iSourceWay=0, iDelta=0,
             iRechargeAfter=0, iLoginWay=0, iRegWay=0):
    """
    log fro recharge
    record:Recharge|dtEventTime|vGameAppID|vOpenID|PlatID|iSourceWay|iDelta|iRechargeAfter|iLoginWay|iRegWay|
    """
    message = ['Recharge']
    message.append(dtEventTime)
    message.append(vGameAppID)
    message.append(vOpenID)
    message.append(PlatID)
    message.append(iSourceWay)
    message.append(iDelta)
    message.append(iRechargeAfter)
    message.append(iLoginWay)
    message.append(iRegWay)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def money_flow(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, Level=0,
               AfterMoney=0, Money=0, Reason=0, SubReason=0, AddOrReduce=0, MoneyType=0, Cpoint=0, Cpoints=0):
    """
    log for MoneyFlow
    record:MoneyFlow|vGameSvrId|dtEventTime|vGameAppID|iEventId|vOpenID|PlatID|iLevel|iAfterMoney|iMoney|iFlowType|iAction|MoneyType
    iFlowType:0,1,2,3
    iAction:0,1,2,3,4,5,6
    """
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
    message.append(AddOrReduce)
    message.append(MoneyType)
    message.append(Cpoint)
    message.append(Cpoints)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
#         if LOG_FOR_SELF and iFlowType == 1:
#             message.append(Cpoint)
#             message.append(Cpoints)
    message.append(Uid)

    sendmsg = _format(message)
    if debug:
        print sendmsg


def item_flow(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, ItemType=0, ItemID=0,
              AfterCount=0, Count=0, Reason=0, SubReason=0, AddOrReduce=0, Itid=0):
    """
    log for ItemFlow
    record:ItemFlow|vGameSvrId|dtEventTime|vGameAppID|vOpenID|PlatID|ItemId|iAfterCount|Count|AddOrReduce|Reason
    Reason:0,1,2,3,4,5,6,7,8,9,10
    """
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
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_flowbat(Uid=0, vGameSvrId=0, dtEventTime=0, vGameAppID=0, vOpenID=0, PlatID=0, ItemID=0,
              iAfterCount=0, Count=0, AddOrReduce=0, Reason=0, Itid=0):

    message = ['ItemFlowBat']

    message.append(vGameSvrId)
    message.append(dtEventTime)
    message.append(vGameAppID)
    message.append(vOpenID)
    message.append(PlatID)
    message.append(ItemID)
    message.append(iAfterCount)
    message.append(Count)
    message.append(AddOrReduce)
    message.append(Reason)
    message.append(Itid)
    message.append(Uid)

    sendmsg = _format(message)

    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_money_flow(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, ItemType=0, ItemId=0,
                    Count=0, Money=0, Level=0, MoneyType=0):
    """
    log for ItemMoneyFlow
    record:ItemMoneyFlow|vGameSvrId|dtEventTime|vGameAppID|vOpenID|PlatID|ItemId|Count|Money|MoneyType|iLevel|
    MoneyType:0,1
    """
    message = ['ItemMoneyFlow']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(ItemType)
    message.append(ItemId)
    message.append(Count)
    message.append(Money)
    message.append(Level)
    message.append(MoneyType)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_exp_flow(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0, ExpChange=0,
                    BeforeLevel=0, AfterLevel=0, Time=0, Reason=0, SubReason=0):
    """
    log for PlayerExpFlow
    record:PlayerExpFlow|vGameSvrId|dtEventTime|vGameAppID|vOpenID|PlatID|ExpChange|BeforeLevel|AfterLevel|time|Reason|
    Reason:0,1,2,3
    """
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
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def sns_flow(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, ActorOpenID=0, RecNum=0, Count=0,
             SNSType=0, SNSSubType=0):
    """
    log for SnsFlow
    record:SnsFlow|vGameSvrId|dtEventTime|vGameAppID|PlatID|vActorOpenID|iCount|iItemCount|SNSType|SNSSenType|
    SNSType:0,1,2,3,4,5,
    """
    message = ['SnsFlow']

    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(ActorOpenID)
    message.append(RecNum)
    message.append(Count)
    message.append(SNSType)
    message.append(SNSSubType)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg

def round_flow(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0,
               BattleID=0, BattleType=0, RoundScore=0, Result=0, Rank=0, Gold=0, isQuick=0, ExpChange=0):
    """
    log for RoundFlow
    record:RoundFlow|vGameSvrId|dtEventTime|iSequence|vGameAppID|vOpenID|PlatID|iBattleID|BattleType|RoundScore|Result|Rank|iGold|[isQuick]
    BattleType:0,1,2
    """
    message = ['RoundFlow']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(BattleID)
    message.append(BattleType)
    message.append(RoundScore)
    message.append(Result)
    message.append(Rank)
    message.append(Gold)
    message.append(isQuick)
    message.append(ExpChange)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    message.append(Uid)

    sendmsg = _format(message)
    if debug:
        print sendmsg


def sec_round_start_flow(Uid=0, vGameSvrId=0, dtEventTime=0, vGameAppID=0, vOpenID=0, iBattleID=0, PlatID=0,
                         ClientRoundStartTime=0, mapid=0,
                         UserCardInfo1=0, UserCardSkill1=0, UserCardItemSkill1=0,
                         UserCardInfo2=0, UserCardSkill2=0, UserCardItemSkill2=0,
                         UserCardInfo3=0, UserCardSkill3=0, UserCardItemSkill3=0,
                         UserCardInfo4=0, UserCardSkill4=0, UserCardItemSkill4=0,
                         UserCardInfo5=0, UserCardSkill5=0, UserCardItemSkill5=0,
                         UserCardInfo6=0, UserCardSkill6=0, UserCardItemSkill6=0,
                         MonsterCardInfo1=0, MonsterCardInfo2=0, MonsterCardInfo3=0,
                         MonsterCardInfo4=0, MonsterCardInfo5=0, MonsterCardInfo6=0,
                         MonsterCardInfo7=0, MonsterCardInfo8=0, MonsterCardInfo9=0,
                         MonsterCardInfo10=0, MonsterCardInfo11=0, MonsterCardInfo12=0,
                         MonsterCardInfo13=0, MonsterCardInfo14=0, MonsterCardInfo15=0, RoundType=0, BossBattleBuff=0, UserName=0,
                         UserPetInfo1=0, UserPetInfo2=0, TowerRandomBuff=0,
                         UserCardInfo7=0, UserCardSkill7=0, UserCardItemSkill7=0,
                         UserCardInfo8=0, UserCardSkill8=0, UserCardItemSkill8=0,
                         UserCardInfo9=0, UserCardSkill9=0, UserCardItemSkill9=0,
                         UserCardInfo10=0, UserCardSkill10=0, UserCardItemSkill10=0,
                         ):
    message = ['SecRoundStartFlow']
    message.append(vGameSvrId)
    message.append(dtEventTime)
    message.append(vGameAppID)
    message.append(vOpenID)
    message.append(iBattleID)
    message.append(PlatID)
    message.append(ClientRoundStartTime)
    message.append(mapid)
    message.append(UserCardInfo1)
    message.append(UserCardSkill1)
    message.append(UserCardItemSkill1)
    message.append(UserCardInfo2)
    message.append(UserCardSkill2)
    message.append(UserCardItemSkill2)
    message.append(UserCardInfo3)
    message.append(UserCardSkill3)
    message.append(UserCardItemSkill3)
    message.append(UserCardInfo4)
    message.append(UserCardSkill4)
    message.append(UserCardItemSkill4)
    message.append(UserCardInfo5)
    message.append(UserCardSkill5)
    message.append(UserCardItemSkill5)
    message.append(UserCardInfo6)
    message.append(UserCardSkill6)
    message.append(UserCardItemSkill6)
    message.append(MonsterCardInfo1)
    message.append(MonsterCardInfo2)
    message.append(MonsterCardInfo3)
    message.append(MonsterCardInfo4)
    message.append(MonsterCardInfo5)
    message.append(MonsterCardInfo6)
    message.append(MonsterCardInfo7)
    message.append(MonsterCardInfo8)
    message.append(MonsterCardInfo9)
    message.append(MonsterCardInfo10)
    message.append(MonsterCardInfo11)
    message.append(MonsterCardInfo12)
    message.append(MonsterCardInfo13)
    message.append(MonsterCardInfo14)
    message.append(MonsterCardInfo15)
    message.append(RoundType)
    message.append(BossBattleBuff)
    if UserName.find('|') != -1:
        UserName = UserName.replace('|', '/')
    message.append(UserName)
    message.append(UserPetInfo1)
    message.append(UserPetInfo2)
    message.append(TowerRandomBuff)
    message.append(UserCardInfo7)
    message.append(UserCardSkill7)
    message.append(UserCardItemSkill7)
    message.append(UserCardInfo8)
    message.append(UserCardSkill8)
    message.append(UserCardItemSkill8)
    message.append(UserCardInfo9)
    message.append(UserCardSkill9)
    message.append(UserCardItemSkill9)
    message.append(UserCardInfo10)
    message.append(UserCardSkill10)
    message.append(UserCardItemSkill10)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def sec_round_end_flow(Uid=0, vGameSvrId=0, dtEventTime=0, vGameAppID=0, vOpenID=0, iBattleID=0, PlatID=0, ClientRoundEndTime=0, RoundResult=0,
                       param=0, ClientVersion=0, Result=0, addheroparam=0, RoundRate=0, UserVipBuff=0,
                       RoundScore=0, IsTopScore=0, RoundGold=0, RoundExp=0, RoundDropItem=0,
                       RoundDropCard0=0, RoundDropCard1=0, RoundDropCard2=0,
                       RoundDropCartSoul0=0, RoundDropCartSoul1=0, IsSafeScore=0, SafeScore=0,
                       RoundDropDiamond=0, RoundReviveCount=0):
    message = ['SecRoundEndFlow']
    message.append(vGameSvrId)
    message.append(dtEventTime)
    message.append(vGameAppID)
    message.append(vOpenID)
    message.append(iBattleID)
    message.append(PlatID)
    message.append(ClientRoundEndTime)
    message.append(RoundResult)
    message.append(param)
    message.append(ClientVersion)
    message.append(Result)
    message.append(addheroparam)
    message.append(RoundRate)
    message.append(UserVipBuff)
    message.append(RoundScore)
    message.append(IsTopScore)
    message.append(RoundGold)
    message.append(RoundExp)
    message.append(RoundDropItem)
    message.append(RoundDropCard0)
    message.append(RoundDropCard1)
    message.append(RoundDropCard2)
    message.append(RoundDropCartSoul0)
    message.append(RoundDropCartSoul1)
    message.append(IsSafeScore)
    message.append(SafeScore)
    message.append(RoundDropDiamond)
    message.append(RoundReviveCount)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def log_anti_data(Uid=0, vGameSvrId=0, dtEventTime=0, iSequence=0, vGameAppID=0, vOpenID=0, PlatID=0, strData=0):
    message = ['LogAntiData']
    message.append(vGameSvrId)
    message.append(dtEventTime)
    message.append(iSequence)
    message.append(vGameAppID)
    message.append(vOpenID)
    message.append(PlatID)
    message.append(strData)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def round_flow_item_output(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0, BattleID=0, BattleType=0, ItemType=0, ItemId=0, ItemNum=0):
    message = ['RoundFlowItemOutput']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(BattleID)
    message.append(BattleType)
    message.append(ItemType)
    message.append(ItemId)
    message.append(ItemNum)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def total_login_reward_reward(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0, Level=0, TotalDay=0, Money=0):
    message = ['TotalLoginRewardReward']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Level)
    message.append(TotalDay)
    message.append(Money)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def continue_login_reward_reward(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0, Level=0, ContinueDay=0, Money=0):
    message = ['ContinueLoginRewardReward']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Level)
    message.append(ContinueDay)
    message.append(Money)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg

def chongji_rank(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0, Level=0, Exp=0):
    message = ['ChongJiRank']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Level)
    message.append(Exp)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def card_star_lvup(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0, Itemtype=0, Itemid=0, Before=0, After=0,
                                    Coin=0, Soul=0, Costtype=0, Cost_id=0):
    message = ['CardStarLvUp']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Itemtype)
    message.append(Itemid)
    message.append(Before)
    message.append(After)
    message.append(Coin)
    message.append(Soul)
    message.append(Costtype)
    message.append(Cost_id)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def boss_attack(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, Result=0, Damage=0, Money=0, Rank=0):
    message = ['BossAttack']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Result)
    message.append(Damage)
    message.append(Money)
    message.append(Rank)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def boss_rank(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, Rank=0):
    message = ['BossRank']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Rank)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def tower_round_flow(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, BattleType=0, FloorNum=0, Result=0, StarNum=0,
                     Frozen=0, ItemId=0, BackupItemId=0, ReliveNum=0, Buff=0, GameAppID='', PlatID=0, OpenID='',
                     BattleID=0, Level=0):
    message = ['TowerRoundFlow']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(BattleID)
    message.append(BattleType)
    message.append(FloorNum)
    message.append(Result)
    message.append(StarNum)
    message.append(Frozen)
    message.append(ItemId)
    message.append(BackupItemId)
    message.append(ReliveNum)
    message.append(Buff)
    message.append(Level)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def use_pet(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, ItemType=0, ItemId=0, Type=0):
    message = ['UsePet']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(ItemType)
    message.append(ItemId)
    message.append(Type)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def player_hero_info(Uid=0, GameSvrId=0, dtEventTime=0, GameAppID=0, PlatID=0, OpenID=0,
                     HeroItemId=0, HeroUid=0, HeroLevel=0, HeroStarLevel=0,
                     Skill1Level=0, Skill2Level=0, Skill3Level=0, Skill4Level=0,
                     Item1Level=0, Item2Level=0, Item3Level=0, Item4Level=0, Item5Level=0, Item6Level=0):
    message = ['PlayerHeroInfo']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(GameAppID)
    message.append(PlatID)

    message.append(OpenID)
    message.append(HeroItemId)
    message.append(HeroUid)
    message.append(HeroLevel)
    message.append(HeroStarLevel)

    message.append(Skill1Level)
    message.append(Skill2Level)
    message.append(Skill3Level)
    message.append(Skill4Level)

    message.append(Item1Level)
    message.append(Item2Level)
    message.append(Item3Level)
    message.append(Item4Level)
    message.append(Item5Level)
    message.append(Item6Level)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def pvp_purchase_vigor(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, CostMoney=0):
    message = ['PVPPurchaseVigor']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(CostMoney)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def pvp_battle_info(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                   Level=0, Combat=0, TeamID=0, PetID1=0, PetID2=0, HoreID1=0, HoreTypeID1=0,
                   HoreID2=0, HoreTypeID2=0, HoreID3=0, HoreTypeID3=0, HoreID4=0, HoreTypeID4=0,
                   HoreID5=0, HoreTypeID5=0):
    message = ['PVPBattleInfo']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Level)
    message.append(Combat)
    message.append(TeamID)
    message.append(PetID1)
    message.append(PetID2)
    message.append(HoreID1)
    message.append(HoreTypeID1)
    message.append(HoreID2)
    message.append(HoreTypeID2)
    message.append(HoreID3)
    message.append(HoreTypeID3)
    message.append(HoreID4)
    message.append(HoreTypeID4)
    message.append(HoreID5)
    message.append(HoreTypeID5)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def pvp_result(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
               OpponentUid=0, TeamID=0, Result=0, Rank=0):
    message = ['PVPResult']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(OpponentUid)
    message.append(TeamID)
    message.append(Result)
    message.append(Rank)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def pvp_award(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
             Honor=0):
    message = ['PVPAward']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Honor)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def pvp_honor_exchange(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                       ItemID=0):
    message = ['PVPHonorExchange']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemID)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_remove(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, ItemType=0,
                   ItemId=0, CostItemType=0 , CostItemId=0, CostItemNum=0, OutputItemType=0, OutputItemId=0,
                   OutputItemNum=0):
    message = ['ItemRemove']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemType)
    message.append(ItemId)
    message.append(CostItemType)
    message.append(CostItemId)
    message.append(CostItemNum)
    message.append(OutputItemType)
    message.append(OutputItemId)
    message.append(OutputItemNum)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_decompose(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, ItemType=0, ItemId=0,
                   SmeltPoint=0 , SmeltDeluxePoint=0):
    message = ['ItemDecompose']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemType)
    message.append(ItemId)
    message.append(SmeltPoint)
    message.append(SmeltDeluxePoint)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_purify(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, ItemType=0, ItemId=0,
                CostItemNum=0, GetGold=0, GetDiamond=0, GetSmeltPoint=0, GetSmeltDeluxePoint=0):
    message = ['ItemPurify']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemType)
    message.append(ItemId)
    message.append(CostItemNum)
    message.append(GetGold)
    message.append(GetDiamond)
    message.append(GetSmeltPoint)
    message.append(GetSmeltDeluxePoint)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_strengthen(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, ItemType=0,
                   ItemId=0, CostItemNum=0, CostMoney=0, BeforeLevel=0, AfterLevel=0, StrengthenType=0):

    message = ['ItemStrengthen']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemType)
    message.append(ItemId)
    message.append(CostItemNum)
    message.append(CostMoney)
    message.append(BeforeLevel)
    message.append(AfterLevel)
    message.append(StrengthenType)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def item_attr_streng(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, ItemType=0,
                   ItemId=0, StrengthType=0, Lock=0, CostItemNum=0, CostSupItemNum=0, CostMoney=0,
                   CostDiamond=0, AddIndex=0, AddID=0):
    message = ['ItemAttrStreng']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemType)
    message.append(ItemId)
    message.append(StrengthType)
    message.append(Lock)
    message.append(CostItemNum)
    message.append(CostSupItemNum)
    message.append(CostMoney)
    message.append(CostDiamond)
    message.append(AddIndex)
    message.append(AddID)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def invitation_code_write(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                          RegistrationTime=0, InvitationCode=0):
    message = ['InvitationCodeWrite']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(RegistrationTime)
    message.append(InvitationCode)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def invitation_code_receive_award(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                                  AwardType=0):
    message = ['InvitationCodeReceiveAward']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(AwardType)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def chat_room_speak(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, Channel=0):
    message = ['ChatRoomSpeak']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(Channel)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def chat_room_gag(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0):
    message = ['ChatRoomSpeak']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def multi_lineup(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0, OperateType=0):
    message = ['MultiLineup']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(OperateType)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def link_skill(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
               MainCardTypeID=0, MainCardID=0, CardTypeID=0, CardID=0, SkillID=0):
    message = ['LinkSkill']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(MainCardTypeID)
    message.append(MainCardID)
    message.append(CardTypeID)
    message.append(CardID)
    message.append(SkillID)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def supplicaion_do(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
               ItemID=0, ItemNum=0):
    message = ['SupplicaionDo']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemID)
    message.append(ItemNum)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def supplicaion_select(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
               ItemID=0):
    message = ['SupplicaionSelect']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(ItemID)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def supplicaion_refresh(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
               RefreshType=0, CostItemNum=0):
    message = ['SupplicaionRefresh']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(RefreshType)
    message.append(CostItemNum)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def continuous_mop_up(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                      StageID=0, MopUpType=0, MopUpNum=0, CostMoney=0):
    message = ['ContinuousMopUp']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageID)
    message.append(MopUpType)
    message.append(MopUpNum)
    message.append(CostMoney)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def luck_hero_select(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                     HeroID=0):        
    message = ['LuckHeroSelect']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HeroID)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def luck_hero_refresh(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                     CostMoney=0):        
    message = ['LuckHeroRefresh']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(CostMoney)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def luck_hero_get(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                     LuckPoints=0, HeroID=0, HeroNum=0):        
    message = ['LuckHeroGet']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(LuckPoints)    
    message.append(HeroID)
    message.append(HeroNum)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def luck_drop_get(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                     StageID=0, LuckPoints=0, DropType=0, DropID=0, DropNum=0):
    message = ['LuckDropGet']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageID)
    message.append(LuckPoints)
    message.append(DropType)
    message.append(DropID)
    message.append(DropNum)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def luck_drop_select(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                  StageID=0, DropType=0, DropID=0):
    message = ['LuckDropSelect']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(StageID)
    message.append(DropType)
    message.append(DropID)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def execute_pay(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                CostType=0, Money=0):
    message = ['ExecutePay']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(CostType)
    message.append(Money)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def GM_reward(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
              DropType=0, DropID=0, DropGrade=0, DropQuantity=0):
    message = ['GMReward']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(DropType)
    message.append(DropID)
    message.append(DropGrade)
    message.append(DropQuantity)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def GM_update(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
              UpdateType=0, UpdateValue=0):
    message = ['GMUpdate']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)
    message.append(UpdateType)
    message.append(UpdateValue)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def skill_level_up(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
                   HoreID=0, HoreTypeID=0, BeforeSkillID=0, AfterSkillID=0):
    message = ['SkillLevelUP']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(HoreID)
    message.append(HoreTypeID)
    message.append(BeforeSkillID)
    message.append(AfterSkillID)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg


def hero_chip(Uid=0, GameSvrId=0, dtEventTime=0, Sequence=0, GameAppID=0, PlatID=0, OpenID=0,
              AddOrReduce=0, Reason=0, ChipID=0, Amount=0):
    message = ['HeroChip']
    message.append(GameSvrId)
    message.append(dtEventTime)
    message.append(Sequence)
    message.append(GameAppID)
    message.append(PlatID)
    message.append(OpenID)

    message.append(AddOrReduce)
    message.append(Reason)
    message.append(ChipID)
    message.append(Amount)
    message.append(Uid)

    sendmsg = _format(message)
    logclient.gethandler().send_msg(sendmsg + '\n')
    if debug:
        print sendmsg
