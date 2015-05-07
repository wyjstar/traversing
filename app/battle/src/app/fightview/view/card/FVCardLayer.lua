
local FVCardItem = import(".FVCardItem")
local FVCardHarm = import(".FVCardHarm")
local FVCardLight = import(".FVCardLight")

local FVCardLayer = class("FVCardLayer", mvc.ViewBase)

local ARMY_MAX_INDEX = 11
local ENEMY_START_INDEX = 13
local ARMY_CAMP = "red"
local ENEMY_CAMP = "blue"

function FVCardLayer:ctor(id)
    FVCardLayer.super.ctor(self, id)
    --存放我方阵容
    self.card_armys = {}
    --存放敌方阵容
    self.card_enemys = {}
    --统一用一个集合存储敌方阵容和我方阵容
    self.cardItems = {false, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil, nil,false}
    self.buddyItem = {}
    self.unparaHero = nil
    self.replaceHero = nil
    self.awake_armys = {}
    self.awake_enemys = {}
    self.fvActionSpec = getFVActionSpec()
    self.process = getFCProcess()
   
    self:init()
end

function FVCardLayer:init()
    self.ENEMY_ZORDER = 10
    self.AEMY_ZORDER = 20
    self.BODDY_ZORDER = 30

    self.LIGHT_ZORDER  = 40
    self.BE_HIT_ZORDER = 49
    
    self.ATTACK_ZORDER = 120
    self.HARM_ZORDER  = 1300
    self.cardHarm = FVCardHarm.new()
    self:addChild(self.cardHarm, self.HARM_ZORDER)

    self.cardLight = FVCardLight.new()
    self:addChild(self.cardLight, self.LIGHT_ZORDER)
end

function FVCardLayer:onMVCEnter()
    --创建卡牌
    self:listenEvent(const.EVENT_MAKE_CARD_ITEM, self.addAttackItem, nil)
    --创建无双
    self:listenEvent(const.EVENT_UPDATA_UNPARA_DATA, self.makeUnpara, nil)    
    --卡牌开始攻击
    self:listenEvent(const.EVENT_ATTACK_ITEM_START, self.playAttackItemStart, nil)
    --播放攻击动作
    self:listenEvent(const.EVENT_PLAY_ATTACK_ACTION, self.playAttackAction, nil)
    --卡牌结束动作
    self:listenEvent(const.EVENT_ATTACK_ITEM_STOP, self.playAttackItemStop, nil)
    --被击开始
    self:listenEvent(const.EVENT_HIT_ITEM_START, self.playHitItemStart, nil)
    --播放被击动画
    self:listenEvent(const.EVENT_PLAY_BE_HIT_ACT, self.playHeroBeHitAct, nil)
    --受击对象停止
    self:listenEvent(const.EVENT_HIT_ITEM_STOP, self.playHitItemStop, nil)
    --卡牌死亡
    self:listenEvent(const.EVENT_DEAD_ITEM, self.itemDead, nil)
    self:listenEvent(const.EVENT_KILL_OVER_BEGIN, self.onKillOverBegin, nil)
    self:listenEvent(const.EVENT_UPDATE_ANGER, self.updateAnger, nil)
    --小伙伴攻击开始
    self:listenEvent(const.EVENT_BUDDY_ATTACK, self.boddyBegin, nil)
    --运行起手动作
    self:listenEvent(const.EVENT_START_BEGIN, self.playHeroBegin, nil)
    --停止起手动作 
    self:listenEvent(const.EVENT_STOP_BEGIN, self.stopBegin, nil)
    --创建小伙伴  
    self:listenEvent(const.EVENT_BUDDY_MAKE_BUDDY, self.makeBoddy, nil)
    self:listenEvent(const.EVENT_HERO_GONE, self.armyGone, nil) 
    self:listenEvent(const.EVENT_REPLACE_HERO, self.replaceHeroEvent, nil)
    self:listenEvent(const.EVENT_MAKE_REPLACE_HERO, self.makeReplaceHero, nil) 
    --回合间动画开始事件
    self:listenEvent(const.EVENT_INTERLUDE_BEGIN, self.onInterludeBegin, nil)
    self:listenEvent(const.EVENT_FIGHT_VICTORY, self.fightVictory, nil)
    --显示阴影
    self:listenEvent(const.EVENT_SHOW_SHADOW, self.showShadow, nil)
    --入场动画结束
    self:listenEvent(const.EVENT_PRELUDE_END, self.onPreludeEnd, nil)
    --更新卡牌状态
    self:listenEvent(const.EVENT_UPDATE_HERO_STATE, self.updateHeroState, nil)
    --更新卡牌的所有状态
    self:listenEvent(const.EVENT_UPDATE_ALL_HERO_STATE, self.updateAllHeroState, nil)
    --开始入场动画
    self:listenEvent(const.EVENT_DO_ACTION_PRELUDE, self.doActionPrelude, nil)
    --播放打击效果
    self:listenEvent(const.EVENT_PLAY_HIT_IMPACT, self.playHitImpact, nil)
    self:listenEvent(const.EVENT_START_AWAKE, self.startAwake, nil)
    self:listenEvent(const.EVENT_MAKE_WORLD_BOSS, self.makeWorldBoss, nil)
    self:listenEvent(const.EVENT_REMOVE_HERO_BUFF,self.removeHeroBuffs,nil)   

    self:listenEvent(const.EVENT_CARD_DIGIT_NUM, self.playDigitHarm, nil)   
end
--创建世界boss
function FVCardLayer:makeWorldBoss()
    local bossEnemys = self.process.blue_units
    for k, v in pairs(bossEnemys) do
        local position = v.pos

        local enemy = FVCardItem.new(v)

        enemy:setVisible(false)
     
        self.card_enemys[position] = enemy
        enemy:setTarget(self)
        enemy:setCardHome(const.BOSS_HOME)
        -- enemy:setCardHome(BIG_SCALE)
        self:addChild(enemy, self.ENEMY_ZORDER)
        
        local action = self.fvActionSpec:makeBossInAction()
        enemy:runAction(action)
        --enemy:addChild(UI_bosslaixichixu()) 
    end

    local function callBack1()
        local node = UI_bosslaixibianshen()
        node:setTag(1001)
        self:addChild(node, self.LIGHT_ZORDER)
        getFightScene():runRepeatAction(1.5)
    end

    local function callBack2()

    end

    -- local delayTime1 = cc.DelayTime:create(1.9)
    local delayTime1 = cc.DelayTime:create(0.4)
    local delayTime2 = cc.DelayTime:create(1)

    local sequence1 = cc.Sequence:create(
        delayTime1, cc.CallFunc:create(callBack1)
        --delayTime2, cc.CallFunc:create(callBack2)
        )
    self:runAction(sequence1)

end
--开始觉醒动画
function FVCardLayer:startAwake()
    self.awake_armys = {}
    self.awake_enemys = {}

    cclog("-----FVCardLayer:startAwake------")
    local red_units = self.process:getRedUnits()

    for k, v in pairs(red_units) do
        if v.is_awake then
            self.cardItems[v.viewPos]:startAwake()
            self:createAwakeEffect(v)
        end
    end

    local blue_units = self.process:getBlueUnits()

    for k, v in pairs(blue_units) do
        if v.is_awake then
            self.cardItems[v.viewPos]:startAwake()
            self:createAwakeEffect(v)
        end
    end
end

function FVCardLayer:createAwakeEffect(unit)
    local node = UI_bianshen()
    node:setPosition(unit.HOME.point)
    node:setScale(1.5)
    self:addChild(node, self.HARM_ZORDER)
    local function callBack1()
        self:onStartAwake(unit)
    end

    local function callBack2()
        getFightScene():runSceneShake(3)
    end

    local delayTime1 = cc.DelayTime:create(1.2)
    local delayTime2 = cc.DelayTime:create(0.32)
    local sequenceAction = cc.Sequence:create(delayTime1, cc.CallFunc:create(callBack1), delayTime2, cc.CallFunc:create(callBack2))
    node:runAction(sequenceAction)
end

function FVCardLayer:onStartAwake(unit)
    cclog("FVCardLayer:onStartAwake======================>")
    local awakeUnitView = FVCardItem.new(unit, unit.no)
    awakeUnitView:setVisible(false)
    awakeUnitView:setTarget(self)
    awakeUnitView:setCardHome(unit.HOME)
    self:addChild(awakeUnitView, unit.zorder)
    self.cardItems[unit.viewPos] = awakeUnitView

    awakeUnitView:setIsShowShadow(true)
    awakeUnitView:setVisible(true)
    awakeUnitView:enterAwake()
end

function FVCardLayer:playHitImpact(buff_info, target_info)
    local target_unit = target_info.target_unit
    local cardItem = self.cardItems[target_unit.viewPos]
    
    if cardItem then
        cclog("FVCardLayer:playHitImpact==================>pos="..target_unit.viewPos)
        self.cardHarm:playHitImpact(buff_info, target_info)
    end
end

function FVCardLayer:playDigitHarm( tab )
    print("FVCardLayer:playDigitHarm----------------->")
    local cardItem = self.cardItems[tab.pos]
    if cardItem then
        self.cardHarm:playDigitHarm(tab)
    end
end

function FVCardLayer:doActionPrelude()
    for i = 1, #self.cardItems do
        local card = self.cardItems[i]
        if card then
            card:doActionPrelude()            
        end
    end
end

function FVCardLayer:onPreludeEnd()
    local action = self.fvActionSpec:makeArmyFirstIn()
    for i = 1 , ARMY_MAX_INDEX  do --排除小伙伴
        local card = self.cardItems[i]
        if card then
            if card.chief then
                card:setVisible(true)
            else
                card:runAction(action:clone())
            end
        end
    end
end

function FVCardLayer:showShadow(side, state, seat)
    if not seat then
        for i = 1, #self.cardItems do
            local card = self.cardItems[i]
            if card and card.unit.side == side then
                card:setIsShowShadow(state) 
            end
        end
    else
        local card = self.cardItems[seat]
        if card then
            card:setIsShowShadow(state)        
        end        
    end
end

function FVCardLayer:fightVictory()
    self:clearEnemyData()
end
--清除敌方数据
function FVCardLayer:clearEnemyData()
    for i = ENEMY_START_INDEX, #self.cardItems do
        local card = self.cardItems[i]
        if card then
            card:removeFromParent(true)
            if i == #self.cardItems then
                self.cardItems[i] = false
            else
                self.cardItems[i] = nil
            end              
        end
    end
end
--开始回合间动画
function FVCardLayer:onInterludeBegin()
    for i = 1, ARMY_MAX_INDEX do
        local card = self.cardItems[i]
        if card then
            if not card:getDeadState() then
                local action =  self.fvActionSpec:makeActionInterlude_army()
                card:runAction(action)
            else
                card:removeFromParent(true)
                if i == 1 then
                    self.cardItems[i] = false                    
                else
                    self.cardItems[i] = nil
                end
            end           
        end
    end
    self:clearEnemyData()
end

function FVCardLayer:makeUnpara()
    cclog("----FVCardLayer:makeUnpara-----")    
    self.unparaHero = FVCardItem.new()
    self.unparaHero:setTarget(self)
    self:addChild(self.unparaHero)
end
--创建乱入武将
function FVCardLayer:makeReplaceHero(prop)
    cclog("----FVCardLayer:makeReplaceHero-----")
    local attack = FVCardItem.new(prop)
    attack:setVisible(false)
    attack:setTarget(self)
    self.replaceHero = attack
    attack:setCardHome(prop.HOME)
    self:addChild(attack, prop.zorder)
end
--替换武将
function FVCardLayer:replaceHeroEvent(seat)
    cclog("replaceHeroEvent================")
    local army = self.cardItems[seat]
    if not army then return end
    army:removeFromParent(true)
    self.cardItems[seat] = self.replaceHero
    self.cardItems[seat]:setVisible(false)
    cclog("replaceHeroEvent================")
end

function FVCardLayer:armyGone(seat)
    cclog("FVCardLayer:armyGone================postion(%d), total(%d)",seat, #self.cardItems)
    local army = self.cardItems[seat]
    if not army then return end
    army:armyGone()
end

function FVCardLayer:itemDead(viewPos)
    local hero = self.cardItems[viewPos]
    if hero then
        hero:changeDeadState(true)
        hero:setVisible(false)
        hero:setIsShowShadow(false)        
    end
end
--创建小伙伴
function FVCardLayer:makeBoddy(friend)
    if self.cardItems[BUDDY_SEAT] then 
        self.cardItems[BUDDY_SEAT]:removeFromParent(true)
        self.cardItems[BUDDY_SEAT] = nil 
    end
    local boddy = FVCardItem.new(friend.unit)
    self.cardItems[BUDDY_SEAT] = boddy
    boddy:setTarget(self)
    boddy:setVisible(false)
    boddy:setCardHome(self.process.buddy_skill.unit.HOME)
    self:addChild(boddy, self.BODDY_ZORDER)
end

function FVCardLayer:boddyBegin()
    cclog("FVCardLayer:boddyBegin=================================>")
    local boddyHero = self.cardItems[BUDDY_SEAT]
    if boddyHero then
        boddyHero:setPosition(320, 260)
        boddyHero:setScale(0.8)
        boddyHero:setVisible(true)        
    end
end
--更新怒气
function FVCardLayer:updateAnger(dataTable)
    local card = self.cardItems[dataTable.seat]
    if card then
        card:updateAnger(dataTable)        
    end
end

-- 添加CardItem
function FVCardLayer:addAttackItem(unit)
    cclog("-----FVCardLayer:addAttackItem----%d",unit.origin_no)
    local old = self.cardItems[unit.viewPos]
    if old then old:removeFromParent(true) end
    
    local attack = FVCardItem.new(unit, unit.origin_no)
    attack:setVisible(false)
    self.cardItems[unit.viewPos] = attack
    attack:setTarget(self)
    attack:setCardHome(unit.HOME)
    self:addChild(attack, unit.zorder)

    if unit.side == "blue" then
        local action = self.fvActionSpec:makeActionInterlude_enemy()
        attack:runAction(action)
    end
end

function FVCardLayer:updateHeroState(unit)
    local item = self.cardItems[unit.viewPos]
    if item then
        item:playActionState(unit)
    end    
end

function FVCardLayer:removeHeroBuffs(buff)
    print("FVCardLayer:removeHeroBuffs--------------->",const.EVENT_REMOVE_HERO_BUFF)
    -- for _,target in pairs(buf.target_infos) do
    -- table.print(buff)
        local item = self.cardItems[buff.target_infos[1].target_unit.viewPos]
        if item then
            item:removeBuffs(buff.target_infos[1].target_unit,buff)
        end
    -- end
end

function FVCardLayer:updateAllHeroState()
    cclog("FVCardLayer:updateAllHeroState==========================>")
    for i = 1, #self.cardItems do
        local card = self.cardItems[i]
        if card and card.unit and not card:getDeadState() then
            card.state:updateAllState(card.unit)
        end
    end
end

function FVCardLayer:playAttackItemStart(seat)
    local army = self.cardItems[seat]
    if army then
        army:setCardClean()
        army:setLocalZOrder(self.ATTACK_ZORDER)
    end
end

function FVCardLayer:playHeroBegin(seat, actions)
    cclog("FVCardLayer:playHeroBegin===============>%d",seat)
    local card = self.cardItems[seat]
    if card then
        card:playBeginAction(actions, function()
            self:dispatchEvent(const.EVENT_END_BEGIN, card.unit.side)
        end)        
    end
end
--停止起手动作
function FVCardLayer:stopBegin(seat)
    local card = self.cardItems[seat]
    if card then
        card:stopBeginAction()
    end
end
--播放攻击动作
function FVCardLayer:playAttackAction(target, actions)
    --7号位和19号位是无双技能位置
    local hero = nil
    if target.viewPos == 7 or target.viewPos == 19 then 
        --self:playUnparaAttackAction(actions)
        hero = self.unparaHero
    else
        hero = self.cardItems[target.viewPos]
    end
    if hero then
        hero:playAttackAction(actions)        
    end
end

-- function FVCardLayer:playUnparaAttackAction(actions)
--     if self.unparaHero then
--         self.unparaHero:playAttackAction(actions)
--     end
-- end

--播放攻击动作完成
function FVCardLayer:onPlayAttackFinish()
    cclog("FVCardLayer:onPlayAttackFinish===========>")
    self:dispatchEvent(const.EVENT_HERO_PLAY_ATTACK_FINISH)
end

function FVCardLayer:playAttackItemStop(seat)
    cclog("FVCardLayer:playAttackArmyStop===========>seat=" .. seat)
    local tempHero = self.cardItems[seat]
    if tempHero then
        tempHero:setVisible(true)
        tempHero:setCardClean()
        tempHero:setLocalZOrder(self.AEMY_ZORDER + 6 - seat)
    end
    if seat == BUDDY_SEAT then
        tempHero:setVisible(false)
    end
end

function FVCardLayer:playHitItemStart(seat)
    local tempHero = self.cardItems[seat]
    if tempHero then
        tempHero:setCardClean()
        tempHero:setLocalZOrder(self.BE_HIT_ZORDER)
    end
    if seat == BUDDY_SEAT then
        tempHero:setVisible(true)
    end
end

function FVCardLayer:playHeroBeHitAct(dataTable)  
    local seat = dataTable.target_unit.viewPos
    if not self.cardItems[seat] then return end    
    self.cardItems[seat]:playBeHitAction(dataTable)
end
--播放被击动作完成
function FVCardLayer:onBeHitCallBack(dataTable)
    cclog("FVCardLayer:onBeHitCallBack==============>")    
    self:dispatchEvent(const.EVENT_BE_HIT_FINISH, dataTable) 
end

function FVCardLayer:playHitItemStop(seat)
    cclog("FVCardLayer:playHitItemStop=============>seat="..seat)
    local item = self.cardItems[seat]
    if item and not item:getDeadState() then
        item:setCardClean()
        item:setLocalZOrder(item.unit.zorder)     
        item.state:updateAllState(item.unit)  
    end
end

function FVCardLayer:onKillOverBegin(seat, time)
    local card = self.cardItems[seat]
    if card then
        card:playActionKillover(time)
        self.cardLight:onKillOverBegin(seat)        
    end
end

function FVCardLayer:onKillOverOver()
    self:dispatchEvent(const.EVENT_START_KO)
    self.cardLight:removeLight()
end

-- function FVCardLayer:onShadowCollect()
--     local cards_army = {}
--     local cards_enemy  = {}
--     for seat, card in pairs(self.card_armys) do
--         --local card = v.baseNode
--         if card:getIsShowShadow() then
--             if seat ~= BUDDY_SEAT then
--                 cards_army[seat] = {isVisible = true, x = card:getPositionX(), y = card:getPositionY(),
--                 scaleX = card:getScaleX(), scaleY = card:getScaleY(),
--                 rotate = card.cardN:getRotation(), }
--             end
--         else
--             cards_army[seat] = {isVisible = false}
--         end
--     end

--     for seat, card in pairs(self.card_enemys) do
--         if card:getIsShowShadow() then
--             cards_enemy[seat] = {isVisible = true, x = card:getPositionX(), y = card:getPositionY(),
--                 scaleX = card:getScaleX(), scaleY = card:getScaleY(),
--                 rotate = card.cardN:getRotation(), 
--                 is_boss = card.is_boss
--             }
--         else 
--             cards_enemy[seat] = {isVisible = false}
--         end
--     end

--     self:dispatchEvent(const.EVENT_SHADOW_SHOW, cards_army, cards_enemy)
-- end

return FVCardLayer
