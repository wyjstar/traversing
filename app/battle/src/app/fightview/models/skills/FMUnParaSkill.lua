-- 无双技能类
--
import("..FightUtil")

local FMBuffManager = import("..FMBuffManager")
local FMUnParaSkill = class("FMUnParaSkill", FMUnParaSkill)

function FMUnParaSkill:ctor(unpar_type_id, unpar_other_id, base_info, process)
    print("FMUnParaSkill:ctor=====", unpar_type_id, unpar_other_id, base_info)
    self.unpar_type_id = unpar_type_id
    self.unpar_other_id = unpar_other_id

    self.mp_step = base_info[2]
    if not unpar_type_id then
        return
    end

    self.mp_max = base_info[3]
    self.ready = false
    self.process = process
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.baseTemplate = getTemplateManager():getBaseTemplate()
    self._main_skill_buff = nil -- 主技能
    self._skill_buffs = {}      -- 其他技能
    self:get_skill_buffs(unpar_type_id)
    self:get_skill_buffs(unpar_other_id)

    self.used_times = 0 -- 使用次数
    self.mp = 0
    self.HOME = {}
    self.side = ""
    self.viewPos = 0
    self.level = level
    self.job = job
    self.max_used_times = self.baseTemplate:getBaseInfoById("wushuangTimeMax")
end

function FMUnParaSkill:get_skill_buffs(skill_id)
    if skill_id == 0 then
        return
    end
    skill_info = self.soldierTemplate:getSkillTempLateById(skill_id)
    if skill_info then
        for _, buff_id in pairs(skill_info.group) do
            local skill_buff = self.soldierTemplate:getSkillBuffTempLateById(buff_id)
            print("skill_buff", buff_id, skill_buff)
            if skill_buff.skill_key == 1 then
                print("m++++++++++2")
                self._main_skill_buff = skill_buff
            end
            table.insert(self._skill_buffs, skill_buff)
        end
    end

end

function FMUnParaSkill:get_skill_nos()
    if not self.unpar_type_id then
        return {}
    end
    local skill_nos = {}
    table.insert(skill_nos, unpar_type_id)
    table.insert(skill_nos, unpar_other_id)
    return skill_nos
end

function FMUnParaSkill:get_hero_num()
    return table.nums(self:get_hero_nos())
end

function FMUnParaSkill:get_hero_nos()
    if self.unpar_type_id == nil then
        return {}
    end

    local nos = {}
    return nos
end

function FMUnParaSkill:is_full()
    if not self.unpar_type_id then
        return false
    end
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
    if not self.unpar_type_id then
        return false
    end
    -- 可进行多段攻击
    return self.mp >= self.mp_max
end

function FMUnParaSkill:skill_buffs()
    --docstring for skill_buff_ids--
    
    return self._skill_buffs
end

function FMUnParaSkill:clear_mp()
    if not self.unpar_type_id then
        return
    end
    --释放技能后，减少怒气
    print("unpara clear_mp", self.mp, self.mp_max, self.used_times)
    if self.mp == self.mp_max then
        self.mp = 0
    end
    self.used_times = self.used_times + 1
    print("unpara clear_mp", self.mp, self.mp_max, self.used_times)
end

function FMUnParaSkill:add_mp()
    print("FMUnParaSkill:add_mp",self.mp,self.mp_step,self.mp_max,self.max_used_times,self.used_times)

    if not self.unpar_type_id or self.max_used_times <= self.used_times then
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
    if not self.unpar_type_id then
        return false
    end
    if self.max_used_times <= self.used_times then
        -- 达到使用上限
        print("reach max use time==================",self.mp,self.mp_max)
        return false
    end
    print("FMUnParaSkill:is_ready==>",self.mp,self.mp_max)
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
    if get_fight_mode(self.process.fight_type) == TYPE_MODE_PVP or self.side == "blue" then
        print("is_auto===========", true)
        return true
    end
    print("is_auto===========", false)
    return false
end

function FMUnParaSkill:reset()
    print("reset==================")
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
function FMUnParaSkill:construct_attacker()
    local fight_type = self.process.fight_type
    local attacker = {}
    -- 判断怪物无双
    print("===================blueunpara", fight_type, TYPE_STAGE_ELITE, side)
    if (fight_type == TYPE_STAGE_ELITE or fight_type == TYPE_STAGE_ACTIVITY or fight_type == TYPE_STAGE_NORMAL) and self.side == "blue" then
        for k, v in pairs(self.process.blue_units) do
                print("===================blueunpara1")
            if v.is_boss then
                print("===================blueunpara2")
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
    attacker.unpar_level = self.level
    attacker.unpar_job = self.job
    attacker.str_data = function()
        local info = "unpara skill:"
        info = info.."unpar_type_id:"..self.unpar_type_id.."---"
        info = info.."unpar_other_id:"..self.unpar_other_id.."---"
        info = info.."level:"..self.level.."---"
        info = info.."job:"..self.job.."---"
        info = info.."mp:"..self.mp.."---"
        return info end
    return attacker
end

function FMUnParaSkill:clear()
    self.after_skill_buffs = {}
end


return FMUnParaSkill
