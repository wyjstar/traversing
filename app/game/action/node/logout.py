# -*- coding:utf-8 -*-
"""
created by server on 14-7-8下午3:54.
"""
from gfirefly.server.logobj import logger
from app.game.core.PlayersManager import PlayersManager
from gfirefly.server.globalobject import remoteserviceHandle
from shared.tlog import tlog_action
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data import game_configs
import time
remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def net_conn_lost_remote(player):
    """logout
    """
    logger.debug('player offline:<%s> %s,%s',
                 player,
                 player.character_id,
                 player.dynamic_id)
    tlog_action.log('PlayerLogout', player)
    player.online_gift.offline_player()

    remote_gate['push'].online_offline_remote(player.base_info.id, 0)
    detail_info = player.mine.detail_info(0)
    # ret, stype, last_increase, limit, normal, lucky, lineup, guard_time, _ = detail_info
    stones = sum(detail_info['normal'].values()) + sum(detail_info['lucky'].values())
    outputGroup1 = game_configs.mine_config[10001].outputGroup1
    timeGroup1 = game_configs.mine_config[10001].timeGroup1
    outputLimited = game_configs.mine_config[10001].outputLimited

    x = outputLimited - stones
    if x < 0:
        x = 0
    time_add = int(x/outputGroup1) * timeGroup1*60
    txt = game_configs.push_config[1005].text
    message = game_configs.language_config.get(str(txt)).get('cn')
    remote_gate['push'].add_push_message_remote(player.base_info.id,
                                                5, message,
                                                int(time.time())+time_add)

    stamina = player.stamina.stamina
    max = game_configs.base_config['max_of_vigor']
    period = game_configs.base_config['peroid_of_vigor_recover']
    add_time = (max - stamina) * period

    txt = game_configs.push_config[1001].text
    message = game_configs.language_config.get(str(txt)).get('cn')
    remote_gate['push'].add_push_message_remote(player.base_info.id,
                                        1, message,
                                        int(time.time())+time_add)

    # TODO 是否需要保存数据
    player.line_up_component.save_data()
    player.line_up_component.line_up_slots[1].update_lord_info()
    PlayersManager().drop_player(player)
    return True
