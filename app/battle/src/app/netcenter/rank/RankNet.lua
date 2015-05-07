RANK_LIST = 1805

local RankNet =  class("RankNet", BaseNetWork)

function RankNet:ctor()
    self.super.ctor(self, "RankNet")
    self.rankData = getDataManager():getRankData()
    self:init()
end

function RankNet:init()
    self:registerNetCallBack()
end

--请求排行列表
function RankNet:sendGetRankList(firstNo, lastNo, rankType)
    print("请求排行列表 RankNet:sendGetRankList ======= ")
    local data =
                {
                    first_no = firstNo,
                    last_no = lastNo,
                    rank_type = rankType
                }
    table.print(data)
    self:sendMsg(RANK_LIST, "GetRankRequest", data)
end


function RankNet:registerNetCallBack()
    -- 1805
    local function getRankListCallBack(data)
        print("请求排行返回 -----getRankListCallBack---- ", data)
        table.print(data)
        local curType = self.rankData:getCurType()
        self.rankData:setRankList(curType, data.user_info)
        if data.my_rank_info ~= nil then
            self.rankData:setMyRankInfo(data.my_rank_info)
            self.rankData:setRankNums(data.all_num)
        end
    end

    self:registerNetMsg(RANK_LIST, "GetRankResponse", getRankListCallBack)
end

return RankNet
