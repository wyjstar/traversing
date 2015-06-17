--游历
--游历中
local PVTravelTraveling = class("PVTravelTraveling", BaseUIView)

function PVTravelTraveling:ctor(id)

    self.c_TravelData = getDataManager():getTravelData()
    self.travelNet = getNetManager():getTravelNet()
    self.c_CommonData = getDataManager():getCommonData()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.c_TravelTemplate = getTemplateManager():getTravelTemplate()

    self.super.ctor(self, id)
end

function PVTravelTraveling:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

    self.UITravelingView = {}

    self:initTouchListener()

    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_traveling.ccbi", self.UITravelingView)
    -- print("*************** 游历中 ***************")


    self.travelList = {}             --事件列表
    self.autoTravelNum = 0
    self._timeTravel = {}
    
    --协议
    self:initRegisterNetCallBack()

    self.tag = self:getTransferData()[1]
  
    self:initView()

    self:initData()
end

function PVTravelTraveling:onExit()
    self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

    if self.scheduerOutputTime ~= nil then
        timer.unscheduleGlobal(self.scheduerOutputTime)
        self.scheduerOutputTime = nil
    end
end


function PVTravelTraveling:initData()
    local _travelInit = self.c_TravelData:getTravelInitResponse()
    self.stageId = _travelInit.travel_item_chapter[self.tag].stage_id

    local viplevel = self.c_BaseTemplate:getVIPAutoTravelFastFinish()
    self.useVipLevel:setString("VIP".. tostring(viplevel) .."可使用")
    local _travelInit = self.c_TravelData:getTravelInitResponse()
    if self:getTransferData()[2] == nil then 
        --说明有自动游历
        local num = self.c_TravelData:getIsIntoTravelingNum(_travelInit.stage_travel, self.tag)
        local autoTravel = nil
        for k,v in pairs(_travelInit.stage_travel) do
            if v.stage_id == self.stageId then
                -- table.print(v.auto_travel)
                autoTravel = v.auto_travel
            end
        end

        local _travel = autoTravel[num].travel--_travelInit.stage_travel[self.tag].auto_travel[num].travel
       
        self.travelList = _travel
        self.autoTravelNum = table.nums(_travel)
        -- print("事件个数："..self.autoTravelNum) 

        self.startTime = autoTravel[num].start_time -- _travelInit.stage_travel[self.tag].auto_travel[num].start_time
        self.continuedTime = autoTravel[num].continued_time --_travelInit.stage_travel[self.tag].auto_travel[num].continued_time
        self.isTravelStype = self.c_TravelData:getIsIntoTraveling(_travelInit.stage_travel, self.tag)    -- 游历状态

        if self.isTravelStype == 1 then
            self.autoTravelNum = table.nums(_travel)+1
            self:setLeftTime(self.isTravelStype)
            self:startTimer()
        end

        self.timesLabel:setString(""..self.autoTravelNum.. "/" .. self.continuedTime/30*5 .."")

        self.tableView:reloadData()
        if self.autoTravelNum >= 3 then
            local _offSet = self.tableView:getContentOffset()
            self.tableView:setContentOffset(cc.p(_offSet.x, 0))
        end
       
        self:fastFinishOrAllGet()

        return 
    end

    self.price = self:getTransferData()[3] 

    self.isTravelStype = 1
    self:fastFinishOrAllGet()

    self.autoTravelNum = 1

    local curNumber = self:getTransferData()[2]   -- 持续时间
    local data = {
            stage_id = _travelInit.travel_item_chapter[self.tag].stage_id,
            ttime = curNumber
            }
    self.travelNet:sendAutoTravel(data)

    self.timesLabel:setString(""..self.autoTravelNum.. "/" .. curNumber/30*5 .."")
end

-- 设置倒计时时间
function PVTravelTraveling:setLeftTime(thisType)
    if thisType == 0 then cclog("没有自动游历，设置倒计时时间失败") return end
    if thisType == 1 then
        local finishTime = self.startTime + self.continuedTime * 60
        local _time = finishTime - self.c_CommonData:getTime()  -- 自动游历剩余时间
        self._leftTime = _time%(6*60)  -- 下一个事件推出的时间倒计时
        self._allTime = _time          -- 总的倒计时间                                    
        
        self.outPutTimeLabel:setString(string.format("%02d:%02d:%02d",math.floor(self._allTime/3600), math.floor(self._allTime%3600/60), self._allTime%60))
    else
        self._leftTime = 0
        self._allTime = 0
    end
end

function PVTravelTraveling:updateData()
    -- print("------------------------ 刷新界面 ---------------------------")

    if self.isTravelStype == 0 then 
        
        self.isAutoWancheng = true
        self.travelNet:sendGetTravelInitResponse()
        return 
    end
    if self.isTravelStype == 1 then self:setLeftTime(self.isTravelStype)  end
    if self.isTravelStype == 2 then 
        if self.scheduerOutputTime ~= nil then
            timer.unscheduleGlobal(self.scheduerOutputTime)
            self.scheduerOutputTime = nil
        end
    end
    if self.isTravelStype == 3 then self:tuichuUpdate() return end
    if self.isTravelStype == 4 then 
        self.isAutoWancheng = true
        self.travelNet:sendGetTravelInitResponse()
        return
    end
    
    self.tableView:reloadData()
    if self.autoTravelNum >= 3 then
        local _offSet = self.tableView:getContentOffset()
        self.tableView:setContentOffset(cc.p(_offSet.x, 0))
    end

    local curNumber = self:getTransferData()[2]   -- 持续时间
    if curNumber ~= nil then
        self.timesLabel:setString(""..self.autoTravelNum.. "/" .. curNumber/30*5 .."")
    end
    
    self:fastFinishOrAllGet()
    
end

function PVTravelTraveling:registerNetInitTravel()
    -- print("------------------------ 830 ---------------------------")
    if self.isAutoWancheng == true then
        if self.scheduerOutputTime ~= nil then
            timer.unscheduleGlobal(self.scheduerOutputTime)
            self.scheduerOutputTime = nil
        end
        tag = self.tag
        self:onHideView()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelPlace", tag)
        tag = nil
        return
    end

    local _travelInit = self.c_TravelData:getTravelInitResponse()
    self.isTravelStype = self.c_TravelData:getIsIntoTraveling(_travelInit.stage_travel, self.tag)
    if self.isTravelStype == 0 then print("全部领取成功") return end 

    -- if self.isTravelStype == 0 then  return end 
 
    if self.isTravelStype == 1 then 
        local num = self.c_TravelData:getIsIntoTravelingNum(_travelInit.stage_travel, self.tag)

        local autoTravel = nil
        for k,v in pairs(_travelInit.stage_travel) do
            if v.stage_id == self.stageId then
                -- table.print(v.auto_travel)
                autoTravel = v.auto_travel
                -- local _travel = v.auto_travel[num].travel
            end
        end

        local _travel = autoTravel[num].travel --_travelInit.stage_travel[self.tag].auto_travel[num].travel
        self.travelList = _travel
        self.autoTravelNum = table.nums(self.travelList)+1
    end
    --完成了游历事件，有没有领取的奖励
    if self.isTravelStype == 2 then
        local num = self.c_TravelData:getIsIntoTravelingNum(_travelInit.stage_travel, self.tag)
        local autoTravel = nil
        for k,v in pairs(_travelInit.stage_travel) do
            if v.stage_id == self.stageId then
                -- table.print(v.auto_travel)
                autoTravel = v.auto_travel
                -- local _travel = v.auto_travel[num].travel
            end
        end
        local _travel = autoTravel[num].travel --_travelInit.stage_travel[self.tag].auto_travel[num].travel
        self.travelList = _travel
        self.autoTravelNum = table.nums(self.travelList)

    end
   
    self:updateData()
end

function PVTravelTraveling:registerNetGet()
    -- print("************************** 838 *********************************")
   
    local autoTravel = self.c_TravelData:getSettleAutoResponse()
    if not self:handelCommonResResult(autoTravel.res) then
        return
    end

    local stageTravel = autoTravel.stage_travel
    self.isTravelStype = self.c_TravelData:getIsIntoTraveling(stageTravel, self.tag)
    local num = self.c_TravelData:getIsIntoTravelingNum(stageTravel, self.tag)

    local autoTravel = nil
    for k,v in pairs(stageTravel) do
        if v.stage_id == self.stageId then
            -- table.print(v.auto_travel)
            autoTravel = v.auto_travel
            -- local _travel = v.auto_travel[num].travel
        end
    end

    if self.isTravelStype == 1 then 
        

        local _travel = autoTravel[num].travel   --autoTravel.stage_travel[self.tag].auto_travel[num].travel
        self.travelList = _travel
        self.autoTravelNum = table.nums(self.travelList)+1
    end
    --完成了游历事件，有没有领取的奖励
    if self.isTravelStype == 2 then
        local _travel = autoTravel[num].travel  --autoTravel.stage_travel[self.tag].auto_travel[num].travel
        self.travelList = _travel
        self.autoTravelNum = table.nums(self.travelList)
    end
    --------------
    if self.lingquType == 1 then 
        --立即领取，花费元宝
        cclog("self._meetPrice=%d", self.lingquPrice)
        self.c_CommonData:subGold(tonumber(self.lingquPrice))
    end
    if self.lingquType == 1 or self.lingquType == 2 then
        self:updateAward()
        if self.isTravelStype ~= 0 then 
            _drops = self.lingquDrops[1]
            getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops)
            _drops = nil
        end
    end
    if self.lingquType == 3 then    -- 全部领取
        -- self.c_CommonData.updateCombatPower()
         
        if self.travelList then
            local dropList = {}
            -- print("----- 1 ------")
            for k,v in pairs(self.travelList) do
                -- print("----- 2 ------")
                local eventNumber = v.event_id-- % 100000
                local eventState = v.state
                local eventType = self.c_TravelTemplate:getEventTypeByEventID(eventNumber)
                if eventType == 1 or eventState == 1 then
                else
                    -- print("----- 3 ------")
                    self.GameResourcesdrops = v.drops
                    self.lingquDrops = getDataProcessor():getGameResourcesResponse(self.GameResourcesdrops)
                    self:updateAward()
                    table.insert(dropList, self.lingquDrops[1] )
                end
            end
            local num = table.nums(dropList)
            -- if num == 1 then
            --     local _drops = dropList[1]
            --     getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops)    -- 0 单个风物志
            if num >= 1 then
                getOtherModule():showOtherView("PVTravelCongratulations", 1, dropList)  -- 1 多个风物志
                return
            else
                print("没有奖励")
            end
            
        end
    end
    -------------
    self:updateData()
end

-- 更新奖励
function PVTravelTraveling:updateAward()
    print("----------更新奖励-----------")

    if self.lingquDrops and self.lingquDrops[1].type == "travel_item" then
        local _travelInit = self.c_TravelData:getTravelInitResponse()
        local a = _travelInit.travel_item_chapter[self.tag].stage_id

        self.c_TravelData:addTravelItem(a, self.lingquDrops[1])
    end
    -- 如果是其他奖励加入
    if self.GameResourcesdrops then
        getDataProcessor():gainGameResourcesResponse(self.GameResourcesdrops)
    end

end

function PVTravelTraveling:fastFinishAuto(  )
    -- print("------------------------ 839 ---------------------------")

    local _travelInit = self.c_TravelData:getTravelInitResponse()
    local a = _travelInit.travel_item_chapter[self.tag].stage_id
    -- print(a)

    local _fastFinish = self.c_TravelData:getFastFinishAutoResponse()
    if not self:handelCommonResResult(_fastFinish.res) then
        return
    end

    local stageTravel = _fastFinish.stage_travel
    self.isTravelStype = self.c_TravelData:getIsIntoTraveling(stageTravel, self.tag)
    local num = self.c_TravelData:getIsIntoTravelingNum(stageTravel, self.tag)
    if self.isTravelStype == 1 then 
        for k,v in pairs(_fastFinish.stage_travel) do
            if v.stage_id == a then
                -- table.print(v.auto_travel)
                local _travel = v.auto_travel[num].travel
            end
        end

        self.travelList = _travel
        self.autoTravelNum = table.nums(self.travelList)+1
    end
    --完成了游历事件，有没有领取的奖励
    if self.isTravelStype == 2 then
        
        local _travel = nil
        for k,v in pairs(_fastFinish.stage_travel) do
            if v.stage_id == a then
                _travel = v.auto_travel[num].travel
            end
        end
        self.travelList = _travel
        self.autoTravelNum = table.nums(_travel)
    end
    
    self:updateData()

end

function PVTravelTraveling:initRegisterNetCallBack()
    
    function onReciveMsgCallBack1(_id)
        --837
        if _id == NET_ID_TRAVEL_AUTOTRAVEL then 
            local autoTravelResponse = self.c_TravelData:getAutoTravelResponse()

            local _travelInit = self.c_TravelData:getTravelInitResponse()
            local a = _travelInit.travel_item_chapter[self.tag].stage_id
            
            for k,v in pairs(autoTravelResponse.stage_travel) do
                if v.stage_id == a then
                    -- table.print(v.auto_travel)
                end
            end
            
            if not self:handelCommonResResult(autoTravelResponse.res) then
                return
            end
            
            local allGold = self.c_CommonData:getGold()
            if self.price <= allGold then
                self.c_CommonData:subGold(tonumber(self.price))
            else
                getOtherModule():showAlertDialog(nil, Localize.query("activity.5"))
            end

            local stageTravel = autoTravelResponse.stage_travel
            self.isTravelStype = self.c_TravelData:getIsIntoTraveling(stageTravel, self.tag)
            local num = self.c_TravelData:getIsIntoTravelingNum(stageTravel, self.tag)

            local autoTravel = {}
            for k,v in pairs(autoTravelResponse.stage_travel) do
                if v.stage_id == a then
                    autoTravel = v.auto_travel
                end
            end

            self.startTime = autoTravel[num].start_time--autoTravelResponse.stage_travel[self.tag].auto_travel[num].start_time

            self.continuedTime = autoTravel[num].continued_time--autoTravelResponse.stage_travel[self.tag].auto_travel[num].continued_time

            self._leftTime = 6*60
            self._allTime = self.continuedTime
            self:startTimer()

            self:fastFinishOrAllGet()
            self:updateData()
        end
    end
    function onReciveMsgCallBack2(_id)
        if _id == NET_ID_TRAVEL_INIT then  self:registerNetInitTravel()  end     --830
    end
    function onReciveMsgCallBack3(_id)
        if _id == NET_ID_TRAVEL_SETTLEAUTO then   self:registerNetGet()   end     --领取奖励协议    838
    end
    function onReciveMsgCallBack4(_id)
        if _id == NET_ID_TRAVEL_FASTFINISH then  self:fastFinishAuto()   end     --立即完成协议    839
    end

    self:registerMsg(NET_ID_TRAVEL_AUTOTRAVEL, onReciveMsgCallBack1)
    self:registerMsg(NET_ID_TRAVEL_INIT, onReciveMsgCallBack2)
    self:registerMsg(NET_ID_TRAVEL_SETTLEAUTO, onReciveMsgCallBack3)
    self:registerMsg(NET_ID_TRAVEL_FASTFINISH, onReciveMsgCallBack4)
end


function PVTravelTraveling:initView()
    self.travelContentLayer = self.UITravelingView["UITravelingView"]["travelContentLayer"]
    self.travelingAllGetLayer = self.UITravelingView["UITravelingView"]["travelingAllGetLayer"]                --全部领取
    self.travelingAtOnceAccLayer = self.UITravelingView["UITravelingView"]["travelingAtOnceAccLayer"]          --立即完成
    self.outPutTimeLabel = self.UITravelingView["UITravelingView"]["outPutTimeLabel"]
    self.timesLabel = self.UITravelingView["UITravelingView"]["timesLabel"]
    self.useVipLevel = self.UITravelingView["UITravelingView"]["useVipLevel"] 
    
    self:fastFinishOrAllGet()
    

    local layerSize = self.travelContentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.travelContentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)
    
   local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.travelContentLayer:addChild(scrBar,2)

end
function PVTravelTraveling:fastFinishOrAllGet()
    --判断如果游历还没有完成则显示立即完成self.travelingAtOnceAccLayer
    --游历完成后显示全部领取self.travelingAllGetLayer
    -- self.isTraveling = self.c_TravelData:getIsIntoTraveling(self.tag) 
    if self.isTravelStype == 1 then 
        self.travelingAtOnceAccLayer:setVisible(true)
        self.travelingAllGetLayer:setVisible(false)
    else
        self.travelingAtOnceAccLayer:setVisible(false)
        self.travelingAllGetLayer:setVisible(true)
    end
end

function PVTravelTraveling:scrollViewDidScroll(view)
end

function PVTravelTraveling:scrollViewDidZoom(view)
end

function PVTravelTraveling:tableCellTouched(table, cell)
    print("cell点击："..cell:getIdx())
end

function PVTravelTraveling:cellSizeForTable(table, idx)
    return 205, 640
end

function PVTravelTraveling:tableCellAtIndex(tbl, idx)
    local cell = nil --tbl:dequeueCell() 
    
    if nil == cell then
        cell = cc.TableViewCell:new()
        local function onBtnAtOnceGaoren()   --立即领取
            -- print("at Once  立即领取。。。。。。。。")
            local _travelInit = self.c_TravelData:getTravelInitResponse()
            local data = { 
                    stage_id = _travelInit.travel_item_chapter[self.tag].stage_id,
                    start_time = self.startTime,
                    event_id = self.travelList[idx+1].event_id,
                    settle_type = 1
                    }
            self.lingquType = 1    --立即领取
            self.GameResourcesdrops = self.travelList[idx+1].drops  -- 奖励掉落
            self.lingquDrops = getDataProcessor():getGameResourcesResponse(self.GameResourcesdrops)

            self.lingquPrice = cell._meetPrice--self.c_TravelTemplate:getPriceByeventID(self.travelList[idx+1].event_id)
            self.travelNet:sendSettleAutoTravel(data)
   

        end
        local function onBtnAtOnceFight()    --领取
            -- print("getget  领取。。。。。。。。。。。")
            local _travelInit = self.c_TravelData:getTravelInitResponse()
            local data = { 
                    stage_id = _travelInit.travel_item_chapter[self.tag].stage_id,
                    start_time = self.startTime,
                    event_id = self.travelList[idx+1].event_id,
                    settle_type = 0
                    }
            -- table.print(data)
            self.lingquType = 2    --领取
            self.GameResourcesdrops = self.travelList[idx+1].drops  -- 奖励掉落
            self.lingquDrops = getDataProcessor():getGameResourcesResponse(self.GameResourcesdrops)
            self.travelNet:sendSettleAutoTravel(data)

        end
        cell.UITravelingItem = {}
        cell.UITravelingItem["UITravelingItem"] = {}
        cell.UITravelingItem["UITravelingItem"]["onBtnAtOnceGaoren"] = onBtnAtOnceGaoren      --立即领取
        cell.UITravelingItem["UITravelingItem"]["onBtnAtOnceFight"] = onBtnAtOnceFight        --领取

        local _ccbProxy = cc.CCBProxy:create()
        local cellItem = CCBReaderLoad("travel/ui_travel_traveling_item.ccbi", _ccbProxy, cell.UITravelingItem)
        cell:addChild(cellItem)
        -- if idx+1 > table.nums(self.travelList) then
        --     -- cell.UIAniView = {}

        --     -- local cellItem = CCBReaderLoad("effect/ui_load_effect.ccbi", _ccbProxy, cell.UIAniView)
        --     -- -- self:loadCCBI("effect/ui_load_effect.ccbi", self.UIAniView)
        --     -- cell:addChild(cellItem)
        --     -- -- cell.UILoadingNode = cell.UIAniView["UIAniView"]["UILoadingNode"]
        --     -- cell.diLayer = cell.UIAniView["UIAniView"]["diLayer"]
        --     -- cell.diLayer:setVisible(false)
        --     -- cell.UILoadingNode:setScaleX(-0.5)
        --     -- cell.UILoadingNode:setScaleY(0.5)
    
        --     -- cell.UILoadingNode:setPosition(580,-170)

        --     -- cell.UILoadingNode:setPosition(0,0)
        -- end

        cell.travelNum = cell.UITravelingItem["UITravelingItem"]["travelNum"]                --游历次数，“第1次游历”
        cell.travelingState = cell.UITravelingItem["UITravelingItem"]["travelingState"]      --游历状态，“战斗胜利获得奖励”
        cell.itemGaorenLayer = cell.UITravelingItem["UITravelingItem"]["itemGaorenLayer"]    --事件等待事件
        cell.itemFightLayer = cell.UITravelingItem["UITravelingItem"]["itemFightLayer"]      --战斗事件／问题事件／直接领取事件
        cell.gaorenDes = cell.UITravelingItem["UITravelingItem"]["gaorenDes"]                --事件描述
        cell.jiangliTypeSprite = cell.UITravelingItem["UITravelingItem"]["jiangliTypeSprite"]--奖励精灵image
        cell.travelingJLNum = cell.UITravelingItem["UITravelingItem"]["travelingJLNum"]      --奖励Number
        cell.goldNum = cell.UITravelingItem["UITravelingItem"]["goldNum"]
        cell.btnAtOnceGaoren = cell.UITravelingItem["UITravelingItem"]["btnAtOnceGaoren"]
        cell.btnAtOnceFight = cell.UITravelingItem["UITravelingItem"]["btnAtOnceFight"]
        cell.travelingItemDes = cell.UITravelingItem["UITravelingItem"]["travelingItemDes"]
        cell.travingLayer = cell.UITravelingItem["UITravelingItem"]["travingLayer"]
        cell.newSp = cell.UITravelingItem["UITravelingItem"]["newSp"]

        cell.yiGetNode2 = cell.UITravelingItem["UITravelingItem"]["yiGetNode2"]
        cell.yiGetNode = cell.UITravelingItem["UITravelingItem"]["yiGetNode"]
        

        cell.animationManager = cell.UITravelingItem["UITravelingItem"]["mAnimationManager"]

        cell.timeTraving = cell.UITravelingItem["UITravelingItem"]["timeTraving"]
    end

    if idx+1 > table.nums(self.travelList) then

        cell.travelingState:setVisible(false)
        cell.travelingItemDes:setVisible(false)
        cell.itemGaorenLayer:setVisible(false)
        cell.itemFightLayer:setVisible(false)

        cell.travingLayer:setVisible(true)

        self.travelingTime = cell.timeTraving
        if self._leftTime ~= nil then
            self.travelingTime:setString(string.format("  (%02d:%02d:%02d)",math.floor(self._leftTime/3600), math.floor(self._leftTime%3600/60), self._leftTime%60))
        end

        cell.animationManager:runAnimationsForSequenceNamed("showTraving")
        cell.travelNum:setString("第" .. tostring(idx+1) .. "次游历")
        return cell
    end

    cell.travelNum:setString("第" .. tostring(idx+1) .. "次游历")
    cell.idx = idx
    local eventNumber = self.travelList[idx+1].event_id-- % 100000
    local eventState = self.travelList[idx+1].state
    

    local eventType = self.c_TravelTemplate:getEventTypeByEventID(eventNumber)
    local eventDes = self.c_TravelTemplate:getDiscriptionByEventID(eventNumber)
    
    cell.GameResourcesdrops = self.travelList[idx+1].drops  -- 奖励掉落
    -- table.print(cell.GameResourcesdrops)
    cell.drops = getDataProcessor():getGameResourcesResponse(cell.GameResourcesdrops)
   
    local detailName = ""
    local meetNum = 1
   
    cell.jiangliTypeSprite:setScale(0.73)
    if cell.drops[1].type == "finance" then
        
        -- cell.commonData = self.c_CommonData
    
        if cell.drops[1].coin ~= nil and cell.drops[1].coin>0 then
            print("-------------coin")
            meetNum = cell.drops[1].coin 
            detailName = "银两" 
            self.c_TravelData:changeFengIconImage(cell.jiangliTypeSprite, 0 ,false) 
        end
        if cell.drops[1].gold ~= nil and cell.drops[1].gold>0 then meetNum = cell.drops[1].gold detailName = "元宝"  end
        
        if cell.drops[1].junior_stone ~= nil and cell.drops[1].junior_stone>0 then meetNum = cell.drops[1].junior_stone   detailName = "百炼石" end
        if cell.drops[1].middle_stone ~= nil and cell.drops[1].middle_stone>0 then meetNum = cell.drops[1].middle_stone   detailName = "千锤石" end
        if cell.drops[1].high_stone ~= nil and cell.drops[1].high_stone>0 then meetNum = cell.drops[1].high_stone   detailName = "精炼石" end
        

        if cell.drops[1].hero_soul ~= nil and cell.drops[1].hero_soul>0 then 
            print("-------------武魂")
            meetNum = cell.drops[1].hero_soul
            detailName = "武魂"
            setItemImage2(cell.jiangliTypeSprite, "res/icon/resource/resource_3.png", 1)
        end

        if cell.drops[1].finance_changes ~= nil then
            print(cell.drops[1].finance_changes)
            print(table.nums(cell.drops[1].finance_changes))
            print("-------------finance_changes")
            for k,v in pairs(cell.drops[1].finance_changes) do
                meetNum = v.item_num
                local _resourceTemp = getTemplateManager():getResourceTemplate()
                local _icon = _resourceTemp:getResourceById(v.item_no)
                setItemImage2(cell.jiangliTypeSprite, "res/icon/resource/".._icon, 1)
                detailName = _resourceTemp:getResourceName(v.item_no)
            end
        end
    end

    if cell.drops[1].type == "travel_item" then

        meetNum = cell.drops[1][1].num
        detailName = self.c_TravelTemplate:getFentWuzhiByAwardId(cell.drops[1][1].id)
        self.c_TravelData:changeFengIconImage(cell.jiangliTypeSprite, cell.drops[1][1].id , false, true)
        
        if self.c_TravelData:setIsHaveFengWuZhi(cell.drops[1][1].id) then
            cell.newSp:setVisible(false)
        else
            cell.newSp:setVisible(true)
        end

    end

    cell.gaorenDes:setString(eventDes.." "..detailName.."X"..meetNum)
    cell.travelingJLNum:setString("X"..meetNum)

    if eventType == 1  then 

        cell.itemGaorenLayer:setVisible(true)
       
        cell._meetPrice = self.c_TravelTemplate:getPriceByeventID(self.travelList[idx+1].event_id)


        cell.goldNum:setString(cell._meetPrice)

        local _timeAll = self.c_TravelTemplate:getTimeByEventID(self.travelList[idx+1].event_id)
        _timeAll = tonumber(_timeAll)

        local _time = _timeAll*60 - (self.c_CommonData:getTime() - self.travelList[idx+1].time)
        if _time < 0 then 
            _time = 0 
            cell.travelingState:setString(string.format("（完成时间等待，可获得奖励）"))
            cell._meetPrice = 0
            cell.goldNum:setString(cell._meetPrice)
        else
            cell.travelingState:setString(string.format("（%02d:%02d:%02d后获得奖励）",math.floor(_time/3600), math.floor(_time%3600/60), _time%60))
        end
    
        local n = 0
        local num = table.nums(self._timeTravel)
        for k,v in pairs(self._timeTravel) do
            if v._idx ~=  idx then 
                n = n+1
            end

        end
        if n == num then 
            local data = {}
            data._idx = idx
            data._leftT = _time
            data._label = cell.travelingState
            data._meetPrice = cell._meetPrice
            data._goldNum = cell.goldNum
            table.insert (self._timeTravel, data) 
        end
        if eventState == 1 then
            for k, v in pairs(self._timeTravel) do
                if v._idx == idx then
                    table.remove(self._timeTravel, k)
                end
            end
        end

    else
        cell.itemGaorenLayer:setVisible(false)
        cell.itemFightLayer:setVisible(true)
    end
    if eventType == 2 then 
        cell.travelingState:setString("（战斗胜利，领取奖励）")
        cell.travelingState:setColor(ui.COLOR_BLUE)
    end
    if eventType == 3 then 
        
        local btnNumber1 = math.random(1,4)
        local btnNumber2 = math.random(1,4)
        while btnNumber2 == btnNumber1 do
            btnNumber2 = math.random(1,4)
        end
        local btnNumber3 = math.random(1,4)
        while btnNumber3 == btnNumber1 or btnNumber3 == btnNumber2 do
            btnNumber3 = math.random(1,4)
        end
        local btnNumber4 = 10-btnNumber1-btnNumber2-btnNumber3
        --四个答案
        local btnName1, languageId1, languageId21 = self.c_TravelTemplate:getFourAnswerByeventID(eventNumber, btnNumber1)
        local btnName2, languageId2, languageId22= self.c_TravelTemplate:getFourAnswerByeventID(eventNumber, btnNumber2)
        local btnName3, languageId3, languageId23 = self.c_TravelTemplate:getFourAnswerByeventID(eventNumber, btnNumber3)
        local btnName4, languageId4, languageId24 = self.c_TravelTemplate:getFourAnswerByeventID(eventNumber, btnNumber4)

        local answerLabel =  "甲:"..btnName1.." 乙:"..btnName2.." 丙:"..btnName3.." 丁:"..btnName4
        local a = "甲"
        print(eventNumber .. "  甲:"..languageId1.." 乙:"..languageId2.." 丙:"..languageId3.." 丁:"..languageId4)
        if self.c_TravelTemplate:isRightAnswerByAnwerID(eventNumber, languageId1) == false then
            a = "甲"
        elseif self.c_TravelTemplate:isRightAnswerByAnwerID(eventNumber, languageId2) == false then
            a = "乙"
        elseif self.c_TravelTemplate:isRightAnswerByAnwerID(eventNumber, languageId3) == false then
            a = "丙"
        else
            a = "丁"
        end

        cell.travelingState:setString("（你选择".. a .."，领取奖励）")
        cell.travelingState:setColor(ui.COLOR_BLUE)

        cell.gaorenDes:setString(eventDes.." "..detailName.."X"..meetNum.."\n"..answerLabel)
    end
    if eventType == 4 then 
        cell.travelingState:setString("（领取奖励）")
        cell.travelingState:setColor(ui.COLOR_BLUE)
    end
    
    if eventState == 1 then
        cell.itemGaorenLayer:setVisible(false)
        cell.itemFightLayer:setVisible(true)
        cell.travelingState:setString("（已领取）")
        cell.travelingState:setColor(ui.COLOR_GREY)
        cell.btnAtOnceFight:setEnabled(false)
        SpriteGrayUtil:drawSpriteTextureGray(cell.btnAtOnceGaoren)

        cell.yiGetNode2:setVisible(false)
        cell.yiGetNode:setVisible(false)
    end

    return cell
end

function PVTravelTraveling:numberOfCellsInTableView(table)
    -- print("++++++++++++++++++++++++++++++++++++++++++"..self.autoTravelNum.."++++++++++++++++++++++++++++++++++++++++++")
   return self.autoTravelNum
end
--退出本届面
function PVTravelTraveling:tuichuUpdate()
    if self.scheduerOutputTime ~= nil then
        timer.unscheduleGlobal(self.scheduerOutputTime)
        self.scheduerOutputTime = nil
    end
    -- print("退出"..self.isTravelStype)
    local event = cc.EventCustom:new(EXIT_PLACE)
    self:getEventDispatcher():dispatchEvent(event)
    local event = cc.EventCustom:new(UPDATE_WAITGAIN)
    self:getEventDispatcher():dispatchEvent(event)
    self:onHideView()
end

function PVTravelTraveling:initTouchListener()
    --退出
    local function onCloseClick()
        self:tuichuUpdate()
    end

    --全部领取
    local function onAllGetMenuItem()
        local _travelInit = self.c_TravelData:getTravelInitResponse()
        -- print("点击全部领取")
        local data = { 
                stage_id = _travelInit.travel_item_chapter[self.tag].stage_id,
                start_time = self.startTime,
                event_id = 0,
                settle_type = 0
                }
        -- table.print(data)
        self.lingquType = 3    --立即领取
        self.travelNet:sendSettleAutoTravel(data)
    end

    --立即完成
    local function travelingAtOnceAcc()
        if self.c_BaseTemplate:getAutoTravelFastFinish() == 0 then
            getOtherModule():showAlertDialog(nil, "VIP等级不足")
        -- local viplevel = getDataManager():getCommonData():getVip()
        end
        if getTemplateManager():getBaseTemplate():getAutoTravelFastFinish() == 0 then
            -- self:toastShow("VIP等级不足")
            getOtherModule():showAlertDialog(nil, Localize.query("PVTravelTraveling.1"))
        else
            local _travelInit = self.c_TravelData:getTravelInitResponse()
            local data = { 
                    stage_id = _travelInit.travel_item_chapter[self.tag].stage_id,
                    start_time = self.startTime
                    }
            self.travelNet:sendFastFinishRequest(data)
        end
    end

    self.UITravelingView["UITravelingView"] = {}
    self.UITravelingView["UITravelingView"]["onCloseClick"] = onCloseClick
    self.UITravelingView["UITravelingView"]["onAllGetMenuItem"] = onAllGetMenuItem
    self.UITravelingView["UITravelingView"]["travelingAtOnceAcc"] = travelingAtOnceAcc
end

function PVTravelTraveling:startTimer()
    -- print("开始时间。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。")
    local function updateTimer(dt)
        print("startTimer刷新时间")
        -- if self._leftTime <= 0 then self.scheduerOutputTime = nil return end
        self._leftTime = self._leftTime - dt
        self._allTime = self._allTime - dt
        for k,v in pairs(self._timeTravel) do
            if v._leftT == 0 then
                print("        v._leftT == 0")
                v._label:setString(string.format("（完成时间等待，可获得奖励）"))
                v._meetPrice = 0
                v._goldNum:setString(v._meetPrice)
            else
                v._leftT = v._leftT - dt
                v._label:setString(string.format("（%02d:%02d:%02d后获得奖励）",math.floor(v._leftT/3600), math.floor(v._leftT%3600/60), v._leftT%60))
            end
        end

        self.outPutTimeLabel:setString(string.format("%02d:%02d:%02d",math.floor(self._allTime/3600), math.floor(self._allTime%3600/60), self._allTime%60))
        if self.travelingTime ~= nil then
            self.travelingTime:setString(string.format("（%02d:%02d:%02d）",math.floor(self._leftTime/3600), math.floor(self._leftTime%3600/60), self._leftTime%60))
        end
        if self._leftTime <= 0 then 
            self.travelNet:sendGetTravelInitResponse()
            self._travelInit = self.c_TravelData:getTravelInitResponse()
            print("6分钟时间到")
        end
    end
    self.scheduerOutputTime = timer.scheduleGlobal(updateTimer, 1.0)
    
end

function PVTravelTraveling:onReloadView()
   self:updateData()
end

return PVTravelTraveling
