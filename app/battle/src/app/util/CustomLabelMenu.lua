local CustomLabelMenu = class("CustomLabelMenu")

function CustomLabelMenu:ctor(node)
	self.items_ = {}
	self.curIndex = 0
	node:setTouchEnabled(true)
	node:registerScriptTouchHandler(handler(self, self.onTouch))
	self.touchRect = node
end

function CustomLabelMenu:addMenuItem(item)
	local index = #self.items_ + 1
	item.index_ = index	
	self.items_[index] = item
end

function CustomLabelMenu:onTouch(event,x, y)
    if event == "began" then
    	self.touchItem = self:checkLabel(x, y)
    	if self.touchItem then
    		return true
    	end
    	return false
    elseif event == "ended" then
    	self:changeLabel(self.touchItem.index_)
    	self.touchItem = nil
    end	
end

function CustomLabelMenu:changeLabel(index)
	if self.curIndex == index or index == nil or index == 0 or index > #self.items_ then return end
	self.curIndex = index
	for i = 1, #self.items_ do
		if self.items_[i].index_ == index then
			self.items_[i]:selected()
		else
			self.items_[i]:unselected()
		end
	end
end

function CustomLabelMenu:checkLabel(x, y)
	-- local pos = self.touchRect:convertToNodeSpace(cc.p(x, y))
	for i = 1, #self.items_ do
		local item = self.items_[i]
		if item:isTouched(x, y) then
			return item
		end
	end
	return nil
end


return CustomLabelMenu