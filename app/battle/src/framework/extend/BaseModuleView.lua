--moduleView 的父类
BaseModuleView = class("BaseModuleView", function()
    return game.newNode()
end)

function BaseModuleView:ctor()
    print("111111111")
    self.moduleName = nil
    self.uiTable = {}
    self.BaseUI = nil --模块的ui
    self.moduleView = nil --module的view
    --就在这里加屏蔽
    self.noUseViewTable = {}
    table.insert(self.noUseViewTable, "PVSoldierMain")
    table.insert(self.noUseViewTable, "PVSoldierBreakDetail")
    table.insert(self.noUseViewTable, "PVSoldierMyLookDetail")
    table.insert(self.noUseViewTable, "PVSoldierUpgradeDetail")

    table.insert(self.noUseViewTable, "PVEquipmentAttribute")
    table.insert(self.noUseViewTable, "PVEquipmentAwaken")
    table.insert(self.noUseViewTable, "PVEquipmentMain")
    table.insert(self.noUseViewTable, "PVEquipmentSmelting")
    table.insert(self.noUseViewTable, "PVEquipmentStrengthen")

    table.insert(self.noUseViewTable, "PVSacrificePanel")
    table.insert(self.noUseViewTable, "PVSecretShop")
    table.insert(self.noUseViewTable, "PVGeneralList")

    table.insert(self.noUseViewTable, "PVArenaPanel")
end

function BaseModuleView:pushModule(item)
    table.insert(self.uiTable, item)
end

function BaseModuleView:notice(noticeId, state)
    self.moduleView:subChNoticeState(noticeId, state)
end

function BaseModuleView:loadBaseModuleUi(_module)
    self.BaseUI = _module

end

function BaseModuleView:changeModuleViewStatr(state)
    if state then  --初始化模块的ui
        self:onModuleViewShow()
    else
        self:onModuleViewHide()
    end
end

--初始化模块的ui
function BaseModuleView:initBaseUI()
    if  self.moduleView == nil and self.BaseUI ~= nil then
        self.moduleView = self.BaseUI.new(self.BaseUI.__cname)
        self.moduleView:onMVCEnter()
        self:addChild(self.moduleView)
    end
end

function BaseModuleView:removeBaseUI()
    self:removeAllChildren()
    self.moduleView = nil
end

function BaseModuleView:onModuleViewShow()
    self:setVisible(true)
    if self.moduleView then
        if self.moduleView.onUIShow then
            self.moduleView:onUIShow()
        end
    end
end

function BaseModuleView:onModuleViewHide()
    self:setVisible(false)
    if self.moduleView.onUIHide then
        self.moduleView:onUIHide()
    end
end

function BaseModuleView:onBaseViewShow(state)
    self.shieldlayer:setTouchEnabled(state)
end


--显示module下得ui
function BaseModuleView:showUIView(_name, ...)

    -- print("g_isShowing", g_isShowing)

    -- if g_isShowing then
    --     return
    -- end
    -- g_isShowing = true
    g_showingModulView = self.moduleName
    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initOtherBaseUI()
            view:initFunc( {...} )
            view:onMVCEnter()
            getPlayerScene():addPlayerView(view)
            g_isShowing = false
            return
        end
    end
end

function BaseModuleView:showUINodeView(_name, ...)
    g_showingModulView = self.moduleName
    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initOtherBaseUI()
            view:initFunc( {...} )
            view:onMVCEnter()
            getPlayerScene():addOtherPlayerView(view)
            g_isShowing = false
            return
        end
    end
end

--显示module下得ui,后面的UI不隐藏
function BaseModuleView:showUIViewLastShow(_name, ...)

    print("g_isShowing", g_isShowing)

    if g_isShowing then
        return
    end
    g_isShowing = true
    g_showingModulView = self.moduleName
    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initOtherBaseUI()
            view:initFunc( {...} )
            view:onMVCEnter()
            getPlayerScene():addPlayerViewLastShow(view)
            g_isShowing = false
            return
        end
    end
end

--显示module下得ui,并且在ui的最上层
function BaseModuleView:showUIViewAndInTop(_name, ...)

    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initBaseUI()
            view:initFunc( {...} )
            view:onMVCEnter()
            getPlayerScene():addPlayerViewAndInTop(view)
            return
        end
    end
end

--显示module下得ui,并且在ui的最上层
function BaseModuleView:showUIViewAndInRunningScence(_name, ...)

    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initBaseUI()
            view:initFunc( {...} )
            view:onMVCEnter()
            -- getPlayerScene():addPlayerViewAndInTop(view)
            cc.Director:getInstance():getRunningScene():addChild(view, 999991)
            return
        end
    end
end

-- 删除最后一个View
function BaseModuleView:removeLastView()
    getPlayerScene():removeLastView()
end

--显示窗口型界面，上一界面不隐藏
function BaseModuleView:showUITopShowLastView(_name, ...)

    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initBaseUI()         --添加屏蔽层
            view:initFunc( {...} )
            view:onMVCEnter()
            getPlayerScene():addPlayerViewAndInTopShowLastView(view)
            return
        end
    end
end

--更新界面
function BaseModuleView:updateView(transTable)
    if self.moduleView then
       if self.moduleView.updateView then
            self.moduleView:updateView(transTable)
        end
    end
end

--通知module界面更新
function BaseModuleView:onNotifUIUpdate(_id, _data)
    if self.moduleView ~= nil then
        self.moduleView:receiveMsg(_id, _data)
    end

end
