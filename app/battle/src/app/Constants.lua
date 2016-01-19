g_notice = g_notice or {}   -- 通知的宏定义
g_other  = g_other or {}    -- 其他字符串宏定义
g_friendSubmodule = g_friendSubmodule or {}     -- 好友子模块名称定义
G_PLATFORM = G_PLATFORM or {}       -- 平台定义

G_BOTTOM_DEFINE = G_BOTTOM_DEFINE or {}       -- 按钮属性宏定义

const = const or {}
const.POS_ARMY = cc.p(320, 260)
const.POS_ENEMY = cc.p(320, 700)

const.BACK_FROM_CIRIKAIQI = "BACK_FROM_CIRIKAIQI"
const.BACK_FROM_NEXTDAY = "BACK_FROM_NEXTDAY"  --次日奖励返回主界面
const.BACK_FROM_COMMON_DETAIL = "BACK_FROM_COMMON_DETAIL"  --道具说明返回
const.POS_UNPARA_ICON_STAGE = cc.p(130,200)
const.POS_UNPARA_ICON_FIGHT = cc.p(55,55)
const.FIGHT_POS_UNPARA_ICON = cc.p(130,355)
BIG_SCALE = 0.58
TYPE_ACTIVITY_LIMIT_SHOP = "limitShop"  --限时商店类型

const.HOME_ARMY = {
    [1] = {point = cc.pAdd(const.POS_ARMY, cc.p(-190, 90)), scale = BIG_SCALE},
    [2] = {point = cc.pAdd(const.POS_ARMY, cc.p(0, 90)), scale = BIG_SCALE},
    [3] = {point = cc.pAdd(const.POS_ARMY, cc.p(190, 90)), scale = BIG_SCALE},
    [4] = {point = cc.pAdd(const.POS_ARMY, cc.p(-190, -100)), scale = BIG_SCALE},
    [5] = {point = cc.pAdd(const.POS_ARMY, cc.p(0, -100)), scale = BIG_SCALE},
    [6] = {point = cc.pAdd(const.POS_ARMY, cc.p(190, -100)), scale = BIG_SCALE},
    [7] = {point = cc.pAdd(const.POS_ARMY, cc.p(0, -260)),scale = 0.55},
    [8] = {point = cc.pAdd(const.POS_ARMY, cc.p(0, 0)),scale = 0.55},
    [9] = {point = cc.pAdd(const.POS_ARMY, cc.p(0, 220)),scale = 0.55},
    [10] = {point = cc.pAdd(const.POS_ARMY, cc.p(0, 440)),scale = 0.55},
    [11] = {point = cc.pAdd(const.POS_ARMY, cc.p(0, 700)),scale = 0.55},
    [12] = {point = cc.pAdd(const.POS_ARMY, cc.p(0, 0)),scale = BIG_SCALE},

}

const.HOME_ENEMY = {
    [1] = {point = cc.pAdd(const.POS_ENEMY, cc.p(-190, -90)), scale = BIG_SCALE},
    [2] = {point = cc.pAdd(const.POS_ENEMY, cc.p(0, -90)), scale = BIG_SCALE},
    [3] = {point = cc.pAdd(const.POS_ENEMY, cc.p(190, -90)), scale = BIG_SCALE},
    [4] = {point = cc.pAdd(const.POS_ENEMY, cc.p(-190, 100)), scale = BIG_SCALE},
    [5] = {point = cc.pAdd(const.POS_ENEMY, cc.p(0, 100)), scale = BIG_SCALE},
    [6] = {point = cc.pAdd(const.POS_ENEMY, cc.p(190, 100)), scale = BIG_SCALE},

    [7] = {point = cc.pAdd(const.POS_ENEMY, cc.p(0, 260)),scale = 0.55},
    [8] = {point = cc.pAdd(const.POS_ENEMY, cc.p(0, 0)),scale = 0.55},
    [9] = {point = cc.pAdd(const.POS_ENEMY, cc.p(0, -220)),scale = 0.55},
    [10] = {point = cc.pAdd(const.POS_ENEMY, cc.p(0, -440)),scale = 0.55},
    [11] = {point = cc.pAdd(const.POS_ENEMY, cc.p(0, -700)),scale = 0.55},

    [12] = {point = cc.pAdd(const.POS_ENEMY, cc.p(0, -700)),scale = BIG_SCALE},
}
const.BOSS_HOME = {point = const.POS_ENEMY, scale = BIG_SCALE}

const.EVENT_MAKE_CARD_ITEM          = "MAKE_CARD_ITEM"
const.EVENT_SHOW_TEMP_HERO_EFFECT   = "SHOW_TEMP_HERO_EFFECT"
const.EVENT_SHOW_TEMP_HERO_EFFECT_2   = "SHOW_TEMP_HERO_EFFECT_2"
--const.EVENT_MAKE_CARD_ENEMY         = "MAKE_CARD_ENEMY"
const.EVENT_REST_CARD_ITEM          = "REST_CARD_ITEM"
const.EVENT_ANEW_CARD_ITEM          = "ANEW_CARD_ITEM"
const.EVENT_PRELUDE_BEGIN           = "PRELUDE_BEGIN"
const.EVENT_PRELUDE_END             = "PRELUDE_END"
const.EVENT_INTERLUDE_BEGIN         = "INTERLUDE_BEGIN"
const.EVENT_INTERLUDE_END           = "INTERLUDE_END"
const.EVENT_FIGHT_BEGIN             = "FIGHT_BEGIN" --战斗开始
const.EVENT_ROUND_BEGIN             = "ROUND_BEGIN" --回合开始
const.EVENT_BUFF_END                = "BUFF_END"    --回合Buff结束
const.EVENT_ROUND_END               = "ROUND_END"   --AfterBuff结束
const.EVENT_FIGHT_VICTORY           = "FIGHT_VICTORY"
const.EVENT_FIGHT_DEFEAT            = "FIGHT_DEFEAT"
const.EVENT_FIGHT_RESULT            = "FIGHT_RESULT"
const.EVENT_BATTLE_RESULT           = "BATTLE_RESULT"
const.EVENT_ATTACK_ITEM_START       = "ATTACK_ITEM_START"
const.EVENT_PLAY_ATTACK_ACTION        = "ATTACK_ITEM_PLAY"

const.EVENT_HERO_PLAY_ATTACK        = "HERO_PLAY_ATTACK"

const.EVENT_HERO_PLAY_ATTACK_FINISH = "HERO_PLAY_ATTACK_FINISH"

const.EVENT_ATTACK_ITEM_PLAY       = "ATTACK_ITEM_PLAY"
const.EVENT_ATTACK_ARMY_FINISH      = "ATTACK_ARMY_FINISH"
--const.EVENT_ATTACK_ARMY_STOP        = "ATTACK_ARMY_STOP"
const.EVENT_ATTACK_ITEM_STOP        = "ATTACK_ITEM_STOP"
--const.EVENT_HIT_ARMY_START          = "HIT_ARMY_START"
const.EVENT_HIT_ITEM_START          = "HIT_ITEM_START"
--const.EVENT_HIT_ARMY_PLAY           = "HIT_ARMY_PLAY"

const.EVENT_PLAY_BE_HIT_ACT         = "PLAY_HIT_ACT"  --播放被攻击动作

const.EVENT_PLAY_HIT_BUFF_ACT       = "PLAY_HIT_BUFF_ACT" --播放被攻击Buff动画
const.EVENT_PLAY_BUFF_ACT           = "PLAY_BUFF_ACT" --播放Buff动画

const.EVENT_HIT_ARMY_IMPACT         = "HIT_ARMY_IMPACT"

const.EVENT_PLAY_HIT_IMPACT         = "PLAY_HIT_IMPACT"
--const.EVENT_HIT_ARMY_FINISH         = "HIT_ARMY_FINISH"
const.EVENT_BE_HIT_FINISH           = "BE_HIT_FINISH"  --被攻击结束
--
const.EVENT_HIT_ITEM_STOP           = "HIT_ITEM_STOP"
--const.EVENT_HIT_ARMY_STOP           = "HIT_ARMY_STOP"
const.EVENT_ATTACK_ENEMY_START      = "ATTACK_ENEMY_START"
--const.EVENT_ATTACK_ENEMY_PLAY       = "ATTACK_ENEMY_PLAY"
const.EVENT_ATTACK_ENEMY_FINISH     = "ATTACK_ENEMY_FINISH"
--const.EVENT_ATTACK_ENEMY_STOP       = "ATTACK_ENEMY_STOP"
const.EVENT_HIT_ENEMY_START         = "HIT_ENEMY_START"
--const.EVENT_HIT_ENEMY_PLAY          = "HIT_ENEMY_PLAY"
const.EVENT_HIT_ENEMY_IMPACT        = "HIT_ENEMY_IMPACT"
--const.EVENT_HIT_ENEMY_FINISH        = "HIT_ENEMY_FINISH"
--const.EVENT_HIT_ENEMY_STOP          = "HIT_ENEMY_STOP"
const.EVENT_ATTACK_ITEM_SHAKE       = "ATTACK_ITEM_SHAKE"
const.EVENT_ATTACK_FLASH            = "ATTACK_FLASH"
const.EVENT_CAMERA_FOCUS            = "CAMERA_FOCUS"
const.EVENT_SLOW_DOWN               = "SLOW_DOWN"
const.EVENT_KILL_OVER_BEGIN         = "KILL_OVER_BEGIN"
const.EVENT_KILL_OVER_END           = "KILL_OVER_END"
const.EVENT_SHADOW_CLEAN            = "SHADOW_CLEAN"
const.EVENT_SHADOW_SHOW             = "SHADOW_SHOW"
const.EVENT_SHADOW_COLLECT          = "SHADOW_COLLECT"
const.EVENT_DEAD_ITEM               = "DEAD_ITEM"

const.EVENT_PLAY_DEAD_ANI           = "PLAY_DEAD_ANI"
const.EVENT_UPDATE_ANGER            = "UPDATE_ANGER"
--const.EVENT_UPDATE_ANGER_ARMY       = "UPDATE_ANGER_ARMY"
--const.EVENT_UPDATE_ANGER_ENEMY      = "UPDATE_ANGER_ENEMY"
const.EVENT_ON_UNPARA_PRESS         = "ON_UNPARA_PRESS"
const.EVENT_ON_BODDY_PRESS          = "ON_BODDY_PRESS"
const.EVENT_PAUSE                   = "PAUSE"   --暂停

const.EVENT_ON_test2click          = "ON_test2click"

const.EVENT_BUFF_VIEW_UPDATE        = "BUFF_VIEW_UPDATE"

const.EVENT_START_UNPARA_ANI        = "START_UNPARA_ANI"
const.EVENT_UNPARALLELED_ROUND_START = "UNPARALLELED_START"
const.EVENT_UNPARALLELED_ROUND_BEGIN = "UNPARALLELED_BEGIN"
const.EVENT_UNPARALLELED_ROUND_END  = "UNPARALLELED_END"

const.EVENT_START_BEGIN             = "START_BEGIN"
const.EVENT_STOP_BEGIN              = "STOP_BEGIN"
const.EVENT_END_BEGIN               = "END_BEGIN"

const.EVENT_BEGIN_STATE_CHANGE      = "BEGIN_STATE_CHANGE"

const.EVENT_STOP_BEGINING           = "STOP_BEGINING"
const.EVENT_BUDDY_ROUND_BEGIN       = "BUDDY_BEGIN"
const.EVENT_BUDDY_ROUND_END         = "BUDDY_END"

const.EVENT_BUDDY_ATTACK            = "BUDDY_ATTACK"
const.EVENT_BUDDY_MAKE_BUDDY        = "BUDDY_MAKE_BUDDY"

const.EVENT_START_BODDY_ANI         = "START_BODDY_ANI"
const.EVENT_BODDY_ROUND_START       = "BODDY_ROUND_START"

const.EVENT_START_ENTRANCE          = "START_ENTRANCE"

const.EVENT_START_KO                = "START_KO"

const.EVENT_ENEMY_COME_IN           = "ENEMY_COME_IN"
--
const.EVENT_PERFORM_IMPACT          = "PERFORM_IMPACT"

const.EVENT_PLAY_ROUND_ANI          = "PLAY_ROUND_ANI"

const.EVENT_ARMY_GO                 = "ARMY_GO"

const.EVENT_UPDATA_UNPARA_DATA      = "UPDATA_UNPARA_DATA"

const.EVENT_SOLDIER_ENTRY_ANI       = "SOLDIER_ENTRY_ANI"

const.EVENT_HERO_GONE               = "HERO_GONE"

const.EVENT_HERO_IN                 = "HERO_IN"

const.EVENT_UPDATE_FRIEND_DATA      = "UPDATE_FRIEND_DATA"

const.EVENT_MAKE_REPLACE_HERO       = "MAKE_REPLACE_HERO"

const.EVENT_REPLACE_HERO            = "REPLACE_HERO"

const.EVENT_UNPATA_STOP             = "UNPATA_STOP"

const.EVENT_SHOW_SHADOW             = "SHOW_SHADOW"

const.EVENT_START_PRELUDE           = "START_PRELUDE"

const.EVENT_UPDATE_HERO_STATE       = "UPDATE_HERO_STATE"

const.EVENT_UPDATE_ALL_HERO_STATE   = "UPDATE_ALL_HERO_STATE"

const.EVENT_PLAY_DROPPING           = "PLAY_DROPPING"

const.EVENT_DO_ACTION_PRELUDE       = "DO_ACTION_PRELUDE"

const.EVENT_UNPARA_BE_AUTO_EXE      = "UNPARA_BE_AUTO_EXE"

const.EVENT_UPDATE_UI_ROUND         = "UPDATE_UI_ROUND"

const.EVENT_UPDATE_UI_VIEW          = "UPDATE_UI_VIEW"
const.EVENT_INIT_UI_VIEW            = "INIT_UI_VIEW" --首次初始化UI

const.EVENT_UPDATE_UI_SROUND        = "UPDATE_UI_SROUND"

const.EVENT_START_AWAKE             = "START_AWAKE"
const.EVENT_START_AWAKE_UNIT        = "START_AWAKE_UNIT"

const.EVENT_MAKE_WORLD_BOSS         = "MAKE_WORLD_BOSS"

const.EVENT_FINAL_HARM              = "FINAL_HARM"
const.EVENT_SHOW_COMBO              = "SHOW_COMBO"
const.EVENT_REMOVE_HERO_BUFF        = "REMOVE_HERO_BUFF" --移除相关Buff，主要是before_buffs and after_buffs
const.EVENT_FIGHT_BEFORE_BUFF       = "FIGHT_BEFORE_BUFF" --开场Buff
const.EVENT_FIGHT_OPEN_BUFF         = "FIGHT_OPEN_BUFF"   --开始开场BUFF
const.EVENT_CARD_DIGIT_NUM          = "CARD_DIGIT_NUM"   --分段数值
const.EVENT_END_BEFORE_BUFFS        = "END_BEFORE_BUFFS" -- 结束回合前Buffs

const.EVENT_FIGHT_END_CLEAR_HERO    = "FIGHT_END_CLEAR_HERO" --战斗结束后清除英雄
const.EVENT_FIGHT_SET_SKIP_ENABLED  = "FIGHT_SET_SKIP_ENABLED" --设置战斗跳过可点击
const.EVENT_GUILD_FIGHT_AWAKE       = "GUILD_FIGHT_AWAKE" --演示战斗中的剧情完之后武将觉醒
const.EVENT_BLOOD_FLASH             = "BLOOD_FLASH"         --红色

const.FONT_NAME                     = MINI_BLACK_FONT_NAME

const.NOT_EXIT_WORDS                = {"郃"} --字库中不存在的字体

const.CURSOR_INPUT_DONE             = "CURSOR_INPUT_DONE"  
const.CURSOR_INPUT_CHANGE           = "CURSOR_INPUT_CHANGE"

const.EVENT_HJQY_REWARD_NOTICE      = "HJQY_REWARD_NOTICE" --黄巾起义Reward红点提示

const.test = "test"  --测试

BUDDY_SEAT = 12
REPLACE_SEAT = 13

TYPE_BACK = 0
TYPE_NORMAL = 1
TYPE_UNPARAL = 2
TYPE_BUDDY = 3
TYPE_RED_UNPARAL= 4
TYPE_BLUE_UNPARAL = 5
TYPE_TEMP_HERO = 6 --假战斗

TYPE_UNPARAL_F = 1
TYPE_UNPARAL_S = 2
TYPE_UNPARAL_T = 3

TYPE_NORMAL_NORMAL = 1
TYPE_NORMAL_RAGE = 2
TYPE_NORMAL_NEXT = 3
TYPE_NORMAL_FUGHT_BACK = 4


TYPE_AUTO_UNPARA_NORMAL = 1
TYPE_AUTO_UNPARA_RED = 2
TYPE_AUTO_UNPARA_BLUE = 3

TYPE_NORMAL_POS = 1
TYPE_FRONT_ROW = 2
TYPE_BACK_ROW = 3
TYPE_FIRST_COLUMN = 4
TYPE_SECOND_COLUMN = 5
TYPE_THIRD_COLUMN = 6
TYPE_ALL_POS = 7
TYPE_SELF_POS = 8

TYPE_HERO_NORMAL = 1
TYPE_HERO_REPLACE = 2
TYPE_HERO_AWAKE = 3
TYPE_HERO_WORLD_BOSS = 4

TYPE_GUIDE          = 0          -- 演示关卡
TYPE_STAGE_NORMAL   = 1          -- 普通关卡（剧情）， stage_config
TYPE_STAGE_ELITE    = 2          -- 精英关卡， special_stage_config
TYPE_STAGE_ACTIVITY = 3          -- 活动关卡， special_stage_config
TYPE_TRAVEL         = 4          -- travel
TYPE_PVP            = 6          -- pvp
TYPE_WORLD_BOSS     = 7          -- 世界boss
TYPE_MINE_MONSTER   = 8          -- 攻占也怪
TYPE_MINE_OTHERUSER = 9          -- 攻占其他玩家
TYPE_HJQY_STAGE     = 10         -- 黄巾起义
TYPE_TREASURE       = 11         -- 夺宝战斗
TYPE_BEAST_BATTLE   = 12         -- 圣兽战斗

TYPE_TEST           = 999        -- 测试战斗
TYPE_ESCORT         = 13        -- 押运

TYPE_PVP_NORMAL     = 0          --正常的PVP,擂台
TYPE_PVP_CLEARANCE  = 1          --过关斩将
TYPE_PVP_REVANGE    = 2          --坏蛋反击

TYPE_FORAGE_ROB_BATTLE_VIEW  = 1 --劫运的战斗回放
TYPE_FORAGE_ROB_BATTLE = 2       --劫运的战斗

TYPE_STAGE_JIA = 3               -- 难度甲
TYPE_STAGE_YI = 2                -- 难度乙
TYPE_STAGE_BING = 1              -- 难度丙

HUODONG_FIGHT_TYPE_JK = "jk_activity"   --金库试炼战斗
HUODONG_FIGHT_TYPE_JC = "jc_activity"   --校场试炼战斗

JK_HD_STAGE_TYPE = 7     --金库活动stage type,发送战斗请求时用
JC_HD_STAGE_TYPE = 8     --校场活动stage type,发送战斗请求时用

TYPE_TEST               = 10000
TYPE_MODE_PVP = 0
TYPE_MODE_PVE = 1
-- test
CONFIG_CARD_STATE_X = 30
CONFIG_CARD_STATE_Y = -110

CONFIG_CARD_HP_X = 7
CONFIG_CARD_HP_Y = 10
CONFIG_CARD_MP_X = 7
CONFIG_CARD_MP_Y = -7
CONFIG_CARD_KIND_X = 10
CONFIG_CARD_KIND_Y = 20
CONFIG_CARD_HERO_X = 0
CONFIG_CARD_HERO_Y = 0

-- 武将图片经1.2被放大后的中心点坐标
CONFIG_CARD_EFFECTA_X = 146.5
CONFIG_CARD_EFFECTA_Y = 162.5
CONFIG_CARD_EFFECTB_X = 146.5
CONFIG_CARD_EFFECTB_Y = 162.5   

CONFIG_CARD_SCALE = 0.8
CONFIG_CARD_MONSTER_SCALE = 0.6
CONFIG_CARD_FIGHT_SCALE = 0.7

CONFIG_FIRST_OFF_HEIGHT = 50


MODULE_NAME_HOMEPAGE = "HomePageModule"     --首页
MODULE_NAME_HOMEPAGE2 = "HomePageModule2"     --首页
MODULE_NAME_LINEUP = "LineUpModule"         --阵容
MODULE_NAME_OTHER   = "OtherModule"         --其他
MODULE_NAME_CRUSADE = "CrusadeModule"       --讨伐模块
MODULE_NAME_SHOP = "ShopModule"             --商城模块
MODULE_NAME_ACTIVITY = "ActivityModule"     --精彩活动模块
MODULE_NAME_WAR = "WarModule"           --信箱模块
MODULE_NAME_LEGION = "LegionModule"     --军团模块
MODULE_NAME_MISSION = "MissionModule"   --任务模块

const.EVENT_PV_EMBATTLE_SHOW        = "EMBATTLE_SHOW"       --布阵显示
const.EVENT_PV_SELECT_WS_SHOW       = "SELECT_WS_SHOW"      --选择无双显示
const.EVENT_PV_SELECT_WS_CALLBACK   = "SELECT_WS_CALLBACK"  --返回选择无双数据
const.EVENT_PV_EMBATTLE_HIDE        = "EMBATTLE_HIDE"       --布阵隐藏

const.EVENT_PV_POP_TIPS_SHOW                    = "POP_TIPS_SHOW " --  弹出页面


NOTICE_COM_HERO          = 1            --可合成英雄
NOTICE_COM_EQUIP         = 2            --可合成装备
NOTICE_ACTIVE_DEGREE     = 3            --获活跃度可领取奖励
ARENA_NOTICE             = 4            --竞技场
BOSS_NOTICE              = 5            --世界boss
INSTANCE_NOTICE          = 6            --讨伐


UPDATE_MINE_NOTICE = "UPDATE_MINE_NOTICE"
UPDATE_BOSS_NOTICE = "UPDATE_BOSS_NOTICE"
UPDATE_PVP_NOTICE = "UPDATE_PVP_NOTICE"
UPDATE_AREANOTICE = "UPDATE_AREANOTICE"



---------------------   剧情对话
STORY_10010113                    = "10010113"
STORY_10010213                    = "10010213"
STORY_10010215                    = "10010215"
STORY_10020135                    = "10020135"
STORY_10020513                    = "10020513"
STORY_10020536                    = "10020536"
STORY_10030731                    = "10030731"
STORY_10040531                    = "10040531"
STORY_10040732                    = "10040732"
STORY_10040733                    = "10040733"

STORY_10010111                    = "10010111"
STORY_10010211                    = "10010211"
STORY_10010214                    = "10010214"
STORY_10020131                    = "10020131"
STORY_10020511                    = "10020511"
STORY_10020531                    = "10020531"
STORY_10030731                    = "10030731"
STORY_10040531                    = "10040531"
STORY_10040731                    = "10040731"

STAGE_100101                       = 100101
STAGE_100102                       = 100102
STAGE_100201                       = 100201
STAGE_100205                       = 100205
STAGE_100307                       = 100307
STAGE_100405                       = 100405
STAGE_100407                       = 100407

--定义资源类型
RES_TYPE_HERO       = 101   --英雄
RES_TYPE_EQUIP      = 102   --装备
RES_TYPE_HERO_CHIP  = 103   --英雄碎片
RES_TYPE_EQUIP_CHIP = 104   --装备碎片
RES_TYPE_ITEM_CHIP  = 105   --道具碎片
RES_TYPE_COMMON     = 107   --通用资源
RES_TYPE_RUNT       = 108   --符文碎片
RES_TYPE_TRAVEL     = 109   --风物志

-- 阶段
SKILL_STAGE_OPEN = 1  -- 开场buff
SKILL_STAGE_IN_BUFF = 3  -- 正常战斗buff

-- 战斗：单元类型
UNIT_TYPE_MONSTER = 1
UNIT_TYPE_HERO = 2


-- 战斗：一次战斗中四步
STEP_BEFORE_BUFF = 1 -- 攻击前清buff
STEP_BEGIN_ACTION = 2 -- 起手动作
STEP_DO_BUFF = 3 -- 攻击
STEP_AFTER_BUFF = 4 -- 攻击后清buff

g_notice.NOTICE_REVENGE_REFRESH_FRIEND = "NOTICE_REVENGE_REFRESH_FRIEND"    --复仇成功之后更新坏蛋列表
g_notice.NOTICE_PVP_CLEARANCE_UPDATA = "NOTICE_PVP_CLEARANCE_UPDATA"        --过关斩将界面,重新刷新当前的关卡信息
g_notice.NOTICE_REFRESH_SYS_MAIL_LIST = "NOTICE_REFRESH_SYS_MAIL_LIST"      --刷新系统邮件列表
g_notice.NOTICE_RESET_MERIDIANS = "NOTICE_RESET_MERIDIANS"                  --更新经脉信息

g_other.USER_DEFAULT_FWZ_NEW_LIST = "USER_DEFAULT_FWZ_NEW_LIST"             --风物志新物品存储名称

g_friendSubmodule.SUBMODULE_PUSH_FRIEND = "SUBMODULE_PUSH_FRIEND"           -- 好友,推送好友子模块

G_BOTTOM_DEFINE.GET_COINS_CANCEL = {
    ["normalFrame"] = "#ui_common_btn_blue2.png",
    ["selectedFrame"] = "#lan_common_cancel.png",
    ["disabledFrame"] = nil,
    ["callBack"] = nil,
}
G_BOTTOM_DEFINE.GET_COINS_JUMP = {
    ["normalFrame"] = "#ui_common_btn_yellow.png",
    ["selectedFrame"] = "#lan_common_qzc.png",
    ["disabledFrame"] = nil,
    ["callBack"] = function ()
        getOtherModule():showUIView("activity.PVActivityPage", ACTIVITY_TYPE().GETWEALTH)
    end,
}

guid_titlle = {war = "GUID_OPEN_WAR"}

TYPE_SHOP = {
    SHOP_ITEM       = 3,   --商城-道具
    SHOP_GIFT       = 4,   --商城-礼包
    SECRETPLACE     = 7,   --秘境商店
    SOUL            = 9,   --武魂商店(武将炼化)
    PVP             = 10,  --军功商店(擂台)
    SMELT           = 11,  --精华商店(装备炼化)
    SHOP_EQUIP      = 12,  --商城-装备
    SMELT_NEW       = 13, -- 新手引导(精华商店)
    SOUL_NEW        = 15, -- 新手引导(武魂商店)
    SHOP_EQUIP_NEW  = 16, -- 新手引导(装备商店)
    MERIT           = 18,  --功勋商店(黄巾起义)
    TREASURE        = 19,  --珍宝（过关斩将）
    VIP             = 20,  --VIP商店
    LEGION_NORMAL   = 21,  --公会贡献商店
    LEGION_DISCOUNT = 22,  --公会免税商店
    VIP_GIFT        = 24, -- VIP每日礼包
}

--[[--
商店的UI类型
]]
SHOP_UI_TYPE = {
    NO_REFRESH_TAB_BAR      = 1, -- 不可刷新,页签形式
    NO_REFRESH_TITLE_OLD    = 2, -- 不可刷新,标题,返回按钮形式
    NO_REFRESH_TITLE_NEW    = 3, -- 不可刷新,标题,返回关闭按钮形式
    REFRESH_TAB_BAR         = 4, -- 可刷新,页签形式
    REFRESH_TITLE_OLD       = 5, -- 可刷新,标题,返回按钮形式
    REFRESH_TITLE_NEW       = 6, -- 可刷新,标题,返回关闭按钮形式
}

RES_TYPE = {
    CRUSADE      = 26,  --征讨令
    FEAT         = 25,  --功勋
    STAMINA      = 7 ,  --体力
    YUANQI       = 16,  --元气
    PVP_SCROE    = 8,   --PVP军功
    GOLD         = 2,   --金币
    COIN         = 1,   --银锭
    EQUIP_SOUL   = 21,  --装备精华
    HERO_SOUL    = 3,   --武魂值
    CLEARANCE_COIN = 27, --通关令
    SHOES        = 20, --鞋子
    PLAYER_EXP   = 12, --战队经验
    GOD_HERO_SOUL= 29, --将魂
    QJYL         = 13, --琼浆玉露
    ENERGY       = 4,  --精力
    ROB_NUM      = 14, --劫运次数
    GONGXIAN     = 10, --公会个人贡献值
    CALL_STONE   = 15, --军团召唤石
}

-- 次日开启类型
const.nextDay_openType = {WORLDBOSS=23,ACTIVITY=2,HJQY=27,GGZJ = 28}      --同成就表配置的达成条件值相匹配
--[[--
事件名称定义
]]
EventName = {
    UPDATE_EXP = "update_exp",--更新经验
    UPDATE_TL = "update_tili",--更新体力
    UPDATE_HEAD = "update_head",--更新头像
    UPDATE_ENERGY = "update_energy",--更新精力
    UPDATE_ROB_NUM = "update_rob_num",--更新劫运次数
    UPDATE_NAME = "update_name",--更新名称
    UPDATE_COMBAT_POWER = "update_combat_power",--更新战斗力
    UPDATE_VIP = "update_vip",--更新VIP
    UPDATE_LEVEL = "update_level",--更新等级
    UPDATE_NEW_FEATURE = "update_new_feature",--有新功能开启
    UPDATE_SILVER = "update_silver",--更新银锭
    UPDATE_GOLD = "update_gold",    --更新元宝
    UPDATE_YUANQI = "UPDATE_YUANQI",--更新元气
    UPDATE_FRIEND = "update_friend", --更新好友
    DISABLE_NEXT_REWARD = "disable_next_reward", --禁用次日登陆奖励
    UPDATE_ACTIVE = "update_active", --更新(精彩活动中的)分享任务
    UPDATE_TASK = "update_task", --更新任务
    UNLOCK_NEW_FEATURE_STAGEID = "UNLOCK_NEW_FEATURE_STAGEID", --当前stageid通知，用于更新新功能开启
    UPDATE_ARENA_CHALLENGE_NUM = "UPDATE_ARENA_CHALLENGE_NUM",  --更新擂台挑战次数
    UPDATE_STAGE_DATA = "UPDATE_STAGE_DATA", -- 跟新讨伐数据
    UPDATE_MAIL = "UPDATE_MAIL", -- 更新邮件通知
    FULL_MAIL = "FULL_MAIL", -- 邮箱已满消息
    UPDATE_SCRECT_PLACE = "UPDATE_SCRECT_PLACE", --更新秘境数据通知
    UPDATE_RECHARGE_NUM = "UPDATE_RECHARGE_NUM",  --更新累计充值数据
    UPDATE_GGZJ = "UPDATE_GGZJ", --更新过关斩将红点
    UPDATE_BOSS = "UPDATE_BOSS", --更新枭雄红点
    UPDATE_BOSS_TIPS = "UPDATE_BOSS_TIPS", --更新枭雄通知
    UPDATE_SOLDIER = "UPDATE_SOLDIER", --更新武将红点
    UPDATE_EQUIP = "UPDATE_EQUIP", -- 更新装备红点
    UPDATE_WINE = "UPDATE_WINE", -- 煮酒红点
    UPDATE_SIGN = "UPDATE_SIGN", -- 更新签到
    UPDATE_HJQY = "UPDATE_HJQY", -- 更新黄巾起义
    UPDATE_ZHENGZHAN = "UPDATE_ZHENGZHAN", -- 更新征战按钮红点
    UPDATE_HOME_FIRSTRECHARGEREWARD_BTN = "UPDATE_HOME_FIRSTRECHARGEREWARD_BTN", --更新home页面的首冲好礼状态
    GUIDE_HANDLE = "GUIDE_HANDLE", --新手引导（出现小手）
    UPDATE_LEGION_APPLY_LIST = "UPDATE_LEGION_APPLY_LIST", --军团申请列表更新
    UPDATE_LEGION_INFO = "UPDATE_LEGION_INFO", --军团信息更新
    SUB_PVP_SCROE = "SUB_PVP_SCROE", --消耗军功
    UPDATE_MAX_COMBAT_POWER = "update_max_combat_power",--更新历史最高战斗力
    REFRESH_EQUIP_SHOP = "REFRESH_EQUIP_SHOP", --精华商店刷新次数
    UPDATE_HUODONG_TIMES = "UPDATE_HUODONG_TIMES", --更新活动副本挑战次数
    UPDATE_FB_TIMES = "UPDATE_FB_TIMES",  --更新精英副本挑战次数
    UPDATE_SOLDIER_EXP = "UPDATE_SOLDIER_EXP", --更新英雄经验值
    UPDATE_SOLDIER_BREAK = "UPDATE_SOLDIER_BREAK", --更新英雄突破等级
    UPDATE_CHAT = "update_chat", --更新聊天提示
    UPDATE_REFRESH_24 = "UPDATE_REFRESH_24",   --24点更新
    UPDATE_EQUIP_ADD = "UPDATE_EQUIP_ADD",  --获得装备
    UPDATE_EQUIP_STRENGTH_LV = "UPDATE_EQUIP_STRENGTH_LV",--装备强化等级清算
    UPDATE_LINEUP_EQUIP_STRENGTH_LV = "UPDATE_LINEUP_EQUIP_STRENGTH_LV", --阵容中装备强化等级
    UPDATE_LINEUP_WS_UPGRADE = "UPDATE_LINEUP_WS_UPGRADE",--无双升级
    TRAVEL_EVENT_CHANGE = "TRAVEL_EVENT_CHANGE", -- 游历,加入等待事件到列表中
    UPDATE_LINEUP = "UPDATE_LINEUP",--更新了阵容信息
    UPDATE_LINEUP_ORDER = "UPDATE_LINEUP_ORDER",--更新阵容顺序
    UPDATE_LINEUP_CHANGED = "UPDATE_LINEUP_CHANGED",--有武将或助威武将更换
    UPDATE_LINEUP_RUNE_CHANGED = "UPDATE_LINEUP_RUNE_CHANGED",--武将符文变化
    UPDATE_SEVENDAY = "UPDATE_SEVENDAY",  --更新七日红点提示
    UPDATE_QJYL = "UPDATE_QJYL", --更新经脉红点
    UPDATE_SOLDIER_AWAKE_MAX = "UPDATE_SOLDIER_AWAKE_MAX",--更新英雄觉醒等级到最高等级
    UPDATE_SOLDIER_AWAKE_LEVEL = "UPDATE_SOLDIER_AWAKE_LEVEL",--更新英雄觉醒等级
    UPDATE_SOLDIER_CHANGE = "UPDATE_SOLDIER_CHANGE",
    CAPTURE_RESP = "CAPTURE_RESP",

    UPDATE_ROB_INVITE = "update_rob_invite",
    UPDATE_ESCORT_INVITE = "update_escort_invite",
    UPDATE_MY_ESCORT = "update_my_escort",
    UPDATE_ROB_CHARATERINFO = "update_rob_characterInfo",--承接人收到的消息，有人加入劫运了
    UPDATE_RUNEBAG = "UPDATE_RUNEBAG",--更新宝石红点
    UPDATE_TRAVEL = "UPDATE_TRAVEL", -- 跟新游历信息
    UPDATE_LEGION_BLESS_NUM = "UPDATE_LEGION_BLESS_NUM", --祈福次数变化
    UPDATE_LEGION_ZAN_MONEY = "UPDATE_LEGION_ZAN_MONEY",  --团长膜拜奖励变化
    UPDATE_LEGION_ZAN_NUM = "UPDATE_LEGION_ZAN_NUM",      --团员点赞数变化
    UPDATE_LEGION_MINEHELP = "UPDATE_LEGION_MINEHELP",     --秘境帮助变化
    REFRESH_RECHARGE_SHOP_NOTICE = "REFRESH_RECHARGE_SHOP_NOTICE", -- 充值成功,商店ui更新
    UPDATE_LEGION_YSDT = "UPDATE_LEGION_YSDT", -- 更新议事大厅建筑红点
    UPDATE_LEGION_QFD = "UPDATE_LEGION_QFD", -- 更新祈福殿建筑红点
    UPDATE_LEGION_JJC = "UPDATE_LEGION_JJC", -- 更新军机处建筑红点

    LEGION_REMOVE_HUB = "LEGION_REMOVE_HUB", -- 移除军团中转UI
    UPDATE_LINEUP_GODDESS_ACTIVED = "UPDATE_LINEUP_GODDESS_ACTIVED", --激活女神
    FULL_STAR_DRAW_GOT_REWARD_NOTICE = "FULL_STAR_DRAW_GOT_REWARD_NOTICE", --满星抽奖领取奖励
    UPDATE_SOUL_SHOP = "UPDATE_SOUL_SHOP", --武魂商店刷新提示
}

NoticeColor = {
    [1] = ui.COLOR_FEN,
    [2] = ui.COLOR_GREEN,
    [3] = ui.COLOR_BLUE,
    [4] = ui.COLOR_BLUE,
    [5] = ui.COLOR_PURPLE,
    [6] = ui.COLOR_PURPLE,
}

const.FettersInfoCount = 5  --羁绊信息最大个数
const.MAX_HERO_POSITION = 6 --最大阵容个数
const.MAX_EQUIP_POSITION = 6

G_PLATFORM.NONE = 0         -- 无平台
G_PLATFORM.WEIXIN = 1       -- 微信平台
G_PLATFORM.QQ = 2           -- QQ平台
G_PLATFORM.QHALL = 3        -- 游戏大厅平台

const.C_WS_MAX_LEVEL = 3
LOADING_FOR_ENTERGAME = 999999 --进入游戏

--定义网络错误代码
const.NET_ERR_CODE = {
    RuneBagFull = 12451, --符文收获时背包满
    PVP_RANK_CHANGE = 150508,--PVP排名发生变化
    PVP_RANK_MY_CHANGE = 150509,--PVP我的排名发生变化
    PVP_RES_NO_ENOUGH = 150501,--PVP资源不足
}

--[[--
排名模块
]]
RANK = {
    NUM_SPECIA = 3, -- 特殊显示的排名数量(前3名)
    NUM_PAGE   = 7, -- 每页显示的排名数量
}

--[[--
签到模块
]]
SIGN = {
    STATE_SIGNED        = 1, -- 已签到状态
    STATE_REPAIR_SIGN   = 2, -- 可补签状态
    STATE_SIGN          = 3, -- 可签到状态
    STATE_NO            = 4, -- 未签不可签状态
}

--[[--
征战界面提示图标
]]
HOME_TIP_TYPE = {
    HJQY_BUFF        = 1, -- 征讨令减半
    HJQY_MERITORIOUS = 2, -- 收益翻倍
    BOSS_OPEN = 3, -- 收益翻倍
}

--[[--
邮件类型
]]
MAIL_TYPE = {
    GIFT        = 1, -- 赠送
    SYS         = 2, -- 系统
    FIGHT       = 3, -- 战斗
    SOCIALLY    = 4, -- 社交
    DEL_SYS     = 5, -- 系统邮件准备删除
    DEL_FIGHT   = 6, -- 战斗邮件准备删除
}

--押劫类型
FORAGE_TASK_TYPE = {
    ESCORT = 1, --押运
    ROB = 2,    --劫运
}
--[[--
游历事件类型
]]
TRAVEL_EVENT_TYPE = {
    WAIT        = 1, -- 有等待时间的事件 参数：等待时间（分钟）
    FIGHT       = 2, -- 战斗的事件 参数：关卡ID
    QUESTION    = 3, -- 答题事件 参数：languageID（答案选项）]
    GET         = 4, -- 直接领取奖励事件
}

--[[--
"成长基金"任务状态
]]
GROW_ACTIVITY_STATE = {
    UNOPEN  = 0, -- 未开启
    UNABLE  = 1, -- 不可领取 
    OPEN    = 2, -- 已激活
    GOT     = 3, -- 已获得
}

--[[--
军团建筑类型
]]
LEGION_BUILDING_TYPE = {
    YSDT = 1, -- 议事大厅
    QFD  = 2, -- 祈福殿
    JTSS = 3, -- 军团商市
    JJC  = 4, -- 军机处
    ZZSC = 5, -- 征战沙场
    GCLD = 6, -- 攻城略地
}
--[[--
军团职位
]]
LEGION_POS_TYPE = {
    COMMANDER   = 1, -- 军团长
    DEPUTYP     = 2, -- 副团长
    MEMBERS     = 3, -- 团员
}
--军团粮草劫押任务状态
TaskState = {
    state_complete = -1 ,-- 已经完成
    state_notReceive = 0, -- 未领取
    state_ReceiveNotStart = 1, -- 领取未开始
    state_Start = 2, -- 开启任务
 }
 --军团粮草劫押记录类型
 TaskLogType = {
    logType_myEscort  = 1 ,-- 我的押运记录
    logType_myRob    = 2, -- 我的劫运记录
    logType_Legion   = 3, -- 军团劫押记录
 }

 LEGION_CELL_TYPE = {
    RANK_IN_LEGION = 1,--自己在军团中时的军团排行
    RANK_OUT_LEGION = 2,--自己没有军团时的军团排行
    RECOMMEND_LEGION = 3,--军团推荐
    SEARCH_LEGION = 4,--查找军团
}
SUCCESS_TYPE = {
    COMPOSE = 1,--合成成功
    AWAKE = 2,--觉醒段升成功
    UPGRADE = 3,--升级成功
    BREAK = 4,--突破成功
}
REWARD_STATE = {
    STATE_CANNOT = 0,--不能领取
    STATE_CAN = 1,--可领取
    STATE_ISGOT = 2,--已领取
}
ACTIVITY_DURATION_TYPE = {
    TIME_FOREVER = 1,--永久活动
    TIME_INTERVAL = 2,--时间区间
    TIME_SERVEROPENBYDAY = 3,--开服后 达到要求一直存在
    TIME_SERVEROPENDAYTODAY = 4,--开服后 第几天到第几天显示
    TIME_SERVEROPENBYTIME = 5,--开服后 多少小时内显示
    TIME_LOGINOVER = 6,--首次登录 达到要求一直存在
    TIME_LOGINOVER2= 7,--首次登录 第几天到第几天一直存在
    TIME_LOGINOVER3= 8,--首次登录 第几小时到第几小时一直存在
}
ACTIVITY_POSITION_TYPE = {
    POSITION_JINGCAI = 0,--精彩活动
    POSITION_SEVENDAY = 1,--精彩活动
    POSITION_ONEBUY = 2,--精彩活动
}


