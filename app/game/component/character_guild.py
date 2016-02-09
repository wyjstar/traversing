# -*- coding:utf-8 -*-
"""
created by server on 14-7-24下午6:32.
"""
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs
from app.game.redis_mode import tb_character_info
import time
from gfirefly.server.globalobject import GlobalObject

remote_gate = GlobalObject().remote.get('gate')


class CharacterGuildComponent(Component):
    """
    公会组件类
    """

    def __init__(self, owner):
        super(CharacterGuildComponent, self).__init__(owner)
        self._g_id = 0  # 公会id

        self._contribution = 0  # 贡献
        self._all_contribution = 0  # 总贡献
        self._today_contribution = [0, int(time.time())]  # 今日贡献

        self._exit_time = 1  # 上次退出公会时间
        self._praise = [0, 1]  # 点赞次数，时间
        self._bless = [0, [], 0, 1]  # 祈福次数,领取的祈福奖励，今日贡献， 今日贡献时间
        self._apply_guilds = []  # 已经申请过的军团
        self._guild_rank_flag = 0  # 推荐列表，已经查询到的redis排行标记
        self._mobai = [0, [], 1]  # ［被膜拜次数，［膜拜李飚］，time］
        self._guild_boss_last_attack_time = {"time": 0, "boss_id": ''}  # 上次攻击圣兽时间
        self._mine_help = []  # 帮助过的时间戳

    def init_data(self, character_info):
        """
        初始化公会组件
        """
        self._g_id = character_info.get("guild_id")
        self._contribution = character_info.get("contribution")
        self._all_contribution = character_info.get("all_contribution")
        self._bless = character_info.get('bless')
        self._praise = character_info.get('praise')
        self._exit_time = character_info.get("exit_time")
        self._apply_guilds = character_info.get("apply_guilds")
        self._guild_boss_last_attack_time = character_info.get("guild_boss_last_attack_time", self._guild_boss_last_attack_time)
        if type(self._guild_boss_last_attack_time) == int:
            self._guild_boss_last_attack_time = {"time": 0, "boss_id": ''}  # 上次攻击圣兽时间
        self._mobai = character_info.get("guild_mobai", [0, [], 1])
        self._mine_help = character_info.get("mine_help")

    def save_data(self):
        data_obj = tb_character_info.getObj(self.owner.base_info.id)
        data_obj.hmset({'guild_id': self._g_id,
                        'contribution': self._contribution,
                        'all_contribution': self._all_contribution,
                        'bless': self._bless,
                        'praise': self._praise,
                        'apply_guilds': self._apply_guilds,
                        'guild_mobai': self._mobai,
                        'mine_help': self._mine_help,
                        'exit_time': self._exit_time,
                        'guild_boss_last_attack_time': self._guild_boss_last_attack_time,
                        })

    def new_data(self):
        data = {'guild_id': self._g_id,
                'contribution': self._contribution,
                'all_contribution': self._all_contribution,
                'bless': self._bless,
                'guild_mobai': self._mobai,
                'mine_help': self._mine_help,
                'praise': self._praise,
                'apply_guilds': self._apply_guilds,
                'exit_time': self._exit_time,
                'guild_boss_last_attack_time': self._guild_boss_last_attack_time,
                }
        return data

    @property
    def today_contribution(self):
        if time.localtime(self._bless[3]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._today_contribution[0]

    @property
    def guild_boss_last_attack_time(self):
        return self._guild_boss_last_attack_time

    @guild_boss_last_attack_time.setter
    def guild_boss_last_attack_time(self, value):
        self._guild_boss_last_attack_time = value

    @property
    def praise(self):
        return self._praise

    @praise.setter
    def praise(self, value):
        self._praise = value

    @property
    def bless(self):
        return self._bless

    @bless.setter
    def bless(self, value):
        self._bless = value

    @property
    def g_id(self):
        return self._g_id

    @g_id.setter
    def g_id(self, g_id):
        self._g_id = g_id

    @property
    def apply_guilds(self):
        return self._apply_guilds

    @apply_guilds.setter
    def apply_guilds(self, v):
        self._apply_guilds = v

    @property
    def exit_time(self):
        return self._exit_time

    @exit_time.setter
    def exit_time(self, exit_time):
        self._exit_time = exit_time

    @property
    def contribution(self):
        return self._contribution

    @contribution.setter
    def contribution(self, contribution):
        self._contribution = contribution

    @property
    def all_contribution(self):
        return self._all_contribution

    @all_contribution.setter
    def all_contribution(self, all_contribution):
        self._all_contribution = all_contribution

    def guild_attr(self):
        guild_level = 1
        guild_info = game_configs.guild_config.get(8).get(guild_level)
        if not guild_info:
            return {}

        return dict(hp=guild_info.profit_hp,
                    atk=guild_info.profit_atk,
                    physical_def=guild_info.profit_pdef,
                    magic_def=guild_info.profit_mdef)

    @property
    def praise_num(self):
        if time.localtime(self._praise[1]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._praise[0]

    def add_praise_times(self):
        if time.localtime(self._praise[1]).tm_yday != time.localtime().tm_yday:
            self._praise = [1, int(time.time())]
        else:
            self._praise[0] += 1
            self._praise[1] = int(time.time())

    @property
    def praise_time(self):
        return self._praise[1]

    @property
    def bless_times(self):
        if time.localtime(self._bless[3]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._bless[0]

    @property
    def bless_gifts(self):
        if time.localtime(self._bless[3]).tm_yday != time.localtime().tm_yday:
            return []
        return self._bless[1]

    @property
    def today_contribution(self):
        if time.localtime(self._bless[3]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._bless[2]

    def do_bless(self, v):
        if time.localtime(self._bless[3]).tm_yday != time.localtime().tm_yday:
            self._bless = [1, [], v, int(time.time())]
        else:
            self._bless[0] += 1
            self._bless[2] += v
            self._bless[3] += v
        self._contribution += v
        self._all_contribution += v

    def receive_bless_gift(self, v):
        if time.localtime(self._bless[3]).tm_yday != time.localtime().tm_yday:
            self._bless = [0, [v], 0, int(time.time())]
        else:
            self._bless[1].append(v)

    @property
    def be_mobai_times(self):
        if time.localtime(self._mobai[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._mobai[0]

    @property
    def mobai_times(self):
        if time.localtime(self._mobai[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return len(self._mobai[1])

    @property
    def mobai_list(self):
        if time.localtime(self._mobai[2]).tm_yday != time.localtime().tm_yday:
            return []
        return self._mobai[1]

    def do_mobai(self, v):
        if time.localtime(self._mobai[2]).tm_yday != time.localtime().tm_yday:
            self._mobai = [0, [v], int(time.time())]
        else:
            self._mobai[1].append(v)

    def be_mobai(self):
        if time.localtime(self._mobai[2]).tm_yday != time.localtime().tm_yday:
            self._mobai = [1, [], int(time.time())]
        else:
            self._mobai[0] += 1

    def receive_mobai(self):
        self._mobai[0] = 0

    @property
    def mine_help(self):
        return self._mine_help

    @mine_help.setter
    def mine_help(self, v):
        self._mine_help = v

    def get_shop_data(self, t):
        return remote_gate['world'].get_shop_data_remote(self.owner.guild.g_id, t)

    def get_guild_member_ids(self, p_list):
        member_ids = []
        for _, v in p_list.items():
            member_ids.extend(v)
        return member_ids

    def exit_guild(self):
        self._g_id = 0
        self._mobai[0] = 0
