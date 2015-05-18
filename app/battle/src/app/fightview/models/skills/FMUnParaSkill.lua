-- 无双技能类
--
import("..FightUtil")

local FMBuffManager = import("..FMBuffManager")
local FMUnParaSkill = class("FMUnParaSkill", FMUnParaSkill)

function FMUnParaSkill:ctor(unpara_info, base_info, level, process)
    print(level)
    self.unpara_info = unpara_info
    if not unpara_info then
        return
    end
    self.mp = base_info[1]
    self.mp_step = base_info[2]
    self.mp_max1 = base_info[3]
    self.mp_max2 = base_info[4]
    self.mp_max3 = base_info[5]
    self.level = level
    self.mp_max = base_info[level+2]
    self.ready= false
    self.process = process
    print("FMUnParaSkill:ctor=====", self.process)
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    skill_info = self.soldierTemplate:getSkillTempLateById(unpara_info["triggle"..level])
    self._main_skill_buff = nil
    self._skill_buffs = {}
    if skill_info then
        for _, buff_id in pairs(skill_info.group) do
            local skill_buff = self.soldierTemplate:getSkillBuffTempLateById(buff_id)
            print("m++++++++++1")
            if skill_buff.skill_key == 1 then
                print("m++++++++++2")
                self._main_skill_buff = skill_buff
            end
            table.insert(self._skill_buffs, skill_buff)
        end
    end
    self.HOME = {}
    self.side = ""
    self.viewPos = 0
end

function FMUnParaSkill:get_skill_nos()
    if not self.unpara_info then
        return {}
    end
    local skill_nos = {}
    for i=1, self.level do
        if i > 3 then i = 3 end
        table.insert(skill_nos, self.unpara_info["triggle"..i])
    end
    return skill_nos
end

function FMUnParaSkill:get_hero_num()
    local item = self.unpara_info
    if item == nil then
        return 0
    end

    local tempIndex = 0
    for i = 1, 6 do
        local name = "condition" .. i
        local conditionValue = item[name]
        if conditionValue ~= 0 then
            tempIndex = tempIndex + 1
        end
    end
    return tempIndex
end

function FMUnParaSkill:is_full()
    --只进行最后的三段攻击--
    if self.mp == self.mp_max then
        return true
    end
    return false
end

function FMUnParaSkill:is_mp_skill()
    return true
end

function FMUnParaSkill:is_can()
    -- 可进行多段攻击
    return self.mp >= self.mp_max1
end

function FMUnParaSkill:skill_buffs()
    --docstring for skill_buff_ids--
    return self._skill_buffs
end

function FMUnParaSkill:clear_mp()
    --释放技能后，减少怒气
    if self.mp == self.mp_max3 then
        self.mp = 0
    elseif self.mp >= self.mp_max2 then
        self.mp = self.mp - self.mp_max2
    elseif self.mp >= self.mp_max1 then
        self.mp = self.mp - self.mp_max1
    end
end

function FMUnParaSkill:add_mp()
    print("FMUnParaSkill:add_mp")
    --docstring for add_mp--
    if not self.unpara_info then
        return 
    end
    if not self:is_full() then
        self.mp = self.mp + self.mp_step
        --如果超过最大怒气，赋值为最大怒气,
        if self.mp > self.mp_max then
            self.mp = self.mp_max
        end
    end
end

function FMUnParaSkill:is_ready()
    if not self.unpara_info then
        return false
    end
    if self:is_auto() then
        -- 自动释放
        return self:is_full()
    else
        -- 手动释放
        return self.ready
    end
end

-- 是否是自动释放
function FMUnParaSkill:is_auto()
    if get_fight_mode(self.process.fight_type) == TYPE_MODE_PVP then
        print("is_auto===========", true)
        return true
    end
    print("is_auto===========", false)
    return false
end

function FMUnParaSkill:reset()
    self.ready = false
    --self:reset_mp()
end

function FMUnParaSkill:main_skill_buff()
    return self._main_skill_buff
end

function FMUnParaSkill:attack_skill_buffs()
    return self._skill_buffs
end

function FMUnParaSkill:get_before_skill_buffs()
    return {}
end
function FMUnParaSkill:set_after_skill_buffs(is_hit, is_mp_skill)
    return {}
end
function FMUnParaSkill:get_after_skill_buffs()
    return {}
end

function FMUnParaSkill:get_skill_type()
    return TYPE_UNPARAL
end

function FMUnParaSkill:get_begin_action()
    return nil
end

-- 构造attacker:view 可以统一处理
function FMUnParaSkill:construct_attacker(side)
    local fight_type = self.process.fight_type
    local attacker = {}
    -- 判断怪物无双
    if fight_type == TYPE_STAGE_ELITE or fight_type == TYPE_STAGE_ACTIVITY or fight_type == TYPE_STAGE_NORMAL and side == "blue" then
        for k, v in pairs(self.process.blue_units) do
            if v.is_boss then
                attacker.is_monster = true -- 判断是否是怪物无双
                attacker.boss = v
            end
        end
    end
    attacker.skill = self
    attacker.side = self.side
    attacker.viewPos = self.viewPos
    attacker.HOME = self.HOME
    attacker.buff_manager = FMBuffManager.new(attacker)
    attacker.str_data = function()
        local info = "unpara skill:"
        info = info.."id:"..self.unpara_info.id.."---"
        info = info.."level:"..self.level.."---"
        info = info.."mp:"..self.mp.."---"
        return info end
    return attacker
end

function FMUnParaSkill:clear()
    self.after_skill_buffs = {}
end
return FMUnParaSkill
