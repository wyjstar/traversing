--- 公共数据
--
--	包括，玩家信息，银币，金币，战斗力 等等
--
local CustomTask = import("...util.CustomTask")
local CommonData = class("CommonData")

function CommonData:ctor(item)
    EventProtocol.extend(self)    
    self.GameLoginResponse = {}
    self.LastStminaTime = nil  -- 上次领取体力时间
    self.AccountResponse = {} -- 注册成功返回数据
    self.isTourist = false
    self.totalRecharge = 0
    self.iscanZcjb = false
    self.netTip = nil
    self.oldLevel = 0 --战队升级前的等级
    self.isHasRebate = false
    self.rank = 0

    self.sealRedData = nil -- 经脉红点数据(nil:需要重新计算是否有红点, ture:有红点, false:无红点)
    
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

end

--初始化定时器
function CommonData:initTasks()
    --24:00的定时器
    self:initRefreshTime24()
    

    --9:00刷新的定时器

end

function CommonData:initRefreshTime24()
    local curYear = self:getYear()
    local curMonth = self:getMonth()
    local curDay = self:getDay()
    local taskTime = {year = curYear, month = curMonth, day = curDay, hour = 24, min = 0, sec = 0} 
    self.refreshTime24 = os.time(taskTime) + 30 --延迟30秒进行同步数据
    local subTime = self.refreshTime24 - self:getTime()
    getDataManager():pushTask(CustomTask.new(handler(self,self.updateRefreshTime24), subTime,1))
end

function CommonData:updateRefreshTime24(task,dt)
    print("CommonData:updateRefreshTime24",dt)
    --定时器到24点
    getNetManager():getActivityNet():sendGetOnlineLevelGiftList()   -- 在线奖励
    getNetManager():getActivityNet():sendGetLoginGiftListMsg()      -- 连续登陆奖励
    getNetManager():getActivityNet():sendGetLoginGiftListMsg()      -- 累计登陆奖励
    getNetManager():getActivityNet():sendZcjbGetdata()              -- 招财进宝奖励
    getNetManager():getActivityNet():sendGetBrewInfoMsg()           -- 煮酒数据
    getNetManager():getActivityNet():sendGetLegionList()            -- 军团活动奖励
    getNetManager():getActivityNet():sendGetConsumeResList()        -- 累计活动奖励
    getNetManager():getInstanceNet():sendGetAllStageInfoMsg()       -- 全部关卡信息
    getNetManager():getLoginNet():sendRefreshPlayer()               -- 刷新登陆信息
    getNetManager():getSignNet():sendGetSignListMsg()               -- 签到刷新
    getNetManager():getSevenDayNet():sendGetDayList(0)              -- 七日活动刷新
    getNetManager():getSoldierNet():sendGetSoldierMsg()             -- 武将数据刷新
    --重置定时器
    task:setEnabled(false)
    self:initRefreshTime24()
    self:dispatchEvent(EventName.UPDATE_REFRESH_24)
end

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
    print("accountId:",self.accountId)
    self.nickname = data.nickname                       --玩家昵称
    self.register_time = data.register_time
    --cclog("----π－－－－"..self.register_time.."等级:"..data.level)
    self.vip = data.vip_level                           --vip等级
    self.exp = data.exp                                 --经验
    self.level = data.level                             --等级
    self.oldLevel = self.level
    -- 将等级写入到userdefault中
    saveTeamLevel(self.level)
    --button_one_time服务端从0开始，客户端要+1
    self.isCiriOpened = data.button_one_time[0+1]  --次日开启功能是否已开启过
    self.isFirstRechargeRewardGot = data.button_one_time[1+1] --是否领过首冲好礼 -1没领过，1领过
    
    -- self.stamina = data.stamina                         --体力
    self.totalRecharge = data.recharge                   --累计充值
    self.normalHeroTimes = data.fine_hero_times           --良将累计抽取次数
    self.godHeroTimes = data.excellent_hero_times         --神将累计抽取次数

    if (data.newbee_guide_id == 0) then
        getNewGManager():updateBaseInfo(GuideId.G_GUIDE_START)  --新手引导记录编号
    else
        getNewGManager():updateBaseInfo(data.newbee_guide_id)
    end
    print("---------------------------------------------------data.newbee_guide_id",data.newbee_guide_id)

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
    self.max_combat_power = data.hight_power--data.max_combat_power   --历史最高战力
    self.get_stamina_times = data.get_stamina_times     -- 通过邮件获取体力次数
    self.buy_stamina_times = data.buy_stamina_times     -- 购买体力次数
    print("------self.buy_stamina_times--------",self.buy_stamina_times)

    self.last_gain_stamina_time = data.last_gain_stamina_time -- 上次获得体力时间


    self.head = data.head             --头像列表
    self.now_head = data.now_head     --当前头像id

    self.tomorrow_gift = data.tomorrow_gift     -- 次日登陆奖励是否收到
    print("tomorrow_gift = ", self.tomorrow_gift)

    self.battle_speed = data.battle_speed or 1 --战斗速度

    self.srv_time = data.server_time                --服务器时间，每秒进行更新
    self.serverOpenTime = data.server_open_time            --开服时间

    self.buy_times = {} --data.buy_times                 --购买资源（体力，讨伐令，鞋子）次数

    if data.buy_times then
        for k,v in pairs(data.buy_times) do --{资源类型,购买次数,上次获得体力时间}
            self.buy_times[v.resource_type] = {resource_type=v.resource_type,buy_stamina_times = v.buy_stamina_times,last_gain_time = v.last_gain_stamina_time}
        end
        --TODO:ADD RES_TYPE.ROB_NUM
        -- if self.buy_times[RES_TYPE.ROB_NUM] == nil then
        --     self.buy_times[RES_TYPE.ROB_NUM] = {resource_type=RES_TYPE.ROB_NUM,buy_stamina_times = 0,last_gain_time = 0}
        -- end
    end
    print("buy_times:====>")
    table.print(self.buy_times)

    self:updateSrvTimer()
    self:resRecoverTime()

    self:setPowerRank(data.fight_power_rank)

    self:setPvpOvercomeIndex(data.pvp_overcome_index)                  -- 过关斩将当前进行的关卡(从0开始计数)
    self:setPvpOvercomeRefreshCount(data.pvp_overcome_refresh_count)   -- 可刷新的次数

    self:setStoryId(data.story_id)

    --初始化定时器
    self:initTasks()

end

--[[--
    设置剧情Id
]]
function CommonData:setStoryId(story_id )
    print("CommonData:setStoryId==>",story_id)
    self.storyId_ = story_id
end

--[[--
    获取剧情关卡Id
]]
function CommonData:getStoryId()
    return self.storyId_
end

--[[--
    设置是否显示战队提升
]]
function CommonData:setShowUpgrad(_value)
    self.showUpgrad = _value
end

--[[--
    获取是否显示战队提升
]]
function CommonData:getShowUpgrad()
    return self.showUpgrad
end

--[[--
    刷新用户数据
    - 返回的数据结构与Login相同，但是目前只有以下字段有数据，需要添加时与服务协商添加
]]
function CommonData:refreshData(data)
    if data.buy_times then
        print("before update")
        table.print(self.buy_times)
        for k,v in pairs(data.buy_times) do --{资源类型,购买次数,上次获得体力时间}
            if self.buy_times[v.resource_type] ~= nil then
                self.buy_times[v.resource_type].buy_stamina_times = v.buy_stamina_times
            end
        end
        print("after update")
        table.print(self.buy_times)
    end

    print("CommonData:refreshData==>",data.pvp_times,"    ",data.pvp_refresh_count,"  ",data.pvp_overcome_index,"   ",data.pvp_overcome_refresh_count)

    self:setPvpTimes(data.pvp_times)
    self:setPvpRefreshCount(data.pvp_refresh_count)
    self:setPvpOvercomeIndex(data.pvp_overcome_index)                  -- 过关斩将当前进行的关卡(从0开始计数)
    self:setPvpOvercomeRefreshCount(data.pvp_overcome_refresh_count)   -- 可刷新的次数

    self:setPowerRank(data.fight_power_rank)
end

--是否领取过首冲好礼
function CommonData:getFirstRechargeRewardGot()
    if self.isFirstRechargeRewardGot == 1 then
        return true
    else
        return false
    end
end

--缓存次日开启已经开启过
function CommonData:setIsCiriOpend()
    self.isCiriOpened = true
end

--次日开启功能是否已开启过
function CommonData:getIsCiriOpend()
    return self.isCiriOpened ~= 0 
end

function CommonData:setPowerRank(rank)
    self.rank = rank
end
function CommonData:setServerOpenTime(timeStr)
    -- body
    self.serverOpenTime = timeStr
end
function CommonData:getServerOpenTime()
    -- body
    return self.serverOpenTime
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

--[[--
获得资源数量
@param number type 资源的类型
]]
function CommonData:getFinance(type_)
    -- table.print(self.finances)
    -- print("CommonData:getFinance=============>type", type_)
    if not self.finances[type_+1] then
        error("CommonData:getFinance error, value is nil , type="..type_)
    end
    if self.finances[type_+1] < 0 then
        self.finances[type_+1] = 0
    end
    return self.finances[type_+1]
end

function CommonData:setFinance(type_, num)
    print("CommonData:setFinance==================>",type_, num)
    if num < 0 then num = 0 end
    self.finances[type_+1] = num
    
    if type_ == RES_TYPE.STAMINA then
        self:dispatchEvent(EventName.UPDATE_TL)
    elseif type_ == RES_TYPE.GOLD then
        self:dispatchEvent(EventName.UPDATE_GOLD)   
        --print("<<=======send UPDATE_GOLD event=======>>")     
    elseif type_ == RES_TYPE.COIN then
        self:dispatchEvent(EventName.UPDATE_SILVER)
    elseif type_ == RES_TYPE.QJYL then
        self.sealRedData = nil
        self:dispatchEvent(EventName.UPDATE_QJYL)
    elseif type_ == RES_TYPE.ENERGY then
        self:dispatchEvent(EventName.UPDATE_ENERGY) 
    elseif type_ == RES_TYPE.ROB_NUM then
        self:dispatchEvent(EventName.UPDATE_ROB_NUM)
    elseif type_ == RES_TYPE.SHOES then -- 游历消耗鞋子需要通知游历主界面和章节游历界面
        self:dispatchEvent(EventName.UPDATE_TRAVEL)
    elseif type_ == RES_TYPE.ROB_NUM then
        self:dispatchEvent(EventName.UPDATE_ROB_NUM)
    end
end

function CommonData:subFinance(type_, num)
    print("CommonData:subFinance==================>",type_, num)     
    if self.finances[type_+1] then
        self:setFinance(type_, self.finances[type_+1] - num)
    end

    if type_ == RES_TYPE.PVP_SCROE then  -- 消耗军功
        self:dispatchEvent(EventName.SUB_PVP_SCROE)
    end
end

function CommonData:addFinance(type_, num)
    print("CommonData:addFinance==================>",type_, num) 
    if self.finances[type_+1] then
        if type_ == RES_TYPE.PLAYER_EXP then        -- 如果是战队经验 单独添加
            self:addExp(num)
        else
            self:setFinance(type_, self.finances[type_+1] + num)
        end 
    end 
end

function CommonData:getRegistTime()
    -- cclog("------新用户的注册时间－－－－－－－"..self.register_time)
    return self.register_time
end

-- 装备精华
function CommonData:getEquipSoul()
    return self:getFinance(RES_TYPE.EQUIP_SOUL)
end

function CommonData:subEquipSoul(num)
    self:subFinance(RES_TYPE.EQUIP_SOUL, num)
end
function CommonData:addEquipSoul(num)
    self:addFinance(RES_TYPE.EQUIP_SOUL, num)
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
    return self:getFinance(RES_TYPE.YUANQI)
end
-- 元气
function CommonData:setYuanqi(num)
    self:setFinance(RES_TYPE.YUANQI, num)
    self:dispatchEvent(EventName.UPDATE_YUANQI)
end
-- 元气
function CommonData:subYuanqi(num)
    self:subFinance(RES_TYPE.YUANQI, num)
    self:dispatchEvent(EventName.UPDATE_YUANQI)
end
-- 元气
function CommonData:addYuanqi(num)
    self:addFinance(RES_TYPE.YUANQI, num)
    self:dispatchEvent(EventName.UPDATE_YUANQI)
end


-- 返回模拟的服务器时间（客户端以服务器时间为准）
function CommonData:getTime()
    return math.floor(self.srv_time or 0)
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
function CommonData:setBrewTimes(times) 
    self.brew_times = times
    -- 发送红点消息
    self:dispatchEvent(EventName.UPDATE_WINE)
end
function CommonData:getBrewStep() return self.brew_step end
function CommonData:setBrewStep(step) self.brew_step = step end

function CommonData:getBattleSpeed() return self.battle_speed end
function CommonData:setBattleSpeed(speed) self.battle_speed = speed end

-- 返回战斗力
function CommonData:getCombatPower() return roundNumber(self.combat_power) end
function CommonData:setCombatPower(num) self.combat_power = num end

--返回最高战力
function CommonData:getMaxCombatPower() 
    if self.max_combat_power == nil then self.max_combat_power = 0 end
    return roundNumber(self.max_combat_power) 
end
--设置最高战力
function CommonData:setMaxCombatPower(num) self.max_combat_power = num end

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
function CommonData:setHead(id) 
    self.now_head = id
    self:dispatchEvent(EventName.UPDATE_HEAD) 
end

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
function CommonData:addHeadLIstId(id)
    for k,v in pairs(self.head) do
        if v == id then -- 重复ID不必添加
            return
        end
    end
    table.insert(self.head, id) 
end
--------------------------

-- 通用资源:鞋子
function CommonData:getShoesBuyTimes() return self.buy_times[RES_TYPE.SHOES].buy_stamina_times end     -- 已购买的鞋子数量
function CommonData:getShoesStorageMax() return self.buy_times[RES_TYPE.SHOES].storageMax end          -- 最大的鞋子数量
function CommonData:getShoesRetainTime() return self.buy_times[RES_TYPE.SHOES].retainTime end          -- 剩余恢复时间

-- 上次领取体力的时间
function CommonData:getLastStminaTime() return self.LastStminaTime end
function CommonData:setLastStminaTime(time) self.LastStminaTime = time end


-- 武魂商店刷新次数
function CommonData:setSoul_shop_refresh_times(times)
     self.GameLoginResponse.soul_shop_refresh_times = self.GameLoginResponse.soul_shop_refresh_times + times
end
function CommonData:getSoul_shop_refresh_times() return self.GameLoginResponse.soul_shop_refresh_times end

function CommonData:setOnlineTime(time)
    -- cclog("---setOnlineTime-----"..time)
    self.onlineTimes = time
    self.server_time = self:getTime()
    -- self.getOnlineRec = os.time()
end

function CommonData:getOnlineTime()
    return self.onlineTimes + self:getTime() - self.server_time
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

function CommonData:getHeroSoul() return self:getFinance(RES_TYPE.HERO_SOUL) end
-- 增加武魂值
function CommonData:addHero_soul(num)
    --self.GameLoginResponse.hero_soul = self.GameLoginResponse.hero_soul + num
    self:addFinance(RES_TYPE.HERO_SOUL, num)
end

-- 减少武魂值
function CommonData:reductionHero_soul(num)
    -- self.GameLoginResponse.hero_soul = self.GameLoginResponse.hero_soul - num
    self:subFinance(RES_TYPE.HERO_SOUL, num)
end

--pvp声望
function CommonData:getPvpStore()
    return self:getFinance(RES_TYPE.PVP_SCROE)  --self.pvp_score
end
function CommonData:subPvpStore(num)
    -- self.pvp_score = self.pvp_score - num
    return self:subFinance(RES_TYPE.PVP_SCROE, num)
end
function CommonData:setPvpStore(num)
    self:setFinance(RES_TYPE.PVP_SCROE, num)
end
--玩家id
function CommonData:setAccountId(cur_id) self.accountId = cur_id end
function CommonData:getAccountId() return self.accountId end

--玩家昵称
function CommonData:setUserName(cur_name) 
    self.nickname = cur_name
    self:dispatchEvent(EventName.UPDATE_NAME) 
end

function CommonData:getUserName() return self.nickname end
--判定是否创建昵称
function CommonData:isCreateUserName()
    return self.nickname ~= nil and self.nickname ~= "" 
end

--vip
function CommonData:setVip(cur_vip)
    self.vip = cur_vip
    self:dispatchEvent(EventName.UPDATE_VIP)
end

function CommonData:getVip() return tonumber(self.vip) end

--经验
function CommonData:setExp(cur_exp) 
    self.exp = cur_exp
    -- getNetManager():sendMsgAfterPlayerUpgrade()
    self:dispatchEvent(EventName.UPDATE_EXP) 
end

function CommonData:getExp() return self.exp end

function CommonData:addExp(num)
    if num == nil or num == 0 then return end
    local exp = self.exp + num
    local level = self:getLevel()
    local maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)
    --如果经验大于等于当前等级最大经验,则升级
    while exp >= maxExp do
        level = level + 1
        exp = exp - maxExp
        maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)
    end
    self:setLevel(level) --由于setExp中最了等级，所以先设置等级，再设置经验
    self:setExp(exp)

    -- getNetManager():sendMsgAfterPlayerUpgrade()  
end

--[[--
设置等级，等级提升则发送升级消息
@param int level 等级
]]
function CommonData:setLevel(level)
    if self.level ~= level then
        self.oldLevel = self.level
        self.level = level        
        getNetManager():getInstanceNet():sendGropUpgrade()
        getNetManager():sendMsgAfterPlayerUpgrade()      
        -- 发送红点消息
        self:dispatchEvent(EventName.UPDATE_ACTIVE)
        self:dispatchEvent(EventName.UPDATE_LEVEL)

        -- if self.oldLevel and self.oldLevel >0 then
        --     local newFeatures = FeaturesOPEN.checkNewFeatures(1,self.level)
        --     if newFeatures and #newFeatures > 0 then
                self:dispatchEvent(EventName.UPDATE_NEW_FEATURE)
        --     end
        -- end

        -- 将等级写入到userdefault中
        saveTeamLevel(self.level)
    end 
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
    self:setFinance(RES_TYPE.STAMINA, cur_stamina)
    -- getHomeBasicAttrView():updateStamina()
end

function CommonData:getStamina() return self:getFinance(RES_TYPE.STAMINA) end

function CommonData:addStamina(num) 
    self:addFinance(RES_TYPE.STAMINA, num)
end

--[[--
    获取精力
]]
function CommonData:getEnergy()
    return self:getFinance(RES_TYPE.ENERGY)
end
--[[--
    减少精力
]]
function CommonData:subEnergy(num)
     self:subFinance(RES_TYPE.ENERGY, num)
end
--[[--
    增加精力
]]
function CommonData:addEnergy(num)
      self:addFinance(RES_TYPE.ENERGY, num)
end

--[[--
    获取召唤石数量
]]
function CommonData:getCallStone()
       return self:getFinance(RES_TYPE.CALL_STONE)
end
--[[--
    增加召唤石
]]
function CommonData:addCallStone(num)
      self:addFinance(RES_TYPE.CALL_STONE, num)
end
--元宝
function CommonData:setGold(cur_gold)
    -- self.gold = cur_gold
    self:setFinance(RES_TYPE.GOLD, cur_gold)
    -- getHomeBasicAttrView():updateGold()  
end

function CommonData:getGold() return self:getFinance(RES_TYPE.GOLD) end --self.gold end
--金币
function CommonData:setCoin(cur_coin)
    -- self.coin = cur_coin
    if cur_coin <= 0 then
        cur_coin = 0
    end
    self:setFinance(RES_TYPE.COIN, cur_coin)
    -- getHomeBasicAttrView():updateCoin()
end
--[[--
更新银锭
@param int num 可正负
]]
function CommonData:updateCoin(num)
    self:setCoin(self:getCoin() + num)
end
function CommonData:getCoin() return self:getFinance(RES_TYPE.COIN) end -- self.coin end

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
function CommonData:setPvpTimes(cur_pvp_times)
    self.pvp_times = cur_pvp_times 
    self:dispatchEvent(EventName.UPDATE_ARENA_CHALLENGE_NUM)
end
function CommonData:getPvpTimes() return self.pvp_times end

--挑战次数重置的次数
function CommonData:setPvpRefreshCount(cur_count) self.pvp_refresh_count = cur_count end
function CommonData:getPvpRefreshCount() return self.pvp_refresh_count end
function CommonData:updatePvpRefreshCount(count)
    self.pvp_refresh_count = self.pvp_refresh_count + count
end

-- 扣除num的银子
-- @num: 银子的数量，正数
function CommonData:subCoin(num) 
    self:subFinance(RES_TYPE.COIN, num)
    -- getHomeBasicAttrView():updateCoin()
end

-- 加num的金子
-- @num: 添加的金子数量
function CommonData:addGold(num) 
    print("CommonData:addGold==================>")
    self:addFinance(RES_TYPE.GOLD, num)
    -- getHomeBasicAttrView():updateGold()   
end
-- 扣除num的金子
-- @num: 金子的数量，正数
function CommonData:subGold(num) 
    self:subFinance(RES_TYPE.GOLD, num)
    -- getHomeBasicAttrView():updateGold()  
end

-- 修改战斗力
function CommonData:updateCombatPower() 
    local power = roundNumber(getCalculationManager():getCalculation():CombatPowerAllSoldierLineUp())
    self:setCombatPower(power)
    print("CommonData:updateCombatPower",power)
    self:dispatchEvent(EventName.UPDATE_COMBAT_POWER) 
end

-- 修改历史最高战斗力
function CommonData:updateMaxCombatPower(power)
   self:setMaxCombatPower(power)
   self:dispatchEvent(EventName.UPDATE_MAX_COMBAT_POWER)
end

--[[--
得到通关令的数量
@return number 通关令的数量
]]
function CommonData:getClearanceCoin()
    return self:getFinance(RES_TYPE.CLEARANCE_COIN)
end

--[[--
更改通关令的数量
@param number num 修改的数量(正数为增加,负数为减少)
]]
function CommonData:changeClearanceCoin(num)
    local cur = self:getClearanceCoin() + num
    self:setFinance(RES_TYPE.CLEARANCE_COIN, cur)
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
    体力恢复剩余时间
]]
function CommonData:countTime()
    return self.buy_times[RES_TYPE.STAMINA].retainTime
end

function CommonData:getResBuyTimeByType(_type)
    return self.buy_times[_type]
end

--[[--
    
]]
function CommonData:getRobNum()
    return self:getFinance(RES_TYPE.ROB_NUM)
end

function CommonData:subRobNum(subnum)
    self:subFinance(RES_TYPE.ROB_NUM,subnum)
end

--[[--
增加资源的已购买次数
@param number type 资源类型
@param number num 增加的购买次数
]]
function CommonData:setBuyTimes(_type, num)
    if not _type then
        return
    end
    num = num or 0
    if num < 0 then
        num = 0
    end

    self.buy_times[_type].buy_stamina_times = num
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
    local startLv = self.c_BaseTemplate:getBrewStartLevel()

end

-- pvp
function CommonData:isOpenArena()
    local startLv = self.c_BaseTemplate:getArenaLevel()

end

-- 秘境
function CommonData:isOpenRune()
    local startLv = self.c_BaseTemplate:getRuneLevel()

end

-- 世界boss
function CommonData:isOpenWorldBoss()
    local startLv = self.c_BaseTemplate:openWorldBossLevel()

end

--充值数据累计
function CommonData:setRechargeNum(rechargeNum)
    self.totalRecharge = rechargeNum
    self:dispatchEvent(EventName.UPDATE_RECHARGE_NUM)
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
    if not ISSHOW_STAGE_OPEN then return true end
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

--[[--
判断是否到次日开启的时间

@return bool opened 是否开启
@return int cirikaiqiPeriod 到开启的时间差
]]
function CommonData:isCiriOpend()
    local nextDayNum, nextDayTimeStr = getTemplateManager():getBaseTemplate():getNextDayOpenTime()
    local ciriKaiQiEndTime = setDesTime(self:getRegistTime(), nextDayNum, nextDayTimeStr)
    local cirikaiqiPeriod = ciriKaiQiEndTime - self:getTime()
    local opened = nil
    if cirikaiqiPeriod < 0 then
        opened = true
    else
        opened = false
    end
    return opened,cirikaiqiPeriod
end

--[[--
是否得到次日登陆奖励
]]
function CommonData:isGetNextDayReward()
    return self.tomorrow_gift ~= 0
end

--[[--
设置领取次日登陆奖励
]]
function CommonData:setGetNextDayReward()
    self.tomorrow_gift = 1
    self:dispatchEvent(EventName.DISABLE_NEXT_REWARD)
end

--[[--
设置当前的小伙伴支援价格
]]
function CommonData:setEmployPrice(price)
    self.employPrice = price
end

--[[--
获取当前的小伙伴支援价格
]]
function CommonData:getEmployPrice()
    return self.employPrice
end

--[[--
设置过关斩将当前进行的关卡
]]
function CommonData:setPvpOvercomeIndex(idx)
    idx = idx or 1
    if idx < 1 then idx = 1 end
    self.pvp_overcome_index = idx
end
--[[--
增加过关斩将当前进行的关卡
]]
function CommonData:addPvpOvercomeIndex(num)
    num = num or 1
    if num < 1 then num = 1 end
    self.pvp_overcome_index = self.pvp_overcome_index + num
end
--[[--
得到过关斩将当前进行的关卡
]]
function CommonData:getPvpOvercomeIndex()
    return self.pvp_overcome_index
end
--[[--
设置过关斩将的已重置次数
]]
function CommonData:setPvpOvercomeRefreshCount(idx)
    idx = idx or 0
    if idx < 0 then idx = 0 end
    self.pvp_overcome_refresh_count = idx
end
--[[--
增加过关斩将当前已重置次数
]]
function CommonData:addPvpOvercomeRefreshCount(num)
    num = num or 1
    if num < 1 then num = 1 end
    self.pvp_overcome_refresh_count = self.pvp_overcome_refresh_count + num
end
--[[--
得到过关斩将当前已重置次数
]]
function CommonData:getPvpOvercomeRefreshCount()
    return self.pvp_overcome_refresh_count
end

--等级
function CommonData:setPlayerLevel(level)
    self.level = level
end
--[[--
是否煮酒需要显示红点
]]
function CommonData:isWineRedDotInHome()
    -- 判断功能是否开启
    local openStageId = getTemplateManager():getBaseTemplate():getCookingWineOpenStage()
    local isOpen = getDataManager():getStageData():getIsOpenByStageId(openStageId)
    if not isOpen then
      return false
    end
    
    local startLv = self.c_BaseTemplate:getBrewStartLevel()
    local lv = self:getLevel()
    local brewFlag = (lv >= startLv)
    if brewFlag then
        local brew_times = self:getBrewTimes()
        local brew_times_max = self.c_BaseTemplate:getBrewTimesMax()
        local isCanBrew = (brew_times_max - brew_times ) > 0
        return isCanBrew
    end
    return false
end

--[[--
是否签到要显示红点
]]
function CommonData:isSignRedDotInHome()
    return not getDataManager():getSignData():isGotCurDay()
end

--[[--
精彩活动,美味大餐 红点
]]
function CommonData:isGiftRedDot()
    local timeCanGet = self:getTimeCanGet()
    return self:isFeastTime(timeCanGet) and not self:isEatFeast(timeCanGet)
end



--[[--
设置经脉红点数据
@param bool var
]]
function CommonData:setSealRedData(var)
    self.sealRedData = var
end
--[[--
获得经脉红点数据
@return bool
]]
function CommonData:getSealRedData()
    return self.sealRedData
end

--[[--
是否显示经脉红点,如果拥有的琼浆玉露能够完成至少一次点穴,那么显示红点
]]
function CommonData:isJingMaiRedDotInHome()
    -- 判断经脉是否开启
    local isOpen, _ = FeaturesOPEN.checkFeatures(FeaturesType.MERIDIAN_OPEN)
    if not isOpen then
        return false
    end

    if self.sealRedData ~= nil then
        return self.sealRedData
    end
    -- 获取琼浆玉露数量
    local qjyl = self:getFinance(RES_TYPE.QJYL)
    -- 获取下次点穴的消耗
    local heroList = getDataManager():getSoldierData():getSoldierData()
    for k,v in pairs(heroList) do
        if v.hero_no then
            local sealID = getDataManager():getSoldierData():getSealById(v.hero_no)
            sealID = sealID or 0
            local nextSealID = getTemplateManager():getSealTemplate():getNext(sealID)
            local sealCost = getTemplateManager():getSealTemplate():getExpend(nextSealID)
            local sealLv = getTemplateManager():getSealTemplate():getHeroLevelRestrictions(nextSealID)
            if v.level >= sealLv and sealCost and sealCost > 0 and qjyl >= sealCost then -- 可以点穴
                self.sealRedData = true
                return true
            end
        end
    end

    self.sealRedData = false
    return false
end
--[[--
夺宝是否显示红点
]]
function CommonData:getIsDuoBaoRed()
    local energy =  self:getEnergy()
    local need = getTemplateManager():getBaseTemplate():getTreasureConsume()
    if energy >= need then 
        return true
    else 
        return false
    end 
end
--[[--
获得贡献值
]]
function CommonData:getGongxian()
    return self:getFinance(RES_TYPE.GONGXIAN)
end
--[[--
增加贡献值，可以为负
]]
function CommonData:addGongxian(num)
    local gongxian = self:getGongxian() + num 
    self:setFinance(RES_TYPE.GONGXIAN,gongxian)
end


return CommonData

