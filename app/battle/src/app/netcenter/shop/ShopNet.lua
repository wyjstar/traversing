--商店网络通信
local ShopNet = class("ShopNet", BaseNetWork)

SHOP_REQUEST_HERO_CODE = 501		--抽取英雄
SHOP_REQUEST_ITEM_CODE = 502		--抽取装备
SHOP_BUY_ITEM_CODE = 503			--购买道具
SHOP_BUY_GIFT_BAG_CODE = 504		--购买礼包

SHOP_GET_ITEM_CODE = 508			--请求商店初始数据
SHOP_REFRESH_CODE = 507				--请求刷新
SHOP_BUY_GOODS_CODE = 505			--请求购买物品

RECHARGE_CODE = 2001 				--充值

local REFRESH_RECHARGE_SHOP_NOTICE = "REFRESH_RECHARGE_SHOP_NOTICE"

function ShopNet:ctor()
	self.super.ctor(self, "ShopNet")
	self:initRegisterNet()
end

--[[
商店类型编号
id	#
INT	#
1	商城良将寻访
2	商城良兵宝箱
3	商城道具
4	商城礼包
5	商城神将寻访
6	商城神兵宝箱
7	密境商店
9	武魂商店
10	竞技场商店
11	熔炼商店
12	抽装备商店
]]

--请求商城装备列表
function ShopNet:sendGetShopList(shop_t)
	local data = {shop_type=shop_t}
	self:sendMsg( SHOP_GET_ITEM_CODE, "GetShopItems", data )
	cclog("sendGetShopList===============")
end

--刷新列表
function ShopNet:sendRefreshShopList(shop_t)
	local data = {shop_type=shop_t}
	self:sendMsg( SHOP_REFRESH_CODE, "RefreshShopItems", data )
end

--购买一个物品，根据ID
function ShopNet:sendBuyGoods(_ids,num)
	local data = {}
	
	if type(_ids) == "table" then 
		data.ids = _ids
	elseif type(_ids) == "number" then 
		data.ids = {_ids}
	end

	if num == nil then
		num = {}
		local count = table.getn(data.ids)
		for i=1,count do 
			table.insert(num,1)
		end
	end
	if type(num) == "table" then data.item_count = num
	elseif type(num) == "number" then data.item_count = {num}
	end
	-- print("~~~~~~~~~~~~~~~~~~~")
	-- table.print(data)
	cclog("发送协议＝＝＝SHOP_BUY_GOODS_CODE")
	self:sendMsg( SHOP_BUY_GOODS_CODE, "ShopRequest", data )
end
-- function ShopNet:sendBuyGoods(_ids)
-- 	local data
-- 	if type(_ids) == "table" then data = {ids=_ids}
-- 	elseif type(_ids) == "number" then data = {ids={_ids}}
-- 	end
-- 	-- print("~~~~~~~~~~~~~~~~~~~")
-- 	-- table.print(data)
-- 	cclog("发送协议＝＝＝SHOP_BUY_GOODS_CODE")
-- 	self:sendMsg( SHOP_BUY_GOODS_CODE, "ShopRequest", data )
-- end

----------------------
--请求抽取英雄
function ShopNet:sendBuyHeroMsg()
	print("Request Buy Hero ..")
	local data = {ids = {10001}}
	self:sendMsg( SHOP_REQUEST_HERO_CODE, "ShopRequest", data )
end

-- 十个良将
function ShopNet:sendBuyHero10Msg()
	print("Request Buy Hero 10 ...")
	local data = {ids = {10002}}
	self:sendMsg( SHOP_REQUEST_HERO_CODE, "ShopRequest", data )
end

--请求抽取神将英雄
function ShopNet:sendBuyGodHeroMsg()
	print("Request Buy God Hero ...")
	local data = {ids = {50001}}
	self:sendMsg( SHOP_REQUEST_HERO_CODE, "ShopRequest", data )
end

-- 十个神将
function ShopNet:sendBuyGodHero10Msg()
	print("Request Buy God Hero 10...")
	local data = {ids = {50002}}
	self:sendMsg( SHOP_REQUEST_HERO_CODE, "ShopRequest", data )
end
--[[
--请求抽取装备
function ShopNet:sendBuyEquipMsg(number)
	print("Request Buy Equip ...")
	local data = {id = 20001, num = number}
	self:sendMsg( SHOP_REQUEST_ITEM_CODE, "ShopRequest", data )
end

--请求抽取神装
function ShopNet:sendBuyGodEquipMsg(number)
	print("Request Buy God Equip ...")
	local data = {id = 60001, num = number}
	self:sendMsg( SHOP_REQUEST_ITEM_CODE, "ShopRequest", data )
end
]]
--[[
--请求购买道具
function ShopNet:sendBuyItemMsg(ID)
	print("Request Buy Item ...")
	local data = {id = ID}
	self:sendMsg( SHOP_BUY_ITEM_CODE, "ShopRequest", data )
end

--请求购买礼包
function ShopNet:sendBuyGiftMsg(ID)
	print("Request Buy Gift ...")
	local data = {id = ID}
	self:sendMsg( SHOP_BUY_GIFT_BAG_CODE, "ShopRequest", data )
end
]]
--注册接受网络协议
function ShopNet:initRegisterNet()
	
	local function getShopItemCallback( data )  -- 商店信息
		print("<<===== 返回商店信息 =====>>")
		table.print(data)
		getDataManager():getShopData():setRefreshTimes(data.refresh_times)
		getDataManager():getShopData():setProLimitOneDay(data.limit_item_id,data.limit_item_num)
		getDataManager():getShopData():setVipGiftData(data)
		local vipData = getDataManager():getShopData():getVipGiftData()
		getDataManager():getCommonData():setVipGift(vipData["BuyEnable"])
	end

	local function getRefreshCallback( data )  -- 刷新
		-- print("<<===== 返回刷新信息 =====>>")
		-- table.print(data)
	end

	local function getCardCallback( data )  --接收物件
		-- print("<<=====获得物件====>>")
		if data.res.result == true then
			-- print("%%%%%%%%%%%%%%%%%%%")
			-- table.print(data)
			getDataProcessor():gainGameResourcesResponse(data.gain)
		else
			print("数据返回错误，CommomResponse.result = false")
		end
		-- 扣钱神吗的在UI上
	end
	--充值返回添加元宝数量
	local function getGoldback(data)
		print("getGoldback add gold ============== ")
		if data.res.result then
			getDataManager():getCommonData():setGold(data.gold)
			getDataManager():getCommonData():setVip(data.vip_level)
			getDataManager():getCommonData():setRechargeNum(data.recharge)

		end
		print("getGoldback ============= gold:", data.gold)
		print("getGoldback ============= vip_level:", data.vip_level)
		print("getGoldback ============= recharge tatol:", data.recharge)

		--发送通知充值商店更新ui
		local eventDispatcher = cc.Director:getInstance():getRunningScene():getEventDispatcher()
        local event = cc.EventCustom:new(REFRESH_RECHARGE_SHOP_NOTICE)
        eventDispatcher:dispatchEvent(event) 
     
	end
	self:registerNetMsg(SHOP_REQUEST_HERO_CODE, "ShopResponse", getCardCallback)
	-- self:registerNetMsg(SHOP_REQUEST_ITEM_CODE, "ShopResponse", getCardCallback)
	-- self:registerNetMsg(SHOP_BUY_ITEM_CODE, "ShopResponse", getCardCallback)
	-- self:registerNetMsg(SHOP_BUY_GIFT_BAG_CODE, "ShopResponse", getCardCallback)

	self:registerNetMsg(SHOP_GET_ITEM_CODE, "GetShopItemsResponse", getShopItemCallback) --初始化
	self:registerNetMsg(SHOP_REFRESH_CODE, "GetShopItemsResponse", getRefreshCallback) --刷新
	self:registerNetMsg(SHOP_BUY_GOODS_CODE, "ShopResponse", getCardCallback) -- 购买
	self:registerNetMsg(RECHARGE_CODE, "GetGoldResponse", getGoldback) -- 充值返回元宝数量	
end

function ShopNet:sendGetGold()
	print("sendGetGold recharge success ============ ")
	self:sendMsg(RECHARGE_CODE)
end


--@return 
return ShopNet

