local CustomLabelItem = class("CustomLabelItem")

function CustomLabelItem:ctor(node, callback)
	self.callback_ = callback
	local children = node:getChildren()
	self.normalSprite = children[1]
	self.selectedSprite = children[2]
	self.selectedSprite:setVisible(false)
	self.touchNode = node
	self.touchNode:setContentSize(self.normalSprite:getContentSize())
end

function CustomLabelItem:selected(hasEffect)
	if hasEffect == true then
		getAudioManager():playEffectPage()
	end
	
	self.normalSprite:setVisible(false)
	self.selectedSprite:setVisible(true)
	if self.callback_ then
		return self.callback_()		
	end
end

function CustomLabelItem:unselected()
	self.normalSprite:setVisible(true)
	self.selectedSprite:setVisible(false)
end

function CustomLabelItem:isTouched(x, y)
	local pos = self.touchNode:convertToNodeSpace(cc.p(x, y))
	return cc.rectContainsPoint(self.normalSprite:getBoundingBox(), pos)
end

return CustomLabelItem