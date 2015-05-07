
local CURRENT_MODULE_NAME = ...

framework = framework or {}
framework.PACKAGE_NAME = string.gsub(CURRENT_MODULE_NAME, "%.[^.]+$", "")

require(framework.PACKAGE_NAME .. ".debug")
require(framework.PACKAGE_NAME .. ".functions")

require(framework.PACKAGE_NAME .. ".cocos.Cocos2dConstants")
require(framework.PACKAGE_NAME .. ".cocos.Cocos2d")
require(framework.PACKAGE_NAME .. ".cocos.GuiConstants")
require(framework.PACKAGE_NAME .. ".cocos.OpenglConstants")
require(framework.PACKAGE_NAME .. ".cocos.Opengl")
require(framework.PACKAGE_NAME .. ".cocos.CCBReaderLoad")
require(framework.PACKAGE_NAME .. ".cocos.AudioEngine")

require(framework.PACKAGE_NAME .. ".extend.device")
require(framework.PACKAGE_NAME .. ".extend.scr")
require(framework.PACKAGE_NAME .. ".extend.game")
require(framework.PACKAGE_NAME .. ".extend.ui")
require(framework.PACKAGE_NAME .. ".extend.timer")
transition = require(framework.PACKAGE_NAME .. ".extend.transition")

if device.platform == "ios" then
    platformLuaoc = require(framework.PACKAGE_NAME .. ".extend.platformLuaoc")
end

-- crypto = require(framework.PACKAGE_NAME .. ".extend.crypto")
json = require(framework.PACKAGE_NAME .. ".extern.json")		--#####


-- 已经移动到appinit.lua文件中去加载了
-- require(framework.PACKAGE_NAME .. ".extern.protobuf")
-- require(framework.PACKAGE_NAME .. ".extern.heap")

-- require(framework.PACKAGE_NAME .. ".network.buffer")
-- require(framework.PACKAGE_NAME .. ".network.EventProtocol")
-- require(framework.PACKAGE_NAME .. ".network.SocketTCP")

-- require(framework.PACKAGE_NAME .. ".mvc.App")
-- require(framework.PACKAGE_NAME .. ".mvc.Event")
-- require(framework.PACKAGE_NAME .. ".mvc.CollectBase")
-- require(framework.PACKAGE_NAME .. ".mvc.ViewBase")
-- require(framework.PACKAGE_NAME .. ".mvc.ModelBase")
-- require(framework.PACKAGE_NAME .. ".mvc.CtrlBase")
-- require(framework.PACKAGE_NAME .. ".mvc.ViewNode")

-- require(framework.PACKAGE_NAME .. ".extend.BaseModuleView")
-- require(framework.PACKAGE_NAME .. ".extend.BaseUIView")
-- require(framework.PACKAGE_NAME .. ".extend.BaseNetWork")
-- ProFi = require(framework.PACKAGE_NAME ..".ProFi")
require("src.app.util.HotUpdateUtil")				--####
-- require("src.app.util.PlatformUtil")
