
local FVCardLight = class("FVCardLight", function()
    return mvc.ViewNode()
end)
function FVCardLight:ctor(id)
    
end

function FVCardLight:onKillOverBegin(seat)
    timer.delayGlobal(function()
        local frames = game.newFrames("dazhao_0000%d.png", 0, 4)
        local animation = game.newAnimation(frames, 0.08 * CONFIG_KO_SLOW)

        self.light = mvc.ViewSprite()
        self.light:setPosition(const.HOME_ENEMY[seat-12].point)
        self.light:setScale(2)

        self.light:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))

        self:addChild(self.light)
    end, 0.15)
end

function FVCardLight:removeLight()
    if self.light then
        self.light:removeFromParent(true)
        self.light = nil
    end

end

return FVCardLight
