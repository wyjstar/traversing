
local FVCardState = class("FVCardState", function()
    return mvc.ViewNode()
end)

function FVCardState:ctor(prop, no)
    self.data = {hpcur = CONFIG_HP_MAX, mpcur = CONFIG_MP_MIN}
    self:init(prop, no)
end

function FVCardState:init(prop, no_)
    --print("hero_no;=====", prop.no)
    if prop == nil then
        return
    end
    local no = no_ or prop.no
    local soldierTemplate = getTemplateManager():getSoldierTemplate()
    --血条背景
    self.trough = mvc.ViewSprite("#c_trough.png")  
    local hpSprite = mvc.ViewSprite(string.format("#c_hp%d.png", CONFIG_HP_MAX))
    local mpSprite = mvc.ViewSprite(string.format("#c_mp%d.png", CONFIG_MP_MAX))
    --血条进度条
    self.hp = cc.ProgressTimer:create(hpSprite)
    self.hp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.hp:setBarChangeRate(cc.p(1, 0))
    self.hp:setMidpoint(cc.p(0, 0.5))
    self.hp:setPercentage(100)
    --怒气进度条
    self.mp = cc.ProgressTimer:create(mpSprite)
    self.mp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.mp:setBarChangeRate(cc.p(1, 0))
    self.mp:setMidpoint(cc.p(0, 0.5))
    if prop.is_break and tonumber(prop.no) == tonumber(no) then
        self.mp:setPercentage(100)
    else
        self.mp:setPercentage(0)
    end

    self.hp:setAnchorPoint(cc.p(0, 0))
    self.mp:setAnchorPoint(cc.p(0, 0))

    self.trough:addChild(self.hp)
    self.trough:addChild(self.mp)
    self.is_world_boss = (getFCProcess().fight_type == TYPE_WORLD_BOSS and prop.side == "blue") -- 蓝方 BOSS 
    print("hero_no;=====", no)
    self.kind = soldierTemplate:getHeroKindById(no)
    self.hp:setPosition(CONFIG_CARD_HP_X, CONFIG_CARD_HP_Y)
    self.mp:setPosition(CONFIG_CARD_MP_X, CONFIG_CARD_MP_Y)
    self.kind:setPosition(CONFIG_CARD_KIND_X, CONFIG_CARD_KIND_Y)

    if self.is_world_boss then
        print("this is boss.......")
        local scale = 2
        self.trough:setPosition(40, -200)
        self.trough:setScale(scale)
    else
        self.trough:setPosition(CONFIG_CARD_STATE_X, CONFIG_CARD_STATE_Y)
    end
    
    self.trough:addChild(self.kind)
    self.trough:setCascadeOpacityEnabled(true)
    self:addChild(self.trough)
    self:setCascadeOpacityEnabled(true)
    self:initbuffInfo(prop)
end

function FVCardState:initbuffInfo(prop)
    self.vertigoSprite = game.newSprite("#buff_bg.png")
    self.silenceSprite = game.newSprite("#buff_bg.png")
    self.beHitSprite = game.newSprite("#buff_bg.png")

    local buff_bg1 = game.newSprite("#xuanyun.png")
    local buff_bg2 = game.newSprite("#chenmo.png")
    local buff_bg3 = game.newSprite("#diaoxue.png")

    -- self.vertigoLabel = cc.LabelAtlas:_create("", "res/ui/ui_f_d_atlas2.png", 34, 55, string.byte("/"))
    -- self.silenceLabel = cc.LabelAtlas:_create("", "res/ui/ui_f_d_atlas2.png", 34, 55, string.byte("/"))

    local width = self.vertigoSprite:getContentSize().width / 2
    local height = self.vertigoSprite:getContentSize().height / 2

    self.vertigoSprite:addChild(buff_bg1)
    self.silenceSprite:addChild(buff_bg2)
    self.beHitSprite:addChild(buff_bg3)

    buff_bg1:setPosition(width, height + buff_bg1:getContentSize().height / 4)
    buff_bg2:setPosition(width - 0.7, height + buff_bg2:getContentSize().height / 4)
    buff_bg3:setPosition(width, height + buff_bg3:getContentSize().height / 4 - 2.1)

    self.vertigoSprite:setScale(2)
    self.silenceSprite:setScale(2)
    self.beHitSprite:setScale(2)

    self:addChild(self.vertigoSprite)
    self:addChild(self.silenceSprite)
    self:addChild(self.beHitSprite)

    -- self:addChild(self.vertigoLabel)
    -- self:addChild(self.silenceLabel)

    local quality = prop.quality
    self.is_world_boss = (getFCProcess().fight_type == TYPE_WORLD_BOSS and prop.side == "blue")
    if not self.is_world_boss then
        local hight = 180
        self.vertigoSprite:setPosition(-80, hight)
        self.silenceSprite:setPosition(0, hight)
        self.beHitSprite:setPosition(80, hight)
    else
        local width = 170
        self.vertigoSprite:setPosition(width, 80)
        self.silenceSprite:setPosition(width, 0)
        self.beHitSprite:setPosition(width, -80)
    end

    self.vertigoSprite:setVisible(false)
    self.silenceSprite:setVisible(false)
    self.beHitSprite:setVisible(false)
    
    local action = self:createBuffAction()
    buff_bg1:runAction(action:clone())
    buff_bg2:runAction(action:clone())
    buff_bg3:runAction(action:clone())
    buff_bg1:setTag(10000)
    buff_bg2:setTag(10000)
    buff_bg3:setTag(10000)
end

function FVCardState:createBuffAction()
    local fadeInAction = cc.FadeIn:create(0.5)
    local fadeOutAction = cc.FadeOut:create(0.5)
    local sequence = cc.Sequence:create(fadeInAction, fadeOutAction)
    return cc.RepeatForever:create(sequence)
end

function FVCardState:playActionState(unit)
    self:updateHeroState(unit)
    self:updateEffectState(unit)
    self:updateHeroAnger(unit)
end

function FVCardState:updateHeroState(hero)
    cclog("FVCardState:updateHeroState=============>%d", hero:get_hp_percent())    
    self.hp:setPercentage(hero:get_hp_percent())
end

function FVCardState:updateEffectState(unit)
    self:updateHeroEffect(unit)
end

function FVCardState:updateHeroEffect(hero)
    local beingBuffs_old = hero.buff_manager.buffs
    local beingBuffs = clone(beingBuffs_old)

    local posIndex = 0
    
    self.silenceSprite:setVisible(false)
    -- self.silenceLabel:setVisible(false)
    self.vertigoSprite:setVisible(false)
    -- self.vertigoLabel:setVisible(false)
    self.beHitSprite:setVisible(false)

    local posTable = {}
    if self.is_world_boss then

    else
        local height = 180
        posTable = {cc.p(-80, height), cc.p(0, height), cc.p(80, height)}
    end

    for k, buffs in pairs(beingBuffs) do
        
        local effectId = k
        for _,v in pairs(buffs) do
            local continue = v.continue_num
            if effectId == 25 then -- 沉默
                posIndex = posIndex + 1
                print("posIndex=====" .. posIndex)
                self.silenceSprite:setVisible(true)
                -- self.silenceLabel:setVisible(true)

                self.silenceSprite:setPosition(posTable[posIndex])
                -- self.silenceLabel:setPosition(posIndex* 50, 100)
                -- self.silenceLabel:setString(tostring(continue))
            elseif effectId == 24 then  -- 眩晕
                posIndex = posIndex + 1
                print("posIndex=====" .. posIndex)
                self.vertigoSprite:setVisible(true)
                -- self.vertigoLabel:setVisible(true)
                self.vertigoSprite:setPosition(posTable[posIndex])
                -- self.vertigoLabel:setPosition(posIndex* 50, 100)
                -- self.vertigoLabel:setString(tostring(continue))
            elseif effectId == 1 or effectId == 2 or effectId == 3 then -- 持续掉血
                posIndex = posIndex + 1
                print("posIndex=====" .. posIndex)
                self.beHitSprite:setVisible(true)
                self.beHitSprite:setPosition(posTable[posIndex])
            end
        end
    end
end

function FVCardState:removeBuffs(hero,buff)
    local beingBuffs_old = hero.buff_manager.buffs --这是英雄已有的Buffs
    local removeBuffId = buff.buff_info
    local effectId = buff.buff_info.effectId
    for k,buffs in pairs(hero.buff_manager.buffs) do
        if k == effectId then
            for _,v in pairs(buffs) do
                -- v.continue_num = v.continue_num - 1
                if v.continue_num <= 0 then --Buff 移除
                    if effectId == 25 then 
                        self.silenceSprite:setVisible(false)
                    elseif effectId == 24 then
                        self.vertigoSprite:setVisible(false)
                    elseif effectId == 1 or effectId == 2 or effectId == 3 then -- 持续掉血
                        self.beHitSprite:setVisible(false)
                    end 
                end
            end
        end
    end
end

function FVCardState:updateAnger(dataTable)
    self:updateHeroAnger(dataTable.hero)
end

function FVCardState:updateHeroAnger(hero)
    self.mp:setPercentage(hero:get_mp_percent())
    -- local mp_percent = hero:get_mp_percent()
    -- print("mp_percent==========="..mp_percent.."hero.no========"..hero.no)
    -- if mp_percent > 0 then
    --     self.mp:setVisible(true)
    -- else
    --     self.mp:setVisible(false)
    -- end

    -- local a1 = self.data.mpcur
    -- local a2 = math.min(CONFIG_HP_MAX, math.floor(mp_percent * CONFIG_HP_MAX + 1))

    -- if a1 == a2 then
    --     return
    -- end
    -- local frames = game.newFrames("c_mp%d.png", a1, a2, a1 > a2)
    -- self.mp:setVisible(true)
    -- self.data.mpcur = a2

    -- self.mp:stopAllActions()
    -- self.mp:runAction(cc.Animate:create(game.newAnimation(frames, 0.05)))
end

function FVCardState:updateAllState(hero)

    self:updateHeroState(hero)
   
    self:updateHeroEffect(hero)

    self:updateHeroAnger(hero)
 
end

return FVCardState







