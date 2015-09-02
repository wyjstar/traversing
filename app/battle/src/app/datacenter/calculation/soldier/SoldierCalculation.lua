--数据计算类

SoldierCalculation = SoldierCalculation or class("SoldierCalculation")

function SoldierCalculation:ctor()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    
    self.c_EquipCalculation = getCalculationManager():getEquipCalculation()
    self.c_LegionCalculation = getCalculationManager():getLegionCalculation()
    self.c_LineupData = getDataManager():getLineupData()
end

-- function SoldierCalculation
--根据heroPB获得hp
function SoldierCalculation:getHeroHpByHeroPB(heroPB)
    local hero_no = heroPB.hero_no
    local break_level = heroPB.break_level
    local level = heroPB.level
    return self:getSoldierHP(hero_no, level, break_level)
end

--根据heroPB获得atk
function SoldierCalculation:getHeroAtkByHeroPB(heroPB)
    local hero_no = heroPB.hero_no
    local break_level = heroPB.break_level
    local level = heroPB.level
    return self:getSoldierATK(hero_no, level, break_level)
end

--根据heroPB获得物理防御
function SoldierCalculation:getHeroPDefByHeroPB(heroPB)
    local hero_no = heroPB.hero_no
    local break_level = heroPB.break_level
    local level = heroPB.level
    return self:getSoldierPDEF(hero_no, level, break_level)
end

--根据heroPB获得魔法防御
function SoldierCalculation:getHeroMDefByHeroPB(heroPB)
    local hero_no = heroPB.hero_no
    local break_level = heroPB.break_level
    local level = heroPB.level
    return self:getSoldierMDEF(hero_no, level, break_level)
end

-----------------------------------------------------------------------------------
--对外获得sildier总得hp血量
--soldierItem：从服务器获得的列表中的一个
function SoldierCalculation:getSoldierHP(hero_no, level, break_level, isBase)
    if isBase == nil then isBase = false end
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    local hp = soldierTemplate.hp
    local growHp = soldierTemplate.growHp

    local hpAddPer = self:getHPAddPer(hero_no, level, break_level, isBase)  -- k4
    local hpAddValue = self:getHPAddValue(hero_no, level, break_level, isBase) -- k5
    local result = self:getHP(hp, growHp, level, hpAddPer, hpAddValue)
    result = roundNumber(result)
    return result
end

--对外获得攻击力
function SoldierCalculation:getSoldierATK(hero_no, level, break_level, isBase)
    if isBase == nil then isBase = false end
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    local atk = soldierTemplate.atk
    local growAtk = soldierTemplate.growAtk

    local atkAddPer = self:getAtkAddPer(hero_no, level, break_level, isBase)
    local atkAddValue = self:getAtkAddValue(hero_no, level, break_level, isBase)

    local result = self:getATK(atk, growAtk, level, atkAddPer, atkAddValue)
    result = roundNumber(result)
    return result
end

--对外获得物理防御
function SoldierCalculation:getSoldierPDEF(hero_no, level, break_level, isBase)
    if isBase == nil then isBase = false end
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    local physicalDef = soldierTemplate.physicalDef
    local growPhysicalDef = soldierTemplate.growPhysicalDef

    local pdefAddPer = self:getPedfAddPer(hero_no, level, break_level, isBase)
    local pdefAddValue = self:getPdefAddValue(hero_no, level, break_level, isBase)

    local result = self:getPDEF(physicalDef, growPhysicalDef, level, pdefAddPer, pdefAddValue)
    print("result", physicalDef, growPhysicalDef, level, pdefAddPer, pdefAddValue)
    result = roundNumber(result)
    return result
end

--对外获得魔法防御
function SoldierCalculation:getSoldierMDEF(hero_no, level, break_level, isBase)
    if isBase == nil then isBase = false end
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    local magicDef = soldierTemplate.magicDef
    local growMagicDef = soldierTemplate.growMagicDef

    local mdefAddPer = self:getMdefAddPer(hero_no, level, break_level, isBase)
    local mdefAddValue = self:getMdefAddValue(hero_no, level, break_level, isBase)

    local result = self:getMDEF(magicDef, growMagicDef, level, mdefAddPer, mdefAddValue)
    result = roundNumber(result)
    return result
end

-----------------------------------------------------------------------------------
--总hp附加百分比 k4
function SoldierCalculation:getHPAddPer(hero_no, level, break_level, isBase)
    local tempValue = 0
    --技能
    local valueA = self:getHPAddPerSkill(hero_no, level, break_level, isBase)
    tempValue = tempValue + valueA
    return tempValue
end

--总atk附加百分比
function SoldierCalculation:getAtkAddPer(hero_no, level, break_level, isBase)
    local tempValue = 0
    --技能
    local valueA = self:getAtkAddPerSkill(hero_no, level, break_level, isBase)
    tempValue = tempValue + valueA
    return tempValue
end

--总pdef附加百分比
function SoldierCalculation:getPedfAddPer(hero_no, level, break_level, isBase)
    local tempValue = 0
    --技能
    local valueA = self:getPedfAddPerSkill(hero_no, level, break_level, isBase)
    tempValue = tempValue + valueA
    return tempValue
end

--总mdef附加百分比
function SoldierCalculation:getMdefAddPer(hero_no, level, break_level, isBase)
    local tempValue = 0
    --技能
    local valueA = self:getMdefAddPerSkill(hero_no, level, break_level, isBase)
    tempValue = tempValue + valueA
    return tempValue
end
-------------------------------------------
--总HP附加值
function SoldierCalculation:getHPAddValue(hero_no, level, break_level, isBase)
    --技能附加HP值
    local valueA = self:getHPAddValueSkill(hero_no, level, break_level, isBase)

    if isBase == true then return valueA end

    --装备附加HP值
    local valueB = self.c_EquipCalculation:getHpAddValueEquipByHeroId(hero_no)
    --公会附加HP值
    local valueC = self.c_LegionCalculation:getHpAddValueLegion()
    --炼体附加HP值
    local valueD = self.c_SoldierData:getHPFromSeal(hero_no)
    --符文附加HP值

    return tonumber(valueA) + tonumber(valueB) + tonumber(valueC) + tonumber(valueD)
end

--总atk附加值
function SoldierCalculation:getAtkAddValue(hero_no, level, break_level, isBase)
    --技能
    local valueA = self:getAtkAddValueSkill(hero_no, level, break_level, isBase)

    if isBase == true then return valueA end

    --装备附加ATK值
    local valueB = self.c_EquipCalculation:getAtkAddValueEquipByHeroId(hero_no)
    --公会附加ATK值
    local valueC = self.c_LegionCalculation:getAtkAddValueLegion()
    --炼体附加ATK值
    local valueD = self.c_SoldierData:getAtkFromSeal(hero_no)
    --符文附加ATK值

    return valueA + valueB + valueC + valueD
end

--总pdef附加值
function SoldierCalculation:getPdefAddValue(hero_no, level, break_level, isBase)
    --技能
    local valueA = self:getPdefAddValueSkill(hero_no, level, break_level, isBase)

    if isBase == true then return valueA end

    --装备附加pdef值
    local valueB = self.c_EquipCalculation:getPdefAddValueEquipByHeroId(hero_no)
    --公会附加pdef值
    local valueC = self.c_LegionCalculation:getPdefAddValueLegion()
    --炼体附加pdef值
    local valueD = self.c_SoldierData:getPdefFromSeal(hero_no)
    --符文附加pdef值

    return valueA + valueB + valueC + valueD
end

--总mdef附加值
function SoldierCalculation:getMdefAddValue(hero_no, level, break_level, isBase)
    --技能
    local valueA = self:getMdefAddValueSkill(hero_no, level, break_level)

    if isBase == true then return valueA end

    --装备附加mdef值
    local valueB = self.c_EquipCalculation:getMdefAddValueEquipByHeroId(hero_no)
    --公会附加mdef值
    local valueC = self.c_LegionCalculation:getMdefAddValueLegion()
    --炼体附加mdef值
    local valueD = self.c_SoldierData:getMdefFromSeal(hero_no)
    --符文附加mdef值
    
    return valueA + valueB + valueC + valueD
end

-----------------------------------------------------------------------------------
---------------------------------附加百分比---------------
-------------hp----------
--技能附加HP百分比
function SoldierCalculation:getHPAddPerSkill(hero_no, level, break_level, isBase)
    if isBase == nil then isBase = false end

    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)

    --处理突破技能
    local breakAddPerValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group
        for k, v in pairs(group) do
            local addPerItem = self:getHPAddPerSkillTrigger(v, level)
            breakAddPerValue = breakAddPerValue + addPerItem
        end
    end

    if isBase == true then return breakAddPerValue end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddPerValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        -- print("hero_no=======" .. hero_no)
        -- table.print(linkItemTable)
        for k, v in pairs(linkItemTable) do
            local link = v.link
            
            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group
            for k, v in pairs(group) do
                local addPerItem = self:getHPAddPerSkillTrigger(v, level)
                linkAddPerValue = linkAddPerValue + addPerItem
            end
        end
    end

    return breakAddPerValue + linkAddPerValue
end

--技能附加hp百分比(触发)
--触发条件为1,效果ID为的技能4或5，数值类别为2，作用位置为{11:0}的技能
function SoldierCalculation:getHPAddPerSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 4 or effectId == 5 then --效果ID为的技能4或5
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                return valueEffect
            end
        end
    end
    return 0
end

------------atk-----------
--技能atk附加百分比
function SoldierCalculation:getAtkAddPerSkill(hero_no, level, break_level, isBase)
    --处理突破技能
    local breakAddPerValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group
        for k, v in pairs(group) do
            local addPerItem = self:getAtkAddPerSkillTrigger(v, level)
            breakAddPerValue = breakAddPerValue + addPerItem
        end
    end

    if isBase == true then return breakAddPerValue end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddPerValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link
            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group
            for k, v in pairs(group) do
                local addPerItem = self:getAtkAddPerSkillTrigger(v, level)
                linkAddPerValue = linkAddPerValue + addPerItem
            end
        end
    end

    return breakAddPerValue + linkAddPerValue 
end

--技能附加atk百分比(触发)
--触发条件为1,效果ID为的技能6或7，数值类别为2，作用位置为{11:0}的技能
function SoldierCalculation:getAtkAddPerSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 6 or effectId == 7 then --效果ID为的技能6或7
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                return valueEffect
            end
        end
    end
    return 0
end

------------Pdef-----------
--技能附加PDEF百分比
function SoldierCalculation:getPedfAddPerSkill(hero_no, level, break_level, isBase)

    --处理突破技能
    local breakAddPerValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group
        for k, v in pairs(group) do
            local addPerItem = self:getPedfAddPerSkillTrigger(v, level)
            breakAddPerValue = breakAddPerValue + addPerItem
        end
    end

    if isBase == true then return breakAddPerValue end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddPerValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link

            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group

            for k, v in pairs(group) do

                local addPerItem = self:getPedfAddPerSkillTrigger(v, level)
                linkAddPerValue = linkAddPerValue + addPerItem
            end
        end
    end

    return breakAddPerValue + linkAddPerValue
end

--技能附加pdef百分比(触发)
--触发条件为1,效果ID为的技能10或11，数值类别为2，作用位置为{11:0}的技能
function SoldierCalculation:getPedfAddPerSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect
    local levelEffectValue = skillBuffItem.levelEffectValue

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 10 or effectId == 11 then --效果ID为的技能10或11
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                return valueEffect
            end
            
        end
    end
    return 0
end

------------Mdef-----------
--技能附加MDEF百分比
function SoldierCalculation:getMdefAddPerSkill(hero_no, level, break_level, isBase)

    --处理突破技能
    local breakAddPerValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" .. i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group
        for k, v in pairs(group) do
            local addPerItem = self:getMdefAddPerSkillTrigger(v, level)
            breakAddPerValue = breakAddPerValue + addPerItem
        end
    end

    if isBase == true then return breakAddPerValue end

    --处理羁绊技能
    --获得已经羁绊上得技能
    local linkAddPerValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link

            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group

            for k, v in pairs(group) do

                local addPerItem = self:getMdefAddPerSkillTrigger(v, level)
                linkAddPerValue = linkAddPerValue + addPerItem
            end
        end
    end

    return breakAddPerValue + linkAddPerValue
end

--技能附加Mdef百分比(触发)
--触发条件为1,效果ID为的技能12或13，数值类别为2，作用位置为{11:0}的技能
function SoldierCalculation:getMdefAddPerSkillTrigger(skillId, level)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect

    if triggerType == 1 and valueType == 2 then --触发条件为1,数值类别为2
        if effectId == 12 or effectId == 13 then --效果ID为的技能12或13
            local isInPos = self:getIsInPos("11" , 0, effectPos) --作用位置为{11:0}的技能
            if isInPos == true then
                return valueEffect
            end
        end
    end
    return 0
end
---------------------------------附加值---------------
-------------------hp
--技能附加HP值： 突破，羁绊，羁绊系数
function SoldierCalculation:getHPAddValueSkill(hero_no, level, break_level, isBase)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    local baseHP = soldierTemplate.hp

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group
        for k, v in pairs(group) do
            local addPerItem = self:getHPAddValueSkillTrigger(v, level) --getHPAddPerSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    local breakAddValue2 = 0
    if break_level ~= 0 then
        local breakItem = self.c_SoldierTemplate:getBreakupAttrTemplateById(hero_no)
        local key = "parameters"..tostring(break_level)
        breakAddValue2 = breakItem[key] * baseHP
    end

    if isBase == true then return breakAddValue + breakAddValue2 end

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
                local addPerItem = self:getHPAddValueSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end

    return  breakAddValue + breakAddValue2 + linkAddValue
end

--技能HP附加值(触发)
--触发条件为1,效果ID为的技能4或5，数值类别为1，作用位置为{11:0}的技能
function SoldierCalculation:getHPAddValueSkillTrigger(skillId, level)
    print("getHPAddValue: ", skillId)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect

    if triggerType == 1 and valueType == 1 then  --触发条件为1,数值类别为1
        if effectId == 4 or effectId == 5 then   --效果ID为的技能4或5
            local isInPos = self:getIsInPos("11" , 0, effectPos)  --作用位置为{11:0}
            if isInPos == true then
                return valueEffect
            end
        end
    end
    return 0   
end

-----------------atk
--技能附加atk值
function SoldierCalculation:getAtkAddValueSkill(hero_no, level, break_level, isBase)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    local baseAtk = soldierTemplate.atk

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group
        for k, v in pairs(group) do
            local addPerItem = self:getAtkAddValueSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    local breakAddValue2 = 0
    if break_level ~= 0 then
        local breakItem = self.c_SoldierTemplate:getBreakupAttrTemplateById(hero_no)
        local key = "parameters"..tostring(break_level)
        breakAddValue2 = breakItem[key] * baseAtk
    end

    if isBase == true then return breakAddValue + breakAddValue2 end

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
                local addPerItem = self:getAtkAddValueSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end

    local totleSkillAddValue = breakAddValue + breakAddValue2 + linkAddValue
    return totleSkillAddValue
end

--技能atk附加值(触发)
--触发条件为1,效果ID为的技能6或7，数值类别为1，作用位置为{11:0}的技能
function SoldierCalculation:getAtkAddValueSkillTrigger(skillId, level)
    print("getAtkAddValue: ", skillId)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect

    if triggerType == 1 and valueType == 1 then  --触发条件为1,数值类别为1
        if effectId == 6 or effectId == 7 then   --效果ID为的技能6或7
            local isInPos = self:getIsInPos("11" , 0, effectPos)  --作用位置为{11:0}
            if isInPos == true then
                return valueEffect
            end
        end
    end
    return 0   
end

----------------pdef
--技能附加Pdef值
function SoldierCalculation:getPdefAddValueSkill(hero_no, level, break_level, isBase)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    local basePDef = soldierTemplate.physicalDef

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" ..  i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group
        for k, v in pairs(group) do
            local addPerItem = self:getPdefAddValueSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    local breakAddValue2 = 0
    if break_level ~= 0 then
        local breakItem = self.c_SoldierTemplate:getBreakupAttrTemplateById(hero_no)
        local key = "parameters"..tostring(break_level)
        breakAddValue2 = breakItem[key] * basePDef
    end

    if isBase == true then return breakAddValue + breakAddValue2 end

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
                local addPerItem = self:getPdefAddValueSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end

    local totleSkillAddValue = breakAddValue + breakAddValue2 + linkAddValue
    return totleSkillAddValue
end

--技能pdef附加值(触发)
--触发条件为1,效果ID为的技能10或11，数值类别为1，作用位置为{11:0}的技能
function SoldierCalculation:getPdefAddValueSkillTrigger(skillId, level)
    print("getPdefAddValue: ", skillId)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect

    if triggerType == 1 and valueType == 1 then  --触发条件为1,数值类别为1
        if effectId == 10 or effectId == 11 then   --效果ID为的技能10或11
            local isInPos = self:getIsInPos("11" , 0, effectPos)  --作用位置为{11:0}
            if isInPos == true then
                return valueEffect
            end
        end
    end
    return 0   
end

---------------------mdef
--技能附加mdef值
function SoldierCalculation:getMdefAddValueSkill(hero_no, level, break_level, isBase)
    local soldierTemplate = self.c_SoldierTemplate:getHeroTempLateById(hero_no)
    local baseMDef = soldierTemplate.magicDef

    --处理突破技能
    local breakAddValue = 0
    local breakSkillItem = self.c_SoldierTemplate:getBreakupTempLateById(hero_no)
    for i = 1, break_level do 
        local breakStr = "break" .. i 
        local breakSkillId = breakSkillItem[breakStr]
        local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(breakSkillId)
        local group = skillTempLate.group
        for k, v in pairs(group) do
            local addPerItem = self:getMdefAddValueSkillTrigger(v, level)
            breakAddValue = breakAddValue + addPerItem
        end
    end

    local breakAddValue2 = 0
    if break_level ~= 0 then
        local breakItem = self.c_SoldierTemplate:getBreakupAttrTemplateById(hero_no)
        local key = "parameters"..tostring(break_level)
        breakAddValue2 = breakItem[key] * baseMDef
    end

    if isBase == true then return breakAddValue + breakAddValue2 end

    -- --处理羁绊技能
    -- --获得已经羁绊上得技能
    local linkAddValue = 0
    local item = self.c_LineupData:getSelectSoldierById(hero_no)
    if item ~= nil then
        local linkItemTable = self.c_LineupData:getLink(hero_no)
        for k, v in pairs(linkItemTable) do
            local link = v.link
            local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(link)
            local group = skillTempLate.group
            for k, v in pairs(group) do
                local addPerItem = self:getMdefAddValueSkillTrigger(v, level)
                linkAddValue = linkAddValue + addPerItem
            end
        end
    end

    local totleSkillAddValue = breakAddValue + breakAddValue2 + linkAddValue
    return totleSkillAddValue
end

--技能mdef附加值(触发)
--触发条件为1,效果ID为的技能12或13，数值类别为1，作用位置为{11:0}的技能
function SoldierCalculation:getMdefAddValueSkillTrigger(skillId, level)
    print("getMdefAddValue: ", skillId)
    local skillBuffItem = self.c_SoldierTemplate:getSkillBuffTempLateById(skillId)
    local triggerType = skillBuffItem.triggerType --触发条件
    local effectId = skillBuffItem.effectId     --效果ID
    local valueType = skillBuffItem.valueType   --数值类别
    local effectPos = skillBuffItem.effectPos   --作用位置
    local valueEffect = skillBuffItem.valueEffect

    if triggerType == 1 and valueType == 1 then  --触发条件为1,数值类别为1
        if effectId == 12 or effectId == 13 then   --效果ID为的技能12或13
            local isInPos = self:getIsInPos("11" , 0, effectPos)  --作用位置为{11:0}
            if isInPos == true then
                return valueEffect
            end
        end
    end
    return 0   
end

-----------------------------------------------------------------------------------
--["11"] = 0,
--获得是否在作用位置上
--v1: key,
--v2:v,
--effectPos
function SoldierCalculation:getIsInPos(v1, v2, effectPos)
    for k, v in pairs(effectPos) do
        if k == v1 and v == v2 then
            return true
        end
    end
    return false
end

--[[
获得英雄hp
k1:英雄基础HP
k2:英雄基础成长HP
k3: 英雄等级
k4:总HP附加百分比
k5:总HP附加值
]]
function SoldierCalculation:getHP(k1, k2, k3, k4, k5)
    --hpHero
    --hp:基础生命值,growHp:生命值成长,heroLevel:武将等级,
    --hpB:突破技能增加面板生命值,parameters:突破系数,hpSeal:炼体增加的生命值,hpStone:符文增加的生命值
    return  ( k1 + k2 * k3 ) * ( 1 + 0.01*k4 ) + k5
end

--
--[[
获得英雄攻击力
k1:英雄基础ATK
k2:英雄基础成长ATK
k3: 英雄等级
k4:总ATK附加百分比
k5:总ATK附加值
]]
function SoldierCalculation:getATK(k1, k2, k3, k4, k5)
    return  ( k1 + k2 * k3 ) * ( 1 + 0.01*k4 ) + k5
end

--[[
获得英雄总物理防御值
k1:英雄基础PDEF
k2:英雄基础成长PDEF
k3: 英雄等级
k4:总PDEF附加百分比
k5:总PDEF附加值
]]
function SoldierCalculation:getPDEF(k1, k2, k3, k4, k5)
    return  ( k1 + k2 * k3 ) * ( 1 + 0.01*k4 ) + k5
end

--[[
总魔法防御值
k1:英雄基础MDEF
k2:英雄基础成长MDEF
k3: 英雄等级
k4:总MDEF附加百分比
k5:总MDEF附加值
]]
function SoldierCalculation:getMDEF(k1, k2, k3, k4, k5)
    return  ( k1 + k2 * k3 ) * ( 1 + 0.01*k4 ) + k5
end

---------------------------------------------战斗---------------------------------------------
--以下为战场中战斗使用的公式 部分值依赖于上面的公式
--另外一部分值依赖于读表

--[[
战斗公式 基础伤害值
k1:攻方总实际攻击
k2:守方总物理防御值或者总魔法防御值
k3:攻防等价调整参数(3)
k4:伤害数值调整参数(2)
]]
function SoldierCalculation:getbaseHurtValue(k1,k2,k3,k4,k5)
    return (((math.pow(k1,2)/(k1+k3 * k2))) * k4)
end

--[[
战斗公式 暴击伤害系数
k1:攻方总暴击伤害系数
k2:守方总暴伤减免系数
]]
function SoldierCalculation:getCriHurtCoeff(k1, k2)
    return k1 - k2
end

--[[
战斗公式 格挡受伤系数
k1:基础配置表单手配置(0.7)
]]
function SoldierCalculation:getBlockHurtCoeff(k1)
    return k1
end

--[[
战斗公式 等级压制系数
k1:攻方等级
k2:守方等级
k3:调整参数1(1)
k4:调整参数2(1600)
k5:调整参数3(3)
]]
function SoldierCalculation:getLevelSuppressCoeff(k1,k2,k3,k4,k5)
    if k2 - k1 > 5 then
        if (1-k3/k4 * (math.pow(k2-k1,2) + k2 - k1)) > 0.1 then
            return 1-k3/k4 * (math.pow(k2-k1,2) + k2 - k1 + k5)  
        else
            return 0.1
        end
    end

    return 1
end

--[[
战斗公式 伤害浮动系数
k1:下限
k2:上限
]]
function SoldierCalculation:getHurtFloatCoeff(k1,k2)
    return math.random(k1,k2)
end

--[[
战斗公式 总伤害值
k1: 基础伤害值
k2: 暴击伤害系数
k3: 格挡伤害系数
k4: 等级压制系数
k5: 伤害浮动系数
]]
function SoldierCalculation:getTotalHurtValue(k1,k2,k3,k4,k5,isCrit,isBlock)
    if isCrit then
        k2 = 1 
    end

    if isBlock then
        k3 = 1 
    end

    return k1 * k2 * k3 * k4 * k5 
end

--[[
战斗公式 总治疗值
k1: 攻方总暴击伤害系数
k2: 攻方总攻击值 
]]
function SoldierCalculation:getTotalCureValue(k1,k2)
    return k1 * k2
end

--[[
战斗公式 攻方实际治疗值
k1: 攻方总治疗值
k2: 技能效果参数 读表
k3: 等级效果参数 读表
k4: 卡牌等级
]]
function SoldierCalculation:getRealCureValue(k1,k2,k3,k4)
    if k3 ~= 0 then
        k2 = k2 + k3 * k4 
    end

    return k1 * k2
end

--[[
战斗公式 攻方实际伤害值
k1: 攻方总治疗值
k2: 技能效果参数 读表
k3: 等级效果参数 读表
k4: 卡牌等级
]]
function SoldierCalculation:getRealHitValue(k1,k2,k3,k4)
    if k3 ~= 0 then
        k2 = k2 + k3 * k4 
    end

    return k1 * k2
end

--[[
战斗公式 受击方实际伤害百分比
k1: 受击方总治疗值
k2: 技能效果参数 读表
k3: 等级效果参数 读表
k4: 卡牌等级
]]
function SoldierCalculation:getRealOnHitValue(k1,k2,k3,k4)
    if k3 ~= 0 then
        k2 = k2 + k3 * k4 
    end

    return k1 * k2
end

--[[
战斗公式 受击方实际治疗值
k1: 受击方总治疗值
k2: 技能效果参数 读表
k3: 等级效果参数 读表
k4: 卡牌等级
]]
function SoldierCalculation:getRealOnHitValue(k1,k2,k3,k4)
    if k3 ~= 0 then
        k2 = k2 + k3 * k4 
    end

    return k1 * k2
end

--[[
skill buff计算
k1: 技能效果参数
k2: 等级效果参数
k3: 卡牌等级
]]
function SoldierCalculation:skillBuffEffectValue(k1,k2,k3)
    if k2 == 0 then 
        return k1
    end

    return k1 + k2 * k3
end

return SoldierCalculation