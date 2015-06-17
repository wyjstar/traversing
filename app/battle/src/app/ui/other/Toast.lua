
local Toast = class("Toast", BaseUIView)

function Toast:ctor(id)
    self.super.ctor(self, id)

    self.label = nil

end

function Toast:onMVCEnter()

    self.label = cc.LabelTTF:create("test", MINI_BLACK_FONT_NAME, 35)
    self.label:enableStroke(ui.COLOR_RED, 2)
    self.label:setVisible(false)
    self.label:setPosition(self.adapterLayer:getContentSize().width/2, self.adapterLayer:getContentSize().height/2 - 50)
    self.label:setDimensions(cc.size(540, 200))
    self:addToUIChild(self.label)
    self.label:setColor(cc.c3b(255,127,0))

    -- self.shieldlayer:setTouchEnabled(false)
    self.adapterLayer:setTouchEnabled(false)

    self:show(self.funcTable[1])
end

function Toast:show(message)

    local function CallFunc()
        if self.label ~= nil then
            self:removeFromParent()
        end
    end

    if self.label then

        self.label:setString(message)

        self.moveAction = cc.Sequence:create(
        cc.Show:create(),
        cc.MoveBy:create(1.0, cc.p(0, 150)),cc.CallFunc:create(CallFunc))
        self.label:runAction(self.moveAction)
    end
end

return Toast
