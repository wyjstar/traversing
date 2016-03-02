# -*- coding:utf-8 -*-
"""
created by wzp on 15-12-14下午5:22.
"""
#from shared.db_opear.configs_data import game_configs
#from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import get_return
import cPickle
from app.game.action.node._fight_start_logic import assemble

def load_data_to_response(tasks, tasks_pb):
    """docstring for load_data_to_response"""
    for task_id, task in tasks.items():
        task_pb = tasks_pb.add()
        update_task_pb(task, task_pb)

def update_task_pb(task, task_pb):
    """docstring for load_task_to_response"""
    task_pb.task_id = task.get("task_id")
    task_pb.task_no = task.get("task_no")
    task_pb.state = task.get("state")
    task_pb.receive_task_time = int(task.get("receive_task_time", 0))
    task_pb.start_protect_time = int(task.get("start_protect_time", 0))
    task_pb.last_send_invite_time = task.get("last_send_invite_time", 0)
    update_guild_pb(task.get("protect_guild_info", {}), task_pb.protect_guild_info)
    update_player_infos_pb(task.get("protecters", []), task_pb.protecters)
    # reward
    load_to_game_response(task.get("reward", []), task_pb.reward)

    for rob_task_info in task.get("rob_task_infos", []):
        rob_task_info_pb = task_pb.rob_task_infos.add()
        update_rob_task_info_pb(task.get("protecters"), rob_task_info, rob_task_info_pb)

def update_guild_pb(guild_info, guild_info_pb):
    guild_info_pb.g_id = guild_info.get("id", -1)
    guild_info_pb.rank = guild_info.get("rank", -1)
    guild_info_pb.name = guild_info.get("name", "")
    guild_info_pb.level = guild_info.get("level", 0)
    guild_info_pb.president = guild_info.get("president", "")
    guild_info_pb.p_num = guild_info.get("p_num", 0)
    guild_info_pb.icon_id = guild_info.get("icon_id", 0)
    guild_info_pb.call = guild_info.get("call", "")

def update_player_infos_pb(player_infos, player_infos_pb):
    for player_info in player_infos:
        player_info_pb = player_infos_pb.add()
        player_info_pb.id = player_info.get("id")
        player_info_pb.nickname = player_info.get("nickname")
        player_info_pb.level = player_info.get("level")
        player_info_pb.hero_no = player_info.get("head")
        player_info_pb.vip_level = player_info.get("vip_level")
        player_info_pb.power = player_info.get("power")
        player_info_pb.guild_position = player_info.get("guild_position", 0)
        player_info_pb.hero_no = player_info.get("hero_no", 0) # 队长头像
        player_info_pb.friend_info.level = player_info.get("level", 0)
        player_info_pb.friend_info.break_level = player_info.get("break_level", 0)

def update_rob_task_info_pb(protecters, rob_task_info, rob_task_info_pb, protect_or_rob=1):
    # guild
    update_guild_pb(rob_task_info.get("rob_guild_info"), rob_task_info_pb.rob_guild_info)
    # robbers
    update_player_infos_pb(rob_task_info.get("robbers"), rob_task_info_pb.robbers)
    # protect battle units
    update_side_battle_unit_pb(protecters, rob_task_info_pb.blue)
    update_side_battle_unit_pb(rob_task_info.get("robbers"), rob_task_info_pb.red)
    # seed
    rob_task_info_pb.seed1 = rob_task_info.get("seed1", 0)
    rob_task_info_pb.seed2 = rob_task_info.get("seed2", 0)
    # rob reward
    load_to_game_response(rob_task_info.get("rob_reward", []), rob_task_info_pb.rob_reward)
    # rob_result
    rob_task_info_pb.rob_result = rob_task_info.get("rob_result", False)
    # rob_time
    rob_task_info_pb.rob_time = rob_task_info.get("rob_time", 0)
    # rob_state
    rob_task_info_pb.rob_state = rob_task_info.get("rob_state", 0)
    # rob_receive_task_time
    rob_task_info_pb.rob_receive_task_time = rob_task_info.get("rob_receive_task_time", 0)
    # rob_no
    rob_task_info_pb.rob_no = rob_task_info.get("rob_no", 0)
    # last_send_invite_time
    rob_task_info_pb.last_send_invite_time = rob_task_info.get("last_send_invite_time", 0)


def update_side_battle_unit_pb(player_infos, battle_unit_groups_pb):
    for player_info in player_infos:
        battle_unit_group_pb = battle_unit_groups_pb.add()
        for no, battle_unit in cPickle.loads(player_info.get("BattleUnitGrop")).items():
            battle_unit_pb = battle_unit_group_pb.group.add()
            assemble(battle_unit_pb, battle_unit)

def load_to_game_response(rewards, response):
    return_data = []
    for data in rewards:
        for k, v in data.items():
            return_data.append([k, v[0], v[2]])

    get_return(None, return_data, response)
