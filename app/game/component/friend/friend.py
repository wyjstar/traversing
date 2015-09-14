# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""

import datetime
import time

from app.game.action.root import netforwarding
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from app.proto_file.db_pb2 import Stamina_DB
from app.game.core.mail_helper import send_mail


class FriendComponent(Component):
    def __init__(self, owner):
        super(FriendComponent, self).__init__(owner)
        self._friends = {}
        self._blacklist = {}
        self._applicants_list = {}

        self._reward = {}
        self._fight_times = {}  # 小伙伴支援次数
        self._fight_last_time = {}  # 小伙伴上次战斗时间
        self._given_record = []      # 体力赠送纪录（用来第二天重置）
        self._reset_time = 0         # 体力赠送记录重置的时间(最后一次在几号)

    def init_data(self, character_info):
        self._friends = character_info.get('friends')
        self._blacklist = character_info.get('blacklist')
        if isinstance(self._blacklist, list):
            d = {}
            for i in self._blacklist:
                d[i] = 0
            self._blacklist = d

        self._applicants_list = character_info.get('applicants_list')
        self._reward = character_info.get('freward', {})
        self._fight_times = character_info.get('ffight_times_', {})
        self._fight_last_time = character_info.get('ffight_last_time_', {})
        self._given_record = character_info.get('given_record', [])
        self._reset_time = character_info.get('reset_time', 0)

        print("#"*66)
        print(self._given_record, self._reset_time)
        today = time.localtime(time.time())
        if self._reset_time != today.tm_mday:
            print("#"*66, "reset given record")
            self._reset_time = today.tm_mday
            self._given_record = []

    def save_data(self):
        friend_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(friends=self._friends,
                    blacklist=self._blacklist,
                    applicants_list=self._applicants_list,
                    freward=self._reward,
                    ffight_times_=self._fight_times,
                    ffight_last_time_=self._fight_last_time,
                    given_record=self._given_record,
                    reset_time=self._reset_time
                    )
        friend_obj.hmset(data)

    def new_data(self):
        data = dict(friends=self._friends,
                    blacklist=self._blacklist,
                    applicants_list=self._applicants_list,
                    freward=self._reward,
                    ffight_times_=self._fight_times,
                    ffight_last_time_=self._fight_last_time,
                    given_record=self._given_record,
                    reset_time=self._reset_time
                    )
        return data

    def check_time(self):
        supporttime = game_configs.base_config.get('supporttime')
        now = time.time()
        for pid in self._fight_times.keys():
            if not self._fight_times[pid]:
                del(self._fight_times[pid])
                continue
            _time = self._fight_times[pid][0]
            if (now - _time) / 60 > supporttime:
                del(self._fight_times[pid])

    @property
    def friends(self):
        date_now = datetime.datetime.now().date()
        for k in self._friends.keys():
            self._friends[k] = filter(lambda t: t.date() == date_now,
                                      self._friends[k])

        return self._friends.keys()

    @property
    def blacklist(self):
        return self._blacklist.keys()

    @property
    def fight_times(self):
        return self._fight_times

    @property
    def fight_last_time(self):
        return self._fight_last_time

    @property
    def applicant_list(self):
        for k, v in self._applicants_list.items():
            period = datetime.datetime.now() - v
            if period.days > 2:
                del (self._applicants_list[k])

        return self._applicants_list.keys()

    def is_friend(self, friend_id):
        if friend_id in self._friends.keys():
            return True
        return False

    def is_in_blacklist(self, target_id):
        if target_id in self._blacklist.keys():
            return True
        return False

    def can_revenge(self, black_id):
        if black_id not in self._blacklist.keys():
            return False
        if self._blacklist[black_id] != 0:
            return False
        return True

    def revenge(self, black_id):
        if black_id in self._blacklist.keys():
            self._blacklist[black_id] = 1

    def is_in_applicants_list(self, target_id):
        if target_id in self.applicant_list:
            return True
        return False

    def add_friend(self, friend_id, is_active=True):
        if not isinstance(friend_id, int):
            logger.error('add friend:%s', friend_id)
        max_num_friend = game_configs.base_config.get('max_of_UserFriend')
        if len(self.friends) >= max_num_friend:
            return False

        if friend_id in self._friends.keys():
            if friend_id in self._applicants_list:
                del(self._applicants_list[friend_id])
            return False

        if friend_id in self._blacklist.keys():
            if friend_id in self._applicants_list:
                del(self._applicants_list[friend_id])
            return False

        if is_active:
            if friend_id not in self._applicants_list:
                return False

        if friend_id in self._applicants_list:
            del(self._applicants_list[friend_id])

        friend_stamina = Stamina_DB()
        friend_info = tb_character_info.getObj(friend_id)
        stamina_data = friend_info.hget('stamina')
        if stamina_data is not None:
            friend_stamina.ParseFromString(stamina_data)

            if self.owner.base_info.id in friend_stamina.contributors:
                self._friends[friend_id] = [datetime.datetime.now()]
            else:
                self._friends[friend_id] = []
        else:
            self._friends[friend_id] = []

        if friend_id in self._given_record:
            self._friends[friend_id] = [datetime.datetime.now()]

        return True

    def del_friend(self, friend_id):
        if friend_id not in self._friends.keys():
            return False

        del self._friends[friend_id]
        return True

    def add_blacklist(self, target_id):
        if not isinstance(target_id, int):
            logger.error('add blacklist:%s', target_id)
        max_num_blacklist = game_configs.base_config.get('max_of_Userblacklist')
        if len(self.blacklist) >= max_num_blacklist:
            return False

        if target_id in self._blacklist.keys():
            return False

        # if target_id in self._friends.keys():
        #     return False

        self._blacklist[target_id] = 0
        return True

    def del_blacklist(self, target_id):
        if target_id not in self._blacklist.keys():
            return False

        del self._blacklist[target_id]
        return True

    def add_applicant(self, target_id):
        if not isinstance(target_id, int):
            logger.error('add applicants_list:%s', target_id)
        max_num_applicant = game_configs.base_config.get('maxOfFriendApply')
        if len(self.applicant_list) >= max_num_applicant:
            return False

        if target_id in self._applicants_list.keys():
            return False

        if target_id in self._friends.keys():
            return False

        if target_id in self._blacklist.keys():
            return False

        self._applicants_list[target_id] = datetime.datetime.now()
        return True

    def del_applicant(self, target_id):
        if target_id not in self._applicants_list:
            return False

        del (self._applicants_list[target_id])
        return True

    def last_present_times(self, target_id):
        given_time_list = self._friends.get(target_id)
        if given_time_list is None:
            return 0
        given_times = len(given_time_list)
        return max(1 - given_times, 0)

    def given_stamina(self, target_id, if_present=True):
        if target_id not in self._friends.keys():
            logger.error('given_stamina can not find friend!:%s', target_id)
            return False
        given_time_list = self._friends[target_id]
        given_times = len(given_time_list)
        if given_times >= 1:
            logger.error('given_stamina times!:%s', given_times)
            return False

        given_time_list.append(datetime.datetime.now())
        if not if_present:
            logger.error('given_stamina present!:%s', if_present)
            return True

        send_mail(conf_id=1, receive_id=target_id,
                  nickname=self.owner.base_info.base_name)
        self._given_record.append(target_id)

        return True

    def get_reward(self, fid, day):
        """
        @param stat: 0:not,1:ok,2:get
        """
        update = False
        if fid in self._reward.keys():
            if self._reward[fid][0] != day:
                self._reward[fid] = [day, 0]
                update = True
        else:
            self._reward[fid] = [day, 0]
            update = True

        return self._reward[fid][1], update

    def set_reward(self, fid, day, stat):
        self._reward[fid] = [day, stat]
