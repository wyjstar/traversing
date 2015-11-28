# -*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""
import action
from shared.db_opear.configs_data import game_configs
from app.game.core.PlayersManager import PlayersManager
from gfirefly.dbentrust.madminanager import MAdminManager
from gfirefly.server.globalobject import GlobalObject
from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.redis_mode import tb_character_info
from shared.utils.ranking import Ranking


def doWhenStop():
    """服务器关闭前的处理
    """
    print "##############################"
    print "##########checkAdmins#############"
    print "##############################"
    MAdminManager().checkAdmins()


GlobalObject().stophandler = doWhenStop

Ranking.init('GuildLevel', 9999)
Ranking.init('LevelRank1', 99999)
Ranking.init('LevelRank2', 99999)
Ranking.init('PowerRank1', 99999)
Ranking.init('PowerRank2', 99999)
Ranking.init('StarRank1', 99999)
Ranking.init('StarRank2', 99999)
Ranking.init('LimitHeroRank', 99999)


if game_configs.base_config.get('initial') and GlobalObject().json_config.get("name") == u"game":
    character_obj = tb_character_info.getObj(999)
    if not character_obj.exists():
        character_obj = tb_character_info.getObj(9199)
        #print("999======", character_obj.exists())
        print(GlobalObject().json_config.get("name"), "GlobalObject================")
        robotname_id, robot_level, rhero_id, rhero_level = game_configs.base_config.get('initial')

        player = PlayerCharacter(999, dynamic_id=-1)
        player.base_info._level = robot_level

        hero = player.hero_component.add_hero(rhero_id)
        hero.hero_no = rhero_id
        hero.level = rhero_level
        hero.break_level = 0
        hero.exp = 0
        player.line_up_component.update_guild_attr()

        player.line_up_component.change_hero(1, rhero_id, 0)
        PlayersManager().add_player(player)
        player.create_character_data()

        character_obj = tb_character_info.getObj(999)
        character_obj.hset('nickname', game_configs.language_config.get('%s' % robotname_id).get('cn'))
