
local ActionEditorList = class("ActionEditorList", function() 
    return cc.ScrollView:create()
end)

function ActionEditorList:ctor(rect)
    self.items = {}

    self:setViewSize(rect)
    self:setContentSize({width = rect.width, height = 20000})
    
    local layer = cc.LayerColor:create(cc.c4b(100, 100, 0, 200))
    layer:setContentSize(self:getContentSize())
    self:setContainer(layer)

    self:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self:setBounceable(false)
    self:setContentOffset({x = 0, y = rect.height - self:getContentSize().height})
    
    self.menu = ui.newMenu({})
    self.menu:setPosition(rect.width/2, 10)

    layer:addChild(self.menu)
end

function ActionEditorList:resetAllItems(data)
    self.items = {}
    self.menu:removeAllChildren();

    local keys = table.keys(data)
    table.sort(keys)

    for i, k in pairs(keys) do
        local idx = #self.items + 1
        local label = ui.newTTFLabelMenuItem({text = k, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, listener = function() self:onChickList(k, idx) end})
        label:setPosition(0, self:getContentSize().height - 10 - 20 * (idx))
        
        self.items[idx] = label
        self.menu:addChild(label)
    end
end

function ActionEditorList:addItem(no)
    local idx = #self.items + 1

    local label = ui.newTTFLabelMenuItem({text = no, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, listener = function() self:onChickList(no, idx) end})
    label:setPosition(0, self:getContentSize().height - 10 - 20 * (idx))
        
    self.items[idx] = label
    self.menu:addChild(label)

    self:onChickList(no, idx)
end

function ActionEditorList:onChickList(no, idx)
    self:getParent():onChickList(no, idx)
end

return ActionEditorList
