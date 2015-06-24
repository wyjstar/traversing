const = const or {}
const.POS_ARMY = cc.p(320, 260)
const.POS_ENEMY = cc.p(320, 700)

const.POS_UNPARA_ICON_STAGE = cc.p(130,355)
const.POS_UNPARA_ICON_FIGHT = cc.p(55,55)
const.FIGHT_POS_UNPARA_ICON = cc.p(130,355)
BIG_SCALE = 0.58
BOSS_SCALE = 1.4

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

const.EVENT_MAKE_WORLD_BOSS         = "MAKE_WORLD_BOSS"

const.EVENT_FINAL_HARM              = "FINAL_HARM"
const.EVENT_SHOW_COMBO              = "SHOW_COMBO"
const.EVENT_REMOVE_HERO_BUFF        = "REMOVE_HERO_BUFF" --移除相关Buff，主要是before_buffs and after_buffs
const.EVENT_FIGHT_BEFORE_BUFF       = "FIGHT_BEFORE_BUFF" --开场Buff
const.EVENT_FIGHT_OPEN_BUFF         = "FIGHT_OPEN_BUFF"   --开始开场BUFF
const.EVENT_CARD_DIGIT_NUM          = "CARD_DIGIT_NUM"   --分段数值
const.EVENT_END_BEFORE_BUFFS        = "END_BEFORE_BUFFS" -- 结束回合前Buffs
const.FONT_NAME                     = MINI_BLACK_FONT_NAME

const.CURSOR_INPUT_DONE             = "CURSOR_INPUT_DONE"  

const.test = "test"  --测试

BUDDY_SEAT = 12
REPLACE_SEAT = 13

TYPE_BACK = 0
TYPE_NORMAL = 1
TYPE_UNPARAL = 2
TYPE_BUDDY = 3
TYPE_RED_UNPARAL= 4
TYPE_BLUE_UNPARAL = 5

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

--  1.普通关卡2.精英关卡3.活动关卡4.游历关卡5.秘境关卡
TYPE_GUIDE = 0              --演示关卡
TYPE_STAGE_NORMAL = 1       -- 普通关卡（剧情）， stage_config
TYPE_STAGE_ELITE = 2        -- 精英关卡， special_stage_config
TYPE_STAGE_ACTIVITY = 3     -- 活动关卡， special_stage_config
TYPE_TRAVEL         = 4     --travel

TYPE_PVP            = 6     --pvp

TYPE_WORLD_BOSS     = 7     --世界boss

TYPE_MINE_MONSTER           = 8       -- 攻占也怪
TYPE_MINE_OTHERUSER         = 9       -- 攻占其他玩家

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

CONFIG_CARD_EFFECTA_X = 152
CONFIG_CARD_EFFECTA_Y = 162
CONFIG_CARD_EFFECTB_X = 152
CONFIG_CARD_EFFECTB_Y = 162
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
UPDATE_FRIEND_NOTICE = "update_friendNotice"
UPDATE_AREANOTICE = "UPDATE_AREANOTICE"
UPDATE_LEGION_NOTICE = "UPDATE_LEGION_NOTICE"



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
RES_TYPE_RUNT       = 108   --符文碎片

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






