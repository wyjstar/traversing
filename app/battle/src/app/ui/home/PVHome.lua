
SET_AREANOTICE = "SET_AREANOTICE"
SET_FIGHTNOTICE = "SET_FIGHTNOTICE"
SET_LINEUPNOTICE = "SET_LINEUPNOTICE"
isLevel7 = false
--底部menu
local PVHome = class("PVHome", BaseUIView)

function PVHome:ctor(id)
    PVHome.super.ctor(self, id)
    --self:onMVCEnter()
end

function PVHome:onMVCEnter()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    game.addSpriteFramesWithFile("res/ccb/resource/ui_navi.plist")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    self.UIHomeView = {}
    self:initTouchListener()

    self:loadCCBI("home/ui_home.ccbi", self.UIHomeView)

    self:initView()
    --self:createListView()
    self:createSlidingMenu()
    --local function updateOnce(dt)
        --self:dispatchEvent(const.EVENT_PV_HOMEPAGE_SHOW)
    --end
    --self.scheduler = cc.Director:getInstance():getScheduler()
    --self.scheduler:scheduleScriptFunc(updateOnce, 1, true)
    --cc.Sequence:create(cc.ScaleBy:create(2, 2),cc.FadeOut:create(2),cc.CallFunc:create(CallFucnCallback2))
    -- self:runAction(cc.Sequence:create(
    -- {
    --     cc.DelayTime:create(0.03),
    --     cc.CallFunc:create(updateOnce)
    -- }))
    -- self:changeShieldLayerState(false)
    -- self:startShowNewGView()

    local function setAreaNotice()
        print("------争霸红点---------")
        -- self:updatePvpArena()
    end
    self.listener = cc.EventListenerCustom:create(SET_AREANOTICE, setAreaNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

    local function setFightNotice()
        print("------讨伐红点---------")
        self:updateInstanceNotice()
    end
    self.listener2 = cc.EventListenerCustom:create(SET_FIGHTNOTICE, setFightNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener2, 1)

    local function setLineUpNotice()
        print("------阵容红点---------")
        self:updateLineUpNotice()
    end
    self.listener3 = cc.EventListenerCustom:create(SET_LINEUPNOTICE, setLineUpNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener3, 1)

    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end

    -- self:registerScriptHandler(onNodeEvent)

    self:initScheduer()

    --讨伐红点显示
    self:updateInstanceNotice()
    --阵容红点显示
    -- self:updateLineUpNotice()
end

function PVHome:initView()
    self.hmMenuA = self.UIHomeView["UIHomeView"]["hmMenuA"]
    self.imgHomeA = self.UIHomeView["UIHomeView"]["imgHomeA"]


    self.listLayer = self.UIHomeView["UIHomeView"]["listLayer"]
    self.shopNotice = self.UIHomeView["UIHomeView"]["shop_notice"]

    self.lineup_notice = self.UIHomeView["UIHomeView"]["lineup_notice"]
    self.lineup_notice:setVisible(false)
    self.fight_notice = self.UIHomeView["UIHomeView"]["fight_notice"]
    self.fight_notice:setVisible(false)
    self.arena_notice = self.UIHomeView["UIHomeView"]["arena_notice"]
    self.arena_notice:setVisible(false)

    self.nodeZhengba = self.UIHomeView["UIHomeView"]["nodeZhengba"]

    -- self.touchLayer = self.UIHomeView["UIHomeView"]["touchLayer"]


    self.isInLeft = true

    self.bgTable = {"#ui_navi1_bf1.png", "#ui_navi1_bag1.png", "#ui_navi_shop1.png", "#ui_navi1_mail1.png"}

    self.spriteTable = {"#ui_navi1_bf2.png", "#ui_navi1_bag2.png", "#ui_navi_shop2.png", "#ui_navi1_mail2.png"}

    --self:updateShopNotice()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.commonData = getDataManager():getCommonData()
    self.c_LineUpData = getDataManager():getLineupData()

    -- self:updateViewLevel()

    --竞技场
    self:updatePvpArena()
end

--更新主页面的图标显示情况
function PVHome:updateViewLevel()
    local item = self.baseTemp:getBaseInfoById("uiIconOpenLevel")
    local nowLevel = self.commonData:getLevel()

    for k, v in pairs(item) do
        if k == "8004" then
            self.nodeZhengba:setVisible(nowLevel >= v)
        end
    end
end


function PVHome:initModelView()
    self.pvLineUp = PVLineUp.new("PVLineUp")
    self:addChild(self.pvLineUp)
    self.pvLineUp:setVisible(false)

    self.pvBag = PVBag.new("PVBag")
    self.addChild(self.pvBag)
    self.pvBag:setVisible(false)
end

function PVHome:initTouchListener()
    local function cbMenuA()
        getAudioManager():playEffectButton1()
        getPlayerScene():clearUI()

        stepCallBack(G_GUIDE_20059)
        stepCallBack(G_GUIDE_30002)

        --stepCallBack(G_SELECT_HOME_2)
        --stepCallBack(G_GUIDE_20038)

        --stepCallBack(G_GUIDE_20050)

        --stepCallBack(G_GUIDE_20068)
        --stepCallBack(G_GUIDE_20089)

        --stepCallBack(G_GUIDE_50002)
        --stepCallBack(G_GUIDE_60002)
        --stepCallBack(G_GUIDE_80002)
        --stepCallBack(G_GUIDE_100002)

        --stepCallBack(G_GUIDE_110002)
        --stepCallBack(G_GUIDE_120002)
        --stepCallBack(G_GUIDE_130002)
        --stepCallBack(G_GUIDE_140002)

        local level = getDataManager():getCommonData():getLevel()
        if level == 7 or level == 25 then
            if not isLevel7 then
                getHomePageView():startLevelShow(level)
                isLevel7 = true
            end
        end
    end

    local function cbMenuB()
        getAudioManager():playEffectButton1()

        getPlayerScene():clearUI()
        getModule(MODULE_NAME_LINEUP):showUIViewAndInTop("PVLineUp")

        stepCallBack(G_SELECT_LINEUP)
        stepCallBack(G_SELECT_LINEUP_2)
        --stepCallBack(G_GUIDE_20046)
        stepCallBack(G_GUIDE_20065)
        stepCallBack(G_GUIDE_20085)

        stepCallBack(G_GUIDE_120007)
        stepCallBack(G_GUIDE_130007)
        print("cbMenuB----")
    end

    local function cbMenuC()
        getAudioManager():playEffectButton1()

        getPlayerScene():clearUI()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters")
        getModule(MODULE_NAME_CRUSADE):showUIView("PVChapters")

        stepCallBack(G_GUIDE_00100)
        stepCallBack(G_SELECT_FIGHT)
        stepCallBack(G_GUIDE_20072)
        --stepCallBack(G_GUIDE_20051)
        stepCallBack(G_GUIDE_20069)

        --stepCallBack(G_GUIDE_20090)

    end

    local function cbMenuD()
        getAudioManager():playEffectButton1()
	    getPlayerScene():clearUI()
        isEntry = false
        getModule(MODULE_NAME_SHOP):showUIView("PVShopPage")
        stepCallBack(G_GUIDE_20078)
    end

    local function cbMenuE()
        getAudioManager():playEffectButton1()

        getPlayerScene():clearUI()
        getModule(MODULE_NAME_WAR):showUIView("PVArenaWarPanel")
        stepCallBack(G_GUIDE_100003)

        stepCallBack(G_GUIDE_110003)
        stepCallBack(G_GUIDE_120003)
    end

    local function cbMenunext()

    end

    local function cbMenubefore()

    end

    self.UIHomeView["UIHomeView"] = {}
    self.UIHomeView["UIHomeView"]["cbMenuA"] = cbMenuA
    self.UIHomeView["UIHomeView"]["cbMenuB"] = cbMenuB
    self.UIHomeView["UIHomeView"]["cbMenuC"] = cbMenuC
    self.UIHomeView["UIHomeView"]["cbMenuD"] = cbMenuD
    self.UIHomeView["UIHomeView"]["cbMenuE"] = cbMenuE
    self.UIHomeView["UIHomeView"]["cbMenunext"] = cbMenunext
    self.UIHomeView["UIHomeView"]["cbMenubefore"] = cbMenubefore
end

function PVHome:onExit()
    cclog("------onExitopoopop=================")
    if self.scheduerMain ~= nil then
        cclog("------onExitopoopop======gertgrgrtgrtgrrt===========")
      timer.unscheduleGlobal(self.scheduerMain)
      self.scheduerMain = nil
    end
    self:getEventDispatcher():removeEventListener(self.listener)
    self:getEventDispatcher():removeEventListener(self.listener2)
    self:getEventDispatcher():removeEventListener(self.listener3)
end

function PVHome:touchMenuCallBack(index)


    local function callBack()
        print("callBack")
    end
    self:registerMsg(1, callBack)

    if index == 1 then
        showModuleView(MODULE_NAME_LINEUP)
    elseif index == 2 then
        showModuleView(MODULE_NAME_CRUSADE)
    elseif index == 3 then
        showModuleView(MODULE_NAME_SHOP)
    elseif index == 4 then
        showModuleView(MODULE_NAME_EMAIL)
    elseif index == 5 then
    end
end

function PVHome:onSlidingBtnClick()
    if self.isInLeft then
        self:runToRight()
        self.isInLeft = false
    else
        self:runToLeft()
        self.isInLeft = true
    end
end

function PVHome:createSlidingMenu()
    -- local layerSize = self.listLayer:getContentSize()
    -- local function itemClickCallBack(_index)
    --     print("self.slidingMenu ================= ",self.slidingMenu.isMoved)
    --     self:touchMenuCallBack(_index + 1)
    --     getAudioManager():playEffectButton1()
    -- end

    -- self.slidingMenu = SlidingMenu:create(layerSize)
    -- self.slidingMenu:addLuaCallback(itemClickCallBack)

    -- for k, v in pairs(self.bgTable) do
    --     local item = self:createItem(k)
    --     local posX = (k - 1) * self.itemSize.width
    --     item:setPosition(cc.p(posX, 0))
    --     self.slidingMenu:addToView(item)
    -- end
    -- self.listLayer:addChild(self.slidingMenu)
end

--创建item
function PVHome:createItem(_index)
    self.UIHomeView[_index] = {}
    local proxy = cc.CCBProxy:create()
    self.UIHomeView[_index]["UIHomeItem"] = {}

    local node = CCBReaderLoad("home/ui_home_item.ccbi", proxy, self.UIHomeView[_index])

    local layer = self.UIHomeView[_index]["UIHomeItem"]["layer"]
    self.itemSize = layer:getContentSize()
    node:setContentSize(self.itemSize)

    local sprite = self.UIHomeView[_index]["UIHomeItem"]["sprite"]
    local spriteLabel = self.UIHomeView[_index]["UIHomeItem"]["spriteLabel"]

    game.setSpriteFrame(sprite, self.bgTable[_index ])
    game.setSpriteFrame(spriteLabel, self.spriteTable[_index ])
    return node
end

function PVHome:createListView()
    -- local function scrollViewDidScroll(view)
    --     --print("scrollViewDidScroll")
    --     --print(view)
    --     --print(view:getContentOffset().x)

    -- end

    -- local function scrollViewDidZoom(view)
    --     --print("scrollViewDidZoom")

    -- end

    -- local function tableCellTouched(tbl, cell)
    --     --print("PVHome cell touched at index: " .. cell:getIdx())
    --     --tbl:setContentOffset({x = 0, y = 0})
    --     --tbl:setContentOffset({x = tbl:minContainerOffset().x, y = 0})
    --     --tbl:setContentOffset(tbl:minContainerOffset())
    --     --getContainer
    --     --tbl:setContentOffsetInDuration(tbl:minContainerOffset(), 0.3)
    --     --print("_tableCellTouched___")
    --     self:touchMenuCallBack(cell:getIdx() + 1)
    --     --print(tbl:getContentOffset().x)
    --     --print(tbl:minContainerOffset().x)
    --     --print(tbl:maxContainerOffset().x)

    -- end

    -- local function numberOfCellsInTableView(tab)
    --    return table.getn(self.bgTable)
    -- end

    -- local function cellSizeForTable(tbl, idx)
    --     return self.itemSize.height,self.itemSize.width
    -- end

    -- local function tableCellAtIndex(tbl, idx)
    --     local cell = tbl:dequeueCell()
    --     -- if nil == cell then
    --     --     print("111111111111111111111111111111 ============= ")
    --     --     cell = cc.TableViewCell:new()
    --     --     local spriteBackGround = game.newSprite("#ui_hm_bg1.png")
    --     --     local spriteBg = game.newSprite()
    --     --     spriteBg:setTag(100)

    --     --     local sprite = game.newSprite()
    --     --     sprite:setTag(101)
    --     --     cell:addChild(spriteBackGround)
    --     --     cell:addChild(spriteBg)
    --     --     cell:addChild(sprite)

    --     --     game.setSpriteFrame(spriteBg, self.bgTable[idx + 1])
    --     --     game.setSpriteFrame(sprite, self.spriteTable[idx + 1])

    --     --     spriteBackGround:setPosition(cc.p(self.itemSize.width / 2, self.itemSize.height / 2))
    --     --     spriteBg:setPosition(cc.p(self.itemSize.width / 2, self.itemSize.height / 2))
    --     --     sprite:setPosition(cc.p(self.itemSize.width / 2, self.itemSize.height / 2))
    --     -- else
    --     --     print("00000000000000000000000000 ============= ")
    --     --     local spriteBg = cell:getChildByTag(100)
    --     --     local sprite = cell:getChildByTag(101)
    --     --     game.setSpriteFrame(spriteBg, self.bgTable[idx + 1])
    --     --     game.setSpriteFrame(sprite, self.spriteTable[idx + 1])

    --     -- end

    --     cell.index = idx
    --     return cell
    -- end

    -- local layerSize = self.listLayer:getContentSize()
    -- self.itemSize = cc.size(layerSize.height, layerSize.height)
    -- self.tableView = cc.TableView:create(layerSize)

    -- self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    -- self.tableView:setDelegate()
    -- self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- self.listLayer:addChild(self.tableView)

    -- self.tableView:registerScriptHandler(scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    -- self.tableView:registerScriptHandler(scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    -- self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    -- self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    -- self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    -- self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    -- self.tableView:reloadData()
    -- self.tableView:setTouchEnabled(true)
end
function PVHome:initScheduer()

    local function updateTimer()
       self:updateShopNotice()
       -- self:updateInstanceNotice()
       -- self:updatePvpArena()
       -- self:updateLineUpNotice()
       self:updatePvpArena()
    end
    self.scheduerMain = timer.scheduleGlobal(updateTimer, 1.0)
end
--商城的红点
function PVHome:updateShopNotice()

    local shopTemplate = getTemplateManager():getShopTemplate()
    local _commonData = getDataManager():getCommonData()
    local flagHero = false
    local flagGodHero = false
    -- 良将周期免费
    local preHeroTime = _commonData:getFineHero()
    local preGodHeroTime = _commonData:getExcellentHero()
    local currTime = os.time()
    local heroFreePeriod = shopTemplate:getHeroFreePeriod() * 3600 -- 免费周期（sec）
    local godHeroFreePeriod = shopTemplate:getGodHeroFreePeriod() * 3600

    local diffTime1 = os.difftime(currTime, preHeroTime)
    local diffTime2 = os.difftime(currTime, preGodHeroTime)

    -- local function updateTimer1(dt)
    --     self.diffTime1 = self.diffTime1 + 1
    --     if self.diffTime1 > self.heroFreePeriod then
    --         -- 免费，停止倒计时
    --         timer.unscheduleGlobal(self.scheduer1)
    --         self.scheduer1 = nil
    --         flagHero = true
    --     else
    --         -- 倒计时 剩余时间
    --         flagHero = false
    --     end
    -- end

    if diffTime1 < heroFreePeriod then
        -- self:removeScheduler1()
        -- self.scheduer1 = timer.scheduleGlobal(updateTimer1, 1.0)
        flagHero = false
    else
        flagHero = true
    end

    ---- 神将周期免费
    -- local function updateTimer2(dt)
    --     self.diffTime2 = self.diffTime2 + 1
    --     if self.diffTime2 > self.godHeroFreePeriod then  -- 免费，停止倒计时
    --         timer.unscheduleGlobal(self.scheduer2)
    --         self.scheduer2 = nil
    --         flagGodHero = true
    --     else  -- 倒计时 剩余时间
    --         flagGodHero = false
    --     end
    -- end

    if diffTime2 < godHeroFreePeriod then
        -- self:removeScheduler2()
        -- self.scheduer2 = timer.scheduleGlobal(updateTimer2, 1.0)
        flagGodHero = false
    else
        flagGodHero = true
    end

    if flagHero or flagGodHero then
        self.shopNotice:setVisible(true)
    else
        self.shopNotice:setVisible(false)
    end
end

--讨伐红点
function PVHome:updateInstanceNotice()
    local _stageData = getDataManager():getStageData()
    local curFbTimes = _stageData:getEliteStageTimes()
    local curHdTimes = _stageData:getActStageTimes()
    local vip = getDataManager():getCommonData():getVip()
    local fbMaxTimes = getTemplateManager():getBaseTemplate():getNumEliteTimes(vip)
    local hdMaxTimes = getTemplateManager():getBaseTemplate():getNumActTimes(vip)
    local eliteStageTimes = fbMaxTimes - curFbTimes
    local actStageTimes = hdMaxTimes - curHdTimes

    if eliteStageTimes > 0 or actStageTimes > 0 then
        self.fight_notice:setVisible(true)
    else
        self.fight_notice:setVisible(false)
    end
end

-- --竞技场红点
-- function PVHome:updatePvpArena()
--     local _level = getDataManager():getCommonData():getLevel()
--     if _level >= 15 then
--         -- print("刷新竞技场红点")
--         local freeTime = self.baseTemp:getArenaFreeTime()              --每日免费挑战次数
--         local challengeTimes = self.commonData:getPvpTimes()           --已经挑战的次数
--         self.leaveTimes = freeTime - challengeTimes
--         if self.leaveTimes > 0 then
--             self.arena_notice:setVisible(true)
--         else
--             self.arena_notice:setVisible(false)
--         end
--     end
-- end

--争霸红点
function PVHome:updatePvpArena()
    local arenaCheck = self:checkArena()
    local runeCheck = self:checkRune()
    local bossCheck = self:checkBoss()
    if arenaCheck or runeCheck or bossCheck then
        self.arena_notice:setVisible(true)
    else
        self.arena_notice:setVisible(false)
    end
    
end
--竞技场红点
function PVHome:checkArena()
    local arenaLevel = self.baseTemp:getArenaLevel()                        --竞技场等级限制
    local _level = getDataManager():getCommonData():getLevel()
    if _level >= arenaLevel then
        -- print("刷新竞技场红点")
        local freeTime = self.baseTemp:getArenaFreeTime()              --每日免费挑战次数
        local challengeTimes = self.commonData:getPvpTimes()           --已经挑战的次数
        self.leaveTimes = freeTime - challengeTimes
        if self.leaveTimes > 0 then
            -- self.arena_notice:setVisible(true)
            return true
        -- else
            -- self.arena_notice:setVisible(false)
        end
    end
    return false
end
--符文秘境红点
function PVHome:checkRune()
    local runeLevel = self.baseTemp:getRuneLevel()                         --密境等级
    local _level = getDataManager():getCommonData():getLevel()
    if _level >= runeLevel then
       local detailInfo = getDataManager():getMineData()
        -- print("detailInfo:getNormalNum(0)="..detailInfo:getNormalNum(0))
        if detailInfo:isHaveHavest() then
            return true
        end
    end
    return false
end
--世界boss红点
function PVHome:checkBoss()
    local bossLevel = self.baseTemp:openWorldBossLevel()                   --世界boss开启等级限制
    local _level = getDataManager():getCommonData():getLevel()
    if _level >= bossLevel then
        if getDataManager():getBossData():getIsStart() then
            return true
        end
    end
    return false
end

--阵容红点
function PVHome:updateLineUpNotice()
    local _isEmpty = false
    for i = 1,6 do
        local _IsOpenBySeat = self.c_LineUpData:getSelectIsOpenBySeat(i)
        if _IsOpenBySeat then
            local _Seat = self.c_LineUpData:getSlotItemBySeat(i)
            if _Seat.hero.hero_no == 0 or _Seat.hero.hero_no == nil then
                _isEmpty = true
            end
        end
    end
    local _changeSoldierList = self.c_LineUpData:getChangeSoldier()
    if #_changeSoldierList >= 1 and _isEmpty then
        self.lineup_notice:setVisible(true)
    else
        self.lineup_notice:setVisible(false)
    end
end

function PVHome:subChNoticeState(noticeId, state)
    print("红点操作 =============== ", noticeId,        state)
    if noticeId == INSTANCE_NOTICE then
        self.fight_notice:setVisible(state)
    elseif noticeId == ARENA_NOTICE then
        print("竞技场红点更新显示 ------------------ ",self.arena_notice)
        -- self:updatePvpArena()
    end
end

-- function PVHome:removeScheduler1()
--     if self.scheduer1 ~= nil then
--         timer.unscheduleGlobal(self.scheduer1)
--         self.scheduer1 = nil
--     end
-- end

-- function PVHome:removeScheduler2()
--     if self.scheduer2 ~= nil then
--         timer.unscheduleGlobal(self.scheduer2)
--         self.scheduer2 = nil
--     end
-- end



return PVHome
