
--竞技场相关数据
local ArenaData = class("ArenaData")


function ArenaData:ctor()
    self.arenaList = {}                 --竞技列表
    self.rankList = {}                  --排行列表
    self.exchangeList = {}              --兑换列表
    self.checkInfo = {}                 --查看战队信息
    self.checkSoldierInfo = {}
    self.challengeData = {}             --挑战数据
    self.exchangeResult = {}            --兑换结果
    self.challengeNum = 0               --挑战次数
    self.pvpScore = 0                   --军功值
    self.otherPlayerLineUp = {}                 --玩家阵容信息
end

-- 竞技列表（请求返回进行初始化数据）
function ArenaData:setArenaList(data)
    self.arenaList = data
end

-- 竞技列表（客户端获取数据）
function ArenaData:getArenaList()
    if self.arenaList ~= nil then
        return self.arenaList
    end
end

-- 排行列表（请求返回进行初始化数据）
function ArenaData:setRankList(data)
    self.rankList = data
end

-- 排行列表（客户端获取数据）
function ArenaData:getRankList()
    if self.rankList ~= nil then
        return self.rankList
    end
end

--竞技场奖励列表
function ArenaData:getArenaRewardInfo()
    local rewards = getTemplateManager():getBaseTemplate():getArenaRewards()
    local rewardItem = {}
    for k, v in pairs(rewards) do
        rewardItem.minRank = v[1]
        rewardItem.maxRank = v[2]

    end
end

-- 玩家排行
function ArenaData:setRankOrder(num)
    print("当前排行初始化 ---------- ", num)
    self.player_rank = num
    if self.player_rank == -1 then self.player_rank = 0 end
end
function ArenaData:getRankOrder()
    return self.player_rank
end

--玩家军功
-- function ArenaData:setPvpScore(score)
--     self.pvpScore = score
-- end
-- function ArenaData:getPvpScore()
--     return self.pvpScore
-- end

-- 兑换列表（请求返回进行初始化数据）
function ArenaData:setExchangeList(data)
    self.exchangeList = data
end

-- 兑换列表（客户端获取数据）
function ArenaData:getExchangeList()
    if self.exchangeList ~= nil then
        return self.exchangeList
    end
end

-- 兑换结果 （请求返回进行初始化数据）
function ArenaData:setExchangeResult(data)
    self.exchangeResult =  data
end

-- 兑换结果 （客户端获取数据）
function ArenaData:getExchangeResult()
    if self.exchangeResult ~= nil then
        return self.exchangeResult
    end
end

-- 排行列表阵容信息查看（请求返回进行初始化数据）
function ArenaData:setOtherPlayerLineUp(data)
    self.otherPlayerLineUp =  data
end

-- 排行列表阵容信息查看（请求返回进行初始化数据）
function ArenaData:getOtherPlayerLineUp()
    if self.otherPlayerLineUp ~= nil then
        return self.otherPlayerLineUp
    end
    return nil
end

-- 排行列表信息查看（请求返回进行初始化数据）
function ArenaData:setRankCheckInfo(data)
    self.checkSoldierInfo =  data
end

-- 排行列表信息查看（客户端获取数据）
function ArenaData:getArenaRankCheck()
    if self.checkSoldierInfo ~= nil then
        return self.checkSoldierInfo
    end
end

function ArenaData:getExpById(hero_id)
    print("hero_id ================ ", hero_id)
    -- table.print(self.checkSoldierInfo)
     for k, v in pairs(self.checkSoldierInfo) do
        if v.hero.hero_no == hero_id then
            return v.hero.exp
        end
    end
    return "@@@@@@@"
end

-- 根据座位号获取英雄(排行查看信息相关)
function ArenaData:getSlotItemBySeat(seatIndex)
    for k, v in pairs(self.checkSoldierInfo) do
        local seat = v.slot_no
        if seat == seatIndex then
            return v
        end
    end
    return nil
end

-- 根据座位号获取英雄数据(排行查看信息相关)
function ArenaData:getHeroDataBySeat(seatIndex)
    for k, v in pairs(self.checkSoldierInfo) do
        local seat = v.slot_no
        if seat == seatIndex then
            return v.hero
        end
    end
    return nil
end

-- 获取当前装备位上的装备id，如果id == "" 则无装备(排行查看信息相关)
function ArenaData:getEquipDataSeat(selectSeat, equipSeat)
    local slotItem = self:getSlotItemBySeat(selectSeat)
    local equs = slotItem.equs
    print("ArenaData getEquipDataSeat ===== getEquipDataSeat ====== ")
    table.print(equs)
    for k, v in pairs(equs) do
        local no = v.no
        if no == equipSeat then
            return v.equ
        end
    end

    return nil
end

-- 竞技挑战 （请求返回进行初始化数据）
function ArenaData:setChallengeData(data)
    self.challengeData = data
end

-- 竞技挑战（客户端获取数据）
function ArenaData:getChallengeData()
    if self.challengeData ~= nil then
        return self.challengeData
    end
end

-- 挑战次数
function ArenaData:setChallengeNum(addNum)
    self.challengeNum = self.challengeNum + addNum
    return self.challengeNum
end

-- 获取当前的挑战次数
function ArenaData:getChallengeNum()
    return self.challengeNum
end

return ArenaData
