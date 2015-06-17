

--首页
local processor = import("...netcenter.DataProcessor")
local PVCreateTeam = import("...platform.PVCreateTeam")
local PVHomePage = class("PVHomePage", BaseUIView)

local OPEN_SACRIFICE_LEVEL = 10     -- 献祭开启等级

-- NOTICE_SYS_RESPONSE = 2000

function PVHomePage:ctor(id)
    cclog("进入主页了。。。。。。。。。")
    isEntry = false
    PVHomePage.super.ctor(self, id)
    self:registerNetCallback()

    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self.commonData = getDataManager():getCommonData()
    self.dropTemp = getTemplateManager():getDropTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.GameLoginResponse = self.commonData:getData()
    self.soldierData = getDataManager():getSoldierData()
    self.secretPlaceData = getDataManager():getMineData()

    self.friendData = getDataManager():getFriendData()
    self.c_activeData = getDataManager():getActiveData()
    self.c_bossData = getDataManager():getBossData()

    self.c_stageTemp = getTemplateManager():getInstanceTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()

    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end
    -- self:registerScriptHandler(onNodeEvent)
    -- getOtherModule():showInOtherView("ImproveAbility")
end

function PVHomePage:onExit()
    cclog("----------PVHomePage:onExit--------")
    if self.scheduerOnline ~= nil then
        timer.unscheduleGlobal(self.scheduerOnline)
        self.scheduerOnline = nil
    end

    if self.scheduerMain ~= nil then
      timer.unscheduleGlobal(self.scheduerMain)
      self.scheduerMain = nil
    end
    self.animationManager:stopAllAnimations()
    self:getEventDispatcher():removeEventListener(self.listener)
    self:getEventDispatcher():removeEventListener(self.listener2)

end

function PVHomePage:registerNetCallback()
    -- local function responseGetLevelInitList(id, data)
    --     print("!!!!!!!!!!!!!!!!!!!")
    --     self:showOnlinePrize()
    --     print("!!!!!!!!!!!!!!!!!!!")
    -- end
    --在线奖励
    local function responseGetOnlineGift(id, data)
        if data.result == true then
            -- 显示获取
            self.commonData:addGotOnlineGift(self._OnlineGiftId)
            print("在线奖励 ============= ", self.nextOnlineGifts)

            for k, v in pairs(self.nextOnlineGifts) do
                print("v[3]  v[3] =============== ", v[3])
                local smallBagIds = self.dropTemp:getSmallBagIds(v[3])
                print("在线奖励奖励列表 ================ ")
                table.print(smallBagIds)
                getOtherModule():showOtherView("PVCongratulationsGainDialog", 5, smallBagIds)
            end
            -- getOtherModule():showOtherView("PVCongratulationsGainDialog", 4, rewards)
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("DialogGetCard", self.nextOnlineGifts, 1)
            local time = os.time()
            self.commonData:setRecordTime(time)

            self:updateOnlineData()
        else
            cclog("在线奖励,领取失败。。。。。。")

        end
    end

    local  function friendDataCallback(id, data)
        cclog("homePage friend data callBack")
        self:updateFriendNoticeData()
    end
    local function noticeDataCallback(data)
        cclog("homePage notice data callBack")
        -- print("------------"..data)
        -- if data ~= nil then table.print(data) end
        -- getHomeBasicAttrView():updateNoticeBuff(data)
    end
    -- self:registerMsg(ACTIVITY_ONLINE_LEVEL_INIT_CODE, responseGetLevelInitList)
    self:registerMsg(ACTIVITY_ONLINE_CODE, responseGetOnlineGift)
    self:registerMsg(FRIEND_LIST_REQUEST, friendDataCallback)
    --self:registerMsg(FRIEND_REFUSE_APPLY_REQUEST, friendDataCallback)
    self:registerMsg(NOTICE_SYS_RESPONSE, noticeDataCallback)
end

function PVHomePage:onMVCEnter()
    cclog("-----------PVHomePage:onMVCEnter-----------")
    local nodeView = self:getChildByTag(1001)
    if nodeView == nil then
        self.basicAttributeView = getHomeBasicAttrView()

        self.basicAttributeView:removeFromParent()
        self:addChild(self.basicAttributeView, 100, 1001)
        self.basicAttributeView:showView()
    end

    self:registerDataBack()

    self.UIHomePage = {}

    self:initTouchListener()

    self:loadCCBI("home/ui_home_page3.ccbi", self.UIHomePage)

    self.createSucceed = false

    self:initData()

    self:initView()

    self.animationManager:runAnimationsForSequenceNamed("Timeline")

    self:updateActivityEff()

    -- local nickName = self.commonData:getUserName()

    -- if nickName == "" then
    --     self.createTeam = PVCreateTeam.new("PVCreateTeam")
    --     self:addChild(self.createTeam)
    -- end

 
    self:updateNoticeData()

    self:initScheduer()
    -- self:updateBossWorld()
    --讨伐红点显示
    -- self:updateInstanceNotice()
    -- 游历红点
    local isCanTravel = self:checkTravel()
    if isCanTravel then
        self.travel_notice:setVisible(true)
    else
        self.travel_notice:setVisible(false)
    end
end

function PVHomePage:updateActivityEff()
    local isCanLoginReward = self:checkLoginReward()
    local isCanWine = self:checkWine()
    local isSineed = self:updateSineNotice()
    local isCanTravel = self:checkTravel()

    if isCanEat or isCanLoginReward or isCanWine or isSineed then

        self.activity_notice:setVisible(true)
        self.menuActivity:setVisible(true)
        self.menuActivityStatic:setVisible(false)
    else
        self.menuActivity:setVisible(false)
        self.menuActivityStatic:setVisible(true)
        self.activity_notice:setVisible(false)
    end
end

function PVHomePage:initData()
    self.recordTime = self.commonData:getRecordTime()
end

function PVHomePage:initScheduer()
    self.timeCanGet = self.commonData:getTimeCanGet()
    self.loginList = self.baseTemp:getAllLoginPrizeList() -- 获取到所有登陆奖励，等级奖励
    local aaa = self.commonData:getLoginTotalGiftList()
    -- print("initScheduer-----------")
    -- table.print(aaa)
    -- print("initScheduer---------")
    local function updateTimer()
        -- cclog("--------homePage notice-------")
        local isCanEat = self:checkCanEat()
        local isCanLoginReward = self:checkLoginReward()

        local isCanWine = self:checkWine()
        local isSineed = self:updateSineNotice()


        local isCanTravel = self:checkTravel()

        -- print(isCanEat)
        -- print(isCanLoginReward)
        -- print(isCanWine)
        -- print(isSineed)
        if isCanEat or isCanLoginReward or isCanWine or isSineed then

            self.activity_notice:setVisible(true)
            -- game.addSpriteFramesWithFile("res/part/ui_a002701.plist")
            -- local function callBack()
            --     self.nodeActivityEffect:removeAllChildren()
            --     local activityEff = UI_Zhujiemianhuodong()
            --     self.nodeActivityEffect:addChild(activityEff)
            -- end
            -- local sequence = cc.Sequence:create(cc.CallFunc:create(callBack))
            -- --repeatAction1 = cc.RepeatForever:create(sequence)
            -- --repeatAction1:setTag(110)
            -- self.nodeActivityEffect:runAction(sequence)
            local activityEff = self.nodeActivityEffect:getChildByTag(110)
            if activityEff == nil then
                cclog("--------UI_Zhujiemianhuodong--------")
                activityEff = UI_Zhujiemianhuodong()
                activityEff:setTag(110)
                self.nodeActivityEffect:addChild(activityEff)
            end
            self.menuActivity:setVisible(true)
            self.menuActivityStatic:setVisible(false)
            --self.animationManager:runAnimationsForSequenceNamed("showActivity")
        else
            local activityEff = self.nodeActivityEffect:getChildByTag(110)
            if activityEff then
                self.nodeActivityEffect:removeAllChildren()
            end
            self.menuActivity:setVisible(false)
            self.menuActivityStatic:setVisible(true)
            self.activity_notice:setVisible(false)
        end

        -------游历
        self:updateNoticeData()

        if isCanTravel then
            self.travel_notice:setVisible(true)
        else
            self.travel_notice:setVisible(false)
        end


        --世界boss
        -- self:updateBossWorld()

        -- 秘境
        self:isHavestInSecretPlace()

    end
    self.scheduerMain = timer.scheduleGlobal(updateTimer, 1.0)
end


function PVHomePage:isHavestInSecretPlace()
    local _havest = self.secretPlaceData:isHaveHavest()
    if _havest then

    end
end
--世界boss红点
function PVHomePage:updateBossWorld()
    local stageId = self.c_bossData:getCurSatgeId()
    if stageId == nil then return end

    local activity_time = self.c_stageTemp:getSpecialStageById(stageId).timeControl
    local index = string.find(activity_time, "-")

    local start_time = string.sub(activity_time, 1, index - 1)
    local end_time = string.sub(activity_time, index + 1, 11)

    local curYear = self.commonData:getYear()
    local curMonth = self.commonData:getMonth()
    local curDay = self.commonData:getDay()
    local curHour = self.commonData:getCurrHour()
    local curMin = self.commonData:getCurrMin()
    local curSec = self.commonData:getCurSec()
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

    if self.subTime < 0 then
        getDataManager():getBossData():setIsStart(true)
        -- self.arena_notice:setVisible(true)        -- 修改的时候，把整个方法放在PVHome内，PVHomePage内没有self.arena_notice
    else
        getDataManager():getBossData():setIsStart(false)
        -- self.arena_notice:setVisible(false)
    end

    if self.subTime < 1000 then
        self:startScheduer(self.subTime)
    end

end
--世界boss定时器
function PVHomePage:startScheduer(subTime1)
    local function updateTimer1(dt)
        subTime1 = subTime1 - 1
        if subTime1 <= 0 then
            getDataManager():getBossData():setIsStart(true)
            if self.scheduer1 ~= nil then
                timer.unscheduleGlobal(self.scheduer1)
                self.scheduer1 = nil
            end
        end
    end

    if subTime1 > 0 then
        -- self.arena_notice:setVisible(true)
        getDataManager():getBossData():setIsStart(false)
        self.scheduer1 = timer.scheduleGlobal(updateTimer1, 1.0)
    else
        if self.scheduer1 ~= nil then
            getDataManager():getBossData():setIsStart(true)
            timer.unscheduleGlobal(self.scheduer1)
            self.scheduer1 = nil
        end
    end
end

-- --讨伐红点
-- function PVHomePage:updateInstanceNotice()
--     local _stageData = getDataManager():getStageData()
--     local curFbTimes = _stageData:getEliteStageTimes()
--     local curHdTimes = _stageData:getActStageTimes()
--     local vip = getDataManager():getCommonData():getVip()
--     local fbMaxTimes = getTemplateManager():getBaseTemplate():getNumEliteTimes(vip)
--     local hdMaxTimes = getTemplateManager():getBaseTemplate():getNumActTimes(vip)
--     local eliteStageTimes = fbMaxTimes - curFbTimes
--     local actStageTimes = hdMaxTimes - curHdTimes

--     if eliteStageTimes > 0 or actStageTimes > 0 then
--         self.fight_notice:setVisible(true)
--     else
--         self.fight_notice:setVisible(false)
--     end
-- end

--检查领取体力
function PVHomePage:checkCanEat()
    local isFeastTime = self.commonData:isFeastTime(self.timeCanGet)

    if isFeastTime then
        local isEatFeast = self.commonData:isEatFeast(self.timeCanGet)

        -- if isEatFeast then
        --     self.activity_notice:setVisible(false)
        -- else
        --     self.activity_notice:setVisible(true)
        -- end
        return not isEatFeast
    end
    return false
end

function PVHomePage:checkWine()
    -- local brew_times = self.commonData:getBrewTimes()
    -- local brew_times_max = self.baseTemp:getBrewTimesMax()
    -- return brew_times_max - brew_times > 0

    local startLv = self.baseTemp:getBrewStartLevel()
    local lv = self.commonData:getLevel()
    local brewFlag = (lv >= startLv)
    if brewFlag then
        local brew_times = self.commonData:getBrewTimes()
        local brew_times_max = self.baseTemp:getBrewTimesMax()
        local isCanBrew = (brew_times_max - brew_times ) > 0
        return isCanBrew
    end
    return false
end

--检查登录奖励
function PVHomePage:checkLoginReward()
    --累计登录奖励
    local IsCanGetTotleReward = self.commonData:getIsCanGetTotleReward()
    --连续登陆奖励
    local isCanGetSeriesReward = self.commonData:getIsCanGetSeriesReward()
    --战队等级奖励
    local isCanGetLevelReward = self.commonData:getIsCanGetLevelReward()
    -- print("累计登录奖励")
    -- print(IsCanGetTotleReward)
    -- print("连续登陆奖励")
    -- print(isCanGetSeriesReward)
    -- print("战队等级奖励")
    -- print(isCanGetLevelReward)

    if IsCanGetTotleReward or isCanGetSeriesReward or isCanGetLevelReward then
        return true
    else
        return false
    end
end

--检查游历是否有宝箱、鞋子、自动游历完成
function PVHomePage:checkTravel()
    --是否有鞋子可以游历
    local _travelInitResponse = getDataManager():getTravelData():getTravelInitResponse()
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
    local _isHasGain = getDataManager():getTravelData():isHasGain()
    if not _isHasGain then
        isGold = true
    else
        isGold = false
    end

    --判断自动游历是否已经游历完并且有奖励领取
    local isCanGetTraveling = false
    local _travelInit = getDataManager():getTravelData():getTravelInitResponse()
    local isTravelStype1 = getDataManager():getTravelData():getIsIntoTraveling(_travelInit.stage_travel,1)
    local isTravelStype2 = getDataManager():getTravelData():getIsIntoTraveling(_travelInit.stage_travel,2)
    local isTravelStype3 = getDataManager():getTravelData():getIsIntoTraveling(_travelInit.stage_travel,3)
    local isTravelStype4 = getDataManager():getTravelData():getIsIntoTraveling(_travelInit.stage_travel,4)
    if isTravelStype1 == 2 or isTravelStype2 == 2 or isTravelStype3 == 2 or isTravelStype4 == 2 then
        isCanGetTraveling = true
    else
        isCanGetTraveling = false
    end

    --判断游历等待时间事件是否已经完成
    local isCanGetTravel = false
    local _travelInit = getDataManager():getTravelData():getTravelInitResponse()
    -- local _stage_id = _travelInit.travel_item_chapter[self.tag].stage_id
    local _chapters = _travelInit.chapter
    for k,v in pairs(_chapters) do
        -- if v.stage_id <= _stage_id then
            for k1,v1 in pairs(v.travel) do
                local meetType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(v1.event_id)
                if meetType == 1 and v1.time > 0 then
                    local _leftTime = getDataManager():getCommonData():getTime() - v1.time
                    if _leftTime > 30*60 then
                        _leftTime = 0
                    else
                        _leftTime = 30*60 - _leftTime
                    end

                    -- print("1111======_leftTime=======  ".._leftTime)

                    if _leftTime <= 0 then
                        -- print("游历等待时间事件完成")
                        isCanGetTravel = true
                    end
                end
            end
        -- end
    end

    local _autoTravel1 = getDataManager():getTravelData():addTableAutoTime(_travelInit.stage_travel, 1)
    local _autoTravel2 = getDataManager():getTravelData():addTableAutoTime(_travelInit.stage_travel, 2)
    local _autoTravel3 = getDataManager():getTravelData():addTableAutoTime(_travelInit.stage_travel, 3)
    local _autoTravel4 = getDataManager():getTravelData():addTableAutoTime(_travelInit.stage_travel, 4)


    for k,v in pairs(_autoTravel1) do
        local meetType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(v.event_id)

        local _leftTime = getDataManager():getCommonData():getTime() - v.time

        if _leftTime > 30*60 then
            _leftTime = 0
        else
            _leftTime = 30*60 - _leftTime
        end
        -- print("2222======_leftTime=======  ".. _leftTime)
        if meetType == 1 and _leftTime<=0 then
            -- print("<<<<<<<<<<<<<<<<<<<<<===================<<<<<<<<<<<<<<<<<")
            -- print("自动游历等待时间事件完成")
            isCanGetTravel = true
        end
    end

    for k,v in pairs(_autoTravel2) do
        local meetType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(v.event_id)

        local _leftTime = getDataManager():getCommonData():getTime() - v.time

        if _leftTime > 30*60 then
            _leftTime = 0
        else
            _leftTime = 30*60 - _leftTime
        end
        -- print("2222======_leftTime=======  ".. _leftTime)
        if meetType == 1 and _leftTime<=0 then
            -- print("<<<<<<<<<<<<<<<<<<<<<===================<<<<<<<<<<<<<<<<<")
            -- print("自动游历等待时间事件完成")
            isCanGetTravel = true
        end
    end

    for k,v in pairs(_autoTravel3) do
        local meetType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(v.event_id)

        local _leftTime = getDataManager():getCommonData():getTime() - v.time

        if _leftTime > 30*60 then
            _leftTime = 0
        else
            _leftTime = 30*60 - _leftTime
        end
        -- print("2222======_leftTime=======  ".. _leftTime)
        if meetType == 1 and _leftTime<=0 then
            -- print("<<<<<<<<<<<<<<<<<<<<<===================<<<<<<<<<<<<<<<<<")
            -- print("自动游历等待时间事件完成")
            isCanGetTravel = true
        end
    end

    for k,v in pairs(_autoTravel4) do
        local meetType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(v.event_id)

        local _leftTime = getDataManager():getCommonData():getTime() - v.time

        if _leftTime > 30*60 then
            _leftTime = 0
        else
            _leftTime = 30*60 - _leftTime
        end
        -- print("2222======_leftTime=======  ".. _leftTime)
        if meetType == 1 and _leftTime<=0 then
            -- print("<<<<<<<<<<<<<<<<<<<<<===================<<<<<<<<<<<<<<<<<")
            -- print("自动游历等待时间事件完成")
            isCanGetTravel = true
        end
    end



    if isCanTravel or isGold or isCanGetTraveling or isCanGetTravel then
        -- print("[[[[[[[[[[[[[[[  true   ]]]]]]]]]]]]]]")
        -- if isCanTravel == true then print("有鞋子") end
        -- if isGold == true then print("有宝箱") end
        -- if isCanGetTraveling == true then print("自动游历") end
        -- if isCanGetTravel == true then print("等待时间") end


        return true
    else
        --print("[[[[[[[[[[[[[[[  false   ]]]]]]]]]]]]]]")
        return false
    end
end

--d签到
function PVHomePage:updateSineNotice()
    local nowDay = self.commonData:getSignCurrDay()
    local isSigned = self.commonData:lookIsSigned(nowDay)
    return  not isSigned
end
-- function PVHomePage:actionHD(node)
--     local rotl = cc.RotateBy:create(20,1.0)
--     local rotr = cc.RotateBy:create(-20,1.0)
--     local dey = cc.d
--     local seq = cc.Sequence:create(rotl,rotr,)
--     local rep = cc.RepeatForever:create()
-- end
function PVHomePage:initView()
    self.animationManager = self.UIHomePage["UIHomePage"]["mAnimationManager"]

    self.labelOnlineLastTime = self.UIHomePage["UIHomePage"]["label_last_time"]
    self.layOnline = self.UIHomePage["UIHomePage"]["lay_menuOnline"]
    self.layOnlinePos = self.UIHomePage["UIHomePage"]["laycolor_pos_online"]

    self.menuOnline = self.UIHomePage["UIHomePage"]["menu_online_gift"]
    self.menuOnlineStatic = self.UIHomePage["UIHomePage"]["menu_online_gift_static"]
    self.imgOnlineTime = self.UIHomePage["UIHomePage"]["img_giftonline"]
    self.imgOnlineCanget = self.UIHomePage["UIHomePage"]["img_canget"]
    self.menuActivity = self.UIHomePage["UIHomePage"]["menu_activity"]
    self.menuActivityStatic = self.UIHomePage["UIHomePage"]["menu_activity_static"]
    self.menu_active = self.UIHomePage["UIHomePage"]["menu_active"]

    -- self.menuOnline:setLocalZOrder(10)                          --安卓版出现点击后背景 跑到上层
    -- self.menuOnlineStatic:setLocalZOrder(10)
    -- self.menuActivity:setLocalZOrder(10)
    -- self.menuActivityStatic:setLocalZOrder(10)
    -- self.menu_active:setLocalZOrder(10)

    self.nodeOnlineEffect = self.UIHomePage["UIHomePage"]["nodeOnlineEffect"]
    self.nodeActivityEffect = self.UIHomePage["UIHomePage"]["nodeActivityEffect"]

    self.soldier_notice = self.UIHomePage["UIHomePage"]["soldier_notice"]
    self.equip_notice = self.UIHomePage["UIHomePage"]["equip_notice"]
    -- self.fight_notice = self.UIHomePage["UIHomePage"]["fight_notice"]
    -- self.arena_notice = self.UIHomePage["UIHomePage"]["arena_notice"]
    self.travel_notice = self.UIHomePage["UIHomePage"]["travel_notice"]
    self.active_notice = self.UIHomePage["UIHomePage"]["active_notice"]
    self.online_notice = self.UIHomePage["UIHomePage"]["online_notice"]
    self.activity_notice = self.UIHomePage["UIHomePage"]["activity_notice"]
    self.friend_notice = self.UIHomePage["UIHomePage"]["friend_notice"]

    self.soldier_notice:setVisible(false)
    self.equip_notice:setVisible(false)
    -- self.fight_notice:setVisible(false)
    -- self.arena_notice:setVisible(false)
    self.travel_notice:setVisible(false)
    self.active_notice:setVisible(false)
    self.online_notice:setVisible(false)
    self.activity_notice:setVisible(false)
    self.friend_notice:setVisible(false)

    ----------------------------------
    -- self.nodeZhengba = self.UIHomePage["UIHomePage"]["nodeZhengba"]
    self.nodeJuntuan = self.UIHomePage["UIHomePage"]["nodeJuntuan"]
    self.nodeXianji = self.UIHomePage["UIHomePage"]["nodeXianji"]
    self.nodeYouli = self.UIHomePage["UIHomePage"]["nodeYouli"]
    self.nodeChuancheng = self.UIHomePage["UIHomePage"]["nodeChuancheng"]
    self.nodechat = self.UIHomePage["UIHomePage"]["nodechat"]
    self.levelUpNode = self.UIHomePage["UIHomePage"]["levelUpNode"]
    self.nodeshejiao = self.UIHomePage["UIHomePage"]["nodeshejiao"]
    self.bagMailLayer = self.UIHomePage["UIHomePage"]["bagMailLayer"]
    ----------------------------------
    self:showOnlinePrize() -- 更新online

    --账号绑定
    self.boundUserNode = self.UIHomePage["UIHomePage"]["boundUserNode"]


    -- local isBound  = cc.UserDefault:getInstance():getBoolForKey("isBound", false)
    -- if isBound then
    --     self.boundUserNode:setVisible(false)
    -- else
    --     self.boundUserNode:setVisible(true)
    -- end

    local isTourist = cc.UserDefault:getInstance():getBoolForKey("isTourist", false)
    print("isTourist ====== isTourist =========== ", isTourist)
    if isTourist then
        self.boundUserNode:setVisible(true)
    else
        self.boundUserNode:setVisible(false)
    end

    -- self:createAccelerometer() -- 添加重力感应
    self:updateNoticeData()

    local function update_friendNotice()
        self:updateFriendNoticeData()
    end

    self.listener = cc.EventListenerCustom:create(UPDATE_FRIEND_NOTICE, update_friendNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)


    local function update_areaNotice()
        -- self:updateAreaNotice()
    end

    self.listener2 = cc.EventListenerCustom:create(UPDATE_AREANOTICE, update_areaNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener2, 1)

      -- 好友
    self:updateFriendNoticeData()
    --活跃度
    self:updateActiveNotice()
    --竞技场
    -- self:updatePvpArena()

    self:updateViewLevel()
end

--更新主页面的图标显示情况
function PVHomePage:updateViewLevel()
    local item = self.baseTemp:getBaseInfoById("uiIconOpenLevel")
    local nowLevel = self.commonData:getLevel()
    print("nowLevel====", nowLevel)
    table.print(item)
    print("nowLevel====", nowLevel)
    for k, v in pairs(item) do
        if k == "8004" then
            -- self.nodeZhengba:setVisible(nowLevel >= v)
        elseif k == "8005" then
            self.nodeJuntuan:setVisible(nowLevel >= v)
        elseif k == "8006" then
            self.nodeXianji:setVisible(nowLevel >= v)
        elseif k == "8007" then
            self.nodeYouli:setVisible(nowLevel >= v)
        elseif k == "8008" then
            self.nodeChuancheng:setVisible(nowLevel >= v)
        elseif k == "8009" then
            self.nodeshejiao:setVisible(nowLevel >= v)
        end
    end
    if nowLevel < 6 then
        self.bagMailLayer:setPosition(cc.p(-200, 0))
    elseif nowLevel == 6 then
        self.bagMailLayer:setPosition(cc.p(-100, 0))
    elseif nowLevel >= 7 then
        print("等级 =========== 777777")
        self.bagMailLayer:setPosition(cc.p(0, 0))
    end
end

function PVHomePage:startLevelShow(level)
    print("startLevelShow__level======", level)
    local isLeveled = self.commonData.isLeveled
    if isLeveled == false then
        return
    end

    if level == 14 then
        -- getNewGManager():startGuide()
    end

    local targetPos = nil
    local viewItem = nil
    if level == 6 then --献祭
        targetPos = cc.p(271, 182)
        viewItem = self.nodeXianji
    elseif level == 7 then --社交
        targetPos = cc.p(370, 182)
        viewItem = self.nodeshejiao
    elseif level == 11 then --游历
        targetPos = cc.p(573, 293)
        viewItem = self.nodeYouli
    elseif level == 20 then --公会
        targetPos = cc.p(470, 293)
        viewItem = self.nodeJuntuan
    elseif level == 25 then --传承
        targetPos = cc.p(76, 290)
        viewItem = self.nodeChuancheng
    end
    if viewItem == nil then
        return
    end
    viewItem:setVisible(false)
    local node = UI_Zhujiemiantubiaokaiqi(targetPos)
    self.levelUpNode:addChild(node)
    local delayAction = cc.DelayTime:create(1)
    local function callBack()
        viewItem:setVisible(true)
        if level ~= 7 then
            -- getNewGManager():startGuide()
        end
    end

    local sequenceAction = cc.Sequence:create(delayAction, cc.CallFunc:create(callBack))
    self:runAction(sequenceAction)


    if level == 6 then
        self.bagMailLayer:setPosition(-200, 0)
        local delayAction = cc.DelayTime:create(0.2)

        local sequenceAction = cc.Sequence:create(delayAction, cc.MoveTo:create(0.3, cc.p(-100, 0)))
        self.bagMailLayer:runAction(sequenceAction)
    elseif level == 7 then
        -- self.bagMailLayer:setPosition(-100, 0)
        -- --local moveToSequence = cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(0, 0)), nil)
        -- self.bagMailLayer:runAction(cc.MoveTo:create(0.3, cc.p(-, 0))
        local delayAction = cc.DelayTime:create(0.2)
        local sequenceAction = cc.Sequence:create(delayAction, cc.MoveTo:create(0.3, cc.p(0, 0)))
        self.bagMailLayer:runAction(sequenceAction)
    end

end

--活跃度红点
function PVHomePage:updateActiveNotice()
    local isHaveReward = self.c_activeData:getNotice()
    if isHaveReward then
        self.active_notice:setVisible(true)
    else
        self.active_notice:setVisible(false)
    end
end

function PVHomePage:subChNoticeState(noticeId, state)
    print("红点操作 =============== ", noticeId,        state)
    --新功能开启相关
    local level = self.commonData:getLevel()
    print("当前战队等级 -===================- ", level)
    if level == 7 or level == 25 then
        if not isLevel7 then
            self:startLevelShow(level)
            isLevel7 = true
        end
    end
    --红点相关
    if noticeId == NOTICE_COM_EQUIP then
        self:updateNoticeData()
    elseif noticeId == NOTICE_ACTIVE_DEGREE then
        print("活跃度领取奖励刷新 =============== ")
        self:updateActiveNotice()
    elseif noticeId == ARENA_NOTICE then
        print("竞技场红点更新显示")
        local event = cc.EventCustom:new(SET_AREANOTICE)
        self:getEventDispatcher():dispatchEvent(event)
        -- print("竞技场红点更新显示 ------------------ ",self.arena_notice)
        -- self:updatePvpArena()
    elseif noticeId == BOSS_NOTICE then
        cclog("世界boss")
    elseif noticeId == INSTANCE_NOTICE then
        -- self.fight_notice:setVisible(state)
    end
end

function PVHomePage:updateNoticeData()
    local isCanComHero = getDataManager():getSoldierData():getIsCanCom()  --是否有合成的武将
    local isCanComEquip = getDataManager():getEquipmentData():getIsComEquip()
    local isCanNewHero = getDataManager():getSoldierData():getIsHaveNewSoldier()   -- 是否有新武将

    if self.soldier_notice then
        self.soldier_notice:setVisible(isCanComHero or isCanNewHero)
    end
    if self.equip_notice then
        self.equip_notice:setVisible(isCanComEquip)
    end
end

-- 社交红点
function PVHomePage:updateFriendNoticeData()
    local _friendListData = getDataManager():getFriendData():getListData()

        if table.nums(_friendListData.applicant_list) > 0 then
            self.friend_notice:setVisible(true)
        else
            self.friend_notice:setVisible(false)
    end
end

function PVHomePage:registerDataBack()
    local function getCallBack()
        if self.isSmelt then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSmeltView")
            self.isSmelt = nil
        end
    end
    self:registerMsg(BAG_RUNES, getCallBack)

end

function PVHomePage:initTouchListener()
    --聊天
    local function chatMenuClick()
        getAudioManager():playEffectButton1()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChatPanel")
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVPeerless")
        --getOtherModule():showOtherView("NewbieGuide", "#ui_common_break_lv_blue.png")

        ---------------ljr
        self.playerLevel = getDataManager():getCommonData():getLevel()
        self.breakupOpenLeve = getTemplateManager():getBaseTemplate():getChatOpenLevel()
        if self.playerLevel >= self.breakupOpenLeve then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChatPanel")
        else
            --功能等级开放提示
            self:removeChildByTag(1000)
            self:addChild(getLevelTips(self.breakupOpenLeve), 0, 1000)
        end
        ----------------

    end
    --装备
    local function equipMenuClick()
        getAudioManager():playEffectButton1()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipmentMain")
        stepCallBack(G_GUIDE_20060)

    end
    --武将
    local function heroMenuClick()
        getAudioManager():playEffectButton1()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierMain")
        --stepCallBack(G_GUIDE_20039)
        --stepCallBack(G_GUIDE_50003)
    end
    --关卡
    local function fightMenuClick()
        getAudioManager():playEffectButton1()
       getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters")

       stepCallBack(G_GUIDE_00100)
       stepCallBack(G_SELECT_FIGHT)
       stepCallBack(G_GUIDE_20051)
       stepCallBack(G_GUIDE_20069)

       stepCallBack(G_GUIDE_20090)

    end
    --军团（公会）
    local function labourUnionMenuClick()
        getAudioManager():playEffectButton1()
        self.legionNet:sendGetLegionInfo()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionPanel")
        stepCallBack(G_GUIDE_140003)
        getModule(MODULE_NAME_HOMEPAGE):showUINodeView("PVLegionPanel")

    end
    --争霸
    local function starcraftMenuClick()
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaWarPanel")
        stepCallBack(G_GUIDE_100003)

        stepCallBack(G_GUIDE_110003)
        stepCallBack(G_GUIDE_120003)
    end

    --社交
    local function socialMenuClick()
       cclog("socialMenuClick")
       getAudioManager():playEffectButton1()
       getModule(MODULE_NAME_HOMEPAGE):showUIView("PVFriendPanel")
    end
    --献祭
    local function sacrificeMenuClick()
        getAudioManager():playEffectButton1()
        cclog("sacrifice")
        -- print(self.GameLoginResponse)
        -- if self.GameLoginResponse.level < OPEN_SACRIFICE_LEVEL then
        --     getOtherModule():showOtherView("Toast", "需要玩家等级大于等于10级")
        --     return
        -- end
        -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSacrificePanel")
        getNetManager():getRuneNet():sendBagRunes()
        self.isSmelt = true
        --getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSacrificePanel")
        stepCallBack(G_GUIDE_30003)
    end

    -- local function onMenuCanGet()  -- 在线奖励
    --     print("在线奖励")
    -- end
    local function onMenuActivity()  -- 精彩活动
        -- cclog("精彩活动")
        getAudioManager():playEffectButton1()
        stepCallBack(G_GUIDE_130003)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActivityPage")
        -- getModule(MODULE_NAME_HOMEPAGE):showUINodeView("PVActivityPage")
    end


    local function onTravelMenuClick()  -- 游历
        getAudioManager():playEffectButton1()
        local _stageId = getTemplateManager():getBaseTemplate():getTravelOpenStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if isOpen then 
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelPanel")
            stepCallBack(G_GUIDE_80003)
        else
            getStageTips(_stageId)
        end
    end

    local function inheritMenuClick()  -- 传承
        cclog("传承")
        getAudioManager():playEffectButton1()
        local _stageId = getTemplateManager():getBaseTemplate():getInheritOpenStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if isOpen then 
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritView")
        else
            getStageTips(_stageId)
        end
    end

    local function bagMenuClick()  -- 背包

        getAudioManager():playEffectButton1()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVBag")
    end

    local function mailMenuClick()  -- 信箱

        getAudioManager():playEffectButton1()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmailView")
    end

    --活跃度
    local function onActiveDegreeClick()
        self.playerLevel = self.commonData:getLevel()
        self.activeLevel = self.baseTemp:getActiveOpenLeve()
        getAudioManager():playEffectButton1()

        local _stageId = getTemplateManager():getBaseTemplate():getActivityOpenStage()
        local isOpen = getDataManager():getStageData():getIsOpenByStageId(_stageId)
        if isOpen then        --self.playerLevel >= self.activeLevel
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActiveDegree")
        else
            --功能等级开放提示
            -- self:removeChildByTag(1000)
            -- self:addChild(getLevelTips(self.activeLevel), 0, 1000)

            -- getOtherModule():showToastView(Localize.query(811))

            getStageTips(_stageId)
        end
    end

    --账号绑定
    local function onBoundUserClick()
        getOtherModule():showOtherView("PVBoundTourist")
    end

    self.UIHomePage["UIHomePage"] = {}
    self.UIHomePage["UIHomePage"]["chatMenuClick"] = chatMenuClick
    self.UIHomePage["UIHomePage"]["equMenuClick"] = equipMenuClick
    self.UIHomePage["UIHomePage"]["heroMenuClick"] = heroMenuClick
    self.UIHomePage["UIHomePage"]["batMenuClick"] = fightMenuClick
    self.UIHomePage["UIHomePage"]["resloveMenuClick"] = sacrificeMenuClick
    self.UIHomePage["UIHomePage"]["mfMenuClick"] = socialMenuClick
    self.UIHomePage["UIHomePage"]["legionMenuClick"] = labourUnionMenuClick
    self.UIHomePage["UIHomePage"]["mZhMenuClick"] = starcraftMenuClick
    self.UIHomePage["UIHomePage"]["onMenuActivity"] = onMenuActivity
    self.UIHomePage["UIHomePage"]["onMenuActivityStatic"] = onMenuActivity
    self.UIHomePage["UIHomePage"]["bagMenuClick"] = bagMenuClick
    self.UIHomePage["UIHomePage"]["mailMenuClick"] = mailMenuClick

    self.UIHomePage["UIHomePage"]["travelMenuClick"] = onTravelMenuClick
    self.UIHomePage["UIHomePage"]["inheritMenuClick"] = inheritMenuClick
    self.UIHomePage["UIHomePage"]["onActiveDegreeClick"] = onActiveDegreeClick
    self.UIHomePage["UIHomePage"]["onBoundUserClick"] = onBoundUserClick
end

-- 更新在线时间
function PVHomePage:updateOnlineData()

    local _nextGiftTime = self:getNextOnlineGift()
    --显示是否可领取
    self._isCanGet, self._OnlineGiftId = self:getOnlineGiftState()

    local function updateTimer(dt)

        --cclog("在线领取定时器")

        --local nowSec = self.commonData:getOnlineTime()     --这里有错误，应该是当前时间减去上次领取时候的时间
        local curTime = os.time()
        local recordTime = self.commonData:getRecordTime()
        local _leftTime = _nextGiftTime - (curTime - recordTime)
        --local _leftTime = _nextGiftTime - nowSec
        if _leftTime <= 0 then  -- 时间到，可领奖
            timer.unscheduleGlobal(self.scheduerOnline)
            self:updateOnlineData()
        else
            self.labelOnlineLastTime:setString( string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
        end

        local isBound  = cc.UserDefault:getInstance():getBoolForKey("isBound", false)
        if isBound then
            self.boundUserNode:setVisible(false)
        end

    end

    if self._isCanGet == true then

        -- local function callBack()
        --     self.nodeOnlineEffect:removeAllChildren()
        --     -- print("callBack--------")
        --     local  onlineEff = UI_Zhujiemianbaoxiang()
        --     onlineEff:setPosition(cc.p(-5, 0))
        --     self.nodeOnlineEffect:addChild(onlineEff)
        -- end
        -- local sequence = cc.Sequence:create(cc.CallFunc:create(callBack), cc.DelayTime:create(2.5))
        -- repeatAction2 = cc.RepeatForever:create(sequence)
        -- repeatAction2:setTag(100)
        -- self.nodeOnlineEffect:runAction(repeatAction2)

        local onlineEff = self.nodeOnlineEffect:getChildByTag(100)
        if onlineEff == nil then
            cclog("--------UI_Zhujiemianbaoxiang--------")
            onlineEff = UI_Zhujiemianbaoxiang()
            onlineEff:setTag(100)
            self.nodeOnlineEffect:addChild(onlineEff)
        end

        self.menuOnline:setVisible(true)
        self.menuOnlineStatic:setVisible(false)

        self.imgOnlineTime:setVisible(false)
        self.imgOnlineCanget:setVisible(true)
        self.online_notice:setVisible(true)
    else
        local onlineEff = self.nodeOnlineEffect:getChildByTag(100)
        if onlineEff then
            self.nodeOnlineEffect:removeAllChildren()
        end
        -- if onlineEff == nil then
        --     cclog("--------UI_Zhujiemianbaoxiang----3333----")
        --     onlineEff = UI_Zhujiemianbaoxiang()
        --     onlineEff:setTag(100)
        --     self.nodeOnlineEffect:addChild(onlineEff)
        -- end
        self.imgOnlineTime:setVisible(true)
        self.imgOnlineCanget:setVisible(false)
        self.online_notice:setVisible(false)

        self.nodeOnlineEffect:stopAllActions()
        self.menuOnline:setVisible(false)
        self.menuOnlineStatic:setVisible(true)
    end
    --显示倒计时
    if self._isCanGet == false then
        if _nextGiftTime == nil then -- 没奖励了
            self.labelOnlineLastTime:setString("今日已领完")
            self._isCanGet = nil
        else
            if self.scheduerOnline ~= nil then
                timer.unscheduleGlobal(self.scheduerOnline); self.scheduerOnline = nil
            end
            self.scheduerOnline = timer.scheduleGlobal(updateTimer, 1.0)
        end
    end
end


-- 显示在线奖励
function PVHomePage:showOnlinePrize()

    self:updateOnlineData()

    ----点击到在线奖励触发奖励提示
    local _size = self.layOnline:getContentSize()
    local _rectArea = cc.rect(0, 0, _size.width, _size.height)
    self.layOnline:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.layOnline:setTouchEnabled(true)
    local function onTouchEvent(eventType, x, y)
        local _pos = self.layOnline:convertToNodeSpace(cc.p(x,y))
        local _isInRect = cc.rectContainsPoint(_rectArea, _pos)
        if eventType == "began" then
            if _isInRect == true then
                if self._isCanGet == true then
                    cclog("发送在线奖励协议"..self._OnlineGiftId)
                    getNetManager():getActivityNet():sendGetOnlineGift(self._OnlineGiftId)

                    self._isCanGet = false
                elseif self._isCanGet == nil then
                    cclog("今日奖励已领完，明日还能再次领取哦")
                    getOtherModule():showAlertDialog(nil, Localize.query("activity.12"))
                    return false
                else
                    local ccbiNode = {}
                    local proxy = cc.CCBProxy:create()
                    local node = CCBReaderLoad("home/ui_activity_tip_get.ccbi", proxy, ccbiNode)
                    local anim = ccbiNode["UIActivityTip"]["mAnimationManager"]
                    local card1 = ccbiNode["UIActivityTip"]["img_card1"]
                    local card1 = ccbiNode["UIActivityTip"]["img_card2"]
                    local num1 = ccbiNode["UIActivityTip"]["label_num1"]
                    local num2 = ccbiNode["UIActivityTip"]["label_num2"]
                    local layBg = ccbiNode["UIActivityTip"]["layer_bg"]
                    anim:runAnimationsForSequenceNamed("Actiontime")
                    -- 获取这轮奖励数据
                    self:getNextOnlineGift()
                    local _cardNum = table.nums(self.nextOnlineGifts)
                    local index = 0
                    for k,v in pairs(self.nextOnlineGifts) do
                        local dropList = self:getDropList(v[3])
                        self:createDropList(dropList,layBg)
                    end

                    -- 添加卡牌与排版

                    -- 设置位置显示
                    local _size = node:getContentSize()
                    local _posX, _posY = self.layOnlinePos:getPosition()
                    node:setPosition(-_size.width, -_size.height)
                    self.layOnlinePos:setOpacity(255)
                    self.layOnlinePos:addChild(node)
                    -- self.layOnlinePos:globalZOrder(1000)
                    -- node:setLocalZOrder(1000)
                    return true
                end

            end
            return false
        elseif  eventType == "ended" then
            self.layOnlinePos:removeAllChildren()
        end
    end
    self.layOnline:registerScriptTouchHandler(onTouchEvent)
end

--设置大包
function PVHomePage:getDropBag(img, label, dropId)
    local _smallDropId = self.dropTemp:getBigBagById(dropId).smallPacketId[1]
    local _itemList = self.dropTemp:getAllItemsByDropId(_smallDropId)
    -- 查出物品类型type,分类处理1，继续查表 2，直接获取图片
    local _index = 1
    for k,v in pairs(_itemList) do  -- _itemList = {[1]={type = v.type, detailId = v.detailID},...}
        if v.type < 100 then  -- 可直接读的资源图
            local _icon = self.resourceTemp:getResourceById(v.type)
            setItemImage(img, "#".._icon, 1)
        else  -- 需要继续查表
            if v.type == 101 then -- 武将
                local _temp = self.soldierTemp:getSoldierIcon(v.detailId)
                local quality = self.soldierTemp:getHeroQuality(v.detailId)
                changeNewIconImage(img,_temp,quality)
            elseif v.type == 102 then -- equpment
                local _temp = self.equipTemp:getEquipResIcon(v.detailId)
                local quality = self.equipTemp:getQuality(v.detailId)
                changeEquipIconImageBottom(img, _temp, quality)
            elseif v.type == 103 then -- hero chips
                local _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local quality = self.chipTemp:getTemplateById(v.detailID).quality
                setChipWithFrame(img,"res/icon/hero/".._icon, quality)
            elseif v.type == 104 then -- equipment chips
                local _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local quality = self.chipTemp:getTemplateById(v.detailID).quality
                setChipWithFrame(img,"res/icon/equipment/".._icon, quality)
            elseif v.type == 105 then  -- item
                local _temp = self.bagTemp:getItemResIcon(v.detailId)
                local quality = self.bagTemp:getItemQualityById(v.detailId)
                setCardWithFrame(img,"res/icon/item/".._temp, quality)
            end
        end
        label:setString("X "..v.count)
    end
end


function PVHomePage:createDropList(tabList,layerView)
    layerView:removeAllChildren()
    local function numberOfCellsInTableView(tab)
        cclog("这里是创建掉落列表"..table.getn(tabList))
        table.print(tabList)
       return table.getn(tabList)
    end
    local function cellSizeForTable(tbl, idx)
        return 85,90
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UICommonGetCard"] = {}
            local node = CCBReaderLoad("common/ui_card_withnumber.ccbi", proxy, cell.itemInfo)
            node:setScale(0.85)
            cell:addChild(node)
            cell.img = cell.itemInfo["UICommonGetCard"]["img_card"]
            cell.labelNum = cell.itemInfo["UICommonGetCard"]["label_number"]
        end

        local reward = tabList[idx+1]
        for k,v in pairs(reward) do
            --index = index + 1
            if k == "101" then -- hero
                local _temp = self.soldierTemp:getSoldierIcon(v[3])
                local quality = self.soldierTemp:getHeroQuality(v[3])
                changeNewIconImage(cell.img, _temp, quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "102" then -- equipment
                local _temp = self.equipTemp:getEquipResIcon(v[3])
                local quality = self.equipTemp:getQuality(v[3])
                changeEquipIconImageBottom(cell.img, _temp, quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "103" then -- hero chip
                local _temp = self.chipTemp:getTemplateById(v[3]).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local _quality = self.chipTemp:getTemplateById(v[3]).quality
                setChipWithFrame(cell.img, "res/icon/hero/".._icon, _quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "104" then -- equipment chip
                local _temp = self.chipTemp:getTemplateById(v[3]).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local quality = self.chipTemp:getTemplateById(v[3]).quality
                setChipWithFrame(cell.img, "res/icon/equipment/".._icon, quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "105" then -- item
                _temp = self.bagTemp:getItemResIcon(v[3])
                local quality = self.bagTemp:getItemQualityById(v[3])
                setItemImage(cell.img, "res/icon/item/".._temp, quality)
               cell.labelNum:setString("X "..v[1])
            elseif k == "106" then -- big_bag
                --这个大包应该不会用到了吧
                --self:getDropBag(cell.img, cell.labelNum, v[3])
            -- elseif k == "107" then
            --     local _res = self.resourceTemp:getResourceById(v[3])
            --     setItemImage(img, "res/icon/resource/".._res, 1)

            else
                local _res = self.resourceTemp:getResourceById(k)
                print("GGGGG", _res)
                setItemImage(cell.img, "#".._res, 1)
                cell.labelNum:setString("X "..v[1])
            end

        end
       return cell
    end

    local layerSize = layerView:getContentSize()
    local tabView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    tabView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    local itemCount = table.nums(tabList)
    print("-----------table.nums(tabList)++++++++++++++"..itemCount)
    if itemCount ~= nil and itemCount < 2 then
        tabView:setPosition(cc.p((2 - itemCount) * 100 / 2, -15))
    else
        tabView:setPosition(cc.p(15 , -15))
    end
    --tabView:setPosition(cc.p(15, -15))
    tabView:setDelegate()
    tabView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    layerView:addChild(tabView)

    -- tabView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    tabView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tabView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tabView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    tabView:reloadData()
end
function PVHomePage:getDropList(dropId)
    local _smallDrop = self.dropTemp:getBigBagById(dropId).smallPacketId
    local dropList = {}
    for k,_smallDropId in pairs(_smallDrop) do
        local _itemList = self.dropTemp:getAllItemsByDropId(_smallDropId)
        cclog("-----------------------_itemList----------------")
        table.print(_itemList)
        cclog("-----------------------_itemList----------------")
        local dropType = _itemList[1].type
        dropList[k] = {[tostring(dropType)] = {_itemList[1].count,_itemList[1].count,_itemList[1].detailId} }
    end
    return dropList
end



--是否可获取在线奖励
-- @ return : false ; true and id
function PVHomePage:getOnlineGiftState()
    --local onlineTimes = self.commonData:getOnlineTime()
    local curTime = os.time()
    local recordTime = self.commonData:getRecordTime()
    local onlineTimes = curTime - recordTime
    local _onlineGiftList = self.baseTemp:getOnlinePrizeList()
    for k,v in pairs(_onlineGiftList) do
        print(v.parameterA)
        if onlineTimes and v and v.parameterA and v.id and onlineTimes >= v.parameterA and self.commonData:isGetOnlineGift(v.id) == false then
            return true, v.id
        end
    end
    return false
end

--返回下一个online奖励的时间
function PVHomePage:getNextOnlineGift()
    local _onlineGiftList = self.baseTemp:getOnlinePrizeList()
    for k,v in pairs(_onlineGiftList) do
        if self.commonData:isGetOnlineGift(v.id) == false then
            self.nextOnlineGifts = v.reward -- activity_config.lua中的reward数据
            return v.parameterA
        end
    end
end

--添加重力感应效果
function PVHomePage:createAccelerometer()

    local layer = cc.Layer:create()
    layer:setAccelerometerEnabled(true)
    self:addChild(layer)

    local sky = self.UIHomePage["UIHomePage"]["img_sky"]
    local ground = self.UIHomePage["UIHomePage"]["img_ground"]
    local meimei = self.UIHomePage["UIHomePage"]["img_meimei"]
    local man = self.UIHomePage["UIHomePage"]["img_man"]
    local glass = self.UIHomePage["UIHomePage"]["img_glass_up"]
    local treedown = self.UIHomePage["UIHomePage"]["img_treedown"]
    local bottom = self.UIHomePage["UIHomePage"]["img_glass_bottom"]

    local function limitOffsetX(target, min, max, curX)
        if curX < min then curX = min end
        if curX > max then curX = max end
        target:setPositionX(curX)
    end

    local function accelerometerListener(event,x,y,z,timestamp)
        -- print("move ", x, y, z, timestamp)
        -- cclog("------accelerometerListener-------")
        local target  = event:getCurrentTarget()
        local ptNowX1 = target:getPositionX()
        local ptNowX2 = treedown:getPositionX()
        local ptNowX3 = glass:getPositionX()
        local ptNowX4 = man:getPositionX()
        local ptNowX5 = meimei:getPositionX()
        local ptNowX6 = ground:getPositionX()
        local ptNowX7 = sky:getPositionX()

        local offFlag1 = 8.0
        local offFlag2 = 5.5
        local offFlag3 = 3.0
        local offFlag4 = 2.0
        local offFlag5 = 0.8  -- meimei
        local offFlag6 = 0.5
        local offFlag7 = 0.3

        local offsetX1 = x * offFlag1
        local offsetX2 = x * offFlag2
        local offsetX3 = x * offFlag3
        local offsetX4 = x * offFlag4
        local offsetX5 = x * offFlag5
        local offsetX6 = -x * offFlag6
        local offsetX7 = -x * offFlag7

        local curNowX1 = ptNowX1 + offsetX1
        local curNowX2 = ptNowX2 + offsetX2
        local curNowX3 = ptNowX3 + offsetX3
        local curNowX4 = ptNowX4 + offsetX4
        local curNowX5 = ptNowX5 + offsetX5
        local curNowX6 = ptNowX6 + offsetX6
        local curNowX7 = ptNowX7 + offsetX7

        local canMove = 80

        limitOffsetX(target,    320 - offFlag1*0.1*canMove, 320 + offFlag1*0.1*canMove, curNowX1)
        limitOffsetX(treedown,  365 - offFlag2*0.1*canMove, 365 + offFlag2*0.1*canMove, curNowX2)
        limitOffsetX(glass,     301 - offFlag3*0.1*canMove, 301 + offFlag3*0.1*canMove, curNowX3)
        limitOffsetX(man,       355 - offFlag4*0.1*canMove, 355 + offFlag4*0.1*canMove, curNowX4)
        limitOffsetX(meimei,    252 - offFlag5*0.1*canMove, 252 + offFlag5*0.1*canMove, curNowX5)
        limitOffsetX(ground,    130 - offFlag6*0.1*canMove, 130 + offFlag6*0.1*canMove, curNowX6)
        limitOffsetX(sky,       350 - offFlag7*0.1*canMove, 350 + offFlag7*0.1*canMove, curNowX7)

    end

    local listerner  = cc.EventListenerAcceleration:create(accelerometerListener)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listerner, bottom)
end

function PVHomePage:updateView()
    print("updateActiveNotice ============ ")
    self:updateActiveNotice()
end

function PVHomePage:onReloadView()
end

function PVHomePage:update()
end

---- 添加日历控件，避免快速不断创建时出现卡死

local PVActivityNode = import(".activity.PVActivityNode")
function g_createSignListView(signLayer, signListViewData)

    local commonData = getDataManager():getCommonData()
    local baseTemp = getTemplateManager():getBaseTemplate()

    local todayDate = commonData:getSignCurrDay()

    if g_create_singListView == nil then
        -- 用listview实现
        local layerSize = signLayer:getContentSize()

        g_create_singListView = ccui.ListView:create()
        g_create_singListView:retain()
        g_create_singListView:setDirection(ccui.ScrollViewDir.vertical)
        g_create_singListView:setTouchEnabled(true)
        g_create_singListView:setBounceEnabled(true)
        g_create_singListView:setBackGroundImageScale9Enabled(true)
        g_create_singListView:setSize(layerSize)

        for k, v in pairs(signListViewData) do
            local layout = game.newLayout(106*5, 147)
            for _k, _v in pairs(v) do
                
                local signNode = PVActivityNode.new()
                signNode:setPosition(106*(_k-1), 20)

                signNode:setTag((k-1)*5 + _k)
                signNode:setData(_v)
                layout:addChild(signNode)
               
            end
            g_create_singListView:pushBackCustomItem(layout)
        end
    end
    return g_create_singListView
end

-- local PVActivityNode = import(".activity.PVActivityNode")
-- function g_createSignListView(signLayer, signListViewData)
--     if g_create_singListView == nil then
--         -- 用listview实现
--         local layerSize = signLayer:getContentSize()

--         g_create_singListView = ccui.ListView:create()
--         g_create_singListView:retain()
--         g_create_singListView:setDirection(ccui.ScrollViewDir.vertical)
--         g_create_singListView:setTouchEnabled(true)
--         g_create_singListView:setBounceEnabled(true)
--         g_create_singListView:setBackGroundImageScale9Enabled(true)
--         g_create_singListView:setSize(layerSize)


--         local commonData = getDataManager():getCommonData()
--         local baseTemp = getTemplateManager():getBaseTemplate()

--         for k, v in pairs(signListViewData) do
--             --local layout = game.newLayout(106*5, 127)
--             local layout = game.newLayout(106*5, 147)
--             for _k, _v in pairs(v) do
--                 -- cclog("--------------g_createSignListView-------------------".._k)
--                 -- table.print(_v)
--                 local signNode = PVActivityNode.new()
--                 --signNode:setPosition(106*(_k-1), 0)
--                 signNode:setPosition(106*(_k-1), 20)

--                 signNode:setTag((k-1)*5 + _k)
--                 signNode:setData(_v)
--                 layout:addChild(signNode)
--                 local iDay = _v.times
--                 -- print("GAGAGAGAGAGAGAGAGAGAGAGAGAGGA  to day:", iDay, self.commonData:getDay())
--                 if commonData:getDay() == iDay then
--                     if commonData:lookIsSigned(iDay) == false then
--                         signNode:setState(3) -- 当天的，可签
--                     else
--                         signNode:setState(1) -- 当天的，已签
--                     end
--                 elseif commonData:getDay() > iDay then -- 已经过了的日期，查找已签和可补签的
--                     local _usedRepaire = commonData:getRepaireTimes()
--                     local _allRepaire = baseTemp:getTotalRepaireSignDays()
--                     cclog("_usedRepaire".._usedRepaire.."_allRepaire".._allRepaire)
--                     local _signDayList = commonData:getSignedList()
--                     if commonData:lookIsSigned(iDay) == true then
--                         signNode:setState(1)
--                     else
--                         if _usedRepaire < _allRepaire then -- 可补签
--                             signNode:setState(2)
--                         else
--                             signNode:setState(0)
--                         end
--                     end
--                 else -- 还没有到的日期的 4
--                     signNode:setState(4)
--                 end
--             end
--             g_create_singListView:pushBackCustomItem(layout)
--         end
--     end
--     return g_create_singListView
-- end



return PVHomePage

