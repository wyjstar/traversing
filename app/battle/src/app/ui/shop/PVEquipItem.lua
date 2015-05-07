local PVEquipItem = class("PVEquipItem",function()
	return game.newNode()
end)

function PVEquipItem:ctor(data)
	self.data_ = data
	local ShopItem = {}
	local node = game.newCCBNode("shop/ui_shop_item.ccbi", ShopItem)
	game.setSpriteFrame(ShopItem["ShopItem"]["item_bg"], getQualityBgImg(self.data_.quality))
	if self.data_.item_type == 1 then
		ShopItem["ShopItem"]["item_icon"]:setScale(0.4)
	elseif self.data_.item_type == 2 then
		ShopItem["ShopItem"]["item_icon"]:setScale(0.5)		
	end
	ShopItem["ShopItem"]["item_icon"]:setTexture(self.data_.icon)
	ShopItem["ShopItem"]["item_name"]:setString(self.data_.name)
	ShopItem["ShopItem"]["item_name"]:enableOutline(ui.COLOR_BLACK, 3)
	--是否打折
	local isSale = (self.data_.disMoney ~= nil)
	ShopItem["ShopItem"]["dazhe_bg"]:setVisible(isSale)
	ShopItem["ShopItem"]["del_line"]:setVisible(isSale)
	--原价，如无折扣原价为现价
	ShopItem["ShopItem"]["price1_bg"]:setVisible(true)
	if self.data_.useMoneyType == 1 then
		ShopItem["ShopItem"]["gold_icon1"]:setVisible(false)
		ShopItem["ShopItem"]["gold_icon2"]:setVisible(false)
		ShopItem["ShopItem"]["coin_icon1"]:setVisible(true)
		ShopItem["ShopItem"]["coin_icon2"]:setVisible(true)
		ShopItem["ShopItem"]["price1"]:setBMFontFilePath("font/yinding.GlyphProject.fnt")					
		ShopItem["ShopItem"]["price2"]:setBMFontFilePath("font/yinding.GlyphProject.fnt")					
	else
		ShopItem["ShopItem"]["gold_icon1"]:setVisible(true)
		ShopItem["ShopItem"]["gold_icon2"]:setVisible(true)
		ShopItem["ShopItem"]["coin_icon1"]:setVisible(false)
		ShopItem["ShopItem"]["coin_icon2"]:setVisible(false)
		ShopItem["ShopItem"]["price1"]:setBMFontFilePath("font/yuanbao.GlyphProject.fnt")
		ShopItem["ShopItem"]["price2"]:setBMFontFilePath("font/yuanbao.GlyphProject.fnt")								
	end
	--现价
	ShopItem["ShopItem"]["price2_bg"]:setVisible(isSale)
	if isSale then
		local zheStr = string.format(Localize.query("shop.23"), self.data_.disMoney*10/self.data_.useMoney)
		ShopItem["ShopItem"]["dazhe_label"]:setString(zheStr)
		ShopItem["ShopItem"]["price2"]:setString(self.data_.disMoney)
		ShopItem["ShopItem"]["price1"]:setString(self.data_.useMoney)		
	else
		ShopItem["ShopItem"]["price1"]:setString(self.data_.useMoney)
	end
	ShopItem["ShopItem"]["bought"]:setVisible(self.data_.got)
	self:addChild(node)
	self:setContentSize(node:getContentSize())
	self.touchBox = node
	self.icon = ShopItem["ShopItem"]["item_icon"]
	self.defaultScale = self.icon:getScale()
end

function PVEquipItem:getData()
	return self.data_
end

function PVEquipItem:isEqual(cell)
	return self.data_.id == cell:getData().id
end

function PVEquipItem:setSelected(selected)
    if selected then
        self.icon:setScale(self.defaultScale*1.2)       
    else
        self.icon:setScale(self.defaultScale)        
    end
end

function PVEquipItem:isTouched(x, y)
    local pos = self.touchBox:convertToNodeSpace(cc.p(x, y))
    return cc.rectContainsPoint(self.touchBox:getBoundingBox(), pos)
end

return PVEquipItem