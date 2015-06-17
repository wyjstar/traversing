--处理伤害显示文字
local FVCardHarm = class("FVCardHarm", function()
    return mvc.ViewNode()
end)

function FVCardHarm:ctor(id)

    -- self.dir = {
    --     {pos1 = cc.p(70, 30), h1 = 80, pos2 = cc.p(30, 10), h2 = 30},
    --     {pos1 = cc.p(-30, 70), h1 = 100, pos2 = cc.p(-10, 30), h2 = 50},
    --     {pos1 = cc.p(30, 70), h1 = 100, pos2 = cc.p(10, 30), h2 = 50},
    --     {pos1 = cc.p(-70, 30), h1 = 80, pos2 = cc.p(-30, 10), h2 = 30}
    -- }
    -- self.dirc = 0
   
    --创建卡牌
    --播放分段
    
end

function FVCardHarm:playHitImpact(buff_info, target_info)
    print("FVCardHarm:playHitImpact=====================>",buff_info.effectId)
    local point = target_info.target_unit.HOME.point
    self:playBlockEffect(point)
    if target_info.is_hit and target_info.is_block then --格档
        
        self:playHarm(point, target_info)
    elseif not target_info.is_hit then                  --闪避
        self:playDodgeEffect(point, target_info)
    elseif table.inv({1, 2, 3,18,30}, buff_info.effectId) then
        self:playHarm(point, target_info)
    elseif table.inv({26}, buff_info.effectId) then     --加血
        self:playHpAdd(point, target_info)
    else
        cclog("playHitImpact5")
        table.print(buff_info.effectId)
    end
end

function FVCardHarm:playHarm(pos, target_info)
    cclog("FVCardHarm:playHarm================>")      
    local is_combo = target_info.is_combo    -- 
    if is_combo then -- 连击产生的总伤害
        self:playFinalHarm(pos, target_info)
        return
    end

    local is_cri = target_info.is_cri  -- 暴击
    if is_cri then
        self:playCriHarm(pos, target_info)
    else
        self:playNormalHarm(pos, target_info)
    end
end

function FVCardHarm:playDigitHarm(digitTable)
    print("FVCardHarm:playDigitHarm->>>>>>>>>>>>>>>>>>")
    table.print(digitTable)
    self:playHarm(digitTable.location,digitTable.targetInfo)
end

function FVCardHarm:playNormalHarm(pos, target_info)
    cclog("FVCardHarm:playNormalHarm================>harm="..target_info.value)     
    local ratio = target_info.ratio
    local harm = target_info.value
    local interTime = target_info.time
    if interTime == nil  or interTime == 0 then
        interTime = 0.2
    end

    if harm == nil or harm == 0 then
        return
    end
    if ratio == nil then
        ratio = 1
    end
    harm = harm * ratio
    if harm < 1 then
        harm = 1
    end
    harm = math.ceil(harm)
    print("FVCardHarm:playNormalHarm===============================",harm,"time:",interTime)
    local harmStr = tostring(harm)
    
    local harmNode = game.newNode()
    self:addChild(harmNode)
    harmNode:setLocalZOrder(10)
    harmNode:setGlobalZOrder(10000)
    -- local interTime = 0.2
    local delayAction = cc.DelayTime:create(interTime / ACTION_SPEED)
    local function callBack(spender, args)
        self:createLabel(args)
    end

    local sequenceAction = cc.Sequence:create(delayAction, 
        cc.CallFunc:create(callBack, 
            {harmStr = harmStr, 
            index = 1,
            pos = pos,
            harmNode = harmNode
            }))
    self:runAction(sequenceAction)

    -- local delayAction = cc.DelayTime:create(0.01 / ACTION_SPEED)
    local args = nil

    local moveBy = cc.MoveBy:create((interTime+0.2) / ACTION_SPEED, cc.p(0, 50))
    local moveByOut = cc.EaseOut:create(moveBy, 2.5)
    local moveBy2 = cc.MoveBy:create((interTime+1) / ACTION_SPEED, cc.p(0, 5))
    local delayAction2 = cc.DelayTime:create((interTime+1) / ACTION_SPEED)
    local spawnAction1 = cc.Spawn:create(moveBy2, delayAction2)
    local sequenceAction = cc.Sequence:create(moveByOut, moveBy2, cc.RemoveSelf:create(true))
    harmNode:runAction(sequenceAction)
end

function FVCardHarm:playCriHarm(pos, target_info)
    cclog("FVCardHarm:playCriHarm================>")    
    local ratio = target_info.ratio
    local harm = target_info.value

    if harm == nil or harm == 0 then
        return
    end
    if ratio == nil then
        ratio = 1
    end
    harm = harm * ratio
    if harm < 1 then
        harm = 1
    end
    harm = math.ceil(harm)

    local harmStr = tostring(harm)

    local labelA = cc.LabelAtlas:_create(harmStr, "res/ui/ui_cri_num.png", 34, 55, string.byte("/"))
    local labelB = cc.LabelAtlas:_create(harmStr, "res/ui/ui_cri_num.png", 34, 55, string.byte("/"))
    labelA:setVisible(false)
    labelB:setVisible(false)
    labelA:setPosition(pos)
    labelB:setPosition(pos)

    self:addChild(labelA)
    self:addChild(labelB)
    labelA:setScale(10)
    labelB:setScale(5)
    local time = 0.2 / ACTION_SPEED
    local detal = 0.1 / ACTION_SPEED
    labelA:setAnchorPoint(cc.p(0.5, 0.5))
    labelB:setAnchorPoint(cc.p(0.5, 0.5))

    local fadeTo1 = cc.FadeTo:create(detal, 0)
    local showAction = cc.Show:create()

    local scaleAction1 = cc.ScaleTo:create(time , 1)
    local fadeTo2 = cc.FadeTo:create(time, 255)
    local delayAction1 = cc.DelayTime:create(0.5 / ACTION_SPEED)
    local removeSelfAction = cc.RemoveSelf:create(true)

    local spawmAction1 = cc.Spawn:create(scaleAction1, fadeTo2)
    local sequenceAction1 = cc.Sequence:create(fadeTo1, showAction:clone(), spawmAction1, delayAction1, removeSelfAction)
    labelA:runAction(sequenceAction1:clone())
    ------------
    local fadeTo3 = cc.FadeTo:create(detal + 0.5 / ACTION_SPEED, 125)
    local scaleAction2 = cc.ScaleTo:create(time / 2, 1)
    local fadeTo4 = cc.FadeTo:create(time / 2, 255)

    local spawmAction2 = cc.Spawn:create(scaleAction2, fadeTo4)
    -- local delayAction2 = cc.DelayTime:create(0.5 + detal)
    -- local sequenceAction2 = cc.Sequence:create(fadeTo3, showAction:clone(), spawmAction2, delayAction1:clone(), removeSelfAction:clone())
    -- labelB:runAction(sequenceAction2)

    local sprite = game.newSprite("#ui_cri_args.png")
    sprite:setVisible(false)
    sprite:setPosition(pos.x, pos.y + 60)
    self:addChild(sprite)
    sprite:setScale(10)
    sprite:runAction(sequenceAction1:clone())
end

function FVCardHarm:createLabel(args)
    print("FVCardHarm:createLabel========>")
    table.print(args)
    local harmOneStr = args.harmStr
    local index = args.index
    local pos = args.pos
    local harmNode = args.harmNode
    local label = cc.LabelAtlas:_create(harmOneStr, "res/ui/ui_f_d_atlas2.png", 34, 55, string.byte("/"))
    label:setAnchorPoint({x = 0.5, y = 0.5})
    local posX = ( index - 1 ) * 34
    label:setPosition(cc.pAdd(pos, cc.p(posX, 0)))
    harmNode:addChild(label)
    label:setGlobalZOrder(100000) --数字显示在最上层
    label:setScale(5)
    label:setVisible(false)
    local speed = 1
    local fadeTo1 = cc.FadeTo:create(0.01, 0)
    local showAction = cc.Show:create()
    -- local scaleAction1 = cc.ScaleTo:create(speed * 0.1 / ACTION_SPEED, 2)
    -- local fadeTo2 = cc.FadeTo:create(speed * 0.1 / ACTION_SPEED, 50)
    -- local spawnAction1 =  cc.Spawn:create(scaleAction1, fadeTo2)

    local scaleAction2 = cc.ScaleTo:create(speed * 0.1 / ACTION_SPEED, 1)
    local fadeTo3 = cc.FadeTo:create(speed * 0.1 / ACTION_SPEED, 255)
    local spawnAction2 =  cc.Spawn:create(scaleAction2, fadeTo3)

    local delayAction1 = cc.DelayTime:create(0.2 / ACTION_SPEED)
    local scaleAction3 = cc.ScaleTo:create(0.8 / ACTION_SPEED, 1.1)

    local delayAction2 = cc.DelayTime:create(0.3 / ACTION_SPEED)
    local fadeTo4 = cc.FadeTo:create(speed * 0.5 / ACTION_SPEED, 0)
    local sequenceAction2 = cc.Sequence:create(delayAction2, fadeTo4)

    local spawnAction3 = cc.Spawn:create(scaleAction3, sequenceAction2)
    local removeSelfAction = cc.RemoveSelf:create(true)
    local sequenceAction = cc.Sequence:create(fadeTo1, showAction, spawnAction2, spawnAction3, removeSelfAction)
    label:runAction(sequenceAction)
end

-- 总伤害
function FVCardHarm:playFinalHarm(pos, target_info)
    cclog("FVCardHarm:playFinalHarm=================>")
    local ratio = target_info.ratio
    local harm = target_info.value

    if harm == nil or harm == 0 then
        return
    end

    if ratio == nil then
        ratio = 1
    end

    harm = harm * ratio

    if harm < 1 then
        harm = 1
    end

    harm = math.ceil(harm)

    local harmStr = tostring(harm)

    local label = cc.LabelAtlas:_create(harmStr, "res/ui/ui_f_d_atlas2.png", 34, 55, string.byte("/"))
    label:setAnchorPoint({x = 0.5, y = 0.5})

    label:setPosition(cc.pAdd(pos, cc.p(0, 50)))
    self:addChild(label)

    local time = 1.5

    local moveByAction = cc.MoveBy:create(time / ACTION_SPEED, cc.p(0, 50))
    local removeSelfAction = cc.RemoveSelf:create(true)
    local sequenceAction = cc.Sequence:create(moveByAction, removeSelfAction)
    label:runAction(sequenceAction)

    local sprite = game.newSprite("res/fight/final_harm.png")
    sprite:setPosition(cc.pAdd(pos, cc.p(0, 50+60)))
    self:addChild(sprite)
    sprite:runAction(sequenceAction:clone())
end


function FVCardHarm:playHpAdd(pos, target_info)
    cclog("FVCardHarm:playHpAdd================>")    
    local ratio = target_info.ratio
    local hpAdd = target_info.value
    if hpAdd == nil or hpAdd == 0 then
        return
    end
    if ratio == nil then
        ratio = 1
    end
    hpAdd = hpAdd * ratio
    local label = cc.LabelAtlas:_create(string.format("/%d", hpAdd), "res/ui/ui_hp_add.png", 34, 55, string.byte("/"))
    label:setAnchorPoint({x = 0.5, y = 0.5})
    label:setPosition(cc.pAdd(pos, cc.p(0, 10)))
    local time = 1.5
    label:runAction(cc.Sequence:create({
        cc.MoveBy:create(time / ACTION_SPEED, cc.p(0, 100)),
        cc.RemoveSelf:create(true),
        }))

    self:addChild(label)
end

-- 闪避
function FVCardHarm:playDodgeEffect(pos)
    cclog("FVCardHarm:playDodgeEffect================>")
    local background = game.newSprite("#buff_bgb.png")
    local shanSprite = game.newSprite("#shan.png")
    background:addChild(shanSprite)
    background:setPosition(pos)
    background:setScale(0.7)

    background:setCascadeOpacityEnabled(true)
    shanSprite:setCascadeOpacityEnabled(true)

    shanSprite:setPosition(100, 60)
    background:setVisible(false)
    local fadeTo2 = cc.FadeTo:create(0.01, 1)

    local time = 0.03
    local dis = 40
    local fadeTo1 = cc.FadeTo:create(time * 8 / ACTION_SPEED, 250)
    local moveByLeft1 = cc.MoveBy:create(time / ACTION_SPEED, cc.p(-dis, 0))
    local moveByRight1 = cc.MoveBy:create(time * 2 / ACTION_SPEED, cc.p(dis * 2, 0))
    local moveByLeft2 = cc.MoveBy:create(time * 2 / ACTION_SPEED, cc.p(-dis * 2, 0))
    local moveByLeft3 = cc.MoveBy:create(time / ACTION_SPEED, cc.p(-dis, 0))
    -- local hide = cc.Hide:create()
    local sequenceAction1 = cc.Sequence:create( moveByLeft1, moveByRight1, moveByLeft3)
    local spawnAction = cc.Spawn:create(fadeTo1, sequenceAction1)
    local delayAction4 = cc.DelayTime:create(0.5 / ACTION_SPEED)
    local fadeTo3 = cc.FadeTo:create(time * 8 / ACTION_SPEED, 0)
    time = 0.01
    local moveByLeft4 = cc.MoveBy:create(time / ACTION_SPEED, cc.p(-dis, 0))
    local moveByRight4 = cc.MoveBy:create(time * 2 / ACTION_SPEED, cc.p(dis * 2, 0))
    local moveByLeft5 = cc.MoveBy:create(time * 2 / ACTION_SPEED, cc.p(-dis * 2, 0))

    local sequenceAction3 = cc.Sequence:create(moveByLeft4, moveByRight4, moveByLeft5)
    local spawnAction2 = cc.Spawn:create(fadeTo3, sequenceAction3)

    local sequenceAction2 = cc.Sequence:create(fadeTo2, cc.Show:create(), spawnAction, delayAction4, spawnAction2, cc.RemoveSelf:create(true))
    background:runAction(sequenceAction2)

    self:addChild(background)
end

-- 格挡
function FVCardHarm:playBlockEffect(pos)
    return
    -- cclog("FVCardHarm:playBlockEffect================>")
    -- local gedang_a = game.newSprite("#gedang_a.png")
    -- local gedang_b = game.newSprite("#gedang_b.png")
    -- local gedang_c = game.newSprite("#gedang_c.png")
    -- local removeTime = 1
    -- local delayAction1 = cc.DelayTime:create(removeTime / ACTION_SPEED)
    -- local sequenceAction1 = cc.Sequence:create(delayAction1, cc.RemoveSelf:create(true))
    -- gedang_a:setPosition(pos.x, pos.y + 62)
    -- gedang_b:setPosition(pos)
    -- gedang_c:setPosition(pos.x, pos.y + 62)
    -- self:addChild(gedang_a)
    -- self:addChild(gedang_b)
    -- self:addChild(gedang_c)

    -- gedang_a:runAction(sequenceAction1:clone())
    -- gedang_c:runAction(sequenceAction1:clone())

    -- local moveBy1 = cc.MoveBy:create(removeTime / ACTION_SPEED, cc.p(0, 100))
    -- local sequenceAction2 = cc.Sequence:create(moveBy1, cc.RemoveSelf:create(true))
    -- gedang_b:runAction(sequenceAction2)
end

return FVCardHarm















