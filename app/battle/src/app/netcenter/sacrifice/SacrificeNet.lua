-- 献祭网络层协议管理


------- 新版中废弃此类 --------


local SacrificeNet =  class("SacrificeNet", BaseNetWork)

HERO_SACRIFICE_REQUEST		= 105	    -- 武将献祭
SECRET_SHOP_LIST_REQUEST	= 507 		-- 武魂商店列表
SECRET_SHOP_GETLIST_REQUEST  = 508     -- 第一次武魂商店列表
SECRET_SHOP_BUY_REQUEST		= 506 		-- 武魂商店兑换
HEROCHIP_SACRIFICE_REQUEST = 119     -- 武将碎片献祭

function SacrificeNet:ctor()
	self.super.ctor(self, self.__cname);
	self:init()
	self:initRegisterNet()
end

function SacrificeNet:init()
	
end

-- 发送武将献祭接口
function SacrificeNet:sendHeroSacrificeRequest(encodeWhat,data)

	self:sendMsg(HERO_SACRIFICE_REQUEST, encodeWhat, data)

end


-- 发送武将碎片献计接口
-- function SacrificeNet:sendHeroChipSacrificeRequest( data)

--   self:sendMsg(HEROCHIP_SACRIFICE_REQUEST, data)

-- end
-- 获取武魂商店列表
function SacrificeNet:sendGetSecretShopList()

	self:sendMsg(SECRET_SHOP_LIST_REQUEST)

end

-- 第一次获取武魂商店列表
function SacrificeNet:sendFirstGetSecretShopList()

  self:sendMsg(SECRET_SHOP_GETLIST_REQUEST)

end

-- 武魂商店购买
function SacrificeNet:sendBuySecretShopItem(data)

	self:sendMsg(SECRET_SHOP_BUY_REQUEST, "SoulShopRequest", data)

end

-- 注册网络接收协议
function SacrificeNet:initRegisterNet()
	  local function onHeroSacrificeCallBack(data)
      cclog("武魂获得返回")
      table.print(data)
      cclog("武魂获得返回")
      getDataManager():getSacrificeData():setHeroSacrificeResponseData(data)

    end
    -- 武魂商店
    local function onGetSecretShopListCallBack(data)
      -- print("--onGetSecretShopListCallBack--")
       -- table.print(data)
       getDataManager():getSacrificeData():setSecretShopListData(data)
    end

     -- 武魂商店购买
    local function onBuySecretShopItemCallBack(data)
      getDataManager():getSacrificeData():setSoulShopResponse(data)
       -- table.print(data)
    end

    self:registerNetMsg(SECRET_SHOP_LIST_REQUEST, "GetShopItemsResponse", onGetSecretShopListCallBack);
    self:registerNetMsg(SECRET_SHOP_GETLIST_REQUEST, "GetShopItemsResponse", onGetSecretShopListCallBack);
    self:registerNetMsg(SECRET_SHOP_BUY_REQUEST, "SoulShopResponse", onBuySecretShopItemCallBack);
    self:registerNetMsg(HERO_SACRIFICE_REQUEST, "HeroSacrificeResponse", onHeroSacrificeCallBack);
end

return SacrificeNet