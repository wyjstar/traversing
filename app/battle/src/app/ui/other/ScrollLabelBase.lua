
local ScrollLabelBase = class("ScrollLabelBase", function ()
    return cc.Node:create()
end)

function ScrollLabelBase:ctor(num)
    self.currentNum = num
    self:init(num)
end

function ScrollLabelBase:init(num)
    self.labelItem = self:createLabel(num)

    self:addChild(self.labelItem)

    self.labelBase:setPosition(0, -num * 55 - 22.5)
end

function ScrollLabelBase:createLabel()
    self.clipNode = cc.ClippingNode:create()
    self.labelBase = game.newNode()
    self.clipNode:addChild(self.labelBase)
    --local labelNode = self:createNode(0, 0)
    for i = 0, 9 do
        local label = cc.LabelAtlas:_create(harmOneStr, "res/ui/ui_f_d_atlas2.png", 34, 55, string.byte("/"))
        -- local label = cc.Label:create()
        self.labelBase:addChild(label)
        local height = label:getContentSize().height
        label:setPosition(0, i * 55 + 22.5)
        label:setString(tostring(i))
        -- label:setSystemFontSize(22)
    end

    self.clipNode:setInverted(false)
    local draw = cc.DrawNode:create()
    local star1 = { cc.p(0, 0), cc.p(0, 55), cc.p(55, 55), cc.p(55, 0)}
    draw:drawPolygon(star1, table.getn(star1), cc.c4f(1,0,0,0.5), 1, cc.c4f(0,0,1,1))
    self.clipNode:setStencil(draw)
    return self.clipNode
end

function ScrollLabelBase:setNum(num)
    if self.currentNum == num  then
        return
    end
    local speed = 0.2
    local index = self.currentNum - num
    local moveByAction = cc.MoveBy:create(speed * math.abs(index), cc.p(0, index * 55))
    local action = cc.EaseOut:create(moveByAction, 2.5)
    self.labelBase:runAction(action)

end

return ScrollLabelBase












