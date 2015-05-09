--装备计算类

local EquipCalculation = EquipCalculation or class("EquipCalculation")

function EquipCalculation:ctor()

    self.c_EquipTemp = getTemplateManager():getEquipTemplate()
    self.c_LineupData = getDataManager():getLineupData()
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_EquipData = getDataManager():getEquipmentData()
end

function EquipCalculation:getFightValue(equip_id)
    -- "result=atk+physicalDef+magicDef+hp/6+(hit+dodge+cri+criCoeff+criDedCoeff+block+ductility)*100"
    local equipItemData = getDataManager():getEquipmentData():getEquipById(equip_id)
    local equip_no = equipItemData.no 
    local equip_lv = equipItemData.strengthen_lv
    print("---------装备属性--------")
    -- table.print(equipItemData)
    ------------------新装备表使用方式-------------------
    result = 0
    atk = 0
    physicalDef = 0
    magicDef = 0
    hp = 0
    hit = 0
    dodge = 0
    cri = 0
    criCoeff = 0
    criDedCoeff = 0
    block = 0
    ductility = 0

    ----------------------------------------------------

    --[[ 老装备表使用方式
    local equipItemTemp = self.c_EquipTemp:getTemplateById(equipItemData.no)
    result = 0
    atk = equipItemTemp.baseAtk + equipItemTemp.growAtk * equip_lv
    physicalDef = equipItemTemp.basePdef + equipItemTemp.growPdef * equip_lv
    magicDef = equipItemTemp.baseMdef + equipItemTemp.growMdef * equip_lv
    hp = equipItemTemp.baseHp + equipItemTemp.growHp * equip_lv
    hit = equipItemTemp.hit
    dodge = equipItemTemp.dodge
    cri = equipItemTemp.cri
    criCoeff = equipItemTemp.criCoeff
    criDedCoeff = equipItemTemp.criDedCoeff
    block = equipItemTemp.block
    ductility = equipItemTemp.ductility
    ]]
    local formula = formula_config[119].clientFormula
    local func = loadstring(formula)-- loadstring 执行的一般都是外部string, 里头的变量默认是global
    -- print(formula)
    func()
    -- print("~~~~~~~~~ ", result)
    return result
end

--装备附加HP值
function EquipCalculation:getHpAddValueEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
    local suitTable = {}
    for k, v in pairs(equs) do
        local equipNo = v.equ.no
        if equipNo ~= 0 then
            local equipId = v.equ.id
            local level = getDataManager():getEquipmentData():getStrengLv(equipId)
            local valueItem = self:getHpAddValueEquip(equipId, level)   ---equipNo

            local suit = getTemplateManager():getEquipTemplate():getTemplateById(equipNo).suitNo
            if suit ~= 0 then
                if suitTable[suit] == nil then suitTable[suit] = {} end
                local index = 1
                for aa,bb in pairs(suitTable[suit]) do
                    if bb == equipNo then break end
                    index = index + 1
                end
                if index == table.nums(suitTable[suit]) + 1 then
                    table.insert(suitTable[suit], equipNo)
                end
            end

            tempValue = tempValue + valueItem
        end
    end
    for k,v in pairs(suitTable) do
        local suitData = getTemplateManager():getSquipmentTemplate():getTemplateById(k)
        local suitCount = table.nums(v)
        if suitCount >= 2 then 
            for i=2, suitCount do
                local skillId = suitData["attr"..tostring(i-1)][2]
                local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(skillId)
                local group = skillTempLate.group
                for aa, bb in pairs(group) do
                    local addPerItem = getCalculationManager():getSoldierCalculation():getHPAddValueSkillTrigger(bb)
                    tempValue = tempValue + addPerItem
                end
            end
        end
    end
    -- print("hp: ", tempValue)
    return tempValue
end

--装备附加HP值
function EquipCalculation:getHpAddValueEquip(_equip_id, _level)
    if _equip_id == 0 then
        return 0
    end
    --local data = self.c_EquipTemp:getTemplateById(_equip_id)
    local data = self.c_EquipData:getEqu(_equip_id)
    local main_attr = data.main_attr
    local minor_attr = data.minor_attr
    local _type_main = main_attr.attr_type
    local ciNum = table.nums(minor_attr)
    local baseHp = 0
    local growHp = 0
    local growedHp = 0
    print("----装备主属性---")
    -- table.print(main_attr)
    print("----装备次属性---")
    -- table.print(minor_attr)
    if _type_main == 1 then
        baseHp = main_attr[1].attr_value
        growHp = main_attr[1].attr_increment
        growedHp = _level * growHp
    end

    if ciNum == 0 or ciNum == nil then
        print("没有次属性")
    else
        for i = 1,ciNum do
            if minor_attr[i].attr_type == 1 then
                baseHp = baseHp + minor_attr[i].attr_value
                growHp = minor_attr[i].attr_increment
                growedHp = growedHp + _level * growHp
            end
        end
    end
    return baseHp + growedHp
end

--装备附加Atk值
function EquipCalculation:getAtkAddValueEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
    local suitTable = {}
    for k, v in pairs(equs) do
        local equipNo = v.equ.no
        if equipNo ~= 0 then
            local equipId = v.equ.id
            local level = getDataManager():getEquipmentData():getStrengLv(equipId)
            local valueItem = self:getAtkAddValueEquip(equipId, level) ---equipNo

            local suit = getTemplateManager():getEquipTemplate():getTemplateById(equipNo).suitNo
            if suit ~= 0 then
                if suitTable[suit] == nil then suitTable[suit] = {} end
                local index = 1
                for aa,bb in pairs(suitTable[suit]) do
                    if bb == equipNo then break end
                    index = index + 1
                end
                if index == table.nums(suitTable[suit]) + 1 then
                    table.insert(suitTable[suit], equipNo)
                end
            end

            tempValue = tempValue + valueItem
        end
    end
    for k,v in pairs(suitTable) do
        local suitData = getTemplateManager():getSquipmentTemplate():getTemplateById(k)
        local suitCount = table.nums(v)
        if suitCount >= 2 then 
            for i=2, suitCount do
                local skillId = suitData["attr"..tostring(i-1)][2]
                local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(skillId)
                local group = skillTempLate.group
                for aa, bb in pairs(group) do
                    local addPerItem = getCalculationManager():getSoldierCalculation():getAtkAddValueSkillTrigger(bb)
                    tempValue = tempValue + addPerItem
                end
            end
        end
    end
    -- print("atk: ", tempValue)
    return tempValue
end

--装备附加Atk值
function EquipCalculation:getAtkAddValueEquip(_equip_id, _level)
    if _equip_id == 0 then
        return 0
    end
    local data = self.c_EquipData:getEqu(_equip_id)
    local main_attr = data.main_attr
    local minor_attr = data.minor_attr
    local _type_main = main_attr.attr_type
    local ciNum = table.nums(minor_attr)
    local baseAtk = 0
    local growAtk = 0
    local growedAtk = 0
    print("----装备主属性---")
    -- table.print(main_attr)
    print("----装备次属性---")
    -- table.print(minor_attr)
    if _type_main == 2 then
        baseAtk = main_attr[1].attr_value
        growAtk = main_attr[1].attr_increment
        growedAtk = _level * growAtk
    end
    if ciNum == 0 or ciNum == nil then
        print("没有次属性")
    else
        for i = 1,ciNum do
            if minor_attr[i].attr_type == 2 then
                baseAtk = baseAtk + minor_attr[i].attr_value
                growHp = minor_attr[i].attr_increment
                growedAtk = growAtk + _level * growAtk
            end
        end
    end
    return baseAtk + growedAtk
end

--装备附加Pdef值
function EquipCalculation:getPdefAddValueEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
    local suitTable = {}
    for k, v in pairs(equs) do
        local equipNo = v.equ.no
        if equipNo ~= 0 then
            local equipId = v.equ.id
            local level = getDataManager():getEquipmentData():getStrengLv(equipId)
            local valueItem = self:getPdefAddValueEquip(equipId, level) ---equipNo

            local suit = getTemplateManager():getEquipTemplate():getTemplateById(equipNo).suitNo
            if suit ~= 0 then
                if suitTable[suit] == nil then suitTable[suit] = {} end
                local index = 1
                for aa,bb in pairs(suitTable[suit]) do
                    if bb == equipNo then break end
                    index = index + 1
                end
                if index == table.nums(suitTable[suit]) + 1 then
                    table.insert(suitTable[suit], equipNo)
                end
            end

            tempValue = tempValue + valueItem
        end
    end
    for k,v in pairs(suitTable) do
        local suitData = getTemplateManager():getSquipmentTemplate():getTemplateById(k)
        local suitCount = table.nums(v)
        if suitCount >= 2 then 
            for i=2, suitCount do
                local skillId = suitData["attr"..tostring(i-1)][2]
                local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(skillId)
                local group = skillTempLate.group
                for aa, bb in pairs(group) do
                    local addPerItem = getCalculationManager():getSoldierCalculation():getPdefAddValueSkillTrigger(bb)
                    tempValue = tempValue + addPerItem
                end
            end
        end
    end
    -- print("pdef: ", tempValue)
    return tempValue
end

--装备附加Pdef值
function EquipCalculation:getPdefAddValueEquip(_equip_id, _level)
    if _equip_id == 0 then
        return 0
    end
    local data = self.c_EquipData:getEqu(_equip_id)
    local main_attr = data.main_attr
    local minor_attr = data.minor_attr
    local _type_main = main_attr.attr_type
    local ciNum = table.nums(minor_attr)
    local basePdef = 0
    local growPdef = 0
    local growedPdef = 0
    print("----装备主属性---")
    -- table.print(main_attr)
    print("----装备次属性---")
    -- table.print(minor_attr)
    if _type_main == 3 then
        basePdef = main_attr[1].attr_value
        growPdef = main_attr[1].attr_increment
    end
    if ciNum == 0 or ciNum == nil then
        print("没有次属性")
    else
        for i = 1,ciNum do
            if minor_attr[i].attr_type == 3 then
                basePdef = basePdef + minor_attr[i].attr_value
                growPdef = minor_attr[i].attr_increment
                growedPdef = growPdef + _level * growPdef
            end
        end
    end
    return basePdef + growedPdef
end

--装备附加Mdef值
function EquipCalculation:getMdefAddValueEquipByHeroId(hero_id)
    local SlotEquipment = self.c_LineupData:getSelectSoldierById(hero_id)
    if SlotEquipment == nil then
        return 0
    end

    local equs = SlotEquipment.equs
    local tempValue = 0
    local suitTable = {}
    for k, v in pairs(equs) do
        local equipNo = v.equ.no
        if equipNo ~= 0 then
            local equipId = v.equ.id
            local level = getDataManager():getEquipmentData():getStrengLv(equipId)
            local valueItem = self:getMdefAddValueEquip(equipId, level) ---equipNo

            local suit = getTemplateManager():getEquipTemplate():getTemplateById(equipNo).suitNo
            if suit ~= 0 then
                if suitTable[suit] == nil then suitTable[suit] = {} end
                local index = 1
                for aa,bb in pairs(suitTable[suit]) do
                    if bb == equipNo then break end
                    index = index + 1
                end
                if index == table.nums(suitTable[suit]) + 1 then
                    table.insert(suitTable[suit], equipNo)
                end
            end

            tempValue = tempValue + valueItem
        end
    end
    for k,v in pairs(suitTable) do
        local suitData = getTemplateManager():getSquipmentTemplate():getTemplateById(k)
        local suitCount = table.nums(v)
        if suitCount >= 2 then 
            for i=2, suitCount do
                local skillId = suitData["attr"..tostring(i-1)][2]
                local skillTempLate = self.c_SoldierTemplate:getSkillTempLateById(skillId)
                local group = skillTempLate.group
                for aa, bb in pairs(group) do
                    local addPerItem = getCalculationManager():getSoldierCalculation():getMdefAddValueSkillTrigger(bb)
                    print(addPerItem)
                    tempValue = tempValue + addPerItem
                end
            end
        end
    end
    -- print("mdef: ", tempValue)
    return tempValue
end

--装备附加Mdef值
function EquipCalculation:getMdefAddValueEquip(_equip_id, _level)
    if _equip_id == 0 then
        return 0
    end
    local data = self.c_EquipData:getEqu(_equip_id)
    local main_attr = data.main_attr
    local minor_attr = data.minor_attr
    local _type_main = main_attr.attr_type
    local _type_minor = minor_attr.attr_type
    local baseMdef = 0
    local growMdef = 0
    local growedMdef = 0
    print("----装备主属性---")
    -- table.print(main_attr)
    print("----装备次属性---")
    -- table.print(minor_attr)
    if _type_main == 4 then
        baseMdef = main_attr[1].attr_value
        growMdef = main_attr[1].attr_increment
    end
    print("次属性",ciNum)
    if ciNum == 0 or ciNum == nil then
        print("没有次属性")
    else
        for i = 1,ciNum do
            if minor_attr[i].attr_type == 4 then
                baseMdef = baseMdef + minor_attr[i].attr_value
                growPdef = minor_attr[i].attr_increment
                growedMdef = growMdef + _level * growMdef
            end
        end
    end
    return baseMdef + growedMdef
end
--------------------------------------------
--装备附加命中率值
function EquipCalculation:getHitRateEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
     for k, v in pairs(equs) do
        local equipId =  v.equ.no

        if equipId ~= 0 then
            local data = self.c_EquipTemp:getTemplateById(_equip_id)
            local valueItem = data.hit
            tempValue = tempValue + valueItem
        end
        
    end
    return tempValue
end

--装备附加暴击率
function EquipCalculation:getCritRateEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
     for k, v in pairs(equs) do
        local equipId =  v.equ.no

        if equipId ~= 0 then
            local data = self.c_EquipTemp:getTemplateById(_equip_id)
            local valueItem = data.crl
            tempValue = tempValue + valueItem
        end
        
    end
    return tempValue
end

--装备附加闪避率
function EquipCalculation:getDodgeRateEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
     for k, v in pairs(equs) do
        local equipId =  v.equ.no

        if equipId ~= 0 then
            local data = self.c_EquipTemp:getTemplateById(_equip_id)
            local valueItem = data.dodge
            tempValue = tempValue + valueItem
        end
        
    end
    return tempValue
end

--装备附加格挡率
function EquipCalculation:getBlockRateEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
     for k, v in pairs(equs) do
        local equipId =  v.equ.no

        if equipId ~= 0 then
            local data = self.c_EquipTemp:getTemplateById(_equip_id)
            local valueItem = data.block
            tempValue = tempValue + valueItem
        end
        
    end
    return tempValue
end

--装备附加暴击伤害系数
function EquipCalculation:getCriCoeffEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
     for k, v in pairs(equs) do
        local equipId =  v.equ.no

        if equipId ~= 0 then
            local data = self.c_EquipTemp:getTemplateById(_equip_id)
            local valueItem = data.criCoeff
            tempValue = tempValue + valueItem
        end
        
    end
    return tempValue
end

--装备附加暴伤减免系数
function EquipCalculation:getCriDedCoeffEquipByHeroId(hero_id)
    local heroPB = self.c_LineupData:getSelectSoldierById(hero_id)
    if heroPB == nil then
        return 0
    end
    local equs = heroPB.equs
    local tempValue = 0
     for k, v in pairs(equs) do
        local equipId =  v.equ.no

        if equipId ~= 0 then
            local data = self.c_EquipTemp:getTemplateById(_equip_id)
            local valueItem = data.criDedCoeff
            tempValue = tempValue + valueItem
        end
        
    end
    return tempValue
end
return EquipCalculation

