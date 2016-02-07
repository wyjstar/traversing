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
const.ENERGY = 4
const.MIDDLE_STONE = 5
const.HIGH_STONE = 6
const.STAMINA = 7
const.PVP = 8
const.CONSUME_GOLD = 9
const.GUILD2 = 11
const.TEAM_EXPERIENCE = 12
const.NECTAR = 13
const.GUILD_ESCORT_ROB_TIMES = 14
const.GUILD_BOSS_TRIGGER_STONE = 15
const.SPIRIT= 16
const.GUILD_SKILL_POINT = 18
const.SHOE= 20
const.EQUIPMENT_ELITE = 21
const.RESOURCE_MAX = 40
const.HJQYCOIN = 25 # 功勋
const.HJQYFIGHTTOKEN = 26 # 征讨令
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

const.MAX_CONNECTION = 4000
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
const.RECHARGE = 33  # 充值掉落
const.ARENA_WIN = 32  # 竞技场获胜
const.FRIEND_REVENGE = 34  # pvp复仇
const.PVP_OVERCOME = 35  # 竞技场获胜
const.WORLD_BOSS_AWARD = 1701  # 世界boss奖励
const.LIVELY_REWARD = 40  # 好友活跃度奖励
const.FIRST_RECHARGE = 2204  # 历史充值

const.COMMON_BUY = 18  # 通用商城购买
const.COMMON_BUY_ITEM = 1803  # 通用商城购买道具
const.COMMON_BUY_GIFT = 1804  # 通用商城购买礼包
const.COMMON_BUY_MINE = 1807  # 通用商城密境商店
const.COMMON_BUY_HERO_SOUL = 1808  # 通用商城武魂商店
const.COMMON_BUY_PVP = 1809  # 通用商城PVP商店
const.COMMON_BUY_MELT = 1811  # 通用商城熔炼商店
const.COMMON_BUY_EQUIPMENT = 1812  # 通用商城装备商店

const.SIGN_GIFT = 1401  # 签到奖励
const.CONTINUS_SIGN = 1402  # 连续签到
const.REPAIR_SIGN = 1403  # 补充签到
const.BOX_SIGN = 1404  # 宝箱签到
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
const.TOMORROW_GIFT = 36  # 次日奖励
const.BUY_COIN = 1406  # 招财进宝
const.ReceivePraiseGift = 33
const.PraiseGift = 39
const.LIMIT_HERO = 37
const.TASK = 38
const.ACT20 = 41
const.ACT21 = 42
const.ReceiveBlessGift = 43
const.HERO_BREAK = 44  # 英雄突破
const.HERO_REFINE = 45  # 英雄炼体
const.HJQY_BATTLE = 46  # 黄巾起义战斗
const.MINE_RESET = 47  # 秘境重置地图
const.MINE_ACC = 48  # 秘境增产
const.RESET_PVP_TIME = 49  # 重置pvp时间
const.RUNT_REFRESH = 50  # 符文打造刷新
const.DREW = 51  # 煮酒
const.UNPAR_UPGRADE = 52  # 无双升级
const.SHOP_REFRESH = 53  # 商城刷新
const.BUY_STAMINA = 54  # 购买可恢复资源
const.AUTO_ADD = 55  # 自动恢复
const.BUY_COIN_ACT = 56  # 招财进宝活动
const.RUNT_PICK = 57  # 摘除符文
const.GUILD_BLESS = 58  # 军团膜拜
const.RESET_STAGE = 59  # 重置关卡
const.GUILD_CREATE = 60  # 创建军团
const.INHERIT_REFINE = 61  # 炼体传承
const.INHERIT_EQUIPMENT = 62  # 装备传承
const.INHERIT_UPARA = 63  # 无双传承
const.ENCOURAGE_HEROS = 64  # pvb鼓舞士气
const.PVB_REBORN = 65  # pvb复活
const.StageChestGift = 66  # 关卡宝箱
const.act_28 = 67  # 关卡宝箱

const.START_TARGET = 68  # 开服7日活动
const.STAGE_STAR_GIFT = 69  # 满星抽奖
const.RUNT_MAKE = 70  # 宝石合成
const.ROB_TREASURE_TRUCE = 71  # 夺宝休战
const.BUY_TRUCE_ITEM = 72  # 夺宝购买休战符
const.ROB_TREASURE = 73  # 夺宝
const.ROB_TREASURE_REWARD = 74  # 夺宝
const.GUILD_MOBAI = 75  # 膜拜
const.Bless = 76
const.FUND = 77
const.ACTIVITY = 78

const.ESCORT_ROB = 1909  # 劫运公会
const.REFRESH_ESCORT_TASKS = 1904 # 刷新押运任务

const.LOGIN_GIFT_CONTINUS = 8061
const.LOGIN_GIFT_CUMULATIVE = 8062

const.HJQY_ADD_REWARD = 21011

const.HERO_AWAKE = 119   # 英雄觉醒
const.UPGRADE_GUILD_SKILL = 2404 # 公会技能升级
const.GUILD_BOSS_IN = 240301 #   公会boss 参与
const.GUILD_BOSS_KILL = 240302 #  公会boss 击杀
const.GUILD_ACTIVITY = 250201 #
const.ADD_ACTIVITY = 260201 # 累积活动:元宝，体力，抽卡
# 等级流水
# const.STAGE = 27  # 关卡
# const.STAGE_SWEEP = 22  # 关卡扫荡
const.GAIN = 1  # 掉落

# ==================================================
# pvb奖励类型
const.PVB_TOP_TEN_AWARD = 1 #排名奖
const.PVB_ADD_UP_AWARD = 2 #累积奖
const.PVB_LAST_AWARD = 3 #斩杀奖
const.PVB_IN_AWARD = 4 #参与奖

const.DEBUG = False

const.level_rank_xs = 10000000
const.power_rank_xs = 1000

const.BATTLE_PVE = 1
const.BATTLE_PVP = 6
const.BATTLE_PVB = 7
const.BATTLE_MINE_PVE = 8
const.BATTLE_MINE_PVP = 9
const.BATTLE_HJQY = 10
const.BATTLE_GUILD_ESCORT = 13
const.BATTLE_GUILD_BOSS = 12

const.BOSS_NOT_EXIST = 0 # 不存在
const.BOSS_LIVE = 1  # 正常
const.BOSS_DEAD = 2      # 已死
const.BOSS_RUN_AWAY = 3  # 逃走

const.ROBOT_NUM = 2000

const.OPEN_FEATURE_HJQY = 1 # 黄巾起义
const.OPEN_FEATURE_TASK = 2 # 任务系统
const.OPEN_FEATURE_WORLD_BOSS = 3 # 世界boss
const.OPEN_FEATURE_GGZJ = 4 # 过关斩将

const.KEEP_USER_AFTER_DROP = 60 # 玩家掉线后保持玩家对象的时间

const.NEXT_DAY_FEATURES_BUTTON = 0 # 第二天功能开启按钮
const.FIRST_RECHARGE_BUTTON = 1 # 首次充值按钮
const.STAGE_LUCKY_BUTTON = 2 # 关卡点我有惊喜

# =================================================
# 军团动态类型
const.DYNAMIC_ZAN = 1
const.DYNAMIC_BLESS = 2
const.DYNAMIC_JOIN = 3
const.DYNAMIC_EXIT = 4
const.DYNAMIC_UP = 5
const.DYNAMIC_DOWN = 6
const.DYNAMIC_CHANGE = 7
const.DYNAMIC_KICK = 8
const.DYNAMIC_MOBAI = 9

const.ATTR_TYPE = {1:"hpHeroSelf",
             2:"atkHeroSelf",
             3:"physicalDefHeroSelf",
             4:"magicDefHeroSelf",
             5:"hitHero",
             6:"dodgeHero",
             7:"criHero",
             8:"criCoeffHero",
             9:"criDedCoeffHero",
             10:"blockHero",
             11:"ductilityHero"}

const.ESCORT_TASK_MAXNUM = 100
