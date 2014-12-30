# -*- coding:utf-8 -*-
"""
created by server on 14-8-26下午4:27.
"""
from robot import Robot
from app.proto_file.equipment_request_pb2 import EnhanceEquipmentRequest
from app.proto_file.equipment_response_pb2 import EnhanceEquipmentResponse
from app.proto_file.stage_request_pb2 import *
from app.proto_file.stage_response_pb2 import *
from app.proto_file.travel_pb2 import *
from app.proto_file.travel_shoes_pb2 import *
from app.proto_file.runt_pb2 import *


class RobotGuild(Robot):
    def command_star_award(self):
        argument1 = StarAwardRequest()
        argument1.chapter_id = 100101
        argument1.award_type = 1
        self.send_message(argument1, 909)

    def reset_star_award_909(self, message):
        argument = StarAwardResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_reset_stage(self):
        argument1 = ResetStageRequest()
        argument1.stage_id = 100101
        self.send_message(argument1, 908)

    def reset_stage_908(self, message):
        argument = ResetStageResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_init_runt(self):
        argument1 = BuyShoesRequest()
        for i in [1, 2, 3]:
            shoes_info = argument1.shoes_infos.add()
            shoes_info.shoes_type = i
            shoes_info.shoes_no = i
        self.send_message(argument1, 843)

    def init_runt_843(self, message):
        argument = InitRuntResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()


    def command_buy_shoes(self):
        argument1 = BuyShoesRequest()
        for i in [1, 2, 3]:
            shoes_info = argument1.shoes_infos.add()
            shoes_info.shoes_type = i
            shoes_info.shoes_no = i
        self.send_message(argument1, 832)

    def buy_shoes_832(self, message):
        argument = BuyShoesResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_open_chest(self):
        argument1 = TravelRequest()
        argument1.stage_id = 900001
        self.send_message(argument1, 836)

    def open_chest_836(self, message):
        argument = OpenChestResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_travel(self):
        argument1 = TravelRequest()
        argument1.stage_id = 900001
        self.send_message(argument1, 831)

    def travel_831(self, message):
        argument = TravelResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_travel_init(self):
        argument1 = Travel()
        argument1.event_id = 1
        self.send_message(argument1, 830)

    def travel_init_830(self, message):
        argument = TravelInitResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

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

    def command_stage(self):

        argument1 = StageStartRequest()
        argument1.stage_id = 100101
        # argument1.fid = 1120
        line_up = argument1.lineup.add()
        line_up.pos = 1
        line_up.hero_id = 10005
        line_up = argument1.lineup.add()
        line_up.pos = 2
        line_up.hero_id = 10029
        line_up = argument1.lineup.add()
        line_up.pos = 3
        line_up.hero_id = 10043
        line_up = argument1.lineup.add()
        line_up.pos = 4
        line_up.hero_id = 0
        line_up = argument1.lineup.add()
        line_up.pos = 5
        line_up.hero_id = 0
        line_up = argument1.lineup.add()
        line_up.pos = 6
        line_up.hero_id = 0

        self.send_message(argument1, 903)

    def in_stage_903(self, message):
        # 进入战斗
        argument = StageStartResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

        # argument1 = StageSettlementRequest()
        # argument1.stage_id = 700101
        # argument1.result = 1
        # self.send_message(argument1, 904)

    def drop_904(self, message):
        # 进入战斗
        argument = StageSettlementResponse()
        argument.ParseFromString(message)
        print argument
