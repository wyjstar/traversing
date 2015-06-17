local PVButton = import(".PVButton")
--首页面
local PVHome2 = class("PVHome2", BaseUIView)

function PVHome2:ctor(id)
    PVHome2.super.ctor(self, id)

    self.commonData = getDataManager():getCommonData()
    self.c_bossData = getDataManager():getBossData()
    self.c_bossNet = getNetManager():getBossNet()
    self.legionNet = getNetManager():getLegionNet()
    self.dropTemp = getTemplateManager():getDropTemplate()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.c_LineUpData = getDataManager():getLineupData()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.c_activeData = getDataManager():getActiveData()
    self.stageData = getDataManager():getStageData()
    self.emailData = getDataManager():getEmailData()
    self.stageTemp = getTemplateManager():getInstanceTemplate()

    self.bagTemp = getTemplateManager():getBagTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()

end

function PVHome2:enterTransitionFinish()
    print("finishi finish ", getNewGManager():getCurrentGid())
    if getNewGManager():getNewBeeFightWin() then
        return
    end

    self:showHomeGuide()

    -- 此代码在新手大礼包位置影响新手出现步骤
    --[[if getPlayerScene().firstEnter==true then
        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20043 then
            stepCallBack(GuideId.G_GUIDE_20044)
        end

        if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20088  then  --因为GuideGroupKey.HOME 里20005 和20006同时存在
            stepCallBack(GuideId.G_GUIDE_20005)
        end
    end]]--
end


function PVHome2:onMVCEnter()

    self.UIHomeView = {}
    self:loadCCBI("home/ui_home2.ccbi", self.UIHomeView)
    self:initAttributes()
    --init button
    self:initButton()
    --touch layer
    self:initTouchLayer()
    --
    self._isCanGet = false
    -- self.nextGiftTime = self:getNextOnlineGift()

    self:registerDataBack()
    self:updateNoticeData()
    self:updateShopNotice()
    self:initScheduer()
    -- self:updateOnlineData()
    self:showOnlinePrize()
    self:updateTravelNotice()
    self:updateActivityEff()
    self:updateFriendNoticeData()
    --活跃度
    self:updateActiveNotice()
    --讨伐红点
    self:updateInstanceNotice()
    --争霸
    self:updatePvpArena()
    --信箱
    self:updateMailNotice()
    --军团
    self:updateLeginNotice()
    --修改好友通知监听方法
    self.listener = cc.EventListenerCustom:create(UPDATE_FRIEND_NOTICE, function()
        self:updateFriendNoticeData()
    end)

    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

    -- local function update_legionNotice()
    --     self:updateLeginNotice()
    -- end
    -- self.listener = cc.EventListenerCustom:create(UPDATE_LEGION_NOTICE, update_legionNotice)
    -- self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)

    local function setFightNotice()
        print("------讨伐红点---------")
        self:updateInstanceNotice()
    end
    self.listener2 = cc.EventListenerCustom:create(SET_FIGHTNOTICE, setFightNotice)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener2, 1)


    -- local currentGID = getNewGManager():getCurrentGid() --G_GUIDE_40100--
    -- print("----currentGID-------")
    -- print(currentGID)
    -- print(G_GUIDE_130003)

    -- if currentGID == G_GUIDE_00100 or currentGID == G_SELECT_FIGHT or currentGID == G_GUIDE_20072
    --     or currentGID == G_GUIDE_30112 or currentGID == G_GUIDE_30120 or currentGID == G_GUIDE_40110
    --     or currentGID == G_GUIDE_40122 or currentGID == G_GUIDE_20069 or currentGID == G_GUIDE_20124
    --     or currentGID == G_GUIDE_40100 or currentGID == G_GUIDE_40138 then
    --     self:scrollToTPage()
    -- end

    -- if currentGID == G_GUIDE_30117 then
    --     self:scrollToFPage()
    -- end

    -- if currentGID == G_GUIDE_130003 then
    --     print("---currentGID == G_GUIDE_130003-----")
    --     self:scrollToSPage()
    -- end
end

function PVHome2:initScheduer()
    self.timeCanGet = self.commonData:getTimeCanGet()
    -- self.loginList = self.baseTemp:getAllLoginPrizeList() -- 获取到所有登陆奖励，等级奖励
    -- local aaa = self.commonData:getLoginTotalGiftList()

    local function updateTimer()

        self:updateNoticeData()
        self:updateShopNotice()
        self:updateTravelNotice()
        self:updateActivityEff()
        --好友
        self:updateFriendNoticeData()
        --活跃度
        self:updateActiveNotice()
        --争霸
        self:updatePvpArena()
        --信箱
        self:updateMailNotice()
        --军团
        self:updateLeginNotice()

    end
    self.scheduerMain = timer.scheduleGlobal(updateTimer, 1.0)
end

function PVHome2:initAttributes()
    getHomeBasicAttrView():init(self.UIHomeView["UIHomeView"])
end

function PVHome2:initTouchLayer()
    local bg_far = self.UIHomeView["UIHomeView"]["bg_far"]
    local bg_mid = self.UIHomeView["UIHomeView"]["bg_mid"]
    local bg_mid2 = self.UIHomeView["UIHomeView"]["bg_mid2"]
    local bg_near = self.UIHomeView["UIHomeView"]["bg_near"]

    self.labelOnlineLastTime = self.UIHomeView["UIHomeView"]["label_last_time"]        -- 在线奖励倒计时
    self.spriteGet = self.UIHomeView["UIHomeView"]["spriteGet"]

    self.lineup_notice = self.UIHomeView["UIHomeView"]["lineup_notice"]          -- 阵容红点
    self.lineup_notice:setVisible(false)
    self.soldier_notice = self.UIHomeView["UIHomeView"]["soldier_notice"]        -- 武将红点
    self.soldier_notice:setVisible(false)
    self.equip_notice = self.UIHomeView["UIHomeView"]["equip_notice"]            -- 装备红点
    self.equip_notice:setVisible(false)
    self.shopNotice = self.UIHomeView["UIHomeView"]["shop_notice"]               -- 商城红点
    self.shopNotice:setVisible(false)
    self.travel_notice = self.UIHomeView["UIHomeView"]["travel_notice"]      -- 游历红点
    self.travel_notice:setVisible(false)
    self.activity_notice = self.UIHomeView["UIHomeView"]["activity_notice"]  -- 精彩活动红点
    self.activity_notice:setVisible(false)
    self.active_notice = self.UIHomeView["UIHomeView"]["active_notice"]      -- 活跃度红点
    self.active_notice:setVisible(false)
    self.friend_notice = self.UIHomeView["UIHomeView"]["friend_notice"]      -- 好友 社交 红点
    self.friend_notice:setVisible(false)
    self.arena_notice = self.UIHomeView["UIHomeView"]["arena_notice"]        -- 争霸 红点
    self.arena_notice:setVisible(false)
    self.fight_notice = self.UIHomeView["UIHomeView"]["fight_notice"]        -- 讨伐 红点
    self.fight_notice:setVisible(false)

    self.mail_notice = self.UIHomeView["UIHomeView"]["mail_notice"]        -- 讨伐 红点
    self.mail_notice:setVisible(false)

    self.legion_notice = self.UIHomeView["UIHomeView"]["legion_notice"]         --军团红点
    self.legion_notice:setVisible(false)

    local _node1 = UI_Hongdiantishitexiao()
    self.lineup_notice:addChild(_node1)
    local _node2 = UI_Hongdiantishitexiao()
    self.soldier_notice:addChild(_node2)
    local _node3 = UI_Hongdiantishitexiao()
    self.equip_notice:addChild(_node3)
    local _node4 = UI_Hongdiantishitexiao()
    self.shopNotice:addChild(_node4)
    local _node5 = UI_Hongdiantishitexiao()
    self.travel_notice:addChild(_node5)
    local _node6 = UI_Hongdiantishitexiao()
    self.activity_notice:addChild(_node6)
    local _node7 = UI_Hongdiantishitexiao()
    self.active_notice:addChild(_node7)
    local _node8 = UI_Hongdiantishitexiao()
    self.friend_notice:addChild(_node8)
    local _node9 = UI_Hongdiantishitexiao()
    self.arena_notice:addChild(_node9)
    local _node10 = UI_Hongdiantishitexiao()
    self.fight_notice:addChild(_node10)
    local _node11 = UI_Hongdiantishitexiao()
    self.mail_notice:addChild(_node11)
    local _node12 = UI_Hongdiantishitexiao()
    self.legion_notice:addChild(_node12)

    self.bg_zhan = self.UIHomeView["UIHomeView"]["bg_zhan"]
    local _node = UI_zhantexiao()
    self.bg_zhan:addChild(_node)


    self.layOnline = self.UIHomeView["UIHomeView"]["lay_menuOnline"]
    self.layOnlinePos = self.UIHomeView["UIHomeView"]["laycolor_pos_online"]

    self.touchLayer = self.UIHomeView["UIHomeView"]["touch_layer"]
    self.touchLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.touchLayer:setTouchEnabled(true)

    local nearMinX = CONFIG_SCREEN_SIZE_WIDTH - bg_near:getContentSize().width
    local farMinX = -500
    local midMinX = CONFIG_SCREEN_SIZE_WIDTH - bg_mid:getContentSize().width
    local mid2MinX = CONFIG_SCREEN_SIZE_WIDTH - bg_mid2:getContentSize().width
    local bx, isSlide = 0, false

    local function avoidOverstep(x, minX)
        if x > 0 then
            x  = 0
        elseif x < minX then
            x = minX
        end
        return x
    end

    local touchStatus = nil

    local function onTouch(eventType, x, y)

        if touchStatus == eventType then return end

        if eventType == "began" then
            touchStatus = eventType
            bx = x
            self:checkClickedBtn(x, y)
            if self.clickedBtn_ then
                self.clickedBtn_:onClick(eventType)
            end
            return true
        elseif eventType == "moved" then
            touchStatus = nil
            local dx = (x - bx)
            local  isGuiding = getNewGManager():isHaveGuide()
            if math.abs(dx) < 5 or isGuiding then
                isSlide = false
                return
            end
            if self.clickedBtn_ then
                self.clickedBtn_:onClick("canceled")
                self.clickedBtn_ = nil
            end
            isSlide = true
            bx = x
            local fx = bg_far:getPositionX() + dx*0.25
            local mx = bg_mid:getPositionX() + dx*0.5
            local mx2 = bg_mid2:getPositionX() + dx*0.7
            local nx = bg_near:getPositionX() + dx
            fx = avoidOverstep(fx, farMinX)
            mx = avoidOverstep(mx, midMinX)
            mx2 = avoidOverstep(mx2, mid2MinX)
            nx = avoidOverstep(nx, nearMinX)

            if (nx >= -60 or nx <= (nearMinX + 55)) then
                -- bg_near:setPositionX(nx)
            else
                bg_near:setPositionX(nx)
                bg_far:setPositionX(fx)
                bg_mid:setPositionX(mx)
                bg_mid2:setPositionX(mx2)
            end
        elseif eventType == "ended" then
            touchStatus = nil
            if isSlide then
                -- 反弹
                -- local nx = bg_near:getPositionX()
                -- if nx >= 0 then
                --     bg_near:setPositionX(nx - 50)
                -- elseif nx <= nearMinX then
                --     bg_near:setPositionX(nearMinX + 50)
                -- end
                isSlide = false
            elseif self.clickedBtn_ then
                local btn = self.clickedBtn_
                self.clickedBtn_ = nil
                btn:onClick(eventType)
            end
        end
    end
    self.touchLayer:registerScriptTouchHandler(onTouch)
end


function PVHome2:checkClickedBtn(x, y)
    if self.clickedBtn_ == nil then
        for i = 1, #self.buttons_ do
            local button = self.buttons_[i]
            if button:isClicked(x, y) then
                self.clickedBtn_ = button
                break
            end
        end
    end
end

function PVHome2:updateNoticeData()

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

function PVHome2:updateMailNotice()

    local _list = self.emailData:getEmailList()

    for k,v in pairs(_list) do
        -- print(k,v)
    end

    if _list then

        if table.nums(_list) > 0 then

            self.mail_notice:setVisible(true)
        else
            self.mail_notice:setVisible(false)
        end

    else
        self.mail_notice:setVisible(false)
    end
end


-- 游历红点
function PVHome2:updateTravelNotice()
    local _stageId = self.baseTemp:getTravelOpenStage()
    local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
    if _isOpen then
    else
        self.travel_notice:setVisible(false)
        return
    end

    local isCanTravel = self:checkTravel()
    if isCanTravel then
        self.travel_notice:setVisible(true)
    else
        self.travel_notice:setVisible(false)
    end
end

function PVHome2:updateActivityEff()
    local isCanLoginReward = self:checkLoginReward()
    local isCanWine = self:checkWine()
    -- local isSineed = self:updateSineNotice()
    local isCanEat = self:checkCanEat()
    local isVipgift = self:checkVipGift()

    if isCanEat or isCanLoginReward or isCanWine  or isVipgift then

        self.activity_notice:setVisible(true)
        -- self.menuActivity:setVisible(true)
        -- self.menuActivityStatic:setVisible(false)
    else
        -- self.menuActivity:setVisible(false)
        -- self.menuActivityStatic:setVisible(true)
        self.activity_notice:setVisible(false)
    end
end
--商城的红点
function PVHome2:updateShopNotice()

    local shopTemplate = getTemplateManager():getShopTemplate()

    local flagHero = false
    local flagGodHero = false
    -- 良将周期免费
    local preHeroTime = self.commonData:getFineHero()
    local preGodHeroTime = self.commonData:getExcellentHero()
    local currTime = os.time()
    local heroFreePeriod = shopTemplate:getHeroFreePeriod() * 3600 -- 免费周期（sec）
    local godHeroFreePeriod = shopTemplate:getGodHeroFreePeriod() * 3600

    local diffTime1 = os.difftime(currTime, preHeroTime)
    local diffTime2 = os.difftime(currTime, preGodHeroTime)

    if diffTime1 < heroFreePeriod then
        flagHero = false
    else
        flagHero = true
    end

    if diffTime2 < godHeroFreePeriod then
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

function PVHome2:registerDataBack()
    --在线奖励
    local function responseGetOnlineGift(id, data)
        if data.result == true then
            -- 显示获取
            self.commonData:addGotOnlineGift(self._OnlineGiftId)
            for k, v in pairs(self.nextOnlineGifts) do
                local smallBagIds = self.dropTemp:getSmallBagIds(v[3])
                getOtherModule():showOtherView("PVCongratulationsGainDialog", 5, smallBagIds)
            end

            self.commonData:setOnlineTime(0)

            self:updateOnlineData()
        else
            cclog("在线奖励,领取失败。。。。。。")
        end
    end
    self:registerMsg(ACTIVITY_ONLINE_CODE, responseGetOnlineGift)
    --军团申请提示
    local function getLegionApplyBack(id, data)
        getNetManager():getLegionNet():sendGetApplyList()
        self:updateLeginNotice()
    end
    self:registerMsg(GET_APPLY_LIST_NOTICE, getLegionApplyBack)
end

--讨伐红点
function PVHome2:updateInstanceNotice()
    -- local _stageData = getDataManager():getStageData()
    local curFbTimes = self.stageData:getEliteStageTimes()
    local curHdTimes = self.stageData:getActStageTimes()
    local vip = self.commonData:getVip()
    local fbMaxTimes = self.baseTemp:getNumEliteTimes(vip)
    local hdMaxTimes = self.baseTemp:getNumActTimes(vip)
    local eliteStageTimes = fbMaxTimes - curFbTimes
    local actStageTimes = hdMaxTimes - curHdTimes

    if eliteStageTimes > 0 or actStageTimes > 0 then
        self.fight_notice:setVisible(true)
    else
        self.fight_notice:setVisible(false)
    end
end

--争霸红点
function PVHome2:updatePvpArena()

    local _stageId = self.baseTemp:getArenaOpenStage()
    local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
    if _isOpen then
        self.arena_notice:setVisible(false)
    else
        return
    end

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
function PVHome2:checkArena()
    local arenaLevel = self.baseTemp:getArenaLevel()                        --竞技场等级限制
    local _level = self.commonData:getLevel()
    if _level >= arenaLevel then
        -- print("刷新竞技场红点")
        local freeTime = self.baseTemp:getArenaFreeTime()              --每日免费挑战次数
        local challengeTimes = self.commonData:getPvpTimes()           --已经挑战的次数
        self.leaveTimes = freeTime - challengeTimes
        if self.leaveTimes > 0 then
            return true
        end
    end
    return false
end
--符文秘境红点
function PVHome2:checkRune()
    local runeLevel = self.baseTemp:getRuneLevel()                         --密境等级
    local _level = self.commonData:getLevel()
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
function PVHome2:checkBoss()
    local bossLevel = self.baseTemp:openWorldBossLevel()                   --世界boss开启等级限制
    local _level = self.commonData:getLevel()
    if _level >= bossLevel then
        if getDataManager():getBossData():getIsStart() then
            return true
        end
    end
    return false
end

-- 社交红点
function PVHome2:updateFriendNoticeData()
    -- print("PVHome2:updateFriendNoticeData")
    local _friendListData = getDataManager():getFriendData():getListData()

    if table.nums(_friendListData.applicant_list) > 0 then
        self.friend_notice:setVisible(true)
    else
        self.friend_notice:setVisible(false)
    end
end

--活跃度红点
function PVHome2:updateActiveNotice()
    local _stageId = self.baseTemp:getActivityOpenStage()
    local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
    if _isOpen then
    else
        self.active_notice:setVisible(false)
        return
    end

    local isHaveReward = self.c_activeData:getNotice()
    if isHaveReward then
        self.active_notice:setVisible(true)
    else
        self.active_notice:setVisible(false)
    end
end

--军团红点添加
function PVHome2:updateLeginNotice()
    local leginApplyList = getDataManager():getLegionData():getApplyList()
    local myPosition = getDataManager():getLegionData():getLegionPosition()
    if myPosition ~= nil then
        if table.getn(leginApplyList) > 0 and myPosition <= 3 then
            self.legion_notice:setVisible(true)
        else
            self.legion_notice:setVisible(false)
        end
    end
end


--是否可获取在线奖励
-- @ return : false ; true and id
function PVHome2:getOnlineGiftState()

    local onlineTimes = self.commonData:getOnlineTime()
    local _onlineGiftList = self.baseTemp:getOnlinePrizeList()
    for k,v in pairs(_onlineGiftList) do
        print(v.parameterA)
        if onlineTimes and v and v.parameterA and v.id and onlineTimes >= v.parameterA and self.commonData:isGetOnlineGift(v.id) == false then
            return true, v.id
        end
    end
    return false
end
-- function PVHome2:initOnlineTime()
--     local _nextGiftTime = self:getNextOnlineGift()
--     --显示是否可领取
--     self._isCanGet, self._OnlineGiftId = self:getOnlineGiftState()

--         local _leftTime = _nextGiftTime - self.commonData:getOnlineTime()
--         if _leftTime <= 0 then  -- 时间到，可领奖
--             -- self.labelOnlineLastTime:setString("可领取")
--             self.spriteGet:setVisible(true)
--             self.labelOnlineLastTime:setVisible(false)
--             timer.unscheduleGlobal(self.scheduerOnline)
--             self:updateOnlineData()
--         else
--             self.spriteGet:setVisible(false)
--             self.labelOnlineLastTime:setVisible(true)
--             self.labelOnlineLastTime:setString(string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
--         end
--     end
--     --显示倒计时
--     if self._isCanGet == false then
--         if _nextGiftTime == nil then -- 没奖励了
--             self._isCanGet = nil
--             -- self.labelOnlineLastTime:setString("已领完")
--             game.setSpriteFrame(self.spriteGet, "#ui_activity_s_ylq.png")
--             self.spriteGet:setVisible(true)
--             self.labelOnlineLastTime:setVisible(false)
--         else
--             if self.scheduerOnline ~= nil then
--                 timer.unscheduleGlobal(self.scheduerOnline)
--                 self.scheduerOnline = nil
--             end
--             self.scheduerOnline = timer.scheduleGlobal(updateTimer, 1.0)
--         end
--     else
--         -- self.labelOnlineLastTime:setString("可领取")
--         self.spriteGet:setVisible(true)
--         self.labelOnlineLastTime:setVisible(false)
--     end
-- end
-- 更新在线时间
function PVHome2:updateOnlineData()
    local _nextGiftTime = self:getNextOnlineGift()
    --显示是否可领取
    self._isCanGet, self._OnlineGiftId = self:getOnlineGiftState()

    if _nextGiftTime ~= nil then
        local _leftTime = _nextGiftTime - self.commonData:getOnlineTime()
        if _leftTime <= 0 then  -- 时间到，可领奖
            self.spriteGet:setVisible(true)
            self.labelOnlineLastTime:setVisible(false)
            -- if not self.scheduerOnline then
            --     timer.unscheduleGlobal(self.scheduerOnline)
            --     self.scheduerOnline = nil
            -- end
            -- self:updateOnlineData()
        else
            self.spriteGet:setVisible(false)
            self.labelOnlineLastTime:setVisible(true)
            self.labelOnlineLastTime:setString(string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
        end
    end

    local function updateTimer(dt)

        local _leftTime = _nextGiftTime - self.commonData:getOnlineTime()
        if _leftTime <= 0 then  -- 时间到，可领奖
            -- self.labelOnlineLastTime:setString("可领取")
            self.spriteGet:setVisible(true)
            self.labelOnlineLastTime:setVisible(false)
            timer.unscheduleGlobal(self.scheduerOnline)
            self:updateOnlineData()
        else
            self.spriteGet:setVisible(false)
            self.labelOnlineLastTime:setVisible(true)
            self.labelOnlineLastTime:setString(string.format("%02d:%02d:%02d",math.floor(_leftTime/3600),math.floor(_leftTime%3600/60),_leftTime%60) )
        end

    end
    --显示倒计时
    if self._isCanGet == false then
        if _nextGiftTime == nil then -- 没奖励了
            self._isCanGet = nil
            -- self.labelOnlineLastTime:setString("已领完")
            game.setSpriteFrame(self.spriteGet, "#ui_activity_s_ylq.png")
            self.spriteGet:setVisible(true)
            self.labelOnlineLastTime:setVisible(false)
        else
            if self.scheduerOnline ~= nil then
                timer.unscheduleGlobal(self.scheduerOnline)
                self.scheduerOnline = nil
            end
            self.scheduerOnline = timer.scheduleGlobal(updateTimer, 1.0)
        end
    else
        -- self.labelOnlineLastTime:setString("可领取")
        self.spriteGet:setVisible(true)
        self.labelOnlineLastTime:setVisible(false)
    end
end

--返回下一个online奖励的时间
function PVHome2:getNextOnlineGift()
    local _onlineGiftList = self.baseTemp:getOnlinePrizeList()
    for k,v in pairs(_onlineGiftList) do
        if self.commonData:isGetOnlineGift(v.id) == false then
            self.nextOnlineGifts = v.reward -- activity_config.lua中的reward数据
            return v.parameterA
        end
    end
end

function PVHome2:initButton()
    local function onClickOnlineReward()
        if self._isCanGet == true then
            getNetManager():getActivityNet():sendGetOnlineGift(self._OnlineGiftId)
            self._isCanGet = false
        end
    end
    local function onClickMall()
        getModule(MODULE_NAME_SHOP):showUIView("PVShopPage")
        print("click mall!!")
        groupCallBack(GuideGroupKey.BTN_CLICK_MALL)
    end
    local function onClickChangku()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVBag")
    end
    local function onClickWujiang()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierMain")

        groupCallBack(GuideGroupKey.BTN_CLICK_WUJIANG)
    end
    local function onClickChuanCheng()
        local _stageId = self.baseTemp:getInheritOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritView")
            groupCallBack(GuideGroupKey.BTN_CLICK_CHUANCHENG)
        else
            getStageTips(_stageId)
            return
        end
    end
    local function onClickLianHua()
        local _stageId = self.baseTemp:getHeroSacrificeOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSmeltView")
            local temp = getDataManager():getCommonData():getHeroSoul()
            print("tempHeroSoul ",temp)
            print("isHaveGuide ",getNewGManager():isHaveGuide())

            if temp>0 and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_30020 then
                getNewGManager():setCurrentGID(GuideId.G_GUIDE_30043)
                groupCallBack(GuideGroupKey.BTN_WUHUN)
                return
            end

            groupCallBack(GuideGroupKey.BTN_LIANHUA)
        else
            getStageTips(_stageId)
            return
        end
    end
    local function onClickYouLi()
        -- print("-----onClickYouLi--------")
        local _stageId = self.baseTemp:getTravelOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVTravelPanel")
            groupCallBack(GuideGroupKey.BTN_YOULI)
        else
            getStageTips(_stageId)
            return
        end
    end
    local function onClickRank()
         getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRankPanel")
    end
    local function onClickHuoyue()
        local _stageId = self.baseTemp:getActivityOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActiveDegree")
        else
            getStageTips(_stageId)
            return
        end
    end
    local function onClickSocial()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVFriendPanel")
    end
    local function onClickZhengBa()
        -- local _stageId = self.baseTemp:getArenaOpenStage()
        -- local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        -- if _isOpen then
            getModule(MODULE_NAME_WAR):showUIView("PVArenaWarPanel")
            groupCallBack(GuideGroupKey.BTN_ZHENG_BAR)
        -- else
            -- getStageTips(_stageId)
            -- return
        -- end
    end
    local function onClickTaoFa()
        local  guideInfo = getNewGManager():getCurrentInfo()
        local gId = getNewGManager():getCurrentGid()

        if guideInfo and tonumber(guideInfo.trigger)==6 then
            local tiggerValue = tonumber(guideInfo.triggerValue)
            local chapterNo = (tiggerValue%100000)/100
            local stageData = getDataManager():getStageData()
            if stageData:getChapterIsLock(chapterNo+1) ~= true then
                --此处需要考虑如何调用chapters里的item
                getNewGManager():setTouchOffSet(cc.p(0,-148))
                getNewGManager():setHandOffSet(cc.p(0,-148))
            end
        end

        --- 进入讨伐是否现实章节故事
        local _isShowPlotChapter, _stageId = self.stageData:getPlotChapterIsShow()

        if _isShowPlotChapter == true then
            getNewGManager():guideOver()
        else
            groupCallBack(GuideGroupKey.BTN_TAOFA)
        end

        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters")
        print("-------_isShowPlotChapter---------",_isShowPlotChapter,_stageId)
        if _isShowPlotChapter then
            cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewLastShow("PVChapterIntroduce",_stageId)
        end
        -- cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

    end
    local function onClickEquipment()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipmentMain")
        groupCallBack(GuideGroupKey.BTN_EQUIPMENT)
    end
    local function onClickHuoDong()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVActivityPage")
        groupCallBack(GuideGroupKey.BTN_CLICK_ACTIVITY)
    end
    local function onClickJunTuan()
        local _stageId = self.baseTemp:getGuildOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if _isOpen then
            self.legionNet:sendGetLegionInfo()
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionPanel")

            groupCallBack(GuideGroupKey.BTN_JUNTUAN)
        else
            getStageTips(_stageId)
            return
        end
    end
    local function onClickMail()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmailView")
    end
    local function onClickZhenRong()
        getModule(MODULE_NAME_LINEUP):showUIView("PVLineUp")

        local num = getDataManager():getLineupData():getOnLineUpNum()
        local curId = getNewGManager():getCurrentGid()

        if curId == GuideId.G_GUIDE_20006 and num>1 then
            getNewGManager():setCurrentGID(GuideId.G_GUIDE_20009)
            groupCallBack(GuideGroupKey.BTN_ADD_LINEUP)
            return
        end

        if curId == GuideId.G_GUIDE_20030 and num>2 then
            getNewGManager():setCurrentGID(GuideId.G_GUIDE_20033)
            groupCallBack(GuideGroupKey.BTN_ADD_LINEUP)
            return
        end

        groupCallBack(GuideGroupKey.BTN_LINEUP)


    end

    local function onClickAddTiLi()
        local curStamina = self.commonData:getStamina()
        local max = self.baseTemp:getStaminaMax()
        if curStamina < max then
            local left = self.baseTemp:getBuyStaminaLeftTimes()
            if left > 0 then
                getOtherModule():showOtherView("PVBuyStamina")
            else
                getOtherModule():showAlertDialog(nil, Localize.query("basic.1"))
            end
        else
            getOtherModule():showAlertDialog(nil, Localize.query("basic.2"))
        end
    end

    local function onClickAddYinYuan()
        getModule(MODULE_NAME_SHOP):showUIView("PVShopPage", 3)
    end
    local function onClickAddYuanBao()
        getModule(MODULE_NAME_SHOP):showUINodeView("PVshopRecharge")
    end
    local function onClickChat()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChatPanel")
    end
    local function onClickPlayerHead()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVHeadView")
    end

    local function onClickSign()
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSignEveryDay")
    end
    self.buttons_ = {
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_online_reward"], onClickOnlineReward),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_chat"], onClickChat),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_add_tili"], onClickAddTiLi),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_add_yinyuan"], onClickAddYinYuan),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_add_yuanbao"], onClickAddYuanBao),
        PVButton.new(self.UIHomeView["UIHomeView"]["player_head"], onClickPlayerHead),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_mall"], onClickMall),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_bag"], onClickChangku),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_equipment"], onClickEquipment),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_hero"], onClickWujiang),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_lineup"], onClickZhenRong),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_chuancheng"], onClickChuanCheng),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_lianhua"], onClickLianHua),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_youli"], onClickYouLi),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_friend"], onClickSocial),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_huoyuedu"], onClickHuoyue),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_zhengba"], onClickZhengBa),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_taofa"], onClickTaoFa),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_activity"], onClickHuoDong),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_juntuan"], onClickJunTuan),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_mail"], onClickMail),
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_rank"], onClickRank),
        --签到
        PVButton.new(self.UIHomeView["UIHomeView"]["btn_qiandao"], onClickSign)
    }
end

function PVHome2:scrollToFPage()
    self:scrollToPage(1)
end

function PVHome2:scrollToSPage()

    self:scrollToPage(2)
end

function PVHome2:scrollToTPage()
    self:scrollToPage(3)
end

function PVHome2:scrollToPage(page)
    print("---PVHome2:scrollToSPage-----")
    local bg_near = self.UIHomeView["UIHomeView"]["bg_near"]
    local bg_mid = self.UIHomeView["UIHomeView"]["bg_mid"]
    local bg_mid2 = self.UIHomeView["UIHomeView"]["bg_mid2"]
    local bg_far = self.UIHomeView["UIHomeView"]["bg_far"]
    local nx, mx, mx2, fx = 0, 0, 0, 0
    if page == 1 then
        nx = -50
        mx, mx2, fx = 0, 0, 0
    elseif page == 2 then
        nx, mx,mx2,fx = -700,-700,-700,-320
    else
        nx = CONFIG_SCREEN_SIZE_WIDTH - bg_near:getContentSize().width + 150
        mx = CONFIG_SCREEN_SIZE_WIDTH - bg_mid:getContentSize().width
        mx2 = CONFIG_SCREEN_SIZE_WIDTH - bg_mid2:getContentSize().width
        fx = CONFIG_SCREEN_SIZE_WIDTH - bg_far:getContentSize().width + 50
    end
    bg_near:setPositionX(nx)
    bg_mid:setPositionX(mx)
    bg_mid2:setPositionX(mx2)
    bg_far:setPositionX(fx)
end


function PVHome2:onExit()
    cclog("------onExitopoopop=================")
    if self.scheduerOnline ~= nil then
        timer.unscheduleGlobal(self.scheduerOnline)
        self.scheduerOnline = nil
    end

    if self.scheduerMain ~= nil then
      timer.unscheduleGlobal(self.scheduerMain)
      self.scheduerMain = nil
    end

    getHomeBasicAttrView():clear()
end

function PVHome2:subChNoticeState(noticeId, state)
    print("红点操作 =============== ", noticeId,state)
end

-----------------------------------
-- 显示在线奖励
function PVHome2:showOnlinePrize()

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
                    getOtherModule():showAlertDialog(nil, Localize.query("onlinegift"))
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
                    node:setPosition(-_size.width+100, -_size.height-20)
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

function PVHome2:createDropList(tabList,layerView)
    layerView:removeAllChildren()
    local function numberOfCellsInTableView(tab)
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
            elseif k == "107" then
                local _res = self.resourceTemp:getResourceById(v[3])
                setItemImage(cell.img, "res/icon/resource/".._res, 1)
                cell.labelNum:setString("X" .. v[1])
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
    -- print("-----------table.nums(tabList)++++++++++++++"..itemCount)
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
function PVHome2:getDropList(dropId)
    local _smallDrop = self.dropTemp:getBigBagById(dropId).smallPacketId
    local dropList = {}
    for k,_smallDropId in pairs(_smallDrop) do
        local _itemList = self.dropTemp:getAllItemsByDropId(_smallDropId)
        cclog("------------------------")
        table.print(_itemList)
        local dropType = _itemList[1].type
        dropList[k] = {[tostring(dropType)] = {_itemList[1].count,_itemList[1].count,_itemList[1].detailId} }
    end
    return dropList
end


--检查游历是否有宝箱、鞋子、自动游历完成
function PVHome2:checkTravel()
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
                    local _leftTime = self.commonData:getTime() - v1.time
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

        local _leftTime = self.commonData:getTime() - v.time

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

        local _leftTime = self.commonData:getTime() - v.time

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

        local _leftTime = self.commonData:getTime() - v.time

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

        local _leftTime = self.commonData:getTime() - v.time

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

--检查登录奖励
function PVHome2:checkLoginReward()
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

function PVHome2:checkWine()
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

--d签到
function PVHome2:updateSineNotice()
    local nowDay = self.commonData:getSignCurrDay()
    local isSigned = self.commonData:lookIsSigned(nowDay)
    return  not isSigned
end
function PVHome2:checkVipGift()
    return self.commonData:getVipGift()
    -- body
end
--检查领取体力
function PVHome2:checkCanEat()
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

-- 处理新手引导逻辑
-- 当所有子界面都关闭时，刷新home界面
function PVHome2:onRloadView()
    print("--------onRloadView--------")
    -- if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20005 then
    --     return
    -- end
    if getNewGManager():getNewBeeFightWin() then
        getNewGManager():setNewBeeFightWin(false)
        local currentStageId = self.stageData:getCurrStageId()
        if currentStageId ~= nil then
            local item = self.stageTemp:getTemplateById(currentStageId)
            if item.open[1] ~= nil then
                print("------getStagePassOpen------")
                getStagePassOpen():startShowViewByStageId(currentStageId,false)
                return
            end
        end
    end

    self:showHomeGuide()
end

function PVHome2:showHomeGuide()
    if getNewGManager():checkIsSendRewards() == true then
        return
    end

    groupCallBack(GuideGroupKey.HOME)
end

return PVHome2
