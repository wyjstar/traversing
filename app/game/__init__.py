#-*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""
import action
from shared.db_opear.configs_data import game_configs
from app.game.core.PlayersManager import PlayersManager
from gfirefly.dbentrust.madminanager import MAdminManager
from gfirefly.server.globalobject import GlobalObject
from app.game.core.character.PlayerCharacter import PlayerCharacter


def doWhenStop():
    """服务器关闭前的处理
    """
    print "##############################"
    print "##########checkAdmins#############"
    print "##############################"
    MAdminManager().checkAdmins()


GlobalObject().stophandler = doWhenStop


robotname_id, robot_level, rhero_id, rhero_level = game_configs.base_config.get('initial')

player = PlayerCharacter(999, dynamic_id=-1)
player.base_info._level = robot_level
player.base_info.base_name = game_configs.language_config.get('%s' % robotname_id).get('cn')

hero = player.hero_component.add_hero(rhero_id)
hero.hero_no = rhero_id
hero.level = rhero_level
hero.break_level = 0
hero.exp = 0

player.line_up_component.change_hero(1, rhero_id, 0)
PlayersManager().add_player(player)
