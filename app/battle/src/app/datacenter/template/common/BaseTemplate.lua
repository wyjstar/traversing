
BaseTemplate = BaseTemplate or class("BaseTemplate")

import("..config.base_config")
import("..config.sign_in_config")
import("..config.activity_config")
import("..config.vip_config")
import("..config.notes_config")

function BaseTemplate:ctor(controller)
end

function BaseTemplate:getBaseInfoById(id)
    return base_config[id]
end

-- getTemplateManager():getBaseTemplate():getheroInheritPrice()
---  传承相关  ---
function BaseTemplate:getheroInheritPrice( )
    return base_config["heroInheritPrice"]
end
function BaseTemplate:getequInheritPrice( )
    return base_config["equInheritPrice"]
end
function BaseTemplate:getwarriorsInheritPrice( )
    return base_config["warriorsInheritPrice"]
end


function BaseTemplate:getMaxLevel( )   -- 200
    return base_config["player_level_max"]
end


-- 获取献祭后经验值对应的itemID
function BaseTemplate:getBaseInfoByExp(exp)
	local sacrificeGainExp = base_config["sacrificeGainExp"]

    -- print("exp=="..exp)

	local status = "100"
    -- if math.modf(exp/10^5) > 0 then
    --     status = "100000"
    -- elseif math.modf(exp/10^4) > 0 then
    --     status = "10000"
    -- elseif math.modf(exp/10^3) > 0 then
    --     status = "1000"
    --    elseif math.modf(exp/10^2) > 0 then
    --     status = "100"
    -- end
    if math.modf(exp/10^3) > 0 then
        status = "1000"
    elseif math.modf(exp/10^2) > 5 then
        status = "500"
    elseif math.modf(exp/10^2) > 0 then
        status = "100"
    end

    return sacrificeGainExp[status]
end

--获得开启的槽位数量
--根据等级
function BaseTemplate:getOpenSeatsByLv(level)
    local item = base_config["hero_position_open_level"]

    local size = table.nums(item)

    for i = 1, size do
        local v = item[string.format(i)]
       --{1:1,2:2,3:5,4:10,5:16,6:20}
       print("v====" .. v)
       print("level===" .. level)
        if v > level then
            --return item[string.format(i - 1)]
            print("i-1" .. i - 1)
            return i - 1
        end
    end
    return 6  --返回最大槽位
end

--一键强化
--开启等级
function BaseTemplate:getOpenLvStrengthen()
    local num = table.nums(vip_config)
    for i=0,num do
        -- print(" ======================== ", vip_config[i].id)
        if vip_config[i].equipmentStrengthOneKey == 1 then
            -- print("一键装备等级："..vip_config[i].id)
            return vip_config[i].id
        end
    end
    return 0
end
function BaseTemplate:getZCJBNum()
    local vipLevel = getDataManager():getCommonData():getVip()
    return vip_config[vipLevel].buyGetMoneyTimes
    -- body
end

--获得助威加成，根据位置
function BaseTemplate:getCheerAddBySeat(seat)
    if seat == 1 then
        return base_config["cheer_partner_seat1"]
    elseif seat == 2 then
        return base_config["cheer_partner_seat2"]
    elseif seat == 3 then
        return base_config["cheer_partner_seat3"]
    elseif seat == 4 then
        return base_config["cheer_partner_seat4"]
    elseif seat == 5 then
        return base_config["cheer_partner_seat5"]
    elseif seat == 6 then
        return base_config["cheer_partner_seat6"]
    end
end

---------------------------
--获得领取体力时间
-- @ return a table
function BaseTemplate:getManualTime()
    return base_config["time_vigor_activity"]
end
function BaseTemplate:getManualLabel()
    return base_config["vigorActivityName"]
end

--获得领取体力的值
function BaseTemplate:getManualValue()
    return base_config["num_vigor_activity"]
end

--------------------------
--获取当月签到
-- function BaseTemplate:getSignGiftList()
--     local _list = {}
--     local _date = os.date("*t", getDataManager():getCommonData():getTime())
--     local _month = _date.month
--     for k,v in pairs(sign_in_config) do
--         if v.month == _month then
--             _list[v.times] = v  -- 按照签到次数排序
--         end
--     end
--     return _list
-- end
function BaseTemplate:getSignGiftList()
    local _list = {}
    local signRound = getDataManager():getCommonData():getSignRound()
    for k,v in pairs(sign_in_config) do
        if v.month == signRound then
            _list[v.times] = v  -- 按照签到次数排序
        end
    end
    return _list
end
function BaseTemplate:getExtraGiftlieCol()
    local _list = {} -- {id=xxx,parameterA=XXX,reward={...}}
    local _index = 1
    for k,v in pairs(activity_config) do
        if v.type == 12 then
            _list[_index] = {id=v.id,parameterC=v.parameterC,reward=v.reward,Type = v.type}
            _index = _index + 1
        end
    end
    return _list
end

function BaseTemplate:getExtraGiftlieRow()
    local _list = {} -- {id=xxx,parameterA=XXX,reward={...}}
    local _index = 1
    for k,v in pairs(activity_config) do
        if v.type == 13 then
            _list[_index] = {id=v.id,parameterC=v.parameterC,reward=v.reward,Type = v.type}
            _index = _index + 1
        end
    end
    return _list
end

--获取累积签到奖励
-- function BaseTemplate:getTotalSignPrize()
--     return base_config["signInPrize"]
-- end

function BaseTemplate:getTotalSignPrize()
    local _list = {} -- {id=xxx,parameterA=XXX,reward={...}}
    local _index = 1
    for k,v in pairs(activity_config) do
        if v.type == 6 then
            _list[_index] = {id=v.id,parameterA=v.parameterA,reward=v.reward}
            _index = _index + 1
        end
    end
    -- sort
    local function cmp(a,b)  -- 天数 升序排序
        if a.parameterA <= b.parameterA then return true
        else return false
        end
    end
    table.sort(_list, cmp)
    return _list
end

--获取可补签奖励的次数
function BaseTemplate:getTotalRepaireSignDays()
    local _list = base_config["signInAdd"]
    return table.getn(_list)
end

--获取补签消耗的元宝
-- @ param times : 是本月第几次
function BaseTemplate:getRepaireSignMoney(times)
    local _list = base_config["signInAdd"]
    return _list[times]
end

-----------------
--获取在线奖励列表
function BaseTemplate:getOnlinePrizeList()
    local _list = {} -- {id=xxx,parameterA=XXX,reward={...}}
    local _index = 1
    for k,v in pairs(activity_config) do
        if v.type == 4 then
            _list[_index] = {id=v.id,parameterA=v.parameterA,reward=v.reward}
            _index = _index + 1
        end
    end
    -- sort
    local function cmp(a,b)  -- 按照等级大>小，品质大>小 降序排序
        if a.parameterA <= b.parameterA then return true
        else return false
        end
    end
    table.sort( _list, cmp )
    return _list
end

----------------
--获取活动页面的奖励列表
function BaseTemplate:getAllLoginPrizeList()
    local _list = {} -- {id=xxx,type=X,parameterA=XXX,reward={...}}
    local _index = 1
    for k,v in pairs(activity_config) do
        if v.type == 1 then -- 累积登陆奖励
            local premise = v.premise
            -- if premise == 0 then
            --     _list[#_list + 1] =  {id=v.id,type=1,parameterA=v.parameterA,reward=v.reward}
            -- end
            _list[_index] = {id=v.id,type= 1,parameterA=v.parameterA,reward=v.reward}
            _index = _index + 1
        end
    end
    for k,v in pairs(activity_config) do
        if v.type == 2 then -- 连续登陆奖励
            _list[_index] = {id=v.id,type=2,parameterA=v.parameterA,reward=v.reward}
            _index = _index + 1
        end
    end
    for k,v in pairs(activity_config) do
        if v.type == 3 then -- 等级奖励
            _list[_index] = {id=v.id,type=3,parameterA=v.parameterA,reward=v.reward}
            _index = _index + 1
        end
    end
    -- sort
    local function cmp(a,b)
        if a.type < b.type then return true
        elseif a.type == b.type then
            if a.parameterA < b.parameterA then return true
            else return false end
        else return false
        end
    end
    table.sort( _list, cmp )
    return _list
end
function BaseTemplate:getContinLoginPrize()
    local _list = {} -- {id=xxx,type=X,parameterA=XXX,reward={...}}
    local _index = 1
     for k,v in pairs(activity_config) do
        if v.type == 2 then -- 连续登陆奖励
            _list[_index] = {id=v.id,type=2,parameterA=v.parameterA,reward=v.reward,canget=false,isgot=false}
            _index = _index + 1
        end
    end

    local function cmp(a,b)
        if a.type < b.type then return true
        elseif a.type == b.type then
            if a.parameterA < b.parameterA then return true
            else return false end
        else return false
        end
    end

    table.sort( _list, cmp )
    return _list
    -- body
end
function BaseTemplate:getTotalLoginPrize()
    local _list = {} -- {id=xxx,type=X,parameterA=XXX,reward={...}}
    local _index = 1
      for k,v in pairs(activity_config) do
        if v.type == 1 then -- 累积登陆奖励
            local premise = v.premise
            _list[_index] = {id=v.id,type= 1,parameterA=v.parameterA,reward=v.reward}
            _index = _index + 1
        end
    end

    local function cmp(a,b)
        if a.type < b.type then return true
        elseif a.type == b.type then
            if a.parameterA < b.parameterA then return true
            else return false end
        else return false
        end
    end

    table.sort( _list, cmp )
    return _list
    -- body
end
--获取活动页面的登陆奖励信息
-- function BaseTemplate:getLoginPrizeList()
--     local _list = {} -- {id=xxx,type=X,parameterA=XXX,reward={...}}
--     local _index = 1
--     for k,v in pairs(activity_config) do
--         if v.type == 1 then -- 累积登陆奖励
--             _list[_index] = {id=v.id,type=1,parameterA=v.parameterA,reward=v.reward}
--             _index = _index + 1
--         end
--     end
--     for k,v in pairs(activity_config) do
--         if v.type == 2 then -- 连续登陆奖励
--             _list[_index] = {id=v.id,type=2,parameterA=v.parameterA,reward=v.reward}
--             _index = _index + 1
--         end
--     end
--     -- sort
--     local function cmp(a,b)
--         if a.type < b.type then return true
--         elseif a.type == b.type then
--             if a.parameterA < b.parameterA then return true
--             else return false end
--         else return false
--         end
--     end
--     table.sort( _list, cmp )
--     return _list
-- end
function BaseTemplate:getLoginPrizeList()
    local _list = {} -- {id=xxx,type=X,parameterA=XXX,reward={...}}
    local _index = 1
    for k,v in pairs(activity_config) do
        if v.type == 1 then -- 累积登陆奖励
            _list[_index] = {id=v.id,type=1,parameterA=v.parameterA,reward=v.reward,canget=false,isgot=false}
            _index = _index + 1
        end
    end
    for k,v in pairs(activity_config) do
        if v.type == 2 then -- 连续登陆奖励
            _list[_index] = {id=v.id,type=2,parameterA=v.parameterA,reward=v.reward,canget=false,isgot=false}
            _index = _index + 1
        end
    end

    local function cmp(a,b)
        if a.type < b.type then return true
        elseif a.type == b.type then
            if a.parameterA < b.parameterA then return true
            else return false end
        else return false
        end
    end

    table.sort( _list, cmp )
    return _list
end

--得到活动页面的等级奖励信息
function BaseTemplate:getGradePrizeList()
    local _list = {} -- {id=xxx,type=X,parameterA=XXX,reward={...}}
    local _index = 1
    for k,v in pairs(activity_config) do
        if v.type == 3 then -- 等级奖励
            _list[_index] = {id=v.id,type=3,parameterA=v.parameterA,reward=v.reward,canget=false,isgot=false}
            _index = _index + 1
        end
    end
    -- sort
    local function cmp(a,b)
        if a.parameterA < b.parameterA then return true
        else return false end
    end
    table.sort( _list, cmp )
    return _list
end
-- function BaseTemplate:getGradePrizeList()
--     local _list = {} -- {id=xxx,type=X,parameterA=XXX,reward={...}}
--     local _index = 1
--     for k,v in pairs(activity_config) do
--         if v.type == 3 then -- 等级奖励
--             _list[_index] = {id=v.id,type=3,parameterA=v.parameterA,reward=v.reward}
--             _index = _index + 1
--         end
--     end
--     -- sort
--     local function cmp(a,b)
--         if a.type < b.type then return true
--         elseif a.type == b.type then
--             if a.parameterA < b.parameterA then return true
--             else return false end
--         else return false
--         end
--     end
--     table.sort( _list, cmp )
--     return _list
-- end


--累计登录
function BaseTemplate:getTotleBaseList()
    local resultList = {}
    for k,v in pairs(activity_config) do
        if v.type == 1 then -- 累积登陆奖励
            resultList[#resultList + 1] = {id=v.id,type=1,parameterA=v.parameterA,reward=v.reward}
        end
    end

    local function cmp(a,b)
        if a.parameterA < b.parameterA then
            return true
        else
            return false
        end
    end
    table.sort( resultList, cmp )

    return resultList
end

--连续登录
function BaseTemplate:getSerialBaseList()
    local resultList = {}
    for k,v in pairs(activity_config) do
        if v.type == 2 then
            resultList[#resultList + 1] = {id=v.id,type=2,parameterA=v.parameterA,reward=v.reward}
        end
    end
    local function cmp(a,b)
        if a.parameterA < b.parameterA then
            return true
        else
            return false
        end
    end
    table.sort( resultList, cmp )
    return resultList
end

--等级礼包
function BaseTemplate:getLvBag()
    local resultList = {}
    for k,v in pairs(activity_config) do
        if v.type == 3 then
            resultList[#resultList + 1] = {id=v.id,type=3,parameterA=v.parameterA,reward=v.reward}
        end
    end
    local function cmp(a,b)
        if a.parameterA < b.parameterA then
            return true
        else
            return false
        end
    end
    table.sort( resultList, cmp )
    return resultList
end

--历史首充
function BaseTemplate:getRchargeHisFirst()
    local resultList = {}
    for k,v in pairs(activity_config) do
        if v.type == 7 then -- 累积登陆奖励
            resultList[#resultList + 1] = {id=v.id,type=7,parameterA=v.parameterA,reward=v.reward}
        end
    end

    local function cmp(a,b)
        if a.parameterA < b.parameterA then
            return true
        else
            return false
        end
    end
    table.sort( resultList, cmp )

    return resultList
end

--单次充值
function BaseTemplate:getRchargeSingle()
    local resultList = {}
    for k,v in pairs(activity_config) do
        if v.type == 8 then -- 累积登陆奖励
            resultList[#resultList + 1] = {id=v.id,type=8,parameterA=v.parameterA,reward=v.reward}
        end
    end

    local function cmp(a,b)
        if a.parameterA < b.parameterA then
            return true
        else
            return false
        end
    end
    table.sort( resultList, cmp )

    return resultList
end

--累计充值
function BaseTemplate:getRchargeAcc()
    local resultList = {}
    for k,v in pairs(activity_config) do
        if v.type == 9 then -- 累积登陆奖励
            resultList[#resultList + 1] = {id=v.id,type=9,parameterA=v.parameterA,reward=v.reward}
        end
    end

    local function cmp(a,b)
        if a.parameterA < b.parameterA then
            return true
        else
            return false
        end
    end
    table.sort( resultList, cmp )

    return resultList
end

--每日首充
function BaseTemplate:getRchargeDayFirst()
    local resultList = {}
    for k,v in pairs(activity_config) do
        if v.type == 10 then -- 累积登陆奖励
            resultList[#resultList + 1] = {id=v.id,type=10,parameterA=v.parameterA,reward=v.reward}
        end
    end

    local function cmp(a,b)
        if a.parameterA < b.parameterA then
            return true
        else
            return false
        end
    end
    table.sort( resultList, cmp )

    return resultList
end

function BaseTemplate:getTimeHisFirst()
    for k,v in pairs(activity_config) do
        if v.type == 7 then
            return v.parameterT
        end
    end
end
function BaseTemplate:getTimeSingle()
    for k,v in pairs(activity_config) do
        if v.type == 8 then
            return v.parameterT
        end
    end
end
function BaseTemplate:getTimeAcc()
    for k,v in pairs(activity_config) do
        if v.type == 9 then
            return v.parameterT
        end
    end
end
function BaseTemplate:getTimeDayFirst()
    for k,v in pairs(activity_config) do
        if v.type == 10 then
            return v.parameterT
        end
    end
end

function BaseTemplate:getHDStageStartLv()
    return base_config["level_open_activity_stage"]
end

function BaseTemplate:getFBStageStartLv()
    return base_config["level_open_copy_stage"]
end

------------------------
-- 获取上限可超出部分
function BaseTemplate:getEquipStrengthMax()
    return base_config.max_equipment_strength
end


-----------------------
---- vip 相关 ----

-- @ return ： 0 不能再购买体力
function BaseTemplate:getBuyStaminaLeftTimes()
    local viplevel = getDataManager():getCommonData():getVip()
    local limit = vip_config[viplevel].buyStaminaMax
    local curBuy = getDataManager():getCommonData():getBuyStaminaTimes()
    if curBuy <= limit then return limit - curBuy
    elseif curBuy > limit then return 0
    end
end

-- @ return ： 0 不能进行自动游历的立即完成
function BaseTemplate:getAutoTravelFastFinish()
    local viplevel = getDataManager():getCommonData():getVip()
    if viplevel < self:getVIPAutoTravelFastFinish() then
        return 0
    else
        return 1
    end
end

-- @ return id 可已完成VIP的等级
function BaseTemplate:getVIPAutoTravelFastFinish()
    print("-----getVIPAutoTravelFastFinish----")
    local num = table.nums(vip_config)
    for i=0,num do
        for k,v in pairs(vip_config) do
            if v.id == i then
                if v.autoTravelGet == 1 then
                    return v.id
                end
            end
        end
    end
    return 0
end

--返回VIP跳过战斗
function BaseTemplate:getVipFightSkip()
    local viplevel = getDataManager():getCommonData():getVip()
    return vip_config[viplevel].jump
end

function BaseTemplate:getFightSkipVipLevel()
    local num = table.nums(vip_config)
    for i=0,num do
        local v = vip_config[i]
        if v.jump == 1 then
            return v.id
        end
    end
    return 0
end

--返回VIP是否跳过Boss
function BaseTemplate:getVipBossFightSkip()
    local viplevel = getDataManager():getCommonData():getVip()
    return vip_config[viplevel].worldbossSkip
end

function BaseTemplate:getBossFightSkipVipLevel()
    local num = table.nums(vip_config)
    for i=0,num do
        local v = vip_config[i]
        if v.worldbossSkip == 1 then
            return v.id
        end
    end
    return 0
end

--判断两倍速是否开启
function BaseTemplate:getFightTwoTimesOpen()
    -- body
    return getDataManager():getCommonData():getLevel() >= base_config.SpeedUpTwoTimesOpenLevel
end

function BaseTemplate:getFightTwoTimesLevel()
    return base_config.SpeedUpTwoTimesOpenLevel
end

--获取VIP等级是否开启三倍速
function BaseTemplate:getVipFightThreeTimes()
    local vipLevel = getDataManager():getCommonData():getVip()
    return vip_config[vipLevel].SpeedUpThreeTimes
end

function BaseTemplate:getFightThreeTimesThreeLevel()
    local num = table.nums(vip_config)
    for i=0,num do
        local v = vip_config[i]
        if v.SpeedUpThreeTimes == 1 then
            return v.id
        end
    end
    return 0
end

-- @ return type : 1 普通钱币， 2 充值币
-- @ return money : 具体钱数
function BaseTemplate:getBuyStaminaMoney()

    local tabPrize = base_config.price_buy_manual

    local curBuyTime = getDataManager():getCommonData():getBuyStaminaTimes() + 1
    print("curBuyTime ="..curBuyTime)
    for k,v in pairs(tabPrize) do
        if k == tostring(curBuyTime) then
            return v[1], v[2]
        end
    end
end

function BaseTemplate:getColorByNo(no)
    local key = "color."..tostring(no)
    return Localize.query(key)
end

function BaseTemplate:getStaminaMax()
    return base_config.max_of_vigor
end

function BaseTemplate:buyStaminaNumber()
    return base_config.buy_vigor_num
end

--一键强化权限
function BaseTemplate:getOneKeyStrength()
    local curVipLevel = getDataManager():getCommonData():getVip()
    local isCan = vip_config[curVipLevel].equipmentStrengthOneKey
    print("isCan ... ", isCan)
    if isCan == 0 then return false
    elseif isCan == 1 then return true
    end
end

--
function BaseTemplate:getStaminaRecoverTime()
    return base_config.peroid_of_vigor_recover
end

--获取膜拜次数
function BaseTemplate:getWorshipTimes()
    local curVipLevel = getDataManager():getCommonData():getVip()
    local curTimes = vip_config[curVipLevel].guildWorshipTimes
    return curTimes
end

--获取某vip等级的 精英关卡 挑战次数
function BaseTemplate:getNumEliteTimes(id)
    for k,v in pairs(vip_config) do
        if v.id == id then return v.eliteCopyTimes end
    end
end

--获取某vip等级的 精英关卡 挑战次数
function BaseTemplate:getVipDescription(id)
    for k,v in pairs(vip_config) do
        if v.id == id then return v.description end
    end
end



--获取某vip等级的 活动关卡 挑战次数
function BaseTemplate:getNumActTimes(id)
    for k,v in pairs(vip_config) do
        if v.id == id then return v.activityCopyTimes end
    end
end

--获取某vip等级的 关卡重置次数
function BaseTemplate:getNumResetStageTimes(id)
    for k,v in pairs(vip_config) do
        if v.id == id then return v.buyStageResetTimes end
    end
end

--根据重置次数，获取重置价格
function BaseTemplate:getPriceByResetStageNum(resetStageNum)
    local _stageResetPrice = base_config["stageResetPrice"]
    for k,v in pairs(_stageResetPrice) do
        if k == resetStageNum+1 then return v end
    end
end


function BaseTemplate:getFreeSweepTimes()
    local curVipLevel = getDataManager():getCommonData():getVip()
    return vip_config[curVipLevel].freeSweepTimes
end

--获取某vip等级的 商城刷新次数
function BaseTemplate:getShopRefreshTimes(id)
    for k,v in pairs(vip_config) do
        if v.id == id then return v.shopRefreshTimes end
    end
    return 0
end
--到达某vip等级所需的累积充值金额
function BaseTemplate:getRechargeAmount(id)
    for k,v in pairs(vip_config) do
        if v.id == id then return v.rechargeAmount end
    end
end
--=============== 竞技场相关 ==============--

--竞技场等级限制
function BaseTemplate:getArenaLevel()
    return base_config["arena_open_level"]
end

--获取竞技场短时间奖励(竞技场相关)
function BaseTemplate:getArenaShorTimePoints(rank_value)
    local score = base_config["arena_shorttime_points"]
    for k,v in pairs(score) do
        if rank_value >= v[1] and rank_value <= v[2] then
            return v[3]
        end
    end
end

--获取短时间奖励间隔时间(竞技场相关)
function BaseTemplate:getArenaShortTime()
    local shortTime = base_config["arena_shorttime_points_time"]
    return shortTime
end

--获取免费挑战次数(竞技场相关)
function BaseTemplate:getArenaFreeTime()
    local freeTime = base_config["arena_free_times"]
    return freeTime
end

--购买竞技场挑战次数(竞技场相关)
function BaseTemplate:getBuyArenaTimes(viplevel)
    print("当前的vip等级 ============ ", viplevel)
    local arenaTimes = vip_config[viplevel].buyArenaTimes
    print("可以重置的次数 ============ ", arenaTimes)
    return arenaTimes
end

--购买竞技场挑战次数价格
function BaseTemplate:getArenaTimePrice()
    local arenaTimePrice = base_config["arena_times_buy_price"]["2"][1]
    return arenaTimePrice
end

--付费重置挑战次数可获得的挑战次数
function BaseTemplate:getReceiveTimes()
    return base_config["arena_reset_times"]
end

--获取竞技场奖励列表
function BaseTemplate:getArenaRewards()
    return base_config["arena_day_points"]
end

--=============== 竞技场相关 ==============--

function BaseTemplate:getSweepIsOpen()
    local curVipLevel = getDataManager():getCommonData():getVip()
    local value = vip_config[curVipLevel].openSweep
    if value == 1 then return true
    elseif value == 0 then return false end
end

function BaseTemplate:getSweepVip()
    local num = table.nums(vip_config)
    local viplevel = 0
    for i=0,num do
        for k,v in pairs(vip_config) do
            if v.id == i then
                if v.openSweep == 1 then
                    return v.id
                end
            end
        end
    end
    return 0
end

function BaseTemplate:getSweepTenIsOpen()
    local curVipLevel = getDataManager():getCommonData():getVip()
    local value = vip_config[curVipLevel].openSweepTen
    if value == 1 then return true
    elseif value == 0 then return false end
end

function BaseTemplate:getSweepTenVip()
    local num = table.nums(vip_config)
    local viplevel = 0
    for i=0,num do
        for k,v in pairs(vip_config) do
            if v.id == i then
                if v.openSweepTen == 1 then
                    return v.id
                end
            end
        end
    end
    return 0
end

function BaseTemplate:getSweepMoneyOneTime()
    return base_config["price_sweep"]
end

-------------------------
--煮酒

function BaseTemplate:getBrewPrice(brew_type, brew_step)
    --return base_config['cookingWinePrice'][brew_type][brew_step]     --徐广
    return base_config['cookingWinePrice'][brew_type][brew_step]["107"][1]
end

--金樽煮酒所需要的金樽数量
function BaseTemplate:getBrewGoldCup(brew_type, brew_step)
    return base_config['cookingWinePrice'][brew_type][brew_step]["105"][1]
end

function BaseTemplate:getBrewTimesMax()
    local curVipLevel = getDataManager():getCommonData():getVip()
    return vip_config[curVipLevel].cookingTimes
end

function BaseTemplate:getBrewStartLevel()
    return base_config["cookingWineOpenLevel"]
end

-- 游历
function BaseTemplate:getCaoXieDeg(shoesName) --耐久度
    return base_config[shoesName][2]
end

function BaseTemplate:getCaoXiePin(n) --品级
    local str = tostring("travelShoe"..n)
    return base_config[str][4]
end

function BaseTemplate:getCaoXieResName(n) --耐久度
    local str = tostring("travelShoe"..n)

    local res = base_config[str][1]
    local resPath = resource_config[res]["pathWithName"]
    local resName = resource_config[res]["name"]
    local name = language_config[tostring(resName)]["cn"]

    return resPath, name
end

function BaseTemplate:getCaoXieGold()          --购买价格
    return base_config["travelShoe1"][3]
end

function BaseTemplate:getBuXieGold()
    return base_config["travelShoe2"][3]
end

function BaseTemplate:getPiXieGold()
    return base_config["travelShoe3"][3]
end
--自动游历
function BaseTemplate:getAutoNum()
    local table_auto = base_config["autoTravel"]
    --table.print(table_auto)
    return table.nums(table_auto)
end
--自动游历次数
function BaseTemplate:getAutoTimeTimes(curNumber)
    return base_config["autoTravel"][tostring(curNumber)][1]
end
--自动游历购买价格（钻石）
function BaseTemplate:getAutoTravelPrice(curNumber)
    return base_config["autoTravel"][tostring(curNumber)][2]
end

--=================世界boss相关=================--

--世界boss开启等级限制
function BaseTemplate:openWorldBossLevel()
    local openLevel = base_config["worldboss_open_level"]
    return openLevel
end

--银币鼓舞消耗银币的数量（实际是金币）
function BaseTemplate:getCostSliverNum()
    local costSliverNum = base_config["goldcoin_inspire_price"]
    return costSliverNum
end

--银币鼓舞翻倍系数
function BaseTemplate:getCostRatio()
    local ratio = base_config["goldcoin_inspire_price_multiple"]
    return ratio
end

--金币鼓舞消耗（实际是钻石）
function BaseTemplate:getCostGoldNum()
    local costGoldNum = base_config["money_inspire_price"]
    return costGoldNum
end

--复活等待的时间
function BaseTemplate:getReliveWaitTime()
    local reliveWaitTime = base_config["free_relive_time"]
    return reliveWaitTime
end

--复活消耗的钻石
function BaseTemplate:getReliveCostGold()
    local reliveCostNum = base_config["money_relive_price"]
    return reliveCostNum
end

--银两鼓舞增加攻击力的比率
function BaseTemplate:getSliverEncorageRadio()
    local sliverRadio = base_config["worldbossInspireAtk"]
    return sliverRadio
end

--元宝鼓舞增加的攻击力比率
function BaseTemplate:getGoldEncourageRadio()
    local goldRadio = base_config["worldbossInspireAtkMoney"]
    return goldRadio
end

--世界boss奖励文本
function BaseTemplate:getBossRewardText()
    return base_config["worldbossRewardsText"]
end

--幸运武将攻击加成系数1
function BaseTemplate:getLuckHero1()
    return base_config["lucky_hero_1"]
end

--幸运武将攻击加成系数2
function BaseTemplate:getLuckHero2()
    return base_config["lucky_hero_2"]
end

--幸运武将攻击加成系数3
function BaseTemplate:getLuckHero3()
    return base_config["lucky_hero_3"]
end

--银币鼓舞cd的时间
function BaseTemplate:getSliverEncorageCD()
    return base_config["goldcoin_inspire_CD"]
end

--银币鼓舞最大次数
function BaseTemplate:getSliverEncorageTimes()
    return base_config["goldcoinInspireLimited"]
end

--元宝鼓舞最大次数
function BaseTemplate:getGoldEncorageTimes()
    return base_config["moneyInspireLimited"]
end

--=================== 符文相关 ===================--
--符文开启等级
function BaseTemplate:getRuneOpenLeve()
    return base_config["totemOpenLevel"]
end

--符文刷新每日免费次数
function BaseTemplate:getFreeRefreshTimes()
    return base_config["totemRefreshFreeTimes"]
end

--符文背包上限
function BaseTemplate:getRuneBagMaxCount()
    return base_config["totemStash"]
end

--符文衰减比率
function BaseTemplate:getRuneDecay()
    return base_config["totemSpaceDecay"]
end

--符文打造刷新消耗的元宝数量
function BaseTemplate:getRefreshCost()
    return base_config["totemRefreshPrice"]
end

--密境boss等级限制
function BaseTemplate:getRuneLevel()
    return base_config["warFogOpenLevel"]
end
--符文秘境矿点根据vip等级是否可增产
function BaseTemplate:isCanMineIncrease(id)
    for k,v in pairs(vip_config) do
        if v.id == id and v.MineIncrease == 1 then
            return true
        end
    end
    return false
end
-- --根据某vip等级获得的密境地图刷新次数
-- function BaseTemplate:gerWarFogRefreshNum(id)
--     for k,v in pairs(vip_config) do
--         if v.id == id then
--             return warFogRefreshNum
--         end
--     end
-- end

--聊天相关
--聊天等级限制
function BaseTemplate:getChatOpenLevel()
    return base_config["public_chat_open_level"]
end

--聊天时间间隔
function BaseTemplate:getChatInterval()
    return base_config["chat_interval"]
end

--活跃度开启等级
function BaseTemplate:getActiveOpenLeve()
    return base_config["activityOpenLevel"]
end

--武将突破开启等级
function BaseTemplate:getBreakupOpenLeve()
    return base_config["hero_breakup_open_level"]
end

--炼体开启等级
function BaseTemplate:getSealOpenLeve()
    return base_config["sealOpenLevel"]
end

--军团聊天开启等级
function BaseTemplate:getJoinGuildOpenLeve()
    return base_config["join_guild_level"]
end

--装备熔炼开启等级
function BaseTemplate:getEquRefundOpenLeve()
    return base_config["equRefundOpenLevel"]
end

--战斗小伙伴支援开启等级
function BaseTemplate:getFriendSupportLevel()
    return base_config["friendHelpOpenLevel"]
end

--好友活跃度奖励值
function BaseTemplate:getFriendActivityValue()
    return base_config["friendActivityValue"]
end

--好友活跃度奖励值
function BaseTemplate:getFriendActivityyReward()
    return base_config["friendActivityReward"]
end

--好友数量上限
function BaseTemplate:getFriendMax()
    return base_config["max_of_UserFriend"]
end

--坏蛋数量上限
function BaseTemplate:getBadMax()
    return base_config["max_of_Userblacklist"]
end



----------------------------------------------新版本关卡开启功能-------------------------------------------

--聊天等级限制
function BaseTemplate:getChatOpenLevel()
    return base_config["public_chat_open_level"]
end

--聊天时间间隔
function BaseTemplate:getChatInterval()
    return base_config["chat_interval"]
end

--活跃度开启关卡
function BaseTemplate:getActivityOpenStage()
    return base_config["activityOpenStage"]
end

--武将突破开启关卡
function BaseTemplate:getBreakupOpenStage()
    return base_config["heroBreakOpenStage"]
end

--武将献祭开启关卡
function BaseTemplate:getHeroSacrificeOpenStage()
    return base_config["heroSacrificeOpenStage"]
end

--经脉炼体开启关卡
function BaseTemplate:getSealOpenStage()
    return base_config["sealOpenStage"]
end

--军团聊天开启等级
function BaseTemplate:getJoinGuildOpenLeve()
    return base_config["join_guild_level"]
end

--军团开启关卡
function BaseTemplate:getGuildOpenStage()
    return base_config["guildOpenStage"]
end

--装备合成开启关卡
function BaseTemplate:getEquAssembleOpenStage()
    return base_config["equAssembleOpenStage"]
end

--装备强化开启关卡
function BaseTemplate:getEquUpgradeOpenStage()
    return base_config["equUpgradeOpenStage"]
end

--装备熔炼开启关卡
function BaseTemplate:getEquRefundOpenStage()
    return base_config["equRefundOpenStage"]
end

--战斗小伙伴支援开启关卡
function BaseTemplate:getFriendSupportStage()
    return base_config["friendHelpOpenStage"]
end

--符文开启关卡
function BaseTemplate:getTotemOpenStage()
    return base_config["totemOpenStage"]
end

--符文秘境开启关卡
function BaseTemplate:getWarFogOpenStage()
    return base_config["warFogOpenStage"]
end

--秘境Boss开启关卡
function BaseTemplate:getWarFogBossOpenStage()
    return base_config["warFogBossOpenStage"]
end

--世界boss开启关卡
function BaseTemplate:getWorldBossOpenStage()
    return base_config["worldbossOpenStage"]
end

--竞技场开启关卡
function BaseTemplate:getArenaOpenStage()
    return base_config["arenaOpenStage"]
end

--活动FB开启关卡
function BaseTemplate:getActivityStageOpenStage()
    return base_config["activityStageOpenStage"]
end

--精英FB开启关卡
function BaseTemplate:getSpecialStageOpenStage()
    return base_config["specialStageOpenStage"]
end

--煮酒开启关卡
function BaseTemplate:getCookingWineOpenStage()
    return base_config["cookingWineOpenStage"]
end

--游历开启关卡
function BaseTemplate:getTravelOpenStage()
    return base_config["travelOpenStage"]
end

--传承开启关卡
function BaseTemplate:getInheritOpenStage()
    return base_config["inheritOpenStage"]
end

--装备商店开启关卡
function BaseTemplate:getEquMallOpenStage()
    return base_config["equMallOpenStage"]
end

------------------------------------------------------------------------------------------------

--熔炼返回金钱比例
function BaseTemplate:getReturnCoinRatio()
    return base_config["equRefundRatio"]
end

--系统公告
function BaseTemplate:getNoteInfoById(id)
    return notes_config[id]
end
--系统公告中每隔几条循环一次系统消息
function BaseTemplate:getNoteTimes()

    return base_config["notesSpaceTimes"]
end

--背包容量上限
function BaseTemplate:getMaxBag()
    return base_config["max_item_bag"]
end

--单品道具重叠上限
function BaseTemplate:getItemMaxNum()
    return base_config["max_item_superposition"]
end

--世界boss排名奖励相关
function BaseTemplate:getRewardList()
    return base_config["hurt_rewards_worldboss_rank"]
end

--世界boss击杀奖励
function BaseTemplate:getKillReward()
    return base_config["kill_rewards_worldboss"]
end

--世界boss参与奖励
function BaseTemplate:getPartReward()
    return base_config["worldbossPartakeRewardsType"]
end

--vip最大等级
function BaseTemplate:getMaxVipLevel()
    return base_config["vipMaxLevel"]
end

function BaseTemplate:getRecruitForGuide()
    return base_config["CardFirst"]
end

--阵容装备一键强化VIP等级
function BaseTemplate:getLineUpEquipStrengthVipLevel(vip_level)
    return vip_config[vip_level].allStrength
end


--====================商店相关====================--
--根据vip等级获取商店刷新次数
function BaseTemplate:getShopRefreshTimes(vip_level)
    return vip_config[vip_level].shopRefreshTimes
end

----------------------扫荡相关----------------------

function BaseTemplate:getSweepPrice( ... )
    local priceInfo = base_config["price_sweep"]
    return priceInfo["107"][1]
end

function BaseTemplate:getSweepItemId( ... )
    local itemInfo = base_config["sweepNeedItem"]
    return itemInfo["105"][3]
end

----------------获取招财进宝－－消耗
function BaseTemplate:getZCJBConsumData()
    return base_config["getMoneyBuyTimesPrice"]
    -- body
end
----------------获取招财进宝 获取的银币
function BaseTemplate:getZCJBGainData()
    return base_config["getMoneyValue"]
    -- body
end
function BaseTemplate:getZCJBTotalTime()
    local curViplevel = getDataManager():getCommonData():getVip()
    return vip_config[curViplevel].buyGetMoneyTimes
    -- body
end

--军团祈福数据
function BaseTemplate:getWorshipData()
    return base_config["worship"]
    -- body
end

-- 军团祈福次数
function BaseTemplate:getParyNumByVipLevel(vip_level)
    return vip_config[vip_level].guildWorshipTimes
end

return BaseTemplate



