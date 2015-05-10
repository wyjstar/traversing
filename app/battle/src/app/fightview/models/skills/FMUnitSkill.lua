-- 技能基类
--

local FMUnitSkill = class("FMUnitSkill")

function FMUnitSkill:ctor(unit, unit_info, mp_info)
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.unit_no = unit.no
    self.mp = mp_info[1]
    self.mp_step = mp_info[2]
    self.mp_max = mp_info[3]
    self.owner = unit
    self.main_normal_skill_buff = nil
    self.main_mp_skill_buff = nil
    self.attack_normal_skill_buffs = {}
    self.attack_mp_skill_buffs = {}
    self.has_skill_buff = false
    if unit.is_break then
        self.mp = self.mp_max
    end
    self.normal_skill_info = self.soldierTemplate:getSkillTempLateById(unit_info.normalSkill)

    self.main_normal_skill_buff, self.attack_normal_skill_buffs, self.has_normal_treat_skill_buff = 
        self:get_skill_buff(self.normal_skill_info["group"])

    print("main_normal_skill_buff==========="..self.unit_no)
    if self.unit_no == 10048 then
        print("main_normal_skill_buff===========")
        table.print(self.main_normal_skill_buff)
    end
    

    self.mp_skill_info = self.soldierTemplate:getSkillTempLateById(unit_info.rageSkill)
    self.main_mp_skill_buff, self.attack_mp_skill_buffs, self.has_mp_treat_skill_buff = self:get_skill_buff(
        self.mp_skill_info["group"])
end

function FMUnitSkill:get_skill_buff(skill_buff_ids)
    local main_skill_buff = nil
    local attack_skill_buffs = {}
    local has_treat_skill_buff = false
    local id_len = table.nums(skill_buff_ids)
    for i=1,id_len do
        local id = skill_buff_ids[i]
        local skill_buff_info = self.soldierTemplate:getSkillBuffTempLateById(id)
        if skill_buff_info.skill_key == 1 then
            main_skill_buff = skill_buff_info
        end
        table.insert(attack_skill_buffs, skill_buff_info)
        if skill_buff_info.effectId == 26 then
            has_treat_skill_buff = true
        end
    end
    print("has_treat_skill_buff:", has_treat_skill_buff)
    table.print(skill_buff_ids)
    return main_skill_buff, attack_skill_buffs, has_treat_skill_buff
end

function FMUnitSkill:is_full()
    if self.mp == self.mp_max then
        return true
    end
    return false
end

function FMUnitSkill:main_skill_buff(_is_mp_skill)
    --普通技能或者怒气技能中的主技能
    if _is_mp_skill then
        return self.main_mp_skill_buff
    end
    return self.main_normal_skill_buff
end

function FMUnitSkill:is_mp_skill()
    return self:is_full() and (not self.owner.buff_manager:is_slient())
end

function FMUnitSkill:attack_skill_buffs(is_mp_skill)
    --"""普通技能或者怒气技能中的技能"""
    if is_mp_skill then
        return self.attack_mp_skill_buffs
    end
    return self.attack_normal_skill_buffs
end

function FMUnitSkill:has_treat_skill(is_mp_skill)
    --"""普通技能或者怒气技能中是否包含治疗技能(triggerType==26)"""
    if is_mp_skill then
        return self.has_mp_treat_skill_buff
    end
    return self.has_normal_treat_skill_buff
end

-- 获取起手动作
function FMUnitSkill:get_begin_action(is_mp_skill)
    if is_mp_skill then
        return self.mp_skill_info.action
    end
    return nil
    --return self.normal_skill_info.action
end

function FMUnitSkill:clear_mp()
    self.mp = 0
end

function FMUnitSkill:add_mp(is_mp_skill)
    -- 攻击结束后，修改怒气值。
    if is_mp_skill then
        return
    end
    self.mp = self.mp + self.mp_step
    if self.mp > self.mp_max then
        self.mp = self.mp_max
    end
end

function FMUnitSkill:get_mp()
    return self.mp
end

function FMUnitSkill:set_mp(value)
    if value < 0 then
        self.mp = 0
    elseif value > self.mp_max then
        self.mp = self.mp_max
    else
        self.mp = value
    end
end

function FMUnitSkill:set_full_mp()
    self.mp = self.mp_max
end

return FMUnitSkill
