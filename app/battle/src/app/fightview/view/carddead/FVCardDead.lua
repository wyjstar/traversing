
local FVCardDead = class("FVCardDead", function()
    return mvc.ViewSprite()
end)

function FVCardDead:ctor(prop)
    self.fvActionSpec = getFVActionSpec()
    self:setSpriteFrame("c_dead_n.png")

    self.dead1 = mvc.ViewSprite("#c_dead1.png")
    self.dead2 = mvc.ViewSprite("#c_dead2.png")
    self.dead3 = mvc.ViewSprite("#c_dead3.png")
    self.dead4 = mvc.ViewSprite("#c_dead4.png")
    self.dead5 = mvc.ViewSprite("#c_dead5.png")

    self.dead1:setPosition(0, 70)
    self.dead2:setPosition(-20, -17)
    self.dead3:setPosition(5, 20)
    self.dead4:setPosition(55, -40)
    self.dead5:setPosition(4, -50)

    self:addChild(self.dead1)
    self:addChild(self.dead2)
    self:addChild(self.dead3)
    self:addChild(self.dead4)
    self:addChild(self.dead5)

    self.dead1:setScale(1.5)
    self.dead2:setScale(1.5)
    self.dead3:setScale(1.5)
    self.dead4:setScale(1.5)
    self.dead5:setScale(1.5)
end

function FVCardDead:setCardHome(home)
    self.home = home

    self:setPosition(self.home.point)
    self:setScale(self.home.scale)
end

function FVCardDead:cleanAllAction()
    self:setPosition(self.home.point)
    self:setScale(self.home.scale)

    self.dead1:setRotation(0)
    self.dead2:setRotation(0)
    self.dead3:setRotation(0)
    self.dead4:setRotation(0)
    self.dead5:setRotation(0)
end

--卡牌死亡动画，出碎板子
function FVCardDead:playAction_dead()
    self:cleanAllAction()

    local action0, action1, action2, action3, action4, action5 = self.fvActionSpec:makeActionDead()

    self:runAction(action0)
    self.dead1:runAction(action1)
    self.dead2:runAction(action2)
    self.dead3:runAction(action3)
    self.dead4:runAction(action4)
    self.dead5:runAction(action5)
end

function FVCardDead:playAction_shake(target_pos, aspect)
    if aspect == 1 then
        local action = self.fvActionSpec:makeActionShake_1(target_pos, self.home)

        self:runAction(action)
    elseif aspect == 2 then
        local action = self.fvActionSpec:makeActionShake_2()

        self:runAction(action)
    end
end

return FVCardDead
