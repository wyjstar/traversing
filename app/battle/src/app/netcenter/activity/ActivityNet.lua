-- 活动
-- 包括体力购买

ActivityNet = class("ActivityNet", BaseNetWork)

ACTIVITY_BUY_STAMINA = 6
ACTIVITY_RECOVER_STAMINA = 7

ACTIVITY_LASTTIME_CODE = 821
ACTIVITY_GETSTMINA_CODE = 820
ACTIVITY_INITLOGIN_CODE = 825
ACTIVITY_GETLOGIN_CODE = 826

ACTIVITY_ONLINE_LEVEL_INIT_CODE = 1120
ACTIVITY_ONLINE_CODE = 1121
ACTIVITY_LEVEL_CODE = 1131

ACTIVITY_SIGN_LIST_CODE = 1400
ACTIVITY_SIGN_IN_CODE = 1401
ACTIVITY_SIGN_TOTAL_CODE = 1402
ACTIVITY_SIGN_REPAIRE_CODE = 1403
ACTIVITY_SIGN_BOX = 1404

ACTIVITY_GET_BREW_CODE = 1600
ACTIVITY_DO_BREW_CODE = 1601
ACTIVITY_TAKEN_BREW_CODE = 1602

ACTIVITY_RECHARGE_DATA = 1150
ACTIVITY_RECHARGE_GIFT = 1151
--活动公告
NOTICE_SYS_RESPONSE = 2000

function ActivityNet:ctor()
	self.super.ctor(self, self.__cname)

    self.commonData = getDataManager():getCommonData()

	self:registerNetCallback()
end

function ActivityNet:sendTakenBrewMsg()
    print("taken brew ")
    self:sendMsg(ACTIVITY_TAKEN_BREW_CODE)
end

function ActivityNet:sendBrewMsg(_type)
	print("发送煮酒类型")
    local data = {brew_type = _type}
	self:sendMsg(ACTIVITY_DO_BREW_CODE, "DoBrew", data)
end

function ActivityNet:sendGetBrewInfoMsg(_type)
	print("get brew info")
	self:sendMsg(ACTIVITY_GET_BREW_CODE)
end

---------------
-- 发送获取体力时间
function ActivityNet:sendGetLastTimeMsg()
	print("发送上次获取体力的时间")
	self:sendMsg(ACTIVITY_LASTTIME_CODE)
end

-- 发送获取体力
function ActivityNet:sendGetStminaMsg()
	print("发送获取体力")
	self:sendMsg(ACTIVITY_GETSTMINA_CODE)
end

---------------
-- 初始化登陆奖励
function ActivityNet:sendGetLoginGiftListMsg()
    print("send get login gift init list")
    self:sendMsg(ACTIVITY_INITLOGIN_CODE)
end

--初始化充值活动
function ActivityNet:sendGetRechargeListMsg()
    print("send get recharge gift init list")
    self:sendMsg(ACTIVITY_RECHARGE_DATA)
end
function ActivityNet:sendGetRechargeGift(_data)
    cclog("--------------sendGetRechargeGift------------")
    local data = {gift = _data}
    table.print(data)
    self:sendMsg(ACTIVITY_RECHARGE_GIFT,"GetRechargeGiftRequest",data)
end

function ActivityNet:sendGetRechargeTest(recnum)
    print("send get recharge gift init sendGetRechargeTest")
    local data = {recharge_num = recnum}
    self:sendMsg(1000000,"RechargeTest",data)
end

-- 发送领取登陆奖励
function ActivityNet:sendGetLoginGiftMsg(id,type)
    print("send get login gift")
    local data = {activity_id=id,activity_type=type}
    self:sendMsg(ACTIVITY_GETLOGIN_CODE, "GetLoginGiftRequest", data)
end

---------------
-- 发送签到的列表
function ActivityNet:sendGetSignListMsg()
    print("send GetSignInResponse")
    self:sendMsg(ACTIVITY_SIGN_LIST_CODE)
end

-- 发送签到
function ActivityNet:sendGetSignMsg()
    print("send get sign gift msg")
    self:sendMsg(ACTIVITY_SIGN_IN_CODE)
end

-- 发送连续签到
function ActivityNet:sendContinuousSignMsg(days)
    print("send get continuous sign msg", days)
    local data = {sign_in_days = days}
    self:sendMsg(ACTIVITY_SIGN_TOTAL_CODE, "ContinuousSignInRequest", data)
end

-- 发送补签
function ActivityNet:sendRepaireSignMsg(_day)
    print("send get repaire sign msg",_day)
    local data = {day = _day}
    self:sendMsg(ACTIVITY_SIGN_REPAIRE_CODE, "RepairSignInRequest", data)
end

-- 发送领取宝箱
function ActivityNet:sendRepaireSignBoxMsg(_id)
    print("send get repaire sign box msg",_id)
    local data = {id = _id}
    self:sendMsg(ACTIVITY_SIGN_BOX, "SignInBoxRequest", data)
end

--------------------
-- 获取在线奖励和等级奖励初始化数据
function ActivityNet:sendGetOnlineLevelGiftList()
    print("send get online level gift list init data")
    self:sendMsg(ACTIVITY_ONLINE_LEVEL_INIT_CODE)
end

-- 获取在线奖励
function ActivityNet:sendGetOnlineGift(giftId)
    print("send get online gift ", giftId)
    local data = {gift_id = giftId}
    self:sendMsg(ACTIVITY_ONLINE_CODE, "GetOnlineGift", data)
end

-- 获取等级奖励
function ActivityNet:sendGetLevelGift(giftId)
    print("send get level gift ", giftId)
    local data = {gift_id = giftId}
    self:sendMsg(ACTIVITY_LEVEL_CODE, "GetLevelGift", data)
end

----------------
function ActivityNet:sendBuyStamina()
    self:sendMsg(ACTIVITY_BUY_STAMINA)
end

function ActivityNet:sendRecoverStamina()
    self:sendMsg(ACTIVITY_RECOVER_STAMINA, nil, nil, false)
end

-------------------
-- 注册协议返回回调函数
function ActivityNet:registerNetCallback()
    
    local function getStmina(data)
    	cclog("<< == response 获取体力 ==>>")
    	table.print(data)
    	if data.res == 2 then 
            local _curStamina = self.commonData:getStamina()
            local _addStamina = getTemplateManager():getBaseTemplate():getManualValue()
            self.commonData:setStamina(_curStamina+_addStamina)
            self.commonData:setLastStminaTime(self.commonData:getTime())
        end
    end
    local function getLastTime(data)
    	cclog("<< == response 获取上次获取体力时间 ==>>")
    	table.print(data)
        table.remove(g_netResponselist)

    	if data.res.result == true then
    		cclog(data.eat_time)
    		self.commonData:setLastStminaTime(data.eat_time)
    	else
    		cclog("response 返回数据错误 ！！！")
    	end
    end
    local function getSignList(data)
        table.remove(g_netResponselist)

        cclog("<< == response getSignList ==>>")
        cclog("activityNet..................")
        table.print(data)
        cclog("activityNet..................")
        self.commonData:setRepaireTimes(data.repair_sign_in_times)
        self.commonData:setSignedList(data.days)
        self.commonData:setSignRound(data.sign_round)
        self.commonData:setSignCurrDay(data.current_day)
        self.commonData:setContinuousSignDays(table.getn(data.days))
        self.commonData:setContinuousSignedList(data.continuous_sign_in_prize)
        self.commonData:setExtraSignGiftList(data.box_sign_in_prize)
    end
    local function getSignGift(data) -- 签到，补签
        cclog("<< == response getSignGift ==>>")
        -- table.print(data.gain)
        if data.res.result == true then
            cclog("<< == response gtttttttttttttetSignGift ==>>")
            getDataProcessor():gainGameResourcesResponse(data.gain)
            getDataManager():getActiveData():setDayReward(data.gain)
            -- 补签时消耗在UI上处理
        else 
            cclog("response 返回数据错误！！！")
        end
    end
    local function getContinuousSign(data)
        cclog("<< == response getContinuousSign ==>>")
        table.print(data)
        if data.res.result == true then
            getDataProcessor():gainGameResourcesResponse(data.gain)
        else 
            cclog("response 返回数据错误！！！")
        end
    end
    local function getOnlineLevelGiftList(data)
        cclog("<< == response getOnlineLevelGiftList == >>")
        
        table.remove(g_netResponselist)

        self.commonData:setOnlineTime(data.online_time)
       
        self.commonData:setOnlineGiftList(data.received_online_gift_id)
        self.commonData:setLevelGiftList(data.received_level_gift_id)
    end
    local function getOnlineGift(data)
        cclog("<< == response getOnlineGift ==>>")
        -- table.print(data.gain)         
        if data.result == true then
            getDataProcessor():gainGameResourcesResponse(data.gain)
        else
            cclog("数据返回错误！！")
        end
    end
    local function getLevelGift(data)
        cclog("<< == response getLevelGift ==>>")
         -- table.print(data)
        if data.result == true then
            getDataProcessor():gainGameResourcesResponse(data.gain)
            getDataManager():getActiveData():setLevelReward(data.gain)
        else
            cclog("数据返回错误！！")
        end
    end
    local function getInitLoginGiftList(data) -- 初始化登陆奖励
        cclog("<< == response getInitLoginGiftList ==>>")
        table.remove(g_netResponselist)
        self.commonData:setLoginTotalDay(data.cumulative_day.login_day)
        self.commonData:setLoginContinueDay(data.continuous_day.login_day)
        self.commonData:setLoginTotalGiftList(data.cumulative_received)
        self.commonData:setLoginContinueGiftList(data.continuous_received)

    end
    local function getLoginGift(data)  -- 获取登陆奖励
        cclog("<< == response getLoginGift ==>>" )
        -- table.print(data)
        if data.result == true then
            -- result_no 
            getDataProcessor():gainGameResourcesResponse(data.gain)
        else
            cclog("数据返回错误！！"..data.result_no)
        end
    end
    local function getBuyStamina(data)
        print("get Buy Stamina")
    end
    local function getRecoverStamina(data)
        print("recover stamina",data.result)
        if data.result == true then
            getDataManager():getCommonData():addStamina(1)
            getHomeBasicAttrView():updateStamina()
        end
    end
    local function getBrewResult(data)
        print("brew result",data.res.result)
        if data.res.result == true then
            self.commonData:setBrewTimes(data.brew_times)
            self.commonData:setBrewStep(data.brew_step)
            -- self.commonData:setNectarNum(data.nectar_num)
            self.commonData:setFinance(DROP_BREW,data.nectar_num)
            self.commonData:setNectarCur(data.nectar_cur)
            self.commonData:setGold(data.gold)
            print("brew result",data.nectar_num, data.nectar_cur, data.brew_times, data.brew_step, data.gold)
        end
    end
    local function getBrewInfo(data)
        table.remove(g_netResponselist)
        
        print("brew info",data.nectar_num, data.nectar_cur, data.brew_times, data.brew_step, data.gold)
        self.commonData:setBrewTimes(data.brew_times)
        self.commonData:setBrewStep(data.brew_step)
        self.commonData:setFinance(DROP_BREW,data.nectar_num)
        -- self.commonData:setNectarNum(data.nectar_num)
        self.commonData:setNectarCur(data.nectar_cur)
        self.commonData:setGold(data.gold)
    end

    local function getNoteResult(data)
        -- cclog("------activityNet getNoteResult---------")
        -- print("--------getnotiice-----",data)
        -- table.print(data)
        getHomeBasicAttrView():updateNoticeBuff(data)
    end

    local function GetRechargeGiftDataResult(data)
        cclog("------activityNet GetRechargeGiftDataResult---------")
        self.commonData:setRechargeActivityData(data.recharge_items)
        table.print(data)
    end

    local function GetRechargeGiftTest(data)
        cclog("-----------测试返回----------")
        print(data)
        table.print(data)
    end
    local function GetRechargeGiftResult(data)
        cclog("-----------获取充值奖励----------")
        table.print(data.gain)
        if data.res.result == true then
            getDataProcessor():gainGameResourcesResponse(data.gain)
        else
            cclog("数据返回错误！！"..data.result_no)
        end
    end
    self:registerNetMsg(ACTIVITY_LASTTIME_CODE, "GetEatTimeResponse", getLastTime)
    self:registerNetMsg(ACTIVITY_GETSTMINA_CODE, "EatFeastResponse", getStmina)
    self:registerNetMsg(ACTIVITY_SIGN_LIST_CODE, "GetSignInResponse", getSignList)  -- 1400
    self:registerNetMsg(ACTIVITY_SIGN_IN_CODE, "SignInResponse", getSignGift)       -- 1401
    self:registerNetMsg(ACTIVITY_SIGN_TOTAL_CODE, "ContinuousSignInResponse", getContinuousSign) -- 1402
    self:registerNetMsg(ACTIVITY_SIGN_REPAIRE_CODE, "SignInResponse", getSignGift) -- 1403
    self:registerNetMsg(ACTIVITY_SIGN_BOX, "SignInResponse", getSignGift) -- 1404
    self:registerNetMsg(ACTIVITY_ONLINE_LEVEL_INIT_CODE, "GetOnlineLevelGiftData", getOnlineLevelGiftList) -- 1120
    self:registerNetMsg(ACTIVITY_ONLINE_CODE, "GetOnlineGiftResponse", getOnlineGift) -- 1121
    self:registerNetMsg(ACTIVITY_LEVEL_CODE, "GetLevelGiftResponse", getLevelGift) -- 1131
    self:registerNetMsg(ACTIVITY_INITLOGIN_CODE, "InitLoginGiftResponse", getInitLoginGiftList) -- 825
    self:registerNetMsg(ACTIVITY_GETLOGIN_CODE, "GetLoginGiftResponse", getLoginGift) -- 826
    self:registerNetMsg(ACTIVITY_BUY_STAMINA, "CommonResponse", getBuyStamina)  -- 6
    self:registerNetMsg(ACTIVITY_RECOVER_STAMINA, "CommonResponse", getRecoverStamina) -- 7
    self:registerNetMsg(ACTIVITY_GET_BREW_CODE, "BrewInfo", getBrewInfo) -- 1600
    self:registerNetMsg(ACTIVITY_DO_BREW_CODE, "BrewInfo", getBrewResult) -- 1601
    self:registerNetMsg(ACTIVITY_TAKEN_BREW_CODE, "BrewInfo", getBrewResult) -- 1602
    self:registerNetMsg(ACTIVITY_RECHARGE_DATA, "GetRechargeGiftDataResponse", GetRechargeGiftDataResult) -- 1130

    self:registerNetMsg(NOTICE_SYS_RESPONSE, "NoticeResponse", getNoteResult) -- 2000
    self:registerNetMsg(ACTIVITY_RECHARGE_GIFT,"GetRechargeGiftResponse",GetRechargeGiftResult) -- 1151

    self:registerNetMsg(1000000,"RechargeTest",GetRechargeGiftTest) -- 2000
end


return ActivityNet
