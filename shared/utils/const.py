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

const.COIN = 1
const.GOLD = 2
const.HERO_SOUL = 3
const.HERO = 101
const.HERO_CHIP = 103
const.EQUIPMENT = 102
const.EQUIPMENT_CHIP = 104
const.ITEM = 105
const.BIG_BAG = 106
# 1：金币
# 2：充值币
# 3：武魂
# 4：低级洗练石
# 5：中级洗练石
# 6：高级洗练石
# 7：体力（关卡）
# 8：积分（竞技场）
# 9：耐力（活动）
# 10：贡献值（帮派）
# 11：资金值（帮派值）
# 12：战队经验
# 101 武将类型 （对应hero表）
# 102 装备类型 （对应equipment表）
# 103 武将碎片类型 （对应chip表中碎片类型为1的）
# 104 装备碎片类型 （对应chip表中碎片类型为2的）
# 105 游戏道具类型 （对应item表）
# 106 掉落大包（对应big_bag表）


