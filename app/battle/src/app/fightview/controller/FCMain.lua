--战斗控制层
local FCMain = class("FCMain", mvc.CtrlBase)

function FCMain:ctor()
    FCMain.super.ctor(self)
    self.fightData = getDataManager():getFightData()
    self.redLineup = self.fightData:getLineup()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.resourceData = getDataManager():getResourceData()
    self.process = getFCProcess()
    self.step = 0
    self.prelaodStep = 0
    self.armistice = false
    self.oneRoundTable = {} --一次将要执行的round

    self.nextRoundType = TYPE_NORMAL --将要执行的round type normal 
    self.unparaType = 0  --无双类型 三段
    self.isPausing = false
    self.isEnemyBegining = false
    self.test = false
    self.autoUnparaType = TYPE_AUTO_UNPARA_NORMAL

    self.isBeingPreLoad = false
    self.isRunRound = false
    self.tempAniActTable = {}
end

function FCMain:onMVCEnter()
    
    --Buff结束之后，显示状态
    self:listenEvent(const.EVENT_BUFF_END, self.onDisplayState, nil)
    --回合结束
    self:listenEvent(const.EVENT_ROUND_END, self.onPlayRoundEnd, nil)
    --入场结束
    self:listenEvent(const.EVENT_PRELUDE_END, self.onPerludeEnd, nil) 
    --前进开始
    self:listenEvent(const.EVENT_INTERLUDE_BEGIN, self.onInterludeBegin, nil)
    --点击小伙伴，打断正在执行的起手动作
    self:listenEvent(const.EVENT_BODDY_ROUND_START, self.startBoddy, nil)  --从ui回调

    self:listenEvent(const.EVENT_PAUSE, self.onPausing, nil)
    --战斗结果
    self:listenEvent(const.EVENT_FIGHT_RESULT, self.onFightResult, nil) -- 回合战斗结果
    self:listenEvent(const.EVENT_BATTLE_RESULT,self.onBattleResult,nil) -- 总的战斗结果
    self:listenEvent(const.EVENT_FIGHT_BEGIN,  self.startRunRoundAni, nil) --战斗开始
    self:listenEvent(const.EVENT_FIGHT_OPEN_BUFF,self.perform_open_skill,nil) --开始开场Buff
end

function FCMain:initData()
    print("FCMain:initData====>")
    self:initTimerData()
end

function FCMain:initTimerData()
    self.stopBattle = false
    print("FCMain:initTimerData=======>")
    self.callBackTable = {}
    local function callBack2()
        cclog("callBack2--------")
        self:initFrame()
        self.process:init()
    end
    table.insert(self.callBackTable, callBack2)
    local function callBack3()
        cclog("callBack3-----")
        self:makeArmy()
    end
    table.insert(self.callBackTable, callBack3)
    local function callBack4()
        cclog("callBack4-------")
        self:makeReplace()
    end
    table.insert(self.callBackTable, callBack4)
    local function callBack5()
        cclog("callBack5--------")
        self:makeBuddy()
    end
    table.insert(self.callBackTable, callBack5)
    local function callBack6()
        cclog("callBack6===========")
        self:makeUnpara()
    end
    table.insert(self.callBackTable, callBack6)

    local function callBack7()
        cclog("callBack7======77777=====")
        self:preLoadAnimation()
    end

    table.insert(self.callBackTable, callBack7)

    -- --QGW 20150422 在开始战斗前需要更新状态
    -- local function callBack9()
        
    --     self.process:perform_open_skill()
    -- end
    -- table.insert(self.callBackTable,callBack9)

    local function callBack8()
        cclog("callBack8=====88888======")
        self:loadAnimation()
        self:startFight()
    end

    table.insert(self.callBackTable, callBack8)

    self.callBackIndex_cb = 0
    local callBackCount = #self.callBackTable
    local timeCallBack = function ()
        self.callBackIndex_cb = self.callBackIndex_cb + 1
        print("CallBackIndex=============",self.callBackIndex,callBackCount)
        if self.callBackIndex_cb > callBackCount or self.stopBattle then
            print("timer.unscheduleGlobal(self.timeScheduler)")
            timer.unscheduleGlobal(self.timeScheduler_handle)
        else
            local func = self.callBackTable[self.callBackIndex_cb]
            func()
        end
    end
    self.timeScheduler_handle = timer.scheduleGlobal(timeCallBack, 0.05)
end

function FCMain:perform_open_skill()
    self.process:perform_open_skill()
end

function FCMain:startFight()
    cclog("FCMain:startFight===================>")
    self:dispatchEvent(const.EVENT_UPDATE_UI_VIEW)
    self:dispatchEvent(const.EVENT_PRELUDE_BEGIN)
end

--小伙伴点击
function FCMain:onBoddyPress()
    self.nextRoundType = TYPE_BUDDY
end

--右上角按钮点击回调
function FCMain:onPausing(isPausing)
    --if TEST == true then
        -- exitFightScene()
        --self:dispatchEvent(const.EVENT_HERO_GONE, 2)
        --getRandom()
        self:nextStep()
        --self:dispatchEvent(const.test)

        -- local director = cc.Director:getInstance()
        -- if self.test == false then
        --     self.test = true
        --     self.pausedTargets = director:getActionManager():pauseAllRunningActions()
        -- else
        --     self.test = false
        --     table.print(self.pausedTargets)
        --     director:getActionManager():resumeTargets(self.pausedTargets)
        -- end     
    --end
end

function FCMain:nextStep()
    cclog("FCMain:nextStep===================>")
    -- self:getNormalStep()
end

--创建army
function FCMain:makeArmy()
    local red_units = self.process:getRedUnits()

    local actionTable = {}
    local delayTime = cc.DelayTime:create(1 / 60)
    local function callBack(sender, args)
        local pos = args.pos
        local unit = red_units[pos]
        self:dispatchEvent(const.EVENT_MAKE_CARD_ITEM, unit, unit.origin_no)
    end

    for pos, v in pairs(red_units) do
        table.insert(actionTable, delayTime:clone())
        table.insert(actionTable, cc.CallFunc:create(callBack, {pos = pos}))
    end
    local sequenceAction = cc.Sequence:create(actionTable)
    getFightScene():runAction(sequenceAction)
end

--创建武将乱入卡牌
function FCMain:makeReplace()
    local replace = self.process:getReplace()
    if replace ~= nil and replace.no ~= 0 then
        cclog("FCMain:makeReplace-------------------------------", replace.no)
        self:dispatchEvent(const.EVENT_MAKE_REPLACE_HERO, replace)
    end
end

--创建enemy卡牌
function FCMain:makeEnemy()
    print("makeEnemy-------------")
    local blue_units = self.process:getBlueUnits()
    for k, v in pairs(blue_units) do
        self:dispatchEvent(const.EVENT_MAKE_CARD_ITEM, v)
    end
end

--创建小伙伴
function FCMain:makeBuddy()
    print("----FCMain:makeBuddy------")
    local friend = self.process:getBuddySkill()
    if friend and friend.no ~= 0 then
        self:dispatchEvent(const.EVENT_BUDDY_MAKE_BUDDY,friend)    
    end
end

--创建无双
function FCMain:makeUnpara()
    self:dispatchEvent(const.EVENT_UPDATA_UNPARA_DATA)
end

--一回合结束后，重置army，血量满，消除buff
function FCMain:restArmy()
    local red_units = self.process:getRedUnits()
    for k, v in pairs(red_units) do
        if not v:is_dead() then
            v:reset()
            self:dispatchEvent(const.EVENT_UPDATE_HERO_STATE, v)
        end
    end
end

--入场动画播放结束后，
function FCMain:onPerludeEnd()
    local fightType = self.fightData:getFightType()
    --if fightType == TYPE_WORLD_BOSS then
        ----如果是世界boss，那么执行这个流程
        --self:startWorldBossFight()
    --else
        self:startNormalFight()
    --end
end

--开始普通战斗，非boss
function FCMain:startNormalFight()
    --创建敌人
    self:makeEnemy()
    
    local function callBack1()
        --延迟显示敌方的影子
        self:dispatchEvent(const.EVENT_SHOW_SHADOW, "blue", true)
    end

    local function callBack2()
        --开始执行觉醒
        self:startAwake()
    end

    local delayTime1 = cc.DelayTime:create(0.6)
    local delayTime2 = cc.DelayTime:create(0.4)
    local sequenceAction = cc.Sequence:create(
        delayTime1, cc.CallFunc:create(callBack1), 
        delayTime2, cc.CallFunc:create(callBack2)
        )
    getFightScene():runAction(sequenceAction)
end

--开始世界boss战
function FCMain:startWorldBossFight()
    
    local function callBack0()
        --创建世界boss
        self:dispatchEvent(const.EVENT_MAKE_WORLD_BOSS)
    end

    local function callBack1()
        --显示影子
        self:dispatchEvent(const.EVENT_SHOW_SHADOW, "blue", true)
    end

    local function callBack2()
        --开始觉醒操作
        self:startAwake()
    end

    local delayTime0 = cc.DelayTime:create(1)
    local delayTime1 = cc.DelayTime:create(3.5)
    local delayTime2 = cc.DelayTime:create(0.5)

    local sequenceAction = cc.Sequence:create(
        delayTime0, cc.CallFunc:create(callBack0),
        delayTime1, cc.CallFunc:create(callBack1),
        delayTime2, cc.CallFunc:create(callBack2)
        )
    getFightScene():runAction(sequenceAction)
end

--开始处理开场Buff
function FCMain:startOpenBuff()
    -- body
    self:dispatchEvent(const.EVENT_FIGHT_OPEN_BUFF)
    -- startRunRoundAni
end

--有武将乱入时，开始武将乱入
function FCMain:startEntry()
    local replace = self.process:getReplace()
    --如果没有武将乱入，那么进行下一个，流程，播放回合动画
    if replace == nil or replace.no == 0 then
        self:startOpenBuff()
        return
    end

    local position = replace.viewPos
    cclog("FCMain:startEntry---------"..position)    
    local function callBack1()
        self:dispatchEvent(const.EVENT_ATTACK_ITEM_START, position)
        self:dispatchEvent(const.EVENT_HERO_GONE, position)
    end
    local function callBack2()
        self:dispatchEvent(const.EVENT_SOLDIER_ENTRY_ANI, replace) --动画
        self:dispatchEvent(const.EVENT_REPLACE_HERO, position)
    end

    local function callBack5()
        self:startOpenBuff()
    end

    local delayTime3 = cc.DelayTime:create(1)
    local delayTime4 = cc.DelayTime:create(1.2)
    local delayTime5 = cc.DelayTime:create(2)
    local sequenceAction = cc.Sequence:create(
        delayTime3, cc.CallFunc:create(callBack1),
        delayTime4, cc.CallFunc:create(callBack2),
        delayTime5, cc.CallFunc:create(callBack5)
        )
    getFightScene():runAction(sequenceAction)
end

--开始觉醒事件，觉醒就是变身
function FCMain:startAwake()
    local function callBack2()
        self:dispatchEvent(const.EVENT_START_AWAKE) --动画
    end

    local function callBack4()
        self:startEntry() --开始武将乱入
    end

    local delayTime2 = cc.DelayTime:create(0.1)
    local delayTime4 = cc.DelayTime:create(1.3)
    local sequenceAction = cc.Sequence:create(
        delayTime2, cc.CallFunc:create(callBack2),
        delayTime4, cc.CallFunc:create(callBack4)
        )
    getFightScene():runAction(sequenceAction)
end

--开始round战斗了
function FCMain:startRunRoundAni()
    local round = self.process:getCurrentRound()   
    -- 先播放动画
    self:dispatchEvent(const.EVENT_PLAY_ROUND_ANI, round, false)
    local function callBack1()
        if  TEST == false then
            local gId = getNewGManager():getCurrentGid()
            if gId == G_UNPARA_1 then  --无双处理，在新手引导的判断
                getNewGManager():startGuide()
            else
                self.process:perform_one_step()
            end
        end
    end
    local delayTime1 = cc.DelayTime:create(1.5)

    local sequenceAction = cc.Sequence:create(
        delayTime1, cc.CallFunc:create(callBack1)
        )
    getFightScene():runAction(sequenceAction)
end

--一回合结束之后开始进行的事件
function FCMain:onInterludeBegin()
    print("FCMain:onInterludeBegin----")
    local function callBack1()
        self.step = 0
        self:restArmy()
    end

    local function callBack2()
        self:makeEnemy()
    end

    local function callBack3()
        self:dispatchEvent(const.EVENT_SHOW_SHADOW, "blue", true)
    end

    local function callBack4()
        self:startRunRoundAni()
    end
    
    local delayTime1 = cc.DelayTime:create(0.5)
    local delayTime2 = cc.DelayTime:create(1)
    local delayTime3 = cc.DelayTime:create(0.7)
    local delayTime4 = cc.DelayTime:create(0.7)

    local sequenceAction = cc.Sequence:create(
        delayTime1, cc.CallFunc:create(callBack1),
        delayTime2, cc.CallFunc:create(callBack2),
        delayTime3, cc.CallFunc:create(callBack3),
        delayTime4, cc.CallFunc:create(callBack4)
        )
    getFightScene():runAction(sequenceAction)
end

--更新怒气值
function FCMain:updateAnger()
    print("FCMain:updateAnger========================>")
    -- local camp = self.oneRoundTable.camp
    -- local skillType = self.oneRoundTable.skillType
    -- local subSkillType = self.oneRoundTable.subSkillType
    -- if camp == "army" then
    --     local armys = self.tempFightData.armys
    --     local army = armys[self.oneRoundTable.src]
    --     if army ~= nil then
    --         army:updateAnger(skillType, subSkillType)
    --     end
    --     local dataTable = {}
    --     dataTable.camp = camp
    --     dataTable.seat = self.oneRoundTable.src

    --     dataTable.hero = army
    --     --播放怒气值改变动画
    --     self:dispatchEvent(const.EVENT_UPDATE_ANGER, dataTable)
    -- end

    -- if camp == "enemy" then
    --     local enemys = self.tempFightData:getCurrentEnemys()
    --     local enemy = enemys[self.oneRoundTable.src]
    --     if enemy ~= nil then
    --         enemy:updateAnger(skillType, subSkillType)
    --     end
    --     local dataTable = {}
    --     dataTable.camp = camp
    --     dataTable.seat = self.oneRoundTable.src

    --     dataTable.hero = enemy
    --     --播放怒气值改变动画
    --     self:dispatchEvent(const.EVENT_UPDATE_ANGER, dataTable)
    -- end
end

--检查是否自动释放无双
function FCMain:checkAutoStep()
    local isAuto = self.tempFightData.isAuto
   cclog("checkAutoStep==========")
    if isAuto then
        self.autoUnparaType = self.tempFightData:getIsUnparaFull()

        if self.autoUnparaType == TYPE_AUTO_UNPARA_RED then
           cclog("我方放无双--------")
            self.nextRoundType = TYPE_UNPARAL
            self.unparaType = TYPE_UNPARAL_T
            self:dispatchEvent(const.EVENT_UNPARA_BE_AUTO_EXE)
        elseif self.autoUnparaType == TYPE_AUTO_UNPARA_BLUE then
           cclog("对方放无双----------")
            self.nextRoundType = TYPE_UNPARAL
            self.unparaType = TYPE_UNPARAL_T
        end
    end
end

-- --开始释放小伙伴
function FCMain:startBoddy()
    self:dispatchEvent(const.EVENT_STOP_BEGINING)--停止正在起手的动作
    self.process:perform_one_step() -- 进行下一步攻击    
end

function FCMain:sendWinMsg()

    local fightType = self.fightData:getFightType()

    if fightType == TYPE_PVP then       
        getFightScene().fvLayerUI:showFightVictory()  -- win
    elseif fightType == TYPE_WORLD_BOSS then                                    --世界boss被打死
        exitFightScene()
        getNetManager():getBossNet():sendGetBossDeadInfo()
     elseif fightType == TYPE_MINE_MONSTER or fightType == TYPE_MINE_OTHERUSER then   -- 秘境
        local data = {}
        data.pos=getDataManager():getMineData():getMapPosition()
        data.result=true
        getNetManager():getSecretPlaceNet():sendMineSettleRequest(data)
    else
        getDataManager():getFightData():setIsWin(true)
        local stageId =  getDataManager():getFightData():getFightingStageId() 
        getNetManager():getInstanceNet():sendSettlement(stageId, fightType, 1)
    end
end

function FCMain:sendFaleMsg()
    print("sendFaleMsg")
    local fightType = self.fightData:getFightType()
    if fightType == TYPE_PVP or fightType == TYPE_MINE_MONSTER or fightType == TYPE_MINE_OTHERUSER then
        getFightScene().fvLayerUI:showFightDefeat()
    elseif fightType == TYPE_WORLD_BOSS then
        getNetManager():getBossNet():sendGetBossInfoForFight()
    else
        getDataManager():getFightData():setIsWin(false)
        local stageId =  getDataManager():getFightData():getFightingStageId()
        getNetManager():getInstanceNet():sendSettlement(stageId, fightType, 0)
    end
end

-- 加载技能Frame
-- 加载loadFrame
function FCMain:preLoadAnimation()
    getActionUtil():init()
    self:initAnimationFrame()
end

function FCMain:initAnimationFrame()
    print("initAnimationFrame-------")
    local actionUtil = getActionUtil()
    local skill_nos = self.process:get_all_skill_nos()
    table.print(skill_nos)
    print("initAnimationFrame-------")
    for _, skill_no in pairs(skill_nos) do
        local item = self.soldierTemplate:getSkillTempLateById(skill_no)
        local group = item.group
        for m, n in pairs(group) do
            local buffItem = self.soldierTemplate:getSkillBuffTempLateById(n)
            local actEffect = buffItem.actEffect
            if actEffect ~= 0 then

                local item = actionUtil.buffdata[string.format(actEffect)]
                local actionActions = item.actions
                for p, q in pairs(actionActions) do
                    local attack = q.attack
                    local hit = q.hit
                    local attackAction = actionUtil.data[attack]
                    local hitAction = actionUtil.data[hit]

                    self:preferAction(attackAction)
                    self:preferAction(hitAction)
                end
            end
        end
    end
end

function FCMain:preferAction(action)
    if action == nil then return end

    for _, v2 in pairs(action) do
        for _, v3 in pairs(v2) do
            if v3 and v3.animate then
                local name = string.sub(v3.animate.file, 1, -3)
                self.tempAniActTable[#self.tempAniActTable + 1] = name
            end
            if v3 and v3.animateS then
                local name = string.sub(v3.animateS.file, 1, -3)
                self.tempAniActTable[#self.tempAniActTable + 1] = name
            end
        end
    end
end
function FCMain:loadAnimation()
    cclog("loadAnimation--------index===")
    table.print(self.tempAniActTable)
    cclog("loadAnimation--------index===")
    game.addSpriteFramesWithFile("res/ui/fight_hit.plist")
    game.addSpriteFramesWithFile("res/ccb/resource/kill_effect.plist")

    self.callBackIndex = 1
    local timeCallBack = function ()
        if self.callBackIndex > #self.tempAniActTable then
            timer.unscheduleGlobal(self.timeScheduler)
        else
            local v = self.tempAniActTable[self.callBackIndex]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end
            
            local v = self.tempAniActTable[self.callBackIndex + 1]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end

            local v = self.tempAniActTable[self.callBackIndex + 2]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end

            local v = self.tempAniActTable[self.callBackIndex + 3]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end

            local v = self.tempAniActTable[self.callBackIndex + 4]
            if v then
                game.addSpriteFramesWithFile("res/animate/" .. v .. ".plist")
            end
        end
        self.callBackIndex = self.callBackIndex + 5
    end
    self.timeScheduler = timer.scheduleGlobal(timeCallBack, 0.01)

end

function FCMain:initFrame()
    game.addSpriteFramesWithFile("res/card/board_all.plist")
    game.addSpriteFramesWithFile("res/card/state_all.plist")

    game.addSpriteFramesWithFile("res/card/dead_all.plist")
    
    game.addSpriteFramesWithFile("res/ccb/resource/ui_fight.plist")
    game.addSpriteFramesWithFile("res/ccb/resource/round_effect.plist")
end
--
-- 清除预加载的数据
function FCMain:clearData()
    game.removeSpriteFramesWithFile("res/card/board_all.plist")
    game.removeSpriteFramesWithFile("res/card/state_all.plist")

    game.removeSpriteFramesWithFile("res/card/dead_all.plist")
    game.removeSpriteFramesWithFile("res/ui/fight_hit.plist")
    game.removeSpriteFramesWithFile("res/ccb/resource/kill_effect.plist")

    game.removeSpriteFramesWithFile("res/ccb/resource/ui_fight.plist")
    game.removeSpriteFramesWithFile("res/ccb/resource/round_effect.plist")
end

--攻击完成
--执行afterBuff
function FCMain:onDisplayState(buff, attacker)
    print("FCMain:onDisplayState======================>buffid=",buff.buff_info.id)
    if buff then
        --更新目标卡牌状态
        for _, target_info in pairs(buff.target_infos) do
            self:dispatchEvent(const.EVENT_UPDATE_HERO_STATE, target_info.target_unit)
        end

        self.process:afterAttackDisplay(buff, attacker)

        --更新小伙伴，无双UI，战斗回合数显示
        self:dispatchEvent(const.EVENT_UPDATE_UI_VIEW)


        self:dispatchEvent(const.EVENT_UPDATE_HERO_STATE, attacker) --更新自身的状态
    end
end

--
-- 攻击播放完成后，进行状态改变，下一步攻击
function FCMain:onPlayRoundEnd(buff, attacker)

    cclog("<===================FCMain:onPlayRoundEnd====================>")    
    local function callBack1()
        if not self.stopBattle then
            self.process:perform_one_step() -- 进行下一步攻击
        end
    end

    local delayTime1 = cc.DelayTime:create(0.5 / ACTION_SPEED)

    local sequenceAction = cc.Sequence:create(
        delayTime1, cc.CallFunc:create(callBack1)
        )
    getFightScene():runAction(sequenceAction)
end

--总的战斗结束
function FCMain:onBattleResult(result)
    self.stopBattle = true
    local delayTime = cc.DelayTime:create(WIN_TIME)  
    local _result = result
    local function callBack()
        if _result then
            self:sendWinMsg()
        else
            self:sendFaleMsg()
        end
    end
    local sequenceAction = cc.Sequence:create(
    delayTime, cc.CallFunc:create(callBack)
    )
    getFightScene():runAction(sequenceAction)
end

function FCMain:onFightResult(result)
 
    if result then -- 胜利
        if self.process:is_last_round() then --结束
            self:onBattleResult(result)
            -- local function callBack()
            --     self:sendWinMsg()
            -- end
            -- local sequenceAction = cc.Sequence:create(
            -- delayTime, cc.CallFunc:create(callBack)
            -- )
            -- getFightScene():runAction(sequenceAction)            
        else --继续
            self.process:next_round()
            self:dispatchEvent(const.EVENT_UPDATE_UI_ROUND)
            self:dispatchEvent(const.EVENT_UPDATE_UI_SROUND)                              
            self:dispatchEvent(const.EVENT_INTERLUDE_BEGIN, self.process:getMaxRound())                     
        end
    else --失败
        self:onBattleResult(result)
        -- local function callBack()
        --     self:sendFaleMsg()
        -- end
        -- local sequenceAction = cc.Sequence:create(
        -- delayTime, cc.CallFunc:create(callBack)
        -- )
        -- getFightScene():runAction(sequenceAction)        
    end
end

return FCMain
