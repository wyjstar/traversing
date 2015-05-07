
local FVEntry = class("FVEntry", function()
    return game.newNode()
end)

function FVEntry:ctor(id)
    self.target = nil
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.fightUitl = getFightUitl()
end

function FVEntry:setTarget(target)
    self.target = target
end

function FVEntry:startEntryAni(hero)
    local proxy = cc.CCBProxy:create()
    self.UIAniView = {}
    self.entryView = CCBReaderLoad("effect/ui_wujiangluanru.ccbi", proxy, self.UIAniView)
    self:addChild(self.entryView)

    self.entryView:runAction(cc.Sequence:create(cc.DelayTime:create(3.34), cc.RemoveSelf:create(true)))
    local action = cc.Sequence:create({
        cc.DelayTime:create(1.68),
        cc.CallFunc:create(function ()
            self:heroIn(hero)    
        end
        ), nil})

    self:runAction(action)
  
    local action2 = cc.Sequence:create({
    cc.DelayTime:create(0.6),
    cc.CallFunc:create(function ()
        getFightScene():runSceneShake(1)
    end
    ), nil})

    self:runAction(action2)

    local action3 = cc.Sequence:create({
    cc.DelayTime:create(0.8),
    cc.CallFunc:create(function ()
        getFightScene():runSceneShake(1)
    end
    ), nil})

    self:runAction(action3)
  
    local action4 = cc.Sequence:create({
    cc.DelayTime:create(1.0),
    cc.CallFunc:create(function ()
        getFightScene():runSceneShake(1)
    end
    ), nil})

    self:runAction(action4)

    local action5 = cc.Sequence:create({
    cc.DelayTime:create(1.2),
    cc.CallFunc:create(function ()
        getFightScene():runSceneShake(3)
    end
    ), nil})

    self:runAction(action5)

    local action6 = cc.Sequence:create({
    cc.DelayTime:create(2.48),
    cc.CallFunc:create(function ()
        getFightScene():runSceneShake(3)
        self.heroNode:removeFromParent(true)
        self.target:onEntryAniOver(hero)

    end
    ), nil})

    self:runAction(action6)

end

function FVEntry:heroIn(hero)
    local heroId = hero.no
    self.heroNode = self.fightUitl:createHero(heroId)
    self:addChild(self.heroNode)

    local fadeTo2 = cc.FadeTo:create(0, 0)
    local scaleTo1 = cc.ScaleTo:create(0, 1.334)
    local scaleTo2 = cc.ScaleTo:create(0.16, 1.5)
    local fadeTo = cc.FadeTo:create(0.16, 255)
    local scaleTo3 = cc.ScaleTo:create(0.4, 1.55)
    local delatAction = cc.DelayTime:create(0.2)

    local point = hero.HOME.point

    -- local time = 0.04
    local time = 0.02
    local moveToAction = cc.MoveTo:create(time, point)
    local scaleTo = cc.ScaleTo:create(time, BIG_SCALE)

    local spawnAction1 = cc.Spawn:create(scaleTo2:clone(), fadeTo:clone())
    local spawnAction2 = cc.Spawn:create(moveToAction:clone(), scaleTo:clone())

    local sequenceAction = cc.Sequence:create(scaleTo1, spawnAction1, scaleTo3, delatAction, spawnAction2)
    self.heroNode:setPosition(320, 540)
    self.heroNode:runAction(sequenceAction)
end

return FVEntry






