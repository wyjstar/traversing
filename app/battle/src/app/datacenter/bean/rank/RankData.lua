-- RANK_POWER = 1
-- RANK_STAR = 2
-- RANK_LEVEL = 3
--符文相关数据
local RankData = class("RankData")

function RankData:ctor()
    self.curType = 1
    self.rankList = {}
    self.topRankList = {}
    self.rankNums = 0
    self.myRankInfo = nil
end

--设置排行数据
function RankData:setRankList(cur_type, data)
    local curType = tonumber(cur_type)
    self.rankList[curType] = data
end

function RankData:getRankList(cur_type)
    local curType = tonumber(cur_type)
    return self.rankList[curType]
end

--获取前三名的信息
function RankData:getTopList(cur_type)
    self.topRankList = {}
    local curType = tonumber(cur_type)
    local curRankList = self.rankList[curType]
    for i = 1, 3 do
        local rankItem = curRankList[i]
        if rankItem ~= nil then
            table.insert(self.topRankList, rankItem)
        end
    end
    return self.topRankList
end

--设置自己的排行信息
function RankData:setMyRankInfo(data)
    self.myRankInfo = data
end

function RankData:getMyRankInfo()
    return self.myRankInfo
end

--设置排行榜总人数
function RankData:setRankNums(num)
    self.rankNums = num
end

function RankData:getRankNums()
    return self.rankNums
end

--设置当前排行类型
function RankData:setCurType(rankType)
    self.curType = rankType
end

function RankData:getCurType()
    return self.curType
end

return RankData
