local CustomScrollView = class("CustomScrollView")

CustomScrollView.DIRECTION_HORIZONTAL = 0
CustomScrollView.DIRECTION_VERTICAL   = 1


CustomScrollView.ALIGN_CENTER = 1
CustomScrollView.ALIGN_LEFT = 2

function CustomScrollView:ctor(scrollRect,opt)
    opt	= checktable(opt)
    self.touchSize = scrollRect:getContentSize()
    self.columns = opt.columns or 4
    self.direction = opt.direction or CustomScrollView.DIRECTION_VERTICAL
    self.columnspace= opt.columnspace or 7
    self.linespace = opt.linespace or 10
    self.dragThreshold = 40
    self.buttons = {}

    self.scrollView = cc.ScrollView:create()
    self.scrollView:setViewSize(self.touchSize)
    self.scrollView:ignoreAnchorPointForPosition(true)
    self.scrollView:setDirection(opt.direction or CustomScrollView.DIRECTION_VERTICAL)
    self.scrollView:setClippingToBounds(true)
    self.scrollView:setBounceable(true)
    self.scrollView:setDelegate()    
    scrollRect:addChild(self.scrollView)
    scrollRect:registerScriptTouchHandler(handler(self, self.onTouch))
    scrollRect:setTouchEnabled(true)
    self.enabled_ = true
end

function CustomScrollView:setEnabled(enabled)
    self.enabled_ = enabled
end

function CustomScrollView:getContentSize()
    return self.scrollView:getContentSize()
end

function CustomScrollView:getViewSize()
    return self.touchSize
end

function CustomScrollView:setDelegate(delegate)
    self.delegate_ = delegate
end

function CustomScrollView:onTouch(event, x, y)
    if not self.enabled_ then return false end
    if event == "began" then
        return self:onTouchBegan(x, y)
    elseif event == "moved" then
        self:onTouchMoved(x, y)
    elseif event == "ended" then
        self:onTouchEnded(x, y)
    else -- cancelled
        self:onTouchCancelled(x, y)
    end	
end

function CustomScrollView:onTouchBegan(x, y)
    local _point = self.scrollView:convertToNodeSpace(cc.p(x,y))
    if cc.rectContainsPoint(self.scrollView:getBoundingBox(), _point) then
        self.drag = {  
            startX = x,
            startY = y,
            isTap = true,
        }
        --可调用按钮点击开始方法
        return true        
    else
        return false
    end
end

function CustomScrollView:onTouchEnded(x, y)
	if self.drag.isTap then
        self:onTouchEndedWithTap(x, y)
	else
        self:onTouchEndedWithoutTap(x, y)		
	end
    self.drag = nil	
end

function CustomScrollView:onTouchEndedWithTap(x, y)
    local button = self:checkButton(x, y)
    if button then
        if self.delegate_ then
            self.delegate_:onClickScrollViewCell(button)
        end
    end	
end

function CustomScrollView:onTouchEndedWithoutTap(x, y)
    print("***********")    
end

function CustomScrollView:onTouchCancelled(x, y)
    print("%%%%%%%%%%")
end

function CustomScrollView:onTouchMoved(x, y)
    if self.direction == CustomScrollView.DIRECTION_HORIZONTAL then
        if self.drag.isTap and math.abs(x - self.drag.startX) >= self.dragThreshold then
            self.drag.isTap = false
        end        
    else
        if self.drag.isTap and math.abs(y - self.drag.startY) >= self.dragThreshold then
            self.drag.isTap = false
        end
    end
end

function CustomScrollView:singalSelectedCell(cell)
    for i = 1, #self.buttons do
        local button = self.buttons[i]
        if button:isEqual(cell) then
            button:setSelected(true)
        else
            button:setSelected(false)
        end
    end    
end

function CustomScrollView:addCell(btn)
    self.buttons[#self.buttons + 1] = btn
    btn.index_ = #self.buttons
	self.scrollView:addChild(btn)
	self:reorderAllBtns()    
end

function CustomScrollView:clear()
    self.scrollView:getContainer():removeAllChildren()
    self.buttons = {}
end

function CustomScrollView:reorderAllBtns()
    local count = #self.buttons
    --一个cell的大小
    local cellSize =  self.buttons[1]:getContentSize()
    local startX, totalRow, contentWidth, contentHeight, currentColumn = 0, 0, 0, 0, 0
    if self.direction == CustomScrollView.DIRECTION_HORIZONTAL then
        contentWidth = count*(cellSize.width + self.columnspace)
        contentHeight = self.touchSize.height
        startX = 0
        y = (contentHeight + cellSize.height)*0.5
    else
        totalRow = math.ceil(count/self.columns)
        startX = (self.touchSize.width - (cellSize.width + self.columnspace)*self.columns)*0.5
        contentWidth = self.touchSize.width
        contentHeight = totalRow*(cellSize.height + self.linespace)
        y = contentHeight
    end

    local x = startX
    for i = 1, count do
        local btn = self.buttons[i]
        btn:setAnchorPoint(cc.p(0, 1))
        btn:ignoreAnchorPointForPosition(false)        
        btn:setPosition(x, y)
        if self.direction == CustomScrollView.DIRECTION_HORIZONTAL then
            x = x + cellSize.width + self.columnspace
        else
            x = x + cellSize.width + self.columnspace
            currentColumn = currentColumn + 1
            if currentColumn == self.columns then
                x = startX
                y = y - cellSize.height - self.linespace
                currentColumn = 0
            end            
        end
    end
    self.scrollView:setContentSize(cc.size(contentWidth, contentHeight))
    if self.direction == CustomScrollView.DIRECTION_VERTICAL then    
        self.scrollView:setContentOffset(cc.p(0, self.touchSize.height - contentHeight))
    else
        self.scrollView:setContentOffset(cc.p(0, 0))
    end
end

function CustomScrollView:checkButton(x, y)
    local pos = cc.p(x, y)
    for i = 1, #self.buttons do
        local button = self.buttons[i]
        if button:isTouched(x, y) then
            return button
        end
    end
    return nil
end

return CustomScrollView