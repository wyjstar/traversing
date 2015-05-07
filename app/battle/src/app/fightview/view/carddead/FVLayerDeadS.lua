-- 死亡卡牌特效
local FVLayerDeadS = class("FVLayerDeadS", mvc.ViewBase)

function FVLayerDeadS:ctor(id)
    FVLayerDeadS.super.ctor(self, id)
    self.fvParticleManager = getFVParticleManager()
end

function FVLayerDeadS:onMVCEnter()
    self:listenEvent(const.EVENT_PLAY_DEAD_ANI, self.playDead, nil)
    
end

function FVLayerDeadS:playDead(target_unit, isplay)
    cclog("--FVLayerDeadS:playDeadArmy----")

    if isplay then
        getAudioManager():playHeroDeadAudio(target_unit.no)
    end

    local home = target_unit.HOME

    local function addCallBack(sender)
        local part1 = getFVParticleManager():make("sw01", 2, false)
        local part2 = getFVParticleManager():make("sw02", 1, false) 
        part1:setPosition(home.point)
        part2:setPosition(home.point)
        part1:setScale(home.scale * 4)
        part2:setScale(home.scale * 4)
        sender:addChild(part1)
        sender:addChild(part2)
    end

    local delayAction1 = cc.DelayTime:create(0.2)
    local delayAction2 = cc.DelayTime:create(0.2)
    local sequenceAction = cc.Sequence:create(delayAction1, cc.CallFunc:create(addCallBack))

    self:runAction(sequenceAction)
end

return FVLayerDeadS
