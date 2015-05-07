--底下管理menu组
local PVHome = import("...ui.home.PVHome")

local HomeModule = class("HomeModule", BaseModuleView)

function HomeModule:ctor()
    self.super.ctor(self)
    self.moduleName = self.__cname
    self:loadBaseModuleUi(PVHome)
end

function HomeModule:hideView()
    removeView(self.ui.rootNode)
end

function HomeModule:showView()

    showView(self.ui.rootNode)

end

return HomeModule

