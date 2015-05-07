--PVServerList
local PVScrollBar = import("..ui.homepage.scrollbar.PVScrollBar")
local PvNotice = import("..ui.notice.PvNotice")
local PVServerList = class("PVServerList", BaseUIView)

function PVServerList:ctor(id)
    self.super.ctor(self, id)

    self.LoginServer = {}
    self.selectItem = {}
    self.itemCount = 0
    self.curCell = nil

    self.isTourist = cc.UserDefault:getInstance():getBoolForKey("isTourist", false)
    self.account_name = cc.UserDefault:getInstance():getStringForKey("tourist_id")
    print("PVServerList 进入游戏获取相关数据 ==================== ", self.isTourist,           self.account_name)
    self:initTouchListener()

    self:initView()
    self:initTableView()

    self:initData()

    -- 网络请求注册回掉
    self:initRegisterNetCallBack()

    self.loginNet = getNetManager():getLoginNet()

    self.serverLayerVisible = false

     local layer = createBlockLayer()
    if layer then
        self:addChild(layer)
    end


    -- local _sprite = cc.Sprite:create("res/test/stage_scene_1.png")
    -- self:addChild(_sprite)

    -- local _spritejpg = cc.Sprite:create("res/test/jpg_h.jpg")
    -- self:addChild(_spritejpg)

    -- game.addSpriteFramesWithFile("res/test/test_bg2.plist")
    -- -- cc.Texture2D:
    -- local test_bg = cc.Sprite:createWithSpriteFrameName("stage_scene_2.png")
    -- test_bg:setAnchorPoint(cc.p(0, 0))
    -- self:addChild(test_bg)

    -- local _info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    -- cclog(_info)

    -- local part = cc.ParticleSystemQuad:create(string.format("res/part/a0200_08.plist"))
    -- part:setPosition(320, 200)

    -- self:addChild(part)


end

-- 注册网络回调
function PVServerList:initRegisterNetCallBack()

    function onReciveMsgCallBack(_id)

        if _id == LOGIN_REGISTER_REQUEST then  -- 进入游戏

        end
    end

    self:registerMsg(LOGIN_ROLELOGIN_REQUEST, onReciveMsgCallBack)
end


function PVServerList:initTouchListener()

    local function onSelectServer()
        if not self.serverLayerVisible then
            self.serverLayerVisible = true
            self.animationManager:runAnimationsForSequenceNamed("showAnimation")
        end
    end

    local function onExitClick()
        userDefault_setStringForKey("password", "")
        userDefault_setStringForKey("tourist_id", "")
        cc.UserDefault:getInstance():setBoolForKey("isTourist", false)
        cc.UserDefault:getInstance():setBoolForKey("isBound", false)
        -- 关闭连接
        -- closeConnectNet()

        -- initConnectNet()

        -- clearGlobalObject()

        game.getRunningScene():removeAllChildren()

        local PlatformOfficial = require("src.app.platform.PlatformOfficial")
        local platformOfficial = PlatformOfficial.new("PlatformOfficial")

        game.getRunningScene():addChild(platformOfficial)

        -- local time = 1
        -- local __sendTimeTick = function ()
        --          -- 连接

             -- timer.unscheduleGlobal(self.sendTimeTickScheduler)
        -- end

        -- self.sendTimeTickScheduler = timer.scheduleGlobal(__sendTimeTick, 1)

    end

    local function onEnterGame(tag, sender)
        print("进入游戏获取相关数据 ==================== ", self.isTourist,           self.account_name)
        --进入游戏loadingtips特殊处理
        isEnterGame = true
        self.netTips = getTemplateManager():getLanguageTemplate():getNetRandTips()
        local keys = {}
        for k,v in pairs(self.netTips) do
            table.insert(keys, k)
        end
        local randomKey = table.randomKey(keys)
        local randomStr = self.netTips[randomKey].cn
        getDataManager():getCommonData():setNetTip(randomStr)
        --进入游戏loadingtips特殊处理
        if table.nums(self.selectItem) <=0 then
             -- getOtherModule():showToastView(Localize.query("server.1"))
             getOtherModule():showAlertDialog(nil, Localize.query("server.1"))
            return
        end
        sender:setEnabled(false)

        userDefault_setStringForKey("server_name", self.selectItem.name)
        -- cc.UserDefault:getInstance():setStringForKey("server", self.selectItem[3]);
        -- cc.UserDefault:getInstance():flush()

        SOCKET_URL = self.selectItem.ip
        SOCKET_PORT = self.selectItem.port

        self.loginNet:setSelectServer(self.selectItem)

        getNetManager():onNetLoading()
        -- 连接
        initConnectNet()

        -- sender:setEnabled(false)
        -- -- 进入游戏
        -- enterPlayerScene()
        --播放漫画动画

    end

    self.LoginServer["LoginServer"] = {}
    self.LoginServer["LoginServer"]["onSelectServer"] = onSelectServer
    self.LoginServer["LoginServer"]["onEnterGame"] = onEnterGame
    self.LoginServer["LoginServer"]["onExitClick"] = onExitClick

end

function PVServerList:initView()

    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()
    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    self:addChild(self.adapterLayer)

    local proxy = cc.CCBProxy:create()
    local updateView = CCBReaderLoad("login/ui_login_choose_server.ccbi", proxy, self.LoginServer)
    self.adapterLayer:addChild(updateView)

    self.contentLayer = self.LoginServer["LoginServer"]["contentLayer"]
    self.label1 = self.LoginServer["LoginServer"]["label1"]
    self.label2 = self.LoginServer["LoginServer"]["label2"]
    self.label3 = self.LoginServer["LoginServer"]["label3"]
    self.versionLabel = self.LoginServer["LoginServer"]["versionLabel"]

    self.stateSprite = self.LoginServer["LoginServer"]["stateSprite"]
    self.serverName = self.LoginServer["LoginServer"]["serverName"]
    self.chooseLabel = self.LoginServer["LoginServer"]["chooseLabel"]
    self.serverLayer = self.LoginServer["LoginServer"]["serverLayer"]
    self.serverLayer:setScaleY(0)

    self.SelectServerBtn = self.LoginServer["LoginServer"]["SelectServerBtn"]
    self.SelectServerBtn:setAllowScale(false)

    self.animationManager = self.LoginServer["LoginServer"]["mAnimationManager"]

    -- 加入公告
    if NOTICE_URL then
        print("NOTICE_URL=============================>",NOTICE_URL)
        local _PvNotice = PvNotice.new("PvNotice")
        _PvNotice:openWebView(NOTICE_URL)
        self:addChild(_PvNotice)        
    end
end

function PVServerList:initTableView()

    self.layerSize = self.contentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    -- local scrBar = PVScrollBar:new()
    -- scrBar:init(self.tableView,1)
    -- scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
    -- self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVServerList:scrollViewDidScroll(view)
end

function PVServerList:scrollViewDidZoom(view)
end

function PVServerList:tableCellTouched(tab, cell)
    local idx = cell:getIdx()
    self:changeSelect(cell, idx)
end

function PVServerList:cellSizeForTable(table, idx)
    return 45, 405
end

function PVServerList:tableCellAtIndex(tbl, idx)

    -- self.cell = tbl:dequeueCell()

    self.cell = nil
    if nil == self.cell then
        self.cell = cc.TableViewCell:new()
        self.cell.LoginServerItem = {}
        self.cell.LoginServerItem["LoginServerItem"] = {}

        local proxy = cc.CCBProxy:create()
        local Item = CCBReaderLoad("login/ui_login_server_item.ccbi", proxy, self.cell.LoginServerItem)

        self.cell.noselectNode = self.cell.LoginServerItem["LoginServerItem"]["noselectNode"]
        self.cell.selectNode = self.cell.LoginServerItem["LoginServerItem"]["selectNode"]

        self.cell.label1 = self.cell.LoginServerItem["LoginServerItem"]["label1"]
        self.cell.label2 = self.cell.LoginServerItem["LoginServerItem"]["label2"]
        self.cell.label3 = self.cell.LoginServerItem["LoginServerItem"]["label3"]
        self.cell.label4 = self.cell.LoginServerItem["LoginServerItem"]["label4"]
        self.cell.label5 = self.cell.LoginServerItem["LoginServerItem"]["label5"]
        self.cell.label6 = self.cell.LoginServerItem["LoginServerItem"]["label6"]

        self.cell.selectNode:setVisible(false)

        self.cell.label1:setString(string.format("%d%s", self.serverList[idx+1].no, Localize.query("server.2")))
        self.cell.label2:setString(self.serverList[idx+1].name)
        self.cell.label3:setString(self:serverStatusTitle(self.serverList[idx+1].status))

        self.cell.label4:setString(string.format("%d%s", self.serverList[idx+1].no, Localize.query("server.2")))
        self.cell.label5:setString(self.serverList[idx+1].name)
        self.cell.label6:setString(self:serverStatusTitle(self.serverList[idx+1].status))


        if self.serverList[idx+1].select then
            self:changeSelect(self.cell, idx)
            self.curCell = self.cell
            self.curCell:setIdx(idx)
        end

        self.cell:addChild(Item)
    end

    return self.cell
end

-- 选择服务器
function PVServerList:changeSelect(cell, idx)
    cell.selectNode:setVisible(true)
    cell.noselectNode:setVisible(false)

    self.selectItem = self.serverList[idx+1]

    self.stateSprite:setVisible(true)
    self.stateSprite:setSpriteFrame(game.newSpriteFrame(self:serverStatusSprite(self.selectItem.status)))

    self.serverName:setString(self.selectItem.name)

    if not self.curCell then
        self.curCell = cell

        return
    end

    local index = self.curCell:getIdx()
    if index ~= idx then
        self.curCell.selectNode:setVisible(false)
        self.curCell.noselectNode:setVisible(true)
    end

    self.curCell = cell

    -- 隐藏服务器列表
    -- if self.serverLayerVisible then
    --     self.serverLayer:setScaleY(0)
    --     self.serverLayerVisible = false
    -- end
end

function PVServerList:numberOfCellsInTableView(table)

   return self.itemCount
end

function PVServerList:initData()
    -- 本地保存的版本信息
    local _version = curversion
    print("PVServerList:",curversion)
    if _version == nil then
        local packagePath = cc.FileUtils:getInstance():fullPathForFilename("src/packageinfo.json")
        local packInfo = nil
        local f = io.open(packagePath, "r")
        if f then
            packInfo = json.decode(f:read("*a"))
            f:close()
        end
        local skipDownload = (packInfo == nil or false)
        if skipDownload then
            _version = "1.0.0.0"
        else
            _version = packInfo.version --本地版本信息
        end
    end
    packInfo = nil
    --local _version = cc.UserDefault:getInstance():getStringForKey("UPDATE_RES_VERSION", UPDATE_RES_VERSION)
    self.versionLabel:setString("版本号：".._version)
    self.label1:setString("")
    self.label2:setString("")
    self.label3:setString("")
    self.serverName:setString("")

    self.stateSprite:setVisible(false)

    self.server_name = cc.UserDefault:getInstance():getStringForKey("server_name")

    self.serverList = getNetManager():getLoginNet():getServerList()

   -- self.LoginServer = {{"1区", "60服务器", "192.168.1.60", "11009", 1, false}}

   for k,v in pairs(self.serverList) do
        v.no = k
        if v.name == self.server_name then
            v.select = true
            self.selectItem = v
        else
            v.select = false
        end
   end

   self.itemCount = table.nums(self.serverList)

   self.tableView:reloadData()

   if table.nums(self.selectItem) <= 0 then
        -- print("服务器列表 ============================ ", table.getn(self.serverList))
       -- self.selectItem = self.serverList[1]
       -- self.serverList[1].select = true
       self.serverLayerVisible = true
        self.animationManager:runAnimationsForSequenceNamed("showAnimation")

       return
   end

    self.label1:setString(string.format("%d%s", self.selectItem.no, Localize.query("server.2")))
    self.label2:setString(self.selectItem.name)
    self.label3:setString(self:serverStatusTitle(self.selectItem.status))

    self.stateSprite:setVisible(true)
    self.stateSprite:setSpriteFrame(game.newSpriteFrame(self:serverStatusSprite(self.selectItem.status)))

    self.serverName:setString(self.selectItem.name)



end

-- 1火爆、2拥挤、3流畅、4维护、5新
function PVServerList:serverStatusTitle(status)
    local title = Localize.query("server_status."..status, Localize.query("server.3"))
    return title
end

-- 1,推荐，2，火爆
function PVServerList:serverStatusSprite(status)
    if status == "hot" then
        return "ui_login_baoman.png"
    else
        return "ui_login_tuijian.png"
    end
end


return PVServerList
