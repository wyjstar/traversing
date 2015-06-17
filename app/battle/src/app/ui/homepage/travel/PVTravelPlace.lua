--游历

-- 鞋子类型
CAO_SHOES = 1
BU_SHOES = 2
PI_SHOES = 3

-- 事件类型
EVENT_ONE = 1   -- 等待时间事件
EVENT_TWO = 2   -- 战斗事件
EVENT_THREE = 3 -- 答题事件 
EVENT_FOUR = 4  -- 直接领取事件

UPDATE_SHOES = "UPDATE_SHOES"
UPDATE_WAITGAIN = "UPDATE_WAITGAIN"
UPDATE_FWZhUI = "UPDATE_FWZhUI"


UPDATE_UNFINISHEVENT = "UPDATE_UNFINISHEVENT"

local PVTravelPlace = class("PVTravelPlace", BaseUIView)

function PVTravelPlace:ctor(id)


    self.c_TravelData = getDataManager():getTravelData()
    self.travelNet = getNetManager():getTravelNet()
    self.c_CommonData = getDataManager():getCommonData()
    self.c_TravelTemplate = getTemplateManager():getTravelTemplate()

    self.super.ctor(self, id)
end

function PVTravelPlace:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")
    --self:showAttributeView()
    self.placeDataList = {}
    self._travelWait = {}
    self.cellID = 0
    self._unfinishevent = 0  -- 未完成事件
    self._unfinisheventID = 0  -- 未完成事件
    self._unfinisheventDrops = 0  -- 未完成事件
    self._otherTravelEvent = {}

    self.isMeetLqTime = false

    self.UITravelPlaceView = {}

    self:initTouchListener()

    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_place.ccbi", self.UITravelPlaceView)
    -- print("***************")
    

    self.tag = self.funcTable[1]
    -- print("...............................................tag="..self.tag)

    self:initData()
    self:initView()
    

    self:initRegisterNetCallBack()

    local function callFunc()
        print("------UPDATE_SHOES---------")
        self:updateShoesUI()
    end

    self.listener = cc.EventListenerCustom:create(UPDATE_SHOES, callFunc)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

    local function waitcallFunc()
        print("------UPDATE_WAITGAIN---------")
        self:update_aftergain()
    end

    self.listener2 = cc.EventListenerCustom:create(UPDATE_WAITGAIN, waitcallFunc)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener2, 1)

    local function fwzhcallFunc()
        self:updateFWZhUI()
    end

    self.listener3 = cc.EventListenerCustom:create(UPDATE_FWZhUI, fwzhcallFunc)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener3, 1)


    local function update_unfinishEvent()
         self:UnfinishedEvent()
    end


    self.listener5 = cc.EventListenerCustom:create(UPDATE_UNFINISHEVENT, update_unfinishEvent)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener5, 1)

    local function onNodeEvent(event)
        if "exit" == event then
            self:onExit()
        end
    end
    
    self:registerScriptHandler(onNodeEvent)

    self:updateFWZhUI()
    self:updateNewPoint()
    
end

function PVTravelPlace:onExit()
    self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")
    self:getEventDispatcher():removeEventListener(self.listener)
    self:getEventDispatcher():removeEventListener(self.listener2)
    self:getEventDispatcher():removeEventListener(self.listener3)
    -- self:getEventDispatcher():removeEventListener(self.listener4)
    self:getEventDispatcher():removeEventListener(self.listener5)

    if self._scheduerOutputTime ~= nil then
        -- print("self.scheduerOutputTime===PVTravelPlace:onExit===")
        timer.unscheduleGlobal(self._scheduerOutputTime)
        self._scheduerOutputTime = nil
    end
end

function PVTravelPlace:initView()

    self.placeContentLayer = self.UITravelPlaceView["UITravelPlaceView"]["placeContentLayer"]
    self.newSp = self.UITravelPlaceView["UITravelPlaceView"]["newSp"]
    self.tavelTitleSprite = self.UITravelPlaceView["UITravelPlaceView"]["tavelTitleSprite"]    --标题
    self.travelPlaceBg = self.UITravelPlaceView["UITravelPlaceView"]["travelPlaceBg"]          --背景大图
    
    local _str = string.format("#ui_travel_di_%d.png",self.tag)
    game.setSpriteFrame(self.tavelTitleSprite, _str)
    local _strBg = string.format("res/ccb/effectpng/ui_travel_bg_%d.jpg",self.tag)
    -- print(">>>>>>>>>>>>>>>".._strBg)
    game.setSpriteFrame(self.travelPlaceBg, _strBg)

    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGB565)
    -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    --鞋子数量
    self.strawShoesNum = self.UITravelPlaceView["UITravelPlaceView"]["strawShoesNum"]
    self.clothShoesNum = self.UITravelPlaceView["UITravelPlaceView"]["clothShoesNum"]
    self.leatherShoesNum = self.UITravelPlaceView["UITravelPlaceView"]["leatherShoesNum"]
    --VIP等级
    self.vipNum = self.UITravelPlaceView["UITravelPlaceView"]["vipNum"]
    --每日最大购买次数
    self.buyNum = self.UITravelPlaceView["UITravelPlaceView"]["buyNum"]
    --可游历次数
    self.travelNumLabel = self.UITravelPlaceView["UITravelPlaceView"]["travelNumLabel"]
    self.shoesTyprSp = self.UITravelPlaceView["UITravelPlaceView"]["shoesTyprSp"]
    --
    self.placeThingNum = self.UITravelPlaceView["UITravelPlaceView"]["placeThingNum"]

    self.btnTravelAuto = self.UITravelPlaceView["UITravelPlaceView"]["btnTravelAuto"]
    self.btnTravel = self.UITravelPlaceView["UITravelPlaceView"]["btnTravel"]

    self.allGoldLabel = self.UITravelPlaceView["UITravelPlaceView"]["allGoldLabel"]
    local goldNUm = self.c_CommonData:getGold()
    self.allGoldLabel:setString(goldNUm)

    --获取VIP等级
    self.viplevel = self.c_CommonData:getVip()
    self.buyShoeTimes = vip_config[self.viplevel].buyShoeTimes
    self.vipNum:setString(self.viplevel)
    self.buyNum:setString(self.buyShoeTimes.."次")


    local layerSize = self.placeContentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.placeContentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,2)
    scrBar:setPosition(cc.p(layerSize.width/2,5))
    self.placeContentLayer:addChild(scrBar,2)

    -- self.tableView:reloadData()
    -- self:update_waitTravel()

    self.itemCount = table.nums(self.placeDataList)
    self.tableView:reloadData()


    -- 初始化鞋子
    self:updateShoesUI()
    self:updateFWZhUI()
      
end

function PVTravelPlace:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        
        local event = cc.EventCustom:new(EXIT_PLACE)
        self:getEventDispatcher():dispatchEvent(event)

        self:onHideView()
    end

    --游历
    local function onTravel()
        --print("点击游历")


        local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
        local _shoes = _travelInitResponse.shoes
        if _shoes.shoe1 <= 0 and _shoes.shoe2<=0 and _shoes.shoe3<=0 then
            -- self:toastShow("游历次数已用完，购买鞋子继续游历")
            getOtherModule():showAlertDialog(nil, Localize.query("PVTravelPlace.1"))
            getAudioManager():playEffectButton2()
            getOtherModule():showOtherView("PVTravelChooseBuyNum",1)
            return
        end

        self.btnTravel:setEnabled(false)

        local data = {stage_id = _travelInitResponse.travel_item_chapter[self.tag].stage_id}

        self.travelNet:sendTravelRequest(data)
    end

    --自动游历
    local function onTravelAuto()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelChooseAutoTime",self.tag)
    end
    --添加草鞋
    local function onAddStrawShoesNum()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelChooseBuyNum",1)
    end

    --添加布鞋
    local function onAddClothShoesNum()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelChooseBuyNum",2)
    end

    --添加皮鞋
    local function onAddLeatherShoesNum()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelChooseBuyNum",3)
    end


    --
    local function toFengwuzhi()
        getAudioManager():playEffectButton2()
        
        local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTravelFengwuzhi", _travelInitResponse.travel_item_chapter[self.tag].stage_id,self.tag)
   
    end

    --
    --物品
    local function onLookShoes1()
        -- print("::::::::::1")
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 1)
    end
    --物品
    local function onLookShoes2()
        -- print("::::::::::2")
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 2)
    end

    --物品
    local function onLookShoes3()
        -- print("::::::::::3")
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 3)
    end


    self.UITravelPlaceView["UITravelPlaceView"] = {}
    self.UITravelPlaceView["UITravelPlaceView"]["onCloseClick"] = onCloseClick
    self.UITravelPlaceView["UITravelPlaceView"]["onTravel"] = onTravel
    self.UITravelPlaceView["UITravelPlaceView"]["onTravelAuto"] = onTravelAuto
    self.UITravelPlaceView["UITravelPlaceView"]["onAddStrawShoesNum"] = onAddStrawShoesNum
    self.UITravelPlaceView["UITravelPlaceView"]["onAddClothShoesNum"] = onAddClothShoesNum
    self.UITravelPlaceView["UITravelPlaceView"]["onAddLeatherShoesNum"] = onAddLeatherShoesNum
    -- self.UITravelPlaceView["UITravelPlaceView"]["onGoldBtn"] = onGoldBtn  
    self.UITravelPlaceView["UITravelPlaceView"]["toFengwuzhi"] = toFengwuzhi

    self.UITravelPlaceView["UITravelPlaceView"]["onLookShoes1"] = onLookShoes1
    self.UITravelPlaceView["UITravelPlaceView"]["onLookShoes2"] = onLookShoes2
    self.UITravelPlaceView["UITravelPlaceView"]["onLookShoes3"] = onLookShoes3
end


function PVTravelPlace:scrollViewDidScroll(view)
end

function PVTravelPlace:scrollViewDidZoom(view)
end

function PVTravelPlace:tableCellTouched(table, cell)
    -- cclog("--PVTravelPanel:tableCellTouched---")

    local idx = cell:getIdx()
    self.cellID = idx
    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    
    if cell.leftTime <=0 then
        -- TODO 时间到了
        local _gainAfter = 1  -- 稍后获得
        if  self.placeDataList[idx+1].isauto then
            -- print("自动游历挂起")
            local data = {}
            data.stage_id = _travelInitResponse.travel_item_chapter[self.tag].stage_id
            data.event_id = self.placeDataList[idx+1].event_id
            data.start_time = self.placeDataList[idx+1].start_time
            data.settle_type = 1
            -- self.travelNet:sendSettleAutoTravel(data)
            -- print("自动游历挂起")
            getOtherModule():showOtherView("PVTravelMeet", self.placeDataList[idx+1].event_id, self.placeDataList[idx+1].drops, _travelInitResponse.travel_item_chapter[self.tag].stage_id, _gainAfter, self, true, self.placeDataList[idx+1].start_time)
            return
            
        else
            -- print("主动游历挂起")
            local data = {}
            data.stage_id = _travelInitResponse.travel_item_chapter[self.tag].stage_id
            data.event_id = self.placeDataList[idx+1].event_id
            -- self.travelNet:sendTravelSettleRequest(data)

            self.isMeetLqTime = true

            getOtherModule():showOtherView("PVTravelMeet", self.placeDataList[idx+1].event_id, self.placeDataList[idx+1].drops, _travelInitResponse.travel_item_chapter[self.tag].stage_id, _gainAfter, self)
            return
        end
        
        self:update_settle()
    else
        -- self.placeDataList[idx+1].drops
        local _gainAfter = 1  -- 稍后获得
        -- print("---tableCellTouched--".._gainAfter)
        if not self.placeDataList[idx+1].isauto then
            print("---------- self.placeDataList[idx+1] ---------------")
            getOtherModule():showOtherView("PVTravelMeet", self.placeDataList[idx+1].event_id, self.placeDataList[idx+1].drops, _travelInitResponse.travel_item_chapter[self.tag].stage_id, _gainAfter, self)
        else   -- 自动游历
            getOtherModule():showOtherView("PVTravelMeet", self.placeDataList[idx+1].event_id, self.placeDataList[idx+1].drops, _travelInitResponse.travel_item_chapter[self.tag].stage_id, _gainAfter, self, true, self.placeDataList[idx+1].start_time)
        end 
    end
end

function PVTravelPlace:cellSizeForTable(table, idx)

    return 150, 147
end

function PVTravelPlace:tableCellAtIndex(tbl, idx)
    local cell = nil 

    if nil == cell then
        cell = cc.TableViewCell:new()

        local function onGeneralHeadClick()
            cclog("onGeneralHeadClick")
        end

        local function onItemClick()
            cclog("onItemClick")
        end

        cell.UiTravelItem = {}
        cell.UiTravelItem["UITravelPlaceItem"] = {}

        local _ccbProxy = cc.CCBProxy:create()
        local cellItem = CCBReaderLoad("travel/ui_travel_place_item.ccbi", _ccbProxy, cell.UiTravelItem)
        cell.outPutLayer = cell.UiTravelItem["UITravelPlaceItem"]["outPutLayer"]
        cell.noOutPutLayer = cell.UiTravelItem["UITravelPlaceItem"]["noOutPutLayer"]
        cell.outPutTimeLabel = cell.UiTravelItem["UITravelPlaceItem"]["outPutTimeLabel"]
        cell.travelPeopleSp = cell.UiTravelItem["UITravelPlaceItem"]["travelPeopleSp"]
        cell.npcNameLabel = cell.UiTravelItem["UITravelPlaceItem"]["npcNameLabel"]

        local _drop = self.placeDataList[idx+1].drops

        cell.GameResourcesdrops = self.placeDataList[idx+1].drops
        cell.drops = getDataProcessor():getGameResourcesResponse(cell.GameResourcesdrops)
        
        local num , name , isNew = self.c_TravelData:setDropSp(cell.drops[1] , cell.travelPeopleSp)
        cell.npcNameLabel:setString(name)




        local eventId = self.placeDataList[idx+1].event_id
        -- local npc = self.c_TravelTemplate:getNPCNameByEventID(eventId)
        -- cell.npcNameLabel:setString(npc)

        -- local resPath = self.c_TravelTemplate:getResNameByeventID(eventId)
        -- cell.travelPeopleSp:setSpriteFrame(resPath)
        -- cell.travelPeopleSp:setScale(0.7)

        local _leftTime = self.c_CommonData:getTime() - self.placeDataList[idx+1].time

        local _time = self.c_TravelTemplate:getTimeByEventID(eventId)
        if _leftTime > tonumber(_time)*60 then 
            _leftTime = 0 
            cell.noOutPutLayer:setVisible(true)
            cell.outPutLayer:setVisible(false)
        else  
            _leftTime = tonumber(_time)*60 - _leftTime
            cell.outPutTimeLabel:setString(string.format("%02d:%02d:%02d",math.floor(_leftTime/3600), math.floor(_leftTime%3600/60), _leftTime%60))
        end

        cell.leftTime = _leftTime

        cell:addChild(cellItem)
    end

    return cell
end

function PVTravelPlace:numberOfCellsInTableView(table)
    -- self.itemCount = table.nums(self.placeDataList)

   return self.itemCount
end


function PVTravelPlace:startTimer()

    local function updateTimer(dt)

        if self.timeBuy <= 0 then
            self.timeBuy = (60*60*24) - self.c_CommonData:getTime()%(60*60*24)
            if self.timeBuy > 0 then
                self.travelNet:sendGetTravelInitResponse()
            end
        end
        self.timeBuy = self.timeBuy - dt
        -- print(string.format("%02d:%02d:%02d",math.floor(self.timeBuy/3600), math.floor(self.timeBuy%3600/60), self.timeBuy%60 ))

        if self.tableView == nil then
            return
        end

        local items = self.tableView:getContainer():getChildren()

        for k, v in pairs(items) do
            local _leftTime = v.leftTime-dt
            -- print(k.."===".._leftTime)
            if _leftTime <= 0 then _leftTime = 0 end
            v.leftTime = _leftTime
            v.outPutTimeLabel:setString(string.format("%02d:%02d:%02d",math.floor(_leftTime/3600), math.floor(_leftTime%3600/60), _leftTime%60))
            if _leftTime <= 0 then 
                v.outPutLayer:setVisible(false)
                v.noOutPutLayer:setVisible(true)
            end
        end
    end

    self._scheduerOutputTime = timer.scheduleGlobal(updateTimer, 1.0)

end

function PVTravelPlace:initData()

    self:initChapterWaitTime()

    self.timeBuy = (60*60*24) - self.c_CommonData:getTime() % (60*60*24)
    --开启时间
    self:startTimer()


    -- todo 处理未完成的游历事件
    local function listener()
        timer.unscheduleGlobal(self._unfinishedTimer)
        self:UnfinishedEvent()
    end 

    self._unfinishedTimer = timer.scheduleGlobal(listener, 0.3)

end

-- 处理未完成的游历事件
function PVTravelPlace:UnfinishedEvent()
    
    cclog("---UnfinishedEvent----")
    -- table.print(self._otherTravelEvent)

    if table.nums(self._otherTravelEvent)>0 then

        local _travelEvent = self._otherTravelEvent[1]
        local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
        self._unfinishevent = 2  -- 未完成事件
        self._unfinisheventID = _travelEvent.event_id
        self._unfinisheventDrops = _travelEvent.drops
        -- self.c_TravelData:setTravelResponseEvent(_travelEvent.event_id)
        getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVTravelMeet", _travelEvent.event_id, _travelEvent.drops, _travelInitResponse.travel_item_chapter[self.tag].stage_id, _unfinishevent, nil, self.tag)
        
        table.remove(self._otherTravelEvent, 1)
    end
end

-- 初始化章节稍等时间中等待时间
function PVTravelPlace:initChapterWaitTime()
    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    local _stage_id = _travelInitResponse.travel_item_chapter[self.tag].stage_id
    local _chapters = _travelInitResponse.chapter

    self._travelWait = {}
    self._otherTravelEvent = {}  -- 未完成的事件

    for k,v in pairs(_chapters) do

        if _stage_id == v.stage_id then

            for k1,v1 in pairs(v.travel) do
                local meetType = self.c_TravelTemplate:getEventTypeByEventID(v1.event_id)
                -- print(meetType.."---meetType---"..v1.time)
                if meetType == 1 and v1.time>0 then
                    v1.isauto = false
                    table.insert(self.placeDataList, v1)
                else
                    table.insert(self._otherTravelEvent, v1)
                end
            end

            break
        end
    end
    local _autoTravel = self.c_TravelData:addTableAutoTime(_travelInitResponse.stage_travel, self.tag)

    for k,v in pairs(_autoTravel) do
        table.insert(self.placeDataList, v)
    end  
end


-- 稍后获得 更新
function PVTravelPlace:update_aftergain()

    self.c_TravelData:subChapterTravel(self.placeDataList[self.cellID+1], self.tag)

    table.remove(self.placeDataList, self.cellID+1)

    self.itemCount = table.nums(self.placeDataList)
    self.tableView:reloadData()
end


-- 结算更新
function PVTravelPlace:update_settle()

    self:updateAward()

    local _drops = getDataProcessor():getGameResourcesResponse(self.placeDataList[self.cellID+1].drops)

    getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops[1])

    self.c_TravelData:subChapterTravel(self.placeDataList[self.cellID+1], self.tag)
    table.remove(self.placeDataList, self.cellID+1)

    -- table.print(self.placeDataList)
    self.itemCount = table.nums(self.placeDataList)

    self.tableView:reloadData()
    self:updateFWZhUI()


end

-- 更新奖励
function PVTravelPlace:updateAward()

    -- getDataProcessor():gainGameResourcesResponse(self.placeDataList[self.cellID+1].drops)

    local drops = getDataProcessor():getGameResourcesResponse(self.placeDataList[self.cellID+1].drops)
    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    self.stage_id = _travelInitResponse.travel_item_chapter[self.tag].stage_id
    if drops[1].type == "travel_item" then
         self.c_TravelData:addTravelItem(self.stage_id, drops[1])
    end

    -- 如果是其他奖励加入
    getDataProcessor():gainGameResourcesResponse(self.placeDataList[self.cellID+1].drops)

end

function PVTravelPlace:initRegisterNetCallBack()
    function onReciveMsgCallBack(_id)
        if _id == NET_ID_TRAVEL_GAINBOX then -- 更新宝箱
            self:updateUIBox()
        elseif _id == NET_ID_TRAVEL then -- 游历
            self:updateTravel()
        elseif _id == NET_ID_TRAVEL_WAITEVENT then -- 稍后获得
            self:update_waitTravel()
        elseif _id == NET_ID_TRAVEL_SETTLE then -- 游历结算  （暂时使用在等待时间和答题两个事件上）
            -- self:update_settle()
       end

       groupCallBack(GuideGroupKey.BTN_YOULI_BAOXIANG)
    end

    self:registerMsg(NET_ID_TRAVEL_WAITEVENT, onReciveMsgCallBack)
    self:registerMsg(NET_ID_TRAVEL, onReciveMsgCallBack)
    self:registerMsg(NET_ID_TRAVEL_GAINBOX, onReciveMsgCallBack)
end

-- 游历
function PVTravelPlace:updateTravel()
    self.btnTravel:setEnabled(true)
    local _TravelResponse = self.c_TravelData:getTravelResponse()
    if not _TravelResponse.res.result then
        if _TravelResponse.res.result_no>0 then
            -- self:toastShow(Localize.query(_TravelResponse.res.result_no))
            getOtherModule():showAlertDialog(nil, Localize.query(_TravelResponse.res.result_no))
            return
        end
        
        getOtherModule():showAlertDialog(nil, "游历失败")
        -- self:toastShow("游历失败")
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelPlace.2"))
        -- self:toastShow(Localize.query(_TravelResponse.res.result_no))
        return
    end
   
    --游历
    self.c_TravelData:addUseNum()
    self:updateShoesUI()

    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    local tagId = _travelInitResponse.travel_item_chapter[self.tag].stage_id
    getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVTravelMeet", _TravelResponse.event_id, _TravelResponse.drops, tagId)
    -- getOtherModule():showOtherView("PVTravelMeet", _TravelResponse.event_id, _TravelResponse.drops, _travelInitResponse.travel_item_chapter[self.tag].stage_id)
end

-- 更新宝箱
function PVTravelPlace:updateUIBox()
    self.openChestResponse = self.c_TravelData:getOpenChestResponse()
    if self.openChestResponse.res.result == false then
        -- self:toastShow("领取失败！")
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelPlace.3"))
        return
    end

    -- 重置宝箱领取时间
    self.c_TravelData:resetChesttime()
    self.texiaoNode:stopActionByTag(100)

    if table.nums(self.openChestResponse.drops.shoes_info) <=0 then
        getOtherModule():showAlertDialog(nil, "领取失败！")
        -- self:toastShow("领取失败！")
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelPlace.3"))
        return
    end

    getOtherModule():showOtherView("PVTravelCongratulations", 9, self.openChestResponse.drops)

    self.c_TravelData:updateShoesNumsByShoesInfo()

    -- 更新UI上鞋子数量
    self:updateShoesUI()
end

-- 更新鞋子  在原来的基础上增加
function PVTravelPlace:updateShoesUI()
    -- print("---------------- 更新鞋子 -----------------------")

    local _shoes = self.c_TravelData:getTravelInitResponse().shoes
    
    self.strawShoesNum:setString(_shoes.shoe1)
    self.clothShoesNum:setString(_shoes.shoe2)
    self.leatherShoesNum:setString(_shoes.shoe3)
    local caoxieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe1")          --购买价格
    local buxieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe2")
    local pixieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe3")

    local x = _shoes.shoe1*caoxieTimes + _shoes.shoe2*buxieTimes + _shoes.shoe3*pixieTimes - _shoes.use_no
   
    local shoes_type = self.c_TravelData:isWhichShoes()
    if shoes_type == 0 then 
        game.setSpriteFrame(self.shoesTyprSp, "#ui_travel_shoes_1.png")
    else
        -- print("--------self.shoesTyprSp-----------------"..(4-_shoes.use_type))
        game.setSpriteFrame(self.shoesTyprSp, "#ui_travel_shoes_"..(4-_shoes.use_type)..".png")
    end

    self.travelNumLabel:setString(tostring(x)..Localize.query("PVTravelPlace.4"))
    
end

-- 更新风物志
function PVTravelPlace:updateFWZhUI()
    -- 更新风物志数量
    -- print("刷新风物志，桃花林页面")
    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    local travel_item = _travelInitResponse.travel_item_chapter[self.tag].travel_item
    local _curNum = table.nums(travel_item)
    local stage_id = _travelInitResponse.travel_item_chapter[self.tag].stage_id
    local _totalNum = self.c_TravelData:getTotalNumFengwuzhi(stage_id)
    self.placeThingNum:setString(string.format("%d/%d", _curNum, _totalNum))
end

-- 更新稍后等待时间列表
function PVTravelPlace:update_waitTravel()

    if self._unfinishevent == 0 then
        local _TravelResponse = self.c_TravelData:getTravelResponse()
        local _eventId = _TravelResponse.event_id
        -- cclog("------PVTravelPlace:update_waitTrave------00000---")
        local meetType = self.c_TravelTemplate:getEventTypeByEventID(_eventId)
        if meetType == 2 then --如果是战斗发过来的return
            return
        end
    end

    self.eventStartResponse = self.c_TravelData:getWaitEventStartResponse()

    if not self.eventStartResponse.res.result then
        if self.eventStartResponse.res.result_no>0 then
            self:toastShow(Localize.query(self.eventStartResponse.res.result_no))
            return
        end
        getOtherModule():showAlertDialog(nil, "事件失败")
        
        -- self:toastShow("事件失败")
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelPlace.5"))
        return
    end
    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    local _TravelResponse = self.c_TravelData:getTravelResponse()

    local travel = {}
    if self._unfinishevent == 0 then
        travel.event_id = _TravelResponse.event_id
        travel.drops = clone(_TravelResponse.drops)
    else
        travel.event_id = self._unfinisheventID
        travel.drops = clone(self._unfinisheventDrops)
    end
    
    travel.time = self.eventStartResponse.time
    table.insert(self.placeDataList, travel)
    self.itemCount = table.nums(self.placeDataList)
    self.tableView:reloadData()
    self:updateInitTravelResponse(travel)
    self._unfinishevent = 0

    if self._scheduerOutputTime == nil then
        self:startTimer()
    end
end


function PVTravelPlace:updateInitTravelResponse(travel)
    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    local _stage_id = _travelInitResponse.travel_item_chapter[self.tag].stage_id
    local _chapters = _travelInitResponse.chapter

    -- cclog("--------updateInitTravelResponse---------")
    -- print(table.nums(_chapters))

    if table.nums(_chapters) > 0 then
        for k,v in pairs(_chapters) do
            -- print(v.stage_id)

            if _stage_id == v.stage_id then

                table.insert(v.travel, travel)
                break
            end
        end
    else
        _travelInitResponse.chapter = {}
        local  chapter = {}
        chapter.stage_id = _stage_id
        chapter.travel = {}
        table.insert(chapter.travel, travel)
        table.insert(_travelInitResponse.chapter, chapter)
    end
end

function PVTravelPlace:onReloadView()

    local goldNUm = self.c_CommonData:getGold()
    self.allGoldLabel:setString(goldNUm)

    if self._scheduerOutputTime == nil then
        self:startTimer()
    end

    if self.isMeetLqTime == true then
        self.isMeetLqTime = false
        self:update_settle()
    end


    -- print("--------- onReloadView ----------------------")
    self:updateFWZhUI()
    self:updateShoesUI()

    self:updateNewPoint()
end

function PVTravelPlace:updateNewPoint()
    local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
    self.stage_id = _travelInitResponse.travel_item_chapter[self.tag].stage_id
    
    self.newSp:setVisible(false)
    if self.c_TravelData:isHaveRedPointFeng(self.stage_id, 2) then 
        self.newSp:setVisible(true)
    end
    if self.c_TravelData:isHaveRedPointFeng(self.stage_id, 3) then
        self.newSp:setVisible(true)
    end
    if self.c_TravelData:isHaveRedPointFeng(self.stage_id, 4) then
        self.newSp:setVisible(true)
    end
    if self.c_TravelData:isHaveRedPointFeng(self.stage_id, 1) then
        self.newSp:setVisible(true)
    end
end


return PVTravelPlace
