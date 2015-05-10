
--世界Boss相关数据
local BossData = class("BossData")

function BossData:ctor()
    self.rankList = {}                  --对boss伤害前十名的玩家排行
    self.shotList = {}                  --上轮击杀
    self.luckyHeros = {}                --幸运武将列表
    self.adventure = nil                --是否有奇遇
    self.teamInfo = {}                  --战队信息
    self.inspireResult = {}             --鼓舞返回结果
    self.reliveData = {}                --复活返回数据
    self.curSatageId = nil              --当前的关卡id
    self.ecourageTimes = 0              --银币鼓舞的次数
    self.goldEncourageTimes = 0         --金币鼓舞的次数
    self.bloodValue = 0                 --boss的当前血量
    self.isOpen = false                 --是否开启
    self.isDead = false                 --是否死亡
    self.fightTimes = nil               --战斗的次数
    self.rankNo = nil                   --当前排名
    self.damageHp = 0                   --对boss的伤害数值
    self.lastFightTime = nil            --上次战斗结束时间
    self.rewardInfo = nil               --世界Boss奖励
    self.isStart = false                --是否到达世界boss开启时间
end

-- 是否开启的信息初始化
function BossData:setIsOpen(data)
    self.isOpen = data
end

-- 获取是否开启信息
function BossData:getIsOpen()
    return self.isOpen
end

-- boss是否已经死亡
function BossData:setBossIsDead(data)
    self.isDead = data
end

-- boss是否已经死亡
function BossData:getBossIsDead()
    return self.isDead
end

-- 对boss伤害前十名的玩家排行（请求返回进行初始化数据）
function BossData:setHurtRankList(data)
    self.rankList = data
end

-- 对boss伤害前十名的玩家排行（客户端获取数据）
function BossData:getHurtRankList()
    if self.rankList ~= nil then
        return self.rankList
    end
end

-- 上轮击杀
function BossData:setLastShotList(data)
    self.shotList = data
end

-- 获取上轮击杀返回
function BossData:getLastShotList()
    if self.shotList ~= nil then
        return self.shotList
    end
end

-- 幸运武将
function BossData:setLuckyHeros(data)
    self.luckyHeros = data
end

--幸运武将列表（客户端获取数据）
function BossData:getLuckyHeros()
    if self.luckyHeros ~= nil then
        return self.luckyHeros
    end
end

--奇遇
function BossData:setAdventure(data)
    self.adventure = data
end

--奇遇数据获取
function BossData:getAdventure()
    if self.adventure ~= nil then
        return self.adventure
    end
end

--鼓舞数据初始化
function BossData:setInspireData(data)
    self.inspireResult = data
end

--获取鼓舞返回的数据
function BossData:getInspireData()
    if self.inspireResult ~= nil then
        return self.inspireResult
    end
end

--复活数据初始化
function BossData:setReliveData(data)
    self.reliveData = data
end

--获取复活的相关数据
function BossData:getReliveData()
    if self.reliveData ~= nil then
        return self.reliveData
    end
end

--当前的关卡id初始化
function BossData:setCurStageId(stageId)
    self.curSatageId = stageId
end

--获取当前的关卡id
function BossData:getCurSatgeId()
    -- print("获取数据输出 =============== ", self.curSatageId)
    if self.curSatageId ~= nil then
        return self.curSatageId
    end
end

--银币鼓舞的次数初始化
function BossData:setSliverEncourageTime(times)
    self.ecourageTimes = times
end

--获取银币鼓舞的次数
function BossData:getSliverEncourageTime(times)
    if self.ecourageTimes ~= nil then
        return self.ecourageTimes
    end
end

-- 金币鼓舞次数初始化
function BossData:setGoldEncourageTimes(times)
    self.goldEncourageTimes = times
end

-- 金币鼓舞次数获取
function BossData:getGoldEncourageTimes()
    return self.goldEncourageTimes
end

--世界boss的当前血量
function BossData:setBloodValue(blood_Value)
    self.bloodValue = blood_Value
end

--世界boss的当前血量获取
function BossData:getBloodValue()
    return self.bloodValue
end

--战斗次数初始化
function BossData:setFightTimes(fight_times)
    self.fightTimes = fight_times
end

--获取战斗次数
function BossData:getFightTimes()
    return self.fightTimes
end

--当前排名
function BossData:setRankNo(rank_no)
    self.rankNo = rank_no
end

--获取当前排名
function BossData:getRankNo()
    return self.rankNo
end

-- 对boss的伤害数值
function BossData:setDamageHp(damage_hp)
    self.damageHp = damage_hp
end

-- 获取对boss的伤害数值
function BossData:getDamageHp()
    return self.damageHp
end

-- 上次战斗结束时间
function BossData:setLastFightTime(fight_time)
    self.lastFightTime = fight_time
end

-- 获取上次战斗结束时间
function BossData:getLastFightTime()
    return self.lastFightTime
end

--是否到达世界boss开启时间
function BossData:setIsStart(flag)
    self.isStart = flag
end

function BossData:getIsStart()
    return self.isStart
end

function BossData:getRewardInfo()
    return self.rewardInfo
end

function BossData:setRewardInfo(data)
    self.rewardInfo = data
end

return BossData
