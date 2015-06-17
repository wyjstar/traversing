--单张卡牌属性
local FMCard = class("FMCard")

function FMCard:ctor(prop)
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.fightUitl = getFightUitl()
    self:initAttribute(prop)
    --------------------------------
    
    self.beingBuffs = {} --正在持续的buf
    self.isDead = false  --是否死亡

    self.skillType = 0    --当前技能的类型
    self.heroType = prop.heroType
    local baseConfigName = nil
    if self.heroType == TYPE_HERO_REPLACE then
        baseConfigName = "stage_break_angry_value"
    else
        baseConfigName = "chushi_value_config"
    end

    --怒气配置
    self.baseItem = getTemplateManager():getBaseTemplate():getBaseInfoById(baseConfigName)
    self.anger = self.baseItem[1]        --怒气
    -- self.anger = self.baseItem[3]        --怒气
    self.angerM = self.baseItem[3]      --怒气
    
    self:restAttribute()
    self:initPreBuffs()
    local gId = getNewGManager():getCurrentGid()
    if gId == 0 and ISSHOW_GUIDE then
        self.anger = self.baseItem[3]
    end
end

function FMCard:initAttribute(prop)
    self.owner = prop.owner                 -- 阵营 army  or   enemy
    self.no = prop.no                       -- 战斗单位no
    self.level = prop.level                 -- 等级
    self.quality = prop.quality             -- 战斗单位品质
    self.position = prop.position           -- 位置
    self.is_boss = prop.is_boss             -- 是否是boss
    self.tmp_heroId = prop.tmp_heroId       -- ?
    self.hp = prop.hp                       -- 战斗单位血量
    self.hpM = self.hp                      -- 战斗单位血量上限
    self.atk = prop.atk                     -- 战斗单位攻击
    self.physical_def = prop.physical_def   -- 战斗单位物理防御
    self.magic_def = prop.magic_def         -- 战斗单位魔法防御
    self.hit = prop.hit                     -- 战斗单位命中率
    self.dodge = prop.dodge                 -- 战斗单位闪避率
    self.cri = prop.cri                     -- 战斗单位暴击率
    self.cri_coeff = prop.cri_coeff         -- 战斗单位暴击伤害系数
    self.cri_ded_coeff = prop.cri_ded_coeff -- 战斗单位暴伤减免系数
    self.block = prop.block                 -- 战斗单位格挡率
    self.ductility = prop.ductility         -- 韧性
    self.break_skills = prop.break_skills   -- 突破技能
                                            --
    self.pictureName = prop.pictureName     -- ?
    self.owner = prop.owner                 -- ?
    self.resFrame = prop.resFrame           -- ?
    self.chief = prop.chief                 -- ?
                                            --
    self.is_break = prop.is_break           -- 是否乱入
    self.is_awake = prop.is_awake           -- 是否觉醒
    self.origin_no = prop.origin_no         -- 如果觉醒或者乱入，之前的原始武将

    self.preLoadBuff = {}
    self.name = self.soldierTemplate:getHeroName(self.no)
    local heroItem = nil
    if self.no > 99999 then    --怪物
        heroItem = self.soldierTemplate:getMonsterTempLateById(self.no)
    else
        heroItem = self.soldierTemplate:getHeroTempLateById(self.no)
    end
    self.normal_skill = heroItem.normalSkill
    self.rage_skill = heroItem.rageSkill

    self.normalBuffs = self.soldierTemplate:getSkillTempLateById(self.normal_skill).group
    self.rageBuffs = self.soldierTemplate:getSkillTempLateById(self.rage_skill).group
end

--获得突破技能
function FMCard:getBreakSkill()
    local id = nil
    if self.heroType == TYPE_HERO_AWAKE then
        id = self.origin_no
    else
        id = self.no
    end
    local heroItem = self.soldierTemplate:getHeroTempLateById(id)
    self.break_skills = {}
   
    if heroItem then
        local breakStr = "break"
        for i = 1, 7 do
            local str = breakStr .. i
            local item = heroItem[str]
            if item ~= 0 then
                self.break_skills[i] = item
            end
        end
    end
end

--处理触发参数为2的buff
function FMCard:initPreBuffs()

    if #self.break_skills == 0 then
        return
    end

    for m, n in pairs(self.break_skills) do
        local buffItem = self.soldierTemplate:getSkillBuffTempLateById(n)
        local triggerType = buffItem.triggerType
       
        if triggerType == 2 then
            local effectId = buffItem.effectId
            local valueEffect = buffItem.valueEffect
            local levelEffectValue = buffItem.levelEffectValue
            local arrValue = self.fightUitl:getTargetArr(self, effectId)

            if effectId >= 4 and effectId <= 23 then
                local result = nil
                local valueType = buffItem.valueType
                if valueType == 1 then
                    result = valueEffect + levelEffectValue * self.level
                elseif valueType == 2 then
                    result = arrValue * valueEffect / 100 + levelEffectValue * level
                end
                self:addResult(effectId, result)
            end
        end
    end
end

function FMCard:init()
    for k, v in pairs(self.normalBuffs) do
        self:initPreBuff(v)     
    end
    if self.chief then
       cclog("preLoadBuff==========111111")
        table.print(self.preLoadBuff)
       cclog("preLoadBuff==========1111111")
    end
    for k, v in pairs(self.break_skills) do
        self:initPreBuff(v)
    end
    if self.chief then
       cclog("preLoadBuff==========22222222")
        table.print(self.preLoadBuff)
       cclog("preLoadBuff==========22222222")
    end
end

function FMCard:initPreBuff(buffno)
   cclog("buffno=======" .. buffno)
    local item = self.soldierTemplate:getSkillBuffTempLateById(buffno)
    local triggerType = item.triggerType
    if triggerType == 2 then  
        table.insert(self.preLoadBuff, buffno)
    end
end

function FMCard:getPreBuff()
    local skillType = TYPE_NORMAL_NORMAL
    return self.preLoadBuff, skillType
end

--还原属性
function FMCard:restAttribute()
    self.tempDuctility = self.ductility
    self.tempHp = self.hp                                           --战斗单位血量
    self.tempHpM = self.hpM                                         --战斗单位血量上限
    self.tempAtk = self.atk                                         --战斗单位攻击
    self.tempPhysical_def = self.physical_def                       --战斗单位物理防御
    self.tempMagic_def = self.magic_def                             --战斗单位魔法防御
    self.tempHit = self.hit                                         --战斗单位命中率
    self.tempDodge = self.dodge                                     --战斗单位闪避率
    self.tempCri = self.cri                                         --战斗单位暴击率
    self.tempCri_coeff = self.cri_coeff                             --战斗单位暴击伤害系数
    self.tempCri_ded_coeff = self.cri_ded_coeff                     --战斗单位暴伤减免系数
    self.tempBlock = self.block                                     --战斗单位格挡率
    self.beingBuffs = {}
end

--获得基础数据
function FMCard:getBaseData()
    local baseData = {}
    baseData.owner = self.owner
    baseData.heroId = self.no
    baseData.name = self.name
    baseData.tempHp = self.tempHp
    baseData.tempHpM = self.tempHpM
    baseData.tempAtk = self.tempAtk
    baseData.tempPhysical_def = self.tempPhysical_def
    baseData.tempMagic_def = self.tempMagic_def
    baseData.tempHit = self.tempHit
    baseData.tempDodge = self.tempDodge
    baseData.tempCri = self.tempCri
    baseData.tempCri_coeff = self.tempCri_coeff
    baseData.tempCri_ded_coeff = self.tempCri_ded_coeff
    baseData.tempBlock = self.tempBlock
    baseData.anger = self.anger
    baseData.tempDuctility = self.tempDuctility
    baseData.isDead = self.isDead
    --baseData.break_skills = self.break_skills
    -- baseData.normal_skill = self.normal_skill
    --baseData.rage_skill = self.rage_skilld

    -- baseData.normalBuffs = self.normalBuffs
    -- baseData.rageBuffs = self.rageBuffs

    baseData.level = self.level
    baseData.quality = self.quality
    baseData.position = self.position
    baseData.is_boss = self.is_boss
    baseData.beingBuffs = self.beingBuffs
    return baseData
end

--拿到当前buff
function FMCard:thinkSkill()
   -- cclog("thinkSkill========no===" .. self.no)
   --  local baseData = self:getBaseData()
   --  table.print(baseData)
   -- cclog("thinkSkill========no===" .. self.no)
    local skillId = 1
    local buffs = nil
    local skillType = nil

    local dataTable = {}
    for k, v in pairs(self.beingBuffs) do
        local effectId = v.effectId
        if effectId == 25 then -- 沉默  -- 不能释放怒气技能
            skillType = TYPE_NORMAL_NORMAL  
            skillId = self.normal_skill
            buffs = self.normalBuffs 
        elseif effectId == 24 then  -- 眩晕
            skillType = TYPE_NORMAL_NEXT
            dataTable.skillType = skillType
            return dataTable
        end
    end

    if  skillType == TYPE_NORMAL_NORMAL then
        dataTable.skillType = skillType
        dataTable.skillId = skillId
        dataTable.buffs = buffs
        return dataTable
    end
    
    --怒气还是普通技能
    if self.anger >= self.angerM then 
        dataTable.skillId = self.rage_skill
        dataTable.skillType = TYPE_NORMAL_RAGE
        dataTable.buffs = self.rageBuffs
        return dataTable
    else
        dataTable.skillId = self.normal_skill
        dataTable.skillType = TYPE_NORMAL_NORMAL
        dataTable.buffs = self.normalBuffs
        return dataTable
    end

    return dataTable
end

function FMCard:getPreKeyBuff(keyInfoTable, buffs)
    local tempIsHit = false
    for k, v in pairs(keyInfoTable) do
        local isHit = v.isHit
        if isHit then
            tempIsHit = true
        end
    end
    local newBuffs = {}
    local size = #buffs
    for i = 1, size do
        local item = buffs[i]
        local buffItem = self.soldierTemplate:getSkillBuffTempLateById(item)
        local skill_key = buffItem.skill_key
        if skill_key == 1 and isHit then

            for m, n in pairs(self.break_skills) do
                local breakBuffItem = self.soldierTemplate:getSkillBuffTempLateById(n)
                local triggerType = breakBuffItem.triggerType
                if triggerType == 10 then
                    newBuffs[#newBuffs + 1] = n
                end
            end
        end
        newBuffs[#newBuffs + 1] = item
    end
end

function FMCard:thinkBoddySkill()
    local dataTable = {}
    dataTable.skillId = self.rage_skill
    dataTable.skillType = TYPE_NORMAL_RAGE
    dataTable.buffs = self.rageBuffs
    return dataTable
end

--更新怒气值
function FMCard:updateAnger(skillType, subSkillType)
    if skillType == TYPE_NORMAL then
        if subSkillType == TYPE_NORMAL_NORMAL then
            self.anger = self.anger + self.baseItem[2]
            if self.anger > self.angerM then
                self.anger = self.angerM
            end
        elseif subSkillType == TYPE_NORMAL_RAGE then
            -- self.anger = self.baseItem[1]
            self.anger = 0
        end
    end
end

--处理技能效果
function FMCard:performImpact(dataTable)
    print("FMCard:performImpact")
    local impact = dataTable.impact
    local digit = dataTable.digit
    local rade = dataTable.rade
    local rade = 1
    if dataTable.rade and dataTable.rade > 0 then
        rade = dataTable.rade
    end

    local startCamp = dataTable.startCamp

    local effectId = impact.effectId
    cclog("effectId=====" .. effectId)
    if impact.result then
        local result = impact.result * rade
        print("result=====" .. result)
        self:addResult(effectId, result)
    end
    print("self.owner=====" .. self.owner)
    impact.owner = self.owner
    impact.position = self.position
    cclog("self.tempHp==========" .. self.tempHp)
    if self.tempHp <= 0 then 
        impact.dead = true
        self.isDead = true
    else
        impact.dead = false
        self.isDead = false
    end

    -- impact.baseData = self:getBaseData()
    -- if dataTable.isPreImpact then
    --     impact.fightBackTable = self:getFightBack(dataTable)
    --     -- impact.chaseTable = self:getChase(dataTable)
    -- end
    return impact
end

--获得被攻击可能触发的buff
function FMCard:getFightBack(isBlock)

    local fightBackBuff = {}
    for k, v in pairs(self.break_skills) do
        print("v=====" .. v)
        local item = self.soldierTemplate:getSkillBuffTempLateById(v)
        local triggerType = item.triggerType
        print("triggerType=====" .. triggerType)
        if triggerType == 4 then
            local fightBackBuffItem = {}
            fightBackBuffItem.fightBackBuffNo = v
            fightBackBuffItem.triggerType = triggerType
            fightBackBuff[#fightBackBuff + 1] = fightBackBuffItem
        elseif triggerType == 5 then
            if isBlock then
                local fightBackBuffItem = {}
                fightBackBuffItem.fightBackBuffNo = v
                fightBackBuffItem.triggerType = triggerType
                fightBackBuff[#fightBackBuff + 1] = fightBackBuffItem
            end
        end
    end
    return fightBackBuff
end

--获得攻击之后可能触发的buff
function FMCard:getChase(effectId, subSkillType)
    local chaseBuff = {}
    for k, v in pairs(self.break_skills) do
        local item = self.soldierTemplate:getSkillBuffTempLateById(v)
        local triggerType = item.triggerType

        if effectId == 1 or effectId == 2 or effectId == 3 then
            if triggerType == 6 and subSkillType == TYPE_NORMAL_NORMAL then
                

                local chaseBuffItem = {}
                chaseBuffItem.chaseBuffNo = v
                chaseBuffItem.triggerType = triggerType
                chaseBuff[#chaseBuff + 1] = chaseBuffItem
            end

            if triggerType == 7 and subSkillType == TYPE_NORMAL_RAGE then
                local chaseBuffItem = {}
                chaseBuffItem.chaseBuffNo = v
                chaseBuffItem.triggerType = triggerType
                chaseBuff[#chaseBuff + 1] = chaseBuffItem
            end

            if triggerType == 8 then
                if subSkillType == TYPE_NORMAL_NORMAL or subSkillType == TYPE_NORMAL_RAGE then
                    local chaseBuffItem = {}
                    chaseBuffItem.chaseBuffNo = v
                    chaseBuffItem.triggerType = triggerType
                    chaseBuff[#chaseBuff + 1] = chaseBuffItem
                end
            end
        end
    end

    if effectId == 26 then
        if subSkillType == TYPE_NORMAL_NORMAL or subSkillType == TYPE_NORMAL_RAGE then
            for k, v in pairs(self.preLoadBuff) do
                local item = self.soldierTemplate:getSkillBuffTempLateById(v)
                local triggerType = item.triggerType
                if triggerType == 9 then
                    local chaseBuffItem = {}
                    chaseBuffItem.chaseBuffNo = v
                    chaseBuffItem.triggerType = triggerType
                    chaseBuff[#chaseBuff + 1] = chaseBuffItem
                end
            end
        end
    end

    return chaseBuff
end

--处理技能
function FMCard:performEffect(impact)
   cclog("performEffect=======self.beingBuffs==========")
    table.print(self.beingBuffs)
   cclog("performEffect========self.beingBuffs==========")
    local effectId = impact.effectId
    local continue = impact.continue
    local overlay = impact.overlay
    local result = nil
    if impact.resultData and impact.resultData.result then
        result = impact.resultData.result
    end
    
    local replace = impact.replace
    --cclog("effectId========" .. effectId)
    --cclog("result========" .. result)
    --cclog("continue========" .. continue)
    --cclog("overlay========" .. overlay)
    local item = nil
    for k, v in pairs(self.beingBuffs) do
        if effectId == v.effectId then
            item = v
        end
    end

    if continue > 0 then
        if item then
            if item.overlay == 0 then
                local oldReplace = item.replace
                if replace > oldReplace then
                    item.continue = continue
                    item.overlay = overlay
                    item.result = result
                else

                end
            end        
        else
            local beingBuff = {}
            beingBuff.overlay = overlay
            beingBuff.continue = continue
            beingBuff.effectId = effectId
            beingBuff.result = result
            beingBuff.replace = replace
            table.insert(self.beingBuffs, beingBuff)
        end
    end
end

--更新自身的状态
function FMCard:updateSelfEffect()
    local cloneBeingBuffs = clone(self.beingBuffs)
   cclog("updateSelfEffect")
    table.print(cloneBeingBuffs)
   cclog("updateSelfEffect")

    for k, v in pairs(cloneBeingBuffs) do
        v.continue = v.continue - 1
        local effectId = v.effectId
        if v.continue <= 0 then
            for m, n in pairs(self.beingBuffs) do
                if effectId == n.effectId then
                    table.remove(self.beingBuffs, m)
                end
            end
            self:returnResult(effectId, v.result)
        else
            for m, n in pairs(self.beingBuffs) do
                if effectId == n.effectId then
                    n.continue = n.continue - 1
                end
            end
            
        end
    end

    for k, v in pairs(self.beingBuffs) do
        local effectId = v.effectId
        local result = v.result
        if effectId == 26 then
            self.tempHp = self.tempHp + result
            if self.tempHp > self.tempHpM then
                self.tempHp = self.tempHpM
            end
        elseif effectId == 1 or effectId == 2 or effectId == 3 then
            self.tempHp = self.tempHp - result
            if self.tempHp <= 0 then
                self.isDead = true
            end
        end
    end
end

function FMCard:roundStep()

end

function FMCard:addResult(effectId, result)
    if effectId == 1 then       -- 物理伤害
        self.tempHp = self.tempHp - result
    elseif effectId == 2 then   -- 魔法伤害

        self.tempHp = self.tempHp - result
    elseif effectId == 3 then   -- 纯伤害

        self.tempHp = self.tempHp - result
    elseif effectId == 4 then   -- HP上限增加

        self.tempHpM = self.tempHpM + result
    elseif effectId == 5 then   -- HP上限减少
        -- local tempHpm = self.tempHpM
        self.tempHpM = self.tempHpM - result
        -- if self.tempHpM < 0 then
        --     self.tempHpM = 0
        --     impact.result = tempHpm
        -- end
    elseif effectId == 6 then   -- 攻击力增加

        self.tempAtk = self.tempAtk + result
    elseif effectId == 7 then   -- 攻击力减少

        self.tempAtk = self.tempAtk - result
    elseif effectId == 8 then   -- 怒气增加

        self.anger = self.anger + result
    elseif effectId == 9 then   -- 怒气减少

        self.anger = self.anger - result
    elseif effectId == 10 then  -- 物理防御增加

        self.tempPhysical_def = self.tempPhysical_def + result
    elseif effectId == 11 then  -- 物理防御减少

        self.tempPhysical_def = self.tempPhysical_def - result
    elseif effectId == 12 then  -- 魔法防御增加

        self.tempMagic_def = self.tempMagic_def + result
    elseif effectId == 13 then  -- 魔法防御减少

        self.tempMagic_def = self.tempMagic_def - result
    elseif effectId == 14 then  -- 命中率增加

        self.tempHit = self.tempHit + result
    elseif effectId == 15 then  -- 命中率减少

        self.tempHit = self.tempHit - result
    elseif effectId == 16 then  -- 闪避率增加

        self.tempDodge = self.tempDodge + result
    elseif effectId == 17 then  -- 闪避率减少

        self.tempDodge = self.tempDodge - result
    elseif effectId == 18 then  -- 暴击率增加

        self.tempCri = self.tempCri + result
    elseif effectId == 19 then  -- 暴击率减少

        self.tempCri = self.tempCri - result
    elseif effectId == 20 then  -- 暴击伤害系数

        self.tempCri_coeff = self.tempCri_coeff + result
    elseif effectId == 21 then  -- 暴伤减免系数

        self.tempCri_ded_coeff = self.tempCri_ded_coeff + result
    elseif effectId == 22 then  -- 格挡率增加

        self.tempBlock = self.tempBlock + result
    elseif effectId == 23 then  -- 格挡率减少

        self.tempBlock = self.tempBlock - result
    elseif effectId == 24 then  -- 眩晕
        -- self:performEffect(impact)
    elseif effectId == 25 then  -- 沉默
        -- self:performEffect(impact)
    elseif effectId == 26 then  -- 治疗
        self.tempHp = self.tempHp + result
        if self.tempHp > self.tempHpM then
            self.tempHp = self.tempHpM
        end

    elseif effectId == 27 then  -- 吸血
    end
end

function FMCard:returnResult(effectId, result)
    if effectId == 6 then   -- 攻击力增加

        self.tempAtk = self.tempAtk - result
    elseif effectId == 7 then   -- 攻击力减少

        self.tempAtk = self.tempAtk + result
    elseif effectId == 10 then  -- 物理防御增加

        self.tempPhysical_def = self.tempPhysical_def - result
    elseif effectId == 11 then  -- 物理防御减少

        self.tempPhysical_def = self.tempPhysical_def + result
    elseif effectId == 12 then  -- 魔法防御增加

        self.tempMagic_def = self.tempMagic_def - result
    elseif effectId == 13 then  -- 魔法防御减少

        self.tempMagic_def = self.tempMagic_def + result
    elseif effectId == 14 then  -- 命中率增加

        self.tempHit = self.tempHit - result
    elseif effectId == 15 then  -- 命中率减少

        self.tempHit = self.tempHit + result
    elseif effectId == 16 then  -- 闪避率增加

        self.tempDodge = self.tempDodge - result
    elseif effectId == 17 then  -- 闪避率减少

        self.tempDodge = self.tempDodge + result
    elseif effectId == 18 then  -- 暴击率增加

        self.tempCri = self.tempCri - result
    elseif effectId == 19 then  -- 暴击率减少

        self.tempCri = self.tempCri + result
    elseif effectId == 20 then  -- 暴击伤害系数

        self.tempCri_coeff = self.tempCri_coeff - result
    elseif effectId == 21 then  -- 暴伤减免系数

        self.tempCri_ded_coeff = self.tempCri_ded_coeff - result
    elseif effectId == 22 then  -- 格挡率增加

        self.tempBlock = self.tempBlock - result
    elseif effectId == 23 then  -- 格挡率减少

        self.tempBlock = self.tempBlock + result
    end
end

--处理buff
function FMCard:performBuff(impact)
    local effectId = impact.effectId
    local beingBuffIndex = self:checkIsBeingBuff(impact)
    if beingBuffIndex ~= -1 then  --如果身上有这种buff
        local continue = impact.continue
        local overlay = impact.overlay
        local oldImpact = self.beingBuffs[beingBuffIndex]
        if overlay == 1 then  --替换
            oldImpact.continue = continue
        elseif overlay == 2 then  --叠加
            oldImpact.continue = oldImpact.continue + continue
        end
    else
        self.beingBuffs[effectId] = impact
    end
end

--身上buff的index
function FMCard:getBeingBuffIndex(impact)
    local effectId = impact.effectId
    for k, v in pairs(self.beingBuffs) do
        if v.effectId == effectId then
            return k
        end
    end
    return -1
end

return FMCard








