--游历
--游历偶遇

UPDATE_FIGHTGAIN = "UPDATE_FIGHTGAIN"

local PVTravelMeet = class("PVTravelMeet", BaseUIView)

g_PVTravelMeet = nil

function PVTravelMeet:ctor(id)
    self.super.ctor(self, id)
    self.curRequestType = 0

    self.commonData = getDataManager():getCommonData()
    self.c_TravelData = getDataManager():getTravelData()
    self.c_TravelTemplate = getTemplateManager():getTravelTemplate()
end

function PVTravelMeet:onMVCEnter()
    self.UITravelMeet = {}
    self:initTouchListener()
    self.curSelectIndex = -1
    self.settleType = 1   -- 1,回答问题，2，稍后获得
    --加载本界面的ccbi
    self:loadCCBI("travel/ui_travel_meet.ccbi", self.UITravelMeet)

    -- print("***************")

    self:initView()   

    self:initRegisterNetCallBack()

    self:initData() 

    local function update_fightaftergain()
         self:updateAwardAfterFight()
    end

    self.listener = cc.EventListenerCustom:create(UPDATE_FIGHTGAIN, update_fightaftergain)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

end

function PVTravelMeet:onExit()
    -- self:unregisterScriptHandler()
    self:getEventDispatcher():removeEventListener(self.listener)

    if self._scheduerOutputTime ~= nil then
        timer.unscheduleGlobal(self._scheduerOutputTime)
        self._scheduerOutputTime = nil
    end

    getDataManager():getResourceData():clearResourcePlistTexture()
end


function PVTravelMeet:updateView(param)
    -- print("---param---")
    if param[1] ~= nil then
        local t = getDataManager():getFightData():getFightType()
        if t == TYPE_TRAVEL then
            -- getDataManager():getFightData():setFightType(TYPE_STAGE_NORMAL)
            -- self:updateAwardAfterFight()
            local _travel = {}
            _travel.event_id = self.eventID
            self.c_TravelData:subChapterTravel(_travel, 1)
        end
    end

    if TRAVEL_WIN ~= nil then
        if TRAVEL_WIN == false then
            self:onHideView()
        else
            self:updateAwardAfterFight()
        end
    end

    TRAVEL_WIN = nil
    -- local _travel = {}
    -- _travel.event_id = self.eventID
    -- self.c_TravelData:subChapterTravel(_travel, self.tag)
end

function PVTravelMeet:initView()
   
    self.meetDes = self.UITravelMeet["UITravelMeet"]["gaorenDes"]
    self.travelJLNum = self.UITravelMeet["UITravelMeet"]["travelJLNum"]

    self.peopleTitleLabel = self.UITravelMeet["UITravelMeet"]["peopleTitleLabel"]

    --描述
    self.timeLayer =self.UITravelMeet["UITravelMeet"]["travelGaorenLayer"]
    self.fightLayer =self.UITravelMeet["UITravelMeet"]["travelHuangjinjunLayer"]
    self.askLayer = self.UITravelMeet["UITravelMeet"]["travelAskLayer"] 
    self.atOnceLayer = self.UITravelMeet["UITravelMeet"]["travelJinlianLayer"]

    self.askGaorenBtn = self.UITravelMeet["UITravelMeet"]["askGaorenBtn"]
    self.waitBtn = self.UITravelMeet["UITravelMeet"]["waitBtn"]
    
    --图片
    self.peopleSprite = self.UITravelMeet["UITravelMeet"]["peopleSprite"]
    
    --需要消耗的元宝数
    self.meetPrice = self.UITravelMeet["UITravelMeet"]["goldNumberGaoren"]
    
    self.goldNumberHJJ = self.UITravelMeet["UITravelMeet"]["goldNumberHJJ"]

    --询问高人界面   和   得道高人界面
    self.travelMeetLayer = self.UITravelMeet["UITravelMeet"]["UITravelMeetLayer"] 
    self.travelMeetLayer:setVisible(true)
    self.travelAskLayer = self.UITravelMeet["UITravelMeet"]["uiTravelAskLayer"]
    self.travelAskLayer:setVisible(false)

    self.travelLabel = self.UITravelMeet["UITravelMeet"]["uiTravelAsk"]
    self.peopleSprite = self.UITravelMeet["UITravelMeet"]["peopleSprite"]

    self.itemicon = self.UITravelMeet["UITravelMeet"]["itemicon"]
    self.itemicon:setVisible(false)

    self.jiangliTypeSprite = self.UITravelMeet["UITravelMeet"]["jiangliTypeSprite"]
    -- self.jiangliTypeSprite:setScale(0.73)
    self.newSp = self.UITravelMeet["UITravelMeet"]["newSp"]

    self.timeLabel = self.UITravelMeet["UITravelMeet"]["timeLabel"]
    self.goldNode = self.UITravelMeet["UITravelMeet"]["goldNode"]
end

function PVTravelMeet:initData()
    self.eventID = self:getTransferData()[1]  -- 事件编号

    local npc = self.c_TravelTemplate:getNPCNameByEventID(self.eventID)
    self.peopleTitleLabel:setString(npc)

    
    -- self.meetJLId = self:getTransferData()[2]     -- 奖励编号
    self.GameResourcesdrops = self:getTransferData()[2]  -- 奖励掉落
    self.drops = getDataProcessor():getGameResourcesResponse(self.GameResourcesdrops)
    self.stage_id = self:getTransferData()[3]     -- 章节号
    self.afterGain = self:getTransferData()[4]    -- 
    self.delegate = self:getTransferData()[5]
    self.tag = self:getTransferData()[6]
    self.start_time = self:getTransferData()[7]     

    local meetType = self.c_TravelTemplate:getEventTypeByEventID(self.eventID)
    
    local _meetDes = self.c_TravelTemplate:getDiscriptionByEventID(self.eventID)

    --  --获得的奖励
    local detailID = 0 
    local meetNum = 0
    local detailName = ""
   
    if self.drops[1].type == "finance" then
        
        if self.drops[1].coin ~= nil and self.drops[1].coin > 0 then
            meetNum = self.drops[1].coin
            detailName = "银两"
            self.c_TravelData:changeFengIconImage(self.jiangliTypeSprite, 0 ,false) 
        end

        if self.drops[1].hero_soul ~= nil and self.drops[1].hero_soul>0 then 
            
            meetNum = self.drops[1].hero_soul
            detailName = "武魂"
            setItemImage3(self.jiangliTypeSprite, "res/icon/resource/resource_3.png", 1)
        end

        if self.drops[1].finance_changes ~= nil then
            -- print(self.drops[1].finance_changes)
            -- print(table.nums(self.drops[1].finance_changes))
            -- print("-------------finance_changes")
            for k,v in pairs(self.drops[1].finance_changes) do
                meetNum = v.item_num
                local _resourceTemp = getTemplateManager():getResourceTemplate()
                local _icon = _resourceTemp:getResourceById(v.item_no)
                setItemImage3(self.jiangliTypeSprite, "res/icon/resource/".._icon, 1)
                detailName = _resourceTemp:getResourceName(v.item_no)
            end
        end
    end

    if self.drops[1].type == "travel_item" then
        print("-------------travel_item")

        meetNum = self.drops[1][1].num
        detailName = self.c_TravelTemplate:getFentWuzhiByAwardId(self.drops[1][1].id)
        self.c_TravelData:changeFengIconImage(self.jiangliTypeSprite, self.drops[1][1].id)

        if self.c_TravelData:setIsHaveFengWuZhi(self.drops[1][1].id) then
            self.newSp:setVisible(false)
        else
            self.newSp:setVisible(true)
        end
    end
    --local a = string.gsub( tostring(self.meetDes) ,"\\n","\n")
    self.meetDes:setString(_meetDes.." "..detailName.."X"..meetNum)

    self.travelJLNum:setString(string.format("X%d", meetNum))

    --是否显示访问高人按钮
    local _ask = self.c_TravelTemplate:isShowAskByEventID(self.eventID)
    if _ask == nil or string.len(_ask)<=0 then
        self.askGaorenBtn:setVisible(false)
    else
        self.askGaorenBtn:setVisible(true)
        --按钮上显示的字
        local askBtnName = self.c_TravelTemplate:getAskDisByEventID(self.eventID)
        -- print("askBtnName  :::::::::   " .. askBtnName)
    end

    local resPath = self.c_TravelTemplate:getResNameByeventID(self.eventID)
    print("---------------")
    print(resPath)
    print("---------------")
    -- game.setSpriteFrame(self.peopleSprite, resPath)
    self.peopleSprite:setSpriteFrame(resPath)

    cclog(resPath)

    self._meetPrice = self.c_TravelTemplate:getPriceByeventID(self.eventID)

    -- print(">>>>>>>>"..self._meetPrice)
    self.meetPrice:setString(self._meetPrice)

    if meetType == 1 then --等待时间  -- 
        -- print("+++++shijian+++++")

        self.timeLayer:setVisible(true)
        self.fightLayer:setVisible(false)
        self.askLayer:setVisible(false)
        self.atOnceLayer:setVisible(false)

        self._time = self.c_TravelTemplate:getTimeByEventID(self.eventID)*60
        self.timeLabel:setString(string.format("%02d:%02d:%02d",math.floor(self._time/3600), math.floor(self._time%3600/60), self._time%60))

        if self.afterGain == 1 then
            -- print("++++++++++")
            -- self.waitBtn:setEnabled(false)
            -- SpriteGrayUtil:drawSpriteTextureGray(self.waitBtn:getNormalImage())

            local _timeAll = self.c_TravelTemplate:getTimeByEventID(self.eventID)
            _timeAll = tonumber(_timeAll)
            if self.start_time then    --自动游历的等待时间
                -- print("+++++++start_time++++")
                self._time = _timeAll*60 - (getDataManager():getCommonData():getTime() - self.start_time)
                if self._time < 0 then self._time = 0 end
                self.timeLabel:setString(string.format("%02d:%02d:%02d",math.floor(self._time/3600), math.floor(self._time%3600/60), self._time%60))
                self.timeLabel:setColor(ui.COLOR_GREEN)
                if self._time <= 0 then 
                    self.timeLabel:setVisible(false)
                    self.waitBtn:setVisible(false)
                    self._meetPrice = 0
                    self.meetPrice:setString(self._meetPrice)
                    self.goldNode:setVisible(false)
                    return
                end
                self:startTimer()
                return

            else    --手动游历的等待时间

                local _travelInitResponse = self.c_TravelData:getTravelInitResponse()
                local _chapters = _travelInitResponse.chapter

                for k,v in pairs(_chapters) do

                    if self.stage_id == v.stage_id then

                        for k1,v1 in pairs(v.travel) do
                            local meetType = self.c_TravelTemplate:getEventTypeByEventID(v1.event_id)
                            if meetType == 1 and v1.time>0 then
                                if v1.event_id == self.eventID then
                                    self.start_time = v1.time
                                    self._time = _timeAll*60 - (getDataManager():getCommonData():getTime() - self.start_time)
                                    
                                    if self._time < 0 then self._time = 0 end
                                    self.timeLabel:setString(string.format("%02d:%02d:%02d",math.floor(self._time/3600), math.floor(self._time%3600/60), self._time%60))
                                    self.timeLabel:setColor(ui.COLOR_GREEN)
                                    if self._time <= 0 then 
                                        self.timeLabel:setVisible(false)
                                        self.waitBtn:setVisible(false)
                                        self._meetPrice = 0
                                        self.meetPrice:setString(self._meetPrice)
                                        self.goldNode:setVisible(false)
                                        return
                                    end
                                    self:startTimer()
                                    return
                                end
                            end
                        end

                        break
                    end
                end

            end
        end


    elseif meetType == 2 then  --战斗
 
        self.goldNumberHJJ:setString(self._meetPrice)

        self.timeLayer:setVisible(false)
        self.fightLayer:setVisible(true)
        self.askLayer:setVisible(false)
        self.atOnceLayer:setVisible(false)

    elseif meetType == 3 then

        self.timeLayer:setVisible(false)
        self.fightLayer:setVisible(false)
        self.askLayer:setVisible(true)
        self.atOnceLayer:setVisible(false)

        --为4个menu随机获取1——4的一个编号，根据编号判断它的答案
        math.randomseed(os.time())
        self.btnNumber1 = math.random(1,4)
        self.btnNumber2 = math.random(1,4)
        while self.btnNumber2 == self.btnNumber1 do
            self.btnNumber2 = math.random(1,4)
        end
        self.btnNumber3 = math.random(1,4)
        while self.btnNumber3 == self.btnNumber1 or self.btnNumber3 == self.btnNumber2 do
            self.btnNumber3 = math.random(1,4)
        end
        self.btnNumber4 = 10-self.btnNumber1-self.btnNumber2-self.btnNumber3
        print(self.btnNumber1..".........."..self.btnNumber2..".........."..self.btnNumber3..".........."..self.btnNumber4)

        --四个答案
        self.answer_question = {}
        local btnName1, languageId,languageId2 = self.c_TravelTemplate:getFourAnswerByeventID(self.eventID, self.btnNumber1)
        table.insert(self.answer_question, languageId2)
        local btnName2 , languageId,languageId2= self.c_TravelTemplate:getFourAnswerByeventID(self.eventID, self.btnNumber2)
        table.insert(self.answer_question, languageId2)
        local btnName3,languageId,languageId2 = self.c_TravelTemplate:getFourAnswerByeventID(self.eventID, self.btnNumber3)
        table.insert(self.answer_question, languageId2)
        local btnName4,languageId,languageId2 = self.c_TravelTemplate:getFourAnswerByeventID(self.eventID, self.btnNumber4)
        table.insert(self.answer_question, languageId2)

        local answerLabel =  "甲:"..btnName1.." 乙:"..btnName2.." 丙:"..btnName3.." 丁:"..btnName4
        self.meetDes:setString(_meetDes.." "..detailName.."X"..meetNum.."\n"..answerLabel)

        -- self.languageId2  = 4*100000000 + self.eventID*10+1 
        
    elseif meetType == 4 then
        --print("meetType   44444444444")
        self.timeLayer:setVisible(false)
        self.fightLayer:setVisible(false)
        self.askLayer:setVisible(false)
        self.atOnceLayer:setVisible(true)
    end
end


function PVTravelMeet:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        if self._scheduerOutputTime ~= nil then
            timer.unscheduleGlobal(self._scheduerOutputTime)
            self._scheduerOutputTime = nil
        end
        self:onHideView()
    end

    --有等待时间的事件
    local function askGaorenBtnEvent()  --询问高人
        self.travelMeetLayer:setVisible(false)
        self.travelAskLayer:setVisible(true)
        self.newSp:setVisible(false)
        
        local askCn = self.c_TravelTemplate:getAskWorldByEventID(self.eventID)
        local a = string.gsub( tostring(askCn) ,"\\n","\n")
        self.travelLabel:setString(a)
    end

    local function waitBtnEvent()       --稍后获得
        getAudioManager():playEffectButton2()

        if self.afterGain == 1 then
            if self._scheduerOutputTime ~= nil then
                timer.unscheduleGlobal(self._scheduerOutputTime)
                self._scheduerOutputTime = nil
            end
            self:onHideView()
            return
        end

        local data = {stage_id=self.stage_id, event_id=self.eventID}

        self.curRequestType = 1
        getNetManager():getTravelNet():sendWaitEventStartRequest(data)

        self.settleType = 2
        if self._scheduerOutputTime ~= nil then
            timer.unscheduleGlobal(self._scheduerOutputTime)
            self._scheduerOutputTime = nil
        end
        self:onHideView()
    end

    local function atOnceEvent()        --立即获得
        getAudioManager():playEffectButton2()

        if self.commonData:getGold() < self._meetPrice then
            -- self:toastShow(Localize.query("shop.8"))
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
            return
        end

        -- self:onHideView()
        if self.tag~=nil and self.tag == true then
            local data = {
                stage_id=self.stage_id,
                event_id=self.eventID,
                start_time = self.start_time,
                settle_type = 1
                }
            getNetManager():getTravelNet():sendSettleAutoTravel(data)
        else

            if self._meetPrice == 0 then
                self.settleType = 2
                local data = {}
                data.stage_id = self.stage_id
                data.event_id = self.eventID
                getNetManager():getTravelNet():sendTravelSettleRequest(data)
                return
            end
            local data = {stage_id=self.stage_id, event_id=self.eventID}
            getNetManager():getTravelNet():sendNoWaitRequest(data)
        end
    end

    --需要玩家进行战斗的事件弹框
    local function intoFightEvent()     --进入战斗
        getAudioManager():playEffectButton2()

        local data = {stage_id=self.stage_id, event_id=self.eventID}
        self.curRequestType = 2
        getNetManager():getTravelNet():sendWaitEventStartRequest(data)

        --  stage = self.c_TravelTemplate:getFightEventStageID(self.eventID)

        -- self:onHideView()
        -- cclog("stage="..stage)
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", stage, "travel")
        -- stage = nil
    end

    local function atOnceGet()          --立即获得
        getAudioManager():playEffectButton2()

        if self.commonData:getGold() < self._meetPrice then
            -- self:toastShow(Localize.query("shop.8"))
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
            return
        end

        -- self:onHideView()
        local data = {stage_id=self.stage_id, event_id=self.eventID}
        getNetManager():getTravelNet():sendNoWaitRequest(data)
    end
    
    ----玩家回答问题领取奖励的事件弹框
    local function answerABtnEvent()    --A
        self:answerQuestion(2, 1)
    end

    local function answerBBtnEvent()    --B 
        self:answerQuestion(2, 2)
    end

    local function answerCBtnEvent()    --C
       self:answerQuestion(2, 3)

    end

    local function answerDBtnEvent()    --D
        self:answerQuestion(2, 4)
        
    end

    --玩家可直接领取奖励的事件弹框
    local function onGetEvent()          --领取
        getAudioManager():playEffectButton2()
         -- 更新奖励
        self:updateAward()
        -- 更新风物志奖励
        local event = cc.EventCustom:new(UPDATE_FWZhUI)
        self:getEventDispatcher():dispatchEvent(event)

        _drops = self.drops[1]
        if self._scheduerOutputTime ~= nil then
            timer.unscheduleGlobal(self._scheduerOutputTime)
            self._scheduerOutputTime = nil
        end
        self:onHideView()
        getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops)
        _drops = nil
        
    end

    local function btnMakeSure() 
        self.travelMeetLayer:setVisible(true)
        self.travelAskLayer:setVisible(false)
        if self.c_TravelData:setIsHaveFengWuZhi(self.drops[1][1].id) then
            self.newSp:setVisible(false)
        else
            self.newSp:setVisible(true)
        end
        -- 判断是否风物志道具
        if self.drops[1].type == "travel_item" then
            if getDataManager():getTravelData():setIsHaveFengWuZhi(self.drops[1][1].id) then
                self.newSp:setVisible(false)
            else
                self.newSp:setVisible(true)
            end 
        end
    end

    self.UITravelMeet["UITravelMeet"] = {}
    --等待
    self.UITravelMeet["UITravelMeet"]["askGaorenBtnEvent"] = askGaorenBtnEvent
    self.UITravelMeet["UITravelMeet"]["waitBtnEvent"] = waitBtnEvent
    self.UITravelMeet["UITravelMeet"]["atOnceEvent"] = atOnceEvent
    --
    self.UITravelMeet["UITravelMeet"]["intoFightEvent"] = intoFightEvent
    self.UITravelMeet["UITravelMeet"]["atOnceGet"] = atOnceGet
    --
    self.UITravelMeet["UITravelMeet"]["answerABtnEvent"] = answerABtnEvent
    self.UITravelMeet["UITravelMeet"]["answerBBtnEvent"] = answerBBtnEvent
    self.UITravelMeet["UITravelMeet"]["answerCBtnEvent"] = answerCBtnEvent
    self.UITravelMeet["UITravelMeet"]["answerDBtnEvent"] = answerDBtnEvent
    --
    self.UITravelMeet["UITravelMeet"]["onGetEvent"] = onGetEvent

    self.UITravelMeet["UITravelMeet"]["btnMakeSure"] = btnMakeSure
end

function PVTravelMeet:answerQuestion(_type, index)
    -- -- 更新风物志奖励
    -- local event = cc.EventCustom:new(UPDATE_FWZhUI)
    -- self:getEventDispatcher():dispatchEvent(event)
    if _type == 2 then  -- 回答问题
        local data = {}
        data.stage_id = self.stage_id
        data.event_id = self.eventID

        local num = 0
        if index == 1 then num = self.btnNumber1 end
        if index == 2 then num = self.btnNumber2 end
        if index == 3 then num = self.btnNumber3 end
        if index == 4 then num = self.btnNumber4 end

        data.parameter = self.c_TravelTemplate:getAnswerIdByeventID(self.eventID, num)
        
        self.curSelectIndex = index
        self.settleType = 1

        -- cclog("-----answerQuestion----")
        -- table.print(data)
        getNetManager():getTravelNet():sendTravelSettleRequest(data)
    else  -- 稍后获得

    end
end

-- 结算更新
function PVTravelMeet:update_settle()
    local _TravelSettleResponse = self.c_TravelData:getTravelSettleResponse()
    if not self:handelCommonResResult(_TravelSettleResponse.res) then
        return
    end

    if self.settleType == 1 then
        -- 结算类型  1，回答问题，2，等待时间
        local _answerID = self.answer_question[self.curSelectIndex]
        table.print(self.answer_question)
        print("answer:::::::::::::::".._answerID)

        -- table.print(self.answer_question)

        local _isTrue, _id = self.c_TravelTemplate:isRightAnswerByAnwerID(self.eventID, _answerID)
        -- print("_isTrue:::::::::::::::".._isTrue)
        if _isTrue ~= true then
            -- print("对对对对对对对对对对对对对对对对")
            -- print(_id)
            -- print(self.eventID)
            local _name = getTemplateManager():getLanguageTemplate():getLanguageById(_id)

            local function alertAward()
                _drops = self.drops[1]
                _afterGain = self.afterGain
                if self._scheduerOutputTime ~= nil then
                    timer.unscheduleGlobal(self._scheduerOutputTime)
                    self._scheduerOutputTime = nil
                end
                self:onHideView()
                getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops, _afterGain)
                _drops = nil
                _afterGain = nil
            end

            getOtherModule():showAlertDialog(function() alertAward() end, _name)
        else

            local _travelWrongKeyFeedback = getTemplateManager():getBaseTemplate():getBaseInfoById("travelWrongKeyFeedback")

            local numAll = table.nums(_travelWrongKeyFeedback)
            math.randomseed(os.time())
            local _num = math.random(1,numAll)

            local _id = _travelWrongKeyFeedback[_num]
            print(_id)
            local _toastMessage = getTemplateManager():getLanguageTemplate():getLanguageById(_id)

            -- self:toastShow(_toastMessage)

            self.GameResourcesdrops = _TravelSettleResponse.drops
            self.drops = getDataProcessor():getGameResourcesResponse(_TravelSettleResponse.drops)

             local function alertAward()
                -- _drops = self.drops[1]
                print("回答错误！！！！！！！！！！！！！！！！！")
                drops = getDataProcessor():getGameResourcesResponse(_TravelSettleResponse.drops)
                -- drops = _TravelSettleResponse.drops
                -- table.print(drops)
                -- print("----------------------------------")
                _afterGain = self.afterGain
                if self._scheduerOutputTime ~= nil then
                    timer.unscheduleGlobal(self._scheduerOutputTime)
                    self._scheduerOutputTime = nil
                end
                self:onHideView()
                getOtherModule():showOtherView("PVTravelCongratulations", 0, drops[1], _afterGain)
                drops = nil
                _afterGain = nil
            end
            getOtherModule():showAlertDialog(function() alertAward() end, _toastMessage)
        end

        self:updateAward()
        local event = cc.EventCustom:new(UPDATE_FWZhUI)
        self:getEventDispatcher():dispatchEvent(event)


        self.curSelectIndex = -1
    elseif self.settleType == 2 then -- 有等待时间事件

        self:onHideView()
    end

end

-- (打斗事件和等待时间事件中的立即获得)
function PVTravelMeet:update_nowaitTravel()
    local _NoWaitResponse = self.c_TravelData:getNoWaitResponse()
    -- table.print(_NoWaitResponse)
    -- print("-----PVTravelMeet:update_nowaitTravel----0000-")
    if not _NoWaitResponse.res.result then
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelMeet.1"))
        return
    end

    -- print("-----PVTravelMeet:update_nowaitTravel----22222-")
    -- 更新奖励
    self:updateAward()
    -- if _NoWaitResponse.time > 0 then -- 

    -- end

    -- 扣除立即获取花费的元宝
    -- cclog("self._meetPrice=%d", self._meetPrice)

    getDataManager():getCommonData():subGold(tonumber(self._meetPrice))
    -- print(self.afterGain)
    -- print("-----PVTravelMeet:update_nowaitTravel----0000-")

    if self.afterGain == 1 and self.delegate ~= nil then
        -- print("-----self.afterGain------")
        -- local event = cc.EventCustom:new(UPDATE_WAITGAIN)
        -- self:getEventDispatcher():dispatchEvent(event)
        self.delegate:update_aftergain()
    end
    
    local event = cc.EventCustom:new(UPDATE_FWZhUI)
    self:getEventDispatcher():dispatchEvent(event)

    _drops = self.drops[1]
    if self._scheduerOutputTime ~= nil then
        timer.unscheduleGlobal(self._scheduerOutputTime)
        self._scheduerOutputTime = nil
    end
    self:onHideView()
    getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops)
    _drops = nil
    
end

-- 战斗胜利之后发过来通知加奖励
function PVTravelMeet:updateAwardAfterFight()
    -- UPDATE_FIGHTGAIN
    -- cclog("------PVTravelMeet:updateAwardAfterFight--------")

    self:updateAward()

    local event = cc.EventCustom:new(UPDATE_FWZhUI)
    self:getEventDispatcher():dispatchEvent(event)

    _drops = self.drops[1]
    self:onHideView()
    getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops)
    _drops = nil

    -- self:onHideView()
end

-- 稍后获得返回
function PVTravelMeet:update_waitTravel()
  
    if self.curRequestType == 2 then
        -- 暂时处理战斗之前发834协议
        self.eventStartResponse = self.c_TravelData:getWaitEventStartResponse()

        if not self.eventStartResponse.res.result then
            if self.eventStartResponse.res.result_no>0 then
                -- self:toastShow(Localize.query(self.eventStartResponse.res.result_no))
                getOtherModule():showAlertDialog(nil, Localize.query(self.eventStartResponse.res.result_no))
                return
            end
            
            -- self:toastShow("事件失败")
            getOtherModule():showAlertDialog(nil, Localize.query("PVTravelMeet.2"))
            return
        end

        stage = self.c_TravelTemplate:getFightEventStageID(self.eventID)

        -- self:onHideView()
        cclog("stage="..stage)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", stage, "travel")
        stage = nil
        self.curRequestType = 0
    end
end
function PVTravelMeet:update_waitAutoTravel()
    local _SettleAutoResponse = self.c_TravelData:getSettleAutoResponse()
    if not _SettleAutoResponse.res.result then
        -- self:toastShow("立即获取失败")
        getOtherModule():showAlertDialog(nil, Localize.query("PVTravelMeet.1"))
        return
    end

    getNetManager():getTravelNet():sendGetTravelInitResponse()

    self:updateAward()

    -- 扣除立即获取花费的元宝
    cclog("self._meetPrice=%d", self._meetPrice)

    getDataManager():getCommonData():subGold(tonumber(self._meetPrice))
   
    if self.afterGain == 1 and self.delegate ~= nil then
        self.delegate:update_aftergain()
    end
    
    local event = cc.EventCustom:new(UPDATE_FWZhUI)
    self:getEventDispatcher():dispatchEvent(event)

    _drops = self.drops[1]
    if self._scheduerOutputTime ~= nil then
        timer.unscheduleGlobal(self._scheduerOutputTime)
        self._scheduerOutputTime = nil
    end
    self:onHideView()
    getOtherModule():showOtherView("PVTravelCongratulations", 0, _drops)
    _drops = nil

end
   
function PVTravelMeet:initRegisterNetCallBack()
    function onReciveMsgCallBack(_id)
        if _id == NET_ID_TRAVEL_SETTLE then -- 游历结算  （暂时使用在等待时间和答题两个事件上）
            self:update_settle()
        elseif _id == NET_ID_TRAVEL_NOWAITEVENT then -- (打斗事件和等待时间事件中的立即获得)
            self:update_nowaitTravel()
        elseif _id == NET_ID_TRAVEL_WAITEVENT then -- 稍后获得
            self:update_waitTravel()
        elseif _id == NET_ID_TRAVEL_SETTLEAUTO then -- 自动游历稍后获得
            -- self:update_nowaitTravel()
            self:update_waitAutoTravel()
        end
    end

    self:registerMsg(NET_ID_TRAVEL_SETTLE, onReciveMsgCallBack)
    self:registerMsg(NET_ID_TRAVEL_WAITEVENT, onReciveMsgCallBack)
    self:registerMsg(NET_ID_TRAVEL_NOWAITEVENT, onReciveMsgCallBack)
    self:registerMsg(NET_ID_TRAVEL_SETTLEAUTO, onReciveMsgCallBack)
end

-- 更新奖励
function PVTravelMeet:updateAward()
    -- print(------------)
    if self.drops[1].type == "travel_item" then
         self.c_TravelData:addTravelItem(self.stage_id, self.drops[1])
    end

    -- 如果是其他奖励加入
    getDataProcessor():gainGameResourcesResponse(self.GameResourcesdrops)

end

function PVTravelMeet:startTimer()

    local function updateTimer(dt)
        
        self._time = self._time-dt
        self.timeLabel:setString(string.format("%02d:%02d:%02d",math.floor(self._time/3600), math.floor(self._time%3600/60), self._time%60))

        if self._time <= 0 then 
            if self._scheduerOutputTime ~= nil then
                timer.unscheduleGlobal(self._scheduerOutputTime)
                self._scheduerOutputTime = nil
            end
            self.timeLabel:setVisible(false)
            self.waitBtn:setVisible(false)
            self._meetPrice = 0
            self.meetPrice:setString(self._meetPrice)
        end
    end

    self._scheduerOutputTime = timer.scheduleGlobal(updateTimer, 1.0)

end

return PVTravelMeet

