
local HomeModule = import("..procedure.HomeModule.HomeModule2")
local HomePageModule = import("..procedure.HomePageModule.HomePageModule")
local LineUpModule = import("..procedure.LineUpModule.LineUpModule")
local CrusadeModule = import("..procedure.CrusadeModule.CrusadeModule")
local ShopModule = import("..procedure.ShopModule.ShopModule")
local WarModule = import("..procedure.WarModule.WarModule")
local PVCreateTeam = import("..platform.PVCreateTeam")
local processor = import("..netcenter.DataProcessor")

g_showingModulView = ""
g_isShowing = false

local PlayerScene = class("PlayerScene", function()
    return game.newScene("PlayerScene")
end) 

function PlayerScene:ctor()
    -- game.addSpriteFramesWithFile("res/ccb/resource/ui_common2.plist")

    self.pVTable = {}  --装有非menuModule得ui
    self.currentModuleView = nil --当前显示的module

    self.moduleNode = game.newNode() --模块node，之所以跟uinode进行区分是因为让module动态加载或者显示隐藏
    self.uiNode = game.newNode()  --显示在menu下层的ui界面所add的node
    -- self.homeMenuNode = game.newNode() --菜单node
    self.uiTopNode = game.newNode()  --显示在menu下层的ui界面所add的node,显示在menu上面的node
    self.otherNode = game.newNode() --显示其他，如网络连接，未开放，toast

    self.lineup = nil
    self.key_listener = nil

    self.firstEnter=true

    self:addRootChild(self.moduleNode)
    self:addRootChild(self.uiNode)
    -- self:addRootChild(self.homeMenuNode)
    self:addRootChild(self.uiTopNode)
    self:addRootChild(self.otherNode)
    self.lastSocketTime = 0

    g_currentSceneStatus = player_scene

    self.commonData = getDataManager():getCommonData()
    local nickName = self.commonData:getUserName()

    -- local gId = getNewGManager():getCurrentGid()

    if nickName == "" or nickName == nil then
        print("create nickName")
        self.createTeam = PVCreateTeam.new("PVCreateTeam")
        self:addChild(self.createTeam)

        local function callNewGuid()
            getNewGManager():startGuide(GuideId.G_FIRST_LOGIN)
        end
        local  seq = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(callNewGuid))
        self:runAction(seq)
    else
        local data = {}
        data.result = true
        getDataProcessor():setCreateResult(data)
    end

    local layer = createBlockLayer()
    if layer then
        self:addRootChild(layer)
    end

    self._curShowPageModul = ""


end


--像module node中添加
function PlayerScene:addHomeMenuView(_moduleView)
	print("PlayerScene:addHomeMenuView")
    -- self.moduleNode:addChild(_moduleView)
end

--像table中添加view
function PlayerScene:addPlayerView(_view)
	print("PlayerScene:addPlayerView")
    local _currentView = table.getLastItem(self.pVTable)
    if _currentView ~= nil then
        _currentView:setVisible(false)
    end
    self.uiTopNode:addChild(_view)
    table.insert(self.pVTable, _view)
end

function PlayerScene:addOtherPlayerView(_view)
	print("PlayerScene:addOtherPlayerView")
    local _currentView = table.getLastItem(self.pVTable)
    if _currentView ~= nil then
        _currentView:setVisible(false)
    end
    self.uiNode:addChild(_view)
    table.insert(self.pVTable, _view)
end

--像table中添加view --前面的不隐藏
function PlayerScene:addPlayerViewLastShow(_view)
	print("PlayerScene:addPlayerViewLastShow")
    self.uiTopNode:addChild(_view)
    table.insert(self.pVTable, _view)
end

--像table中添加view,并且显示在menu的上面
function PlayerScene:addPlayerViewAndInTop(_view)
	print("PlayerScene:addPlayerViewAndInTop")
    local _currentView = table.getLastItem(self.pVTable)
    if _currentView ~= nil then
        _currentView:setVisible(false)
    end
    self.uiTopNode:addChild(_view)
    table.insert(self.pVTable, _view)
end

-- 删除最后一个View
function PlayerScene:removeLastView()
	print("PlayerScene:removeLastView")
    local _currentView = table.getLastItem(self.pVTable)
    if _currentView ~= nil then
        _currentView:removeFromParent(true)
    end
    table.removeLastItem(self.pVTable)
end

--像table中添加view,并且显示在menu的上面,上一界面不隐藏
function PlayerScene:addPlayerViewAndInTopShowLastView(_view)
	print("PlayerScene:addPlayerViewAndInTopShowLastView")
    self.uiTopNode:addChild(_view)
    table.insert(self.pVTable, _view)
end

--添加显示其他view
function PlayerScene:addOtherView(view)
	print("PlayerScene:addOtherView")
    self.uiTopNode:addChild(view)
    table.insert(self.pVTable, view)
end

function PlayerScene:showInOtherView(view)
	print("PlayerScene:showInOtherView")
    self.otherNode:addChild(view)
end

--移除当前ui页面，并且更新下一个页面
function PlayerScene:onCurrentViewRemove( ... )
	cclog("PlayerScene:onCurrentViewRemove")
    g_showUIView = ""
    table.removeLastItem(self.pVTable)
    self:updateCurrentView( ... )
end

--更新当前界面
function PlayerScene:updateCurrentView( ... )
	print("PlayerScene:updateCurrentView")
    local currentView = table.getLastItem(self.pVTable)
    if currentView == nil then
        currentView = self.currentModuleView
    end

    if currentView ~= nil then
        local transTable = {...}
        currentView:setVisible(true)
        currentView:updateView( transTable )
    elseif currentView == nil and #self.pVTable == 0 then
        self.homeModuleView.moduleView:onRloadView()
    end
end

--更新指定的view
function PlayerScene:updateAppointView(viewName)
	print("PlayerScene:updateAppointView")
    for k, v in pairs(self.pVTable) do
        if v.__cname == viewName then
            v.updateView()
        end
    end
end

function PlayerScene:onRloadView()
    -- body
end

--清除ui模块页面
function PlayerScene:clearUI()
    print("clearUI=====================")
    for k, v in pairs(self.pVTable) do
        if v.onExit ~= nil then
            v:onExit()
        end
        if v ~= nil then
            v:removeFromParent(true)
        end
        v = nil
    end
    self.pVTable = {}
end

function PlayerScene:onExit()
    print("-----PlayerScene:onExit-------")

    -- if self.homePageView.moduleView.onExit ~= nil then
    --     self.homePageView.moduleView:onExit()
    -- end

    if self.homeModuleView.moduleView.onExit ~= nil then
        self.homeModuleView.moduleView:onExit()
    end

    if self.key_listener ~= nil then
        self.key_listener = nil
    end
    -- getHomeBasicAttrView():onExit()

    self:clearUI()
end

function PlayerScene:setKeyEnabled( enabled )
    local _enabled = enabled
    local ___refreshSetKeyEnabledFunc = function()
        timer.unscheduleGlobal(___refreshSetKeyEnabled)
        if self.key_listener ~= nil then
            self.key_listener:setEnabled(_enabled)
        end
    end
    ___refreshSetKeyEnabled = timer.scheduleGlobal(___refreshSetKeyEnabledFunc, 0.2)
   
end

--初始化
function PlayerScene:onEnter()
    print("-----PlayerScene:onEnter-------")
    self.g_menu_table = {}       --全局管理menu 的table
    local menu_name = {HomePageModule,LineUpModule,CrusadeModule,ShopModule,WarModule} --临时放将要加载的module
    for k, v in pairs(menu_name) do
        local key = v.__cname
        local temoModule = v.new(v.__cname)
        self.moduleNode:addChild(temoModule)
        self.g_menu_table[key] = temoModule
    end

    self.homeModuleView = HomeModule.new()
    self.homeModuleView:initBaseUI()
    self.homeModuleView:changeModuleViewStatr(true)
    self.homeModuleView.moduleView:onUIHide()
    self.moduleNode:addChild(self.homeModuleView)

    self.g_menu_table[HomeModule.__cname] = self.homeModuleView
    g_showingModulView = HomeModule.__cname

    local function onRelease( code,event )
        print("[TTransfer],onRelease:",code)
        if code == 6 then --Click Back Key
            if not getNewGManager():checkStageGuide() then --非新手引导过程中

                local viewCount = #self.pVTable
                if viewCount == 0 then 
                    getOtherModule():showConfirmDialog(function ( )
                        print("Sure")
                        cc.Director:getInstance():endToLua()
                    end, function ( ... )
                        print("Cancel")
                    end, Localize.query("Logout.1"))
                    -- getPlatformLuaManager():accessDiffPlatform("onConfirmExit")
                else
                    self:removeLastView()
                    local _currentView = table.getLastItem(self.pVTable)
                    if _currentView ~= nil then
                        _currentView:setVisible(true)
                    end
                end
            end
        end
    end

    local function onKeyPressed( code,event )
    end

    self.key_listener = cc.EventListenerKeyboard:create()
    self.key_listener:registerScriptHandler(onRelease,cc.Handler.EVENT_KEYBOARD_RELEASED)
    self.key_listener:registerScriptHandler(onKeyPressed,cc.Handler.EVENT_KEYBOARD_PRESSED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.key_listener,self)
end

--根据module的name获取module的实例
function PlayerScene:getModule(_moduleName)
    return self.g_menu_table[_moduleName]
end

--切换module
function PlayerScene:showModuleView(_moduleName)
    print("PlayerScene:showModuleView",_moduleName)
    -- print("_moduleName===" .. _moduleName)
    if MODULE_NAME_HOMEPAGE == _moduleName then
        self:clearUI()
    end
end

--通知ui更新
function PlayerScene:onNetMsgUpdateUI(_id, _data)
	print("PlayerScene:onNetMsgUpdateUI",_id)
   -- print("guide id", getNewGManager():getCurrentGid())

    if _id == LOGIN_CREATE_PLAYER_REQUEST then
        local resultData = processor:getCreateResult().result
        if resultData then
            if self.createTeam ~= nil then
                self.createTeam:removeFromParent(true)
                stepCallBack(GuideId.G_GUIDE_20084)
            end
        else
            local words = Localize.query("common.nickname")
            getOtherModule():showAlertDialog(nil, words)
        end
    end

    for k, v in pairs(self.g_menu_table ) do
        v:onNotifUIUpdate(_id, _data)
    end

    for k, v in pairs(self.pVTable ) do
        v:receiveMsg(_id, _data)
    end
end

function PlayerScene:notice(noticeId, state)
    print("PlayerScene:notice", noticeId, state)
    for k, v in pairs(self.pVTable ) do
        v:changeNoticeState(noticeId, state)
    end

    self.homeModuleView:notice(noticeId, state)
end

function PlayerScene:enterBattle(stageId)
    local _data = {}
    local _hasHero = false
    _data.stage_id = stageId
    _data.stage_type = 1
    _data.lineup = {}

    self.stageId=stageId
    self.lineup = {}

    local lineUpList = getDataManager():getLineupData():getSelectSoldier()
    local embattleOrder = getDataManager():getLineupData():getEmbattleOrder()

    for k,v in pairs(lineUpList) do
        _data.lineup[v.slot_no] = embattleOrder[k]
        self.lineup[k] = {pos = v.slot_no, hero_id = v.hero.hero_no, activation = v.activation}
        if v.hero.hero_no ~= 0 then _hasHero = true end
    end

    _data.unparalleled = 0
    _data.fid = 0
    if _hasHero == true then
        cclog("发送请求")
        table.print(_data)
        getNetManager():getInstanceNet():sendStartFight(_data)
    end

end


return PlayerScene
