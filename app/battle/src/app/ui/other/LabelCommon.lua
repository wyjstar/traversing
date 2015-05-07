
LabelCommon = class("LabelCommon", function() return game.newNode() end)

function LabelCommon:ctor()
    self.label = nil
    self.shieldlayer = nil
    self.moveAction = nil
end

function LabelCommon:initAction(strValue)
    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()

    self.label = cc.LabelTTF:create(strValue, MINI_BLACK_FONT_NAME, 24)
    self.label:setColor(cc.c3b(255,0,0))
    self.shieldlayer = game.createShieldLayer()
    self.shieldlayer:setTouchEnabled(true)
    self.shieldlayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.label:setPosition(cc.p(CONFIG_SCREEN_SIZE_WIDTH / 2, -10))
    self:addChild(self.label)
    self:addChild(self.shieldlayer)

    self.moveAction = cc.Sequence:create({
        cc.DelayTime:create(0),
        cc.MoveTo:create(1.5, cc.p(CONFIG_SCREEN_SIZE_WIDTH / 2, 550)),cc.CallFunc:create(function () if self.label ~= nil then self.label:setVisible(false) self.label = nil self.shieldlayer:setTouchEnabled(false) end end
        ), nil})
    self.label:runAction(self.moveAction)
end

return LabelCommon
