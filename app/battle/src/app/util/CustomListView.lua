local CustomListView = class("CustomListView", function()
	return game.newNode()
end)


CustomListView.DIRECTION_HORIZONTAL = 0
CustomListView.DIRECTION_VERTICAL   = 1

CustomListView.TOP_DOWN = 1
CustomListView.BOTTOM_UP = 2

function CustomListView:ctor(rect, opt)
	opt = opt or {}
	self.cellsUsed_ = {}
	self.cellsFreed_ = {}
	self.cellsPositions_ = {}
	self.indices_ = {}
	self.isUsedCellsDirty_ = false
	self.lineSpace_ = opt.lineSpace or 10
	self.columnSpace_ = opt.columnSpace or 10
	self.direction_ = opt.direction or CustomListView.DIRECTION_VERTICAL
	self.vordering_ = CustomListView.TOP_DOWN
	self.viewSize_ = rect:getContentSize()
    self.scrollView = cc.ScrollView:create()
    self.scrollView:setViewSize(self.viewSize_)
    self.scrollView:ignoreAnchorPointForPosition(true)    
    self.scrollView:setDirection(self.direction_)
    self.scrollView:setClippingToBounds(true)
    self.scrollView:setBounceable(true)
    self.scrollView:setDelegate()
    self:addChild(self.scrollView)
	rect:addChild(self)
end

function CustomListView:setDelegate(delegate)
	self.delegate_ = delegate
end

function CustomListView:scrollToTop()
	self.scrollView:setContentOffset(cc.p(0, self.viewSize_.height - self.scrollView:getContentSize().height))
end

function CustomListView:reloadData()
    for k, v in pairs(self.cellsUsed_) do
		if self.delegate_ and self.delegate_.listCellWillRecycle then
			self.delegate_:listCellWillRecycle(self, v)
		end
		v:reset()
		if v:getParent() == self.scrollView:getContainer() then
			print("=========================>remove cell", v:getIdx())
			v:removeFromParent()
			v = nil
		end
	end
	self.indices_ = {}
	self.cellsUsed_ = {}
	self.cellsFreed_ = {}
	self.cellsPositions_ = {}	
	self:updateCellPositions()
	self:updateContentSize()
	self:scrollViewDidScroll(self)
	self:scrollToTop()	
	self.curItem = nil  	-- 重置数据后将当前item置为空,防止野指针错误
end

function CustomListView:onTouch(idx, item)
	print("onClickItem===================>", idx)
	if self.curItem and self.curItem:getIdx() ~= idx then
		self.curItem:onClose()
		self.curItem = item
	elseif self.curItem and self.curItem:getIdx() == idx then
		self.curItem = nil
	else
		self.curItem = item				
	end
	--------------------------------------------------
	self:updateCellPositions()
	self:updateContentSize()
	local cellsCount = self.delegate_:numberOfCellsInListView()	
    local cell = nil
    for i = 1, cellsCount do
    	cell = self:cellAtIndex(i)
		cell:setPosition(self:_offsetFromIndex(i))    	
    end
    --------------------------------------------------
    local distance = item:getContentSize().height - item:getBeforeSize().height    
    local offset = self.scrollView:getContentOffset()
    local offsety = offset.y - distance
    local y = item:getPositionY() + offsety
    if y < 0 then
    	offsety = offsety - y
    end

    local min = self.viewSize_.height - self.scrollView:getContentSize().height

    if offsety > 0 and min < 0 then 
    	offsety = 0
    elseif math.abs(offsety) > math.abs(min) then
    	offsety = min
    end 
    self.scrollView:setContentOffset(cc.p(0, offsety))    
end

function CustomListView:updateCellPositions()
	local cellsCount = self.delegate_:numberOfCellsInListView()
	if cellsCount > 0 then
		local currentPos = 0
		local cellSize = nil
		for i = 1, cellsCount do
			self.cellsPositions_[i] = currentPos
			cellSize = self.delegate_:listCellSizeForIndex(self, i)
			if self.direction_ == CustomListView.DIRECTION_HORIZONTAL then
				currentPos = currentPos + cellSize.width + self.columnSpace_
			else
				currentPos = currentPos + cellSize.height + self.lineSpace_
			end
		end
	end
	print("=============updateCellPositions==========")
	table.print(self.cellsPositions_)
end

function CustomListView:updateContentSize()
    local size = cc.size(0,0)
	local cellsCount = self.delegate_:numberOfCellsInListView()
	if cellsCount > 0 then
		local cellSize = self.delegate_:listCellSizeForIndex(self, cellsCount)
		local maxPosition = self.cellsPositions_[cellsCount]
		if self.direction_ == CustomListView.DIRECTION_HORIZONTAL then
            size = cc.size(maxPosition + cellSize.width, self.viewSize_.height)
		else
            size = cc.size(self.viewSize_.width, maxPosition + cellSize.height)
		end
	end
	self.scrollView:setContentSize(size)
	print("=============updateContentSize==========")	
	table.print(size)		
end

function CustomListView:scrollViewDidScroll()
    local cellsCount = self.delegate_:numberOfCellsInListView()
    if cellsCount == 0 then return end

    if self.isUsedCellsDirty_ then
    	self.isUsedCellsDirty_ = false
    	table.sort(self.cellsUsed_, function(a, b)
    		return a:getIdx() < b:getIdx()
    	end)
    end

    if self.delegate_ and self.delegate_.scrollViewDidScroll then
    	self.delegate_:scrollViewDidScroll(self)
    end

    local startIdx, endIdx, idx = 0,0,0
    startIdx = 1
    endIdx = cellsCount
    --move used item to free
    -- if #self.cellsUsed_ > 0 then
    --     local cell = self.cellsUsed_[1]
    --     idx = cell:getIdx()
    --     while idx < startIdx do
    --         self:_moveCellOutOfSight(cell, 1)
    --         if #self.cellsUsed_ > 0 then
    --             cell = self.cellsUsed_[1]
    --             idx = cell:getIdx()
    --         else
    --             break
    --         end
    --     end
    -- end
    
    -- if #self.cellsUsed_ > 0 then
    --     local cell = self.cellsUsed_[#self.cellsUsed_]
    --     idx = cell:getIdx()
    --     while idx <= cellsCount and idx > endIdx do
    --         self:_moveCellOutOfSight(cell, #self.cellsUsed_)
    --         if #self.cellsUsed_ > 0 then
    --             cell = self.cellsUsed_[#self.cellsUsed_]
    --             idx = cell:getIdx()
    --         else
    --             break
    --         end
    --     end
    -- end
    
    for i = startIdx, endIdx do
    	if not table.find(self.indices_) then
        	self:updateCellAtIndex(i)    		
    	end
    end
end

function CustomListView:updateCellAtIndex(idx)
	if idx == -1 then return end
	local cellsCount = self.delegate_:numberOfCellsInListView()
	if cellsCount == 0 or idx > cellsCount then return end
	local cell = self:cellAtIndex(idx)
	if cell then
		self:_moveCellOutOfSight(cell)
	end
	cell = self.delegate_:listCellAtIndex(self, idx)
	self:_setIndexForCell(idx, cell)
	self:_addCellIfNecessary(cell)
end

function CustomListView:_addCellIfNecessary(cell)
	if cell:getParent() ~= self.scrollView:getContainer() then
		self.scrollView:addChild(cell)
		cell:setContainer(self)
	end
	table.insert(self.cellsUsed_, cell)
	table.insert(self.indices_, cell:getIdx())
	self.isUsedCellsDirty_ = true		
end

function CustomListView:_setIndexForCell(idx, cell)
	cell:setAnchorPoint(cc.p(0,0))
	cell:ignoreAnchorPointForPosition(false)
	cell:setPosition(self:_offsetFromIndex(idx))
	cell:setIdx(idx)
end

function CustomListView:_offsetFromIndex(index)
	local offset = self:__offsetFromIndex(index)
	local size = self.delegate_:listCellSizeForIndex(self, index)
	if CustomListView.TOP_DOWN == self.vordering_ then
		offset.y = self.scrollView:getContainer():getContentSize().height - offset.y - size.height
	end
	return offset
end

function CustomListView:__offsetFromIndex(index)
	local pos = self.cellsPositions_[index]
	if self.direction_ == CustomListView.DIRECTION_HORIZONTAL then
		return cc.p(pos, 0)
	else
		return cc.p(0, pos)
	end
end

function CustomListView:_moveCellOutOfSight(cell)
	if self.delegate_ and self.delegate_.listCellWillRecycle then
		self.delegate_:listCellWillRecycle(self, cell)
	end	
	table.insert(self.cellsFreed_,cell)
	for i =1, #self.cellsUsed_ do
		if self.cellsUsed_[i]:getIdx() == cell:getIdx() then
			table.remove(self.cellsUsed_, i)
			break
		end
	end
	self.isUsedCellsDirty_ = true
	table.removebyvalue(self.indices_, cell:getIdx())
	cell:reset()
	if cell:getParent() == self.scrollView:getContainer() then
		cell:removeFromParent()
	end
end

function CustomListView:_moveCellAtIndex(idx)
	local cell = self:cellAtIndex(idx)
	self:_moveCellOutOfSight(cell)
end

function CustomListView:dequeueCell()
    return table.remove(self.cellsFreed_)
end

function CustomListView:cellAtIndex(idx)
	if table.find(self.indices_, idx) then
		for _, v in pairs(self.cellsUsed_) do
			if v:getIdx() == idx then
				return v
			end
		end		
	end
	return nil
end


return CustomListView