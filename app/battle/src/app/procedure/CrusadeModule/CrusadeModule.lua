
--背包

--道具批量使用界面
-- local PVUseItemTips = import("...ui.bag.PVUseItemTips")

-- local PVBag = import("...ui.bag.PVBag")

local PVChapters = import("...ui.homepage.instance.PVChapters")             --章节选择

local CrusadeModule = class("CrusadeModule", BaseModuleView)

function CrusadeModule:ctor()
    self.super.ctor(self)
    self.moduleName = self.__cname

    -- self:pushModule(PVBag)
    self:pushModule(PVChapters)
    -- self:pushModule(PVUseItemTips)

end

function CrusadeModule:hideView()
    removeView(self.ui.rootNode)
end

return CrusadeModule

