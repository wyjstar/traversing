# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午3:19.
"""
from app.game.core.PlayersManager import PlayersManager
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file import item_pb2
from shared.db_opear.configs_data.game_configs import item_config, big_bag_config
from app.game.core.drop_bag import BigBag
from app.game.logic.item_group_helper import gain, get_return
from app.game.logic.common.check import have_player
from app.proto_file.item_response_pb2 import GetItemsResponse, ItemUseResponse


@have_player
def get_items(dynamic_id, **kwargs):
    player = kwargs.get('player')
    print "playerid", player.base_info.id
    items = player.item_package.get_all()
    # game_items = {1000:1, 1001:2}
    response = GetItemsResponse()
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
    if not item_config_item:
        print("item %d is not itemconfig." % item_no)
        return
    print "item_no", item_no
    print "item_num", item_num
    print "item_config_item", item_config_item
    print ("item????????", item_config_item.dropId)
    item_func = item_config_item.func
    drop_id = item_config_item.dropId
    func_args1 = item_config_item.funcArgs1
    func_args2 = item_config_item.funcArgs2

    response = ItemUseResponse()
    common_response = response.res  # = common_response
    common_response.result = True

    # 校验道具数量
    item = player.item_package.get_item(item_no)
    if not item or item.num < item_num:
        common_response.result = False
        common_response.result_no = 106
        # common_response.message = u"道具不足！"
        return response.SerializeToString()

    if item_func == 2:
        # 宝箱
        box_key_no = func_args1
        box_key = player.item_package.get_item(box_key_no)
        if not box_key or box_key.num < func_args2 * item_num:
            common_response.result = False
            common_response.result_no = 107
            # common_response.message = u"box key 不足！" + str(func_args2 * item_num) + "_" + str(box_key.num)
            return response.SerializeToString()
        # 消耗key
        box_key.num -= func_args2 * item_num
        if box_key.num == 0:
            player.item_package.get_item
        player.item_package.save_data()
    # 消耗道具
    item.num -= item_num




    big_bag = BigBag(drop_id)
    for i in range(item_num):
        drop_item_group = big_bag.get_drop_items()
        return_data = gain(player, drop_item_group)
        get_return(player, return_data, response.gain)

    return response.SerializeToString()


