--游历
--游历界面，选择游历章节

EXIT_PLACE = "EXIT_PLACE"

local PVTravelCellItem = import(".PVTravelCellItem")

local PVTravelPanel = class("PVTravelPanel", BaseUIView)

function PVTravelPanel:ctor(id)
    self.super.ctor(self, id)

    self.c_TravelData = getDataManager():getTravelData()
    self.travelNet = getNetManager():getTravelNet()
    self.c_CommonData = getDataManager():getCommonData()

    self.tag = 1
end

function PVTravelPanel:onMVCEnter()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    game.addSpriteFramesWithFile("res/ccb/resource/ui_travel2.plist")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_25_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_4_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_5_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_10_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_20_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_9_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_7_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_6_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_2_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_26_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_19_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_24_all.plist")
    game.addSpriteFramesWithFile("res/ccb/card/stage_monster_25_all.plist")


    self:showAttributeView()
    self.UITravelChapterView = {}
    self.curCellItem = nil
    self.travel = {}
    self.travelInitResponse = self.c_TravelData:getTravelInitResponse()
  
    self:initTouchListener()

    self:loadCCBI("travel/ui_travel_view.ccbi", self.UITravelChapterView)

    self:initView()


    -- 
    self.travelNet:sendGetTravelInitResponse()

    local function exitcallFunc()
        print("------章节界面刷新---------")
        self.travelNet:sendGetTravelInitResponse()
        -- self:updateView()
    end
    self.listener4 = cc.EventListenerCustom:create(EXIT_PLACE, exitcallFunc)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener4, 1)
    
    self:initRegisterNetCallBack()
    
end

function PVTravelPanel:onExit()
    cclog("---PVTravelPanel:onExit----")
    self:unregisterScriptHandler()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel2.plist")

    self:getEventDispatcher():removeEventListener(self.listener4)


    if self.scheduerOutputTime ~= nil then
        timer.unscheduleGlobal(self.scheduerOutputTime)
        self.scheduerOutputTime = nil
    end
    
end

function PVTravelPanel:initView()
    self.travelContentLayer = self.UITravelChapterView["UITravelChapterView"]["travelContentLayer"]
    
    self.firstDiName = self.UITravelChapterView["UITravelChapterView"]["firstDiName"]
    self.travelPlaceBg = self.UITravelChapterView["UITravelChapterView"]["travelPlaceBg"]
    self.itemFirstLayer1 = self.UITravelChapterView["UITravelChapterView"]["itemFirstLayer1"]   -- 游历中
    self.itemFirstLayer2 = self.UITravelChapterView["UITravelChapterView"]["itemFirstLayer2"]   -- 开启
    self.firstTimeLabel1 = self.UITravelChapterView["UITravelChapterView"]["firstTimeLabel1"]   -- 游历 10:25:46
    self.firstConditionlabel2 = self.UITravelChapterView["UITravelChapterView"]["firstConditionlabel2"]  --开启条件：集齐前一章内所有风物志
    self.travelCellDes = self.UITravelChapterView["UITravelChapterView"]["travelCellDes"]  -- 章节描述
    self.newSp = self.UITravelChapterView["UITravelChapterView"]["newSp"]     -- 风物志 红点
    self.placeThingNum = self.UITravelChapterView["UITravelChapterView"]["placeThingNum"] -- 风物志数量  16/20
    self.startTravelBtn = self.UITravelChapterView["UITravelChapterView"]["startTravelBtn"]

    -- 宝箱
    self.travelGoldSprite = self.UITravelChapterView["UITravelChapterView"]["travelGoldSprite"]
    self.travelGoldNumber = self.UITravelChapterView["UITravelChapterView"]["travelGoldNumber"]
    self.texiaoNode = self.UITravelChapterView["UITravelChapterView"]["texiaoNode"]
    --鞋子数量
    self.strawShoesNum = self.UITravelChapterView["UITravelChapterView"]["strawShoesNum"]
    self.clothShoesNum = self.UITravelChapterView["UITravelChapterView"]["clothShoesNum"]
    self.leatherShoesNum = self.UITravelChapterView["UITravelChapterView"]["leatherShoesNum"]

    --判断今天宝箱是否领取
    local _isHasGain = self.c_TravelData:isHasGain()
    if not _isHasGain then
        self.travelGoldSprite:setVisible(true)
        local function callBack()
            self.texiaoNode:removeAllChildren()
            local node2 = UI_Youlibaoxiang() 
            self.texiaoNode:addChild(node2)
        end
        local sequence = cc.Sequence:create(cc.CallFunc:create(callBack), cc.DelayTime:create(1.5))
        self.repeatAction = cc.RepeatForever:create(sequence)
        self.repeatAction:setTag(100)
        self.texiaoNode:runAction(self.repeatAction)
    else

        self.travelGoldSprite:setVisible(false)
    end


    self:setTravelDes()

    self.scrollView = cc.ScrollView:create()
    local screenSize = self.travelContentLayer:getContentSize()
    if nil ~= self.scrollView then

        self.scrollView:setViewSize(cc.size(screenSize.width, screenSize.height))
        self.scrollView:ignoreAnchorPointForPosition(true)

        self.scrollView:setDirection(0)
        self.scrollView:setClippingToBounds(true)
        self.scrollView:setBounceable(true)
        self.scrollView:setDelegate()

    end
    self.travelContentLayer:removeAllChildren()
    self.travelContentLayer:addChild(self.scrollView)
  
    self:initScrollViewTouchEvent()
end

function PVTravelPanel:setTravelDes( ... )

    local _str = string.format("#ui_travel_di_%d.png",self.tag)
    game.setSpriteFrame(self.firstDiName, _str)
    local _strBg = string.format("res/ccb/effectpng/ui_travel_bg_%d.jpg",self.tag)
    print(_strBg)
    game.setSpriteFrame(self.travelPlaceBg, _strBg)
    
    local _chapter = self.travelInitResponse.travel_item_chapter[self.tag].stage_id
    local des = getTemplateManager():getInstanceTemplate():getDesById(_chapter) 
    self.travelCellDes:setString(des)

    self.newSp:setVisible(false)

    -- 更新风物志数量
    local _curNum = table.nums(self.travelInitResponse.travel_item_chapter[self.tag].travel_item)
    local _totalNum = self.c_TravelData:getTotalNumFengwuzhi(_chapter)
    self.placeThingNum:setString(string.format("%d/%d", _curNum, _totalNum))


    -- if  没有开启
    local _isOpen = self.travelInitResponse.travel_item_chapter[self.tag].isOpen
    if not _isOpen then

        self.placeThingNum:setVisible(false)
        self.itemFirstLayer2:setVisible(true)
        self.itemFirstLayer1:setVisible(false)

        self.startTravelBtn:setEnabled(false)
    else
        --  游历中 倒计时
        -- 如果没有游历中，隐藏。。。。

        self.itemFirstLayer2:setVisible(false)
        self.startTravelBtn:setEnabled(true)

        local _travelInit = self.c_TravelData:getTravelInitResponse()
        local isIntoTraveling = self.c_TravelData:getIsIntoTraveling(_travelInit.stage_travel, self.tag)
      
        if isIntoTraveling == 1 or isIntoTraveling == 2  then
            local isIntoTravelingNUm = self.c_TravelData:getIsIntoTravelingNum(_travelInit.stage_travel, self.tag)
            self.itemFirstLayer1:setVisible(true)
            if isIntoTraveling == 1 then
                local _travelInit = self.c_TravelData:getTravelInitResponse()

                local autoT = nil
                for k,v in pairs(_travelInit.stage_travel) do
                    if v.stage_id == self.sta then
                        autoT = v.auto_travel
                    end
                end
                if autoT ~= nil then
                    local auto_travel = autoT[isIntoTravelingNUm]
                    local startTime = auto_travel.start_time
                    local continuedTime = auto_travel.continued_time
                    local finishTime = startTime + continuedTime*60

                    self.time = finishTime - self.c_CommonData:getTime()
                    self.firstTimeLabel1:setString(string.format("%02d:%02d:%02d",math.floor(self.time/3600), math.floor(self.time%3600/60), self.time%60))
                    self:startTimer()
                else
                    -- print("--------else-----------")
                end 
            end
            if isIntoTraveling == 2 then
                self.firstTimeLabel1:setString("领取自动游历奖励")
            end
        else
            self.itemFirstLayer1:setVisible(false)
        end
    end
end

function PVTravelPanel:initScrollViewContent()
    -- local _itemCount = 8
    self.scrollView:getContainer():removeAllChildren()
    
    local _itemCount = table.nums(self.travelInitResponse.travel_item_chapter)
    local cell_width = 129
    local cell_height = 300
    local m_cloum = _itemCount

    local _containerSize = cell_width * (_itemCount+1)    ---(math.floor(_itemCount/2)+_itemCount%2) * cell_height

    self.scrollView:setContentSize(_containerSize, self.scrollView:getViewSize().height)
    -- self.scrollView:updateInset()
    self.scrollView:setContentOffset(cc.p(self.scrollView:minContainerOffset().x, 0))

    for i=1, _itemCount+1 do
        local cell = PVTravelCellItem.new()
        cell:initData(i, self.tag)
        cell:setAnchorPoint(cc.p(0, 0))
        cell:setContentSize(cell_width, cell_height)
        local _x = i-1
 
        -- local rowIndex = _x%m_cloum;
        -- local indexPath = math.floor(_x/m_cloum)

        local _posx = _x * cell_width
        local _posy = 0

        cell:setPosition(_posx, _posy)

        self.scrollView:getContainer():addChild(cell)
        -- cell:autorelease()
    end

end

function PVTravelPanel:inTouchSide(point)

    local _children = self.scrollView:getContainer():getChildren()

    for k,v in pairs(_children) do
        
        local _point = v:convertToNodeSpace(point)

        local posx, posy = v:getPosition()
        local rectArea = cc.rect(0, 0, v:getContentSize().width, v:getContentSize().height)

        local isInRect = cc.rectContainsPoint(rectArea, _point)
        
        if isInRect then
            -- local _isTouch = v:isTouchEvent(point)

            -- if _isTouch then
                return v
            -- end
        end
    end

    return nil
end

function PVTravelPanel:initScrollViewTouchEvent()

    -- local rectArea = self.travelContentLayer:getBoundingBox() 
    local rectArea = cc.rect(0, 0, self.travelContentLayer:getContentSize().width, self.travelContentLayer:getContentSize().height)
    local _isMoving =  false
    local _startPos = cc.p(0, 0)

    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            _startPos = cc.p(x,y)
            local _point = self.travelContentLayer:convertToNodeSpace(_startPos)
            local isInRect = cc.rectContainsPoint(rectArea, _point)
            if isInRect then
                -- print("=onTouchEvent==true")
                self.curCellItem = self:inTouchSide(cc.p(x, y))
                if self.curCellItem then
                    return true
                else
                    return false
                end
            else
                -- print("=onTouchEvent==false")
                return false
            end

        elseif  eventType == "moved" then

            local _pox = _startPos.x - x
            local _poy = _startPos.y - y

            if math.abs(_pox)>5.0 or math.abs(_poy)>5.0 then
                _isMoving = true
            end
        elseif  eventType == "ended" then

            if not _isMoving and self.curCellItem ~= nil then
                self:touchEventFunc()
            end
            _isMoving = false
        end
    end

    self.travelContentLayer:registerScriptTouchHandler(onTouchEvent)
    self.travelContentLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.travelContentLayer:setTouchEnabled(true)
end

function PVTravelPanel:touchEventFunc()
    if self.curCellItem ~= nil then
        -- self.curCellItem:executeHandelEvent()

        print("点击："..self.curCellItem.tag)
        
        self.travelInitResponse = self.c_TravelData:getTravelInitResponse()
        local _itemCount = table.nums(self.travelInitResponse.travel_item_chapter)
        if self.curCellItem.tag >= _itemCount + 1 then
            return
        end

        self.tag = self.curCellItem.tag
        self:updateUIData()

        -- self.scrollView:reloadData()
    end
end

-- 更新UI
--@param id 网络协议号
function PVTravelPanel:updateUIData(id)
    cclog("====updateUIData====")

    self.travelInitResponse = self.c_TravelData:getTravelInitResponse()
    self:initScrollViewContent();

    self:setTravelDes()
end


function PVTravelPanel:initTouchListener()

    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()

    end

    local function startTravelClick()
        
        local _isOpen = self.travelInitResponse.travel_item_chapter[self.tag].isOpen
        if not _isOpen then
            return
        end

        local _travelInit = self.c_TravelData:getTravelInitResponse()
        local isIntoTraveling = self.c_TravelData:getIsIntoTraveling(_travelInit.stage_travel, self.tag)

        if isIntoTraveling == 1 or isIntoTraveling == 2  then   --进入游历中界面
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelTraveling", self.tag)
        else
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelPlace", self.tag)
        end
        groupCallBack(GuideGroupKey.BTN_TAO_YUAN)

    end

    local function toFengwuzhi()
    
        getAudioManager():playEffectButton2()
        
        local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVTravelFengwuzhi", _travelInitResponse.travel_item_chapter[self.tag].stage_id, self.tag)
    end

    --宝箱
    local function onGoldBtn()
        getAudioManager():playEffectButton2()

        self.travelNet:sendGetGainBox()
        print("onGoldBtn-----")
    end

    --
    --物品
    local function onLookShoes1()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 1)
    end
    --物品
    local function onLookShoes2()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 2)
    end

    --物品
    local function onLookShoes3()
        getAudioManager():playEffectButton2()
        getOtherModule():showOtherView("PVTravelPropItem", 1, 3)
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

    self.UITravelChapterView["UITravelChapterView"] = {}
    self.UITravelChapterView["UITravelChapterView"]["onCloseClick"] = onCloseClick
    self.UITravelChapterView["UITravelChapterView"]["startTravelClick"] = startTravelClick
    self.UITravelChapterView["UITravelChapterView"]["toFengwuzhi"] = toFengwuzhi
    self.UITravelChapterView["UITravelChapterView"]["onGoldBtn"] = onGoldBtn

    self.UITravelChapterView["UITravelChapterView"]["onLookShoes1"] = onLookShoes1
    self.UITravelChapterView["UITravelChapterView"]["onLookShoes2"] = onLookShoes2
    self.UITravelChapterView["UITravelChapterView"]["onLookShoes3"] = onLookShoes3
    self.UITravelChapterView["UITravelChapterView"]["onAddStrawShoesNum"] = onAddStrawShoesNum
    self.UITravelChapterView["UITravelChapterView"]["onAddClothShoesNum"] = onAddClothShoesNum
    self.UITravelChapterView["UITravelChapterView"]["onAddLeatherShoesNum"] = onAddLeatherShoesNum
    
end

function PVTravelPanel:initRegisterNetCallBack()
    function onReciveMsgCallBack(_id)
        if _id == NET_ID_TRAVEL_INIT then -- 初始化UI
            self:updateUIData(_id)
        elseif _id == NET_ID_TRAVEL_GAINBOX then -- 更新宝箱
            self:updateUIBox()
        end
    end

    self:registerMsg(NET_ID_TRAVEL_INIT, onReciveMsgCallBack)
    self:registerMsg(NET_ID_TRAVEL_GAINBOX, onReciveMsgCallBack)
end

function PVTravelPanel:onReloadView()

    self:updateShoesUI()
   
end

-- 更新宝箱
function PVTravelPanel:updateUIBox()

    print("-------------更新宝箱--------------")
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
function PVTravelPanel:updateShoesUI()
    print("---------------- 更新鞋子 -----------------------")
    local _shoes = self.c_TravelData:getTravelInitResponse().shoes
    self.strawShoesNum:setString(_shoes.shoe1)
    self.clothShoesNum:setString(_shoes.shoe2)
    self.leatherShoesNum:setString(_shoes.shoe3)
end

function PVTravelCellItem:startTimer()

    local function updateTimer(dt)
        if self.time == nil then self.scheduerOutputTime = nil return end
        if self.time <= 0 then  return end
        self.time = self.time - dt
        self.firstTimeLabel1:setString(string.format("%02d:%02d:%02d",math.floor(self.time/3600), math.floor(self.time%3600/60), self.time%60))
        if self.time <= 0 then 
            self.time = 0
            -- print("时间到")
            self.firstTimeLabel1:setString("领取自动游历奖励")
            timer.unscheduleGlobal(self.scheduerOutputTime)
            self.scheduerOutputTime = nil
        end
    end
    self.scheduerOutputTime = timer.scheduleGlobal(updateTimer, 1.0)

end

return PVTravelPanel

