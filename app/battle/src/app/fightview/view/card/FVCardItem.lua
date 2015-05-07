
local FVCardBoard = import(".FVCardBoard")
local FVCardImage = import(".FVCardImage")
local FVCardState = import(".FVCardState")

local FVCardItem = class("FVCardItem", function()
    return mvc.ViewNode()
end)

function FVCardItem:ctor(prop, no)
    self.unit = prop
    self.data = {}
    self.data.hpcur = CONFIG_HP_MAX
    self.data.mpcur = CONFIG_MP_MIN
    self.beginCallBack = nil 
    self.attackCallBack = nil  
    self.beHitCallBack = nil 

    self.beginActionIndex = 0 
    self.attackActionIndex = 0 
    self.beHitActionIndex = 0 
    if prop then
        self.is_boss = prop.is_boss
        self.chief = prop.chief
        self.position = prop.viewPos --viewPos, pos position都代表位置
    end
    
    self.isDead = false
    self.isShowShadow = false
    self.target = nil

    self.boardM = FVCardBoard.new(prop, no)
    self.heroM = FVCardImage.new(prop, no)
    self.heroM:setVisible(true)
    self.state = FVCardState.new(prop, no)
    --card
    self.cardN = mvc.ViewNode()
    self.cardN:setCascadeOpacityEnabled(true)
    self.cardN:addChild(self.boardM, 10)
    self.cardN:addChild(self.heroM, 20)
    self.cardN:addChild(self.state, 30)
    -----------
    self.cardA = mvc.ViewSprite()
    self.cardA:setVisible(false)
    self.cardA:setCascadeOpacityEnabled(true)
    

    self:addChild(self.cardN)
    self:addChild(self.cardA)
    self:setCascadeOpacityEnabled(true)
end

function FVCardItem:setTarget(target)
    self.target = target
end

function FVCardItem:setIsShowShadow(isShowShadow)
    self.isShowShadow = isShowShadow
    self.boardM:setShowShadow(isShowShadow)
end

function FVCardItem:getIsShowShadow()
    return self.isShowShadow 
end

function FVCardItem:changeDeadState(state)
    cclog("changeDeadState======")
    self.isDead = state
end

function FVCardItem:getDeadState()
    return self.isDead
end


function FVCardItem:setCardHome(home)
    self.home = home

    self:setPosition(self.home.point)
    
    self:setScale(self.home.scale)
end

function FVCardItem:setCardClean()
    self.heroM:setCardClean()
    self.boardM:setCardClean()

    self.cardA:stopAllActions()

    self:setPosition(self.home.point)
    self.boardM:setPosition(0, 0)
    self.heroM:setPosition(0, 0)
    self.cardA:setPosition(0, 0)

    self:setScale(self.home.scale)
    self.boardM:setScale(1)
    self.heroM:setScale(1)
    self.cardA:setScale(1)

    self.cardN:setRotation(0)

    self.cardA:setRotation(0)
    self:setOpacity(255)
    self:setRotation(0)
    self.cardN:setAdditionalTransform({a = 1, b = 0, c = 0, d = 1, tx = 0, ty = 0})
end

function FVCardItem:armyGone()
    cclog("FVCardItem:armyGone=====================================>")
    local time = 0.18
    local moveDis = -50
    local scaleTo1 = cc.ScaleTo:create(0.1, 0.52)
    local delatAction = cc.DelayTime:create(0.04)
    local scaleTo2 = cc.ScaleTo:create(time, 1.1)
    local fadeTo = cc.FadeTo:create(time, 0)
    local function callBack()
        self:setVisible(false)
        self.isShowShadow = false
    end
    local spawnAction = cc.Spawn:create(scaleTo2, fadeTo:clone())

    local sequenceAction = cc.Sequence:create(scaleTo1, delatAction, spawnAction, cc.CallFunc:create(callBack))
    self:runAction(sequenceAction)
    self.isGone = true
end

function FVCardItem:armyIn()

    local scaleTo1 = cc.ScaleTo:create(0, 1.334)
    local scaleTo2 = cc.ScaleTo:create(0.16, 1.5)
    local fadeTo = cc.FadeTo:create(0.16, 255)
    local scaleTo3 = cc.ScaleTo:create(0.86, 1.55)
    local delatAction = cc.DelayTime:create(1.2)

    local moveToAction = cc.MoveTo:create(0.06, self.home.point)
    local scaleTo = cc.ScaleTo:create(0.06, self.home.scale)

    local spawnAction1 = cc.Spawn:create(scaleTo2:clone(), fadeTo:clone())
    local spawnAction2 = cc.Spawn:create(moveToAction:clone(), scaleTo:clone())
    local function  callBack1(spender)
        spender:setVisible(true)
    end
    local sequenceAction = cc.Sequence:create(scaleTo1:clone(), cc.CallFunc:create(callBack1), spawnAction1, scaleTo3, delatAction, spawnAction2)
    self:setPosition(320, 540)
    self:runAction(sequenceAction:clone())
end

function FVCardItem:playBeginAction(actions, callback)
    self.beginCallBack = callback
    local function callbackActionEnd()
        self.beginActionIndex = self.beginActionIndex - 1
        if self.beginActionIndex == 0 then
            self:onBeginActionEnd()
        end
    end
    self.beginActionIndex = self:playAction(actions, callbackActionEnd, {})
    if self.beginActionIndex == 0 then
        self:onBeginActionEnd()
    end
end

function FVCardItem:stopBeginAction()
    self:stopAllActions()
    self.cardN:stopAllActions()
    self.boardM:stopMNAction()
    self.heroM:stopMNAction()
end

function FVCardItem:onBeginActionEnd()
    local callBack = self.beginCallBack
    if callBack then
        callBack()
    end
end

function FVCardItem:preHiting()
    if self.beHitActionIndex > 0 then
        self:stopAllActions()
        self.cardN:stopAllActions()
        self.boardM:stopMNAction()
        self.heroM:stopMNAction()
        cclog("FVCardItem:preHiting-------------")
        self.beHitActionIndex = 0
        self:playBeHitCallBack(self.dataTable)  
        if self.attackActionIndex > 0 then
            cclog("playAttackCallBack-------------self.attackActionIndex====" .. self.attackActionIndex)
            self.attackActionIndex = 0
            self:playAttackCallBack()
        end
    end
end

function FVCardItem:playAttackAction(actions)
    cclog("FVCardItem:playAttackAction==========>step3")
    local function callbackActionEnd(tag, args)
        self:onAttackActionEnd() 
    end
    self.attackActionIndex = self:playAction(actions, callbackActionEnd, {})

    if self.attackActionIndex == 0 then
        self:playAttackCallBack()
    end
end

function FVCardItem:playBeHitAction(dataTable)  
    self.dataTable = dataTable
    local actions = self.dataTable.beAction
    local function callbackActionEnd(tag, args)
        self:onBeHitActionEnd(args.dataTable)
    end
    self.beHitActionIndex = self:playAction(actions, callbackActionEnd, self.dataTable)

    if self.beHitActionIndex == 0 then
        self:playBeHitCallBack(self.dataTable)
    end
end

function FVCardItem:playAction(actions, callbackActionEnd, dataTable)
    local actionIndex = 0
    if actions.actionm_card then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>1")
        actionIndex = actionIndex + 1
        local function callBack1()
           cclog("FVCardItem:playAction-----------1")
        end        
        self:runAction(cc.Sequence:create({
            actions.actionm_card,
            cc.CallFunc:create(callBack1),            
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 1}),
            }))
    end

    if actions.actionn_card then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>2")
        actionIndex = actionIndex + 1
        local function callBack2()
           cclog("FVCardItem:playAction-----------2")
        end
        self.cardN:runAction(cc.Sequence:create({
            actions.actionn_card,
            cc.CallFunc:create(callBack2),
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 2}),
            }))
    end

    if actions.actiona_card then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>3")        
        actionIndex = actionIndex + 1
        local function callBack3()
           cclog("FVCardItem:playAction-----------3")
        end

        self.cardA:runAction(cc.Sequence:create({
            actions.actiona_card,
            cc.CallFunc:create(callBack3),
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 3}),
            }))
    end

    if actions.actionm_board then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>4")
        actionIndex = actionIndex + 1
        local function callBack4()
           cclog("FVCardItem:playAction-----------4")
        end        
        self.boardM:runAction(cc.Sequence:create({
            actions.actionm_board,
            cc.CallFunc:create(callBack4),
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 1}),
            }))
    end

    if actions.actionn_board then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>5")
        actionIndex = actionIndex + 1
        local function callBack5()
           cclog("FVCardItem:playAction-----------5")
        end        
        self.boardM.boardN:runAction(cc.Sequence:create({
            actions.actionn_board,
            cc.CallFunc:create(callBack5), 
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 1}),
            }))
    end

    if actions.actiona_board then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>6")
        actionIndex = actionIndex + 1
        local function callBack6()
           cclog("FVCardItem:playAction-----------6")
        end        
        self.boardM.boardA:runAction(cc.Sequence:create({
            actions.actiona_board,
            cc.CallFunc:create(callBack6),            
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 1}),
            }))
    end

    if actions.actionm_hero then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>7")
        actionIndex = actionIndex + 1
        local function callBack7()
           cclog("FVCardItem:playAction-----------7")
        end          
        self.heroM:runAction(cc.Sequence:create({
            actions.actionm_hero,
            cc.CallFunc:create(callBack7),            
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 1}),
            }))
    end

    if actions.actionn_hero then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>8")        
        actionIndex = actionIndex + 1
        local function callBack8()
           cclog("FVCardItem:playAction-----------8")
        end         
        self.heroM.heroN:runAction(cc.Sequence:create({
            actions.actionn_hero,
            cc.CallFunc:create(callBack8),            
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 1}),
            }))
    end

    if actions.actiona_hero then
        cclog("FVCardItem:playAction>>>>>>>>>>>>>>9")        
        actionIndex = actionIndex + 1
        local function callBack9()
           cclog("FVCardItem:playAction-----------9")
        end         
        self.heroM.heroA:runAction(cc.Sequence:create({
            actions.actiona_hero,
            cc.CallFunc:create(callBack9),            
            cc.CallFunc:create(callbackActionEnd, {dataTable = dataTable, actionType = 1}),
            }))
    end
    return actionIndex 
end

function FVCardItem:playActionKillover(time)
    timer.delayGlobal(function()

        local boarda = mvc.ViewClippingNode()
        local boardb = mvc.ViewClippingNode()
        
        local boarda_clip = mvc.ViewSprite("res/card/clip.png")
        local boardb_clip = mvc.ViewSprite("res/card/clip.png")
        
        local boarda_board = mvc.ViewSprite(self.boardM.boardN:getSpriteFrame())
        local boardb_board = mvc.ViewSprite(self.boardM.boardN:getSpriteFrame())
    
        boarda:addChild(boarda_board)
        boardb:addChild(boardb_board)
    
        boarda:setInverted(true)
        boardb:setInverted(false)
        boarda:setAlphaThreshold(0.5)
        boardb:setAlphaThreshold(0.5)
        boarda:setStencil(boarda_clip)
        boardb:setStencil(boardb_clip)
    
        self.boardM.boardN:setVisible(false)
        self.boardM:addChild(boarda)
        self.boardM:addChild(boardb)
    
        local heroa_hero = mvc.ViewSprite(self.heroM.heroN:getSpriteFrame())
        local herob_hero = mvc.ViewSprite(self.heroM.heroN:getSpriteFrame())
    
        heroa_hero:setPosition(CONFIG_CARD_HERO_X, CONFIG_CARD_HERO_Y)
        herob_hero:setPosition(CONFIG_CARD_HERO_X, CONFIG_CARD_HERO_Y)
    
        local heroa = mvc.ViewClippingNode()
        local herob = mvc.ViewClippingNode()

        heroa:addChild(heroa_hero)
        herob:addChild(herob_hero)

        local heroa_clip = mvc.ViewSprite("res/card/clip.png")
        local herob_clip = mvc.ViewSprite("res/card/clip.png")
        local effecta = self.heroM.heroN:getChildByTag(1)
        local effectb = self.heroM.heroN:getChildByTag(2)

        if effecta then
            local heroa_effecta = mvc.ViewSprite(effecta:getSpriteFrame())
            local herob_effecta = mvc.ViewSprite(effecta:getSpriteFrame())
            heroa_effecta:setPosition(CONFIG_CARD_EFFECTA_X, CONFIG_CARD_EFFECTA_Y)
            herob_effecta:setPosition(CONFIG_CARD_EFFECTA_X, CONFIG_CARD_EFFECTA_Y)
            heroa_hero:addChild(heroa_effecta, 1)
            herob_hero:addChild(herob_effecta, 1)
        end

        if effectb then
            local heroa_effectb = mvc.ViewSprite(effectb:getSpriteFrame())
            local herob_effectb = mvc.ViewSprite(effectb:getSpriteFrame())
            heroa_effectb:setPosition(CONFIG_CARD_EFFECTB_X, CONFIG_CARD_EFFECTB_Y)
            herob_effectb:setPosition(CONFIG_CARD_EFFECTB_X, CONFIG_CARD_EFFECTB_Y)
            heroa_hero:addChild(heroa_effectb, -1)
            herob_hero:addChild(herob_effectb, -1)
        end

        heroa:setInverted(true)
        herob:setInverted(false)
        heroa:setAlphaThreshold(0.5)
        herob:setAlphaThreshold(0.5)
        heroa:setStencil(heroa_clip)
        herob:setStencil(herob_clip)
    
        self.heroM.heroN:setVisible(false)
        self.heroM:addChild(heroa)
        self.heroM:addChild(herob)

        boarda:runAction(cc.Sequence:create({
            cc.DelayTime:create(time * CONFIG_KO_SLOW),
            cc.EaseOut:create(cc.Spawn:create({
                cc.MoveBy:create(0.5 * CONFIG_KO_SLOW, cc.p(-10, 25)),
                cc.RotateBy:create(0.5 * CONFIG_KO_SLOW, -5)
                }), 10),
            }))
        boardb:runAction(cc.Sequence:create({
            cc.DelayTime:create(time * CONFIG_KO_SLOW),
            cc.EaseOut:create(cc.Spawn:create({
                cc.MoveBy:create(0.5 * CONFIG_KO_SLOW, cc.p(10, -25)),
                cc.RotateBy:create(0.5 * CONFIG_KO_SLOW, 5)
                }), 10),
            }))
        heroa:runAction(cc.Sequence:create({
            cc.EaseOut:create(cc.Spawn:create({
                cc.MoveBy:create((time + 0.7) * CONFIG_KO_SLOW, cc.p(-20, 50)),
                cc.RotateBy:create((time + 0.7) * CONFIG_KO_SLOW, -10)
                }), 10),
            }))

        local function callBack()
            self.target:onKillOverOver()
        end

        herob:runAction(cc.Sequence:create({
            cc.EaseOut:create(cc.Spawn:create({
                cc.MoveBy:create((time + 0.7) * CONFIG_KO_SLOW, cc.p(20, -50)),
                cc.RotateBy:create((time + 0.7) * CONFIG_KO_SLOW, 10)
                }), 10),
            cc.CallFunc:create(callBack)
            }))
    end, 1.5)
end

function FVCardItem:onAttackActionEnd()
    self.attackActionIndex = self.attackActionIndex - 1
    cclog("FVCardItem::onAttackActionEnd==========self.attackActionIndex=====>" .. self.attackActionIndex)
    if self.attackActionIndex == 0 then
        self:setCardClean()
        self:playAttackCallBack()
    end
end

function FVCardItem:playAttackCallBack()
    self.attackActionIndex = 0
    self.target:onPlayAttackFinish()
end

function FVCardItem:onBeHitActionEnd(dataTable)
    self.beHitActionIndex = self.beHitActionIndex - 1
    --print("onBeHitActionEnd:::::self.beHitActionIndex=====" .. self.beHitActionIndex)
    if self.beHitActionIndex == 0 then
        self:setCardClean()
        self:playBeHitCallBack(dataTable)
    end
end

function FVCardItem:playBeHitCallBack(dataTable)
    self.beHitActionIndex = 0
    self.target:onBeHitCallBack(dataTable)
end

function FVCardItem:isShowEffect(state)
    self.heroM:isShowEffect(state)
end

function FVCardItem:updateAnger(dataTable)
    self.state:updateAnger(dataTable)
end

function FVCardItem:playActionState(unit)
    self.state:playActionState(unit)
end

function FVCardItem:removeBuffs(unit,buff)
    self.state:removeBuffs(unit,buff)
end

--主卡播放入场动画
function FVCardItem:doActionPrelude()
    if self.chief == false then
        return
    end
    self:setVisible(true)
    self:setPosition(320, 480)
    self:setScale(1)

    self.boardM:setPositionX(self.boardM:getPositionX() - 600)
    self.heroM:setPositionX(self.heroM:getPositionX() + 600)
    self.state:setPositionX(self.state:getPositionX() - 600)

    self.boardM:runAction(cc.Sequence:create({
        cc.EaseBackOut:create(
            cc.MoveBy:create(0.3, cc.p(600, 0))
            ),
        }))
    self.heroM:runAction(cc.Sequence:create({
        cc.DelayTime:create(0.1),
        cc.EaseBackOut:create(
            cc.MoveBy:create(0.3, cc.p(-600, 0))
            ),
        }))
    self.state:runAction(cc.Sequence:create({
        cc.DelayTime:create(0.2),
        cc.EaseBackOut:create(
            cc.MoveBy:create(0.3, cc.p(600, 0))
            ),
        cc.CallFunc:create(function()
            local part = getFVParticleManager():make("fgblue1", 0.2, false)
            --part:setPosition(-100, -125)
            part:setPosition(-59, -115)
            self:addChild(part, 100)
        end),
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(function() 
            self.state.kind:setVisible(true)
            end)
        }))

    self.state.hp:setPercentage(0)
    self.state.hp:runAction(cc.ProgressTo:create(0.7, 100))

    local time = 0.2
    local spawnAction = cc.Spawn:create(
            cc.MoveTo:create(0.16, self.home.point),
            --cc.ScaleTo:create(0.1, 1.2)
            cc.Sequence:create(
                cc.EaseSineOut:create(cc.ScaleTo:create(0.16, 1.5)),
                cc.EaseSineInOut:create(cc.ScaleTo:create(0.04, self.home.scale))
                )
            )
    self:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.81),
            cc.EaseIn:create(cc.EaseBackOut:create(spawnAction), 8)
        )
    )
end

function FVCardItem:startAwake()
    local dur = 0.1
    local actionTable = {}
    local action1 = cc.OrbitCamera:create(dur, 1, 0, 0, 50, 0, 0)
    local action2 = cc.OrbitCamera:create(dur, 1, 0, 50, -100, 0, 0)

    table.insert(actionTable, action1)
    table.insert(actionTable, action2)

    local times = 3
    for i = 1, times do
        local action3 = cc.OrbitCamera:create(dur, 1, 0, -50, 100, 0, 0)
        local action4 = cc.OrbitCamera:create(dur, 1, 0, 50, -100, 0, 0)
        table.insert(actionTable, action3)
        table.insert(actionTable, action4)
    end
    local action3 = cc.OrbitCamera:create(dur, 1, 0, -50, 50, 0, 0)
    table.insert(actionTable, action3)

    local upTime = 0.2
    local moveToAction = cc.MoveBy:create(upTime, cc.p(0, 20))
    local scaleToAction = cc.ScaleTo:create(upTime, 0.8)
    local sequenceAction = cc.Sequence:create(actionTable)
    local spawnAction = cc.Spawn:create(moveToAction, scaleToAction)

    local delatAction = cc.DelayTime:create(0.1)
    self:runAction(cc.Sequence:create(spawnAction, delatAction, sequenceAction, cc.RemoveSelf:create(true)))
    -- local function callBack(card)
    --     card:setAdditionalTransform({a = 1, b = 0, c = 0, d = 1, tx = 0, ty = 0})
    -- end
    -- local action1 = cc.OrbitCamera:create(4, 1, 0, 0, 90, 0, 0)
    -- local action2 = cc.OrbitCamera:create(4, 1, 0, 90, 180, 0, 0)
    -- local action3 = cc.OrbitCamera:create(4, 1, 0, 180, 270, 0, 0)
    -- local action4 = cc.OrbitCamera:create(4, 1, 0, 270, 360, 0, 0)
    -- local sequenceAction = cc.Sequence:create(action1, action2, cc.CallFunc:create(callBack))
    -- self:runAction(cc.RepeatForever:create(sequenceAction))
end

function FVCardItem:enterAwake()
    self:setScale(0.75)
    local time = 0.05
    self:setPosition(self.home.point.x, self.home.point.y + 20)
    local scaleToAction = cc.ScaleTo:create(time, self.home.scale)
    local moveToAction = cc.MoveBy:create(time, cc.p(0, -20))
    local action = cc.EaseIn:create(scaleToAction, 2.5)

    local spawnAction = cc.Spawn:create(action, moveToAction)
    local delatAction = cc.DelayTime:create(0.3)
    self:runAction(cc.Sequence:create(delatAction, spawnAction))
end

function FVCardItem:addBossEffect()
    self.heroM:addBossEffect()
end

return FVCardItem










