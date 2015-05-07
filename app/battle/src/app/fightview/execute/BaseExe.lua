
local BaseExe = class("BaseExe")

function BaseExe:ctor(id)
    -- self.process = getFMProcess()
    self.isBeingAttack = false
    self.isBeingOver = false
    self.isBeHitOver = false
    self.beHitFinish = false
end

function BaseExe:doDispatchEvent(k1, ...)
    if self.target then
        self.target:dispatchEvent(k1, ...)
    end
end


--处理身上的效果
function BaseExe:performEffect()
    -- cclog("BaseExe:performEffect===================>")
    -- local buff = self:currentBuff()
    -- local target_infos = buff.target_infos
    -- for _, target_info in pairs(target_infos) do
    --     self:doDispatchEvent(const.EVENT_PLAY_HIT_IMPACT, buff.buff_info, target_info)
    -- end
end

function BaseExe:performEmptyImpach()
    self:performEffect()
    self.target:performEmptyImpach()
end

function BaseExe:onBeHitFinish()

    if self.is_play_remove_action then
        self:onPlayRemoveBuffs()
    else
        self.beHitHeroNum = self.beHitHeroNum - 1
        cclog("BaseExe:onBeHitFinish=============>self.beHitHeroNum=%d", self.beHitHeroNum)
        if self.beHitHeroNum <= 0 then
            cclog("BaseExe:onBeHitFinish================>step6")
            self.beHitFinish = true
            if self.isBeingAttack == false then       
                self:onRunActions()
            end
        end

    end
end

function BaseExe:heroPlayAttackFinish(dataTable)
    cclog("BaseExe:heroPlayAttackFinish================>step5")
    self.isBeingAttack = false
    if self.beHitFinish then
        -- self:doDispatchEvent(const.EVENT_ATTACK_ITEM_STOP, self.attacker.viewPos)
        self.beHitFinish = false
        self:onRunActions()
    end

end

--处理状态显示
--应该在执行AfterBuff之前
function BaseExe:onDisplayStepResult()
    cclog("BaseExe:onDisplayStepResult==================>")   
    if #self.buffs > 0 then 
        for k, v in pairs(self.buffs) do
            for _, target_info in pairs(v.target_infos) do
                self:doDispatchEvent(const.EVENT_HIT_ITEM_STOP, target_info.target_unit.viewPos)
                print("viewPos:",target_info.target_unit.viewPos)
            end

            self:doDispatchEvent(const.EVENT_BUFF_END, v, self.attacker)
            
        end

        -------------------------------------------
        if self.actionRound.skillType == TYPE_UNPARAL then
            self:doDispatchEvent(const.EVENT_UNPATA_STOP)
        end
    end
    
end


--一个step结束
function BaseExe:onStepRoundEnd()
    cclog("BaseExe:onStepRoundEnd==================>")    
    -- stop action
 
    self:doDispatchEvent(const.EVENT_ROUND_END, self:currentBuff(), self.attacker)
end

--最终伤害，当是由多个连击造成 的伤害时
function BaseExe:doFinalHarm()
    cclog("BaseExe:doFinalHarm==================>")
    if self.actionsMaxValue == 0 then
        return
    end

    local buff = self:currentBuff() 
    --不是连击不处理
    if not self.combo then return end
    print("combo actions.......")
    table.print(buff.actions)
    --所有目标
    local target_infos = buff.target_infos
    for _, target_info in pairs(target_infos) do
        target_info.is_combo = true
        self:doDispatchEvent(const.EVENT_PLAY_HIT_IMPACT, buff.buff_info, target_info)
    end
end

function BaseExe:createDigit() 
    local result = {}
    result[1] = {0.2, 1, 1}
    return result
end
-- 当前action
function BaseExe:currentAction()
    cclog("BaseExe:currentAction======>self.buffIndex.."..self.buffIndex..", self.attackActionIndex.."..self.actionIdxAttack)
    return self.buffs[self.buffIndex].actions[self.actionIdxAttack]
end
-- 当前buff
function BaseExe:currentBuff()
    print("currentBuffIndex:",self.buffIndex)
    return self.buffs[self.buffIndex]
end

return BaseExe
