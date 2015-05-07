--武将网络
local SodierNet = class("SodierNet", BaseNetWork)

NET_ID_HERO_REQUEST  = 101  --获得武将
NET_ID_HERO_BREAK    = 104  --突破
NET_ID_HERO_COMPOSE         = 106  --武将合成
NET_ID_HERO_GET_PATCH = 108 --获得武将碎片
NET_ID_HERO_UPGRADE = 103 --武将升级

function SodierNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
    self:initRegisterNet()
end

function SodierNet:init()
    self.soldierData = getDataManager():getSoldierData()
    
end

--发送获取武将列表
function SodierNet:sendGetSoldierMsg()
    self:sendMsg(NET_ID_HERO_REQUEST)
end

--发送武将合成
function SodierNet:sendComposeSoldierMsg(soldierId)
    local data = {hero_chip_no = soldierId}

    self:sendMsg(NET_ID_HERO_COMPOSE, "HeroComposeRequest", data, true)
end

--武将突破
function SodierNet:sendBreakSoldierMsg(heroNo)
    local data = {hero_no = heroNo}

    self:sendMsg(NET_ID_HERO_BREAK, "HeroBreakRequest", data)
end

--请求全部武将碎片
function SodierNet:sendGetSoldierPatch()
    self:sendMsg(NET_ID_HERO_GET_PATCH)
end

--发送武将升级
function SodierNet:sendSoldierUpgrade(hero_no, exp_item_no, exp_item_num)
     local data = {hero_no = hero_no,
                    exp_item_no = exp_item_no,
                    exp_item_num = exp_item_num
                    }

    self:sendMsg(NET_ID_HERO_UPGRADE, "HeroUpgradeWithItemRequest", data,true)
end
--
--注册接受网络协议
function SodierNet:initRegisterNet()
    local function onGetSoldierCallBack(data)
        print("+++++++++++++++++++  onGetSoldierCallBack  ++++++++++++++++++++")
        table.remove(g_netResponselist)
        self.soldierData:setSoldierData(data.heros)
    end

    local function onBreakCallBack(data)
        if data.res.result == true then
            getDataProcessor():consumeGameResourcesResponse(data.consume)    
        end
    end

    local function onComposeSoldierCallBack(data)
        print("+++++++++++++++++++  onComposeSoldierCallBack  ++++++++++++++++++++")
        print(data.res.result)
        print("dafadfaagas")
        if data.res.result == true then
            local hero = data.hero
            self.soldierData:addData(hero)
        end
    end

    local function onGetPatchCallBack(data)
        print("+++++++++++++++++++  onGetPatchCallBack  ++++++++++++++++++++")
        
        table.remove(g_netResponselist)

        self.soldierData:setPatchData(data.hero_chips)
    end

    local function onSoldierUpgradeCallBack(data)
        print("+++++++++++++++++++  onSoldierUpgradeCallBack  ++++++++++++++++++++")
        
    end

    self:registerNetMsg(NET_ID_HERO_REQUEST, "GetHerosResponse", onGetSoldierCallBack)
    self:registerNetMsg(NET_ID_HERO_BREAK, "HeroBreakResponse", onBreakCallBack)
    self:registerNetMsg(NET_ID_HERO_COMPOSE, "HeroComposeResponse", onComposeSoldierCallBack)
    self:registerNetMsg(NET_ID_HERO_GET_PATCH, "GetHeroChipsResponse", onGetPatchCallBack)
    self:registerNetMsg(NET_ID_HERO_UPGRADE, "HeroUpgradeResponse", onSoldierUpgradeCallBack)
    
end

return SodierNet
