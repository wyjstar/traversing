
local FVFriend = class("FVFriend", function()
    return game.newNode()
end)

function FVFriend:ctor(id)
    self.target = nil
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.process = getFCProcess()
    self.fightUitl = getFightUitl()
end

function FVFriend:setTarget(target)
    self.target = target
end

function FVFriend:loadFriendCCBI()
    self.UIAniFriendView = {}
    local proxy = cc.CCBProxy:create()
    self.friendView = CCBReaderLoad("effect/ui_friend.ccbi", proxy, self.UIAniFriendView)

    self.shieldlayer = game.createShieldLayer()
    self.friendView:addChild(self.shieldlayer)
    self.shieldlayer:setTouchEnabled(true)
    self:addChild(self.friendView)

    local function removeCallBack()
        self.shieldlayer:setTouchEnabled(false)
        self.friendView:removeFromParent(true)
    end
    local function startBoddyFightCallBack()
        --self:dispatchEvent(const.EVENT_BUDDY_ATTACK)
    end

    local delayAction1 = cc.DelayTime:create(2)
    local delayAction2 = cc.DelayTime:create(1.8)


    local sequenceAction1 = cc.Sequence:create(delayAction1, cc.CallFunc:create(removeCallBack))
    local sequenceAction2 = cc.Sequence:create(delayAction2, cc.CallFunc:create(startBoddyFightCallBack))
    local swanAction = cc.Spawn:create(sequenceAction1, sequenceAction2)
    self:runAction(swanAction)

    ------
    local delayAction3 = cc.DelayTime:create(0.36)
    local function shakeCallBack1()
        getFightScene():runSceneShake(2)
    end
    sequenceAction = cc.Sequence:create(delayAction3, cc.CallFunc:create(shakeCallBack1))
    self:runAction(sequenceAction)

    ---------
    local delayAction4 = cc.DelayTime:create(0.93)

    local function shakeCallBack2()
        getFightScene():runSceneShake(3)
    end

    sequenceAction = cc.Sequence:create(delayAction4, cc.CallFunc:create(shakeCallBack2))
    self:runAction(sequenceAction)

    local delayAction5 = cc.DelayTime:create(0.36)

    local function callBack5()
        self:startFriendIn()
    end
    --local delayAction6 = cc.DelayTime:create(0.06)
    local delayAction6 = cc.DelayTime:create(1.38)
    local function callBack6()
        self.target:onFriendAniOver()
        self.friendNode:removeFromParent(true)
    end

    sequenceAction = cc.Sequence:create(delayAction5, cc.CallFunc:create(callBack5),
        delayAction6, cc.CallFunc:create(callBack6))
    self:runAction(sequenceAction)
end

function FVFriend:startFriendIn()
    local friend = self.process.buddy_skill.unit
    local time1 = 0.06
    local time2 = 0.02
    -- local time1 = 5
    -- local time2 = 5
    local scaleTo1 = cc.ScaleTo:create(0, 1.5)
    local scaleTo2 = cc.ScaleTo:create(time1, 2)
    local moveTo1 = cc.MoveTo:create(time1, cc.p(320, 80))
    local easeOutMoveTo1 = cc.EaseOut:create(moveTo1, 1)
    local moveTo2 = cc.MoveTo:create(time2, cc.p(320, 260))
    local easeOutMoveTo2 = cc.EaseOut:create(moveTo2, 1)
    local scaleTo = cc.ScaleTo:create(time2, 0.8)


    local spawnAction1 = cc.Spawn:create(easeOutMoveTo1, scaleTo2)
    local spawnAction = cc.Spawn:create(easeOutMoveTo2, scaleTo)

    -- local delayTimeAction = cc.DelayTime:create(0.36)
    local heroId = friend.no
    local point = cc.p(320, -200)
    self.friendNode = self.fightUitl:createHero(heroId, point)
    self:addChild(self.friendNode)

    local sequenceAction = cc.Sequence:create(scaleTo1, spawnAction1, spawnAction)
    self.friendNode:runAction(sequenceAction)
end

return FVFriend






