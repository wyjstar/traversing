--[[--
矩阵表
]]
local CustomMatrixTableView = class("CustomMatrixTableView", function()
    return game.newNode()
end)

CustomMatrixTableView.DIRECTION_HORIZONTAL = 0
CustomMatrixTableView.DIRECTION_VERTICAL   = 1

function CustomMatrixTableView:ctor(opt)
    EventProtocol.extend(self)
    opt	= checktable(opt)
    self._direct = opt.direct or CustomMatrixTableView.DIRECTION_VERTICAL
    self._viewSize = opt.viewSize or cc.size(0,0)
    self._lines = opt.lines or 1
    self._columns = opt.columns or 1
    self._columnSpace = opt.columnSpace or 2
    self._lineSpace = opt.lineSpace or 2
    self._offsetx = opt.offsetx or 0
    self._getCellNumber = opt.getCellNumberFunc
    self._getCellSizeFunc = opt.getCellSizeFunc
    self._loadCellDataFunc = opt.loadCellDataFunc
    self._onClickCellFunc = opt.onClickCellFunc
    self._tableView = nil
end

function CustomMatrixTableView:reloadData()
	
	self._totalCount = self:getCellNumber() or 0
	--修正行和列
	if self._direct == CustomMatrixTableView.DIRECTION_VERTICAL then
		self._lines = math.ceil(self._totalCount/self._columns)
	else
		self._columns = math.ceil(self._totalCount/self._lines)
	end
	--
	if not self._tableView then
	    self._tableView = cc.TableView:create(self._viewSize)
	    self._tableView:setDirection(self._direct)
	    self._tableView:setDelegate()
	    if self._direct == CustomMatrixTableView.DIRECTION_VERTICAL then
	    	self._tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)	    	
	    end
	    self:addChild(self._tableView)
	    self._tableView:addBar()
	    self._tableView:registerScriptHandler(handler(self, self.cellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
	    self._tableView:registerScriptHandler(handler(self, self.cellSizeAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	    self._tableView:registerScriptHandler(handler(self, self.numberOfCells), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	end
	self._tableView:reloadData()	
end
--[[--
获取cell大小
]]
function CustomMatrixTableView:cellSizeForIndex(tbl, idx)
	local size = nil
	if self._direct == CustomMatrixTableView.DIRECTION_VERTICAL then
		size = self:getCellSize(idx*self._columns+1)
		return size.height, (size.width + self._columnSpace)*self._columns-self._columnSpace		
	else
		size = self:getCellSize(idx*self._lines+1)
		return (size.height + self._lineSpace)*self._lines-self._lineSpace, size.width
	end
	return size
end

--[[--
获取cell
]]
function CustomMatrixTableView:cellSizeAtIndex(tbl, idx)
	local cell = tbl:dequeueCell()
	if cell then
		local node = cell:getChildren()[1]
		local children = node:getChildren()
		for iidx, item in pairs(children) do
			local index = iidx + idx*self:getNumberOfCells()
			item:setVisible((index <= self._totalCount))
			if item:isVisible() then
				self:loadCellData(item, index)		
			end
		end
	else
		cell = cc.TableViewCell:new()
		local node = game.newLayer()
		local pos = nil
		local drag = false
	    --handler,是否支持多点触摸，优先级，是否吞噬触摸事件
	    node:registerScriptTouchHandler(function(event, x, y)
	    	if event == "began" then
	    		pos = cc.p(x, y)
	    		drag = false
	    		return true
	    	elseif event == "moved" then
	    		if math.abs(pos.x - x) > 5 or math.abs(pos.y - y) > 5 then
	    			drag = true
	    		end 
		    elseif event == "ended" then
		    	if not drag then
					local children = node:getChildren()
					for _, item in pairs(children) do
						if item:isVisible() and self._onClickCellFunc and self._onClickCellFunc(item, x, y) then
							break	
						end
					end			    		
		    	end	    	
		    end
	    end,false,0,false)
	    node:setTouchEnabled(true)		
		local height, width = self:cellSizeForIndex(tbl, idx)
		node:setContentSize(cc.size(width, height))
		if self._offsetx ~= 0 then
			node:setPosition(cc.p(self._offsetx, 0))
		end
		
		cell:addChild(node)
		--获取数量
		local count = 0
		if self._direct == CustomMatrixTableView.DIRECTION_VERTICAL then
			if (idx + 1) == self._lines then
				count= self._totalCount%self._columns
			else
				count= self._columns
			end
		else				
			if (idx + 1) == self._columns then
				count= self._totalCount%self._lines
			else
				count= self._lines
			end
		end
		local x, y = 0, 0
		--加载数据
		for i = 1, count do
			local index = i + idx*self:getNumberOfCells()
			local item = self:loadCellData(nil, index)
			--横向排列
			if self._direct == CustomMatrixTableView.DIRECTION_VERTICAL then
				x = (i - 1) * (item:getContentSize().width + self._columnSpace)
			else
				y = height - i * (item:getContentSize().height+ self._lineSpace)
			end
			item:setPosition(cc.p(x, y))
			item.index = index
			node:addChild(item)
		end		
	end
	return cell
end
--[[--
获取cell数量
]]
function CustomMatrixTableView:numberOfCells()
	if self._direct == CustomMatrixTableView.DIRECTION_VERTICAL then
		return self._lines
	else
		return self._columns
	end
end
--[[--
获取反向cell数量
]]
function CustomMatrixTableView:getNumberOfCells()
	if self._direct == CustomMatrixTableView.DIRECTION_VERTICAL then
		return self._columns
	else
		return self._lines
	end
end

function CustomMatrixTableView:getCellNumber()
	if self._getCellNumber then
		return self._getCellNumber()
	end
	return 0
end

function CustomMatrixTableView:getCellSize(idx)
	if self._getCellSizeFunc then
		return self._getCellSizeFunc(idx)
	end
	return cc.size(0,0)
end

function CustomMatrixTableView:loadCellData(item, idx)
	if self._loadCellDataFunc then
		return self._loadCellDataFunc(item, idx)
	end
end

return CustomMatrixTableView