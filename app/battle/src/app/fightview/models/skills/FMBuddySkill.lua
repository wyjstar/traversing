-- 小伙伴技能类
--
local FMBuddySkill = class("FMBuddySkill", FMBuddySkill)

function FMBuddySkill:ctor(unit)
    self.baseTemplate = getTemplateManager():getBaseTemplate()
    local mp_info = self.baseTemplate:getBaseInfoById("huoban_value_config")
    self.unit = unit
    self.mp = mp_info[1]
    self.mp_step = mp_info[2]
    self.mp_max = mp_info[3]
    self.mp_init = mp_info[1]
    self.ready = false
end

function FMBuddySkill:get_skill_nos()
    local skill_nos = {}
    local v = self.unit
    table.insert(skill_nos, v.unit_info.normalSkill) -- 普通技能
    table.insert(skill_nos, v.unit_info.rageSkill)-- 怒气技能
    table.insertTo(skill_nos, v:get_break_skill_nos())-- 突破技能
    return skill_nos
end

function FMBuddySkill:is_full()
    print("FMBuddySkill:is_full=====================>"..self.mp.. ", "..self.mp_max)
    if tonumber(self.mp) == tonumber(self.mp_max) then
        print("FMBuddySkill:is_full===================>")
        return true
    end
    return false
end

function FMBuddySkill:skill_buff_ids()
    return self.unit.skill_buff_ids
end

function FMBuddySkill:main_skill_buff()
    return self.unit._skill.main_mp_skill_buff
end

function FMBuddySkill:get_before_skill_buffs()
    return self.unit._skill:get_before_skill_buffs()
end

function FMBuddySkill:set_after_skill_buffs(is_hit, is_mp_skill)
    return self.unit._skill:set_after_skill_buffs(is_hit, true)
end

function FMBuddySkill:get_after_skill_buffs(is_hit)
    return self.unit._skill:get_after_skill_buffs(is_hit)
end

function FMBuddySkill:get_back_skill_buffs(is_hit, is_block)
    return self.unit._skill:get_back_skill_buffs(is_hit, is_block)
end

function FMBuddySkill:attack_skill_buffs()
    --docstring for attack_skill_buffs--
    return self.unit._skill.attack_mp_skill_buffs
end

function FMBuddySkill:clear_mp()
    --reset mp
    self.mp = self.mp_init
    self.ready = false
end

function FMBuddySkill:is_ready()
    return self.ready
end

function FMBuddySkill:add_mp()
    --docstring for add_mp--
    if not self:is_full() then
        self.mp = self.mp + self.mp_step
    end
    if self.mp > self.mp_max then
        self.mp = self.mp_max
    end
    if self.mp == self.mp_max then
        self.unit._skill:set_full_mp()
    end
    print("FMBuddySkill:add_mp()===============", self.mp_step, self.mp)
end

function FMBuddySkill:is_mp_skill()
    return true
end

function FMBuddySkill:get_skill_type()
    return TYPE_BUDDY
end

function FMBuddySkill:get_begin_action()
    return self.unit._skill:get_begin_action(true)
end

function FMBuddySkill:clear()
    self.unit._skill:clear()
end
return FMBuddySkill
