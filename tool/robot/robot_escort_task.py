# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file import escort_pb2, common_pb2
#import GetEscortTasksResponse

class RobotEscortTask(Robot):

    def command_get_all_task_info(self):
        self.tasks = {}
        request = ""
        self.send_message(request, 1901)

    def get_all_task_info_1901(self, message):
        print "get_all_task_info_1901==================="
        response = escort_pb2.GetEscortTasksResponse()
        response.ParseFromString(message)
        for task in response.tasks:
            task_info = {}
            task_info["task_id"] = task.task_id
            task_info["task_no"] = task.task_no
            task_info["state"] = task.state
            task_info["g_id"] = 1989
            self.tasks[task.task_id] = task_info

        self.on_command_finish()

    def command_get_escort_record(self):
        request = escort_pb2.GetEscortRecordsRequest()
        request.record_type = 1
        self.send_message(request, 1902)

    def get_escort_record_1902(self, message):
        print "get_escort_record_1902==================="
        response = escort_pb2.GetEscortTasksResponse()
        response.ParseFromString(message)
        self.on_command_finish()

    def command_refresh_can_rob_tasks(self):
        request = ""
        self.send_message(request, 1903)
    def refresh_can_rob_tasks_1903(self, message):
        print "refresh_can_rob_tasks_1903==================="
        response = escort_pb2.GetEscortTasksResponse()
        response.ParseFromString(message)
        self.on_command_finish()

    def command_refresh_tasks(self):
        request = ""
        self.send_message(request, 1904)
    def refresh_tasks_1904(self, message):
        print "refresh_tasks_1904==================="
        response = escort_pb2.RefreshEscortTaskResponse()
        response.ParseFromString(message)
        self.on_command_finish()

    def command_receive_task(self):
        request = escort_pb2.ReceiveEscortTaskRequest()
        request.task_id = self.tasks.keys()[0]
        request.task_guild_id = 1989
        request.protect_or_rob = 1
        self.send_message(request, 1905)

    def command_receive_rob_task(self):
        request = escort_pb2.ReceiveEscortTaskRequest()
        request.task_id = self.tasks.keys()[0]
        request.protect_or_rob = 2
        request.task_guild_id = 1989
        self.send_message(request, 1905)

    def receive_task_1905(self, message):
        print "receive_task_1905==================="
        response = common_pb2.CommonResponse()
        response.ParseFromString(message)

        self.on_command_finish()

    def command_zzcancel_escort_task(self):
        request = escort_pb2.CancelEscortTaskRequest()
        request.task_id = self.tasks.keys()[0]
        request.task_guild_id = 1989
        self.send_message(request, 1906)

    def cancel_escort_task_1906(self, message):
        print "cancel_escort_task_1906==================="
        response = common_pb2.CommonResponse()
        response.ParseFromString(message)

        self.on_command_finish()

    def command_invite(self):
        request = escort_pb2.InviteEscortTaskRequest()
        request.task_id = self.tasks.keys()[0]
        request.task_guild_id = 1989
        request.protect_or_rob = 1
        request.send_or_in = 1
        self.send_message(request, 1908)
    def command_zjoin_invite(self):
        request = escort_pb2.InviteEscortTaskRequest()
        request.task_id = self.tasks.keys()[0]
        request.task_guild_id = 1989
        request.protect_or_rob = 1
        request.send_or_in = 2
        self.send_message(request, 1908)

    def invite_1908(self, message):
        print "invite_1908==================="
        response = common_pb2.CommonResponse()
        response.ParseFromString(message)
        self.on_command_finish()
    def command_start_task(self):
        request = escort_pb2.StartEscortTaskRequest()
        request.task_id = self.tasks.keys()[0]
        request.task_guild_id = 1989
        request.protect_or_rob = 1
        #request.send_or_in = 1
        self.send_message(request, 1909)

    def start_task_1909(self, message):
        print "start_task_1909==================="
        response = escort_pb2.StartEscortTaskResponse()
        response.ParseFromString(message)
        self.on_command_finish()

    def command_start_rob_task(self):
        request = escort_pb2.StartEscortTaskRequest()
        request.task_id = self.tasks.keys()[0]
        request.task_guild_id = 1989
        request.protect_or_rob = 2
        #request.send_or_in = 1
        self.send_message(request, 1909)

    def push_to_team_when_join_team_19081(self, message):
        print "push_to_team_when_join_team_19081==================="
        response = escort_pb2.StartEscortTaskResponse()
        response.ParseFromString(message)
        self.on_command_finish()

    def push_to_guild_when_invite_19082(self, message):
        print "push_to_guild_when_invite_19082==================="
        response = escort_pb2.StartEscortTaskResponse()
        response.ParseFromString(message)
        self.on_command_finish()
