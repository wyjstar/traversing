local PVButton = class("PVButton")

function PVButton:ctor(btn, callback)
	local children = btn:getChildren()
	self.normalSprite_ = children[1] or btn
	self.selectedSprite_ = children[2] or self.normalSprite_
	self.disabledSprite_ = children[3] or self.normalSprite_
	self.redPoint = children[4]

	self.callback_ = callback
	--self.normalSprite_:isVisible()
	self:setEnabled(true)
	self.selected_ = false
	self.rect_ = self.normalSprite_:getBoundingBox()
	self.rect_.x = 0
	self.rect_.y = 0
end

function PVButton:onClick(eventType)
	if eventType == "began" then
		self:selected()		
	elseif eventType == "canceled" then
		self:unselected()
	elseif eventType == "ended" then
		self:unselected()
		getAudioManager():playEffectButton1()
		if self.callback_ then self.callback_() end		
	else
		cclog("eventType is error:",eventType)
	end	
end

function PVButton:isClicked(x, y)
	if self.enabled_ then
		local nodeSpace = self.normalSprite_:convertToNodeSpace(cc.p(x,y))
		return cc.rectContainsPoint(self.rect_, nodeSpace)
	end
	return false
end

function PVButton:selected()
	if not self.enabled_ then return end
	self.selected_ = true
	self.normalSprite_:setVisible(false)
	self.selectedSprite_:setVisible(true)
	self.selectedSprite_:setScale(0.9)
	if self.redPoint then
		self.redPoint:setScale(0.9)
	end
end

function PVButton:unselected()
	if not (self.enabled_ and self.selected_) then return end
	self.selected_ = false		
	self.selectedSprite_:setScale(1)
	if self.redPoint then
		self.redPoint:setScale(1)
	end
	self.selectedSprite_:setVisible(false)			
	self.normalSprite_:setVisible(true)	
end

function PVButton:isEnabled()
	return self.enabled_
end

function PVButton:setEnabled(enabled)
	if self.enabled_ == nil or self.enabled_ ~= enabled then
		self.enabled_ = enabled
		if self.enabled_ then
			self.selectedSprite_:setVisible(false)
			self.disabledSprite_:setVisible(false)
			self.normalSprite_:setVisible(true)						
		else
			self.normalSprite_:setVisible(false)
			self.selectedSprite_:setVisible(false)
			self.disabledSprite_:setVisible(true)						
		end
	end
end

return PVButton