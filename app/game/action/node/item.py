# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午4:16.
"""
from app.game.core.PlayersManager import PlayersManager
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file import item_pb2
from shared.db_opear.configs_data.game_configs import item_config, big_bag_config
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.player_response_pb2 import GameResourcesResponse
from app.game.core.drop_bag import BigBag
from app.game.logic.item_group_helper import gain, get_return


@remote_service_handle
def get_items_301(dynamic_id, pro_data):
    """取得全部道具
    """
    print '301', dynamic_id, pro_data
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
    print player
    game_items = player.item_package.items
    # game_items = {1000:1, 1001:2}
    items = item_pb2.ItemsResponse()
    item = items.item
    for item_no, item_num in game_items.items():
        _item = item.add()
        _item.item_no = item_no
        _item.item_num = item_num
    return items.SerializePartialToString()


@remote_service_handle
def use_item_302(dynamic_id, pro_data):
    """使用道具"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
    item_pb = item_pb2.ItemPB()
    item_pb.ParseFromString(pro_data)

    item_no = item_pb.item_no
    item_num = item_pb.item_num
    item_config_item = item_config.get(item_no)

    item_func = item_config_item.func
    drop_id = item_config_item.dropId
    func_args1 = item_config_item.func_args1
    func_args2 = item_config_item.func_args2

    common_response = CommonResponse()
    common_response.result = True
    game_resources_response = GameResourcesResponse()
    common_response = game_resources_response.res  # = common_response
    common_response.result = True

    if item_func == 2:
        # 宝箱
        box_key_no = func_args1
        box_key = player.item_package.get_item(box_key_no)
        if not box_key or box_key.num < func_args2 * item_num:
            common_response.result = False
            common_response.message = "box key 不足！" + str(func_args2 * item_num) + "_" + box_key.num
            return game_resources_response
        # 消耗key
        box_key.num -= func_args2 * item_num
        player.item_package.save_data()

    big_bag = BigBag(drop_id)
    for i in range(item_num):
        drop_item_group = big_bag.get_drop_items()
        return_data = gain(player, drop_item_group)
        get_return(player, return_data, game_resources_response)
    return game_resources_response.SerializeToString()














