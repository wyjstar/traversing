local PVTimeBossWait = class("PVTimeBossWait", BaseUIView)

function PVTimeBossWait:ctor(id)
    self.super.ctor(self, id)

end

function PVTimeBossWait:onMVCEnter()
    --加载相关plist文件
    game.addSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")
    self:registerDataBack()

    self.c_commonData = getDataManager():getCommonData()
    self.c_bossData = getDataManager():getBossData()
    self.c_bossNet = getNetManager():getBossNet()
    self.c_stageTemp = getTemplateManager():getInstanceTemplate()
    self.c_baseTemplate = getTemplateManager():getBaseTemplate()

    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()

    self:initData()
    self:initView()

end

--网络返回
function PVTimeBossWait:registerDataBack()
end

--相关数据初始化
function PVTimeBossWait:initData()
    self.stageId = self.c_bossData:getCurSatgeId()                                         --当前的关卡id
    local roundId = self.c_stageTemp:getSpecialStageById(self.stageId).round1              --当前的怪物组id

    self.curMonsterId = self.c_SoldierTemplate:getMonsIdFromGroup(roundId)
    getDataManager():getResourceData():loadHeroImageDataById(self.curMonsterId)


    self.luckyHeros = self.c_bossData:getLuckyHeros()                               --幸运武将数据初始化
    print("幸运武将列表 --------------- ")
    table.print(self.luckyHeros)
    self.itemCount = table.getn(self.luckyHeros)

    self.rankList = self.c_bossData:getHurtRankList()                               --击杀前十名
    self.shotItem = self.c_bossData:getLastShotList()                               --最后击杀列表

    local stageId = self.c_bossData:getCurSatgeId()                                 --当前的关卡id

    local rewardTextId = self.c_baseTemplate:getBossRewardText()                    --奖励介绍
    self.rewardText = self.c_LanguageTemplate:getLanguageById(rewardTextId)
    local textTable = string.split(self.rewardText, '\\n')

    -- self.reward1 = string.split(textTable[1], '$')
    -- self.reward2 = string.split(textTable[2], '$')

    -- local lucky1 = self.c_baseTemplate:getLuckHero1()
    -- self.lucky_1 = "+" .. (lucky1 - 1) * 100 .. " %"
    -- local lucky2 = self.c_baseTemplate:getLuckHero2()
    -- self.lucky_2 = "+" .. (lucky2 - 1) * 100 .. " %"
    -- local lucky3 = self.c_baseTemplate:getLuckHero3()
    -- self.lucky_3 = "+" .. (lucky3 - 1) * 100 .. " %"

    local activity_time = self.c_stageTemp:getSpecialStageById(stageId).timeControl
    local index = string.find(activity_time, "-")

    local start_time = string.sub(activity_time, 1, index - 1)
    local end_time = string.sub(activity_time, index + 1, 11)

    local curYear = self.c_commonData:getYear()
    local curMonth = self.c_commonData:getMonth()
    local curDay = self.c_commonData:getDay()
    local curHour = self.c_commonData:getCurrHour()
    local curMin = self.c_commonData:getCurrMin()
    local curSec = self.c_commonData:getCurSec()
    --当前时间
    local nowTime = os.time({year = curYear, month = curMonth, day = curDay, hour = curHour, min = curMin, sec = curSec})

    --开始时间
    local startIndex = string.find(start_time, ":")
    local start_hour = string.sub(start_time, 1, startIndex - 1)
    local start_min = string.sub(start_time, startIndex + 1, 5)
    local curTime1 = {year = curYear, month = curMonth, day = curDay, hour = start_hour, min = start_min, sec = 0}
    local startTime = os.time(curTime1)

    --结束时间
    local endIndex = string.find(end_time, ":")
    local end_hour = string.sub(end_time, 1, endIndex - 1)
    local end_min = string.sub(end_time, endIndex + 1, 5)
    local curTime2 = {year = curYear, month = curMonth, day = curDay, hour = end_hour, min = end_min, sec = 0}
    local endTime = os.time(curTime2)

    --12:00 - 12:30     20:00 - 20:30

    --距离开始时间间隔

    local curSubTime = startTime - nowTime
    local addTime = 24 * 60 * 60

    if curSubTime < 0 then
        local curStartTime = startTime + addTime
        self.subTime = curStartTime - nowTime
    else
        self.subTime = startTime - nowTime
    end
end

--倒计时更新显示
function PVTimeBossWait:updateData()
    -- local function updateTimer1(dt)
    --     self.subTime = self.subTime - 1
    --     if self.subTime < 0 then
    --         timer.unscheduleGlobal(self.scheduer1)
    --         self.scheduer1 = nil
    --         self:onHideView()
    --         getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTimeWorldBoss")
    --     else
    --         -- 倒计时 剩余时间
    --         self.timeLabel:setString( string.format("%02d:%02d:%02d",math.floor(self.subTime/3600),math.floor(self.subTime%3600/60),self.subTime%60) )
    --     end
    -- end

    if self.subTime > 0 then
        self.scheduer1 = timer.scheduleGlobal(function(dt)
            self.subTime = self.subTime - 1
            if self.subTime < 0 then
                timer.unscheduleGlobal(self.scheduer1)
                self.scheduer1 = nil
                self:onHideView()
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTimeWorldBoss")
            else
                -- 倒计时 剩余时间
                self.timeLabel:setString( string.format("%02d:%02d:%02d",math.floor(self.subTime/3600),math.floor(self.subTime%3600/60),self.subTime%60) )
            end
        end, 1.0)
    else
        if self.scheduer1 ~= nil then
            timer.unscheduleGlobal(self.scheduer1)
            self.scheduer1 = nil
        end
    end
end

--界面加载以及初始化
function PVTimeBossWait:initView()
    self.UIBossWaitView = {}
    self:initTouchListener()
    self:loadCCBI("boss/ui_boss_view2.ccbi", self.UIBossWaitView)

    self.contentLayer1 = self.UIBossWaitView["UIBossWaitView"]["contentLayer1"]                                     --幸运武将层
    self.contentlayer2 = self.UIBossWaitView["UIBossWaitView"]["contentlayer2"]                                 --上轮击杀层
    self.contentLayer3 = self.UIBossWaitView["UIBossWaitView"]["contentlayer3"]                                 --奖励介绍
    self.rankLayer = self.UIBossWaitView["UIBossWaitView"]["rankLayer"]
    self.firstName = self.UIBossWaitView["UIBossWaitView"]["firstName"]
    self.secondName = self.UIBossWaitView["UIBossWaitView"]["secondName"]
    self.thirdName = self.UIBossWaitView["UIBossWaitView"]["thirdName"]
    self.hurtFirst = self.UIBossWaitView["UIBossWaitView"]["hurtFirst"]                         --伤害第一
    self.killFirst = self.UIBossWaitView["UIBossWaitView"]["killFirst"]                         --最后击杀
    self.firstLabel = self.UIBossWaitView["UIBossWaitView"]["firstLabel"]
    self.sendLabel = self.UIBossWaitView["UIBossWaitView"]["sendLabel"]
    self.thirdLabel = self.UIBossWaitView["UIBossWaitView"]["thirdLabel"]
    self.introLayer = self.UIBossWaitView["UIBossWaitView"]["introLayer"]
    self.bossSprite = self.UIBossWaitView["UIBossWaitView"]["spDongzhuo"]
    self.myRank = self.UIBossWaitView["UIBossWaitView"]["myRank"]                               --我的战绩
    self.activityTimeSprite = self.UIBossWaitView["UIBossWaitView"]["activityTimeSprite"]

    self.timeLabel = self.UIBossWaitView["UIBossWaitView"]["timeLabel"]

    self.bossSprite:removeAllChildren()
    local bossImageNode = self.c_SoldierTemplate:getWorldBossImage(self.curMonsterId)
    self.bossSprite:addChild(bossImageNode)

    self.timeLabel:setString( string.format("%02d:%02d:%02d",math.floor(self.subTime/3600),math.floor(self.subTime%3600/60),self.subTime%60) )

    self:updateData()

    self:initTable()
    self.hurtFirst:setString("")
    
    if self.c_bossData:getRankNo()>0 then
        self.myRank:setString(string.format(Localize.query("boss.2"),string.format("%d",self.c_bossData:getRankNo())))
    else
        self.myRank:setString(Localize.query("boss.3"))
    end
    -- self.rankLayer:setVisible(false)
    if table.getn(self.rankList) > 0 then
        -- self.rankLayer:setVisible(true)
        if self.rankList[1] ~= nil then
            -- self.firstLabel:setVisible(true)
            self.hurtFirst:setString(self.rankList[1].nickname)
        end
    else
        -- self.rankLayer:setVisible(false)
    end

    if self.shotItem ~= nil then
        self.killFirst:setString(self.shotItem.nickname)
    end

    --上一轮击杀显示初始化
    -- if table.getn(self.rankList) > 0 then
    --     self.rankLayer:setVisible(true)
    --     if self.rankList[1] ~= nil then
    --         -- self.firstLabel:setVisible(true)
    --         self.firstName:setString(self.rankList[1].nickname)
    --     end

    --     -- if self.rankList[2] ~= nil then
    --     --     self.sendLabel:setVisible(true)
    --     --     self.secondName:setString(self.rankList[2].nickname)
    --     -- else
    --     --     self.sendLabel:setVisible(false)
    --     -- end

    --     -- if self.rankList[3] ~= nil then
    --     --     self.thirdLabel:setVisible(true)
    --     --     self.thirdName:setString(self.rankList[3].nickname)
    --     -- else
    --     --     self.thirdLabel:setVisible(false)
    --     -- end
    -- else
    --     self.rankLayer:setVisible(false)
    -- end

    -- self.introLayer:setVisible(true)

end

--界面监听事件
function PVTimeBossWait:initTouchListener()
    --返回
    local function backMenuClick()
        getAudioManager():playEffectButton2()
        cclog("backMenuClick")
        self:removeScheduler1()
        self:onHideView()
    end
    --排行榜
    local function onRankClick()
        getAudioManager():playEffectButton2()
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVBossRank")
    end

    --奖励列表
    local function onRewardClick()
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVBossReward")
    end

    self.UIBossWaitView["UIBossWaitView"] = {}

    self.UIBossWaitView["UIBossWaitView"]["backMenuClick"] = backMenuClick                          --关闭
    self.UIBossWaitView["UIBossWaitView"]["onRankClick"] = onRankClick                              --排行
    self.UIBossWaitView["UIBossWaitView"]["onRewardClick"] = onRewardClick                              --排行
end

function PVTimeBossWait:initTable()
    local layerSize = self.contentLayer1:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    -- self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()

    self.contentLayer1:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer1:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVTimeBossWait:tableCellTouched(table, cell)
    local idx = cell:getIdx()
    local heroId = self.luckyHeros[idx + 1].hero_no
    getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", heroId, 2, nil, 1)
end

function PVTimeBossWait:cellSizeForTable(table, idx)
    return 150, 100
end

function PVTimeBossWait:tableCellAtIndex(tabl, idx)
    local curCell = nil
    if nil == curCell then
        curCell = cc.TableViewCell:new()

        curCell.UIBossLuckyItem = {}
        curCell.UIBossLuckyItem["UIBossLuckyItem"] = {}

        local proxy = cc.CCBProxy:create()
        local node = CCBReaderLoad("boss/ui_boss_luckItem.ccbi", proxy, curCell.UIBossLuckyItem)

        curCell.soldierName = curCell.UIBossLuckyItem["UIBossLuckyItem"]["soldierName"]                     --英雄头像
        curCell.soldierIcon = curCell.UIBossLuckyItem["UIBossLuckyItem"]["soldierIcon"]
        curCell.attributes = {}
        curCell.attribute1 = curCell.UIBossLuckyItem["UIBossLuckyItem"]["attribute1"]
        curCell.attribute2 = curCell.UIBossLuckyItem["UIBossLuckyItem"]["attribute2"]

        curCell.attributes[1] = curCell.attribute1
        curCell.attributes[2] = curCell.attribute2

        for k,v in pairs(curCell.attributes) do
            curCell.attributes[k]:setVisible(false)
        end

        curCell.index = idx

        curCell:addChild(node)
    end
    if table.getn(self.luckyHeros) > 0 then
        --旧版本
        -- if idx == 0 then
        --     curCell.attack_A:setString(self.lucky_1)
        -- elseif idx == 1 then
        --     curCell.attack_A:setString(self.lucky_2)
        -- elseif idx == 2 then
        --     curCell.attack_A:setString(self.lucky_3)
        -- end
        -- print("self.luckyHeros[curCell.index + 1] ====================== ", curCell.index + 1)
        -- table.print(self.luckyHeros[curCell.index + 1])
        -- self:initMemberData(curCell.contentlayer, self.luckyHeros[curCell.index + 1])

        --新版本
        local luckyId = self.luckyHeros[idx + 1].pos
        local heroId = self.luckyHeros[idx + 1].hero_no
        print("heroId ============ ", heroId)
        local attrTab = self.luckyHeros[idx + 1].attr
        local attrNum = table.getn(attrTab)
        local index = 1

        for i = 1, attrNum do
            curCell.attributes[i]:setVisible(true)
        end

        for k, v in pairs(attrTab) do
            local typeStr = getTemplateManager():getStoneTemplate():getAttriStrByType(v.attr_type)
            local attrValue = math.floor(v.attr_value * 100)
            curCell.attributes[index]:setString(typeStr .. "+" .. attrValue .. "%")
            index = index + 1
        end

        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(heroId)
        local soldierName = self.c_SoldierTemplate:getHeroName(heroId)
        local quality = soldierTemplateItem.quality
        -- local resIcon = self.c_SoldierTemplate:getSoldierIcon(heroId)
        -- print("[q]resIcon:"..resIcon)
        -- changeNewIconImage(curCell.soldierIcon, resIcon, quality) --更新icon
        local heroImg = self:getClipperNode(heroId,quality)
        heroImg:setPosition(62,122)
        curCell.soldierIcon:addChild(heroImg)
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(quality)
        curCell.soldierName:setColor(color)
        curCell.soldierName:setString(soldierName)

    end

    return curCell
end

--无双添加遮罩
function PVTimeBossWait:getClipperNode(heroId,quality)

    local res = ""

    if quality == 1 or quality == 2 then
        res =  "#ui_common_g_frame.png"
    elseif quality == 3 or quality == 4 then
        res = "#ui_common_b_frame.png"
    elseif quality == 5 or quality == 6 then
        res = "#ui_common_p_frame.png"
    end

    local stencil = game.newSprite("#ui_boss_heroFrame.png")        --遮罩层
    local clipper = cc.ClippingNode:create()

    clipper:setAnchorPoint(cc.p(0.5, 0.5))
    clipper:setAlphaThreshold(0)
    clipper:setStencil(stencil)
    clipper:addChild(stencil)


    local node = self.c_SoldierTemplate:getHeroBigImageById(heroId)
    node:setScale(0.8)
    node:setPosition(0, -25)
    clipper:addChild(node)
    clipper:setPosition(62,125)
    local bgSprite = game.newSprite(res)
    bgSprite:addChild(clipper)
    return bgSprite
end 

function PVTimeBossWait:numberOfCellsInTableView(table)
    return self.itemCount
end

--幸运武将的头像列表
function PVTimeBossWait:initMemberData(itemLayer, meberItemList)
    local memberItemCount = table.getn(meberItemList)

    function tableCellTouched(table, cell)
        local index = cell:getIdx()
        local hero_id = meberItemList[index + 1]
        local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(hero_id)
        print("幸运武将的头像列表 =============== ", hero_id)
        -- table.print(soldierTemplateItem)
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", hero_id, 2, nil, 1)
    end

    function cellSizeForTable(table, idx)
        return 85, 85
    end

    function tableCellAtIndex(tabl, idx)
        print("idx ====================== ", idx)
        local curCell = tabl:dequeueCell()
        if nil == curCell then
            curCell = cc.TableViewCell:new()

            curCell.UIArenaMemberItem = {}
            curCell.UIArenaMemberItem["UIArenaMemberItem"] = {}

            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("arena/ui_arena_small_item.ccbi", proxy, curCell.UIArenaMemberItem)

            curCell.itemSprite = curCell.UIArenaMemberItem["UIArenaMemberItem"]["itemSprite"]                     --英雄头像
            self.sizeLayer = curCell.UIArenaMemberItem["UIArenaMemberItem"]["sizeLayer"]
            curCell:addChild(node)
        end
        if table.getn(meberItemList) > 0 then
            local hero_id = meberItemList[idx + 1]
            local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(hero_id)
            local quality = soldierTemplateItem.quality
            local resIcon = self.c_SoldierTemplate:getSoldierIcon(hero_id)
            changeNewIconImage(curCell.itemSprite, resIcon, quality) --更新icon
        end

        return curCell
    end

    function numberOfCellsInTableView(tabl)
        self.isTouchMember = false
        return memberItemCount
    end

    local layerSize = itemLayer:getContentSize()
    self.memberTableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    self.memberTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.memberTableView:setPosition(cc.p(0, 0))
    self.memberTableView:setDelegate()
    itemLayer:addChild(self.memberTableView)

    self.memberTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.memberTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.memberTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.memberTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.memberTableView:reloadData()
end

function PVTimeBossWait:removeScheduler1()
    if self.scheduer1 ~= nil then
        timer.unscheduleGlobal(self.scheduer1)
        self.scheduer1 = nil
    end
end

function PVTimeBossWait:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")
end

return PVTimeBossWait
