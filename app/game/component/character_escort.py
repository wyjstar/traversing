# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午7:00.
"""
from app.game.component.Component import Component
from app.game.core.hero import Hero
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from app.game.core.task import hook_task, CONDITIONId
from shared.utils.date_util import str_time_to_timestamp, get_current_timestamp
from shared.utils.random_pick import random_pick_with_weight
from shared.utils.pyuuid import get_uuid
from app.game.action.node._fight_start_logic import assemble
from app.proto_file import escort_pb2, common_pb2


class CharacterEscortComponent(Component):
    """粮草押运组件"""

    def __init__(self, owner):
        super(CharacterEscortComponent, self).__init__(owner)
        self._tasks = {}          # 押运任务列表
        self._protect_records = []     # 我的押运记录
        self._rob_records = []         # 我的劫运记录
        self._start_protect_times = 0; # 开始押运次数
        self._protect_times = 0;       # 保护押运次数
        self._rob_times = 0;           # 参与劫运次数
        self._refresh_times = 0;       # 刷新押运列表
        self._refresh_task_time = 0;   # 刷新押运任务列表时间

    def init_data(self, character_info):
        self._tasks = character_info.get('tasks')

    def save_data(self):
        pass

    def new_data(self):
        return {}

    def check_time(self):
        escort_refresh = game_configs.base_config.get("EscortRefresh")
        escort_refresh = str_time_to_timestamp(escort_refresh)
        if self._refresh_task_time < escort_refresh:
            self.refresh_tasks()
            self._refresh_times = get_current_timestamp()
            self.save_data()

    def refresh_tasks(self):
        """刷新押运列表"""
        items = {}
        for item in game_configs.guild_task_config:
            items[item.id] = item.weights

        task_num = game_configs.base_config.get('EscortTaskShowQuantity')

        for _ in task_num:
            result_no = random_pick_with_weight(items)
            self.add_task(result_no)

    def receive_task(self):
        """
        接受任务
        """
        pass

    def add_task(self, task_no):
        """
        添加任务或者记录
        """
        task = EscortTask()
        task.task_id = get_uuid()
        task.task_no = task_no
        self.tasks[task.task_id] = task


class Guild():
    """docstring for Guild"""
    def __init__(self):
        self._tasks = {}

    def get_task_by_id(self, task_id):
        return self._tasks.get(task_id)

    def add_task(self, task):
        pass

    def save_data(self):
        pass



class EscortTask():
    """粮草押运组件"""

    def __init__(self):
        self._task_id = ''
        self._task_no = 0
        self._state = 0 # 0: 初始状态；1：接受任务2：开始押运3已经完成
        self._receive_task_time = 0 #
        self._start_protect_time = 0 #
        self._protect_guild_info = {}
        self._protecters = []

        self._rob_task_infos = []

    def update_pb(self, task_pb):
        """
        更新protobuff
        """
        task_pb.task_id = self._task_id
        task_pb.task_no = self._task_no
        task_pb.state = self._state
        task_pb.receive_task_time = self._receive_task_time
        task_pb.start_protect_time = self._start_protect_time
        for rob_task_info in self._rob_task_infos:
            rob_task_info_pb = task_pb.rob_task_infos.add()
            self.update_rob_task_info(rob_task_info, rob_task_info_pb)

    def update_rob_task_info_pb(self, rob_task_info, rob_task_info_pb):
        # guild
        self.update_guild_pb(rob_task_info.get("rob_guild_info"), rob_task_info_pb.rob_guild_info)
        # robbers
        self.update_player_info_pb(rob_task_info.get("robbers"), rob_task_info_pb.robbers)
        # protect battle units
        self.update_side_battle_unit_pb(self._protecters, rob_task_info_pb.red)
        self.update_side_battle_unit_pb(rob_task_info.get("robbers"), rob_task_info_pb.blue)
        # seed
        rob_task_info_pb.seed1 = rob_task_info.get("seed1")
        rob_task_info_pb.seed2 = rob_task_info.get("seed2")
        # rob reward
        rob_response_pb = common_pb2.GameResourcesResponse()
        rob_task_info_pb.rob_reward = rob_response_pb.ParseFromString(rob_task_info.get("rob_reward", ""))
        # rob_result
        rob_task_info_pb.rob_result = rob_task_info.get("rob_result")



    def update_side_battle_unit_pb(self, player_infos, battle_unit_group_pb):
        for player_info in player_infos:
            battle_unit_group_pb = battle_unit_group_pb.add()
            for battle_unit in player_info.get("BattleUnitGrop"):
                battle_unit_pb = battle_unit_group_pb.group.add()
                assemble(battle_unit_pb, battle_unit)


    def update_guild_pb(self, guild_info, guild_info_pb):
        guild_info_pb.g_id = guild_info.get("g_id", -1)
        guild_info_pb.rank = guild_info.get("rank", -1)
        guild_info_pb.name = guild_info.get("name", "")
        guild_info_pb.level = guild_info.get("level", 0)
        guild_info_pb.president = guild_info.get("president", "")
        guild_info_pb.p_num = guild_info.get("p_num")
        guild_info_pb.icon_id = guild_info.get("icon_id", 0)
        guild_info_pb.call = guild_info.get("call", "")

    def update_player_infos_pb(self, player_infos, player_infos_pb):
        pass




    def add_player(self, player, protect_or_rob, header=0):
        player_info = {}
        player_info["id"] = player.base_info.id
        player_info["nickname"] = player.base_info.base_name
        player_info["level"] = player.base_info.level
        player_info["head"] = player.base_info.heads.now_head
        player_info["vip_level"] = player.base_info.vip_level
        player_info["power"] = int(player.line_up_component.combat_power)
        player_info["BattleUnitGrop"] = player.fight_cache_component.get_red_units()
        if protect_or_rob == 1:
            self._protecters.append(player_info)
        elif protect_or_rob == 2:
            if not header:
                rob_task_info = {}
                rob_task_info["robbers"] = []
                rob_task_info["robbers"].append(player_info)
                self._rob_task_infos[player.base_info.id] = rob_task_info
            else:
                rob_task_info = self._rob_task_infos.get(header)
                rob_task_info["robbers"].append(player_info)

        Guild().save_data()


        return True

    def is_finished(self, task_item):
        if self._start_protect_time and self._start_protect_time + task_item.taskTime < get_current_timestamp():
            return True
        elif not self._start_protect_time and self._receive_task_time + task_item.wait + task_item.taskTime < get_current_timestamp():
            return True
        return False

    def rob_success_times(self):
        """
        劫运成功的次数
        """
        times = 0
        for rob_task_info in self._rob_task_infos:
            if rob_task_info.get("rob_result"):
                times = times + 1
        return times

