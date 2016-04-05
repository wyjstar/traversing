# -*- coding:utf-8 -*-
"""
@author: cui
"""
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
import time
from gfirefly.dbentrust.redis_mode import RedisObject

tb_guild_info = RedisObject('tb_guild_info')
from app.world.core.escort_task import EscortTask
from app.world.core.guild_boss import GuildBoss
from shared.utils.date_util import str_time_to_timestamp, get_current_timestamp
from shared.common_logic.shop import guild_shops, check_time, get_new_shop_info, \
    refresh_shop_info
from shared.utils.pyuuid import get_uuid
from shared.utils.const import const


class Guild(object):
    """公会
    """
    def __init__(self):
        """
        """
        self._name = 0                         # 名
        self._g_id = 0                         # id
        self._contribution = 0                 # 当前建设值
        self._all_contribution = 0             # 总建设值
        self._call = ''                        # 公告
        self._p_list = {}                      # 成员信息
        self._apply = []                       # 加入申请
        self._invite_join = {}                 # {id:time, id:time} 邀请加入
        self._icon_id = 0                      # 军团头像
        self._bless = [0, 0, 1]                # 祈福人数,福运,时间
        self._praise = [0, 0, 1]               # 点赞次数，累计金钱，时间
        self._build = {}                       # 建筑等级 {建筑类型：建筑等级}
        self._escort_tasks = {}                # 粮草押运任务
        self._escort_tasks_can_rob = []        # 粮草押运任务中可被抢夺的任务
        self._escort_tasks_invite_protect = {} # 粮草押运任务邀请
        self._escort_tasks_invite_rob = {}     # 粮草押运任务邀请
        self._guild_boss = GuildBoss()         # 圣兽
        self._guild_boss_trigger_times = 0     # 圣兽触发次数
        self._guild_boss_reset_time = 0        # 上次圣兽重置时间
        self._guild_skills = {}                # 军团等级
        self._last_attack_time = 0             # 上次攻击圣兽时间
        self._mine_help = {}                   # {time:[mine_id, u_id]}
        self._escort_tasks_ids = []            # 任务ids
        self._shop_data = {}                   # {shop_type: shop_info}  军团商店
        self._skill_point = 0                  # 技能点
        self._dynamics = []

        self.init_guild_skills()

    @property
    def _info(self):
        data = {'id': self._g_id,
                'name': self._name,
                'contribution': self._contribution,
                'all_contribution': self._all_contribution,
                'icon_id': self._icon_id,
                'bless': self._bless,
                'praise': self._praise,
                'guild_dynamics': self._dynamics,
                'call': self._call,
                'invite_join': self._invite_join,
                'mine_help': self._mine_help,
                'p_list': self._p_list,
                'build': self.build,
                'apply': self._apply,
                'escort_tasks_invite_protect': self._escort_tasks_invite_protect,
                'escort_tasks_invite_rob': self._escort_tasks_invite_rob,
                'guild_boss': self._guild_boss.property_dict(),
                'guild_boss_trigger_times': self._guild_boss_trigger_times,
                'guild_skills': self._guild_skills,
                'last_attack_time': self._last_attack_time,
                'guild_boss_reset_time': self._guild_boss_reset_time,
                'escort_tasks_ids': self._escort_tasks_ids,
                'shop_data': self._shop_data,
                'skill_point': self._skill_point,
                }
        return data

    def create_guild(self, p_id, name, icon_id):
        g_id = tb_guild_info.getObj('incr').incr()

        self._name = name
        self._g_id = g_id
        self._icon_id = icon_id
        self._p_list = {1: [p_id]}
        refresh_shop_info(self._shop_data, 1)

        guild_obj = tb_guild_info.getObj(self._g_id)
        guild_obj.new(self._info)
        return g_id

    def save_data(self):
        guild_data = tb_guild_info.getObj(self._g_id)
        guild_data.hmset(self._info)

    def init_data(self, data):
        self._g_id = data.get("id")
        self._name = data.get("name")
        self._contribution = data.get("contribution")
        self._all_contribution = data.get("all_contribution")
        self._icon_id = data.get("icon_id")
        self._bless = data.get("bless")
        self._dynamics = data.get("guild_dynamics", [])
        self._praise = data.get("praise")
        self._mine_help = data.get("mine_help")
        self._call = data.get("call")
        self._invite_join = data.get("invite_join")
        self._p_list = data.get("p_list")
        self._apply = data.get("apply")
        self._build = data.get("build")
        self._shop_data = data.get("shop_data")
        self._escort_tasks_ids = data.get("escort_tasks_ids", [])


        # 初始化粮草押运信息
        tb_guild_escort_tasks = tb_guild_info.getObj(self._g_id).getObj('escort_tasks')
        escort_tasks = tb_guild_escort_tasks.hgetall()
        for task_id, _data in escort_tasks.items():
            task = EscortTask(self)
            task.init_data(_data)
            self._escort_tasks[task.task_id] = task
        for k, task in self._escort_tasks.items():
            if task.state == 2:
                self._escort_tasks_can_rob.append(k)
                logger.debug("guild_id %s task info %s" % (self._g_id, task))
        logger.debug("escort_tasks_can_rob init_data %s" % self._escort_tasks_can_rob)

        boss = GuildBoss()
        boss.load(data.get("guild_boss", {}))
        self._guild_boss = boss
        self._guild_boss_trigger_times = data.get("guild_boss_trigger_times", 0)
        logger.debug("build %s" % data.get("build"))
        logger.debug("guild_skills %s" % data.get("guild_skills"))
        logger.debug("skill_point %s" % data.get("skill_point"))

        self._guild_skills = data.get("guild_skills", self._guild_skills)
        self._skill_point = data.get("skill_point", self._skill_point)

    def init_guild_skills(self):
        """docstring for init_guild_skills"""
        for i in range(1, 5):
            self._guild_skills[i] = 1

    def join_guild(self, p_id):
        if self._apply.count(p_id) >= 1:
            self._apply.remove(p_id)
        # if len(self._apply) >= 50:
        #     self._apply.pop(0)
        self._apply.append(p_id)

    def get_position(self, p_id):
        for position, p_list in self._p_list.items():
            if p_id in p_list:
                return position
        else:
            return 0

    def exit_guild(self, p_id, position):
        # 人数减去1
        # position_p_list = self._p_list.get(position)
        # position_p_list.remove(p_id)
        # self._p_list.update({position: position_p_list})
        self._p_list.get(position).remove(p_id)

    def delete_guild(self):
        guild_obj = tb_guild_info.getObj(self._g_id)
        guild_obj.delete()

    def change_position(self, p_id, position, position1):
        '''
        position 原
        position1 后
        '''
        self._p_list.get(position).remove(p_id)
        self._p_list.get(position1).append(p_id)

    def editor_call(self, call):
        self._call = call

    @property
    def p_num(self):
        num = 0
        for p_list in self._p_list.values():
            num += len(p_list)
        return num

    @property
    def build(self):
        build_conf = game_configs.base_config.get('guild_level')
        for build_type, build_level in build_conf.items():
            if build_level >= 1:
                if not self._build.get(build_type):
                    self._build[build_type] = build_level
        return self._build

    def add_dynamic(self, dynamic):
        if len(self._dynamics)+1 > 50:
            del self.dynamics[0]
        self.dynamics.append(dynamic)

    @build.setter
    def build(self, v):
        self._build = v

    @property
    def dynamics(self):
        return self._dynamics

    @property
    def all_contribution(self):
        return self._all_contribution

    @all_contribution.setter
    def all_contribution(self, v):
        self._all_contribution = v

    @property
    def contribution(self):
        return self._contribution

    @contribution.setter
    def contribution(self, v):
        self._contribution = v

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        self._name = name

    @property
    def apply(self):
        return self._apply

    @apply.setter
    def apply(self, t_p_id):
        self._apply = t_p_id

    @property
    def p_list(self):
        return self._p_list

    @p_list.setter
    def p_list(self, p_list):
        self._p_list = p_list

    @property
    def g_id(self):
        return self._g_id

    @g_id.setter
    def g_id(self, g_id):
        self._g_id = g_id

    @property
    def level(self):
        level = 0
        build_info = self.build
        for b_type, b_level in build_info.items():
            level += b_level
        return level

    @property
    def call(self):
        return self._call

    @call.setter
    def call(self, call):
        self._call = call

    @property
    def invite_join(self):
        return self._invite_join

    @invite_join.setter
    def invite_join(self, values):
        self._invite_join = values

    @property
    def icon_id(self):
        return self._icon_id

    @icon_id.setter
    def icon_id(self, values):
        self._icon_id = values

    @property
    def bless(self):
        return self._bless

    @bless.setter
    def bless(self, values):
        self._bless = values

    @property
    def escort_tasks(self):
        return self._escort_tasks

    @escort_tasks.setter
    def escort_tasks(self, values):
        self._escort_tasks = values

    @property
    def escort_tasks_can_rob(self):
        return self._escort_tasks_can_rob

    @escort_tasks_can_rob.setter
    def escort_tasks_can_rob(self, values):
        self._escort_tasks_can_rob = values

    @property
    def escort_tasks_invite_protect(self):
        return self._escort_tasks_invite_protect

    @escort_tasks_invite_protect.setter
    def escort_tasks_invite_protect(self, values):
        self._escort_tasks_invite_protect = values

    @property
    def escort_tasks_invite_rob(self):
        return self._escort_tasks_invite_rob

    @escort_tasks_invite_rob.setter
    def escort_tasks_invite_rob(self, values):
        self._escort_tasks_invite_rob = values

    @property
    def guild_skills(self):
        return self._guild_skills

    @guild_skills.setter
    def guild_skills(self, values):
        self._guild_skills = values

    @property
    def skill_point(self):
        return self._skill_point

    @skill_point.setter
    def skill_point(self, values):
        self._skill_point = values

    @property
    def guild_boss_trigger_times(self):
        return self._guild_boss_trigger_times

    @guild_boss_trigger_times.setter
    def guild_boss_trigger_times(self, values):
        self._guild_boss_trigger_times = values

    @property
    def guild_boss(self):
        return self._guild_boss

    @guild_boss.setter
    def guild_boss(self, values):
        self._guild_boss = values

    @property
    def praise_num(self):
        if time.localtime(self._praise[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._praise[0]

    @property
    def praise_money(self):
        if time.localtime(self._praise[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._praise[1]

    # self._praise = [0, 0, 1]  # 点赞次数，累计金钱，时间
    def add_praise_money(self, num):
        now = int(time.time())
        if time.localtime(self._praise[2]).tm_yday != time.localtime(now).tm_yday:
            self._praise = [1, num, int(time.time())]
        else:
            self._praise[0] += 1
            self._praise[1] += num
            self._praise[2] = now

    def receive_praise_money(self):
        self._praise[1] = 0

    @property
    def bless_luck_num(self):
        if time.localtime(self._bless[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._bless[1]

    @property
    def bless_num(self):
        if time.localtime(self._bless[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._bless[0]

    def do_bless(self, v1, v2, my_bless_times):
        self._contribution += v1
        self._all_contribution += v1
        if time.localtime(self._bless[2]).tm_yday != time.localtime().tm_yday:
            self._bless = [1, v2, int(time.time())]
        else:
            if not my_bless_times:
                self._bless[0] += 1
            self._bless[1] += v2

    def get_task_by_id(self, task_id):
        task = self._escort_tasks.get(task_id)
        if not task:
            logger.debug("task_id %s not exists!" % task_id)
            return None
        task.update_task_state()
        return task

    def add_task(self, task_info):
        task = EscortTask(self)
        task.task_id = task_info.get("task_id")
        task.task_no = task_info.get("task_no")
        task.state = task_info.get("state")
        task.add_player(task_info.get("player_info"), 1, 0, self.guild_info())
        self._escort_tasks[task.task_id] = task
        self._escort_tasks_ids.append(task.task_id)
        if len(self._escort_tasks_ids) > const.ESCORT_TASK_MAXNUM:
            task_id = self._escort_tasks_ids.remove(self._escort_tasks_ids[0])
            del self._escort_task_ids[task_id]
        task.update_task_state()
        task.save_data()

    @property
    def guild_data(self):
        data = {'id': self._g_id,
                'name': self._name,
                'icon_id': self._icon_id,
                'p_list': self._p_list,
                'p_num': self.p_num,
                'level': self.level,
                'dynamics': self._dynamics,
                'apply': self._apply,
                'call': self._call,
                'build': self.build,
                'contribution': self._contribution,
                'all_contribution': self._all_contribution,
                'praise_num': self.praise_num,
                'praise_money': self.praise_money,
                'bless_luck_num': self.bless_luck_num,
                'bless_num': self.bless_num,
                'guild_skills': self._guild_skills,
                'skill_point': self._skill_point,
                }
        return data

    def add_guild_boss(self, stage_id, blue_units, boss_type,
                       trigger_player_id, trigger_player_name):
        """docstring for add_boss"""
        logger.debug("add boss %s %s" % (blue_units, stage_id))
        boss = GuildBoss()
        boss._boss_id = get_uuid()
        boss.blue_units = blue_units
        boss.stage_id = stage_id
        boss.trigger_time = int(get_current_timestamp())
        boss.hp_max = boss.hp
        boss.boss_type = boss_type
        boss.trigger_player_id = trigger_player_id
        boss.trigger_player_name = trigger_player_name
        self._guild_boss = boss
        self._guild_boss_trigger_times = self._guild_boss_trigger_times + 1
        self.save_data()
        return boss

    @property
    def mine_help(self):
        return self._mine_help

    @mine_help.setter
    def mine_help(self, values):
        self._mine_help = values

    def reset_guild_boss_trigger_times(self):
        """
        重置公会boss召唤次数
        """
        str_time = game_configs.base_config.get("AnimalFresh")

        if self._guild_boss_reset_time < str_time_to_timestamp(str_time):
            self._guild_boss_reset_time = get_current_timestamp()
            self._guild_boss_trigger_times = 0
        self.save_data()

    def update_all_escort_task_state(self):
        """docstring for update_all_task_state"""
        for escort_task_id, escort_task in self._escort_tasks.items():
            escort_task.update_task_state()

    def get_shop_data(self, shop_type):
        if shop_type not in self._shop_data:
            logger.error('err shop type:%s', shop_type)
            logger.error('guild shop data:%s', self._shop_data)
            return None
        check_time(self._shop_data)
        self.save_data()
        return self._shop_data[shop_type]

    def guild_info(self):
        data = {'id': self._g_id,
                'name': self._name,
                'icon_id': self._icon_id,
                'p_list': self._p_list,
                'p_num': self.p_num,
                }
        return data
