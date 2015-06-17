-- 秘境网络
MINE_BASE_INFO = 1240               --查询矿点基本信息-主页面显示
MINE_SEARCH = 1241                  --搜索矿点
MINE_RESET = 1242                   --重置地图
MINE_DETAIL_INFO = 1243             --查看矿点详细信息
MINE_GUARD = 1244                   --驻守矿点－换阵容
MINE_HARVEST = 1245                 --收获符文石
MINE_BATTLE = 1253                  --攻占矿点
MINE_SHOP_INFO = 1247               --查看神秘商人信息  -- 神秘商人已走商店统一接口
MINE_EXCHANGE_SHOP = 1248           --神秘商人兑换
MINE_BOX = 1249                     --宝箱领奖
MINE_ACC = 1250                     --主矿增产
MINE_WIN_SETTLE = 1252              --胜利结算
MINE_RAND_BOSS_PUSH = 1707          --触发随机boss后 服务器推送过来的协议
RAND_BOSS_INFO = 1701               -- 

local SecretPlaceNet = class("SecretPlaceNet", BaseNetWork)

function SecretPlaceNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
    self:initRegisterNet()
end

function SecretPlaceNet:init()
    self.c_mineData = getDataManager():getMineData()
end

--查询矿点基本信息-主页面显示1240
function SecretPlaceNet:getMineBaseInfo()
    self:sendMsg(MINE_BASE_INFO)
end

--搜索矿点1241
function SecretPlaceNet:searchMine(data)
    self:sendMsg(MINE_SEARCH, "positionRequest", data)
end

--重置地图1242
function SecretPlaceNet:resetMap(data)
    self:sendMsg(MINE_RESET, "resetMap", data)
end


--查询矿点相信信息1243
function SecretPlaceNet:getDetailInfo(data)
    print("--getDetailInfo-----")

    self:sendMsg(MINE_DETAIL_INFO, "positionRequest", data)
end

--驻守占领的矿点1244
function SecretPlaceNet:guardMine(data) -- 请求信息需要包括矿点位置和阵容信息--需待完成
    self:sendMsg(MINE_GUARD, "MineGuardRequest", data)
end

--收获符文石1245
function SecretPlaceNet:harvestStones(data)
    self:sendMsg(MINE_HARVEST, "positionRequest", data)
end

--攻占矿点1253
function SecretPlaceNet:battleMine(data) -- 请求信息需要包括矿点位置和阵容信息--需待完成
    self:sendMsg(MINE_BATTLE, "MineBattleRequest", data)
end

--查看神秘商人信息1247
function SecretPlaceNet:queryShop(data)
    self:sendMsg(MINE_SHOP_INFO, "positionRequest", data)
end

--神秘商人兑换1248
function SecretPlaceNet:exchange(data)
    self:sendMsg(MINE_EXCHANGE_SHOP, "exchangeRequest", data)
end

--巨龙宝箱领取奖励1249
function SecretPlaceNet:getReward(data)
    self:sendMsg(MINE_BOX, "positionRequest", data)
end

--增产
function SecretPlaceNet:increase(data)
    self:sendMsg(MINE_ACC, "positionRequest", data)
end

--结算
function SecretPlaceNet:sendMineSettleRequest(data)
    cclog("----------sendMineSettleRequest----------")
    self:sendMsg(MINE_WIN_SETTLE, "MineSettleRequest", data)
end

--注册接受网络协议
function SecretPlaceNet:initRegisterNet()
    
    --1240查询矿点基本信息返回
    local function mineBaseInfo(data)
        cclog("----1240查询矿点基本信息返回---")
        -- table.print(data.mine) 
        self.c_mineData:setMineInfo(data)
    end
    --1241搜索矿点返回
    local function searchMineCallback(data)
        cclog("－－－－－－－搜索矿点－－－－－－－")
        -- table.print(data)
        self.c_mineData:setOneMineInfo(data)
    end
    --1242重置地图返回
    local function resetMapCallback(data)
        cclog("----------map reset---------")
        -- table.print(data)
        self.c_mineData:setMapInfo(data)
    end
    --1243查询矿点详细信息返回
    local function mineDetailInfo(data)
        cclog("----1243查询矿点详细信息返回---")
        -- table.print(data.lineup.travel_item_chapter)
        self.c_mineData:setDetailInfo(data)
    end

    --1244驻守矿点返回
    local function guradMineCallback(data)
        --self.c_mineData:setGuradInfo(data)
        -- table.print(data)
        getNetManager():getEquipNet():sendGetEquipMsg() 
        getNetManager():getSoldierNet():sendGetSoldierMsg()
    end

    --1245收获符文石
    local function harvestCallBack(data)
        print("---------1245收获符文石---------")
        -- table.print(data)
        self.c_mineData:procHarvest(data)
    end

    --1246攻占矿点战斗返回
    local function battleCallback(data)
        cclog("---==-----1246攻占矿点战斗返回---===-")
        -- table.print(data)
        self.c_mineData:setBattleResponse(data)
    end

    --1247查看神秘商人返回
    local function queryShopCallback(data)
        -- table.print(data)
    end

    --1248商人兑换返回
    local function exchangeCallback(data)
        -- table.print(data)
        --返回兑换内容
    end

    --1249领取巨龙宝箱奖励
    local function getRewardCallback(data)
        -- cclog("--------领取巨龙宝箱奖励-------------")
        -- table.print(data) --领取的奖励
        -- cclog("--------领取巨龙宝箱奖励-------------")
        self.c_mineData:setBoxReward(data)
    end

    --1250增产返回
    local function increaseCallBack(data)
        print("--------1250增产返回---------")
        -- table.print(data)
        self.c_mineData:setIncrease(data)
    end

    --1252结算
    local function settleCallBack(data)
        print("-------settleCallBack========")
        -- table.print(data)
        self.c_mineData:setSettle(data)
    end

    --1259触发世界boss
    local function bossCallBack(data)

    end

    --1707
    local function bossPushCallBack(data)

        self.c_mineData:setMineBossResponse(data)
    end
    
    self:registerNetMsg(MINE_RAND_BOSS_PUSH, "MineBossResponse", bossPushCallBack)
    self:registerNetMsg(MINE_WIN_SETTLE, "CommonResponse", settleCallBack)
     self:registerNetMsg(MINE_BASE_INFO, "mineUpdate", mineBaseInfo)
    self:registerNetMsg(MINE_SEARCH, "searchResponse", searchMineCallback)
    self:registerNetMsg(MINE_RESET, "resetResponse", resetMapCallback)
    self:registerNetMsg(MINE_DETAIL_INFO, "mineDetail", mineDetailInfo)
    self:registerNetMsg(MINE_GUARD, "CommonResponse", guradMineCallback)
    self:registerNetMsg(MINE_HARVEST, "drawStones", harvestCallBack)
    self:registerNetMsg(MINE_BATTLE, "MineBattleResponse", battleCallback)
    self:registerNetMsg(MINE_SHOP_INFO, "shopStatus", queryShopCallback)
    self:registerNetMsg(MINE_EXCHANGE_SHOP, "exchangeResponse", exchangeCallback)
    self:registerNetMsg(MINE_BOX, "boxReward", getRewardCallback)
    self:registerNetMsg(MINE_ACC, "IncreaseResponse", increaseCallBack)

end

return SecretPlaceNet
