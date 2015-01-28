# coding: utf-8

from shared.tlog import log4tx
from shared.utils import xtime
# from utils.log import log_except
from gfirefly.server.logobj import logger

game_server_id = 1
game_app_id = 1
plat_id = 1


def player_register(player_data, handler):
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
                           DeviceId=handler.device_id, Nickname='nickname')


def player_login(player_data, handler):
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
                        DeviceId=handler.device_id, OpenID=player_data.id)


def item_flow(player_data, addorreduce, itemtype, itemnum, itemid, itid,
              reason, after_num):
    log4tx.item_flow(PlatID=plat_id, GameSvrId=game_server_id,
                     dtEventTime=xtime.strdatetime(), GameAppID=game_app_id,
                     OpenID=player_data.base_info.id, ItemID=itemid,
                     ItemType=itemtype, AfterCount=after_num, Count=itemnum,
                     AddOrReduce=addorreduce, Reason=reason, Itid=itid)


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


# TLOG分类打印函数
tlog_funcs = {}
tlog_funcs['PlayerLogin'] = player_login
tlog_funcs['PlayerRegister'] = player_register
tlog_funcs['ItemFlow'] = item_flow
tlog_funcs['PlayerExpFlow'] = player_exp_flow


def log(mod, *args, **kwds):
    """
    打印TLOG
    """
    try:
        tlog_funcs[mod](*args, **kwds)
    except:
        pass
        # log_except(mod)
