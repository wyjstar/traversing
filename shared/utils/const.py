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
const.JUNIOR_STONE = 4
const.MIDDLE_STONE = 5
const.HIGH_STONE = 6
const.STAMINA = 7
const.PVP = 8
const.GUILD = 9
const.GUILD2 = 11
const.TEAM_EXPERIENCE = 12
const.NECTAR = 13
const.STONE1 = 14
const.STONE2 = 15
const.EQUIPMENT_ELITE = 21
const.RESOURCE_MAX = 23
const.RESOURCE = 107

const.HERO = 101
const.HERO_CHIP = 103
const.EQUIPMENT = 102
const.EQUIPMENT_CHIP = 104
const.ITEM = 105
const.BIG_BAG = 106
const.RUNT = 108
const.TRAVEL_ITEM = 109
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
# 1     银两
# 2     元宝
# 3     武魂
# 4     百炼石（待用）
# 5     千锤石（待用）
# 6     精炼石（待用）
# 7     体力
# 8     军功（竞技场积分）
# 10    公会贡献值
# 11    公会资金值
# 12    战队经验
# 13    琼浆玉露
# 14    原石
# 15    晶石
# 16    元气
# 17    活跃度
# 18    草鞋
# 19    布鞋
# 20    皮鞋
# 21    装备精华
# 22    商店幸运值

const.MAX_CONNECTION = 2000
const.TIME_OUT = 60 * 10  # 秒
const.TLOG_ADDR = ('192.168.10.25', 6667)

# ========t_log=============
const.ADD = 0
const.REDUCE = 1

# ==道具流水，获得原因==
const.MELTING_EQUIPMENT = 1  # 装备熔炼
const.HERO_SELL = 2  # 武将出售
const.HERO_SACRIFICE_OPER = 3  # 武将献祭
const.USE_ITEM = 4  # 使用物品
const.LEVEL_GIFT = 5  # 等级活动奖励
const.NEW_LEVEL_GIFT = 6  # 等级推送
const.LIVELY = 7  # 活跃
const.CUMULATIVE_LOGIN_GIFT = 8  # 累积登陆奖励
const.CONTINUOUS_LOGIN_GIFT = 9  # 连续登陆奖励
const.MAIL = 10  # 邮件
const.MINE_EXCHANGE = 11  # 秘境神秘商人
const.MINE_REWARD = 12  # 秘境宝箱
const.NEW_GUIDE_STEP = 13  # 新手引导
const.SHOP_BUY_GIFT_PACK = 14  # 商城,购买礼包
const.SHOP_BUY_ITEM = 15  # 商城购买道具
const.SHOP_DRAW_HERO = 16  # 商城抽英雄
const.SHOP_DRAW_EQUIPMENT = 17  # 商城抽装备
const.COMMON_BUY = 18  # 通用商城购买
const.SIGN_GIFT = 19  # 签到奖励
const.CONTINUS_SIGN = 20  # 连续签到
const.REPAIR_SIGN = 21  # 补充签到
const.STAGE_SWEEP = 22  # 关卡扫荡
const.CHAPTER_AWARD = 23  # 章节奖励
const.TRAVEL = 24  # 游历
const.TRAVEL_OPEN_CHEST = 25  # 游历宝箱
const.TRAVEL_AUTO = 26  # 自动游历
const.STAGE = 27  # 关卡

const.ENHANCE_EQUIPMENT = 28  # 装备强化
const.ONLINE_GIFT = 29  # 在线奖励
const.GM = 30  # gm发放
const.HERO_CHIP_SACRIFICE_OPER = 31  # 武将碎片献祭

# 等级流水
# const.STAGE = 27  # 关卡
# const.STAGE_SWEEP = 22  # 关卡扫荡
const.GAIN = 1  # 掉落

# ==================================================

const.DEBUG = False
