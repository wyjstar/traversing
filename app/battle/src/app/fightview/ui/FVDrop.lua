
local FVDrop = class("FVDrop", function()
    return game.newNode()
end)

function FVDrop:ctor(id)
    self.target = nil
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
end

function FVDrop:setTarget(target)
    self.target = target
end

function FVDrop:playDropping(point)

    local startPoint = point
    
    local sprite = game.newSprite("#ui_fight_diaoluo.png")
    sprite:setPosition(startPoint.x, startPoint.y + 100)
    local targetPoint = cc.p(42.7, 928)

    local function callBack()
        self.target:playDroppingOver()
    end
    
    local speed = 1
    --in --先慢后快
    --out ----先快后慢2
    --local moveBy1 = cc.MoveBy:create(0.05 * speed, cc.p(0, 100))
    local moveBy2 = cc.MoveBy:create(0.3 * speed, cc.p(0, -100))
    local moveBy3 = cc.MoveBy:create(0.1 * speed, cc.p(0, 30))
    local moveTo1 = cc.MoveTo:create(0.3 * speed, targetPoint)
    --local action1 = cc.EaseOut:create(moveBy1, 2.5)
    local action2 = cc.EaseIn:create(moveBy2, 2.5) 
    -- local action2 = cc.EaseBounceIn:create(moveBy2) 
    local scaleTo3 = cc.ScaleTo:create(0, 0)
    local action3 = cc.EaseIn:create(moveTo1, 2.5)
    local action4 = cc.EaseOut:create(moveBy3, 2.5)
    local scaleTo2 = cc.ScaleTo:create(0.05 * speed, 1)
    --local spawn1 = cc.Spawn:create(action1, scaleTo2)
    local delayTime1 = cc.DelayTime:create(0.1 * speed)
    local delayTime2 = cc.DelayTime:create(0.32 * speed)
    --local sequenceAction1 = cc.Sequence:create(action1, action2, cc.RemoveSelf:create(true),cc.CallFunc:create(callBack))
    local sequenceAction1 = cc.Sequence:create(scaleTo2, action2, delayTime1, scaleTo3, delayTime2,
     cc.RemoveSelf:create(true), cc.CallFunc:create(callBack))
    --local scaleTo1 = cc.ScaleTo:create(0.01, 0.1)
    sprite:setScale(0)
    sprite:runAction(sequenceAction1)
    self:addChild(sprite)
    local aniNode = self:UI_Zhandoubaoxiangdiaoluo(targetPoint)
    aniNode:setPosition(startPoint)
    self:addChild(aniNode)

    --宝箱特效
    local particleThree = createParticle("ui_a002803", startPoint)

    local cistbleThree1 = createVistbleAction(false)
    local delayThree1 = createParticleDelay(0.45 * speed)
    local cistbleThree2 = createVistbleAction(true)
    local particleThree2 = createRestartAction("ui_a002803")
    local delayThree2 = createParticleDelay(0.35 * speed)

    local moveAction1 = createParticleMove(targetPoint, 0.3 * speed, 0)

    local action6 = cc.EaseIn:create(moveTo1:clone(), 2.5) 

    local scaleThree  = createScaleTo(0.3 * speed, 0.7, 0.7)
    local spawnThree = createSpawn(action6, scaleThree)

    local delayThree3 = createParticleDelay(0.01 * speed)
    local stopActionThree = createParticleOut(0.01 * speed)
  
    local sequenceActionThree = createSequence(cistbleThree1, delayThree1, cistbleThree2, particleThree2, 
        spawnThree, delayThree3, stopActionThree)

    particleThree:runAction(sequenceActionThree)
    self:addChild(particleThree)
end

function FVDrop:UI_Zhandoubaoxiangdiaoluo(targetPos)--战斗宝箱掉落 28
    local speed = 5
    -- 光
    local particleone = createParticle("ui_a002801", cc.p(0,80))
    local delayActionone = createParticleDelay(0.3 * speed)
    local stopActionone = createParticleOut(0.3 * speed)
    local sequenceActionone= createSequence(delayActionone, stopActionone)

    --图标特效-- 第二个
    local particletwo = createParticle("ui_a002802", cc.p(0,100))
    local scaleToActiotten  = createScaleTo(0, 1, 1)
    local delayActiontwo = createParticleDelay(0.2 * speed)--持续时间
    local stopActiontwo = createParticleOut(0.5 * speed)
    local sequenceActiontwo = createSequence(scaleToActiotten,delayActiontwo,stopActiontwo)


    local node = createTotleAction(
        particleone, sequenceActionone,
        particletwo, sequenceActiontwo
        --particleThree, sequenceActionThree
        )
    return node
end


return FVDrop






