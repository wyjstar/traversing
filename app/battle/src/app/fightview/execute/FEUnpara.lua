local BaseExe = import(".BaseExe")
local FEUnpara = class("FEUnpara", BaseExe)

function FEUnpara:ctor()
    FEUnpara.super.ctor(self, id)
    self.fvAction = getFVAction()
    self.actionUtil = getActionUtil()
    self.fvActionSpec = getFVActionSpec()
    self.fvParticleManager = getFVParticleManager()
    self.audioManager = getAudioManager()
    self.fightUtil = getFightUitl()
    self.tempFightData = getTempFightData()
    self.target = nil
    self.actionRound = {}
end

function FEUnpara:playUnparaRoundBegin(target, round)

    self.actionRound = round
    cclog("00000000000000")
    cclog(self.actionRound.skillType)
    cclog("00000000000000000")
    self.target = target

    self.buffEnd = false
    self.effectEnd = false                    
    self.buffIndex = 0                               
    self.actionIdxAttack = 0                          
    self.actionIdxHit = 0                                 
    self.actionEndAttack = 0                          
    self.actionEndHit = 0                               
    self.actionActions = {}
    self.currentBuffs = self.actionRound.buffs
    self.maxBuffs = #self.currentBuffs   
    self:onRunBuffs()
end

function FEUnpara:onRunBuffs()
    if self.buffIndex + 1 > self.maxBuffs then
        self:onStepRoundEnd()
        return
    end
    self.buffIndex = self.buffIndex + 1
   cclog("self.buffIndex====FEUnpara=====" .. self.buffIndex)
    self.actionIdxAttack = 0

    local buff = self.currentBuffs[self.buffIndex]
    local actEffect = buff.actEffect

    if actEffect ~= 0 then
        print("-------actEffect-------")
        print(actEffect)
        --self.actionActions = self.actionUtil.buffdata[string.format(actEffect)].actions
        self.actionActions = buff.actionActions
        self.actionsMaxValue = #self.actionActions    --每个buff中得action数量
        self:onRunActions()
    else
        self.actionsMaxValue = 0
        self.actionActions = nil
        self:performEffect()
        self:onRunBuffs()
    end
end

function FEUnpara:onRunActions()
    if self.actionIdxAttack + 1 > self.actionsMaxValue then
        self:onRunBuffs()
        return
    end
    
    self.actionIdxAttack = self.actionIdxAttack + 1
    cclog("self.actionIdxAttack====FEUnpara=====" .. self.actionIdxAttack)
    self:performEffect()
    --cclog("")
    local camp = self.actionRound.camp
    local actions = self.actionActions
    local buff = self.currentBuffs[self.buffIndex]
    self.beHitHeroNum = buff.beHitTable[self.actionIdxAttack]

    local dst_pos = buff.dst_pos
    local srcs = buff.srcs
    local actEffect = buff.actEffect

    local buffNo = buff.buffno
    self.audioManager:playBufffAudio(buffNo)
    
    local idx = self.actionIdxAttack
    local src = srcs[idx]
    local target_pos = dst_pos[idx]
    local attackAction = self.actionActions[self.actionIdxAttack].attack
    local attack = nil

    local actionDataTable = {}
    actionDataTable.actEffect = actEffect
    actionDataTable.no = attackAction
    actionDataTable.target_pos = target_pos
    self.beHitFinish = false
    self.isBeingAttack = true
    if camp == "army" then
        local function callBack(sender, args)
            self:playUnparaHitEnemy(args.buffIndex, args.actionIdxAttack, args.actionsMaxValue) 
        end

        local delayTime = self.actionActions[self.actionIdxAttack].delta / ACTION_SPEED

        -- timer.delayPlayHit(callBack, delayTime, self.buffIndex, self.actionIdxAttack, self.actionsMaxValue)
        local args = {}
        args.buffIndex = self.buffIndex
        args.actionIdxAttack = self.actionIdxAttack
        args.actionsMaxValue = self.actionsMaxValue

        print(args.buffIndex)
        print(args.actionIdxAttack)
        print(args.actionsMaxValue)

        self.fightUtil:runDelayAction(callBack, delayTime, args)
        
        print("--FEUnpara:onRunActions----")
        print(actions[idx].attack)
        table.print(target_pos)
        print(src)

        attack = self.fvAction:makeActionFront(actions[idx].attack, target_pos, const.HOME_ARMY[src])
        self:doDispatchEvent(const.EVENT_ATTACK_ARMY_PLAY, src, attack)
        
    elseif camp == "enemy" then
        actionDataTable.home = const.HOME_ENEMY[src]
    
        local function callBack(sender, args)
            self:playUnparaHitArmy(args.buffIndex, args.actionIdxAttack, args.actionsMaxValue) 
        end
        local delayTime = self.actionActions[self.actionIdxAttack].delta / ACTION_SPEED

        --timer.delayPlayHit(callBack, delayTime, self.buffIndex, self.actionIdxAttack, self.actionsMaxValue)
        local args = {}
        args.buffIndex = self.buffIndex
        args.actionIdxAttack = self.actionIdxAttack
        args.actionsMaxValue = self.actionsMaxValue

        self.fightUtil:runDelayAction(callBack, delayTime, args)

        attack = self.fvAction:makeActionHind(actionDataTable)
        
        self:doDispatchEvent(const.EVENT_ATTACK_ENEMY_PLAY, src, attack)
    end
end

function FEUnpara:playUnparaHitArmy(buffIndex, actionIdxAttack, actionsMaxValue)
    local actions = self.actionActions
    local buff = self.currentBuffs[buffIndex]
    local dst_pos = buff.dst_pos
    local dst_army = buff.dst_army
    local dst_enemy = buff.dst_enemy
    local actEffect = buff.actEffect
    local startCamp = buff.startCamp
    local target_pos = dst_pos[actionIdxAttack]
    local attackAction = actions[actionIdxAttack].hit
    local actionDataTable = {}
    actionDataTable.actEffect = actEffect
    actionDataTable.no = attackAction
    actionDataTable.target_pos = target_pos
    
    for seat, impact in pairs(dst_army) do
        if actionIdxAttack == 1 then self:doDispatchEvent(const.EVENT_HIT_ARMY_START, seat) end
        actionDataTable.home = const.HOME_ARMY[seat]
        local hitAction = self.fvAction:makeActionHind(actionDataTable)
        local digit = actions[actionIdxAttack].digit
        local dataTable = {}
        dataTable.seat = seat
        dataTable.hitAction = hitAction
        dataTable.buffIndex = buffIndex
        dataTable.actionIndex = actionIdxAttack
        dataTable.actionsMaxValue = actionsMaxValue
        dataTable.digit = digit
        dataTable.endCamp = "army"
        dataTable.startCamp = startCamp

        dataTable.impact = impact
        self:doDispatchEvent(const.EVENT_PLAY_BE_HIT_ACT, dataTable)
    end

    for seat, impact in pairs(dst_enemy) do
        if actionIdxAttack == 1 then self:doDispatchEvent(const.EVENT_HIT_ENEMY_START, seat) end
        actionDataTable.home = const.HOME_ENEMY[seat]
        local hitAction = self.fvAction:makeActionHind(actionDataTable)
        local digit = actions[actionIdxAttack].digit
        local dataTable = {}
        dataTable.seat = seat
        dataTable.hitAction = hitAction
        dataTable.buffIndex = buffIndex
        dataTable.actionIndex = actionIdxAttack
        dataTable.actionsMaxValue = actionsMaxValue
        dataTable.digit = digit
        dataTable.endCamp = "enemy"
        dataTable.startCamp = startCamp

        dataTable.impact = impact
        self:doDispatchEvent(const.EVENT_PLAY_BE_HIT_ACT, dataTable)
    end
end

function FEUnpara:playUnparaHitEnemy(buffIndex, actionIdxAttack, actionsMaxValue)
    local actions = self.actionActions
    local dst_pos = self.currentBuffs[buffIndex].dst_pos
    local dst_army = self.currentBuffs[buffIndex].dst_army
    local dst_enemy = self.currentBuffs[buffIndex].dst_enemy
    local killover = self.currentBuffs[buffIndex].killover
    local target_pos = dst_pos[buffIndex]
    
    for seat, impact in pairs(dst_army) do
        if buffIndex == 1 then self:doDispatchEvent(const.EVENT_HIT_ARMY_START, seat) end
        local hitAction = self.fvAction:makeActionFront(actions[buffIndex].hit, target_pos, const.HOME_ARMY[seat])
        
        local digit = actions[actionIdxAttack].digit
        local dataTable = {}
        dataTable.seat = seat
        dataTable.hitAction = hitAction
        dataTable.buffIndex = buffIndex
        dataTable.actionIndex = actionIdxAttack
        dataTable.actionsMaxValue = actionsMaxValue
        dataTable.digit = digit
        dataTable.endCamp = "army"
        dataTable.startCamp = startCamp

        dataTable.impact = impact
        self:doDispatchEvent(const.EVENT_PLAY_BE_HIT_ACT, dataTable)
    end

    for seat, impact in pairs(dst_enemy) do
        if buffIndex == 1 then self:doDispatchEvent(const.EVENT_HIT_ENEMY_START, seat) end
        local hitAction = self.fvAction:makeActionFront(actions[buffIndex].hit, target_pos, const.HOME_ENEMY[seat])
        
        local digit = actions[actionIdxAttack].digit
        local dataTable = {}
        dataTable.seat = seat
        dataTable.hitAction = hitAction
        dataTable.buffIndex = buffIndex
        dataTable.actionIndex = actionIdxAttack
        dataTable.actionsMaxValue = actionsMaxValue
        dataTable.digit = digit
        dataTable.endCamp = "enemy"
        dataTable.startCamp = startCamp

        dataTable.impact = impact
        self:doDispatchEvent(const.EVENT_PLAY_BE_HIT_ACT, dataTable)
    end
end

return FEUnpara














