local PVArenaWarPanel = import("...ui.homepage.arena.PVArenaWarPanel")          --竞技场入口争霸界面

local WarModule = class("WarModule", BaseModuleView)

function WarModule:ctor()
	self.super.ctor(self)
    self.moduleName = self.__cname
    
    self:pushModule(PVArenaWarPanel)

end

function WarModule:hideView()
    removeView(self.ui.rootNode)
end

return WarModule