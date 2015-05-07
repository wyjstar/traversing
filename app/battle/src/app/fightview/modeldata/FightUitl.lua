
local FightUitl = class("FightUitl", function()
    return game.newNode()
end)

function FightUitl:ctor()
    self.resourceData = getDataManager():getResourceData()
end

function FightUitl:createHero(heroId, point)

    local soldierTemplate = getTemplateManager():getSoldierTemplate()

    local pictureName = soldierTemplate:getHeroImageName(heroId)

    local boardN = soldierTemplate:getHeroBoardById(heroId)

    local boardA = mvc.ViewSprite()
    boardA:setVisible(false)
    boardA:setCascadeOpacityEnabled(true)

    local boardM = mvc.ViewNode()
    boardM:setCascadeOpacityEnabled(true)

    boardM:addChild(boardN, 10)
    boardM:addChild(boardA, 20)

    local len = string.len(pictureName)
    local startPos = len - 4
    local tempName = pictureName

    local resFrame = string.sub(tempName, 1, startPos)
    self.resourceData:loadHeroImageDataById(resFrame)

    local heroN = soldierTemplate:getBigImageByResName(pictureName, heroId)

    -- self.resourceData:removeHeroImageDataById(resFrame)
    local heroA = mvc.ViewSprite()
    heroA:setVisible(false)
    heroA:setCascadeOpacityEnabled(true)

    local heroM = mvc.ViewNode()
    heroM:setCascadeOpacityEnabled(true)

    heroM:addChild(heroN, 10)
    heroM:addChild(heroA, 20)

    heroM:setPositionZ(30)
    -- heroM:setGlobalZOrder(0)

    local state = mvc.ViewBatchNode("res/card/state_all.pvr.ccz", 4)

    state.trough = mvc.ViewSprite("#c_trough.png")
    state.hp = mvc.ViewSprite(string.format("#c_hp%d.png", CONFIG_HP_MAX))
    state.mp = mvc.ViewSprite(string.format("#c_mp%d.png", CONFIG_HP_MIN))

    state.hp:setAnchorPoint(cc.p(0, 0))
    state.mp:setAnchorPoint(cc.p(0, 0))
    state.hp:setPosition(CONFIG_CARD_HP_X, CONFIG_CARD_HP_Y)
    state.mp:setPosition(CONFIG_CARD_MP_X, CONFIG_CARD_MP_Y)

    state.trough:addChild(state.hp)
    state.trough:addChild(state.mp)
    state.mp:setVisible(false)
    local kind = soldierTemplate:getHeroKindById(heroId)
    kind:setPosition(CONFIG_CARD_KIND_X, CONFIG_CARD_KIND_Y)
    state.trough:addChild(kind)

    state.trough:setPosition(CONFIG_CARD_STATE_X, CONFIG_CARD_STATE_Y)
    state.trough:setCascadeOpacityEnabled(true)
    state:addChild(state.trough)

    state:setCascadeOpacityEnabled(true)
    state:setPositionZ(60)
    -- state:setGlobalZOrder(0)

    --card
    cardN = mvc.ViewNode()
    cardN:setCascadeOpacityEnabled(true)

    cardN:addChild(boardM, 10)
    cardN:addChild(heroM, 20)
    cardN:addChild(state, 30)

    cardA = mvc.ViewSprite()
    cardA:setVisible(false)
    cardA:setCascadeOpacityEnabled(true)

    local node = game.newNode()
    node:addChild(cardN, 10)
    node:addChild(cardA, 20)

    if point ~= nil then 
        node:setPosition(point)
    end
    
    node:setCascadeOpacityEnabled(true)

    return node
end

function FightUitl:makeRedAction(seat)

    local function callBack(spender, args)

        local fadeTo = cc.FadeTo:create(args.time, 0)

        local function removeCallBack(spender)

            spender:removeFromParent(true)
        end

        local action = cc.Sequence:create(fadeTo, cc.CallFunc:create(removeCallBack))
        spender:runAction(action)
    end

    local time , rate = nil
    if seat == 1 then
        time = 0.5
        rate = 125
    elseif seat == 2 then
        time = 0.3
        rate = 125
    elseif seat == 3 then
        time = 0.1
        rate = 125
    elseif seat == 4 then
        time = 0.08
        rate = 125
    end

    local fadeTo = cc.FadeTo:create(time, rate)

    local action = cc.Sequence:create(fadeTo, cc.CallFunc:create(callBack, {time = time}))

    return action
end

function FightUitl:createBloodView(seat)
    --cclog("createBloodView=============" .. seat)
    local blood = game.newSprite("#ui_blood.png")
    blood:setScale(2)
    local fadeTo = cc.FadeTo:create(0, 0)
    blood:runAction(fadeTo)
    local bloodAction = self:makeRedAction(seat)
    blood:runAction(bloodAction)
    return blood
end

function FightUitl:getTargetArr(targetHero, effectId, impact)
   cclog("getTargetArr=========effectId====" .. effectId)
   cclog("name = " .. targetHero.name)
    local result = nil
    if effectId == 4 then   -- HP上限增加

        result = targetHero.tempHpM
    elseif effectId == 5 then   -- HP上限减少

        result = targetHero.tempHpM
    elseif effectId == 6 then   -- 攻击力增加

        result = targetHero.tempAtk
    elseif effectId == 7 then   -- 攻击力减少

        result = targetHero.tempAtk
    elseif effectId == 8 then   -- 怒气增加

        result = targetHero.anger
    elseif effectId == 9 then   -- 怒气减少

        result = targetHero.anger
    elseif effectId == 10 then  -- 物理防御增加

        result = targetHero.tempPhysical_def
    elseif effectId == 11 then  -- 物理防御减少

        result = targetHero.tempPhysical_def
    elseif effectId == 12 then  -- 魔法防御增加
        print("---effectId == 12-----")
        print(targetHero.isReplaceBuffer)
        
        if targetHero.isReplaceBuffer then
            result = targetHero.magic_def
        else
            result = targetHero.tempMagic_def
        end

    elseif effectId == 13 then  -- 魔法防御减少

        result = targetHero.tempMagic_def
    elseif effectId == 14 then  -- 命中率增加

        result = targetHero.tempHit
    elseif effectId == 15 then  -- 命中率减少

        result = targetHero.tempHit
    elseif effectId == 16 then  -- 闪避率增加

        result = targetHero.tempDodge
    elseif effectId == 17 then  -- 闪避率减少

        result = targetHero.tempDodge
    elseif effectId == 18 then  -- 暴击率增加

        result = targetHero.tempCri
    elseif effectId == 19 then  -- 暴击率减少

        result = targetHero.tempCri
    elseif effectId == 20 then  -- 暴击伤害系数

        result = targetHero.tempCri_ded_coeff
    elseif effectId == 21 then  -- 暴伤减免系数

        result = targetHero.tempCri_ded_coeff
    elseif effectId == 22 then  -- 格挡率增加

        result = targetHero.tempBlock
    elseif effectId == 23 then  -- 格挡率减少
        result = targetHero.tempBlock
    end
    return result
end

function FightUitl:runDelayAction(listener, time, args)
    
    if args then
        self:runAction(cc.Sequence:create({
            cc.DelayTime:create(time),
            cc.CallFunc:create(listener, args),
            }))
    else
        self:runAction(cc.Sequence:create({
            cc.DelayTime:create(time),
            cc.CallFunc:create(listener),
            }))
    end
end

-- function timer.delayPlayHit(listener, time, buffIndex, actionIdxAttack, actionsMaxValue)
--     local handle
--     local function callBack()
--         timer.unscheduleGlobal(handle)
--         listener(buffIndex, actionIdxAttack, actionsMaxValue)
--     end

--     handle = sharedScheduler:scheduleScriptFunc(callBack, time, false)
--     return handle
-- end

return FightUitl











