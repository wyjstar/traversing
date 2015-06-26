-- 武将技能
local UnitSkill = import(".FMUnitSkill")
local FMHeroSkill = class("FMHeroSkill", UnitSkill)

function FMHeroSkill:ctor(unit)
    self.baseTemplate = getTemplateManager():getBaseTemplate()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    local unit_info = unit.unit_info

    local mp_info = self.baseTemplate:getBaseInfoById("chushi_value_config")
    if unit.is_break then
        mp_info = self.baseTemplate:getBaseInfoById("stage_break_angry_value")
    elseif unit.is_awake then
        mp_info = self.baseTemplate:getBaseInfoById("angryValueAwakeHero")
    end
    FMHeroSkill.super.ctor(self, unit, unit_info, mp_info)
    self._break_skill_buffs = {}
    self._break_skill_ids = unit:get_break_skill_nos()
    self:set_break_skill_ids(self._break_skill_ids)
    self.after_skill_buffs = {}
    self.main_is_hit = false
    self.main_is_block = true
end

function FMHeroSkill:get_before_skill_buffs()
    --主技能释放前，执行的buff(triggerType==10)--
    if self._break_skill_buffs[10] then
        return self._break_skill_buffs[10]
    end
    return {}
end

function FMHeroSkill:get_open_skill_buffs()
    --主技能释放前，执行的buff(triggerType==10)--
    if self._break_skill_buffs[2] then
        return self._break_skill_buffs[2]
    end
    return {}
end

function FMHeroSkill:set_after_skill_buffs(is_hit, is_mp_skill)
    --主技能释放前，执行的buff(triggerType==6, 7, 8, 9)--
    local temp = {}

    print("has_treat_skill:", self:has_treat_skill(is_mp_skill), is_mp_skill, self.unit_no)
    table.print(self._break_skill_buffs[9])
    if self:has_treat_skill(is_mp_skill) and self._break_skill_buffs[9] then
        table.insertTo(temp, self._break_skill_buffs[9])
    end

    if not is_hit then
        return temp
    end

    if is_mp_skill and self._break_skill_buffs[7] then
        table.insertTo(temp, self._break_skill_buffs[7])
    end
    if not is_mp_skill and self._break_skill_buffs[6] then
        table.insertTo(temp, self._break_skill_buffs[6])
    end

    table.insertTo(temp, self._break_skill_buffs[8])
    self.after_skill_buffs = temp
end

function FMHeroSkill:get_after_skill_buffs()
    return self.after_skill_buffs
end

function FMHeroSkill:get_back_skill_buffs(is_hit, is_block)
    -- 反击技能 --
    if not is_hit then
        return {}
    end

    local len = table.nums(self._break_skill_buffs["back"])
    print("get_back_skill_buffs========="..len)
    local temp = {}

    for i=len,1,-1 do
        local buff = self._break_skill_buffs["back"][i]
        table.print(buff)
        print("trigger_type:"..buff.trigger_type..buff.skill_buff_info.id)

        if buff.trigger_type == 4 then
            table.insertTo(temp, {buff.skill_buff_info})
        elseif buff.trigger_type ==5 and is_block then
            table.insertTo(temp, {buff.skill_buff_info})
        end
    end

    return temp
end

function FMHeroSkill:begin_skill_buffs()
    --进入战场时，施加的buff--
    if self._break_skill_buffs[2] then
        return self._break_skill_buffs[2]
    end
    return {}
end

function FMHeroSkill:set_break_skill_ids(value)
    print("FMHeroSkill:set_break_skill_ids==========")
    table.print(value)
    self._break_skill_buffs["back"] = {}
    for _,id in pairs(value) do
        local skill_info = self.soldierTemplate:getSkillTempLateById(id)
        if skill_info then
            for i,buff_id in pairs(skill_info.group) do
                local skill_buff_info = self.soldierTemplate:getSkillBuffTempLateById(buff_id)
                trigger_type = skill_buff_info.triggerType
                if not table.ink(self._break_skill_buffs, trigger_type) then
                    self._break_skill_buffs[trigger_type] = {}
                end
                if table.inv({4, 5}, trigger_type) then
                    local info = {}
                    info.trigger_type = trigger_type
                    info.skill_buff_info = skill_buff_info
                    table.insert(self._break_skill_buffs["back"], info)
                else
                    table.insert(self._break_skill_buffs[trigger_type], skill_buff_info)
                end
            end
        end
    end
end

function FMHeroSkill:get_skill_type()
    --if not self:is_mp_skill() then
    return TYPE_NORMAL
    --else
        --return TYPE_NORMAL_RAGE
    --end
end

-- 清除过程中的buff
function FMHeroSkill:clear()
    self.after_skill_buffs = {}
end

return FMHeroSkill
