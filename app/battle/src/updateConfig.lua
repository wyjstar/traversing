DEBUG = true
DEBUG_FPS = false

-- 资源热更新地址
-- HOST_SERVER = "http://210.14.148.9/transfer/" --外网服务器 --高洋
HOST_SERVER = "http://192.168.1.100/transfer/" --内网服务器

SEND_TYPE = "GET"
HTTP_CONNECT_TIMEOUT = 10  -- 资源版本更新http 超时时间


CONFIG_PROJECTION = "2D"
CONFIG_SCREEN_SIZE_WIDTH = 640
CONFIG_SCREEN_SIZE_HEIGHT= 960

--是否跳过热更新 true不跳过 false不跳过
function skipVersionUpdate(  )
	local  skip = CHANNEL_ID ~= "tencent"
	return skip
end

-- design resolution
CONFIG_SCREEN_WIDTH  = CONFIG_SCREEN_SIZE_WIDTH
CONFIG_SCREEN_HEIGHT = CONFIG_SCREEN_SIZE_HEIGHT
--
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
local size = cc.Director:getInstance():getWinSize()
if size.width / size.height >= CONFIG_SCREEN_SIZE_WIDTH / CONFIG_SCREEN_SIZE_HEIGHT then
    CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
end

NET_LOCALIZE={
    ["cn"] = {[3300010008] = "当前网络不是wifi环境 是否继续下载？",[3300010009]="存储空间不足，请清理后进行下载", ["checknet"]="正在检查版本更新........"},
}

--ccbi资源通用路径头
CONFIG_RES = "res/"
CONFIG_RES_PAHT = CONFIG_RES.."ccb/"
MINI_BLACK_FONT_NAME = CONFIG_RES_PAHT .."resource/miniblack.ttf"