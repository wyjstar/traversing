--游历
--章节
UPDATE_FWZhUI = "UPDATE_FWZhUI"

local PVTravelCellItem = class("PVTravelCellItem", function()
    return cc.TableViewCell:new() 
    end)

function PVTravelCellItem:ctor()

    self.c_TravelData = getDataManager():getTravelData()
    
    self.tag = 1
end

function PVTravelCellItem:initData(tag, data)
    local _travelInit = self.c_TravelData:getTravelInitResponse()
    local _itemCount = table.nums(_travelInit.travel_item_chapter)

    self.tag = tag
    self._isSelected = false
    -- print(data..tag)
    if self.tag == data then
        -- print("------self.tag == data--------")
        self._isSelected = true
    end

    if tag > _itemCount then
        self._isSelected = false
        self._isNoHave = true
    else
        self.sta = _travelInit.travel_item_chapter[tag].stage_id
    end

    self.time = 0
    self.travelInitResponse = _travelInit
    self:initView()
    self:updateUI()
end

function PVTravelCellItem:initView()

    self.UiTravelItem = {}
    self.UiTravelItem["UiTravelItem"] = {}

    local _ccbProxy = cc.CCBProxy:create()
    local cellItem = nil
    
    cellItem = CCBReaderLoad("travel/ui_travel_item.ccbi", _ccbProxy, self.UiTravelItem)

    self:addChild(cellItem)

    self.firstSprite = self.UiTravelItem["UiTravelItem"]["firstSprite"]
    self.left_notice = self.UiTravelItem["UiTravelItem"]["left_notice"]
    self.texiaoNode = self.UiTravelItem["UiTravelItem"]["texiaoNode"]
    self.itemFirstLayer2 = self.UiTravelItem["UiTravelItem"]["itemFirstLayer2"]
    self.selectedItem = self.UiTravelItem["UiTravelItem"]["selectedItem"]
    self.allNode = self.UiTravelItem["UiTravelItem"]["rotationNode"]
    self.firstNumberLabel = self.UiTravelItem["UiTravelItem"]["firstNumberLabel"]

    if self._isSelected == true then
        self.selectedItem:setVisible(true)
        self.allNode:setScale(1)
    else
        self.selectedItem:setVisible(false)
        self.allNode:setScale(0.9)
    end


    -- self.firstDiName = self.UiTravelItem["UiTravelItem"]["firstDiName"]
    -- self.fengwuzhiLabel = self.UiTravelItem["UiTravelItem"]["fengwuzhiLabel"]
    
    -- self.firstTitle2 = self.UiTravelItem["UiTravelItem"]["firstTitle2"]
    -- self.firstConditionlabel2 = self.UiTravelItem["UiTravelItem"]["firstConditionlabel2"]
    -- self.firstTimeLabel1 = self.UiTravelItem["UiTravelItem"]["firstTimeLabel1"]
    -- self.itemFirstLayer1 = self.UiTravelItem["UiTravelItem"]["itemFirstLayer1"]
    

    --特效加载
    local node1 = UI_youlifengwuzhi()
    local node2 = UI_youlifengwuzhi001()
    local chaTag = self.c_TravelData:getTravelChaTag()
    local isTeXiao = false
    if self.tag >= 2 then
        if self.tag - 1 == chaTag then
            if self.c_TravelData:getIsEqual(chaTag) then
                isTeXiao = true
                self.c_TravelData:setTravelChaTag(self.tag)
            end
        end
    end
    if isTeXiao == true and self._isNoHave ~= true then
        if self.tag % 2 ==0 then
            self.texiaoNode:addChild(node2)
        else
            self.texiaoNode:addChild(node1)
        end
    else
        self.texiaoNode:removeAllChildren()
    end


    local function fwzhcallFunc()
        self:updateFWZhUI()
    end
    self.listener3 = cc.EventListenerCustom:create(UPDATE_FWZhUI, fwzhcallFunc)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener3, 1)


    local function onNodeEvent(event)
        if "exit" == event then
            self:onExit()
        end
    end
    
    self:registerScriptHandler(onNodeEvent)

end

function PVTravelCellItem:onExit()

    self:unregisterScriptHandler()
    self:getEventDispatcher():removeEventListener(self.listener3)
    -- if self.scheduerOutputTime ~= nil then
    --     timer.unscheduleGlobal(self.scheduerOutputTime)
    --     self.scheduerOutputTime = nil
    -- end
end

-- 根据传过来的数据更新UI
function PVTravelCellItem:updateUI()

    local strImg = tostring("ui_travel_bg_"..self.tag..".png")
    self.firstSprite:setSpriteFrame(strImg)

    if self._isNoHave == true then
        self.itemFirstLayer2:setVisible(true)
        self.firstNumberLabel:setVisible(false)
        return
    end
    
    -- 更新风物志数量
    local _curNum = table.nums(self.travelInitResponse.travel_item_chapter[self.tag].travel_item)
    local _totalNum = self.c_TravelData:getTotalNumFengwuzhi(self.travelInitResponse.travel_item_chapter[self.tag].stage_id)
    self.firstNumberLabel:setString(string.format("%d/%d", _curNum, _totalNum))

    -- if  没有开启
    local _isOpen = self.travelInitResponse.travel_item_chapter[self.tag].isOpen
    if not _isOpen then

        -- self.firstNumberLabel:setString(string.format("%d/%d", 0, _totalNum))
        -- self.firstSprite:setColor(ui.COLOR_GREY)
        -- self.firstDiName:setColor(ui.COLOR_GREY)
        -- self.firstNumberLabel:setTextColor(ui.COLOR_GREY)
        -- self.firstTitle2:setColor(ui.COLOR_GREY)

        self.itemFirstLayer2:setVisible(true)
        -- self.itemFirstLayer1:setVisible(false)

        self.left_notice:setVisible(false)

    else
        --  游历中 倒计时
        -- 如果没有游历中，隐藏。。。。

        self.itemFirstLayer2:setVisible(false)

        if self:checkTravel() then self.left_notice:setVisible(true) else self.left_notice:setVisible(false) end

        if self.c_TravelData:getIsEqual(self.tag) then
            self.left_notice:setVisible(false)
        end


        -- local _travelInit = self.c_TravelData:getTravelInitResponse()
        -- local isIntoTraveling = self.c_TravelData:getIsIntoTraveling(_travelInit.stage_travel, self.tag)
        
        -- cclog("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        -- cclog(isIntoTraveling)

        -- if isIntoTraveling == 1 or isIntoTraveling == 2  then
        --     local isIntoTravelingNUm = self.c_TravelData:getIsIntoTravelingNum(_travelInit.stage_travel, self.tag)
        --     self.itemFirstLayer1:setVisible(true)
        --     self.itemFirstLayer2:setVisible(false)
        --     if isIntoTraveling == 1 then
        --         local _travelInit = self.c_TravelData:getTravelInitResponse()

        --         local autoT = nil
        --         for k,v in pairs(_travelInit.stage_travel) do
        --             if v.stage_id == self.sta then
        --                 autoT = v.auto_travel
        --             end
        --         end
        --         if autoT ~= nil then
        --             local auto_travel = autoT[isIntoTravelingNUm]
        --             local startTime = auto_travel.start_time
        --             local continuedTime = auto_travel.continued_time
        --             local finishTime = startTime + continuedTime*60

        --             self.time = finishTime - getDataManager():getCommonData():getTime()
        --             self.firstTimeLabel1:setString(string.format("%02d:%02d:%02d",math.floor(self.time/3600), math.floor(self.time%3600/60), self.time%60))
        --             self:startTimer()
        --         else
        --             -- print("--------else-----------")
        --         end 
        --     end
        --     if isIntoTraveling == 2 then
        --         self.firstTimeLabel1:setString("领取自动游历奖励")
        --     end
        -- else
        --     self.itemFirstLayer1:setVisible(false)
        --     self.itemFirstLayer2:setVisible(false)
        -- end
    end
end


-- function PVTravelCellItem:startTimer()

--     local function updateTimer(dt)
--         if self.time == nil then self.scheduerOutputTime = nil return end
--         if self.time <= 0 then  return end
--         self.time = self.time - dt
--         self.firstTimeLabel1:setString(string.format("%02d:%02d:%02d",math.floor(self.time/3600), math.floor(self.time%3600/60), self.time%60))
--         if self.time <= 0 then 
--             self.time = 0
--             -- print("时间到")
--             self.firstTimeLabel1:setString("领取自动游历奖励")
--             timer.unscheduleGlobal(self.scheduerOutputTime)
--             self.scheduerOutputTime = nil
--         end
--     end
--     self.scheduerOutputTime = timer.scheduleGlobal(updateTimer, 1.0)

-- end

-- function PVTravelCellItem:getOpacityWithPoint(pSpr, point)

--     local pImage = self:createImageFromSprite(pSpr)
    
--     local c = pImage:getColor4B(point.x, point.y)
--     pImage:release()
--     return c.a;
-- end

-- function PVTravelCellItem:createImageFromSprite(pSpr)

--     local pNewSpr = cc.Sprite:createWithSpriteFrame(pSpr:getSpriteFrame())
--     pNewSpr:setAnchorPoint(cc.p(0,0))
--     local pRender = cc.RenderTexture:create(pNewSpr:getContentSize().width, pNewSpr:getContentSize().height)
--     pRender:begin()
--     pNewSpr:visit()
--     pRender:endToLua()
    
--     cc.Director:getInstance():execRenderer()
    
--     return pRender:newImage(false)
-- end

-- function PVTravelCellItem:isTouchEvent(pos)

--     local _pos = self.firstSprite:convertToNodeSpace(pos)
--     local _a = self:getOpacityWithPoint(self.firstSprite, cc.p(_pos.x, _pos.y))
                
--     cclog("_a=".._a)

--     return _a > 0
-- end

-- function PVTravelCellItem:executeHandelEvent()
--     -- print("executeHandelEvent----")
--     -- print(self.tag)

--     local _isOpen = self.travelInitResponse.travel_item_chapter[self.tag].isOpen
--     -- print("---------------- self.tag -------------------------")
--     -- print(_isOpen)
--     if not _isOpen then
--         return
--     end

--     local _travelInit = self.c_TravelData:getTravelInitResponse()
--     local isIntoTraveling = self.c_TravelData:getIsIntoTraveling(_travelInit.stage_travel, self.tag)

--     if isIntoTraveling == 1 or isIntoTraveling == 2  then   --进入游历中界面
--         getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelTraveling", self.tag)
--     else
--         getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelPlace", self.tag)
--     end
--     groupCallBack(GuideGroupKey.BTN_TAO_YUAN)
-- end

--     if isIntoTraveling == 1 or isIntoTraveling == 2  then   --进入游历中界面
--         -- getOtherModule():showOtherView("PVTravelTraveling", self.tag) 
--         getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelTraveling", self.tag)
--     else
--         -- getOtherModule():showOtherView("PVTravelPlace", self.tag) 
--         getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelPlace", self.tag)
--     end

--     local _isHasGain = getDataManager():getTravelData():isHasGain()
--     print("isHasGain ", _isHasGain)
    
--     if _isHasGain then
--         if(getNewGManager():getCurrentGid()==GuideId.G_GUIDE_60007) then
--             getNewGManager():setCurrentGID(GuideId.G_GUIDE_60009)
--             groupCallBack(GuideGroupKey.BTN_YOULI_BAOXIANG_CONFIRM)
--             --getNewGManager():guideOver()
--         end
--     else
--         groupCallBack(GuideGroupKey.BTN_TAO_YUAN)
--     end
-- end

-- 更新风物志
function PVTravelCellItem:updateFWZhUI()
    -- print("刷新风物志，章节刷新")
    -- 更新风物志数量

    if self._isNoHave == true then
        return
    end
    local _curNum = table.nums(self.travelInitResponse.travel_item_chapter[self.tag].travel_item)
    local _totalNum = self.c_TravelData:getTotalNumFengwuzhi(self.travelInitResponse.travel_item_chapter[self.tag].stage_id)
    self.firstNumberLabel:setString(string.format("%d/%d", _curNum, _totalNum))
end



--检查游历是否有宝箱、鞋子、自动游历完成
function PVTravelCellItem:checkTravel()
    --是否有鞋子可以游历
    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    local _shoes = _travelInitResponse.shoes
    local isCanTravel = false
    if _shoes.shoe1 <= 0 and _shoes.shoe2<=0 and _shoes.shoe3<=0 then
        isCanTravel = false
    else
        isCanTravel = true
    end
    --是否有宝箱可以领取
    -- 判断今天宝箱是否领取
    local isGold = false
    local _isHasGain = self.c_TravelData:isHasGain()
    if not _isHasGain then
        isGold = true
    else
        isGold = false
    end
    
    --判断自动游历是否已经游历完并且有奖励领取
    local isCanGetTraveling = false
    local _travelInit = self.c_TravelData:getTravelInitResponse()
    local isTravelStype = self.c_TravelData:getIsIntoTraveling(_travelInit.stage_travel,self.tag)
    
    if isTravelStype == 2 then 
        isCanGetTraveling = true
    else
        isCanGetTraveling = false
    end
    
    --判断游历等待时间事件是否已经完成
    local isCanGetTravel = false
    local _travelInit = self.c_TravelData:getTravelInitResponse()
    local _stage_id = _travelInit.travel_item_chapter[self.tag].stage_id
    local _chapters = _travelInit.chapter
    for k,v in pairs(_chapters) do
        if v.stage_id == _stage_id then
            for k1,v1 in pairs(v.travel) do
                local meetType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(v1.event_id)
                if meetType == 1 and v1.time > 0 then
                    local _leftTime = getDataManager():getCommonData():getTime() - v1.time
                    local _time = getTemplateManager():getTravelTemplate():getTimeByEventID(v1.event_id)
                    if _leftTime > _time*60 then 
                        _leftTime = 0 
                    else  
                        _leftTime = _time*60 - _leftTime
                    end

                    -- print("1111======_leftTime=======  ".._leftTime)

                    if _leftTime <= 0 then
                        -- print("游历等待时间事件完成")
                        isCanGetTravel = true
                    end
                end
            end
        end
    end

    local _autoTravel = self.c_TravelData:addTableAutoTime(_travelInit.stage_travel, self.tag)
   

    for k,v in pairs(_autoTravel) do
        local meetType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(v.event_id)

        local _leftTime = getDataManager():getCommonData():getTime() - v.time
        
        local _timeAll = getTemplateManager():getTravelTemplate():getTimeByEventID(v.event_id)
        if _leftTime > _timeAll*60 then 
            _leftTime = 0 
        else  
            _leftTime = _timeAll*60 - _leftTime
        end
        if meetType == 1 and _leftTime<=0 then
            -- print("自动游历等待时间事件完成")
            isCanGetTravel = true
        end
    end


    if isCanTravel or isGold or isCanGetTraveling or isCanGetTravel then
        return true
    else
        return false
    end

end

return PVTravelCellItem
