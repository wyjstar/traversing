
--公会计算类
local LegionCalculation = LegionCalculation or class("LegionCalculation")

function LegionCalculation:ctor()
    self.c_LegionTempalte = getTemplateManager():getLegionTemplate()
    self.c_LegionData = getDataManager():getLegionData()

end

--公会附加HP值
function LegionCalculation:getHpAddValueLegion()
    local level = self.c_LegionData:getLegionLevel()
    if level == nil then
        return 0
    end

    local item = self.c_LegionTempalte:getGuildTemplateByLevel(level)
    local profit_hp = item.profit_hp
    return profit_hp
end

--公会附加atk值
function LegionCalculation:getAtkAddValueLegion()
    local level = self.c_LegionData:getLegionLevel()
    if level == nil then
        return 0
    end

    local item = self.c_LegionTempalte:getGuildTemplateByLevel(level)
    local profit_atk = item.profit_atk
    return profit_atk
end

--公会附加pdef值
function LegionCalculation:getPdefAddValueLegion()
    local level = self.c_LegionData:getLegionLevel()
    if level == nil then
        return 0
    end

    local item = self.c_LegionTempalte:getGuildTemplateByLevel(level)

    local profit_pdef = item.profit_pdef
    return profit_pdef
end

--公会附加mdef值
function LegionCalculation:getMdefAddValueLegion()
    local level = self.c_LegionData:getLegionLevel()
    if level == nil then
        return 0
    end

    local item = self.c_LegionTempalte:getGuildTemplateByLevel(level)

    local profit_mdef = item.profit_mdef
    return profit_mdef
end
return LegionCalculation






