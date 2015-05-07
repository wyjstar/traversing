ARENA_RANKLIST = 1501                   --排行列表协议号
ARENA_ARENALIST = 1502                  --竞技列表协议号
ARENA_REFRESH = 1503                   --竞技列表刷新
ARENA_RANK_CHECK = 1504                 --排行查看
ARENA_CHALLENGE = 1505                  --发送挑战
-- ARENA_EXCHANGELIST = 1511             --兑换列表协议号  --新版本废弃，改用ShopNet
ARENA_EXCHANGE = 1510                  --进行兑换

ARENA_RESET_CHALLENGE = 1506

ArenaNet = class("ArenaNet", BaseNetWork)

function ArenaNet:ctor()
    self.super.ctor(self, "ArenaNet")
    self:init()
end

function ArenaNet:init()
    self.c_arenaData = getDataManager():getArenaData()
    self.memberList = {}
    self.exchangeList = {}
    self:registerChatCallBack()
end

------=======发送协议=======------

--获取排行列表 1501
function ArenaNet:sendGetRankList()
    print("请求竞技排行列表 ===============" )
    self:sendMsg(ARENA_RANKLIST)
end

--获取竞技列表 1502
function ArenaNet:sendGetArenaList()
    print("请求竞技列表 =============== ")
    self:sendMsg(ARENA_ARENALIST)
end

--竞技列表刷新 1503
function ArenaNet:sendRefreshArenaList()
    print("竞技列表刷新协议 =============== ")
    self:sendMsg(ARENA_REFRESH)
end

--[[ 新版本废弃，改用ShopNet
--获取兑换列表
function ArenaNet:sendGetExchangeList()
    print("请求兑换列表 ================ ")
    self:sendMsg(ARENA_EXCHANGELIST)
end
]]
--进行兑换
function ArenaNet:sendExchange(itemId)
    local data = { id = itemId}
    self:sendMsg(ARENA_EXCHANGE, "ArenaShopRequest", data)
end

--排行信息中查看战队信息
function ArenaNet:sendCheckInfo(rank_num)
    local data = { player_rank = rank_num }
    self:sendMsg(ARENA_RANK_CHECK, "PvpPlayerInfoRequest", data)
end

-- 竞技中发起挑战 1505
function ArenaNet:sendChallenge(data)
    self:sendMsg(ARENA_CHALLENGE, "PvpFightRequest", data)
end

--重置挑战次数协议
function ArenaNet:sendResetChallenge()
    print("发送重置协议 =============== ")
    self:sendMsg(ARENA_RESET_CHALLENGE)
end

------=======协议返回=======------

function ArenaNet:registerChatCallBack()
    --排行列表请求返回 1501
    local function rankListCallBack(data)
        print("竞技排行数据返回 ============ ", data)
        table.print(data)
        self.c_arenaData:setRankList(data.rank_items)
        print("@@@@@@ player_rank", data.player_rank)
    end
    self:registerNetMsg(ARENA_RANKLIST, "PlayerRankResponse", rankListCallBack)

    --竞技列表请求返回 1502
    local function arenaListCallBack(data)
        print("竞技场数据返回 9999999999 ========== ",data)
        table.print(data)
        self.c_arenaData:setRankOrder(data.player_rank)
        getDataManager():getCommonData():setPvpStore(data.pvp_score)
        self.c_arenaData:setArenaList(data.rank_items)

    end
    self:registerNetMsg(ARENA_ARENALIST, "PlayerRankResponse", arenaListCallBack)

    --竞技列表刷新返回 1503
    local function refreshCallBack(data)
        print("竞技列表刷新返回 ============ ")
        table.print(data.rank_items)
        self.c_arenaData:setArenaList(data.rank_items)
    end
    self:registerNetMsg(ARENA_REFRESH, "PlayerRankResponse", refreshCallBack)

    --兑换请求返回
    local function exchangeCallBack(data)
        print("兑换请求之后返回数据 ============= ", data)
        table.print(data)
        self.c_arenaData:setExchangeResult(data)
    end
    self:registerNetMsg(ARENA_EXCHANGE, "ArenaShopResponse", exchangeCallBack)

    --排行列表中战队信息查看
    local function checkInfoCallBack(data)
        print("排行列表返回 ==== ========= ", data)
        table.print(data)
        self.c_arenaData:setRankCheckInfo(data.slot)
        self.c_arenaData:setOtherPlayerLineUp(data)
    end

    self:registerNetMsg(ARENA_RANK_CHECK, "LineUpResponse", checkInfoCallBack)

    --竞技发起挑战协议返回 1505
    local function getChallengeCallBack(data)
        print("发起pvp挑战返回 -=================-")
    end
    self:registerNetMsg(ARENA_CHALLENGE, "PvpFightResponse", getChallengeCallBack)

    --挑战次数重置返回
    local function getResetCallBack(data)
        print("挑战次数重置 返回 ========= ")
        -- required CommonResponse res = 1;
        -- optional GameResourcesResponse consume = 2;
        -- optional GameResourcesResponse gain = 3;
        table.print(data)
    end

    self:registerNetMsg(ARENA_RESET_CHALLENGE, "ShopResponse", getResetCallBack)

end

return ArenaNet
