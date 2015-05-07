--数据计算类

FightCalculation = FightCalculation or class("FightCalculation")

function FightCalculation:ctor()
    self.c_SoldierData = getDataManager():getSoldierData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.c_instanceTemplate = getTemplateManager():getInstanceTemplate()

    self.c_EquipCalculation = getCalculationManager():getEquipCalculation()
    self.c_LegionCalculation = getCalculationManager():getLegionCalculation()
    self.c_LineupData = getDataManager():getLineupData()
    self.c_SoldierCalculation = getCalculationManager():getSoldierCalculation()

    self.c_OtherCalculation = getCalculationManager():getOtherCalculation()

    self.c_FormulaTemplate = getTemplateManager():getFormulaTemplate()

    self.tempFightData = getTempFightData()
end

function FightCalculation:getUnparaDamageValue(camp, unparaItem, k2)
    --self.unparaItem = self.soldierTemplate.unparaItem
    --self.unparaItem["condition1"]
    --local item1 = unparaItem["condition1"]
    local totleLevel = 0
    for i = 1 , 3 do
        local name = "condition" .. i
        local item = unparaItem[name]
        print("getUnparaDamageValue===========" .. item)
        if item ~= 0 then
            local level = self.tempFightData:getHeroLevel(camp, item)
            print("level====" .. level)
            totleLevel = totleLevel + level
        end
    end
    print("totleLevel==========" .. totleLevel)
    print("k2==========" .. k2)
    return totleLevel * k2
end

function FightCalculation:getTriggerRate()
end

function FightCalculation:getIsHit(paraDataTable)
    
    print("----FightCalculation:getIsHit-------")

    local fmCardSender = paraDataTable.fmCardSender
    local fmCardTarget = paraDataTable.fmCardTarget
    local tempDate = (fmCardSender.tempHit - fmCardTarget.tempDodge)/10

    local randomTable = self.tempFightData:getRandom(0, 99)
    local randomValue = randomTable.randomValue

    local formula = self.c_FormulaTemplate:getFormulaByID(99).clientFormula
    local before = "function func(random, hitArray1, dodgeArray2) local "
    local after = " return result end"
    assert(loadstring(before..formula..after))()
    -- assert(loadstring("function func(random, hitArray1, dodgeArray2)  result=(random<hitArray1-dodgeArray2 and 1) or 0 return result end"))()

    local result = func(tonumber(randomValue), tonumber(fmCardSender.tempHit), tonumber(fmCardTarget.tempDodge))

    local isHitTable = {}
    isHitTable.tempHit = fmCardSender.tempHit
    isHitTable.tempDodge = fmCardSender.tempDodge
    isHitTable.tempDate = tempDate
    isHitTable.randomTable = randomTable
    isHitTable.isHit = false

    if result == 1 then isHitTable.isHit = true end
    
    return isHitTable
end

function FightCalculation:getIsCrit(paraDataTable)
    
    print("----FightCalculation:getIsCrit-------")

    local fmCardSender = paraDataTable.fmCardSender
    local fmCardTarget = paraDataTable.fmCardTarget
    local tempData = (fmCardSender.tempCri - fmCardTarget.tempDuctility)/10

    local randomTable = self.tempFightData:getRandom(0, 99)
    local randomValue = randomTable.randomValue

    -- result=((criArray1-ductilityArray2)/10>random and 1) or 0

    local formula = self.c_FormulaTemplate:getFormulaByID(100).clientFormula
    local before = "function func(random, criArray1, ductilityArray2) local "
    local after = " return result end"
    assert(loadstring(before..formula..after))()

    local result = func(tonumber(randomValue), tonumber(fmCardSender.tempCri), tonumber(fmCardTarget.tempDuctility))

    local isCritTable = {}
    isCritTable.tempCri = fmCardSender.tempCri
    isCritTable.tempDuctility = fmCardSender.tempDuctility
    isCritTable.randomTable = randomTable
    isCritTable.tempData = tempData
    isCritTable.isCrit = false

    if result == 1 then isCritTable.isCrit = true end

    return isCritTable
end

function FightCalculation:getIsBlock(paraDataTable)
    local fmCardTarget = paraDataTable.fmCardTarget
    local tempBlock = fmCardTarget.tempBlock/10

    local randomTable = self.tempFightData:getRandom(0, 99)
    local randomValue = randomTable.randomValue

    -- result=(blockArray/10>random and 1) or 0
    local formula = self.c_FormulaTemplate:getFormulaByID(101).clientFormula
    local before = "function func(random, blockArray) local "
    local after = " return result end"
    assert(loadstring(before..formula..after))()

    local result = func(tonumber(randomValue), tonumber(fmCardTarget.tempBlock))

    local isBlockTable = {}
    isBlockTable.tempBlock = tempBlock
    isBlockTable.randomTable = randomTable
    isBlockTable.isBlock = false

    if result == 1 then isBlockTable.isBlock = true end
   
    return isBlockTable
end

function FightCalculation:getEffectValue(paraDataTable)
    local valueEffect = paraDataTable.valueEffect
    local levelEffectValue = paraDataTable.levelEffectValue
    local level = paraDataTable.level
    local valueType = paraDataTable.valueType
    local arrValue = paraDataTable.arrValue
    local result = nil
    if valueType == 1 then
        result = valueEffect + levelEffectValue * level
    elseif valueType == 2 then
        --k1*k2/100+k3*k4
        
        result = arrValue * valueEffect / 100 + levelEffectValue * level
    end
    
    local resultData = {}
    resultData.valueType = valueType
    resultData.result = result
    resultData.valueEffect = valueEffect
    resultData.levelEffectValue = levelEffectValue
    resultData.level = level
    resultData.arrValue = arrValue
    return resultData
end

function FightCalculation:getPureDemage(paraDataTable)
    local valueType = paraDataTable.valueType
    local levelEffectValue = paraDataTable.levelEffectValue
    local fmCardSender = paraDataTable.fmCardSender
    local level = paraDataTable.level
    local valueEffect = paraDataTable.valueEffect
    
    local resultData = {}

    --local isHit = self:getIsHit(paraDataTable)
    -- isHit = false
    local result = 0
    if valueType == 1 then
        result =  levelEffectValue * level
        resultData.levelEffectValue = levelEffectValue
        resultData.level = level
    elseif valueType == 2 then
        result = fmCardSender.tempAtk * valueEffect / 100
        resultData.tempAtk = fmCardSender.tempAtk
        resultData.valueEffect = valueEffect
    end
    
    resultData.result = result
    resultData.valueType = valueType
    --resultData.isHit = isHit
    return resultData
end

function FightCalculation:getActTreat(paraDataTable)
    local valueType = paraDataTable.valueType
    local fmCardSender = paraDataTable.fmCardSender
    local fmCardTarget = paraDataTable.fmCardTarget
    local valueEffect = paraDataTable.valueEffect
    local levelEffectValue = paraDataTable.levelEffectValue
    local level = paraDataTable.level

    local isCritTable = self:getIsCrit(paraDataTable)
    local isCrit = isCritTable.isCrit

    local k1 = 0
    if isCrit then
        
        k1 = fmCardSender.tempAtk * fmCardSender.tempCri_coeff / 1000
    else
        k1 = fmCardSender.tempAtk
    end

    local result = nil
    if valueType == 1 then
       
        result = k1 + valueEffect + levelEffectValue * level
    elseif valueType == 2 then
       
        result = k1 * valueEffect / 100 + levelEffectValue * level
    end
    local resultData = {}
    resultData.result = result
    resultData.tempCri_coeff = fmCardSender.tempCri_coeff
    -- resultData.tempCri_ded_coeff = fmCardTarget.tempCri_ded_coeff
    resultData.tempAtk = fmCardSender.tempAtk

    resultData.valueEffect = valueEffect
    resultData.levelEffectValue = levelEffectValue
    resultData.level = level
    resultData.valueType = valueType
    return resultData
end

function FightCalculation:getTPActDV(paraDataTable)
    local valueType = paraDataTable.valueType
    local effectId = paraDataTable.effectId
    
    local fmCardSender = paraDataTable.fmCardSender
    local fmCardTarget = paraDataTable.fmCardTarget

    local valueEffect = paraDataTable.valueEffect
    local levelEffectValue = paraDataTable.levelEffectValue
    local level = paraDataTable.level
    local isHitTable = paraDataTable.isHitTable
    if isHitTable == nil then
        isHitTable = self:getIsHit(paraDataTable)
    end

    local isHit = isHitTable.isHit
    -- isHit = false
    local dataTable = {}

    local result = 0
    if isHit then
        if effectId == 1 then
            local tpDemageTable = self:getTPDemageValue(paraDataTable)
            result = tpDemageTable.tpDemageResult
            dataTable.tpDemageTable = tpDemageTable

            dataTable.isCrit = tpDemageTable.isCrit
            dataTable.isBlock = tpDemageTable.isBlock
        elseif effectId == 2 then
            local tmDemageTable = self:getTMDemageValue(paraDataTable)
            result = tmDemageTable.tmDemageResult
            dataTable.tmDemageTable = tmDemageTable

            dataTable.isCrit = tmDemageTable.isCrit
            dataTable.isBlock = tmDemageTable.isBlock
        end
        
        if valueType == 1 then
            result = result + valueEffect + levelEffectValue * level

        elseif valueType == 2 then
            --k1*k2/100+k3*k4
            result = result * valueEffect / 100 + levelEffectValue * level
        end
    end
    
    dataTable.valueEffect = valueEffect
    dataTable.levelEffectValue = levelEffectValue
    dataTable.level = level
    dataTable.isHitTable = isHitTable
    dataTable.result = result
    dataTable.isHit = isHit
    dataTable.valueType = valueType
    
    return dataTable
end

--总物理伤害值
-- fmCardSender:攻方
-- fmCardTarget:守方
-- k1: 基础伤害值
-- k2: 暴击物理伤害系数
-- k3: 格挡伤害系数
-- k4: 等级压制系数
-- k5: 伤害浮动系数
-- k6: 暴击率xishu
-- k7: 格挡率
function FightCalculation:getTPDemageValue(paraDataTable)
    local fmCardSender = paraDataTable.fmCardSender
    local fmCardTarget = paraDataTable.fmCardTarget

    local phyDemageTable = self:getPhyDemage(fmCardSender, fmCardTarget)
    local k1 = phyDemageTable.phyDemageResult
    local k2 = ( fmCardSender.tempCri_coeff - fmCardTarget.tempCri_ded_coeff ) / 1000
    local k3 = self:getHeroCriDedCoeff()
    local levSuppCoeffTable = self:getlevSuppCoeff(fmCardSender, fmCardTarget)
    -- local k4 = levSuppCoeffTable.result
    local k4 = 1
    local demageFloatTable = self:getDemageFloat()
    local k5 = demageFloatTable.randomValue
    local isCritTable = self:getIsCrit(paraDataTable)
    local isCrit = isCritTable.isCrit
    local isBlockTable = self:getIsBlock(paraDataTable)
    local isBlock = isBlockTable.isBlock
    local result = self:getTotalHurtValue(k1, k2, k3, k4, k5, isCrit, isBlock)
    local dataTable = {}
    dataTable.tpDemageResult = result
    dataTable.isCrit = isCrit
    dataTable.isBlock = isBlock

    dataTable.isCritTable = isCritTable
    dataTable.isBlockTable = isBlockTable


    dataTable.k1Table = phyDemageTable

    local k2Table = {}
    k2Table.tempCri_coeff = fmCardSender.tempCri_coeff
    k2Table.tempCri_ded_coeff = fmCardSender.tempCri_ded_coeff
    k2Table.result = k2

    dataTable.k2Table = k2Table
    dataTable.k3 = k3
    dataTable.k4Table = levSuppCoeffTable
    dataTable.k5Table = demageFloatTable
    
    return dataTable
end

--总物理伤害值
-- fmCardSender:攻方
-- fmCardTarget:守方
-- k1: 基础魔法伤害值
-- k2: 暴击伤害系数
-- k3: 格挡伤害系数
-- k4: 等级压制系数
-- k5: 伤害浮动系数
-- k6: 暴击率
-- k7: 格挡率
function FightCalculation:getTMDemageValue(paraDataTable)
    local fmCardSender = paraDataTable.fmCardSender
    local fmCardTarget = paraDataTable.fmCardTarget
    
    local magDemageTable = self:getMagDemage(fmCardSender, fmCardTarget)
    local k1 = magDemageTable.result

    local k2 = (fmCardSender.tempCri_coeff - fmCardTarget.tempCri_ded_coeff) / 1000
    local k3 = self:getHeroCriDedCoeff()
    local levSuppCoeffTable = self:getlevSuppCoeff(fmCardSender, fmCardTarget)
    -- local k4 = levSuppCoeffTable.result
    local k4 = 1
    local demageFloatTable = self:getDemageFloat()
    local k5 = demageFloatTable.randomValue

    local isCritTable = self:getIsCrit(paraDataTable)
    local isCrit = isCritTable.isCrit
    local isBlockTable = self:getIsBlock(paraDataTable)
    local isBlock = isBlockTable.isBlock
    -- isBlock = true
    local result = self:getTotalHurtValue(k1, k2, k3, k4, k5, isCrit, isBlock)
    local dataTable = {}
    dataTable.tmDemageResult = result
    dataTable.isCrit = isCrit
    dataTable.isBlock = isBlock
    dataTable.isCritTable = isCritTable
    dataTable.isBlockTable = isBlockTable

    dataTable.k1Table = magDemageTable

    local k2Table = {}
    k2Table.tempCri_coeff = fmCardSender.tempCri_coeff
    k2Table.tempCri_ded_coeff = fmCardSender.tempCri_ded_coeff
    k2Table.result = k2

    dataTable.k2Table = k2Table
    dataTable.k3 = k3

    dataTable.k4Table = levSuppCoeffTable
    dataTable.k5Table = demageFloatTable
    return dataTable
end

----------------------------------------------
--物理伤害
function FightCalculation:getPhyDemage(fmCardSender, fmCardTarget)
    --k1:攻方总实际攻击
    local k1 = fmCardSender.tempAtk
    --k2:守方总物理防御值
    local k2 = fmCardTarget.tempPhysical_def
    local level = fmCardSender.level
    --k3:攻防等价调整参数(3)
    -- local baseItem = self.c_BaseTemplate:getBaseInfoById("a3")
    -- local k3 = baseItem[1]
    -- local k4 = baseItem[2]
    local result = self:getbaseHurtValue(k1, k2, level)
    local phyDemageTable = {}
    phyDemageTable.k1 = k1
    phyDemageTable.k2 = k2
    phyDemageTable.k3 = 0
    phyDemageTable.k4 = 0
    phyDemageTable.phyDemageResult = result
    return phyDemageTable
end

--魔法伤害
--攻方heroPBA
--守方heroPBB
function FightCalculation:getMagDemage(fmCardSender, fmCardTarget)
    --k1:攻方总实际攻击
    local k1 = fmCardSender.tempAtk
    --k2:守方总魔法防御值
    local k2 = fmCardTarget.tempMagic_def
    local level = fmCardSender.level
    --k3:攻防等价调整参数(3)
    -- local baseItem = self.c_BaseTemplate:getBaseInfoById("a3")
    -- local k3 = baseItem[1]
    -- local k4 = baseItem[2]
    local result = self:getbaseHurtValue(k1, k2, level)
    local magDemageTable = {}
    magDemageTable.k1 = k1
    magDemageTable.k2 = k2
    magDemageTable.k3 = 0
    magDemageTable.k4 = 0
    magDemageTable.result = result
    return magDemageTable
end

--暴击伤害系数
--攻方heroPBA
--守方heroPBB
function FightCalculation:getHeroCriCoeff(heroPBA, heroPBB)
    -- result=(criCoeffArray1-criDedCoeffArray2)/1000

    --攻方总暴击伤害系数
    local hero_no = heroPBA.hero_no
    local level = heroPBA.level
    local break_level = heroPBA.break_level
    local k1 = self.c_OtherCalculation:getHeroCriCoeff(hero_no, level, break_level)
    --守方总暴伤减免系数
    local hero_no = heroPBB.hero_no
    local level = heroPBB.level
    local break_level = heroPBB.break_level
    local k2 = self.c_OtherCalculation:getHeroCriDedCoeff(hero_no, level, break_level)

    -- local result = k1 - k2 

    local formula = self.c_FormulaTemplate:getFormulaByID(103).clientFormula
    local before = "function func(criCoeffArray1, criDedCoeffArray2) local "
    local after = " return result end"
    assert(loadstring(before..formula..after))()

    local result = func(k1, k2)

    return result
end

--格挡受伤系数
--攻方heroPBA
--守方heroPBB
function FightCalculation:getHeroCriDedCoeff()
    --基础配置表单手配置（0.7）
    local baseItem = self.c_BaseTemplate:getBaseInfoById("a4")
    return baseItem
end

--等级压制系数
--攻方heroPBA
--守方heroPBB
function FightCalculation:getlevSuppCoeff(fmCardSender, fmCardTarget)

    --攻方等级
    local level = fmCardSender.level
    local k1 = level
    --守方等级
    local level = fmCardTarget.level
    local k2 = level
    -- --调整参数1（1）
    -- local baseItem = self.c_BaseTemplate:getBaseInfoById("a5")
    -- local k3 = baseItem[1]
    -- local k4 = baseItem[2]
    -- local k5 = baseItem[3]
    -- local result = self:getLevelSuppressCoeff(k1, k2)
    local levSuppCoeffTable = {}
    levSuppCoeffTable.k1 = fmCardSender.level
    levSuppCoeffTable.k2 = fmCardTarget.level

    levSuppCoeffTable.result = 1

    return levSuppCoeffTable


end

--伤害浮动系数
function FightCalculation:getDemageFloat()
    local baseItem = self.c_BaseTemplate:getBaseInfoById("a6")
    local k1 = baseItem[1]
    local k2 = baseItem[2]
    local randomTable = self.tempFightData:getRandom(k1, k2)
    local randomValue = randomTable.randomValue

    local demageFloatTable = {}
    demageFloatTable.k1 = k1
    demageFloatTable.k2 = k2
    demageFloatTable.randomTable = randomTable
    demageFloatTable.randomValue = randomValue
    return demageFloatTable
end

---------------------------------------------战斗---------------------------------------------
--以下为战场中战斗使用的公式 部分值依赖于上面的公式
--另外一部分值依赖于读表


--[[
战斗公式 基础伤害值
k1:攻方总实际攻击
k2:守方总物理防御值或者总魔法防御值
k3:攻防等价调整参数(3) -- 作废
k4:伤害数值调整参数(2) -- 作废
level:武将等级
]]
function FightCalculation:getbaseHurtValue(k1,k2,level)
    --(atkArray1**2/(atkArray1+3*def2))*2
    -- result= (atkArray-def2 > heroLevel and atkArray-def2 ) or heroLevel
    local formula = self.c_FormulaTemplate:getFormulaByID(102).clientFormula
    local before = "function func(atkArray, def2, heroLevel) local "
    local after = " return result end"
    assert(loadstring(before..formula..after))()

    local result = func(tonumber(k1), tonumber(k2), level)

    return result
    -- return ((math.pow(k1,2)/(k1+k3 * k2))) * k4
end

--[[
战斗公式 等级压制系数
k1:攻方等级
k2:守方等级
k3:调整参数1(1)
k4:调整参数2(1600)
k5:调整参数3(3)
]]

--1 if heroLevel1>heroLevel2-5 else (0.1 if heroLevel1<heroLevel2-23 else 1-(heroLevel2-5-heroLevel1)*0.05)
function FightCalculation:getLevelSuppressCoeff(k1,k2)
    -- if k1 - k2 > 5 then
    --     if (1 - k3 / k4 * (math.pow(k2-k1,2) + k2 - k1 + k5)) > 0.1 then
    --         return 1 - k3 / k4 * (math.pow(k2-k1,2) + k2 - k1 + k5)  
    --     else
    --         return 0.1
    --     end
    -- end
    if k1 - k2 > -5 then
        return 1
    elseif k2 - k1 > 23 then
        return 0.1
    else
        return 1 - (k2 - 5 - k1) * 0.05
    end
end

--[[
战斗公式 伤害浮动系数
k1:下限
k2:上限
]]
function FightCalculation:getHurtFloatCoeff(k1,k2)
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
function FightCalculation:getTotalHurtValue(k1,k2,k3,k4,k5,isCrit,isBlock, v1, v2)
    if isCrit == false then
        k2 = 1 
    end

    if isBlock == false then
        k3 = 1 
    end

    -- result=baseDamage*((isHit and 1) or 0)*((isCri and criDamage) or 1)*((isBlock and 0.7) or 1)*levelDamage
    
    return k1 * k2 * k3 * k4 * k5 
end

--[[
战斗公式 总治疗值
k1: 攻方总暴击伤害系数
k2: 攻方总攻击值 
]]
function FightCalculation:getTotalCureValue(k1,k2)
    -- result=atkArray*((isCri and criCoeffArray/1000) or 1)

    return k1 * k2
end

--[[
战斗公式 攻方实际治疗值
k1: 攻方总治疗值
k2: 技能效果参数 读表
k3: 等级效果参数 读表
k4: 卡牌等级
]]
function FightCalculation:getRealCureValue(k1,k2,k3,k4)
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
function FightCalculation:getRealHitValue(k1,k2,k3,k4)
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
function FightCalculation:getRealOnHitValue(k1,k2,k3,k4)
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
function FightCalculation:getRealOnHitValue(k1,k2,k3,k4)
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
function FightCalculation:skillBuffEffectValue(k1,k2,k3)
    if k2 == 0 then 
        return k1
    end

    return k1 + k2 * k3
end

-- 无双战力
function FightCalculation:unparaEffectValue(valueEffect, type, id)
    print("---FightCalculation:unparaEffectValue------")
    print(valueEffect)
    
    local unparaId = self.tempFightData.unparaId
    local num = 0
    if unparaId ~= 0 and unparaId ~= nil then
        num = self.c_instanceTemplate:getWSHeroNum(unparaId)
    end

    local unparaItem = self.tempFightData.unparaItem



    local enemy_physicalDefArray = 0
    local enemy_magicDefArray = 0
    local warriors_atkArray = 0

    if type == "enemy" then
        enemy_physicalDefArray = self.tempFightData:getEnemyphysicalDef(id)
        
        enemy_magicDefArray = self.tempFightData:getEnemyMagicDef(id)

        local hero_no = unparaItem["condition1"]
        print("---hero_no------")
        print(hero_no)

        warriors_atkArray = warriors_atkArray + self.tempFightData:getHeroAtk((hero_no))
        hero_no = unparaItem["condition2"]
        print(hero_no)
        warriors_atkArray = warriors_atkArray + self.tempFightData:getHeroAtk((hero_no))
        if num >=3 then
            hero_no = unparaItem["condition3"]
            warriors_atkArray = warriors_atkArray + self.tempFightData:getHeroAtk((hero_no))
        end
    else  
        -- todo 
        enemy_physicalDefArray = self.tempFightData:getArmyphysicalDef(id)
        
        enemy_magicDefArray = self.tempFightData:getArmyMagicDef(id)

        local hero_no = unparaItem["condition1"]
        warriors_atkArray = warriors_atkArray + self.tempFightData:getEnemyHeroAtk((hero_no))
        hero_no = unparaItem["condition2"]
        warriors_atkArray = warriors_atkArray + self.tempFightData:getEnemyHeroAtk((hero_no))
        if num >=3 then
            hero_no = unparaItem["condition3"]
            warriors_atkArray = warriors_atkArray + self.tempFightData:getEnemyHeroAtk((hero_no))
        end
    end

    print("--warriors_atkArray--")
    print(warriors_atkArray)

    print("--enemy_physicalDefArray----")
    print(enemy_physicalDefArray)

    print("--enemy_magicDefArray--")
    print(enemy_magicDefArray)

    local formula = self.c_FormulaTemplate:getFormulaByID(112).clientFormula
    local before = "function func(warriors_atkArray, enemy_physicalDefArray, enemy_magicDefArray, valueEffect) local "
    local after = " return result end"
    assert(loadstring(before..formula..after))()

    print(formula)

    local result = func(warriors_atkArray, enemy_physicalDefArray, enemy_magicDefArray, valueEffect)
    print("--result---")
    print(result)
    -- result=(warriors_atkArray-enemy_physicalDefArray/2-enemy_magicDefArray/2)*valueEffect/100

    return result

end

return FightCalculation