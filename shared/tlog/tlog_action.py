# coding: utf-8

from shared.tlog import log4tx
from shared.utils import xtime
# from utils.log import log_except

game_server_id = 1
game_app_id = 1


def player_register(player_data, handler):
    log4tx.player_register(GameSvrId=game_server_id, dtEventTime=xtime.strdatetime(), GameAppID=game_app_id, PlatID=handler.plat_id, OpenID=player_data.id, ClientVersion=handler.client_version,
                        SystemSoftware=handler.system_software, SystemHardware=handler.system_hardware, TelecomOper=handler.telecom_oper, Network=handler.network, ScreenWidth=handler.screen_width,
                        ScreenHight=handler.screen_hight, Density=handler.density, RegChannel=handler.login_channel, UUID=handler.mac, CpuHardware=handler.cpu_hardware, Memory=handler.memory,
                        GLRender=handler.gl_render, GLVersion=handler.gl_version, DeviceId=handler.device_id, Nickname='nickname')


def player_login(player_data, handler):
    log4tx.player_login(Uid=player_data.id, GameSvrId=game_server_id, dtEventTime=xtime.strdatetime(), GameAppID=game_app_id,
                        PlatID=handler.plat_id, OpenID=player_data.id, Level=player_data.level, PlayerFriendsNum=1,
                        ClientVersion=handler.client_version, SystemSoftware=handler.system_software, SystemHardware=handler.system_hardware, TelecomOper=handler.telecom_oper,
                        Network=handler.network, ScreenWidth=handler.screen_width,
                        ScreenHight=handler.screen_hight, Density=handler.density, LoginChannel=handler.login_channel, UUID=handler.mac, CpuHardware=handler.cpu_hardware, Memory=handler.memory,
                        GLRender=handler.gl_render, GLVersion=handler.gl_version, DeviceId=handler.device_id, IPAddress='0.0.0.0')


# TLOG分类打印函数
tlog_funcs = {}
tlog_funcs['PlayerLogin'] = player_login
tlog_funcs['PlayerRegister'] = player_register


def log(mod, *args, **kwds):
    """
    打印TLOG
    """
    try:
        tlog_funcs[mod](*args, **kwds)
    except:
        pass
        # log_except(mod)
