# -*- coding:utf-8 -*-
"""
@author: cui
"""
from app.world.core.guild import Guild
from app.world.redis_mode import tb_guild_info
from shared.utils.random_pick import get_random_items_from_list
import copy


class GuildManager(object):
    """公会
    """
    def __init__(self):
        """
        """
        self._guilds = {}  # {id:obj}
        print("wzp_abc", tb_guild_info.getAllKeys("tb_guild_info*[0-9]"))
        for k in tb_guild_info.getAllKeys("tb_guild_info*[0-9]"):
            k = k.replace("tb_guild_info:", "")
            print("guild_id", k)
            data1 = tb_guild_info.getObj(k).hgetall()
            guild = Guild()
            guild.init_data(data1)
            print("%s %s %s k, can-ids, tasks" % (k, guild.escort_tasks_can_rob, guild.escort_tasks.keys))
            self._guilds[int(k)] = guild

    def get_guild_obj(self, g_id):
        """获取军团对象
        """
        print("get_guild_obj g_id %s" % g_id)
        print("create guild %s" % len(self._guilds))
        guild_obj = self._guilds.get(g_id)
        if guild_obj:
            return guild_obj
        else:
            print("no guild exist1!")
        data = tb_guild_info.getObj(g_id).hgetall()
        if not data:
            print("no guild exist2!")
            return None
        else:
            guild_obj = Guild()
            guild_obj.init_data(data)
            self._guilds[g_id] = guild_obj
            return guild_obj

    def create_guild(self, p_id, g_name, icon_id):
        guild_obj = Guild()
        guild_obj.create_guild(p_id, g_name, icon_id)
        self._guilds[guild_obj.g_id] = guild_obj
        return guild_obj

    def delete_guild(self, g_id):
        guild_obj = self.get_guild_obj(g_id)
        if guild_obj:
            guild_obj.delete_guild()
            del self._guilds[g_id]

    def get_can_rob_escort_tasks(self, player_g_id):
        """
        获取可劫的粮草押运任务
        """
        target_num = 5
        task_ids = {}

        guilds = {}
        print("player_g_id", player_g_id, len(self._guilds), type(player_g_id))

        for k, guild in self._guilds.items():
            print("%s %s %s k, can-ids" % (k, guild.escort_tasks_can_rob, type(k)))
            if len(guild.escort_tasks_can_rob) > 0 and player_g_id != k:
                guild.update_all_escort_task_state()
                print("%s %s %s k, can-ids" % (k, guild.escort_tasks_can_rob, k))
                guilds[k] = copy.deepcopy(guild.escort_tasks_can_rob)

        print("get_can_rob_escort_tasks %s" % guilds)

        if len(guilds) >= target_num:
            res_g_ids = get_random_items_from_list(target_num, guilds.keys())
            for g_id in res_g_ids:
                tmp_task_ids = get_random_items_from_list(1, guilds[g_id])
                if tmp_task_ids:
                    task = self._guilds[g_id].get_task_by_id(tmp_task_ids[0])
                    task_ids[tmp_task_ids[0]] = g_id
        else:
            while len(task_ids) < target_num:
                num = len(task_ids)
                for g_id, tmp_task_ids in guilds.items():
                    print("tmp_task_ids %s" % tmp_task_ids)
                    tmp_ids = get_random_items_from_list(1, tmp_task_ids)
                    if tmp_ids:
                        print("tmp_ids %s" % tmp_ids)
                        task_id = tmp_ids[0]
                        tmp_task_ids.remove(task_id)
                        task_ids[task_id] = g_id
                if num == len(task_ids):
                    break

        print("get_can_rob_escort_tasks ids %s" % task_ids)
        tasks = {}
        for task_id, g_id in task_ids.items():
            task = self._guilds[g_id].get_task_by_id(task_id)
            tasks[task.task_id] = task

        return tasks


guild_manager_obj = GuildManager()
#guild_obj = guild_manager_obj.create_guild(1989, "mock_guild_name", 0)
#guild_obj.build[4] = 10
#guild_manager_obj._guilds[1989] = guild_obj
