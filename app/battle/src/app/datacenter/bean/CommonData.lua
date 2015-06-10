--- 公共数据
--
--	包括，玩家信息，银币，金币，战斗力 等等
--
DROP_BREW = 13
local CommonData = class("CommonData")

function CommonData:ctor(item)
    self.GameLoginResponse = {}
    self.LastStminaTime = nil  -- 上次领取体力时间
    self.AccountResponse = {} -- 注册成功返回数据
    self.isTourist = false
    self.totalRecharge = 0
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.isHasVipGift = false
    self.iscanZcjb = false
    self.netTip = nil
    self.oldLevel = 0 --战队升级前的等级
    self.isHasRebate = false
    self.rank = 0
end
-- function CommonData:clear()
--     cclog("---------------CommonData:clear------")
--     self.GameLoginResponse = {}
--     self.LastStminaTime = nil  -- 上次领取体力时间
--     self.AccountResponse = {} -- 注册成功返回数据
--     self.isTourist = false
--     self.signedList = nil
--     cclog("---------------CommonData:clear------")
-- end

function CommonData:setNetTip(tipStr)
    self.netTip = tipStr
end

function CommonData:getNetTip()
    return self.netTip
end

function CommonData:setAccountResponse(data)
    self.AccountResponse = data
end

function CommonData:getAccountResponse()

    return self.AccountResponse
end

--是否是游客登录
function CommonData:setIsTourist(is_tourist)
    self.isTourist = is_tourist
end

function CommonData:getIsTourist()
    return self.isTourist
end

--获取全部数据
function CommonData:getData()
    if self.GameLoginResponse ~= nil then
        return self.GameLoginResponse
    end
    return nil
end

--给全部数据赋值(登录网络协议返回时对通用值进行初始化)
function CommonData:setData(data)
    print("CommonData:setData")
    table.print(data)
    self.GameLoginResponse = data                       --commonData全部数据

    self.accountId = data.id                            --玩家id
    self.nickname = data.nickname                       --玩家昵称
    self.register_time = data.register_time
    cclog("------新用户的注册时间－－－－－－－"..self.register_time.."等级:"..data.level)
    self.vip = data.vip_level                           --vip等级
    self.exp = data.exp                                 --经验
    self.level = data.level                             --等级
    -- self.stamina = data.stamina                         --体力
    self.totalRecharge = data.recharge                   --累计充值
    self.normalHeroTimes = data.fine_hero_times           --良将累计抽取次数
    self.godHeroTimes = data.excellent_hero_times         --神将累计抽取次数
    self.newbee_guide_id = data.newbee_guide_id
    print("newbee_guide_id", newbee_guide_id)
    print("---------------------------------------------------")
    -- self.gold = data.gold                               --元宝
    -- self.coin = data.coin                               --金币
    -- self.junior_stone = data.junior_stone               --初级熔炼石
    -- self.middle_stone = data.middle_stone               --中级熔炼石
    -- self.high_stone = data.high_stone                   --高级熔炼石
    -- self.pvp_score = data.pvp_score                     --pvp声望
    -- print("pvp_score", data.pvp_score)

    self.fine_hero = data.fine_hero                     --良将上次免费抽取的时间
    self.excellent_hero = data.excellent_hero           --神兵利器上次抽取时间
    self.fine_equipment = data.fine_equipment           --一般装备上次抽取时间
    self.excellent_equipment = data.excellent_equipment --神兵利器上次抽取时间

    self.pvp_times = data.pvp_times                     --对战次数
    self.pvp_refresh_count = data.pvp_refresh_count     --重置次数
    self.server_time = data.server_time                 --登录时间

    self.client_time = os.time()
    print("server_time", self.server_time)
    print("client_time", self.client_time)

    self.finances = data.finances

    print("----self.finances--------")
    print(self.finances)
    table.print(self.finances)

    self.login_time = data.server_time

    self.combat_power = data.combat_power
    self.get_stamina_times = data.get_stamina_times     -- 通过邮件获取体力次数
    self.buy_stamina_times = data.buy_stamina_times     -- 购买体力次数
    print("------self.buy_stamina_times--------",self.buy_stamina_times)
    self.last_gain_stamina_time = data.last_gain_stamina_time -- 上次获得体力时间


    self.head = data.head             --头像列表
    self.now_head = data.now_head     --当前头像id

    self.tomorrow_gift = data.tomorrow_gift
    print("tomorrow_gift = ", data.tomorrow_gift)

    self.battle_speed = data.battle_speed or 1 --战斗速度

    self.srv_time = data.server_time                --服务器时间，每秒进行更新

    self.buy_times = {} --data.buy_times                 --购买资源（体力，讨伐令，鞋子）次数

    if data.buy_times then
        for k,v in pairs(data.buy_times) do --{资源类型,购买次数,上次获得体力时间}
            self.buy_times[v.resource_type] = {resource_type=v.resource_type,buy_stamina_times = v.buy_stamina_times,last_gain_time = v.last_gain_stamina_time}
        end
    end

    self:updateSrvTimer()
    self:resRecoverTime()

    self:setPowerRank(data.fight_power_rank)

    self.pvp_overcome_index = data.pvp_overcome_index                   -- 过关斩将当前进行的关卡(从0开始计数)
    self.pvp_overcome_refresh_count = data.pvp_overcome_refresh_count   -- 可刷新的次数
    print("self.pvp_overcome_index = "..self.pvp_overcome_index)
    print("self.pvp_overcome_refresh_count = "..self.pvp_overcome_refresh_count)

end

function CommonData:setPowerRank(rank)
    self.rank = rank
end


--每一秒更新服务器时间
function CommonData:updateSrvTimer()

    if self.srvTimer then
        timer.unscheduleGlobal(self.srvTimer);
        self.srvTimer = nil
    end

    if self.srv_time then
        self.srvTimer = timer.scheduleGlobal(function(dt)
            self.srv_time = self.srv_time + dt
            -- print("serverTime:",self.server_time,self.srv_time)
        end,1)
    end
end

--收到服务器时间之后更新服务器时间
function CommonData:setSrvTime(time)
    print("CommonData:setSrvTime====>preTime:",self.srv_time,"now time:",time)
    self.srv_time = time
end

-- 新版本玩家资源 data.finances
function CommonData:getFinance(type)
    -- table.print(self.finances)
    -- print("CommonData:getFinance=============>type, value", type, self.finances[type+1])
    if not self.finances[type+1] then
        error("CommonData:getFinance error, value is nil , type="..type)
    end
    if self.finances[type+1] < 0 then
        self.finances[type+1] = 0
    end
    return self.finances[type+1]
end

function CommonData:setFinance(type, num)
    self.finances[type+1] = num
end
function CommonData:subFinance(type, num)
    if self.finances[type+1] then
        self.finances[type+1] = self.finances[type+1] - num
    end
end
function CommonData:addFinance(type, num)
    self.finances[type+1] = self.finances[type+1] + num

    getHomeBasicAttrView():updateStamina()
    getHomeBasicAttrView():updateExp()

    getHomeBasicAttrView():updateGold()
    getHomeBasicAttrView():updateCoin()

end

function CommonData:getRegistTime()
    -- cclog("------新用户的注册时间－－－－－－－"..self.register_time)
    return self.register_time
end

-- 装备精华
function CommonData:getEquipSoul()
    return self:getFinance(21)
end

function CommonData:subEquipSoul(num)
    self:subFinance(21, num)
end
function CommonData:addEquipSoul(num)
    self:addFinance(21, num)
end

----------征讨令Begin----------
--[[--
    获得征讨令
]]
function CommonData:getCrusade()
    return self:getFinance(RES_TYPE.CRUSADE )
end
--[[--
    减少征讨令
]]
function CommonData:subCrusade(num)
    self:subFinance(RES_TYPE.CRUSADE , num)
end
--[[--
    添加征讨令
]]
function CommonData:addCrusade(num)
    self:addFinance(RES_TYPE.CRUSADE , num)
end
----------征讨令End------------

-- 元气
function CommonData:getYuanqi()
    return self:getFinance(16)
end
-- 元气
function CommonData:setYuanqi(num)
    self:setFinance(16, num)
end
-- 元气
function CommonData:subYuanqi(num)
    self:subFinance(16, num)
end
-- 元气
function CommonData:addYuanqi(num)
    self:addFinance(16, num)
end
--是否有Vip礼包
function CommonData:getVipGift()
   return self.isHasVipGift
    -- body
end
function CommonData:setVipGift(hasVipGift)
    self.isHasVipGift = hasVipGift
    -- body
end
function CommonData:setCanZcjb(canZcjb)
    self.iscanZcjb = canZcjb
    -- body
end
function CommonData:getCanZcjb()
    return self.iscanZcjb
    -- body
end

function CommonData:setRebateState(hasRebate)
    self.isHasRebate = hasRebate
end

function CommonData:getRebateState()
    return self.isHasRebate
end

-- 返回模拟的服务器时间（客户端以服务器时间为准）
function CommonData:getTime()
    return math.floor(self.srv_time)
    -- local nowTime = os.time()
    -- local diff_time = nowTime - self.client_time
    -- return self.server_time + diff_time
end
function CommonData:getDay() return os.date("*t",self:getTime()).day end
function CommonData:getMonth() return os.date("*t",self:getTime()).month end
function CommonData:getYear() return os.date("*t",self:getTime()).year end
function CommonData:getCurrHour() return os.date("*t",self:getTime()).hour end
function CommonData:getCurrMin() return os.date("*t",self:getTime()).min end
function CommonData:getCurSec() return os.date("*t", self:getTime()).sec end

--brew
function CommonData:getNectarNum() return self.nectar_num end
function CommonData:setNectarNum(num) self.nectar_num = num end
function CommonData:getNectarCur() return self.nectar_cur end
function CommonData:setNectarCur(num) self.nectar_cur = num end
function CommonData:getBrewTimes() return self.brew_times end
function CommonData:setBrewTimes(times) self.brew_times = times end
function CommonData:getBrewStep() return self.brew_step end
function CommonData:setBrewStep(step) self.brew_step = step end

function CommonData:getBattleSpeed() return self.battle_speed end
function CommonData:setBattleSpeed(speed) self.battle_speed = speed end

-- 返回战斗力
function CommonData:getCombatPower() return self.combat_power end
function CommonData:setCombatPower(num) self.combat_power = num end

--返回战力排行
function CommonData:getPowerRank() return self.rank end


--------------------------
-- 当前头像ID
    -- if self.now_head == nil then
    --     if self.head == nil then
    --     else
    --         self.now_head = self.head[1]
    --     end
    -- end
-- end
function CommonData:setHead(id) self.now_head = id end

function CommonData:getHead()
    -- if self.now_head == nil then
    --     if self.head == nil then

    --     else
    --         self.now_head = self.head[1]
    --     end
    -- end
    return self.now_head
end

-- 所有头像ID
function CommonData:getHeadList() return self.head end
function CommonData:setHeadLIst(list) self.head = list end

-- 在头像列表中添加头像ID
function CommonData:addHeadLIstId(id) table.insert(self.head, id) end
--------------------------





-- 上次领取体力的时间
function CommonData:getLastStminaTime() return self.LastStminaTime end
function CommonData:setLastStminaTime(time) self.LastStminaTime = time end

-- 补签次数
function CommonData:setRepaireTimes(times) self.repaireTimes = times end
function CommonData:getRepaireTimes() return self.repaireTimes end
-- 签到列表
function CommonData:setSignedList(list)
    self.signedList = list
end
function CommonData:getSignedList() return self.signedList end
--当前签到为哪一组
function CommonData:setSignRound(roundId) self.SignRoundId = roundId end
function CommonData:getSignRound() return self.SignRoundId end
--当前签到为哪一天
function CommonData:setSignCurrDay(currday) self.SignCurrDay = currday end
function CommonData:getSignCurrDay() return self.SignCurrDay end

-- 武魂商店刷新次数
function CommonData:setSoul_shop_refresh_times(times)
     self.GameLoginResponse.soul_shop_refresh_times = self.GameLoginResponse.soul_shop_refresh_times + times
end
function CommonData:getSoul_shop_refresh_times() return self.GameLoginResponse.soul_shop_refresh_times end

-- 查询某天是否签过到
function CommonData:lookIsSigned(day)
    -- cclog("------------setSignedList---111-----"..day)
    -- table.print(self.signedList)
    for k,v in pairs(self.signedList) do
        if v == day then return true end
    end
    return false
end
-- 将某天签到状态改为已签到
function CommonData:setSignedByDay(day)
    -- cclog("-----------setSignedByDay--------")
    table.insert(self.signedList, day)
    -- table.insert(self.signedList, 3)
end
--[[--

设置连续签到的天数
@param days 连续签到的天数
]]
function CommonData:setContinuousSignDays(days) self.continuousSignDays = days end
--[[--

获取连续签到的天数

]]
function CommonData:getContinuousSignDays() return self.continuousSignDays end
--[[--

设置[7，15，25]天的连续签到的奖励
@param list [7，15，25]天的连续签到的奖励
]]
function CommonData:setContinuousSignedList(list) self.continuousSignedList = list end
--[[--

获取[7，15，25]天的连续签到的奖励

]]
function CommonData:getContinuousSignedList() return self.continuousSignedList end

function CommonData:setContinuousSignedByDay(day) table.insert(self.continuousSignedList, day) end
function CommonData:setCurContinuousSigned(reward) self.curRewardContinuousSigned = reward end
function CommonData:getCurContinuousSigned() return self.curRewardContinuousSigned end
--[[--

设置额外签到奖励
@param list  额外签到奖励列表

]]
function CommonData:setExtraSignGiftList(list)
    self.extraSignGiftList = list
end

--[[--
    获取的额外签到奖励
]]
function CommonData:getExtraSignGiftList()
    return self.extraSignGiftList
end
function CommonData:addExtraSignGiftListByID(id)
    table.insert(self.extraSignGiftList, id)
    cclog("----------------addExtraSignGiftListByID-------")
    table.print(self.extraSignGiftList)
end
-- 在线时间
-- function CommonData:setOnlineTime(time) self.onlineTimes = time end
-- function CommonData:getOnlineTime()
--     if not self.onlineTimes then
--         return 0
--     end
--     local nowTime = os.time()
--     local diff_time = nowTime - self.client_time
--     return self.onlineTimes + diff_time
-- end
function CommonData:setOnlineTime(time)
    -- cclog("---setOnlineTime-----"..time)
    self.onlineTimes = time
    -- self.getOnlineRec = os.time()
end

function CommonData:getOnlineTime()
    -- if not self.onlineTimes then
    --     return 0
    -- end
    -- local nowTime = os.time()
    -- local diff_time = nowTime - self.getOnlineRec
    -- return self.onlineTimes + diff_time
    --在线累计时间 + 服务器当前时间 - 客户端登陆时间
    return self.onlineTimes + self.srv_time - self.server_time
end

-- function CommonData:getLastOnlineTime() return self.LastOnlineTime end
-- function CommonData:setLastOnlineTime(time) self.LastOnlineTime = time end
-- 在线奖励
function CommonData:setOnlineGiftList(list) self.onlineGiftList = list end
function CommonData:addGotOnlineGift(giftId) table.insert(self.onlineGiftList, giftId) end
function CommonData:getGotOnlineGift(giftId) return self.onlineGiftList end
-- 查询在线奖励是否领取
function CommonData:isGetOnlineGift(id)
    if self.onlineGiftList == nil then return false end
    for k,v in pairs(self.onlineGiftList) do
        if v == id then return true end
    end
    return false
end

-- 等级奖励
function CommonData:setLevelGiftList(list) self.levelGiftList = list end
-- 添加已获得的等级奖励
function CommonData:addGotLevelGift(giftId) table.insert(self.levelGiftList, giftId) end
-- 查询等级奖励是否已经领取
function CommonData:isGetLevelGift(id)
    if self.levelGiftList == nil then return false end
    for k,v in pairs(self.levelGiftList) do
        if v == id then return true end
    end
    return false
end
-- 连续登陆奖励
function CommonData:setLoginContinueGiftList(list) self.loginContinueGiftList = list end
function CommonData:addLoginContinueGift(giftId) table.insert(self.loginContinueGiftList, giftId) end
function CommonData:isGetLoginContinueGift(id)
    if self.loginContinueGiftList == nil then return false end
    for k,v in pairs(self.loginContinueGiftList) do
        if v == id then return true end
    end
    return false
end
-- 累积登陆奖励
function CommonData:setLoginTotalGiftList(list) self.loginTotalGiftList = list end
function CommonData:addLoginTotalGift(giftId) table.insert(self.loginTotalGiftList, giftId) end
function CommonData:isGetLoginTotalGift(id)
    if self.loginTotalGiftList == nil then return false end
    for k,v in pairs(self.loginTotalGiftList) do
        if v == id then return true end
    end
    return false
end

function CommonData:getLoginTotalGiftList()
    return self.loginTotalGiftList
end

-- 累积登陆时间
function CommonData:setLoginTotalDay(day) self.loginTotalDay = day end
function CommonData:getLoginTotalDay() return self.loginTotalDay end

--连续登录奖励
function CommonData:setLoginContinueDay(day) self.loginContinueDay = day end
function CommonData:getLoginContinueDay() return self.loginContinueDay end

function CommonData:getHeroSoul() return self:getFinance(3) end
-- 增加武魂值
function CommonData:addHero_soul(num)
    --self.GameLoginResponse.hero_soul = self.GameLoginResponse.hero_soul + num
    self:addFinance(3, num)
end

--获取是否能领取累计登陆奖励
function CommonData:getIsCanGetTotleReward()
    -- print("getIsCanGetTotleReward-------")
    local totleBaseList = getTemplateManager():getBaseTemplate():getTotleBaseList()
    -- table.print(totleBaseList)
    -- print("getIsCanGetTotleReward-------")
    -- table.print(self.loginTotalGiftList)
    -- print("11111111111111")


    local loginTotalDay = self:getLoginTotalDay()
    -- print("loginTotalDay=====" .. loginTotalDay)
    for i = 1, loginTotalDay do
        local item = totleBaseList[i]
        local id = item.id
        local isGot = self:isGetLoginTotalGift(id)
        if isGot == false then
            return true
        end
    end
    return false
end

--获取是否可以领取连续登陆奖励
function CommonData:getIsCanGetSeriesReward()
    local serialBaseList = getTemplateManager():getBaseTemplate():getSerialBaseList()
    --print("<<======连续登陆列表=========>>")
    --table.print(serialBaseList)
    local serialTotalDay = self:getLoginContinueDay()
    for i = 1, serialTotalDay do
        local item = serialBaseList[i]
        local id = item.id
        local isGot = self:isGetLoginContinueGift(id)
        if isGot == false then
            return true
        end
    end
    return false
end

--获得是否可以领取战队等级奖励
function CommonData:getIsCanGetLevelReward()
    local lvBaglBaseList = getTemplateManager():getBaseTemplate():getLvBag()
    if self.level == 1 then
        return false
    end

    local size = self.level - 1
    for k, v in pairs(lvBaglBaseList) do
        local parameterA = v.parameterA
        if parameterA <= self.level then
            local id = v.id
            local isGot = self:isGetLevelGift(id)
            if isGot == false then
                return true
            end
        end
    end
    return false
end

-- 减少武魂值
function CommonData:reductionHero_soul(num)
    -- self.GameLoginResponse.hero_soul = self.GameLoginResponse.hero_soul - num
    self:subFinance(3, num)
end

-- -- 减少充值币
-- function CommonData:reductionGlod(num)
--     self.GameLoginResponse.gold = self.GameLoginResponse.gold - num
-- end

--pvp声望
function CommonData:getPvpStore()
    return self:getFinance(8)  --self.pvp_score
end
function CommonData:subPvpStore(num)
    -- self.pvp_score = self.pvp_score - num
    return self:subFinance(8, num)
end
function CommonData:setPvpStore(num)
    self:setFinance(8, num)
end
--玩家id
function CommonData:setAccountId(cur_id) self.accountId = cur_id end
function CommonData:getAccountId() return self.accountId end

--玩家头像id
-- function CommonData:setAccountId(cur_id) self.accountId = cur_id end
-- function CommonData:getAccountId() return self.accountId end

--玩家昵称
function CommonData:setUserName(cur_name) self.nickname = cur_name; getHomeBasicAttrView():updateUserName() end
function CommonData:getUserName() return self.nickname end

--vip
function CommonData:setVip(cur_vip)
    self.vip = cur_vip
    getHomeBasicAttrView():updateVip()
end
function CommonData:getVip() return self.vip end

--经验
function CommonData:setExp(cur_exp) self.exp = cur_exp; getHomeBasicAttrView():updateExp()  getNetManager():sendMsgAfterPlayerUpgrade() end
function CommonData:getExp() return self.exp end
function CommonData:addExp(num) self.exp = self:getExp() + num  getHomeBasicAttrView():updateExp()  getNetManager():sendMsgAfterPlayerUpgrade() end

--等级
function CommonData:setPlayerLevel(level)
    self.level = level
end

--等级
function CommonData:setLevel(level)

    print("setLevel---------level====", level)
    print("self.level====", self.level)
    self.isLeveled = false
    if self.level < level then
        self.oldLevel = self.level

        getNetManager():getInstanceNet():sendGropUpgrade()
        --getNewGManager():setIsGuideLevel()
        self.isLeveled = true

    end
    self.level = level

    --getHomePageView():updateViewLevel()
    getHomeBasicAttrView():updateLevel()
    getHomeBasicAttrView():updateExp()
end

function CommonData:getLevel() return self.level end

--升级前的等级
function CommonData:getOldLevel() return self.oldLevel end
--升级前的体力
function CommonData:getOldStamina() return self.oldStamina end
--升级前的体力
function CommonData:setOldStamina(value)
    self.oldStamina = value
end

--体力
function CommonData:setStamina(cur_stamina)
    self:setFinance(7, cur_stamina)
    getHomeBasicAttrView():updateStamina()
end
function CommonData:getStamina() return self:getFinance(7) end
function CommonData:addStamina(num) self:setFinance(7, self:getFinance(7) + num); getHomeBasicAttrView():updateStamina() end

--购买体力次数
function CommonData:getBuyStaminaTimes() return self.buy_stamina_times end
function CommonData:addBuyStaminaTimes() self.buy_stamina_times = self.buy_stamina_times + 1 end

--元宝
function CommonData:setGold(cur_gold)
    -- self.gold = cur_gold
    self:setFinance(2, cur_gold)
    getHomeBasicAttrView():updateGold()
end
function CommonData:getGold() return self:getFinance(2) end --self.gold end

--金币
function CommonData:setCoin(cur_coin)
    -- self.coin = cur_coin
    if cur_coin <= 0 then
        cur_coin = 0
    end
    self:setFinance(1, cur_coin)
    getHomeBasicAttrView():updateCoin()
end
function CommonData:getCoin() return self:getFinance(1) end -- self.coin end

--一般装备上次抽取时间
function CommonData:setFineEquipment(cur_fine_equipment) self.fine_equipment = cur_fine_equipment end
function CommonData:getFineEquipment() return self.fine_equipment end
--良将上次免费抽取的时间
function CommonData:setFineHero(cur_fine_hero) self.fine_hero = cur_fine_hero end
function CommonData:getFineHero() return self.fine_hero end

--神兵利器上次抽取时间
function CommonData:setExcellentEquipment(cur_excellent_equipment) self.excellent_equipment = cur_excellent_equipment end
function CommonData:getExcellentEquipment() return self.excellent_equipment end
--神将上次免费抽取时间
function CommonData:setExcellentHero(cur_excellent_hero) self.excellent_hero = cur_excellent_hero end
function CommonData:getExcellentHero() return self.excellent_hero end

--初级熔炼石
function CommonData:setJuniorStone(cur_junior_stone) self.junior_stone = cur_junior_stone end
function CommonData:addJuniorStone(num) self.junior_stone = self:addNum(self.junior_stone, num) end
function CommonData:getJuniorStone() return self.junior_stone end

--中级熔炼石
function CommonData:setMiddleStone(cur_middle_stone) self.middle_stone = cur_middle_stone end
function CommonData:addMiddleStone(num) self.middle_stone = self:addNum(self.middle_stone, num) end
function CommonData:getMiddleStone() return self.middle_stone end

--高级熔炼石
function CommonData:setHighStone(cur_high_stone) self.high_stone = cur_high_stone end
function CommonData:addHighStone(num) self.high_stone = self:addNum(self.high_stone, num) end
function CommonData:getHighStone() return self.high_stone end

--对战次数
function CommonData:setPvpTimes(cur_pvp_times) self.pvp_times = cur_pvp_times end
function CommonData:getPvpTimes() return self.pvp_times end

--挑战次数重置的次数
function CommonData:setPvpRefreshCount(cur_count) self.pvp_refresh_count = cur_count end
function CommonData:getPvpRefreshCount() return self.pvp_refresh_count end
function CommonData:updatePvpRefreshCount(count)
    self.pvp_refresh_count = self.pvp_refresh_count + count
end
-- 加num的银子
-- @num: 添加的银子数量
function CommonData:addCoin(num) self:addFinance(1, num);getHomeBasicAttrView():updateCoin(); end
-- 扣除num的银子
-- @num: 银子的数量，正数
function CommonData:subCoin(num) self:subFinance(1, num);getHomeBasicAttrView():updateCoin(); end

-- 加num的金子
-- @num: 添加的金子数量
function CommonData:addGold(num) self:addFinance(2, num);getHomeBasicAttrView():updateGold(); end
-- 扣除num的金子
-- @num: 金子的数量，正数
function CommonData:subGold(num) self:subFinance(2, num); getHomeBasicAttrView():updateGold(); end

-- 修改战斗力
function CommonData:updateCombatPower() getHomeBasicAttrView():updateCombatPower(); end

--[[--
得到通关令的数量
@return number 通关令的数量
]]
function CommonData:getClearanceCoin()
    return self.finances[27+1] or 0
end

--[[--
更改通关令的数量
@param number num 修改的数量(正数为增加,负数为减少)
]]
function CommonData:changeClearanceCoin(num) 
    self:subFinance(27, num);
    if self.finances[27+1] then
        self.finances[27+1] = self.finances[27+1] + num
    end
end

-----------------------------
------private function-------
-----------------------------

-- 给某值加addNum
function CommonData:addNum(theNum, addNum)
	assert(addNum >= 0, "the add number must more then 0 !")

	theNum = theNum + addNum
	return theNum
end

-- 给某值减去subNum
function CommonData:subNum(theNum, subNum)
	assert(subNum >= 0 and theNum >= subNum, "the sub number must more than 0 !")
	theNum = theNum - subNum
	return theNum
end

--[[--
    体力的恢复，目前不需要了
    用resRecoverTime 代替
]]
function CommonData:countTimer()
    print("～～～～～～～～～～～")
    -- local recoverTime = getTemplateManager():getBaseTemplate():getStaminaRecoverTime()   -- 300秒
    -- local max = getTemplateManager():getBaseTemplate():getStaminaMax()                   -- 最大体力
    -- -- self.during_time = 0
    -- local x = self.last_gain_stamina_time
    -- -- self.during_time = self.server_time - x
    -- self.during_time = self:getTime() - x

    -- -- print(self.during_time)
    -- -- self:getTime()

    -- local function updateTimer(dt)

    --     -- print("----- updateTimer ------")
    --     -- self.server_time = self.server_time + 1
    --     self.during_time = self.during_time + 1
    --     if self.during_time >= recoverTime then
    --         -- print("--------- 10到 -------------")
    --         if self:getStamina() < max then
    --             getNetManager():getActivityNet():sendRecoverStamina()
    --             self.during_time = 0
    --             self.last_gain_stamina_time = self:getTime()
    --         end
    --     end
    -- end
    -- timer.scheduleGlobal(updateTimer, 1.0)
end
--[[--
    体力恢复剩余时间
]]
function CommonData:countTime()
    return self.buy_times[RES_TYPE.STAMINA].retainTime
end

function CommonData:getResBuyTimeByType(type)
    return self.buy_times[type]
end

--[[--
    可恢复性资源统一恢复时间计时
    目前包含（体力、讨伐令、鞋子）,先处理讨
]]
function CommonData:resRecoverTime()

    local resTemp = getTemplateManager():getResourceTemplate()

    for k,v in pairs(self.buy_times) do
        local rescfg = resTemp:getResById(k)
        v.buyPrice = rescfg.buyPrice
        v.storageMax = rescfg.storageMax
        v.recoveryTime = rescfg.recoveryTime
        v.buyNumber = rescfg.buyOneNumber
        v.recoverNumber = rescfg.recoveryNumber
        v.retainTime = 0
    end

    print("CommonData:resRecoverTime=====>begin")
    table.print(self.buy_times)
    print("CommonData:resRecoverTime====>end")
    if self.updateResTimer then
        timer.unscheduleGlobal(self.updateResTimer)
        self.updateResTimer = nil
    end

    local function updateTimer(dt)
        local curTime = self:getTime()
        for k,v in pairs(self.buy_times) do
            if v.storageMax ~= nil then
                local cur = self:getFinance(k)
                if cur<v.storageMax then
                    v.retainTime = v.last_gain_time + v.recoveryTime - curTime --剩余时间
                    if v.last_gain_time + v.recoveryTime <= curTime then --时间到
                        getNetManager():getActivityNet():sendAutoAddRes(k,v.recoverNumber)
                        v.last_gain_time = curTime
                    end
                else
                    v.retainTime = 0 --剩余时间
                    v.last_gain_time = curTime
                end
            end
        end
    end
    self.updateResTimer = timer.scheduleGlobal(updateTimer,1.0)
end

-- function CommonData:countOnlineTime()
--     local function updateTimer( dt )
--         self.onlineTimes = self.onlineTimes + 1
--     end
--     if self.timerOnline ~= nil then
--         timer.unscheduleGlobal(self.timerOnline)
--         self.timerOnline = nil
--     end
--     self.timerOnline = timer.scheduleGlobal(updateTimer, 1.0)
-- end

--@return
---- 检测时间是否为可领取体力时间
function CommonData:isFeastTime(_timeCanGet)
    local function getTheTimeMin(_hour, _min)
        return _hour*60 + _min
    end

    local _curHour = self:getCurrHour()
    local _curMin = self:getCurrMin()
   -- print("current :", _curHour,_curMin)
    for k,v in pairs(_timeCanGet) do
    -- print(v.startHour, v.startMin, v.endedHour, v.endedMin)
        if getTheTimeMin(v.startHour,v.startMin) <= getTheTimeMin(_curHour,_curMin) and
                getTheTimeMin(v.endedHour,v.endedMin) > getTheTimeMin(_curHour,_curMin) then
            return true
        end
    end
    return false
end

function CommonData:isEatFeast(_timeCanGet) -- 检测是否已经吃过了
    local _curHour = self:getCurrHour()
    local _curMin = self:getCurrMin()
    local _curDay = self:getDay()
    local _curMonth = self:getMonth()
    local _curYear = self:getYear()
    local _lastTime = self:getLastStminaTime()
    local _lastTimeHour = os.date("*t", _lastTime).hour
    local _lastTimeMin = os.date("*t", _lastTime).min
    local _lastTimeDay = os.date("*t", _lastTime).day
    local _lastTimeMonth = os.date("*t", _lastTime).month
    local _lastTimeYear = os.date("*t", _lastTime).year

    local function getTheTimeMin(_hour, _min)
        return _hour*60 + _min
    end

    local function inWhichTime(hour,min)
        local index = 1
        for k,v in pairs(_timeCanGet) do
            -- print(v.startHour, v.startMin, v.endedHour, v.endedMin)
            if getTheTimeMin(v.startHour,v.startMin) <= getTheTimeMin(hour,min) and
                    getTheTimeMin(v.endedHour,v.endedMin) > getTheTimeMin(hour,min) then
                return index
            end
            index = index + 1
        end
    end

    if _lastTimeYear == _curYear and _lastTimeMonth == _curMonth and _lastTimeDay == _curDay then -- Sameday
        local _curWhich = inWhichTime(_curHour,_curMin)
        local _lastWhich = inWhichTime(_lastTimeHour,_lastTimeMin)
        if _curWhich == _lastWhich then return true -- 同一时间段，已经吃了
        else return false
        end
    else -- not same day
        return false
    end
end

function CommonData:getTimeCanGet()
    local function onToTime(strTime) -- 解析出时间
        local _len = string.len(strTime)
        local _posS, _posE = string.find(strTime, ":")
        if _posS == _posE then
            local _hour = tonumber(string.sub(strTime, 1, _posS-1))
            local _min = tonumber(string.sub(strTime, _posS+1, _len))
            return _hour, _min
        else
            print("!!!base_config表中manual_time有数据错误")
        end
    end

    local _stamina_time = getTemplateManager():getBaseTemplate():getManualTime()

    local _timeCanGet = {}  -- 保存可领取体力的时间{{startHour,startMin,endedHour,endedMin}...}
    for k,v in pairs(_stamina_time) do
        local str = v[1] .. "-" .. v[2]
        _timeCanGet[k] = {}
        _timeCanGet[k].startHour,
        _timeCanGet[k].startMin = onToTime(v[1])
        _timeCanGet[k].endedHour,
        _timeCanGet[k].endedMin = onToTime(v[2])
    end
    return _timeCanGet
end

-- 煮酒
function CommonData:isOpenBrew()
    local startLv = self.baseTemp:getBrewStartLevel()

end

-- pvp
function CommonData:isOpenArena()
    local startLv = self.baseTemp:getArenaLevel()

end

-- 秘境
function CommonData:isOpenRune()
    local startLv = self.baseTemp:getRuneLevel()

end

-- 世界boss
function CommonData:isOpenWorldBoss()
    local startLv = self.baseTemp:openWorldBossLevel()

end
----------------充值活动相关-------------------------
--初始化充值活动
function CommonData:setRechargeActivityData(data)
    cclog("------------初始化充值活动-----------")
    table.print(data)
    self.rechargeData = data
    for k,v in pairs (self.rechargeData) do
        if v.data.recharge_time ~= nil then print("----recharge_time---"..v.data.recharge_time) end
        if v.gift_type == 9 then
            self.rechargeAcc = v.data[1].recharge_accumulation
        end
    end
end

--[[--
    充值活动是否可领取
    @param int id 奖品id
]]
function CommonData:rechargeGiftCanGet(id)
    cclog("--------------id---------"..id)
    if self.rechargeData == nil then return false end
    for k,v in pairs(self.rechargeData) do
        if v.gift_id == id then
            return true
        end
    end
    return false
end

--[[--
    充值活动奖励是否领取过
    @param int id 奖品id
]]
function CommonData:rechargeGiftIsGot(id)
    if self.rechargeData == nil then return false end
    for k,v in pairs(self.rechargeData) do
        if v.gift_id == id then
            if v.data[1].is_receive == 0 then return false
            elseif v.data[1].is_receive == 1 then return true end
        end
    end
    return false
end

--[[--
    活动的累计充值数
]]
function  CommonData:getRechargeAcc()
    if self.rechargeAcc == nil then self.rechargeAcc = 0 end
    return self.rechargeAcc
end

--[[--
    活动的单次充值数
    @param int id 奖品id
]]
function  CommonData:getRechargeSingle(id)
     local rechargeSingle  = 0
     if self.rechargeData == nil then return rechargeSingle end
     for k,v in pairs(self.rechargeData) do
         if v.gift_id == id then

            if v.data[1].recharge_accumulation == nil then
                return rechargeSingle
            else
                return v.data[1].recharge_accumulation
            end
         end
     end
    return rechargeSingle
end
--[[--
    活动在点击领取时候的发送信息
    @param int id 奖品id
]]
function CommonData:getSendInfo(id)
    for k,v in pairs(self.rechargeData) do
        if v.gift_id == id then
            return v
        end
    end
end

--[[--
    设置某一奖励领取了
    @param int id 奖品id
]]
function CommonData:setRechargeGiftGot(id)
    if self.rechargeData == nil then return end
    for k,v in pairs(self.rechargeData) do
        if v.gift_id == id then
            if v.data[1].is_receive == 0 then
            v.data[1].is_receive = 1 end
        end
    end
end
function CommonData:giftCanGetByType(_type)
    for k,v in pairs(self.rechargeData) do
        if v.gift_type == _type then
            if v.data[1].is_receive == 0 then return true end
        end
    end
    return false
end

--解析xxxx-xx-xx xx:xx:xx - yyyy-yy-yy yy:yy:yy的时间类型
function CommonData:analysisTime(timeStr)

    local function toTimeTable(timeStr)

        local timeTab = {}
        local strlen = string.len(timeStr)
        local pos = string.find(timeStr, " ")
        local data = string.sub(timeStr,1,pos-1)
        local timex = string.sub(timeStr,pos+1,strlen)

        local str = data
        local pos = string.find(str,"-")
        local year = tonumber(string.sub(str,1,pos-1))
        str = string.sub(str,pos+1,-1)
        pos = string.find(str,"-")
        local month = tonumber(string.sub(str,1,pos-1))
        local day = tonumber(string.sub(str,pos+1,-1))

        local str2 = timex
        pos = string.find(str2,":")
        local hour = tonumber(string.sub(str2,1,pos-1))
        print("之前 ======== hour ===== ", hour)
        if hour < 10 then
            hour = "0" .. hour
        end
        print("之后 ======== hour ===== ", hour)
        str2 = string.sub(str2,pos+1,-1)
        pos = string.find(str2,":")
        local min = tonumber(string.sub(str2,1,pos-1))
        if min < 10 then
            min = "0" .. min
        end
        local sec = tonumber(string.sub(str2,pos+1,-1))

        timeTab = {year = year,month = month,day = day,hour = hour,min = min,sec = sec}
        return timeTab
    end

    local strlen = string.len(timeStr)
    local startTime = string.sub(timeStr,1,(strlen+1)/2-2)
    local endTime = string.sub(timeStr,(strlen+1)/2+2,strlen)

    local startTimeTab = toTimeTable(startTime)
    local endTimeTab = toTimeTable(endTime)

    return startTimeTab,endTimeTab
end

--解析xx:xx:xx的时间类型
function CommonData:analysisTime1(timeStr)

    local function toTimeTable(timeStr)
        local timeTab = {}
        local strlen = string.len(timeStr)
        local str = timeStr
        local pos = string.find(str,":")
        local hour = tonumber(string.sub(str,1,pos-1))
        str = string.sub(str,pos+1,-1)
        pos = string.find(str,":")
        local min = tonumber(string.sub(str,1,pos-1))
        local sec = tonumber(string.sub(str,pos+1,-1))
        timeTab = {hour = hour,min = min,sec = sec}
        return timeTab
    end

    local strlen = string.len(timeStr)
    local startTime = string.sub(timeStr,1,strlen)
    local startTimeTab = toTimeTable(startTime)
    return startTimeTab.hour*3600 + startTimeTab.min*60 + startTimeTab.sec ,startTimeTab
end

--充值数据累计
function CommonData:setRechargeNum(rechargeNum)
    self.totalRecharge = rechargeNum
end

--获取充值数据
function CommonData:getRechargeNum()
    return self.totalRecharge
end

--良将累计抽取次数
function CommonData:setNormalHeroTimes(times)
    local perTimes = getTemplateManager():getBaseTemplate():getNormalHeroPerTimes()
    if times >= perTimes then
        times = 0
    end
    self.normalHeroTimes = times
end

function CommonData:getNormalHeroTimes()
    return self.normalHeroTimes
end

--神将累计抽取次数
function CommonData:setGodHeroTimes(times)
    local perTimes = getTemplateManager():getBaseTemplate():getGodHeroPerTimes()
    if times >= perTimes then
        times = 0
    end
    self.godHeroTimes = times
end

function CommonData:getGodHeroTimes()
    return self.godHeroTimes
end

--[[--
    
    判断次日开启的功能开启时间
    @param type 23,蛊雕之乱 2,任务 27, 黄巾起义 28, 过关斩将
    @return string 开启时间
]]
function CommonData:contentOpenTime(type)
    print("type====>>",type)
    local _type = type
    if _type == nil  then return nil end

    local _itemOpenDay = nil
    if _type == const.nextDay_openType.WORLDBOSS then
        _itemOpenDay = self.c_BaseTemplate:getWorldbossOpenDay()  -- 蛊雕之乱
    elseif _type == const.nextDay_openType.ACTIVITY then
        _itemOpenDay = self.c_BaseTemplate:getActivityOpenDay()  -- 任务
    elseif _type == const.nextDay_openType.HJQY then
        _itemOpenDay = self.c_BaseTemplate:getHjqyOpenDay() -- 黄巾起义
    elseif _type == const.nextDay_openType.GGZJ then
        _itemOpenDay = self.c_BaseTemplate:getGgzjOpenDay() -- 过关斩将
    end

    if _itemOpenDay == nil then print("<<=====is null=====>>") return nil end

    for k,v in pairs(_itemOpenDay) do
        return v[1]
    end

end
--[[--
    
    判断次日开启的功能是否开启
    @param type 23,蛊雕之乱 2,任务 27, 黄巾起义 28, 过关斩将
    @return bool 是否开启
]]
function CommonData:isOpenByType(type)
    local _type = type
    if _type == nil then return false end

    local _item = {1,1,1,1}
    local _itemOpenDay = nil
    if _type == const.nextDay_openType.WORLDBOSS then
        _itemOpenDay = self.c_BaseTemplate:getWorldbossOpenDay()  -- 蛊雕之乱
    elseif _type == const.nextDay_openType.ACTIVITY then
        _itemOpenDay = self.c_BaseTemplate:getActivityOpenDay()  -- 任务
    elseif _type == const.nextDay_openType.HJQY then
        _itemOpenDay = self.c_BaseTemplate:getHjqyOpenDay() -- 黄巾起义
    elseif _type == const.nextDay_openType.GGZJ then
        _itemOpenDay = self.c_BaseTemplate:getGgzjOpenDay() -- 过关斩将
    end

    if _itemOpenDay == nil then return false end

   for k,v in pairs(_itemOpenDay) do
        _item.day = tonum(k)
        _item.time = v[1]
       break
   end

   local _day_ = (_item.day<2 and 1) or (_item.day-1)

    local  _regist_time = self:getRegistTime()

    local nextDaytime = os.date("*t", tonumber(_regist_time) + tonumber(_day_*24*60*60))  

    local curYear = self:getYear()
    local curMonth = self:getMonth()
    local curDay = self:getDay()
    local curHour = self:getCurrHour()
    local curMin = self:getCurrMin()
    local curSec = self:getCurSec()

    --当前时间
    local nowTime = os.time({year = curYear, month = curMonth, day = curDay, hour = curHour, min = curMin, sec = curSec})

    -- 次日开启时间
    local times = string.split(_item.time, ":")

    local destTime = os.time({year = nextDaytime.year, month = nextDaytime.month, day = nextDaytime.day, hour = tonum(times[1]), min = tonum(times[2]), sec = tonum(times[3])})
   
    local _left_open_time = destTime - nowTime

    print("---_left_open_time-----")
    print(_left_open_time)

    return _left_open_time <= 0 
end


return CommonData