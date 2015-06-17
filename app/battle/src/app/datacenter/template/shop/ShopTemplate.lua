
local ShopTemplate = ShopTemplate or class("BagTemplate")
import("..config.shop_config")
import("..config.shop_type_config")
import("..config.recharge_config")

function ShopTemplate:ctor(controller)

end

function ShopTemplate:getTemplateById(id)
	return shop_config[id]
end
---- 抽取要价 ----

-- 良将 抽取要价
function ShopTemplate:getHeroUseMoney()
	return shop_config[10001].consume["1"][1]
end
-- 良将， 抽取10个要价
function ShopTemplate:getTenHeroUseMoney( ... )
	return shop_config[10002].consume["1"][1]
end
-- 神将 抽取要价
function ShopTemplate:getGodHeroUseMoney()
	return shop_config[50001].consume["2"][1]
end
-- 神将， 抽取10个要价
function ShopTemplate:getTenGodHeroUseMoney()
	return shop_config[50002].consume["2"][1]
end
-- 良装 抽取要价
function ShopTemplate:getEquipUseMoney()
	return shop_config[20001].consume["1"][1]
end
-- 神装， 抽取要价
function ShopTemplate:getGodEquipUseMoney()
	return shop_config[60001].consume["2"][1]
end
-- 获取Vip礼包 －－
function ShopTemplate:getVipGiftPrice(giftId)
	return shop_config[giftId].consume["107"][3]
	-- body
end

---- 免费周期 ----

-- 良将抽取免费周期
function ShopTemplate:getHeroFreePeriod()
	return shop_config[10001].freePeriod
end
-- 神将抽取免费周期
function ShopTemplate:getGodHeroFreePeriod()
	return shop_config[50001].freePeriod
end
-- 良装抽取免费周期
function ShopTemplate:getEquipFreePeriod()
	return shop_config[20001].freePeriod
end
-- 神装抽取免费周期
function ShopTemplate:getGodEquipFreePeriod()
	return shop_config[60001].freePeriod
end

-- 返回钱数，类型
function ShopTemplate:getFlashMoney(shop_type)
	local priceData = shop_type_config[shop_type].refreshPrice
	if table.nums(priceData) == 0 then return 0, 0
	else return table.getValueByIndex(priceData, 1), table.getKeyByIndex(priceData, 1)
	end
end


---- 道具。礼包 ----

-- 获取道具列表
function ShopTemplate:getPorps()
	local shopProps = {}
	for k, v in pairs(shop_config) do
		if v.type == 3 then
			table.insert(shopProps, v)
		end
	end

	return shopProps
end
function ShopTemplate:getBuyMaxNumById(id)
	local goods = shop_config[tonumber(id)]
	if goods then
		return goods.batch
	end
end
function ShopTemplate:getBuyVIPLimitNumById(id,vipno)
	local goods = shop_config[tonumber(id)]
	local vipLimite = goods.limitVIPeveryday[tostring(vipno)]
	if vipLimite then return vipLimite end
	return 0
end
-- 获取礼包列表
function ShopTemplate:getGifts()
	local shopGifts = {}
	for k, v in pairs(shop_config) do
		if v.type == 4 then
			table.insert(shopGifts, v)
		end
	end

	return shopGifts
end

--获取武魂商店的免费刷新次数
 function ShopTemplate:getRefreshTimesInSoulShop()
 	return shop_type_config[9].freeRefreshTimes
 end

 --获取熔炼商店的免费刷新次数
 function ShopTemplate:getRefreshTimesInEquipShop()
 	return shop_type_config[11].freeRefreshTimes
 end

--获取当前商店的免费刷新次数
function ShopTemplate:getRefreshTimes(shop_type)
	local type_num = tonumber(shop_type)
	return shop_type_config[type_num].freeRefreshTimes
end

--得到新手引导特殊处理的商品
function ShopTemplate:getSpecialGoods()
 	local specialGoods = {}
 	for k,v in pairs(shop_config) do
 		if v.type == 13 and not self:isInSpecialGoodsBuyed(v.id) then
 			v.got = false
 			table.insert(specialGoods,v)
 		end
 	end
 	return specialGoods
 end

function ShopTemplate:addSpecialGoodsBuyed(id)
	if id == nil then return end
	if self.specialGoodsBuyed == nil then
		cclog("----------------kong -----")
		self.specialGoodsBuyed = {}
	end
	for k,v in pairs(shop_config) do
 		if v.id == id and not self:isInSpecialGoodsBuyed(v.id) then
 			v.got = true
 			table.insert(self.specialGoodsBuyed,v)
 			return
 		end
 	end
end
function ShopTemplate:isInSpecialGoodsBuyed(id)
	if self.specialGoodsBuyed then
		for k,v in pairs(self.specialGoodsBuyed) do
			if v.id == id then return true end
		end
	end
	return false
end
 function ShopTemplate:getSpecialGoodsBuyed()
 	return self.specialGoodsBuyed
 end

--新手引导武魂商店特殊处理
function ShopTemplate:getSpecialSoulGoods()
 	local specialSoulGoods = {}
 	for k,v in pairs(shop_config) do
 		if v.type == 15 and not self:isInSpecialSoulGoodsBuyed(v.id) then
 			v.got = false
 			table.insert(specialSoulGoods,v)
 		end
 	end
 	return specialSoulGoods
 end

function ShopTemplate:addSpecialSoulGoodsBuyed(id)
	if id == nil then return end
	if self.specialSoulGoodsBuyed == nil then
		cclog("----------------kong -----")
		self.specialSoulGoodsBuyed = {}
	end
	for k,v in pairs(shop_config) do
 		if v.id == id and not self:isInSpecialSoulGoodsBuyed(v.id) then
 			v.got = true
 			table.insert(self.specialSoulGoodsBuyed,v)
 			return
 		end
 	end
end
function ShopTemplate:isInSpecialSoulGoodsBuyed(id)
	if self.specialSoulGoodsBuyed then
		for k,v in pairs(self.specialSoulGoodsBuyed) do
			if v.id == id then return true end
		end
	end
	return false
end
 function ShopTemplate:getSpecialSoulGoodsBuyed()
 	return self.specialSoulGoodsBuyed
 end

--新手引导装备商城特殊处理
function ShopTemplate:getSpecialEquipGoods()
 	local specialGoods = {}
 	for k,v in pairs(shop_config) do
 		if v.type == 16 and not self:isInSpecialEquipGoodsBuyed(v.id) then
 			v.got = false
 			table.insert(specialGoods,v)
 		end
 	end
 	return specialGoods
 end

function ShopTemplate:addSpecialEquipGoodsBuyed(id)
	if id == nil then return end
	if self.specialEquipGoodsBuyed == nil then
		cclog("----------------kong -----")
		self.specialEquipGoodsBuyed = {}
	end
	for k,v in pairs(shop_config) do
 		if v.id == id and not self:isInSpecialEquipGoodsBuyed(v.id) then
 			v.got = true
 			table.insert(self.specialEquipGoodsBuyed,v)
 			return
 		end
 	end
end
function ShopTemplate:isInSpecialEquipGoodsBuyed(id)
	if self.specialEquipGoodsBuyed then
		for k,v in pairs(self.specialEquipGoodsBuyed) do
			if v.id == id then return true end
		end
	end
	return false
end
 function ShopTemplate:getSpecialEquipGoodsBuyed()
 	return self.specialEquipGoodsBuyed
 end

--根据设备类型得到充值列表
 function ShopTemplate:getRechargeListByPlatform(platform)
 	local rechargeList = {}
 	for k,v in pairs(recharge_config) do
 		if v.flatform == platform then
 			table.insert(rechargeList,v)
 		end
 	end
 	local function mySort(item1, item2)
	    return item1.currence > item2.currence
	end
	table.sort(rechargeList, mySort)

 	return rechargeList
 end

 --获取预览良将id列表
 function ShopTemplate:getPreviewNormalHeroId()
 	local heroes = {}
 	for k,v in pairs(small_bag_config) do
 		if v["dropId"] == 1000001 then
 			table.insert(heroes,v["detailID"])
 		end
 	end
 	return heroes
 end

  --获取预览神将id列表
 function ShopTemplate:getPreviewEpicHeroId()
 	local heroes = {}
 	for k,v in pairs(small_bag_config) do
 		if v["dropId"] == 1000004 then
 			table.insert(heroes,v["detailID"])
 		end
 	end
 	return heroes
 end

 function ShopTemplate:getEquipmentRefreshTime( ... )
 	for k,v in pairs(shop_type_config) do
 		if v["id"] == 12 then
 			return v["freeRefreshTime"]
 		end
 	end
 end

return ShopTemplate
