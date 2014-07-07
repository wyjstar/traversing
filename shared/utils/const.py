# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""


class ConstError(Exception):
    pass


class _const(object):
    """定义常量
    """

    def __setattr__(self, key, value):
        if key in self.__dict__:
            raise ConstError
        else:
            self.__dict__[key] = value


const = _const()

const.ACCOUNT_COMMAND = [1, 2, 3]  # 帐号服务器命令编号
const.PLAYER_TYPE = 1  # 玩家
const.MONSTER_TYPE = 2  # 怪物npc
const.PET_TYPE = 3  # 宠物

# 物品类型
const.ITEM_NONE = 0  # 空物品
const.ITEM_COIN = 1  # 金币
const.ITEM_PAY_COIN = 2  # 充值币

const.ITEM_HERO = 101  # 武将类型
const.ITEM_EQUIP = 102  # 装备类型

const.LINE_UP_INDEX = [1, 2, 3, 4, 5, 6]  # 阵容编号

