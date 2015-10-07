local CustomListViewItem = class("CustomListViewItem", function()
	return game.newNode()
end)

function CustomListViewItem:ctor()
    self.idx_ = -1
    self.container_ = nil
    self.beforeSize_ = nil
end

function CustomListViewItem:setContainer(container)
    self.container_ = container
end

function CustomListViewItem:onTouch()
    if self.item_ then
        self.beforeSize_ = self:getContentSize()
        self:setContentSize(self.item_:getContentSize())       
    end

    if self.container_ then
        self.container_:onTouch(self.idx_, self)               
    end
end

function CustomListViewItem:getBeforeSize()
    return self.beforeSize_
end

function CustomListViewItem:onClose()
    if self.item_ then
        self.item_:onClose()
        self:setContentSize(self.item_:getContentSize())                
    end
end

function CustomListViewItem:setItem(item)
    self.item_ = item
    self:addChild(item)
    item:setContainer(self)
    self:setContentSize(item:getContentSize())   
end

function CustomListViewItem:getItem()
    return self.item_
end

function CustomListViewItem:removeItem()
    if self.item_ then
        self.item_:removeFromParentAndCleanup(true)
        self.item_ = nil        
    end
end

function CustomListViewItem:getIdx()
	return self.idx_
end

function CustomListViewItem:setIdx(idx)
	self.idx_ = idx
end

function CustomListViewItem:reset()
    self.idx_ = -1
    self.container_ = nil
    self.beforeSize_ = nil
    self.item_ = nil           
end

return CustomListViewItem