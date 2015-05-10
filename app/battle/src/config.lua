--000000000999999999
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info

--


-- 第三方 注册、登录服务器
THIRD_LOGIN_REGISTER_SERVER = "http://192.168.1.62"       --62服务器
-- THIRD_LOGIN_REGISTER_SERVER = "http://192.168.40.234"        --不靠谱
-- THIRD_LOGIN_REGISTER_SERVER = "http://192.168.10.13"      -- 金岭
-- THIRD_LOGIN_REGISTER_SERVER = "http://192.168.10.26"      -- 小凯
-- THIRD_LOGIN_REGISTER_SERVER = "http://192.168.10.27"            --鑫哥
-- THIRD_LOGIN_REGISTER_SERVER = "http://210.14.148.9"         --外网

THIRD_LOGIN_REGISTER_PORT = "30004"

-- 正式登录服务器
-- LOGIN_SERVER = "http://192.168.40.234"       --不靠谱
LOGIN_SERVER = "http://192.168.1.62"       --62服务器
-- LOGIN_SERVER = "http://192.168.10.13"         --金岭
-- LOGIN_SERVER = "http://192.168.10.26"         --小凯
-- LOGIN_SERVER = "http://192.168.10.27"            --鑫哥
-- LOGIN_SERVER = "http://210.14.148.9"         --外网

LOGIN_SERVER_PORT = "30006"

--  打包时候下面两个不用改
SOCKET_URL = ""         --外网
SOCKET_PORT = ""           --端口

ISPAUSEING = false  --战斗暂停键

--ISSHOWLOG = false
-- 是否显示Log
ISSHOWLOG = true

ISSHOW_GUIDE = false            --关闭新手引导
-- ISSHOW_GUIDE = true                --开启新手引导

ISSHOW_LEVEL_GUIDE = false   --是否显示等级引导

ISSHOW_STAGE_OPEN = false   --关闭显示功能关卡限制
ISSHOW_STAGE_OPEN = true   --显示功能关卡限制

-- TEST_ISSHOW_EDIT = true
TEST_ISSHOW_EDIT = false



ATTRIBUTE_VIEW_HEIGHT = 123
HOMEMENU_VIEW_HEIGHT = 130
--
CONFIG_BACKGROUND_YD = 300
CONFIG_HP_MIN = 1
CONFIG_HP_MAX = 18
CONFIG_MP_MIN = 1
CONFIG_MP_MAX = 18
CONFIG_KO_SLOW = 0.05
CONFIG_ROUND_MAX = 1

--
CONFIG_BAG_CELL_HEIGHT = 146
CONFIG_BAG_CELL_WIDTH = 563

CONFIG_GENERAL_CELL_WIDTH = 534
CONFIG_GENERAL_CELL_HEIGHT = 150


CONFIG_RES_CCB_RESOURCE_PAHT = CONFIG_RES_PAHT.."resource/"
CONFIG_RES_ANIMATE_PAHT = CONFIG_RES.."animate/"
CONFIG_RES_EQUIPMENT_PAHT = CONFIG_RES.."equipment/"
CONFIG_RES_CARD_PAHT = CONFIG_RES.."card/"
CONFIG_RES_ICON_PAHT = CONFIG_RES.."icon/"
CONFIG_RES_ICON_WS_PAHT = CONFIG_RES.."icon/ws/"
CONFIG_RES_ICON_RUNE_PAHT = CONFIG_RES_ICON_PAHT.."rune/"
CONFIG_RES_ICON_EQUIPMENT_PAHT = CONFIG_RES_ICON_PAHT.."equipment/"
CONFIG_RES_ICON_HERO_PAHT = CONFIG_RES_ICON_PAHT.."hero/"
CONFIG_RES_ICON_ITEM_PAHT = CONFIG_RES_ICON_PAHT.."item/"
CONFIG_RES_ICON_STAGE_PAHT = CONFIG_RES_ICON_PAHT.."stage/"
CONFIG_RES_ICON_RES_PAHT = CONFIG_RES_ICON_PAHT.."resource/"
CONFIG_RES_PART_PAHT = CONFIG_RES.."part/"
CONFIG_RES_RESOURCE_PAHT = CONFIG_RES.."resource/"
CONFIG_RES_STAGE_PAHT = CONFIG_RES.."stage/"
CONFIG_RES_UI_PAHT = CONFIG_RES.."ui/"
CONFIG_RES_SOUND_PAHT = CONFIG_RES.."sound/"
CONFIG_RES_SOUND_EFFECT_PAHT = CONFIG_RES_SOUND_PAHT.."effect/"


if  g_isLoadResource == nil then
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_CCB_RESOURCE_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_RESOURCE_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_ANIMATE_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_EQUIPMENT_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_CARD_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_ICON_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_ICON_WS_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_ICON_EQUIPMENT_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_ICON_HERO_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_ICON_ITEM_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_ICON_STAGE_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_ICON_RUNE_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_STAGE_PAHT)
    cc.FileUtils:getInstance():addSearchPath(CONFIG_RES_UI_PAHT)
end

--BAG_GET_DATA = 301

