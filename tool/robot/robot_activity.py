# -*- coding:utf-8 -*-
"""
created by server on 14-9-2上午11:42.
"""
from app.proto_file.feast_pb2 import EatFeastResponse
from robot import Robot
from app.proto_file import online_gift_pb2
from app.proto_file import level_gift_pb2
from app.proto_file import pvp_rank_pb2
from app.proto_file import line_up_pb2
from app.proto_file import google_pb2
from app.proto_file import recharge_pb2
from app.proto_file import activity_pb2
from app.proto_file import shop_pb2
# from app.proto_file import soul_shop_pb2


class RobotActivity(Robot):
    # online gift

    def command_0_last_activity(self):
        self.send_message("", 2601)
    def last_activity_init_2601(self, msg):
        self.on_command_finish()
    #def command_92_get_reward_guild_activity(self):
        #request = activity_pb2.GuildActivityGetRewardRequest()
        #request.act_id = 52001
        #self.send_message(request, 2502)
    #def guild_activity_get_reward_2502(self, msg):
        #self.on_command_finish()

    #def command_91_test_guild_activity(self):
        #self.send_message("", 2503)
    #def guild_activity_init_2503(self, msg):
        #self.on_command_finish()

    #def command_92_get_reward_guild_activity(self):
        #request = activity_pb2.GuildActivityGetRewardRequest()
        #request.act_id = 52001
        #self.send_message(request, 2502)
    #def guild_activity_get_reward_2502(self, msg):
        #self.on_command_finish()



    #def command_get_online_gift(self, gift_id):
        #request = online_gift_pb2.GetOnlineGift()
        #request.gift_id = int(gift_id)
        #self.send_message(request, 1121)

    #def get_online_gift_1121(self, message):
        #response = online_gift_pb2.GetOnlineGiftResponse()
        #response.ParseFromString(message)
        #print 'result:', response.result
        #print 'gain:', response.gain
        #self.on_command_finish()

    ## level gift
    #def command_get_level_gift(self, gift_id):
        #request = level_gift_pb2.GetLevelGift()
        #request.gift_id = int(gift_id)
        #self.send_message(request, 1131)

    #def get_level_gift_1131(self, message):
        #response = level_gift_pb2.GetLevelGiftResponse()
        #response.ParseFromString(message)
        #print 'result:', response.result
        #print 'gain:', response.gain
        #self.on_command_finish()

    #def command_get_online_level_gift_data(self):
        #self.send_message(None, 1120)

    #def get_online_level_gift_data_1120(self, message):
        #response = online_gift_pb2.GetOnlineLevelGiftData()
        #response.ParseFromString(message)
        #print 'online time:', response.online_time
        #for _ in response.received_online_gift_id:
            #print 'received online gift:', _
        #for _ in response.received_level_gift_id:
            #print 'received online gift:', _
        #self.on_command_finish()

    #def command_eat_feast(self, hello):
        #self.send_message(None, 820)

    #def eat_feast_820(self, message):
        #argument = EatFeastResponse()
        #argument.ParseFromString(message)
        #print argument
        #self.on_command_finish()

    #def command_pvp_player_info(self, rank):
        #request = pvp_rank_pb2.PvpPlayerInfoRequest()
        #request.player_rank = int(rank)
        #self.send_message(request, 1504)

    #def get_player_info_1504(self, message):
        #response = line_up_pb2.LineUpResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()

    #def command_pvp_top_rank(self):
        #self.send_message(None, 1501)

    #def command_pvp_player_rank(self):
        #self.send_message(None, 1502)

    #def command_pvp_player_rank_refresh(self):
        #self.send_message(None, 1503)

    #def get_player_info_1501(self, message):
        #response = pvp_rank_pb2.PlayerRankResponse()
        #response.ParseFromString(message)
        #for _ in response.rank_items:
            #print _.nickname, _.rank
        #self.on_command_finish()

    #def get_player_info_1502(self, message):
        #response = pvp_rank_pb2.PlayerRankResponse()
        #response.ParseFromString(message)
        #for _ in response.rank_items:
            #print _.nickname, _.rank
        #self.on_command_finish()

    #def get_player_info_1503(self, message):
        #response = pvp_rank_pb2.PlayerRankResponse()
        #response.ParseFromString(message)
        #for _ in response.rank_items:
            #print _.nickname, _.rank
        #self.on_command_finish()

    #def command_pvp_fight_player(self, rank):
        #request = pvp_rank_pb2.PvpFightRequest()
        #request.challenge_rank = int(rank)
        #self.send_message(request, 1505)

    #def get_fight_response_1505(self, message):
        #response = pvp_rank_pb2.PvpFightResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()

    #def command_arena_shop_refresh(self):
        #self.send_message(None, 1511)

    ## def get_arena_shop_response_1511(self, message):
    ##     response = soul_shop_pb2.GetShopItemsResponse()
    ##     response.ParseFromString(message)
    ##     print response
    ##     self.on_command_finish()

    ## def command_get_arena_shop(self):
    ##     self.send_message(None, 1512)

    ## def get_arena_shop_response_1512(self, message):
    ##     response = soul_shop_pb2.GetShopItemsResponse()
    ##     response.ParseFromString(message)
    ##     print response
    ##     self.on_command_finish()

    #def command_recharge(self, recharge):
        #request = google_pb2.RechargeTest()
        #request.recharge_num = int(recharge)
        #self.send_message(request, 1000000)

    #def none_1000000(self, message):
        #print message
        #self.on_command_finish()

    #def command_get_recharge(self):
        #self.send_message(None, 1150)

    #def none_1150(self, message):
        #response = recharge_pb2.GetRechargeGiftDataResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()

    #def command_take_recharge_gift(self, gift_id, recharge_time):
        #request = recharge_pb2.GetRechargeGiftRequest()
        #recharge_item = request.gift.add()
        #recharge_item.gift_id = int(gift_id)
        #_data = recharge_item.data.add()
        #_data.recharge_accumulation = int(recharge_time)
        #self.send_message(request, 1151)

    #def none_1151(self, message):
        #response = recharge_pb2.GetRechargeGiftResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()

    #def command_get_activity_gift(self, activity_id, quantity):
        #request = activity_pb2.GetActGiftRequest()
        #request.act_id = int(activity_id)
        #request.quantity = int(quantity)
        #self.send_message(request, 1834)

    #def none_1834(self, message):
        #response = activity_pb2.GetActGiftResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()

    #def command_buy_shop_item(self, shop_id, num):
        #request = shop_pb2.ShopRequest()
        #request.ids.append(int(shop_id))
        #request.item_count.append(int(num))
        #self.send_message(request, 505)

    #def none_505(self, message):
        #response = shop_pb2.ShopResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()

    #def command_get_fund_activity_gift(self, activity_id):
        #request = activity_pb2.GetActGiftRequest()
        #request.act_id = int(activity_id)
        #self.send_message(request, 1850)

    #def none_1850(self, message):
        #response = activity_pb2.GetActGiftResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()

    #def command_get_activate_activity_gift(self, activity_id):
        #request = activity_pb2.GetActGiftRequest()
        #request.act_id = int(activity_id)
        #self.send_message(request, 1851)

    #def none_1851(self, message):
        #response = activity_pb2.GetActGiftResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()

    #def command_get_fund_activity_info(self):
        #self.send_message(None, 1854)

    #def none_1854(self, message):
        #response = activity_pb2.GetFundActivityResponse()
        #response.ParseFromString(message)
        #print response
        #self.on_command_finish()
