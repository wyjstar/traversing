--@module CustomScrollView
--[[--
-- 功能：自定义滚动控件
-- 作者：肖寒
-- 日期：2015-06-11
]]
local CustomScrollView = class("CustomScrollView", function()
    return game.newNode()
end)

CustomScrollView.DIRECTION_HORIZONTAL = 0
CustomScrollView.DIRECTION_VERTICAL   = 1


CustomScrollView.ALIGN_CENTER = 1
CustomScrollView.ALIGN_LEFT = 2
CustomScrollView.ALIGN_RIGHT = 3

CustomScrollView.SCROLL_NONE        = 0 --不需要移动
CustomScrollView.SCROLL_TO_LEFT     = 1 --已经移动到最左端
CustomScrollView.SCROLL_TO_RIGHT    = 2 --已经移动到最右端
CustomScrollView.SCROLL_TO_TOP      = 3 --已经移动到最上端
CustomScrollView.SCROLL_TO_BOTTOM   = 4 --已经移动到最下端
CustomScrollView.SCROLL_TO_NORMAL   = 5 --正常移动
CustomScrollView.SCROLL_BAR_MIN_LENGTH = 60 --滚动条最小长度
--[[--
构造方法
@params node scrollRect 滚动区域
@params table opt       设置参数
]]
function CustomScrollView:ctor(scrollRect,opt)
    opt	= checktable(opt)
    self.leftArrow_ = opt.leftArrow--左提示箭头
    self.rightArrow_ = opt.rightArrow--右提示剪头
    self.align_ = opt.align or CustomScrollView.ALIGN_LEFT
    self.offsetx_ = opt.offsetx or 0
    self.offsety_ = opt.offsety or 0
    self.isShowTipArrow = (self.leftArrow_ ~= nil and self.rightArrow_ ~= nil)
    self.touchSize = scrollRect:getContentSize()
    self.columns = opt.columns or 4
    self.lines = opt.lines or 4
    self.direction = opt.direction or CustomScrollView.DIRECTION_VERTICAL
    self.columnspace= opt.columnspace or 7
    self.linespace = opt.linespace or 10
    self.dragThreshold = 40
    if opt.swallowable == nil then
        self.swallowable = true
    else
        self.swallowable = opt.swallowable
    end
    self.showScroll = opt.showScroll or (self.direction == CustomScrollView.DIRECTION_VERTICAL)
    self.buttons = {}
    --滚动层
    self.scrollView = cc.CustomScrollView:create()
    self.scrollView:setVisible(false)
    self.scrollView:setViewSize(self.touchSize)
    self.scrollView:ignoreAnchorPointForPosition(true)
    self.scrollView:setDirection(self.direction)
    self.scrollView:setClippingToBounds(true)
    self.scrollView:setBounceable(true)
    -- self.scrollView:setDelegate()
    self:addChild(self.scrollView)  
    self.scrollView:registerDidScrollHandler(handler(self,self.resetArrowTip))    
    --handler,是否支持多点触摸，优先级，是否吞噬触摸事件
    scrollRect:registerScriptTouchHandler(handler(self, self.onTouch),false,0,self.swallowable)
    scrollRect:setTouchEnabled(true)
    self.enabled_ = true
    --添加滚动条
    if self.showScroll then
        -- self.scrollBg = cc.Scale9Sprite:create("res/ui/vr_slider_bg.png")
        -- self.scrollBg:setContentSize(cc.size(self.scrollBg:getContentSize().width, self.touchSize.height))
        -- self.scrollBg:setAnchorPoint(cc.p(1, 0))
        -- self.scrollBg:setPosition(self.touchSize.width, 0)
        -- self.scrollBg:setVisible(false)        
        -- self:addChild(self.scrollBg)

        self.scrollBar = cc.Scale9Sprite:create("res/ui/vr_slider.png")
        self.scrollBar:setAnchorPoint(cc.p(0.5,1))
        self.scrollBar:setPosition(self.touchSize.width, self.touchSize.height)
        self.scrollBar:setVisible(false)
        self:addChild(self.scrollBar)

        CustomScrollView.SCROLL_BAR_MIN_LENGTH = self.scrollBar:getContentSize().height
    end

    local function onNodeEvent(event)
        if "enter" == event then
            self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)           
        end
    end
    self:registerScriptHandler(onNodeEvent)  
    scrollRect:addChild(self)    
end
--[[--
逐帧更新
@params float dt 时间差
]]
function CustomScrollView:update(dt)
    self:updateScrollBarPosition_()  
end
--[[--
更新滚动条位置
]]
function CustomScrollView:updateScrollBarPosition_()
    if self.showScroll and self.updateScrollBar then      
        if self.direction == CustomScrollView.DIRECTION_VERTICAL then
            local distance = self.maxScrollHeight - math.abs(self.scrollView:getContentOffset().y)
            distance = distance*self.touchSize.height/self.maxScrollHeight
            local y = math.floor(self.touchSize.height - distance)
            if y < self.scrollBar:getContentSize().height then y = self.scrollBar:getContentSize().height end
            if y > self.touchSize.height then y = self.touchSize.height end

            if math.abs(self.scrollBar:getPositionY() - y) < 0.001 then
                self.scrollBar:setOpacity(self.scrollBar:getOpacity()*0.98)
            else
                self.scrollBar:setPositionY(y)
                self.scrollBar:setOpacity(255)
            end            
        end
    end    
end
--[[--
是否可用
@params boolean enabled
]]
function CustomScrollView:setEnabled(enabled)
    self.enabled_ = enabled
end
--[[--
获取内容大小
]]
function CustomScrollView:getContentSize()
    return self.scrollView:getContentSize()
end
--[[--
获取内容偏移位置
]]
function CustomScrollView:getContentOffset()
    return self.scrollView:getContentOffset()
end
--[[--
设置是否回弹
@params boolean bounceable
]]
function CustomScrollView:setBounceable(bounceable)
    return self.scrollView:setBounceable(bounceable)
end
--[[--
获取显示大小
]]
function CustomScrollView:getViewSize()
    return self.touchSize
end
--[[--
设置代理
]]
function CustomScrollView:setDelegate(delegate)
    self.delegate_ = delegate
end
--[[--
点击事件回调
@params string event 事件名
@params int    x     x坐标
@params int    y     y坐标
]]
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
--[[--
点击开始
@params int x x坐标
@params int y y坐标

]]
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
--[[--
点击结束
@params int x x坐标
@params int y y坐标

]]
function CustomScrollView:onTouchEnded(x, y)
    if self.drag then
    	if self.drag.isTap then
            self:onTouchEndedWithTap(x, y)
    	else
            self:onTouchEndedWithoutTap(x, y)
    	end
        self.drag = {}
    end
end
--[[--
点中按钮结束
@params int x x坐标
@params int y y坐标

]]
function CustomScrollView:onTouchEndedWithTap(x, y)
    local button = self:checkButton(x, y)
    if button then
        if self.delegate_ and self.delegate_.onClickScrollViewCell ~= nil then
            getAudioManager():playEffectButton2()
            self.delegate_:onClickScrollViewCell(button)
        end
    end
end
--[[--
重置箭头提示
]]
function CustomScrollView:resetArrowTip()
    if self.scrollView ~= nil and self.isShowTipArrow then
        local contentSize = self.scrollView:getContentSize()
        local offset = self.scrollView:getContentOffset()
        if self.direction == CustomScrollView.DIRECTION_HORIZONTAL then
            if contentSize.width <= self.touchSize.width then
                self.leftArrow_:setVisible(false)
                self.rightArrow_:setVisible(false)
            else
                if offset.x == 0 then
                    self.leftArrow_:setVisible(false)
                    self.rightArrow_:setVisible(true)
                elseif offset.x <= self.touchSize.width - contentSize.width then
                    self.leftArrow_:setVisible(true)
                    self.rightArrow_:setVisible(false)
                else
                    self.leftArrow_:setVisible(true)
                    self.rightArrow_:setVisible(true)
                end
            end
        else
            if contentSize.height <= self.touchSize.height then
                self.leftArrow_:setVisible(false)
                self.rightArrow_:setVisible(false)
            else
                if offset.y == 0 then
                    self.leftArrow_:setVisible(false)
                    self.rightArrow_:setVisible(true)
                elseif offset.y <= self.touchSize.height - contentSize.height then
                    self.leftArrow_:setVisible(true)
                    self.rightArrow_:setVisible(false)
                else
                    self.leftArrow_:setVisible(true)
                    self.rightArrow_:setVisible(true)
                end
            end
        end
    end
end
--[[--
移动一个Cell的大小
@params table direction:{x,y},代表着向x,y方向移动,x是左是正 右为负，上为负，下为正,
]]
function CustomScrollView:scrollCellSize(direction)
    if #self.buttons > 0 then
        local tmpSize = self.buttons[1]:getContentSize()
        local cellSize = cc.size(tmpSize.width * self.buttons[1]:getScaleX() * direction.x, tmpSize.height * self.buttons[1]:getScaleY() * direction.y)

        local movePosition = {x = cellSize.width,y = cellSize.height}

        movePosition = cc.pAdd(movePosition,{x = self.columnspace * direction.x,y = self.columnspace * direction.y})

        local p = cc.pAdd(self.scrollView:getContentOffset(),movePosition)
        print("after Add:==========>")
        table.print(p)

        p = self:checkContentOffsetPosition(p)

        self.scrollView:setContentOffset(p,true)
    end
end

--[[--
验证需要设置的ContentOffset是否越界
]]
function CustomScrollView:checkContentOffsetPosition(pos)
    local contentSize = self.scrollView:getContentSize()
    if pos.x > 0 then
        pos.x = 0
    end
    if pos.x < 0 and pos.x < self.touchSize.width - contentSize.width then
        pos.x = self.touchSize.width - contentSize.width
    end

    if pos.y > 0 then
        pos.y = 0
    end
    if pos.y < 0 and pos.y < self.touchSize.height - contentSize.height then
        pos.y = self.touchSize.height - contentSize.height
    end
    return pos
end
--[[--
滑动结束结束
]]
function CustomScrollView:onTouchEndedWithoutTap(x, y)
    print("***********")
end
--[[--
点击取消
]]
function CustomScrollView:onTouchCancelled(x, y)
    print("%%%%%%%%%%")
end
--[[--
滑动
@params int x x坐标
@params int y y坐标
]]
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
--[[--
单选一个cell,设置选中状态
@params userdata cell cell单元
]]
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
--[[--
添加一个cell
]]
function CustomScrollView:addCell(btn)
    self.buttons[#self.buttons + 1] = btn
    btn.index_ = #self.buttons
    btn:setAnchorPoint(cc.p(0, 1))
    btn:ignoreAnchorPointForPosition(false)      
	self.scrollView:addChild(btn)
end
--[[--
插入一个cell
@params node btn cell单元
@params int  pos 位置，默认为1
]]
function CustomScrollView:insertCell(btn, pos)
    pos = pos or 1
    table.insert(self.buttons, pos, btn)
    for i = 1, #self.buttons do
        self.buttons[i].index_ = i
    end
    btn:setAnchorPoint(cc.p(0, 1))
    btn:ignoreAnchorPointForPosition(false)      
    self.scrollView:addChild(btn)    
end
--[[--
重置cell位置，重置指示箭头状态
]]
function CustomScrollView:reloadData()
    self:reorderAllBtns()
    self:resetArrowTip()
    self.scrollView:setVisible(true)        
end
--[[--
根据索引获取cell
]]
function CustomScrollView:getCell(index)
    return self.buttons[index]
end
--[[--
清除cell
]]
function CustomScrollView:clear()
    self.scrollView:getContainer():removeAllChildren()
    self.buttons = {}
end
--[[--
当前节点退出，已作废
]]
function CustomScrollView:exit()
    -- self:clear()
    -- self.scrollView = nil
end
--[[--
更新内容大小
]]
function CustomScrollView:updateContentSize()
    local count = #self.buttons
    self.offsetWidth = 0 --x坐标偏移量
    self.offsetHeight = 0--y坐标偏移量
    self.ratio = 1
    local width, height, lineHeight, lineWidth,contentWidth,contentHeight = 0, 0, 0, 0, 0, 0
    if count ~= 0 then
        if self.direction == CustomScrollView.DIRECTION_VERTICAL then
            width = self.touchSize.width
            height = 0
            for i = 1, count do
                local cellSize = cc.size(self.buttons[i]:getContentSize().width * self.buttons[i]:getScale(), self.buttons[i]:getContentSize().height * self.buttons[i]:getScale())
                contentWidth = contentWidth + cellSize.width + self.columnspace
                lineHeight = math.max(lineHeight, cellSize.height + self.linespace)
                if i%self.columns == 0 then
                    lineWidth = math.max(lineWidth, contentWidth)
                    contentWidth = 0
                end
            end
            local rows = math.ceil(count/self.columns)
            height = rows*lineHeight
            lineWidth = math.max(lineWidth, contentWidth) - self.columnspace
            if rows > 1 then
                self.offsetWidth = math.floor((width - lineWidth)/2)            
            else
                self.offsetWidth = self.offsetx_
            end           
            if height <= self.touchSize.height then
                self.scrollView:setTouchEnabled(false)
            else
                self.scrollView:setTouchEnabled(true)            
            end
            self.ratio = self.touchSize.height/height       
        else
            width = 0
            height = self.touchSize.height
            --计算总列数
            local columns = math.ceil(count/self.lines)
            --取第一个cell大小
            local cellSize = cc.size(self.buttons[1]:getContentSize().width * self.buttons[1]:getScale(), self.buttons[1]:getContentSize().height * self.buttons[1]:getScale())
            --(一个cell宽+列间隙)*总列数 - 一个列间隙算出内容总宽度
            width= (cellSize.width + self.columnspace)*columns - self.columnspace
            --(一个cell高+行间隙)*min(行数，数量) - 一个行间隙
            lineHeight = (cellSize.height + self.linespace)*math.min(self.lines, count) - self.linespace
            if self.offsety_ == 0 then
                self.offsetHeight = math.floor((height - lineHeight)/2)            
            else
                self.offsetHeight = self.offsety_
            end
            if width <= self.touchSize.width then
                --左对齐
                if self.align_ == CustomScrollView.ALIGN_LEFT then
                    self.offsetWidth = self.offsetx_
                else
                    self.offsetWidth = math.floor((self.touchSize.width-width)/2)                
                end
                self.scrollView:setTouchEnabled(false)
            else
                self.offsetWidth = self.offsetx_            
                self.scrollView:setTouchEnabled(true)             
            end
            self.ratio = self.touchSize.width/width              
        end        
    end
    self.scrollView:setContentSize(cc.size(width, height))
    self:updateScrollBarSize()    
end
--[[--
更新滚动条大小
]]
function CustomScrollView:updateScrollBarSize()
    if self.showScroll then
        if self.ratio >= 1 then
            self.scrollBar:setVisible(false)
            -- self.scrollBg:setVisible(false)            
            self.updateScrollBar = false
            return
        end
        if self.direction == CustomScrollView.DIRECTION_VERTICAL then
            self.maxScrollHeight = self.scrollView:getContentSize().height - self.touchSize.height
            self.updateScrollBar = true        
            self.scrollBar:setVisible(true)
            -- self.scrollBg:setVisible(true)          
            local scrollViewSize = self.scrollView:getContentSize()
            local height = math.floor(self.ratio*self.touchSize.height)
            if height < CustomScrollView.SCROLL_BAR_MIN_LENGTH then
                height = CustomScrollView.SCROLL_BAR_MIN_LENGTH
            end
            self.scrollBar:setContentSize(cc.size(self.scrollBar:getContentSize().width, height))             
        end
    end
end
--[[--
更新cell的坐标
]]
function CustomScrollView:updateCellPositions()
    local count = #self.buttons
    if count == 0 then return end    
    local x, y, lineHeight = 0, 0, 0
    if self.direction == CustomScrollView.DIRECTION_VERTICAL then
        x = self.offsetWidth
        y = self.scrollView:getContentSize().height
        for i = 1, count do            
            self.buttons[i]:setPosition(x, y)
            lineHeight = math.max(lineHeight, self.buttons[i]:getContentSize().height * self.buttons[i]:getScale() + self.linespace)
            x = x + self.buttons[i]:getContentSize().width * self.buttons[i]:getScale() + self.columnspace             
            if i%self.columns == 0 then
                y = y - lineHeight
                x = self.offsetWidth
            end
        end
    else
        x = self.offsetWidth
        y = self.scrollView:getContentSize().height - self.offsetHeight
        for i = 1, count do               
            self.buttons[i]:setPosition(x, y)           
            if self.lines > 1 and (i + 1)%self.lines == 0 then
                x = self.buttons[i]:getPositionX()
                y = y - self.buttons[i]:getContentSize().height * self.buttons[i]:getScale() - self.linespace
            else
                x = x + self.buttons[i]:getContentSize().width * self.buttons[i]:getScale() + self.columnspace                
                y = self.scrollView:getContentSize().height - self.offsetHeight             
            end
        end
    end
end
--[[--
重置cell位置
]]
function CustomScrollView:reorderAllBtns()
    self:updateContentSize()
    self:updateCellPositions()
    if self.direction == CustomScrollView.DIRECTION_VERTICAL then
        self.scrollView:setContentOffset(cc.p(0, self.touchSize.height - self.scrollView:getContentSize().height))
    else
        self.scrollView:setContentOffset(cc.p(0, 0))
    end
end
--[[--
检查是否点中按钮
@params int x x坐标
@params int y y坐标
]]
function CustomScrollView:checkButton(x, y)
    local pos = cc.p(x, y)
    for i = 1, #self.buttons do
        local button = self.buttons[i]
        if button.isTouched and button:isTouched(x, y) then
            return button
        end
    end
    return nil
end
--[[--
获取所有的cell
]]
function CustomScrollView:getAllButtons()
    return self.buttons
end
--[[--
删除一个cell
]]
function CustomScrollView:delButtonByIdx(idx)
    if idx and idx >= 1 and idx <= table.nums(self.buttons) then
        self.buttons[idx]:removeFromParent()
        table.remove(self.buttons, idx)
    end
end
--[[
跳转到顶部
]]
function CustomScrollView:jumpToTop()
    if self.scrollView then
        self.scrollView:setContentOffset(self.scrollView:minContainerOffset())
    end
end
--[[
跳转到底部
]]
function CustomScrollView:jumpToBottom()
    if self.scrollView then
        self.scrollView:setContentOffset(self.scrollView:maxContainerOffset())
    end
end

--[[--
滑动动画
@param table opt 参数设置
{
    ["delayTime"],  -- 初始延时
    ["delayRow"],   -- 行间延时
    ["delayLine"],  -- 列间延时
    ["boundWidth"], -- 回弹距离
    ["delayBound"], -- 回弹延时
    ["itemWidth"],  -- 初始的位置
}
]]
function CustomScrollView:runItemAction(opt)
    opt = opt or {}
    local dTime     = opt.delayTime or 0.05
    local dRow      = opt.delayRow or 0.09
    local dLine     = opt.delayLine or 0.07
    local bWidth    = opt.boundWidth or 10
    local dBound    = opt.delayBound or 0.05
    local iWidth    = opt.itemWidth or self.touchSize.width

    for k,v in pairs(self.buttons) do
        v:setPositionX(v:getPositionX() + iWidth)
    end

    local size = self.direction == CustomScrollView.DIRECTION_VERTICAL and self.columns or self.lines -- 竖向使用columns, 横向使用lines
    for k,v in pairs(self.buttons) do
        local rowNum = tonumber(string.format("%d", (k-1)/size)) -- 行号,从0开始
        local lineNum = (k-1) % size -- 列号,从0开始
        local que = cc.Sequence:create(
            cc.MoveBy:create(dTime + rowNum*dRow + lineNum*dLine, cc.p(-iWidth-bWidth, 0)),
            cc.MoveBy:create(dBound, cc.p(bWidth, 0))
        )
        v:runAction(que)
    end
end

return CustomScrollView
