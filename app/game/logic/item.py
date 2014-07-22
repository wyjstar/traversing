# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午3:19.
"""
from app.game.core.PlayersManager import PlayersManager
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file import item_pb2
from shared.db_opear.configs_data.game_configs import item_config, big_bag_config
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.player_response_pb2 import GameResourcesResponse
from app.game.core.drop_bag import BigBag
from app.game.logic.item_group_helper import gain, get_return
from app.game.logic.common.check import have_player


@have_player
def get_items(dynamic_id, **kwargs):
    player = kwargs.get('player')
    items = player.item_package.get_all()
    # game_items = {1000:1, 1001:2}
    response = item_pb2.GetItemsResponse()
    for item in items:
        _item = response.items.add()
        _item.item_no = item.item_no
        _item.item_num = item.num
    return response.SerializePartialToString()


@have_player
def use_item(dynamic_id, pro_data, **kwargs):
    player = kwargs.get('player')
    item_pb = item_pb2.ItemPB()
    item_pb.ParseFromString(pro_data)
    item_no = item_pb.item_no
    item_num = item_pb.item_num
    item_config_item = item_config.get(item_no)
    item_func = item_config_item.func
    drop_id = item_config_item.dropId
    func_args1 = item_config_item.func_args1
    func_args2 = item_config_item.func_args2

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


