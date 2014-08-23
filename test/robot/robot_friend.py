# -*- coding:utf-8 -*-
"""
created by server on 14-8-22下午2:45.
"""

from robot import Robot
from app.proto_file import friend_pb2


class RobotFriend(Robot):
    def command_get_friend_list(self):
        request = friend_pb2.FriendCommon()
        self.send_message(request, 1106)

    def command_add_friend(self, target_id):
        request = friend_pb2.FriendCommon()
        request.target_ids.append(target_id)
        # self.send_message(request, 1101)
        self.send_message(request, 1100)

    def command_accept_friend(self, target_id):
        request = friend_pb2.FriendCommon()
        request.target_ids.append(target_id)
        self.send_message(request, 1101)

    def command_refuse_friend(self, target_id):
        request = friend_pb2.FriendCommon()
        request.target_ids.append(target_id)
        self.send_message(request, 1102)

    def command_find_friend(self, key):
        request = friend_pb2.FindFriendRequest()
        request.id_or_nickname = key
        self.send_message(request, 1107)

    def get_friend_list_1106(self, message):
        # get friend list
        response = friend_pb2.GetPlayerFriendsResponse()
        response.ParseFromString(message)
        # print 'get friends list:'
        print 'frinds:', len(response.friends)
        for _ in response.friends:
            print 'friend:', _
        print 'blacklist:', len(response.blacklist)
        for _ in response.blacklist:
            print 'blacklist:', _
        print 'applicant list:', len(response.applicant_list)
        for _ in response.applicant_list:
            print 'applicant list:', _

        self.on_command_finish()
