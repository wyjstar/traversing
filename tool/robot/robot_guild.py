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
from app.proto_file.runt_pb2 import *
from app.proto_file.level_gift_pb2 import *
from app.proto_file.start_target_pb2 import *
from app.proto_file.rob_treasure_pb2 import *
from app.proto_file.guild_pb2 import *


class RobotGuild(Robot):
    def command_guild_dymanic(self):
        self.send_message('', 876)

    def rob_guild_dymanic_876(self, message):
        argument = GuildDynamicsResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_rob_treasure_init(self):
        self.send_message('', 858)

    def rob_treasure_init_858(self, message):
        argument = RobTreasureInitResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()
    """
    def command_rob_treasure_init(self):
        self.send_message('', 858)

    def rob_treasure_init_858(self, message):
        argument = RobTreasureInitResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_rob_treasure_truce(self):
        argument1 = RobTreasureTruceRequest()
        argument1.num = 2
        self.send_message(argument1, 859)

    def rob_treasure_truce_859(self, message):
        argument = RobTreasureTruceResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_rob_treasure_truce(self):
        argument1 = RobTreasureTruceRequest()
        argument1.num = 2
        self.send_message(argument1, 859)

    def rob_treasure_truce_859(self, message):
        argument = RobTreasureTruceResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_buy_rob_treasure_item(self):
        argument1 = BuyTruceItemRequest()
        argument1.num = 2
        self.send_message(argument1, 861)

    def buy_rob_treasure_item_861(self, message):
        argument = BuyTruceItemResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_refresh_rob_treasure_item(self):
        self.send_message("", 862)

    def refresh_rob_treasure_item_862(self, message):
        argument = RefreshRobTreasureResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_rob_treasure_reward(self):
        self.send_message("", 863)

    def rob_treasure_reward_863(self, message):
        argument = RobTreasureRewardResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_pvp_rob_treasure(self):
        argument1 = PvpRobTreasureRequest()
        argument1.uid = 1
        self.send_message(argument1, 864)

    def pvp_rob_treasure_864(self, message):
        argument = PvpFightResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_enhance_rob_treasure(self):
        argument1 = RobTreasureEnhanceRequest()
        argument1.no = ''
        argument1.use_no = ''
        self.send_message(argument1, 866)

    def enhance_rob_treasure_866(self, message):
        argument = RobTreasureEnhanceResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()
    # =====================

    def command_start_target_get(self):
        argument1 = GetStartTargetRewardRequest()
        argument1.target_id = 29001
        self.send_message(argument1, 1827)

    def start_target_get_1827(self, message):
        argument = GetStartTargetRewardResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_start_target(self):
        argument1 = GetStartTargetInfoRequest()
        argument1.day = 0
        self.send_message(argument1, 1826)

    def start_target_1826(self, message):
        argument = GetStartTargetInfoResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_new_level_gift(self):
        argument1 = StageInfoRequest()
        argument1.stage_id = 0
        self.send_message(argument1, 840)

    def new_level_gift_840(self, message):
        argument = NewLevelGiftResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_get_stage_info(self):
        argument1 = StageInfoRequest()
        argument1.stage_id = 0
        self.send_message(argument1, 901)

    def reset_get_stage_info_901(self, message):
        argument = StageInfoResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_get_award_info(self):
        argument1 = ChapterInfoRequest()
        argument1.chapter_id = 0
        self.send_message(argument1, 902)

    def reset_get_award_info_902(self, message):
        argument = ChapterInfoResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_star_award(self):
        argument1 = StarAwardRequest()
        argument1.chapter_id = 4
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
    """
