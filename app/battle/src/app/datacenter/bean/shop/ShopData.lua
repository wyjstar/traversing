local ShopData = class("ShopData")

function ShopData:ctor(id)

    self.shopList = {}

end

function ShopData:setData(data)

    self.shopList = data
end

function ShopData:getData()

    return self.shopList
end

function ShopData:getDataById(id)

    return self.shopList[id]
end

--equipment---------------------

-- 存购买装备操作，买的个数
function ShopData:setBuyEquipmentNumber(num) self.buyEquipNum = num end
function ShopData:getBuyEquipmentNumber() return self.buyEquipNum end

-- 缓存装备商店
function ShopData:setShopEquipList(ids)
	self.shopEquipIDsList = ids
	print("ShopData:setShopEquipList==========================>")
	table.print(ids)
end

function ShopData:getShopEquipList()
	return self.shopEquipIDsList
end

-- 缓存装备商店已买的物品
function ShopData:setShopEquipGotList(ids)
	self.shopEquipIDsGotList = ids
end

function ShopData:getShopEquipGotList()
	return self.shopEquipIDsGotList
end
--缓存全部购买的装备列表tips
function ShopData:setShopEquipTips(data)
	self.shopEquipTips = data
end

function ShopData:getShopEquipTips()
	return self.shopEquipTips
end
-- 缓存道具商店已买的物品


-- 缓存luck_num
function ShopData:setLuckNum(num)
	self.shopLuckNum = num
end

function ShopData:getLuckNum()
	if self.shopLuckNum == nil then return 0
	else return self.shopLuckNum end
end

--缓存商城刷新的次数
function ShopData:setRefreshTimes(reftimes)
	self.refreshTimes = reftimes
	print("----商城刷新的次数-----"..self.refreshTimes)
end

function ShopData:getRefreshTimes()
	return self.refreshTimes
end

function ShopData:addRefreshTimes(num)
	self.refreshTimes = self.refreshTimes + num
	print("----商城刷新的次数-----"..self.refreshTimes)
end
--------prop----------------------

function ShopData:setShopPropList(ids)
	self.shopPropIDsList = ids
	table.print(ids)
end

function ShopData:getShopPropList()
	return self.shopPropIDsList
end
function ShopData:setShopPropGotList(ids)
	self.shopPropIDsGotList = ids
end

function ShopData:getShopPropGotList()
	return self.shopPropIDsGotList
end
function ShopData:setProBuyTypeAndMoney(type,money)
	self.propUnit = {moneyType = type,useMoney = money}
end

function ShopData:getProBuyTypeAndMoney(type,money)
	return self.propUnit
end
--存储VIP奖励
function ShopData:setVipGiftData(data)
	table.print(data)
	if self.m_vipGift == nil then
	   self.m_vipGift = {}
	   self.m_vipGift["id"] = {}
	   self.m_vipGift["buyed_id"] = {}
    end
    
	for k,v in pairs(data.id) do
		local shopItem = getTemplateManager():getShopTemplate():getTemplateById(v)
		if shopItem["type"] == 24 then
			self.m_vipGift["id"][k] = v
		end
	end
	for k,v in pairs(data.buyed_id) do
		local shopItem = getTemplateManager():getShopTemplate():getTemplateById(v)
		if shopItem["type"] == 24 then
			self.m_vipGift["buyed_id"][k] = v
		end
	end
	
	table.print(self.m_vipGift)
	-- body
end
--获取vip奖励
function ShopData:getVipGiftData()
	return self.m_vipGift;
	-- body
end
function ShopData:setCanBuyCurVip( data )
	cclog("－－－－－－－setCanBuyCurVip－－－－－－"..data)
	table.insert(self.m_vipGift["buyed_id"],data)
	  
	-- body
end
function ShopData:getVipGiftData()
	
	if(self.m_vipGift == nil) then
		return nil
	end
	local vipData = {}
	local curViplevel = getDataManager():getCommonData():getVip()
	for k,v in pairs(self.m_vipGift["id"]) do
			--print(k,v)
			local limitVip = getTemplateManager():getShopTemplate():getBuyVIPLimitNumById(v,curViplevel)
			if limitVip == 1 then
				cclog("－－－－－－－vipData－－－－－－"..v)
				vipData["id"] = v
				break
			end
	end
	vipData["BuyEnable"] = 1
	for k,v in pairs(self.m_vipGift["buyed_id"]) do
			local limitVip = getTemplateManager():getShopTemplate():getBuyVIPLimitNumById(v,curViplevel)
			if limitVip > 0 then
				vipData["id"] = v
				vipData["BuyEnable"] = 0
				break
			end
		end
	return vipData
	-- body
end
--初始化道具已购买的数量
function ShopData:setProLimitOneDay(limitId,limitNum)
	cclog("----------setProLimitOneDay---@@@-----")
	table.print(limitId)
	cclog("--------------------")
	table.print(limitNum)
	self.proLimit = {}
	local num = table.getn(limitId)
	for i=1,num do
		self.proLimit[i] = {}
		self.proLimit[i]["limit_item_id"] = limitId[i]
		self.proLimit[i]["limit_item_num"] = limitNum[i]
	end
	cclog("----------setProLimitOneDay--------")
	table.print(self.proLimit)
end
--根据ID得到该ID所购买的数量
function ShopData:getProLimitOneDayById(id)
	if self.proLimit == nil then return 0 end
	for k,v in pairs(self.proLimit) do
		if v.limit_item_id == id then
			return v.limit_item_num
		end
	end
	return 0 
end

-- function ShopData:addLimitNumById(id,num)
-- 	if self.proLimit == nil then self.proLimit = {} end
-- 	for k,v in pairs(self.proLimit) do
-- 		if v.limit_item_id == id then
-- 			v.limit_item_num = v.limit_item_num+num
-- 			return 
-- 		end
-- 	end

-- 	self.proLimit[#self.proLimit+1]["limit_item_id"] = id 
-- 	self.proLimit[#self.proLimit+1]["limit_item_num"] = num
-- end

-----giftBag----------------------
function ShopData:setShopGiftBagList(ids)
	self.shopGiftBagIDsList = ids
	table.print(ids)
end

function ShopData:getShopGiftBagList()
	return self.shopGiftBagIDsList
end
function ShopData:setShopGiftBagGotList(ids)
	self.shopGiftBagIDsGotList = ids
end

function ShopData:getShopGiftBagGotList()
	return self.shopGiftBagIDsGotList
end
function ShopData:setGiftBagBuyTypeAndMoney(type,money)
	self.giftBagUnit = {moneyType = type,useMoney = money}
end

function ShopData:getGiftBagBuyTypeAndMoney(type,money)
	return self.giftBagUnit
end

--soul------------------------

-- 缓存武魂商店
function ShopData:setSoulList(ids)
	self.shopSoulIDsList = ids
end

function ShopData:getSoulList()
	return self.shopSoulIDsList
end

-- 缓存已购买的武魂商店物品
function ShopData:setSoulGotList(ids)
	self.shopSoulGotList = ids
end

function ShopData:getSoulGotList()
	return self.shopSoulGotList
end

--PVP------------------------
-- 缓存Pvp商店
function ShopData:setPvpList(ids)
	self.shopPvpIDsList = ids
end

function ShopData:getPvpList()
	return self.shopPvpIDsList
end

-- 缓存已购买商店物品
function ShopData:setPvpGotList(ids)
	self.shopPvpGotList = ids
end

function ShopData:getPvpGotList()
	return self.shopPvpGotList
end

--Smelting----------------------
-- 缓存Smelt商店
function ShopData:setSmeltList(ids)
	self.shopSmeltIDsList = ids
end

function ShopData:getSmeltList()
	return self.shopSmeltIDsList
end

-- 缓存已购买的商店物品
function ShopData:setSmeltGotList(ids)
	self.shopSmeltGotList = ids
end

function ShopData:getSmeltGotList()
	return self.shopSmeltGotList
end



-- 缓存秘境商店
function ShopData:setSecretPlaceList(ids)
	self.shopSecretPlaceIDsList = ids
end

function ShopData:getSecretPlaceList()
	return self.shopSecretPlaceIDsList
end

function ShopData:setSecretPlaceGotList(ids)
	self.shopSecretPlaceGotIDsList = ids
end

function ShopData:getSecretPlaceGotList()
	return self.shopSecretPlaceGotIDsList
end


--储存当前发送的商店协议的协议类型号
function ShopData:setShopType(shop_type)
	self.shopType = shop_type
end

function ShopData:getShopType()
	return self.shopType
end
--储存商城招募类型        1 良将招募  2 神将招募  3 继续招募
function ShopData:setShopRecruitType(rec_type)
	self.recruitType = rec_type 
end
function ShopData:getShopRecruitType()
	return self.recruitType
end

--@return
return ShopData
