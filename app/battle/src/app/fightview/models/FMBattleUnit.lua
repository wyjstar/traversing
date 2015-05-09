-- 战斗单元

local FMBuffManager = import("..models.FMBuffManager")
local FMBattleUnit = class("FMBattleUnit")

function FMBattleUnit:ctor(data)
    self.no = 0
    self.unit_name = ""
    self.hp = 0
    self.hp_max = 0
    self.hp_begin = 0
    self.atk = 0
    self.physical_def = 0
    self.magic_def = 0
    self.hit = 0           -- 命中率
    self.dodge = 0         -- 闪避率
    self.cri = 0           -- 暴击率
    self.cri_coeff = 0     -- 暴击伤害系数
    self.cri_ded_coeff = 0 -- 暴击减免系数
    self.block = 0         -- 格挡率
    self.ductility = 0     -- 韧性
    self.level = 0         -- 等级
    self.break_level = 0   -- 突破等级
    self.quality = 0       -- 武将品质
    self.is_boss = false   -- 是否为boss
    self.skill = nil       -- 技能
    self.is_break = false  -- 是否为突破
    self.is_awake = false  -- 是否觉醒
    self.origin_no = 0     -- 突破或者觉醒武将的原始no
    self.unit_info = nil   -- 配置表信息
    self.chief = false   -- 配置表信息

    self.buff_manager = FMBuffManager.new(self)

end

function FMBattleUnit:get_hp()
    return self.hp
end

function FMBattleUnit:set_hp(value)
    self.hp = value 
    if self.hp < 0 then 
        self.hp = 0
    elseif self.hp > self.hp_max then
        self.hp = self.hp_max
    end
end

function FMBattleUnit:get_hp_percent()
    print("hp",self.hp,"hp_max",self.hp_max)
    return (self.hp / self.hp_max)*100
end

function FMBattleUnit:get_mp_percent()
    return (self.skill.mp / self.skill.mp_max)*100
end

function FMBattleUnit:get_atk()
    print("get_atk:", self.atk)
    return self.buff_manager:get_buffed_atk(self.atk)
end

function FMBattleUnit:get_physical_def()
    print("get_physical_def:", self.physical_def)
    return self.buff_manager:get_buffed_physical_def(self.physical_def)
end

function FMBattleUnit:get_magic_def()
    return self.buff_manager:get_buffed_magic_def(self.magic_def)
end

function FMBattleUnit:get_hit()
    print("get_hit"..self.hit)
    print(self.buff_manager:get_buffed_hit(self.hit))
    return self.buff_manager:get_buffed_hit(self.hit)
end

function FMBattleUnit:get_dodge()
    return self.buff_manager:get_buffed_dodge(self.dodge)
end

function FMBattleUnit:get_cri()
    print("get_cri:", self.cri)
    return self.buff_manager:get_buffed_cri(self.cri)
end

function FMBattleUnit:get_cri_coeff()
    return self.buff_manager:get_buffed_cri_coeff(self.cri_coeff)
end

function FMBattleUnit:get_cri_ded_coeff()
    return self.buff_manager:get_buffed_cri_ded_coeff(self.cri_ded_coeff)
end

function FMBattleUnit:get_block()
    return self.buff_manager:get_buffed_block(self.block)
end

function FMBattleUnit:get_ductility()
    return self.buff_manager:get_buffed_ductility(self.ductility)
end

function FMBattleUnit:get_break_skill_nos()
    skill_ids = {}
    local break_level = self.break_level
    for i = 1, break_level do 
        local break_str = "break" ..  i 
        local break_skill_id = self.unit_info[break_str]
        print("break_skill_id:======",break_skill_id)
        if break_skill_id ~= 0 then
            table.insert(skill_ids, break_skill_id)
        end
    end
    return skill_ids
end

function FMBattleUnit:is_dead()
    if self.hp <= 0 then
        return true
    end
    return false
end

function FMBattleUnit:reset()
    self.buff_manager:clear()
    self.hp = self.hp_max
    self.mp = 0
end

function FMBattleUnit:str_data()
    local info = ""
    info=info.."武将no:"..self.no.."---"
    info=info.."hp:"..self:get_hp().."---"
    info=info.."mp:"..self.skill.mp.."---"
    info=info.."攻击:"..self:get_atk().."---"
    info=info.."物理防御:"..self:get_physical_def().."---"
    info=info.."魔法防御:"..self:get_magic_def().."---"
    info=info.."命中:"..self:get_hit().."---"
    info=info.."闪避:"..self:get_dodge().."---\n"
    info=info.."\t暴击:"..self:get_cri().."---"
    info=info.."暴击系数:"..self:get_cri_coeff().."---"
    info=info.."暴击减免系数:"..self:get_cri_ded_coeff().."---"
    info=info.."格挡:"..self:get_block().."---"
    info=info.."韧性:"..self:get_ductility().."---"
    info=info.."位置:"..self.pos.."---"
    info=info.."等级:"..self.level.."---"
    info=info.."突破等级:"..self.break_level.."---"

    info=info.."\n\tBuffs:\n"
    info=info..self.buff_manager:str_data()

    return info.."\n"
end

return FMBattleUnit
