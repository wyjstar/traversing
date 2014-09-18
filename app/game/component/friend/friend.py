# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""

import datetime
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_friend


class FriendComponent(Component):
    def __init__(self, owner):
        super(FriendComponent, self).__init__(owner)
        self._friends = []
        self._blacklist = []
        self._applicants_list = {}

    def init_data(self):
        friend_data = tb_character_friend.getObjData(self.owner.base_info.id)

        if friend_data:
            self._friends = friend_data.get('friends')
            self._blacklist = friend_data.get('blacklist')
            self._applicants_list = friend_data.get('applicants_list')

    def save_data(self):
        friend_obj = tb_character_friend.getObj(self.owner.base_info.id)
        count = len(self._friends) + len(self._blacklist) + len(self._applicants_list)
        if count > 0:
            if friend_obj:
                data = {'friends': self._friends,
                        'blacklist': self._blacklist,
                        'applicants_list': self._applicants_list}
                friend_obj.update_multi(data)
            else:
                data = {'id': self.owner.base_info.id,
                        'friends': self._friends,
                        'blacklist': self._blacklist,
                        'applicants_list': self._applicants_list}
                tb_character_friend.new(data)
        elif friend_obj:
            tb_character_friend.deleteMode(self.owner.base_info.id)


    @property
    def friends(self):
        return self._friends


    @property
    def blacklist(self):
        return self._blacklist


    @property
    def applicant_list(self):
        return self._applicants_list

    def is_friend(self, friend_id):
        if friend_id in self._friends:
            return True
        return False

    def is_in_blacklist(self, target_id):
        if target_id in self._blacklist:
            return True
        return False

    def is_in_applicants_list(self, target_id):
        for k, v in self._applicants_list.items():
            period = datetime.datetime.now() - v
            if period.days > 2:
                del(self._applicants_list[k])

        if target_id in self._applicants_list.keys():
            return True
        return False

    def add_friend(self, friend_id, is_active=True):
        if friend_id in self._friends:
            return False

        if friend_id in self._blacklist:
            return False

        if is_active:
            if not friend_id in self._applicants_list:
                return False
            del(self._applicants_list[friend_id])

        self._friends.append(friend_id)
        return True

    def del_friend(self, friend_id):
        if not friend_id in self._friends:
            return False

        self._friends.remove(friend_id)
        return True

    def add_blacklist(self, target_id):
        if target_id in self._blacklist:
            return False

        if target_id in self._friends:
            return False

        self._blacklist.append(target_id)
        return True

    def del_blacklist(self, target_id):
        if not target_id in self._blacklist:
            return False

        self._blacklist.remove(target_id)
        return True

    def add_applicant(self, target_id):
        if target_id in self._applicants_list.keys():
            return False

        if target_id in self._friends:
            return False

        if target_id in self._blacklist:
            return False

        self._applicants_list[target_id] = datetime.datetime.now()
        return True

    def del_applicant(self, target_id):
        if not target_id in self._applicants_list:
            return False

        del(self._applicants_list[target_id])
        return True
