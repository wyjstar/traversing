--刀光显示层
local FVLayerFlash = class("FVLayerFlash", mvc.ViewBase)

function FVLayerFlash:ctor(id)
    FVLayerFlash.super.ctor(self, id)

end

function FVLayerFlash:onMVCEnter()
    self.flash = mvc.ViewSprite()

    self:addChild(self.flash)

    self:listenEvent(const.EVENT_ATTACK_FLASH, self.onAttackFlash, nil)
end

function FVLayerFlash:onAttackFlash(frames, pos, scale, rotate, flip)
    self.flash:stopAllActions()
    self.flash:setPosition(pos)
    self.flash:setScale(scale)
    self.flash:setRotation(rotate)
    self.flash:setFlippedX(flip)
    self.flash:setVisible(true)

    print("FVLayerFlash:onAttackFlash========================>",frames[1])
    self.flash:setSpriteFrame(frames[1])
    self.flash:runAction(cc.Sequence:create({
        cc.DelayTime:create(0.05),
        cc.Animate:create(cc.Animation:createWithSpriteFrames(frames, 0.05)),
        cc.Hide:create(),
        }))
end

return FVLayerFlash
