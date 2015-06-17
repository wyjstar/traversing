
local ActionEditorCell = import(".ActionEditorCell")

local ActionEditorView = class("ActionEditorView", function() 
    return cc.ScrollView:create()
end)

function ActionEditorView:ctor(size)
    self.cells = {}

    self:setViewSize(size)
    self:setContentSize({width = size.width, height = 8000})
    
    self.layer = cc.LayerColor:create(cc.c4b(100, 100, 0, 200))
    self.layer:setContentSize(self:getContentSize())
    self:setContainer(self.layer)

    self:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self:setBounceable(false)
    self:setContentOffset({x = 0, y = self:getViewSize().height - self:getContentSize().height})
end

function ActionEditorView:resetAllCells(data)
    self:setContentOffset({x = 0, y = self:getViewSize().height - self:getContentSize().height})

    for k, v in ipairs(data) do
        local cell = self.cells[k]
        if not cell then 
            cell = ActionEditorCell.new()
            self.cells[k] = cell
            self.layer:addChild(cell)
        end

        cell:setPosition(5, self:getContentSize().height - (cell:getContentSize().height + 10) * k)
        cell:setVisible(true)
        cell:resetAllData(k, v)
    end

    for k = #data + 1, #self.cells do
        self.cells[k]:setVisible(false)
    end
end

function ActionEditorView:resolveToData()
    local datas = {}

    for k, v in ipairs(self.cells) do
        if v:isVisible() then
            datas[#datas + 1] = v:resolveToData()
        end
    end

    return datas
end

return ActionEditorView
