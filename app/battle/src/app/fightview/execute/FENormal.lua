local BaseExe = import(".BaseExe")
local FENormal = class("FENormal", BaseExe)

function FENormal:ctor()
    FENormal.super.ctor(self, id)
    self.fvAction = getFVAction()
    self.actionUtil = getActionUtil()
    self.fightUtil = getFightUitl()
    self.fvActionSpec = getFVActionSpec()
    self.fvParticleManager = getFVParticleManager()
    self.audioManager = getAudioManager()
    self.tempFightData = getTempFightData()
    self.target = nil
    self.actionRound = nil
    self.is_play_remove_action = false
end

-- 开始回合
function FENormal:startRound(target, round)
    cclog("FENormal:startRound=================>step1")
    self.actionRound = round

    self.skillStage = round.skillStage --Skill Stage
    self.before_buffs = round.before_buffs --战前Buff
    self.after_buffs = round.after_buffs    --战后Buffs

    self.attacker = round.attacker
    self.target = target
    self.buffIndex = 0

    self.beforeBuffIndex = 0
    self.afterBuffIndex = 0

    self.actionIdxAttack = 0
    self.maxBeforeBuffs = table.nums(self.before_buffs)
    self.maxafterBuff = table.nums(self.after_buffs)

    self.buffs = round.buffs

    print(self.buffs, "FENormal:=========")
    self.maxBuffs = table.nums(self.buffs)

    -- self:onRunBeforeBuffs()
    self.onRunBuffCallBack = function ()
        self:onDisplayStepResult()
        self:onStepRoundEnd()
    end
    self:onRunBuffs()
end

--执行回合前Buffs
function FENormal:startBeforeBuffs(target, round)
    print("onRunBeforeBuffs=================>")

    self.actionRound = round
    self.attacker = round.attacker
    self.skillStage = round.skillStage --Skill Stage
    self.target = target
    -- self:onRunRemoveBuff(self.beforeBuffIndex,self.maxBeforeBuffs,self.before_buffs,function ()
    --     self:onRunBuffs()
    -- end)
    self.is_play_remove_action = true

    self.remove_Buffs = round.before_buffs

    print("FENormal:startBeforeBuffs=------------->")
    for k,v in pairs(round.before_buffs) do
        print("buffid:==============>",v.buff_info.id)
    end

    self.removeIndex = 0
    self.removeMaxIndex = table.nums(self.remove_Buffs)

    self.removeCallBack = function ()
        self:doDispatchEvent(const.EVENT_END_BEFORE_BUFFS)
    end
    self:onPlayRemoveBuffs()
end

function FENormal:onPlayRemoveBuffs()
    if self.removeIndex + 1 > self.removeMaxIndex  then 
        self.is_play_remove_action = false
        if self.removeCallBack ~= nil then
            self.removeCallBack()
        end
        return
    end
    self.removeIndex = self.removeIndex + 1
    local buff = self.remove_Buffs[self.removeIndex]
    print("Remove Actions=======================",buff.buff_info.effectId)
    local has_play = false
    if table.inv({3,8,9,26,27},buff.buff_info.effectId) then
        if table.nums(buff.actions) > 0 then
            self.actionIdxAttack = 1
            
            self:playHit(buff,buff.target_infos[1])
            is_play_remove_buffs = true
            has_play = true
        end
        --回调等动作执行完成
    end
    self:doDispatchEvent(const.EVENT_REMOVE_HERO_BUFF,buff)
    if not has_play then
        self:onPlayRemoveBuffs()
    end
    -- self:onRunRemoveBuff(bi,mb,buffs,callBack)
    -- self:onRunRemoveBuff(self.removeIndex,self.removeMaxIndex,self.remove_Buffs,self.removeCallBack)
end

--执行回合后Buffs
function FENormal:onRunAfterBuffs()


    print("onRunAfterBuffs=================>",self.maxafterBuff )
    self.is_play_remove_action = true
    self.removeIndex = self.afterBuffIndex
    self.removeMaxIndex = self.maxafterBuff
    self.remove_Buffs = self.after_buffs
    self.removeCallBack = function ()
        self:onStepRoundEnd()
    end
    self:onPlayRemoveBuffs()
    -- self:onStepRoundEnd()
    -- self:onRunRemoveBuff(self.afterBuffIndex,self.maxafterBuff,self.after_buffs,function ()
    --     self:onStepRoundEnd()
    -- end)
end

function print_buff(buff)
    print("buffid"..buff.buff_info.id)
    print("len of target_units-----")
    print(table.nums(buff.target_infos))
    print("viewAction========")
    -- table.print(buff.actions[1])
end

function FENormal:onRunBuffs()
    print("onRunBuffs======", self.maxBuffs)
    if self.buffIndex + 1 > self.maxBuffs then
        if self.onRunBuffCallBack ~= nil then
            self.onRunBuffCallBack()
        else
            print("self.onRunBuffCallBack is nil ")
        end
        return
    end    
    self.buffIndex = self.buffIndex + 1
    print("FENormal:onRunBuffs===========>buffIndex="..self.buffIndex..",maxBuffs="..self.maxBuffs)       
    self.actionIdxAttack = 0
    self.actionsMaxValue = 0
    local buff = self.buffs[self.buffIndex]
    self.actionsMaxValue = table.nums(buff.actions)--每个buff中得action数量    
    self.onRunActionCallBack = function ()
        self:doFinalHarm()
        self:onRunBuffs()
    end
    self:onRunActions()
end

function FENormal:onRunActions()   
    cclog("FENormal:onRunActions===========>actionIdxAttack="..self.actionIdxAttack..",actionsMaxValue="..self.actionsMaxValue)  
    if self.actionIdxAttack + 1 > self.actionsMaxValue then
        if self.onRunActionCallBack ~= nil then
            self.onRunActionCallBack()
        end
        return
    end      
    self.actionIdxAttack = self.actionIdxAttack + 1
       
    local buff = self.buffs[self.buffIndex]
    self.beHitHeroNum = table.nums(buff.target_infos)
    print("FENormal:onRunActions=======>target_num == ",self.beHitHeroNum,"   buffId==",buff.buff_info.id)
    if self.beHitHeroNum == 0 then
        cclog("FENormal:onRunActions=======>target_num == 0")
        self:onRunBuffs()        
        return 
    end 
    self:playBuff(buff)
end

function FENormal:playBuff(buff)
    print("buffid"..buff.buff_info.id,"TargeInfos:",#buff.target_infos)
    local viewTargetPos = buff.viewTargetPos
    if viewTargetPos == TYPE_NORMAL_POS then
        for _, target in pairs(buff.target_infos) do
            -- local targetPos = self:getTargetPos(target.target_unit, viewTargetPos)
            self:playHit(buff, target)
        end
    else
        -- local targetPos = self:getTargetPos(buff.target_infos[1].target_unit, viewTargetPos)
        self:playHit(buff, buff.target_infos[1])
    end
end

--播放开场Buff
function FENormal:playFightBuff(buff)
    print("FENormal:playFightBuff=========>",buff.buff_info.id)
    self.actionsMaxValue = table.nums(buff.actions)--每个buff中得action数量 

    self.actionIdxAttack = 0
    self.buffIndex = 1
    self.maxBuffs = 1
    self.buffs = {}
    self.attacker = buff.attacker
    table.insert(self.buffs,buff)
    self.onRunActionCallBack = nil
    self.onRunBuffCallBack = nil
    self:onRunActions()
end

-- 播放攻击动画, 一个action
function FENormal:playHit(buff, target_info)
    local viewTargetPos = buff.viewTargetPos
    local targetPos = self:getTargetPos(target_info.target_unit, viewTargetPos)


    print("FENormal:playHit=================>step2","PlayHit Side:"..self.attacker.side)
    local curAction = buff.actions[self.actionIdxAttack]
    local attackAction = curAction.attack
    local delayTime = curAction.delta / ACTION_SPEED
    local buffNo = buff.buff_info.id
    -- table.print(curAction)

    print("FENormal:playHit===================>buff="..buffNo..", action="..attackAction)
    self.audioManager:playBufffAudio(buffNo)
    self.beHitFinish = false
    self.isBeingAttack = true

    if self.actionIdxAttack == 1 then self:doDispatchEvent(const.EVENT_ATTACK_ITEM_START, self.attacker.viewPos) end
    local function callBack(sender, buff)
        self:playBeHit(buff, target_info) 
    end

    self.fightUtil:runDelayAction(callBack, delayTime, buff)

--组织actions
    local ack = nil    
    if self.attacker.side == "red" then
        ack = self.fvAction:makeActionFront(attackAction, targetPos, self.attacker.HOME)
    else
        local data={}
        data.actEffect = buff.buff_info.actEffect
        data.no = attackAction
        data.target_pos = targetPos
        data.home = self.attacker.HOME
        ack = self.fvAction:makeActionHind(data)
    end
    self:doDispatchEvent(const.EVENT_PLAY_ATTACK_ACTION, self.attacker, ack)
    --添加连击显示消息
    -- if self.actionsMaxValue > 1 and self.actionIdxAttack <= self.actionsMaxValue then
    --     self:doDispatchEvent(const.EVENT_SHOW_COMBO, self.actionIdxAttack)
    -- end          
end

-- 播放被击动画
-- buff 当前buff
function FENormal:playBeHit(buff, target_info)
    cclog("FENormal:playBeHit=============>step4")
    local viewTargetPos = buff.viewTargetPos
    local targetPos = self:getTargetPos(target_info.target_unit, viewTargetPos)
    local actEffect = buff.buff_info.actEffect
    
    local buffNo = buff.buff_info.id
    local target_infos = buff.target_infos
    local action = buff.actions[self.actionIdxAttack]

    self.combo = false
    -- if action == nil then
    --     return
    -- end
    if action.digit ~= nil then --有分段数值
        local index = 1
        if #action.digit > 1 then --连击
            local lastTime = 0
            function playDigit()
                if index <= #action.digit then
                    vd = action.digit[index]
                    self:doDispatchEvent(const.EVENT_CARD_DIGIT_NUM,{
                        pos = target_info.target_unit.viewPos,location = target_info.target_unit.HOME.point,targetInfo = {value = target_info.value * vd[2],time = vd[1] - lastTime}
                        })
                    if index > 1 then
                        self:doDispatchEvent(const.EVENT_SHOW_COMBO, index)
                        self.combo = true
                    end
                    index = index + 1
                    self.fightUtil:runDelayAction(playDigit, (vd[1] -lastTime) / ACTION_SPEED)
                    lastTime = vd[1]
                end
            end

            playDigit()
        end
    end

    for k, target_info in pairs(target_infos) do
        local target_unit = target_info.target_unit
        local viewPos = target_unit.viewPos
        if actionIndex == 1 then self:doDispatchEvent(const.EVENT_HIT_ITEM_START, viewPos) end

        local digit = nil

        local dataTable = {}
        dataTable.target_unit = target_unit
        local hit = nil
        if target_info.is_hit then
            if target_info.is_block or action == nil then
                hit = "bb0007"
            else
                hit = action.hit
            end
        else
            hit = "bb0005"
        end
        hit = string.trim(hit) --有可能服务配置的有空格，要去掉
        if self.attacker.side == "red" then
            ack = self.fvAction:makeActionFront(hit, targetPos, target_unit.HOME)
        else
            local data={}
            data.actEffect = buff.buff_info.actEffect
            data.no = hit
            data.target_pos = targetPos
            data.home = target_unit.HOME
            ack = self.fvAction:makeActionHind(data)
        end
        dataTable.beAction = ack
        if action.digit == nil or #action.digit <= 1 then
            self:doDispatchEvent(const.EVENT_PLAY_HIT_IMPACT, buff.buff_info, target_info)
        end                
        self:doDispatchEvent(const.EVENT_PLAY_BE_HIT_ACT, dataTable)                       
    end    
end


function FENormal:getTargetPos(target, viewTargetPos)
    if target.side == "red" then
        if viewTargetPos == TYPE_NORMAL_POS then
            return target.HOME.point
        elseif viewTargetPos == TYPE_FRONT_ROW then
            return const.HOME_ARMY[2].point
        elseif viewTargetPos == TYPE_BACK_ROW then
            return const.HOME_ARMY[5].point
        elseif viewTargetPos == TYPE_FIRST_COLUMN then
            return const.HOME_ARMY[1].point
        elseif viewTargetPos == TYPE_SECOND_COLUMN then
            return const.HOME_ARMY[2].point
        elseif viewTargetPos == TYPE_THIRD_COLUMN then
            return const.HOME_ARMY[3].point
        elseif viewTargetPos == TYPE_ALL_POS then
            return const.POS_ARMY
        end
    elseif target.side == "blue" then
        if viewTargetPos == TYPE_NORMAL_POS then
            return target.HOME.point
        elseif viewTargetPos == TYPE_FRONT_ROW then
            return const.HOME_ENEMY[2].point
        elseif viewTargetPos == TYPE_BACK_ROW then
            return const.HOME_ENEMY[5].point
        elseif viewTargetPos == TYPE_FIRST_COLUMN then

            return const.HOME_ENEMY[1].point
        elseif viewTargetPos == TYPE_SECOND_COLUMN then

            return const.HOME_ENEMY[2].point
        elseif viewTargetPos == TYPE_THIRD_COLUMN then

            return const.HOME_ENEMY[3].point
        elseif viewTargetPos == TYPE_ALL_POS then
            return const.POS_ENEMY
        end
    end
end
return FENormal
