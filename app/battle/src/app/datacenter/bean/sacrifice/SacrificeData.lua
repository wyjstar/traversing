-- 献祭数据管理

------------- 新系统将弃用 --------------

local  SacrificeData =  class("SacrificeData")

function SacrificeData:ctor()
	self.HeroSacrificeResponse = {}
	self.GetShopItemsResponse = {}
	self.SoulShopResponse = {}
end

function SacrificeData:setHeroSacrificeResponseData(data)
	self.HeroSacrificeResponse = data
end

function SacrificeData:getHeroSacrificeResponseData()
	
	return self.HeroSacrificeResponse
end

function SacrificeData:setSecretShopListData(data)
	self.GetShopItemsResponse = data
end

function SacrificeData:getSecretShopListData()
	
	return self.GetShopItemsResponse
end

function SacrificeData:setSoulShopResponse(data)
	self.SoulShopResponse = data
end

function SacrificeData:getSoulShopResponse()
	
	return self.SoulShopResponse
end

function SacrificeData:clearData()
	self.sacrificeData = {}
	self.GetShopItemsResponse = {}
	self.SoulShopResponse = {}
end

return SacrificeData