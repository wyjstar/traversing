--lua层模板管理类，管理静态数据实例

local CalculationManager = CalculationManager or class("CalculationManager")
local SoldierCalculation = import(".soldier.SoldierCalculation")

local LineUpCalculation = import(".soldier.LineUpCalculation")
local OtherCalculation = import(".soldier.OtherCalculation")

local EquipCalculation = import(".equipment.EquipCalculation")

local LegionCalculation = import(".legion.LegionCalculation")

local FightCalculation = import(".fight.FightCalculation")

local Calculation = import(".Calculation")

function CalculationManager:ctor(controller)
    self.c_SoldierCalcylation = nil --英雄计算类

    self.c_OtherCalculation = nil --英雄其他计算类

    self.c_LineUpCalculation = nil --阵容计算类

    self.c_EquipCalculation = nil --装备计算

    self.c_LegionCalculation = nil --公会计算

    self.c_FightCalculation = nil --战斗中计算
    
    self.c_Calculation = nil -- 战斗
end

function CalculationManager:getSoldierCalculation()
    if self.c_SoldierCalcylation  == nil then
        self.c_SoldierCalcylation = SoldierCalculation.new()
    end
    return self.c_SoldierCalcylation
end

function CalculationManager:getLineUpCalculation()
    if self.c_LineUpCalculation == nil then
        self.c_LineUpCalculation = LineUpCalculation.new()
    end
    return self.c_LineUpCalculation
end

function CalculationManager:getEquipCalculation()
    if self.c_EquipCalculation == nil then
        self.c_EquipCalculation = EquipCalculation.new()
    end
    return self.c_EquipCalculation
end

function CalculationManager:getLegionCalculation()
    if self.c_LegionCalculation == nil then
        self.c_LegionCalculation = LegionCalculation.new()
    end
    return self.c_LegionCalculation
end

function CalculationManager:getOtherCalculation()
    if self.c_OtherCalculation == nil then
        self.c_OtherCalculation = OtherCalculation.new()
    end
    return self.c_OtherCalculation
end

function CalculationManager:getFightCalculation()
    if self.c_FightCalculation == nil then
        self.c_FightCalculation = FightCalculation.new()
    end
    return self.c_FightCalculation
end

function CalculationManager:getCalculation()
    if self.c_Calculation == nil then
        self.c_Calculation = Calculation.new()
    end
    return self.c_Calculation
end

function CalculationManager:clear()
    self.c_SoldierCalcylation = nil --英雄计算类

    self.c_OtherCalculation = nil --英雄其他计算类

    self.c_LineUpCalculation = nil --阵容计算类

    self.c_EquipCalculation = nil --装备计算

    self.c_LegionCalculation = nil --公会计算

    self.c_FightCalculation = nil --战斗中计算
    
    self.c_Calculation = nil -- 战斗
end

return CalculationManager
