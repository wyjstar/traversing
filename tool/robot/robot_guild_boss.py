# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file import guild_pb2
#import GetEscortTasksResponse

class RobotGuildBoss(Robot):

    def command_0get_all_task_info(self):
        self.stage_id = 0
        request = ""
        self.send_message(request, 2401)

    def get_guild_boss_init_2401(self, message):
        print "get_all_task_info_2401==================="
        response = guild_pb2.GuildBossInitResponse()
        response.ParseFromString(message)
        self.stage_id = response.guild_boss.stage_id

        self.on_command_finish()

    def command_1trigger_boss(self):
        request = guild_pb2.TriggerGuildBossRequest()
        request.boss_type = 1
        self.send_message(request, 2402)

    def trigger_boss_2402(self, message):
        print "trigger_boss_2402==================="
        response = guild_pb2.TriggerGuildBossResponse()
        response.ParseFromString(message)
        self.on_command_finish()

    def command_2battle(self):
        request = guild_pb2.GuildBossBattleRequest()
        request.stage_id = 910001
        print(request)
        self.send_message(request, 2403)


    def battle_2403(self, message):
        print "2403==================="
        response = guild_pb2.GuildBossBattleResponse()
        response.ParseFromString(message)

        self.on_command_finish()

    def command_3upgrade_guild_skill(self):
        request = guild_pb2.UpGuildSkillRequest()
        request.skill_type = 1
        self.send_message(request, 2404)


    def upgrade_guild_skill_2404(self, message):
        print "2404==================="
        response = guild_pb2.UpGuildSkillResponse()
        response.ParseFromString(message)

        self.on_command_finish()

