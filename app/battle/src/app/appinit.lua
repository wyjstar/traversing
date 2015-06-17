-- appinit.lua
-- @create by QGW
-- @create Date 2015.04.02
-- @descript 主要用于热更新之后需要更新init的文件

require("src.config")

crypto = require(framework.PACKAGE_NAME .. ".extend.crypto")
Localize = require(framework.PACKAGE_NAME .. ".extern.Localize") --本地话语言

require(framework.PACKAGE_NAME .. ".extern.protobuf")
require(framework.PACKAGE_NAME .. ".extern.heap")

require(framework.PACKAGE_NAME .. ".network.buffer")
require(framework.PACKAGE_NAME .. ".network.EventProtocol")
require(framework.PACKAGE_NAME .. ".network.SocketTCP")

require(framework.PACKAGE_NAME .. ".mvc.App")
require(framework.PACKAGE_NAME .. ".mvc.Event")
require(framework.PACKAGE_NAME .. ".mvc.CollectBase")
require(framework.PACKAGE_NAME .. ".mvc.ViewBase")
require(framework.PACKAGE_NAME .. ".mvc.ModelBase")
require(framework.PACKAGE_NAME .. ".mvc.CtrlBase")
require(framework.PACKAGE_NAME .. ".mvc.ViewNode")

require(framework.PACKAGE_NAME .. ".extend.BaseModuleView")
require(framework.PACKAGE_NAME .. ".extend.BaseUIView")
require(framework.PACKAGE_NAME .. ".extend.BaseNetWork")

if DEBUG then
    ProFi = require(framework.PACKAGE_NAME ..".ProFi")
end

require("src.app.util.Util")				
require("src.app.util.PlatformUtil")
require("src.app.controller.GameController")

local NetManage = require("src.app.netcenter.NetManage")
g_NetManager = g_NetManager or NetManage.new()
