-- 怪物技能
local UnitSkill = import(".FMUnitSkill")
local FMMonsterSkill = class("FMMonsterSkill", UnitSkill)

function FMMonsterSkill:ctor(data, unit)
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.baseTemplate = getTemplateManager():getBaseTemplate()

    local mp_info = baseTemplate:getBaseInfoById("chushi_value_config")
    FMMonsterSkill.super.ctor(unit, unit.unit_info, mp_info)
end


function FMMonsterSkill:before_skill_buffs(is_hit)
    return {}
end

function FMMonsterSkill:after_skill_buffs(is_hit)
    return {}
end

function FMMonsterSkill:back_skill_buffs(is_hit, is_block)
    return {}
end

function FMMonsterSkill:begin_skill_buffs()
    return {}
end

return FMMonsterSkill
