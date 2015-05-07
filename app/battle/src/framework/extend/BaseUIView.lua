--普通ui 的父类
PVScrollBar = import("src.app.ui.homepage.scrollbar.PVScrollBar")
BaseUIView = class("BaseUIView", function()
    return game.newNode()
end)

function BaseUIView:ctor(id)
    self._name = id
    self.netWorkTable = {}
    self:initAdapterLayer()
    -- self:initBaseUI()

    self.tableViewAction = false
    self.itemWidth = 0
    self.boundsArea = 25

    self.allchildrens = {}

    local function onNodeEvent(event)
        if "enterTransitionFinish" == event then
            if self.enterTransitionFinish ~= nil then
                self:enterTransitionFinish()
            end
        end
    end

    self:registerScriptHandler(onNodeEvent)  
end

function BaseUIView:onMVCEnter()
    -- body
end

function BaseUIView:initBaseUI()
    print("BaseUIView:initBaseUI=======>")
    --就在这里加屏蔽
    self.shieldlayer = self:createShieldLayer()
    self.shieldlayer:setTouchEnabled(true)

    -- local sharedDirector = cc.Director:getInstance()
    -- local glsize = sharedDirector:getWinSize()
    -- self.adapterLayer = cc.Layer:create()

    -- self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    -- self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    -- self:addChild(self.adapterLayer)
    self.adapterLayer:addChild(self.shieldlayer)
end

function BaseUIView:initAdapterLayer()
    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()

    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    self:addChild(self.adapterLayer)
end

function BaseUIView:initOtherBaseUI()
    --就在这里加屏蔽
    self.shieldlayer = self:createOtherShieldLayer()
    self.shieldlayer:setTouchEnabled(true)

    local _size = self.shieldlayer:getContentSize()

    

    -- local sharedDirector = cc.Director:getInstance()
    -- local glsize = sharedDirector:getWinSize()
    -- self.adapterLayer = cc.Layer:create()

    -- self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    -- self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    -- self:addChild(self.adapterLayer)
    self.adapterLayer:addChild(self.shieldlayer)

    -- local colorLayer = cc.LayerColor:create(cc.c4b(255, 0, 0, 125), _size.width, _size.height)
    -- self.adapterLayer:addChild(colorLayer)

end

function BaseUIView:showAttributeView()
    self.shieldlayer:setContentSize(cc.size(640, 960 - ATTRIBUTE_VIEW_HEIGHT))
end

function BaseUIView:addToUIChild(_node, tag)
    -- _node:setTag(tag)
    self.adapterLayer:addChild(_node)
end

--加载ccbi
function BaseUIView:loadCCBI(_name, _table)
    local node = game.newCCBNode(_name, _table)
    if node then
        node:setTag(19980)
        self:addToUIChild(node)        
    end
    return node
end

--back事件，移除当前ui
function BaseUIView:onHideView( ... )
    cclog("onHideView:" .. self._name)

    if self.onExit ~= nil then
        self:onExit()
    end

    self:removeFromParent(true)   

    local runningScence = cc.Director:getInstance():getRunningScene()
    if runningScence == getPlayerScene() then
        print("this scene is PlayerScene")
        local _closeTips = getDataManager():getStageData():getCloseTips()
        if _closeTips then
            getDataManager():getStageData():setCloseTips(false)
        else
            getPlayerScene():onCurrentViewRemove( ... )
        end
    else
       getDataManager():getStageData():setCloseTips(false) 
    end
    --传递参数 ,geng更新数据
end

--从上个界面来的所接收参数
function BaseUIView:initFunc(func)
    self.funcTable = func
end

--获得传递的参数
function BaseUIView:getTransferData()
    return self.funcTable
end

--当view是module ui时
function BaseUIView:onUIShow()
    -- self:changeShieldLayerState(true)
    if self.update ~= nil then
        self:update()
    end

end

function BaseUIView:onUIHide()
    -- self:changeShieldLayerState(false)
end

--改变屏蔽事件是否起作用
function BaseUIView:changeShieldLayerState(state)
    self.shieldlayer:setTouchEnabled(state)
    self.shieldlayer:setVisible(false)
end

--更新界面(从上一个页面返回到当前页面)
function BaseUIView:updateView( transTable )

    if transTable ~= nil then
        self.funcTable = transTable
    end

    if self.onReloadView ~= nil then
        self:onReloadView()
    end
end

--注册网络接受协议
function BaseUIView:registerMsg(_id, _hander)
    self.netWorkTable[_id] = _hander
end

--接受协议id
function BaseUIView:receiveMsg(_id, _data)
    local hander = self.netWorkTable[_id]
    if hander ~= nil then
        hander(_id, _data)
    end
end

-- toast  提示
function BaseUIView:toastShow(message)
    if string.len(message) > 0 then
        getOtherModule():showToastView(message)
    end
end


function BaseUIView:resetTabviewContentOffset(tableView)
    local pos = tableView:getContentOffset()
    tableView:setContentOffset(cc.p(self.boundsArea, pos.y))
end

-- table view 出场动画
function BaseUIView:tableViewItemAction(tableView)

   local items = tableView:getContainer():getChildren()
    -- print(tableView.isAction)
   if not self.tableViewAction or not tableView.isAction then

        tableView.isAction = true
        self.itemWidth = tableView:getViewSize().width
        self.tableViewAction = true
        -- print("itemWidth.000: "..self.itemWidth)
       local size = cc.size(self.itemWidth+self.boundsArea, tableView:getViewSize().height)
        tableView:setViewSize(size)
        -- print("itemWidth.222: "..tableView:getViewSize().width..'----'..tableView:getViewSize().height)
        tableView:setPosition(cc.p(tableView:getPositionX()-self.boundsArea, tableView:getPositionY()))

    end

    local pos = tableView:getContentOffset()
    tableView:setContentOffset(cc.p(self.boundsArea, pos.y))
    local pos = tableView:getContentOffset()


   for k, v in pairs(items) do
        local pos = cc.p(self.itemWidth, v:getPositionY())
        v:setPosition(pos)
        v:setVisible(false)
    end

   local _time = 0.15
   for k, v in pairs(items) do
        v:runAction(cc.Sequence:create(cc.Show:create(), cc.MoveTo:create(_time, cc.p(-self.boundsArea, v:getPositionY())),
            cc.MoveTo:create(0.1, cc.p(0, v:getPositionY()))))
        _time = _time + 0.08
    end
end

function BaseUIView:viewRunActionFadeIn()
    self:setCascadeOpacityEnabled(true)
    self.allchildrens = {}

    local _allchildrens = self:getAllChildren(self.adapterLayer)

    for k,v in pairs(self.allchildrens) do
        if v and v:isVisible() then
            v:setOpacity(0)
            -- v:runAction(cc.FadeOut:create(2))
        end
    end

    for k,v in pairs(self.allchildrens) do
        if v and v:isVisible() then
            v:runAction(cc.FadeIn:create(0.5))
            -- v:runAction(cc.FadeOut:create(2))
        end
    end
end

function BaseUIView:getAllChildren(parent)
    local children = parent:getChildren()

    for k, v in pairs(children) do
        local _child = v:getChildren()
        if table.nums(_child) > 0 then
            self:getAllChildren(v)

        end
        if v:isVisible() and v:getCCNodeType() == 1 then
            table.insert(self.allchildrens, v)
        end
    end
end

function BaseUIView:createShieldLayer()
    local layer = cc.Layer:create()
    --local layer = game.newLayer()
    -- print("scr. ============== scr.heightInPixels ", scr.contentScaleFactor,     scr.heightInPixels)
    local viewHeight = scr.contentScaleFactor * CONFIG_SCREEN_SIZE_HEIGHT
    -- print("viewHeight ------------------- ", viewHeight)
    -- local height = (scr.heightInPixels - viewHeight) / 2

    local winSize = cc.Director:getInstance():getWinSize()
    local height = (winSize.height - CONFIG_SCREEN_SIZE_HEIGHT) / 2
    -- print("height ================ ", height)
    local function onTouchEvent(eventType, x, y)
        -- print("====================",eventType)
        if eventType == "began" then

            -- local size = layer:getContentSize()
            -- -- print("size ======== szie ============ ", size.width,           size.height)
            -- -- print("scr.contentScaleFactor====" .. scr.contentScaleFactor)
            -- -- print("CONFIG_SCREEN_SIZE_HEIGHT=====" .. CONFIG_SCREEN_SIZE_HEIGHT)
            -- -- print("scr.heightInPixels=====" .. scr.heightInPixels)
            -- -- print("yyyyyy=======" .. y)
            -- -- print("size.height=======" .. size.height + height)
            -- -- print("height====" .. height)
            -- if y < size.height + height and y > HOMEMENU_VIEW_HEIGHT + height then
            -- if y < size.height + height then
            --     return true
            -- end
            return true

        end
    end

    layer:registerScriptTouchHandler(onTouchEvent)
    layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    layer:setTouchEnabled(true)

    return layer
end


function BaseUIView:createOtherShieldLayer()
    local layer = cc.Layer:create()
    --local layer = game.newLayer()

    local viewHeight = scr.contentScaleFactor * CONFIG_SCREEN_SIZE_HEIGHT
    -- local height = (scr.heightInPixels - viewHeight) / 2

    local winSize = cc.Director:getInstance():getWinSize()
    local height = (winSize.height - CONFIG_SCREEN_SIZE_HEIGHT) / 2

    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then

            local size = layer:getContentSize()
            -- print("scr.contentScaleFactor====" .. scr.contentScaleFactor)
            -- print("CONFIG_SCREEN_SIZE_HEIGHT=====" .. CONFIG_SCREEN_SIZE_HEIGHT)
            -- print("scr.heightInPixels=====" .. scr.heightInPixels)
            -- print("scr.heightInPixels=====" .. scr.heightInPixels)
            -- print("yyyyyy=======" .. y)
            -- print("size.height=======" .. size.height + height)
            -- print("height====" .. height)

            -- if y < size.height + height and y > HOMEMENU_VIEW_HEIGHT + height then
            --     return true
            -- end
            return true

        end
    end

    layer:registerScriptTouchHandler(onTouchEvent)
    layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    layer:setTouchEnabled(true)

    return layer
end

function BaseUIView:createTopShieldLayer()
    local layer = cc.Layer:create()

    local viewHeight = scr.contentScaleFactor * CONFIG_SCREEN_SIZE_HEIGHT

    local winSize = cc.Director:getInstance():getWinSize()
    local height = (winSize.height - CONFIG_SCREEN_SIZE_HEIGHT) / 2

    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            return true

        end
    end

    layer:registerScriptTouchHandler(onTouchEvent)
    layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    layer:setTouchEnabled(true)
    layer:setTag(999)
    self:addChild(layer,999)
end

function BaseUIView:removeTopShieldLayer()
    self:removeChildByTag(999)
end


-- 统一处理commonResource
function BaseUIView:handelCommonResResult(res)
    if res == nil then
        return false
    end

    if not res.result then
        cclog("==commonResReult result_no==")
        cclog(res.result_no)
        self:toastShow(tostring(Localize.query(res.result_no)))

        return false
    end

    return true
end

function BaseUIView:startShowNewGView()
    local node = getNewGManager():drawCircle()
    self.adapterLayer:addChild(node)

end

function BaseUIView:changeNoticeState(noticeId, state)
    local func = self.subChNoticeState
    if func then
        func(noticeId, state)
    end
end






