local PVGiftItem = class("PVGiftItem", function()
	return game.newNode()
end)

function PVGiftItem:ctor(data)
	local UIGiftItem = {}
	local node = game.newCCBNode("shop/ui_gift_item.ccbi", UIGiftItem)
	game.setSpriteFrame(UIGiftItem["UIGiftItem"]["item_bg"], getQualityBgImg(data.quality))
	UIGiftItem["UIGiftItem"]["item_icon"]:setTexture(data.icon)
	if data.item_type == 102 or data.item_type == 104 then
		UIGiftItem["UIGiftItem"]["item_icon"]:setScale(0.5)	
	end
	if data.item_type == 103 or data.item_type == 104 then
		UIGiftItem["UIGiftItem"]["item_break"]:setVisible(true)
	else
		UIGiftItem["UIGiftItem"]["item_break"]:setVisible(false)		
	end
	UIGiftItem["UIGiftItem"]["item_count"]:setString(data.item_count)
	self:addChild(node)
	self:setContentSize(node:getContentSize())
end

function PVGiftItem:isTouched(x, y)
	return false
end

return PVGiftItem