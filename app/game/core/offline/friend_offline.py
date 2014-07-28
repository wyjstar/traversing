# -*- coding:utf-8 -*-
"""
created by server on 24-7-19下午2:27.
"""
import datetime
from app.game.redis_mode import tb_character_friend


class FriendOffline(object):
    def __init__(self, player_id):
        self._player_id = player_id
        self._player_data = tb_character_friend.getObjData(self._player_id)
        self._player_obj = tb_character_friend.getObj(self._player_id)

    def add_applicant(self, target_id):
        player_applicants = self._player_data.get('applicants_list')
        if target_id in player_applicants.key():
            print 'offline add applicant', 'exist in applicants!!!!'
            return False

        player_friends = self._player_data.get('friends')
        if target_id in player_friends:
            print 'offline add applicant', 'exist in friend!!!!'
            return False

        player_blacklist = self._player_data.get('blacklist')
        if target_id in player_blacklist:
            print 'offline add applicant', 'exist in blacklist!!!!'
            return False

        player_applicants[target_id] = datetime.datetime.now()
        self._player_obj.update('applicants_list', player_applicants)
        return True

    def add_friend(self, friend_id):
        player_friends = self._player_data.get('friends')

        if friend_id in player_friends:
            print 'offline add friend', 'exist in friend list'
            return False

        return True

    def del_friend(self, friend_id):
        player_friends = self._player_data.get('friends')

        if not friend_id in player_friends:
            print 'offline del friend', 'can not find friend'
            return False

        return True

