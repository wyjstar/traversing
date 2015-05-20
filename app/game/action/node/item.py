# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午4:16.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import item_pb2
from shared.db_opear.configs_data import game_configs
from app.game.core.drop_bag import BigBag
from app.game.core.item_group_helper import gain, get_return
from app.proto_file.item_response_pb2 import GetItemsResponse, ItemUseResponse
from gfirefly.server.logobj import logger
from shared.utils.const import const


@remoteserviceHandle('gate')
def get_items_301(pro_data, player):
    """取得全部道具 """
    items = player.item_package.get_all()
    # game_items = {1000:1, 1001:2}
    response = GetItemsResponse()
    for item in items:
        _item = response.items.add()
        _item.item_no = item.item_no
        _item.item_num = item.num
        logger.debug("get items:%d  %d" % (item.item_no, item.num))
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def use_item_302(pro_data, player):
    """使用道具"""
    item_pb = item_pb2.ItemPB()
    item_pb.ParseFromString(pro_data)
    item_no = item_pb.item_no
    item_num = item_pb.item_num
    print("request:", item_pb)
    item_config_item = game_configs.item_config.get(item_no)
    if not item_config_item:
        return
    item_func = item_config_item.func
    drop_id = item_config_item.dropId
    func_args1 = item_config_item.funcArg1
    func_args2 = item_config_item.funcArg2

    response = ItemUseResponse()
    common_response = response.res  # = common_response
    common_response.result = True

    # 校验道具数量
    item = player.item_package.get_item(item_no)
    if not item or item.num < item_num:
        common_response.result = False
        common_response.result_no = 106
        print("error:", 106)
        # common_response.message = u"道具不足！"
        return response.SerializeToString()

    if item_func == 2:
        # 宝箱
        box_key_no = func_args1
        box_key = player.item_package.get_item(box_key_no)
        if not box_key or box_key.num < func_args2 * item_num:
            print("error:", 107)
            common_response.result = False
            common_response.result_no = 107
            # common_response.message = u"box key 不足！" + str(func_args2 * item_num) + "_" + str(box_key.num)
            return response.SerializeToString()
        # 消耗key
        #box_key.num -= func_args2 * item_num
        player.item_package.consume_item(box_key_no, item_num)
        player.item_package.save_data()

    big_bag = BigBag(drop_id)
    for i in range(item_num):
        drop_item_group = big_bag.get_drop_items()
        return_data = gain(player, drop_item_group, const.USE_ITEM)
        get_return(player, return_data, response.gain)

    logger.debug("item_no:%s", item_no)
    logger.debug("item_num:%s", item_num)

    # 使用招财符
    if item_config_item.canUse == 11:
        player.buy_coin.extra_can_buy_times += item_num

    player.item_package.consume_item(item_no, item_num)

    return response.SerializeToString()
