
local FVMain = class("FVMain", mvc.ViewBase)
local FENormal = import(".FENormal")
local FEUnpara = import(".FEUnpara")
function FVMain:ctor(id)
    FVMain.super.ctor(self, id)

    self.slowdownPri = 0
    self.slowdownSpeed = 1.0
    self.camerafocusPri = 0

    self.fvAction = getFVAction()
    self.actionUtil = getActionUtil()
    self.fvActionSpec = getFVActionSpec()
    self.fvParticleManager = getFVParticleManager()
    self.audioManager = getAudioManager()
    self.peNormal = FENormal.new()
    self.ptmpNormal = FENormal.new()
    self.peUnpara = FEUnpara.new()
    self.tempSender = nil
    self.process = getFCProcess()
end

function FVMain:onMVCEnter()
    --回合开始
    self:listenEvent(const.EVENT_ROUND_BEGIN, self.playRoundBegin, nil)   
    --开始释放无双
    self:listenEvent(const.EVENT_UNPARALLELED_ROUND_BEGIN, self.playUnparaRoundBegin,nil)
    --攻击完成
    self:listenEvent(const.EVENT_HERO_PLAY_ATTACK_FINISH, self.heroPlayAttackFinish, nil)
    --被击完成
    self:listenEvent(const.EVENT_BE_HIT_FINISH, self.onBeHitFinish, nil) 
    
    self:listenEvent(const.EVENT_ATTACK_ITEM_SHAKE, self.onAttackShake, nil)
    self:listenEvent(const.EVENT_CAMERA_FOCUS, self.onCameraFocus, nil)
    self:listenEvent(const.EVENT_SLOW_DOWN, self.onSlowDown, nil)
    --击杀动画
    self:listenEvent(const.EVENT_KILL_OVER_BEGIN, self.onKillOverBegin, nil)
    --起手动作结束
    self:listenEvent(const.EVENT_END_BEGIN, self.endBegin,nil)

    self:listenEvent(const.EVENT_BUDDY_ROUND_BEGIN, self.startBoddyBegin, nil)

    self:listenEvent(const.EVENT_STOP_BEGINING, self.stopBegining, nil)
    --
    self:listenEvent(const.EVENT_BUDDY_ATTACK, self.startBoddyRound, nil)

    self:listenEvent(const.EVENT_FIGHT_BEFORE_BUFF, self.playFightBeforeBuff, nil)

    self:listenEvent(const.EVENT_END_BEFORE_BUFFS,  self.endBeforBuffs, nil)
end


function FVMain:onMVCExit()
end

--处理开场Buff,作用域为全体的，同效果ID只播放一次
function FVMain:dealBuffs(buffs)
    local iBuffsCount = table.getn(buffs)
    print("FVMain:dealBuffs=====>buffCount:",iBuffsCount)
    local i = 1
    for i = 1 , #buffs do
        buffs[i].play_state = 1 --需要播放
    end
    while true do
        if i > #buffs then
            break
        end
        local buff = buffs[i]
        
        if table.nums(buff.target_infos) == 0 or buff.play_state == 0 then
            buff.play_state = 0 --不播放
        else
            if buff.buff_info.effectPos["2"] ~= nil and buff.buff_info.effectPos["2"] == 0 then --此Buff为群体Buff
                j = i + 1
                while true do
                    if j > #buffs then
                        break
                    end
                    local tmp_buff = buffs[j]
                    if tmp_buff.play_state ~= 0 and  tmp_buff.buff_info.effectId == buff.buff_info.effectId then
                        print("effectID:",tmp_buff.buff_info.effectId)
                        if tmp_buff.buff_info.replace > buff.buff_info.replace then
                            buff.play_state = 0
                            buff = tmp_buff
                        else
                            tmp_buff.play_state = 0
                        end
                    end
                    j = j + 1
                end
            end
        end
        i = i + 1
    end
end

function FVMain:printBuffs(buffs)
    local i = 1
    for i = 1 , #buffs do
        v = buffs[i]
        print("buffID:",v.buff_info.id,"effectID:",v.buff_info.effectId,"replace:",v.buff_info.replace,"play_state:",v.play_state)
        -- table.print(v.buff_info.effectPos)
    end
end

function FVMain:playFightBeforeBuff(actions)
    local blueact = actions.blue_actions
    local redact = actions.red_actions

    print("befor Deal buffs:================>")
    print("red:")
    self:printBuffs(redact.buffs)
    print("blue:")
    self:printBuffs(blueact.buffs)
    print("end=＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝>")

    self:dealBuffs(redact.buffs)
    self:dealBuffs(blueact.buffs)

    print("after Deal buffs:================>")
    print("red:")
    self:printBuffs(redact.buffs)
    print("blue:")
    self:printBuffs(blueact.buffs)
    print("end=＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝>")

    local redBuffsCount = #redact.buffs
    local blueBuffsCount = #blueact.buffs

    local index = 1
    local blueIndex = 1
    self.peNormal.target = self
    self.tempSender = self.peNormal
    local time = 0.6

    -- local tmpSpeed = ACTION_SPEED * 2

    print("buffCount:red:",redBuffsCount,"blueBuffCount:",blueBuffsCount)
    self.playRed = true
    function playOpenBuf() --依次播放开场Buff

        print("index:",index,"blueIndex:",blueIndex,"playRed:",self.playRed)
        if (self.playRed or blueIndex > blueBuffsCount ) and index <= redBuffsCount then
            local redBuff = redact.buffs[index]
            
            print("redbuffId:",redBuff.buff_info.id,"index:",index)
            
            if redBuff.play_state == 0 then
                self:runAction(cc.CallFunc:create(playOpenBuf))
            else
                
                redBuff.attacker.side="red"
                self.peNormal:playFightBuff(redBuff)
                self:runAction(cc.Sequence:create({
                    cc.DelayTime:create(time / ACTION_SPEED),cc.CallFunc:create(playOpenBuf)}))
                self.playRed = not self.playRed
            end
            index = index + 1
        elseif blueIndex <= blueBuffsCount then

            local blueBuff = blueact.buffs[blueIndex]
            if blueBuff.play_state == 0 then
                self:runAction(cc.CallFunc:create(playOpenBuf))   
            else
                
                blueBuff.attacker.side = "blue"
                self.peNormal:playFightBuff(blueBuff)
                self:runAction(cc.Sequence:create({
                    cc.DelayTime:create(time / ACTION_SPEED),cc.CallFunc:create(playOpenBuf)}))
                self.playRed = not self.playRed
            end  
            blueIndex = blueIndex +1   
        else
            self:dispatchEvent(const.EVENT_FIGHT_BEGIN)
        end

    end
    self:runAction(cc.CallFunc:create(playOpenBuf))
end

function FVMain:playRoundBegin(round)
    print("<=====================FVMain:playRoundBegin================>",round.skillType)   
    self.actionRound = round
    -- if round.beginAction then
    if round.skillType == TYPE_BEGIN_ACTION then
        self:startBegin()
        -- self.tempSender = self.peNormal
        -- self.tempSender:startRound(self, self.actionRound)
    elseif round.skillType == TYPE_UNPARAL then --无双
        self:dispatchEvent(const.EVENT_START_UNPARA_ANI, round.attacker)
    elseif round.skillType == TYPE_BUDDY then   --小伙伴
        self:dispatchEvent(const.EVENT_START_BODDY_ANI)        
    else
        -- self:startBeforBuffs()
        self.tempSender = self.peNormal
        self.tempSender:startRound(self, self.actionRound)
    end
end

function FVMain:playUnparaRoundBegin()
    if not self.actionRound then return end
    -- for i = 1, #self.actionRound.buffs do
    --     print("FVMain:playUnparaRoundBegin=======>",self.actionRound.buffs[i].actions[1].attack)
    --     table.print(self.actionRound.attacker.HOME)       
    -- end    
    self.tempSender = self.peNormal
    self.tempSender:startRound(self, self.actionRound)
end

function FVMain:heroPlayAttackFinish(dataTable)
    self.tempSender:heroPlayAttackFinish(dataTable)
end

--开始回合前Buff
function FVMain:startBeforBuffs()
    self.tempSender = self.peNormal
    self.tempSender:startBeforeBuffs(self, self.actionRound)
end

--结束回合前Buff,开始起手动作--
function FVMain:endBeforBuffs()
    -- self:startBegin()
end

--开始起手动作
function FVMain:startBegin()
    cclog("FVMain:startBegin=============>")
    if self.actionRound.beginAction then --是否有起手动作
        local attacker = self.actionRound.attacker
        local target_pos = cc.p(320, 480)
        self:dispatchEvent(const.EVENT_ATTACK_ITEM_START, attacker.viewPos)
        local actions = self.actionUtil.buffdata[string.format(self.actionRound.beginAction)].actions
        local attackId = actions[1].attack
        local attack = self.fvAction:makeActionFront(attackId, target_pos, attacker.HOME)
        if attacker.side == "blue" then
            self:dispatchEvent(const.EVENT_BEGIN_STATE_CHANGE, true)        
        end
        self:dispatchEvent(const.EVENT_START_BEGIN, attacker.viewPos, attack)
    else
        self:doDispatchEvent(const.EVENT_ROUND_END)
        -- self.tempSender = self.peNormal
        -- self.tempSender:startRound(self, self.actionRound)
    end
end

--结束起手动作
function FVMain:endBegin()
    self:doDispatchEvent(const.EVENT_ROUND_END)
    -- self:dispatchEvent(const.EVENT_BEGIN_STATE_CHANGE, false)
    -- self.tempSender = self.peNormal
    -- self.tempSender:startRound(self, self.actionRound)
end

--停止起手动作
function FVMain:stopBegining()
    self:dispatchEvent(const.EVENT_STOP_BEGIN, self.actionRound.attacker.viewPos)
end

function FVMain:startBoddyBegin(round)
    self.actionRound = round
end

--开始小伙伴
function FVMain:startBoddyRound()
    if not self.actionRound then return end
    self.tempSender = self.peNormal
    self.tempSender:startRound(self, self.actionRound)
end

--被hit结束，callback
function FVMain:onBeHitFinish(dataTable)
    cclog("FVMain:onBeHitFinish=============>")
    self.tempSender:onBeHitFinish()
end

--战斗过程中处理impact
function FVMain:performImpact(dataTable)
    cclog("FVMain:performImpact--------------")
    print("dataTable.actionIndex=====" .. dataTable.actionIndex)
    print("dataTable.actionsMaxValue=====" .. dataTable.actionsMaxValue)
    if dataTable.actionIndex ==  dataTable.actionsMaxValue then
        local seat = dataTable.seat
        local endCamp = dataTable.endCamp

        local impact = dataTable.impact
        print("endCamp=====" .. endCamp)
        if endCamp == "army" then
            local armys = self.tempFightData.armys
            if seat ~= BUDDY_SEAT then
                local army = armys[seat]

                if army.isDead then
                    
                    
                    print("---performImpact------")
                    print(army.tmp_heroId)

                    local param = {}
                    param.camp = endCamp
                    param.seat = seat
                    param.heroId = army.tmp_heroId
                    param.isplay = self.tempFightData:isLastHeroDead(army.tmp_heroId)

                    self:dispatchEvent(const.EVENT_DEAD_ARMY, seat)
                    self:dispatchEvent(const.EVENT_SHOW_SHADOW, endCamp, false, seat)
                    self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, param)
                    -- self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, endCamp, seat, heroId)
                else
                    if seat ~= BUDDY_SEAT then
                        local dataTable = {}
                        dataTable.camp = endCamp
                        dataTable.seat = seat

                        dataTable.hero = army
                        self:dispatchEvent(const.EVENT_UPDATE_ANGER, dataTable)  --怒气
                    end
                end
            end
        elseif endCamp == "enemy" then
            local enemys = self.tempFightData:getCurrentEnemys()

            local enemy = enemys[seat]

            if enemy.isDead then
                self:dispatchEvent(const.EVENT_DEAD_ENEMY, seat)
                self:dispatchEvent(const.EVENT_SHOW_SHADOW, endCamp, false, seat)

                local dropNum = self.tempFightData:getDropNum(seat)
                if dropNum ~= nil and dropNum ~= 0 then
                    local dataTable = {}
                    dataTable.seat = seat
                    dataTable.camp = endCamp
                    dataTable.dropNum = dropNum
                    self:dispatchEvent(const.EVENT_PLAY_DROPPING, dataTable)
                end

                local param = {}
                param.camp = endCamp
                param.seat = seat
                param.heroId = enemy.tmp_heroId
                param.monsterId = enemy.no
                param.fightType = self.tempFightData.fightType
                param.isplay, param.quality = self.tempFightData:isLastHeroDeadInEnemys(enemy.tmp_heroId)

                self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, param)
                -- self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, endCamp, seat)
            else
                local dataTable = {}
                dataTable.camp = endCamp
                dataTable.seat = seat

                dataTable.hero = enemy
                self:dispatchEvent(const.EVENT_UPDATE_ANGER, dataTable)  --怒气
            end
        end
    end
end

--当该buff没有动作时直接执行
function FVMain:performEmptyImpach()
    local armys = self.tempFightData.armys
    for seat, army in pairs(armys) do
        local camp = "army"
        if army.isDead then
            self:dispatchEvent(const.EVENT_DEAD_ARMY, seat)
            self:dispatchEvent(const.EVENT_SHOW_SHADOW, camp, false, seat)
            print("---performEmptyImpach------")
            print(army.no)

            local param = {}
            param.camp = camp
            param.seat = seat
            param.heroId = army.tmp_heroId
            param.isplay = self.tempFightData:isLastHeroDead(army.tmp_heroId)

            self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, param)
            -- self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, camp, seat, army.no)
        else
            local dataTable = {}
            dataTable.camp = camp
            dataTable.seat = seat
            dataTable.hero = army
            self:dispatchEvent(const.EVENT_UPDATE_ANGER, dataTable)
        end
    end

    local enemys = self.tempFightData:getCurrentEnemys()
    camp = "enemy"
    for seat, enemy in pairs(enemys) do
        if enemy.isDead then
            self:dispatchEvent(const.EVENT_DEAD_ENEMY, seat)
            self:dispatchEvent(const.EVENT_SHOW_SHADOW, camp, false, seat)

            local dropNum = self.tempFightData:getDropNum(seat)
            if dropNum ~= nil and dropNum ~= 0 then
                local dataTable = {}
                dataTable.seat = seat
                dataTable.camp = camp
                dataTable.dropNum = dropNum
                self:dispatchEvent(const.EVENT_PLAY_DROPPING, dataTable)
            end

            local param = {}
            param.camp = camp
            param.seat = seat
            param.heroId = enemy.tmp_heroId
            param.monsterId = enemy.no
            param.fightType = self.tempFightData.fightType
            param.isplay, param.quality = self.tempFightData:isLastHeroDeadInEnemys(enemy.tmp_heroId)

            self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, param)
            -- self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, camp, seat)
        else
            local dataTable = {}
            dataTable.camp = camp
            dataTable.seat = seat

            dataTable.hero = enemy
            self:dispatchEvent(const.EVENT_UPDATE_ANGER, dataTable)
        end
    end   
end

--处理掉血等效果，不过延迟执行
function FVMain:performEffect(buff, target_info, delta)
    cclog("FVMain:performEffect===========")

end

--攻击震动，之前就有
function FVMain:onAttackShake(target_pos, frequency, aspect)
    local action_fight = self.fvActionSpec:makeActionShake_card(frequency)

    if action_fight then self:runAction(action_fight) end
end

--做慢镜头
function FVMain:doSlowDown(dur, speed, pri)
    if self.slowdownPri >= pri then return end
    if self.slowdownHandle then timer.unscheduleGlobal(self.slowdownHandle) end

    self.slowdownPri = pri
    self.slowdownSpeed = speed

    cc.Director:getInstance():getActionManager():setSpeed(speed)
    getFVParticleManager():setSpeed(speed)

    self.slowdownHandle = timer.delayGlobal(function()
        self.slowdownHandle = nil
        self.slowdownPri = 0
        self.slowdownSpeed = 1.0
        cc.Director:getInstance():getActionManager():setSpeed(1.0)
        getFVParticleManager():setSpeed(1.0)
    end, dur)

    self:redoCameraFocus()
end

--聚焦
function FVMain:doCameraFocus(dur, pos, scale, pri)
    if self.camerafocusPri >= pri then return end

    self.camerafocusPri = pri
    self.camerafocusDur = dur
    self.camerafocusPos = cc.p(scr.cx - pos.x * scale, scr.cy - pos.y * scale)
    self.camerafocusScale = scale
    self.camerafocusAction = cc.Sequence:create({
        cc.EaseSineOut:create(cc.Spawn:create({
            cc.MoveTo:create(0.15 * self.slowdownSpeed, self.camerafocusPos),
            cc.ScaleTo:create(0.15 * self.slowdownSpeed, self.camerafocusScale),
            })),
        cc.CallFunc:create(function()
            self.camerafocusPos = nil
            self.camerafocusScale = nil
            self.camerafocusAction = nil
        end),
        })

    self:runAction(self.camerafocusAction)

    self.camerafocusHandle = timer.delayGlobal(function()
        self.camerafocusHandle = nil
        self.camerafocusDur = nil
        self.camerafocusPos = cc.p(0, 0)
        self.camerafocusScale = 1.0
        self.camerafocusAction = cc.Sequence:create({
            cc.EaseSineOut:create(cc.Spawn:create({
                cc.MoveTo:create(0.15 * self.slowdownSpeed, self.camerafocusPos),
                cc.ScaleTo:create(0.15 * self.slowdownSpeed, self.camerafocusScale),
                })),
            cc.CallFunc:create(function()
                self.camerafocusPri = 0
                self.camerafocusPos = nil
                self.camerafocusScale = nil
                self.camerafocusAction = nil
            end),
            })
        self:runAction(self.camerafocusAction)
    end, dur + 0.15)
end

--聚焦
function FVMain:redoCameraFocus()
    if self.camerafocusHandle then
        timer.unscheduleGlobal(self.camerafocusHandle)

        if self.camerafocusAction then
            self:stopAction(self.camerafocusAction)

            self.camerafocusAction = cc.Sequence:create({
                cc.EaseSineOut:create(cc.Spawn:create({
                    cc.MoveTo:create(0.15 * self.slowdownSpeed, self.camerafocusPos),
                    cc.ScaleTo:create(0.15 * self.slowdownSpeed, self.camerafocusScale),
                    })),
                cc.CallFunc:create(function()
                    self.camerafocusPos = nil
                    self.camerafocusScale = nil
                    self.camerafocusAction = nil
                end),
                })

            self:runAction(self.camerafocusAction)
        end

        self.camerafocusHandle = timer.delayGlobal(function()
            self.camerafocusHandle = nil
            self.camerafocusDur = nil
            self.camerafocusPos = cc.p(0, 0)
            self.camerafocusScale = 1.0
            self.camerafocusAction = cc.Sequence:create({
                cc.EaseSineOut:create(cc.Spawn:create({
                    cc.MoveTo:create(0.15 * self.slowdownSpeed, self.camerafocusPos),
                    cc.ScaleTo:create(0.15 * self.slowdownSpeed, self.camerafocusScale),
                    })),
                cc.CallFunc:create(function()
                    self.camerafocusPri = 0
                    self.camerafocusPos = nil
                    self.camerafocusScale = nil
                    self.camerafocusAction = nil
                end),
                })
            self:runAction(self.camerafocusAction)
        end, self.camerafocusDur + 0.15)
    else
        if self.camerafocusAction then
            self:stopAction(self.camerafocusAction)

            self.camerafocusAction = cc.Sequence:create({
                cc.EaseSineOut:create(cc.Spawn:create({
                    cc.MoveTo:create(0.15 * self.slowdownSpeed, self.camerafocusPos),
                    cc.ScaleTo:create(0.15 * self.slowdownSpeed, self.camerafocusScale),
                    })),
                cc.CallFunc:create(function()
                    self.camerafocusPri = 0
                    self.camerafocusPos = nil
                    self.camerafocusScale = nil
                    self.camerafocusAction = nil
                end),
                })
            self:runAction(self.camerafocusAction)
        end
    end
end

function FVMain:onCameraFocus(dur, pos, scale)
   cclog("onCameraFocus------------")
    self:doCameraFocus(dur, pos, scale, 2)
end

function FVMain:onSlowDown(dur, speed)
    self:doSlowDown(dur, speed, 1)
end

function FVMain:onKillOverBegin(seat)
    print("FVMain:onKillOverBegin==========================", seat)
    self:doSlowDown(3.3, CONFIG_KO_SLOW, 2)
    self:doCameraFocus(3, const.HOME_ENEMY[seat-12].point, 2.5, 1)
    timer.delayGlobal(function()
        self:dispatchEvent(const.EVENT_KILL_OVER_END)
    end, 3.3)
end

function FVMain:doDispatchEvent(k1, ...)
    self:dispatchEvent(k1, ...)
end

return FVMain
