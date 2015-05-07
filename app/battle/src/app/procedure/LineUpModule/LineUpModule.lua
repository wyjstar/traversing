--阵容
local PVLineUp = import("...ui.lineup.PVLineUp")

local PVSelectEquipment = import("...ui.lineup.PVSelectEquipment")
local PVSelectSoldier = import("...ui.lineup.PVSelectSoldier")
local PVSoldierChain = import("...ui.lineup.PVSoldierChain")
local PVWSPage = import("...ui.lineup.PVWSDetailPage")
local PVSoldierGetType = import("...ui.lineup.PVSoldierGetType")           --羁绊英雄

local LineUpModule = class("LineUpModule", BaseModuleView)


function LineUpModule:ctor()
    self.super.ctor(self)
    self.moduleName = self.__cname
    self:pushModule(PVLineUp)
    self:pushModule(PVSelectEquipment)
    self:pushModule(PVSelectSoldier)
    self:pushModule(PVSoldierChain)
    self:pushModule(PVWSPage)
    self:pushModule(PVSoldierGetType)
end

function LineUpModule:hideView()
    removeView(self.ui.rootNode)
end

return LineUpModule

