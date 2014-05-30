#-*- coding:utf-8 -*-
"""
created by server on 14-5-19上午11:47.
"""

from gfirefly.utils.singleton import Singleton


class ChatRoomManager(object):
    """聊天室房间管理
    """

    __metaclass__ = Singleton

    def __init__(self):
        self._rooms = {}  # key:room_id, values: set(dynamic_id)

    def join_room(self, dynamic_id, room_id):
        """
        @param dynamic_id: int client id
        @param room_id: int room id
        """
        room = self._rooms.get(room_id, None)
        if room is None:
            self._rooms[room_id] = set()
        self._rooms[room_id].add(dynamic_id)

    def leave_room(self, dynamic_id, room_id):
        """
        @param dynamic_id: int client id
        @param room_id: int room id
        """
        room = self._rooms.get(room_id, None)
        if room is None:
            return
        room.remove(dynamic_id)

    def get_room_member(self, room_id):
        """
        @param room_id: int room id
        """
        targets = self._rooms.get(room_id, None)
        if not targets:
            return []
        return targets
