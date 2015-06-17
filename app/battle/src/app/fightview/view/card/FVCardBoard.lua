
local FVCardBoard = class("FVCardBoard", function()
    return mvc.ViewNode()
end)

function FVCardBoard:ctor(prop)
    self:init(prop)
end

function FVCardBoard:init(prop)
    if prop == nil then
        return
    end
    self:setCascadeOpacityEnabled(true)

    local soldierTemplate = getTemplateManager():getSoldierTemplate()

    self.boardN = soldierTemplate:getHeroBoardById(prop.origin_no)

    self.boardA = mvc.ViewSprite()
    self.boardA:setVisible(false)
    self.boardA:setCascadeOpacityEnabled(true)
    ------------------------------------------------------
    self.shadow = mvc.ViewSprite("res/card/shadow.png")
    self.shadow:setVisible(false)
    self.shadow:setOpacity(128)
    self.shadow:setScale(self.boardN:getScale()*0.65)
    self.shadow:setPosition(self.boardN:getPositionX() - 20, self.boardN:getPositionY() - 30)
    self.shadow:setRotation(self.boardN:getRotation())         
    -------------------------------------------------------
    self:addChild(self.shadow)
    self:addChild(self.boardN)
    self:addChild(self.boardA)
end

function FVCardBoard:setCardClean()
    self.boardA:stopAllActions()
    self.boardA:setPosition(0, 0)
    self.boardA:setScale(1)
    self.boardA:setRotation(0)

    self.boardN:setRotation(0)
    self.boardN:setAdditionalTransform({a = 1, b = 0, c = 0, d = 1, tx = 0, ty = 0})
end

function FVCardBoard:setShowShadow(visible)
    self.shadow:setVisible(visible)  
end

function FVCardBoard:stopMNAction()
    self:stopAllActions()
    self.boardN:stopAllActions()
end

return FVCardBoard
