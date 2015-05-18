--英雄其他计算类

local OtherCalculation = OtherCalculation or class("OtherCalculation")

function OtherCalculation:ctor()
    self.c_LineupData = getDataManager():getLineupData()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self.c_SoldierCalculation = getCalculationManager():getSoldierCalculation()
    self.c_EquipCalculation = getCalculationManager():getEquipCalculation()

end

--获得是否暴击
function OtherCalculation:getIsCrit(heroPB)
    local hero_no = heroPB.hero_no
    local break_level = heroPB.break_level
    local level = heroPB.level
    --暴击率
    local critRate = self:getHeroCritRate(hero_no, level, break_level)
    local tempRate =  math.random(0,100)
    if tempRate > critRate  then
        return true
    else
        return false
    end
end

--获得是否格挡
function OtherCalculation:getIsBlock(heroPB)
    local hero_no = heroPB.hero_no
    local break_level = heroPB.break_level
    local level = heroPB.level
    --格挡率
    local critRate = self:getHeroBlockRate(hero_no, level, break_level)
    local tempRate =  math.random(0,100)
    if tempRate > critRate * 100 then
        return true
    else
        return false
    end
end

------------------------------------------------------------------------------------
--总命中率
function OtherCalculation:getHeroHitRate(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    --英雄基础命中率
    local hit = soldierTemplate.hit
    --技能附加命中率
    local skillValue = self:getAddHitRateSkill(hero_no, level, break_level)
    --装备附加命中率
    local equipValue = self.c_EquipCalculation:getHitRateEquipByHeroId(hero_no)
    local result = self:getHitRate(hit, skillValue, equipValue)
end

--总暴击率
function OtherCalculation:getHeroCritRate(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    --英雄基础暴击率
    local cri = soldierTemplate.cri
    --技能附加暴击率
    local skillValue = self:getHeroCritRateSkill(hero_no, level, break_level)
    --装备附加暴击率
    local equipValue = self.c_EquipCalculation:getCritRateEquipByHeroId(hero_no)
    local result = self:getHitRate(cri, skillValue, equipValue)
end

--总闪避率
function OtherCalculation:getHeroDodgeRate(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    --英雄基础闪避率
    local dodge = soldierTemplate.dodge
    --技能附加命中率
    local skillValue = self:getAddHitRateSkill(hero_no, level, break_level)
    --装备附加命中率
    local equipValue = self.c_EquipCalculation:getHeroDodgeRateSkill(hero_no)
    local result = self:getHitRate(dodge, skillValue, equipValue)
end

--总格挡率
function OtherCalculation:getHeroBlockRate(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    --英雄基础格挡率
    local block = soldierTemplate.block
    --技能附加格挡率
    local skillValue = self:getAddHitRateSkill(hero_no, level, break_level)
    --装备附加命格挡率
    local equipValue = self.c_EquipCalculation:getHeroBlockRateSkill(hero_no)
    local result = self:getHitRate(block, skillValue, equipValue)
end

--总暴击伤害系数
function OtherCalculation:getHeroCriCoeff(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    --英雄基础暴击伤害系数
    local criCoeff = soldierTemplate.criCoeff
    --技能附加暴击伤害系数
    local skillValue = self:getHeroCriCoeffSkill(hero_no, level, break_level)
    --装备附加暴击伤害系数
    local equipValue = self.c_EquipCalculation:getCriCoeffEquipByHeroId(hero_no)
    local result = self:getHitRate(criCoeff, skillValue, equipValue)
end

--总暴伤减免系数
function OtherCalculation:getHeroCriDedCoeff(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    --英雄基础暴伤减免系数
    local criDedCoeff = soldierTemplate.criDedCoeff
    --技能附加暴伤减免系数
    local skillValue = self:getHeroCriDedCoeffSkill(hero_no, level, break_level)
    --装备附加暴伤减免系数
    local equipValue = self.c_EquipCalculation:getCriDedCoeffEquipByHeroId(hero_no)
    local result = self:getHitRate(criDedCoeff, skillValue, equipValue)
end

------------------------------------------------------------------------------------
--技能附加命中率
function OtherCalculation:getAddHitRateSkill(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    --处理普通技能
    local normalSkill = soldierTemplate.normalSkill
    local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local group = skillTempLate.group
    local normalAddValue = 0
    for k, v in pairs(group) do

        local addPerItem = self:getAddHitRateSkillTrigger(v, level)
        normalAddValue = normalAddValue + addPerItem

        local skillBuffItem = nil
    end

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group

        for k, v in pairs(group) do

            local addPerItem = self:getAddHitRateSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link

            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group

            for k, v in pairs(group) do

                local addPerItem = self:getAddHitRateSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    print("hero_no==" .. hero_no)
    print("normalAddValue====" .. normalAddValue)
    print("breakAddValue====" .. breakAddValue)
    print("linkAddValue====" .. linkAddValue)
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    local totleAddPer = normalAddValue + breakAddValue + linkAddValue
    return totleAddPer
end

--技能附加命中率
--触发条件为1,效果ID为的技能14或15，数值类别为2，作用位置为{11:0}的技能
function OtherCalculation:getAddHitRateSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect
    local levelEffectValue = skillBuffItem.levelEffectValue

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 14 or effectId == 15 then --效果ID为的技能14或15
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                local addPerItem = valueEffect + levelEffectValue * level
                return addPerItem
            end
            
        end
    end
    return 0
end
------------------------------------------------------------------------------------
--技能附加暴击率
function OtherCalculation:getHeroCritRateSkill(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    --处理普通技能
    local normalSkill = soldierTemplate.normalSkill
    local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local group = skillTempLate.group
    local normalAddValue = 0
    for k, v in pairs(group) do

        local addPerItem = self:getHeroCritRateSkillTrigger(v, level)
        normalAddValue = normalAddValue + addPerItem

        local skillBuffItem = nil
    end

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group

        for k, v in pairs(group) do

            local addPerItem = self:getHeroCritRateSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link

            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group

            for k, v in pairs(group) do

                local addPerItem = self:getHeroCritRateSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    print("hero_no==" .. hero_no)
    print("normalAddValue====" .. normalAddValue)
    print("breakAddValue====" .. breakAddValue)
    print("linkAddValue====" .. linkAddValue)
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    local totleAddPer = normalAddValue + breakAddValue + linkAddValue
    return totleAddPer
end

--技能附加暴击率
--触发条件为1,效果ID为的技能18或19，数值类别为2，作用位置为{11:0}的技能
function OtherCalculation:getHeroCritRateSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect
    local levelEffectValue = skillBuffItem.levelEffectValue

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 18 or effectId == 19 then --效果ID为的技能18或19
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                local addPerItem = valueEffect + levelEffectValue * level
                return addPerItem
            end
            
        end
    end
    return 0
end

------------------------------------------------------------------------------------
--技能附加闪避率
function OtherCalculation:getHeroDodgeRateSkill(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    --处理普通技能
    local normalSkill = soldierTemplate.normalSkill
    local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local group = skillTempLate.group
    local normalAddValue = 0
    for k, v in pairs(group) do

        local addPerItem = self:getHeroDodgeRateSkillTrigger(v, level)
        normalAddValue = normalAddValue + addPerItem

        local skillBuffItem = nil
    end

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group

        for k, v in pairs(group) do

            local addPerItem = self:getHeroDodgeRateSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link

            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group

            for k, v in pairs(group) do

                local addPerItem = self:getHeroDodgeRateSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    print("hero_no==" .. hero_no)
    print("normalAddValue====" .. normalAddValue)
    print("breakAddValue====" .. breakAddValue)
    print("linkAddValue====" .. linkAddValue)
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    local totleAddPer = normalAddValue + breakAddValue + linkAddValue
    return totleAddPer
end

--技能附加闪避率
--触发条件为1,效果ID为的技能16或17，数值类别为2，作用位置为{11:0}的技能
function OtherCalculation:getHeroDodgeRateSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect
    local levelEffectValue = skillBuffItem.levelEffectValue

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 16 or effectId == 17 then --效果ID为的技能16或17
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                local addPerItem = valueEffect + levelEffectValue * level
                return addPerItem
            end
            
        end
    end
    return 0
end

------------------------------------------------------------------------------------
--技能附加格挡率
function OtherCalculation:getHeroBlockRateSkill(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    --处理普通技能
    local normalSkill = soldierTemplate.normalSkill
    local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local group = skillTempLate.group
    local normalAddValue = 0
    for k, v in pairs(group) do

        local addPerItem = self:ggetHeroBlockRateSkillTrigger(v, level)
        normalAddValue = normalAddValue + addPerItem

        local skillBuffItem = nil
    end

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group

        for k, v in pairs(group) do

            local addPerItem = self:ggetHeroBlockRateSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link

            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group

            for k, v in pairs(group) do

                local addPerItem = self:ggetHeroBlockRateSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    print("hero_no==" .. hero_no)
    print("normalAddValue====" .. normalAddValue)
    print("breakAddValue====" .. breakAddValue)
    print("linkAddValue====" .. linkAddValue)
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    local totleAddPer = normalAddValue + breakAddValue + linkAddValue
    return totleAddPer
end

--技能附加格挡率
--触发条件为1,效果ID为的技能22或23，数值类别为2，作用位置为{11:0}的技能
function OtherCalculation:ggetHeroBlockRateSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect
    local levelEffectValue = skillBuffItem.levelEffectValue

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 22 or effectId == 23 then --效果ID为的技能22或23
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                local addPerItem = valueEffect + levelEffectValue * level
                return addPerItem
            end
            
        end
    end
    return 0
end
------------------------------------------------------------------------------------

--技能暴击伤害系数
function OtherCalculation:getHeroCriCoeffSkill(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    --处理普通技能
    local normalSkill = soldierTemplate.normalSkill
    local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local group = skillTempLate.group
    local normalAddValue = 0
    for k, v in pairs(group) do

        local addPerItem = self:getHeroCriCoeffSkillTrigger(v, level)
        normalAddValue = normalAddValue + addPerItem

        local skillBuffItem = nil
    end

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group

        for k, v in pairs(group) do

            local addPerItem = self:getHeroCriCoeffSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link

            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group

            for k, v in pairs(group) do

                local addPerItem = self:getHeroCriCoeffSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    print("hero_no==" .. hero_no)
    print("normalAddValue====" .. normalAddValue)
    print("breakAddValue====" .. breakAddValue)
    print("linkAddValue====" .. linkAddValue)
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    local totleAddPer = normalAddValue + breakAddValue + linkAddValue
    return totleAddPer
end

--技能暴击伤害系数
--触发条件为1,效果ID为的技能20，数值类别为2，作用位置为{11:0}的技能
function OtherCalculation:getHeroCriCoeffSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect
    local levelEffectValue = skillBuffItem.levelEffectValue

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 20 then --效果ID为的技能20
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                local addPerItem = valueEffect + levelEffectValue * level
                return addPerItem
            end
            
        end
    end
    return 0
end

------------------------------------------------------------------------------------
--技能暴伤减免系数
function OtherCalculation:getHeroCriDedCoeffSkill(hero_no, level, break_level)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    --处理普通技能
    local normalSkill = soldierTemplate.normalSkill
    local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(normalSkill)
    local group = skillTempLate.group
    local normalAddValue = 0
    for k, v in pairs(group) do

        local addPerItem = self:getHeroCriDedCoeffSkillTrigger(v, level)
        normalAddValue = normalAddValue + addPerItem

        local skillBuffItem = nil
    end

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group

        for k, v in pairs(group) do

            local addPerItem = self:getHeroCriDedCoeffSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link

            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group

            for k, v in pairs(group) do

                local addPerItem = self:getHeroCriDedCoeffSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    print("hero_no==" .. hero_no)
    print("normalAddValue====" .. normalAddValue)
    print("breakAddValue====" .. breakAddValue)
    print("linkAddValue====" .. linkAddValue)
    print("<<<<<<<<<<<getAddHitRateSkill<<<<<<<<<<<<<")
    local totleAddPer = normalAddValue + breakAddValue + linkAddValue
    return totleAddPer
end

--技能暴伤减免系数
--触发条件为1,效果ID为的技能21，数值类别为2，作用位置为{11:0}的技能
function OtherCalculation:getHeroCriDedCoeffSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect
    local levelEffectValue = skillBuffItem.levelEffectValue

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 21 then --效果ID为的技能21
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                local addPerItem = valueEffect + levelEffectValue * level
                return addPerItem
            end
            
        end
    end
    return 0
end
------------------------------------------------------------------------------------
--[[
总命中率
k1:英雄基础命中率
k2:技能附加命中率
k3: 装备附加命中率
]]
function OtherCalculation:getHitRate(k1, k2, k3)
    return  k1 + k2 + k3
end

--[[
总暴击率
k1:英雄基础暴击率
k2:技能附加暴击率
k3: 装备附加暴击率
]]
function OtherCalculation:getCritRate(k1, k2, k3)
    return  k1 + k2 + k3
end

--[[
总闪避率
k1:英雄基础闪避率
k2:技能附加闪避率
k3: 装备附加闪避率
]]
function OtherCalculation:getDodgeRate(k1, k2, k3)
    return  k1 + k2 + k3
end

--[[
总格挡率
k1:英雄基础格挡率
k2:技能附加格挡率
k3: 装备附加格挡率
]]
function OtherCalculation:getBlockRate(k1, k2, k3)
    return  k1 + k2 + k3
end

--[[
总暴击伤害系数
k1:英雄基础暴击伤害系数
k2:技能附加暴击伤害系数
k3: 装备附加暴击伤害系数
]]
function OtherCalculation:getCriCoeff(k1, k2, k3)
    return  k1 + k2 + k3
end

--[[
总暴伤减免系数
k1:英雄基础暴伤减免系数
k2:技能附加暴伤减免系数
k3: 装备附加暴伤减免系数
]]
function OtherCalculation:getCriDedCoeff(k1, k2, k3)
    return  k1 + k2 + k3
end

return OtherCalculation













