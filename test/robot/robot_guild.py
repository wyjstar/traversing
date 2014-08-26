# -*- coding:utf-8 -*-
"""
created by server on 14-8-26下午4:27.
"""
from robot import Robot
from app.proto_file.equipment_request_pb2 import EnhanceEquipmentRequest
from app.proto_file.equipment_response_pb2 import EnhanceEquipmentResponse


class RobotGuild(Robot):
    def command_enhance_equipment(self):
        argument1 = EnhanceEquipmentRequest()
        argument1.id = u"0004"
        argument1.type = 1
        argument1.num = 10
        self.send_message(argument1, 402)

    def get_fnd_402(self, message):
        argument = EnhanceEquipmentResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()
