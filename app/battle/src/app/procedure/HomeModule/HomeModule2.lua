local PVHome2 = import("...ui.home.PVHome2")

local HomeModule2 = class("HomeModule2", BaseModuleView)

function HomeModule2:ctor()
    self.super.ctor(self)
    self.moduleName = self.__cname
    self:loadBaseModuleUi(PVHome2)
end

function HomeModule2:hideView()
    removeView(self.ui.rootNode)
end

function HomeModule2:showView()
    showView(self.ui.rootNode)
end

return HomeModule2