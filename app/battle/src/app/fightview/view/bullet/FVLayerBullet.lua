
local FVLayerBullet = class("FVLayerBullet", mvc.ViewBase)

function FVLayerBullet:ctor(id)
    FVLayerBullet.super.ctor(self, id)

end

function FVLayerBullet:onMVCEnter()
    --播放攻击动作
    self:listenEvent(const.EVENT_PLAY_ATTACK_ACTION, self.playAttackItem, nil)
    --播放被击动画
    self:listenEvent(const.EVENT_PLAY_BE_HIT_ACT, self.playHit, nil)
    
end

function FVLayerBullet:makeBullet(sprite, actionm, actionn, actiona)
    local nAction = 0

    local function callbackActionEnd(card)

        nAction = nAction - 1

        if nAction == 0 then
            timer.delayAction(function(card)
                card:removeFromParent(true)
                --print("removeFromParent------------")
            end, card, nil, 1)
        end
    end

    if actionm then
        nAction = nAction + 1
        sprite:runAction(cc.Sequence:create({
            actionm,
            cc.CallFunc:create(callbackActionEnd),
            }))
    end

    if actionn then
        nAction = nAction + 1
        sprite:runAction(cc.Sequence:create({
            actionn,
            cc.CallFunc:create(callbackActionEnd),
            }))
    end

    if actiona then
        nAction = nAction + 1
        sprite:runAction(cc.Sequence:create({
            actiona,
            cc.CallFunc:create(callbackActionEnd),
            }))
    end
end

function FVLayerBullet:playAttackItem(target, actions)
    local point = target.HOME.point
    if actions.actionm_bullet1 or actions.actionn_bullet1 or actions.actiona_bullet1 then
        cclog("FVLayerBullet:playAttackItem==============>1")
        local sprite = mvc.ViewSprite()

        sprite:setPosition(point)

        self:makeBullet(sprite, actions.actionm_bullet1, actions.actionn_bullet1, actions.actiona_bullet1)

        self:addChild(sprite, 3)
    end

    if actions.actionm_bullet2 or actions.actionn_bullet2 or actions.actiona_bullet2 then
        cclog("FVLayerBullet:playAttackItem==============>2")        
        local sprite = mvc.ViewSprite()

        sprite:setPosition(point)

        self:makeBullet(sprite, actions.actionm_bullet2, actions.actionn_bullet2, actions.actiona_bullet2)

        self:addChild(sprite, 2)
    end

    if actions.actionm_bullet3 or actions.actionn_bullet3 or actions.actiona_bullet3 then
        cclog("FVLayerBullet:playAttackItem==============>3")        
        local sprite = mvc.ViewSprite()

        sprite:setPosition(point)

        self:makeBullet(sprite, actions.actionm_bullet3, actions.actionn_bullet3, actions.actiona_bullet3)

        self:addChild(sprite,1)
    end
end

function FVLayerBullet:playHit(dataTable)
    local point = dataTable.target_unit.HOME.point
    local action = dataTable.beAction

    if action.actionm_bullet1 or action.actionn_bullet1 or action.actiona_bullet1 then
        local sprite = mvc.ViewSprite()

        sprite:setPosition(point)

        self:makeBullet(sprite, action.actionm_bullet1, action.actionn_bullet1, action.actiona_bullet1)

        self:addChild(sprite, 3)
    end

    if action.actionm_bullet2 or action.actionn_bullet2 or action.actiona_bullet2 then
        local sprite = mvc.ViewSprite()

        sprite:setPosition(point)

        self:makeBullet(sprite, action.actionm_bullet2, action.actionn_bullet2, action.actiona_bullet2)

        self:addChild(sprite, 2)
    end

    if action.actionm_bullet3 or action.actionn_bullet3 or action.actiona_bullet3 then
        local sprite = mvc.ViewSprite()

        sprite:setPosition(point)

        self:makeBullet(sprite, action.actionm_bullet3, action.actionn_bullet3, action.actiona_bullet3)

        self:addChild(sprite, 1)
    end
end

return FVLayerBullet
