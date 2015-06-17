
local PVBossRewardPanel = import("src.app.ui.homepage.arena.PVBossRewardPanel")

-- local PVScrollBar = import("..scrollbar.PVScrollBar")
local PVArenaWarPanel = class("PVArenaWarPanel", BaseUIView)

function PVArenaWarPanel:ctor(id)
    self.super.ctor(self, id)

end

function PVArenaWarPanel:onMVCEnter()
    --加载相关plist文件
    game.addSpriteFramesWithFile("res/ccb/resource/ui_arena.plist")
    self:registerDataBack()

    self.c_bossData = getDataManager():getBossData()
    self.c_commonData = getDataManager():getCommonData()

    self.c_bossNet = getNetManager():getBossNet()

    self.c_stageTemp = getTemplateManager():getInstanceTemplate()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.stageData = getDataManager():getStageData()

    self:initData()
    self:initView()

    --  local function onNodeEvent(event)
    --     if "exit" == event then
    --         if self.onExit ~= nil then
    --             self:onExit()
    --         end
    --     end
    -- end

    -- self:registerScriptHandler(onNodeEvent)


    local function update_BossNotice()
        self:updateBossNoticeData()
    end

    self.listener = cc.EventListenerCustom:create(UPDATE_BOSS_NOTICE, update_BossNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

    local function update_pvpNotice()
        -- self:updatePVPNoticeData()
    end

    self.listener2 = cc.EventListenerCustom:create(UPDATE_PVP_NOTICE, update_pvpNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener2, 1)

     local function update_mineNotice()
        -- self:updateMineNoticeData()
        if self.tableView ~= nil then
            self.tableView:reloadData()
        end
    end

    self.listener3 = cc.EventListenerCustom:create(UPDATE_MINE_NOTICE, update_mineNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener3, 1)

end

function PVArenaWarPanel:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()

    self:getEventDispatcher():removeEventListener(self.listener)
    self:getEventDispatcher():removeEventListener(self.listener2)
    self:getEventDispatcher():removeEventListener(self.listener3)

end

--网络返回
function PVArenaWarPanel:registerDataBack()
    --世界boss相关内容返回
    local function bossInfoCallBack(id ,data)
        if id == BOSS_INFO then
            local isOpen = self.c_bossData:getIsOpen()                  --世界boss活动是否已经开始
            self.c_bossData:setBossIsDead(isOpen)
            self.hpLeft = data.hp_left                                --世界boss剩余血量
            self:updateData(isOpen)
        elseif id == BOSS_DEAD then
            local isDead = data.open_or_not
            self.c_bossData:setBossIsDead(isDead)
            if isDead == false then
                -- self:onHideView()
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVBossRank")
            else
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTimeWorldBoss")
            end
            -- self:updateData(isOpen)
        end
    end

    local function getRewardInfoCallBack(id,data)
        print("[QPrint:]=====")
        table.print(data)
        if not data.is_over then

            function headCallFunc( ... )
                self:getEventDispatcher():removeEventListener(self.listener)
                self.c_bossNet:sendPvbAward()
            end

            self.listener = cc.EventListenerCustom:create("NextReward", headCallFunc)
            self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

            getDataProcessor():gainGameResourcesResponse(data.gain) --处理获得的物品
            PVBossRewardPanel.new()

            local view = PVBossRewardPanel.new("PVBossRewardPanel")
            view:onMVCEnter()
            getPlayerScene():addPlayerViewLastShow(view)
        end
    end

    self:registerMsg(BOSS_INFO, bossInfoCallBack)
    self:registerMsg(BOSS_DEAD, bossInfoCallBack)
    self:registerMsg(BOSS_REWARD_GET,getRewardInfoCallBack)
end

--相关数据初始化
function PVArenaWarPanel:initData()
    --图片
    local spriteIcon = {}

    spriteIcon[1] = "ui_arena_item1.png"                                    --竞技场图片

    spriteIcon[2] = "ui_secret_into.png"                                    --密境图片

    spriteIcon[3] = "ui_arena_boss_bg.png"                                  --世界boss图片

    --文字描述图片
    local wordIcon = {}

    wordIcon[1] = "ui_arena_leitai.png"                                    --竞技场图片

    wordIcon[2] = "ui_secret_fuwenmij.png"                                 --密境图片

    wordIcon[3] = "ui_arena_boss_word.png"                                 --世界boss图片

    --等级限制
    self.levels = {}

    self.levels[1] = self.c_BaseTemplate:getArenaLevel()                        --竞技场等级限制

    self.levels[2] = self.c_BaseTemplate:getRuneLevel()                         --密境boss等级

    self.levels[3] = self.c_BaseTemplate:openWorldBossLevel()                   --世界boss开启等级限制

    -- 关卡限制
    self.stageLimit = {}
    local stageIds = {}
    -- local _stageId = self.c_BaseTemplate:getArenaOpenStage()
    stageIds[1] = self.c_BaseTemplate:getArenaOpenStage()
    self.stageLimit[1] = self.stageData:getIsOpenByStageId(stageIds[1])                        --竞技场限制
    -- _stageId = self.c_BaseTemplate:getWarFogOpenStage()
    stageIds[2] = self.c_BaseTemplate:getWarFogOpenStage()
    self.stageLimit[2] = self.stageData:getIsOpenByStageId(stageIds[2])                         --密境boss
    stageIds[3] = self.c_BaseTemplate:getWorldBossOpenStage()
    -- _stageId = self.c_BaseTemplate:getWorldBossOpenStage()
    self.stageLimit[3] = self.stageData:getIsOpenByStageId(stageIds[3])                  --世界boss开启限制

    self.warList = {}
    for i = 1, 3 do
        local warItem = {}
        warItem.typeValue = i
        warItem.level = self.levels[i]
        warItem.spriteBg = spriteIcon[i]
        warItem.wordSprite = wordIcon[i]
        warItem.stageId = stageIds[i]
        table.insert(self.warList, warItem)
    end
    self.itemCount = table.getn(self.warList)


    --玩家当前的等级
    self.playerLevel = self.c_commonData:getLevel()
end

--界面加载以及初始化
function PVArenaWarPanel:initView()
    self.UIArenaWarPanel = {}
    self:initTouchListener()
    self:loadCCBI("arena/ui_arena_war_panel.ccbi", self.UIArenaWarPanel)

    self.contentLayer = self.UIArenaWarPanel["UIArenaWarPanel"]["contentLayer"]

    -- self.levelLabel = {}

    -- self.levelLabel[1] = cc.LabelAtlas:_create(string.format("%d", self.levels[1]), "res/ui/ui_arena_number.png", 17, 25, string.byte("0"))
    -- self.levelLabel[2] = cc.LabelAtlas:_create(string.format("%d", self.levels[2]), "res/ui/ui_arena_number.png", 17, 25, string.byte("0"))
    -- self.levelLabel[3] = cc.LabelAtlas:_create(string.format("%d", self.levels[3]), "res/ui/ui_arena_number.png", 17, 25, string.byte("0"))

    self:initTable()
end

--界面监听事件
function PVArenaWarPanel:initTouchListener()
     --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        cclog("onCloseClick")
        self:removeScheduler1()
        self:onHideView()
    end

    self.UIArenaWarPanel["UIArenaWarPanel"] = {}

    self.UIArenaWarPanel["UIArenaWarPanel"]["onCloseClick"] = onCloseClick                        --关闭
end

function PVArenaWarPanel:initTable()
    local layerSize = self.contentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()

    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVArenaWarPanel:openOtherView(index)
    local __refreshCurrent = function()
        timer.unscheduleGlobal(self._refreshCurrentView)
        self._refreshCurrentView = nil
        -- self:onHideView()

        if index == 1 then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaPanel")
        elseif index == 2 then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretPlacePanel")
        elseif index == 3 then

        end

    end

    self._refreshCurrentView = timer.scheduleGlobal(__refreshCurrent, 0.1)
end

function PVArenaWarPanel:tableCellTouched(table, cell)
    local index = cell:getIdx()
    local curType = self.warList[index + 1].typeValue
    local warLevel = self.warList[index + 1].level

    if curType == 1 then
        print("点击擂台")
        groupCallBack(GuideGroupKey.BTN_LEITAI)
        -- stepCallBack(G_GUIDE_110004)

        -- if self.playerLevel >= warLevel then  --self.playerLevel >= warLevel
        --     self:openOtherView(1)
        --     -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaPanel")
        -- else
        --     -- getOtherModule():showToastView(Localize.query(811))

        --     -- 功能等级开放提示
        --     self:removeChildByTag(1000)
        --     self:addChild(getLevelTips(warLevel), 0, 1000)
        -- end
        local _stageId = self.c_BaseTemplate:getArenaOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            self:openOtherView(1)
        else
            getStageTips(_stageId)
            return
        end

    elseif curType == 2 then
        print("点击符文秘境")
        -- if self.playerLevel >= warLevel then
        --     self:openOtherView(2)
        --     -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSecretPlacePanel")
        -- else
        --     -- getOtherModule():showToastView(Localize.query(811))

        --     -- 功能等级开放提示
        --     self:removeChildByTag(1000)
        --     self:addChild(getLevelTips(warLevel), 0, 1000)
        -- end
        local _stageId = self.c_BaseTemplate:getWarFogOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            self:openOtherView(2)
        else
            getStageTips(_stageId)
            return
        end
        groupCallBack(GuideGroupKey.BTN_MIJING)
    elseif curType == 3 then
        print("点击枭雄")
        -- if self.playerLevel >= warLevel then
        --     local data = { boss_id = "world_boss" }
        --     self.c_bossNet:sendGetBossInfo(data)
        -- else
        --     -- getOtherModule():showToastView(Localize.query(811))

        --     -- 功能等级开放提示
        --     self:removeChildByTag(1000)
        --     self:addChild(getLevelTips(warLevel), 0, 1000)
        -- end
        local _stageId = self.c_BaseTemplate:getWorldBossOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        print(self.stageData)
        if _isOpen then
            local data = { boss_id = "world_boss" }
            self.c_bossNet:sendGetBossInfo(data)
        else
            getStageTips(_stageId)
            return
        end
        stepCallBack(G_GUIDE_100004)
    end
end

function PVArenaWarPanel:updateData(isOpen)
    if g_toBoss == 1 then g_toBoss = 0 end
    --世界活动是否开启
    if isOpen then                                                            --boss未死亡
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTimeWorldBoss")
        g_toBoss = 1
    else
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTimeBossWait")
    end

    --TODO：获取是否有需要领取的奖励还没有发放   
    self.c_bossNet:sendPvbAward()
end

function PVArenaWarPanel:cellSizeForTable(table, idx)
    return 170, 550
end

function PVArenaWarPanel:tableCellAtIndex(tabl, idx)
    local cell = nil
    if nil == cell then
        cell = cc.TableViewCell:new()

        cell.UIArenaWarItem = {}
        cell.UIArenaWarItem["UIArenaWarItem"] = {}


        local proxy = cc.CCBProxy:create()
        local arenaWarItem = CCBReaderLoad("arena/ui_arena_war_item.ccbi", proxy, cell.UIArenaWarItem)

        cell.arenaItemSprite = cell.UIArenaWarItem["UIArenaWarItem"]["arenaItemSprite"]             --挑战按钮层
        cell.arenaItemWord = cell.UIArenaWarItem["UIArenaWarItem"]["arenaItemWord"]                 --排行按钮层
        cell.levelLayer = cell.UIArenaWarItem["UIArenaWarItem"]["levelLayer"]                       --等级layer
        cell.openLevelLayer = cell.UIArenaWarItem["UIArenaWarItem"]["openLevelLayer"]               --开启等级限制层
        cell.notice = cell.UIArenaWarItem["UIArenaWarItem"]["notice"]
        cell.openCondition = cell.UIArenaWarItem["UIArenaWarItem"]["openCondition"]                 --开启等级提示
        cell.notice:setVisible(false)
        cell:addChild(arenaWarItem)
        if idx == 1 then
            cell.notice:setPosition(cc.p(375,115))
        end

        local _label = cc.LabelAtlas:_create(string.format("%d", self.levels[idx + 1]), "res/ui/ui_arena_number.png", 17, 25, string.byte("0"))
        _label:setRotation(-25)
        _label:setAnchorPoint(cc.p(0.5, 0.5))
        cell.levelLayer:addChild(_label)
    end

    if table.nums(self.warList) > 0 then
        local warItem = self.warList[idx + 1]
        print("warItem.stageId ======== ")
        local _isOpen = self.stageLimit[idx+1]
        cell.arenaItemSprite:setSpriteFrame(warItem.spriteBg)
        cell.arenaItemWord:setSpriteFrame(warItem.wordSprite)

        local freeTime = self.c_BaseTemplate:getArenaFreeTime()              --每日免费挑战次数
        local challengeTimes = self.c_commonData:getPvpTimes()           --已经挑战的次数
        self.leaveTimes = freeTime - challengeTimes
        if  _isOpen then        --self.playerLevel >= warItem.level
            --竞技场红点显示控制
            if self.leaveTimes ~= nil and self.leaveTimes > 0 and idx == 0 then
                cell.notice:setVisible(true)
            end
            --世界boss红点控制
            if self.c_bossData:getIsStart() and idx == 2 then
                cell.notice:setVisible(true)
            end

            cell.arenaItemSprite:setColor(ui.COLOR_WHITE)
            cell.arenaItemWord:setColor(ui.COLOR_WHITE)
            cell.openLevelLayer:setVisible(false)
            cell.openCondition:setVisible(false)
        else
            cell.arenaItemSprite:setColor(ui.COLOR_DARK_GREY)
            cell.arenaItemWord:setColor(ui.COLOR_DARK_GREY)
            cell.openLevelLayer:setVisible(false)
            local tipStr = getStageTipStr(warItem.stageId)
            cell.openCondition:setVisible(true)
            cell.openCondition:setString(tipStr)
            -- getStageTipStr
        end

        -- 根据类型判断红点   符文秘境
        local curType = self.warList[idx + 1].typeValue
        local warLevel = self.warList[idx + 1].level
        if curType == 2 and self.playerLevel >= warLevel then
            local detailInfo = getDataManager():getMineData()
            -- print("detailInfo:getNormalNum(0)="..detailInfo:getNormalNum(0))
            if detailInfo:isHaveHavest() and _isOpen then
                cell.notice:setVisible(true)
            else
                cell.notice:setVisible(false)
            end
            --print("秘境 notice 查看 ", detailInfo:isHaveHavest())
        end
    end

    return cell
end

function PVArenaWarPanel:numberOfCellsInTableView(table)
    return self.itemCount
end

function PVArenaWarPanel:removeScheduler1()
    if self.scheduer1 ~= nil then
        timer.unscheduleGlobal(self.scheduer1)
        self.scheduer1 = nil
    end
end

function PVArenaWarPanel:onReloadView()
    self.tableView:reloadData()
end

function PVArenaWarPanel:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")
end

return PVArenaWarPanel
