
require("src.app.controller.GameController")
local NetManage = import("..netcenter.NetManage")
 require("src.app.util.Util")
g_NetManager = g_NetManager or NetManage.new()
-- require("src.app.Constants")
--getNewGManager():setCurrentGID(G_GUIDE_ANI_OVER)
--getDataManager():getFightData():setFightType(TYPE_GUIDE)
