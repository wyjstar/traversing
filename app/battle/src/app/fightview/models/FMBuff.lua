-- 对应于SkillBuff

local FMBuff = class("FMBuff")

function FMBuff:ctor(target_side, skill_buff_info, process)
    self.process = process
    self.target_side = target_side
    --attacker = self.process.attacker
    self.skill_buff_info = skill_buff_info
    self.continue_num = skill_buff_info.continue
    self.value = 0
end

function FMBuff:check_hit(owner)
    return check_hit(self.skill_buff_info, self.process.attacker, owner)
end

function FMBuff:perform_hp_mp_buff(owner)
    appendFile2("buff前："..owner:str_data(), 1)
    local effect_id = self.skill_buff_info.effectId
    if table.inv({3,8,9,26, 33, 34, 35}, effect_id) then
        -- 伤害或者治疗buff与持续性buff不同，提前一回合去buff
        self.continue_num = self.continue_num - 1
    end
    if effect_id == 3 then
        owner:set_hp(owner.hp-self.value)
    elseif effect_id == 8 then
        owner.skill:set_mp(owner.skill.mp+self.value)
    elseif effect_id == 9 then
        owner.skill:set_mp(owner.skill.mp+self.value)
    elseif effect_id == 26 then
        owner:set_hp(owner.hp+self.value)
    end
    appendFile2("值:"..roundNumberIfNumber(self.value).."\n", 1)
    appendFile2("buff后："..owner:str_data(), 1)
    appendFile2("------------------------------", 1)
    if owner.hp <= 0 then
        print("hero dead==========", owner.no, owner.pos)
    end
    if owner.hp<=0 and table.ink(self.target_side, owner.pos) then 
        print("hero dead==========", owner.no)
        self.target_side[owner.pos] = nil
        print("target_len=======:", table.nums(self.target_side))
        print("target_len=======:", table.nums(self.process.red_units))
        print("target_len=======:", table.nums(self.process.blue_units))
    end
end

function FMBuff:perform_buff(owner, result)
    print("FMBuff:perform_buff==============")
    --local temp_buff_set = self.process.temp_buff_set
    --local result = temp_buff_set:get_last_data()
    appendFile2("buff前："..owner:str_data(), 1)
    local attacker = self.process.attacker
    local effect_id = self.skill_buff_info.effectId
    print("perform buff effect_id "..effect_id)
    if table.inv({1,2,3,8,9,26, 33, 34, 35}, effect_id) then
        -- 伤害或者治疗buff与持续性buff不同，提前一回合去buff
        self.continue_num = self.continue_num - 1
    end

    local extra_msgs = {}
    if table.inv({1,2}, effect_id) then
        print("1============")
        if result.is_block == nil then
            result.is_block = check_block(attacker, owner, self.skill_buff_info)
        end
        result.is_cri = check_cri(attacker.cri, owner.ductility, self.skill_buff_info)
        result.value = execute_demage(attacker, owner, self.skill_buff_info, is_block, result.is_cri, extra_msgs)
    elseif table.inv({3, 33, 34, 35}, effect_id) then
        print("2============",effect_id)
        result.value = execute_pure_demage(attacker, owner, self.skill_buff_info, extra_msgs)
        self.value = result.value
    elseif table.inv({8, 9}, effect_id) then
        print("3============")
        result.value = execute_mp(owner, self.skill_buff_info, extra_msgs)
        self.value = result.value
    elseif table.inv({26}, effect_id) then
        print("4============")
        result.is_cri = check_cri(attacker.cri, owner.ductility, self.skill_buff_info)
        result.value = execute_treat(attacker, owner, self.skill_buff_info, result.is_cri, extra_msgs)
        self.value = result.value
    elseif table.inv({30}, effect_id) then
        print("attacker_side============", attacker.is_monster)
        print(self.process.army)
        if not attacker.is_monster then
            result.value = unpara(attacker, self.skill_buff_info, owner)
        else
            result.value = unpara_monster(attacker.atk, owner, extra_msgs)
        end
    else
        self.value = self:get_buff_value_util(owner)
    end
    result.extra_msgs = extra_msgs
    appendFile2("buff："..self:str_data(), 1)
    for _,v in pairs(result.extra_msgs) do
        appendFile2("详细信息:"..v, 1)
    end
    appendFile2("值:"..roundNumberIfNumber(result.value).."\n", 1)
    appendFile2("buff后："..owner:str_data(), 1)
    appendFile2("------------------------------", 1)
    if owner.hp <= 0 then
        print("hero dead==========", owner.no, owner.pos)
        print("target_len2=======:", table.nums(self.target_side))
        print("target_len2=======:", table.nums(self.process.red_units))
        print("target_len2=======:", table.nums(self.process.blue_units))
        for i,v in pairs(self.process.blue_units) do
            print(i, v.pos)
        end
        for i,v in pairs(self.target_side) do
            print(i, v.pos)
        end
    end
    if owner.hp<=0 and table.ink(self.target_side, owner.pos) then 
        print("hero dead==========", owner.no)
        self.target_side[owner.pos] = nil
        --table.remove(self.target_side, owner.pos)
        --print("target_len2=======:", table.nums(self.target_side))
        --print("target_len2=======:", table.nums(self.process.red_units))
        --print("target_len2=======:", table.nums(self.process.blue_units))
    end
end

function FMBuff:get_buff_value_util(owner)
    local effect_id = self.skill_buff_info.effectId
    if effect_id == 6 then
        return get_buff_value(owner.atk, self)
    elseif effect_id == 7 then
        return get_buff_value(owner.atk, self) * -1
    elseif effect_id == 10 then
        return get_buff_value(owner.physical_def, self)
    elseif effect_id == 11 then
        return get_buff_value(owner.physical_def, self) * -1
    elseif effect_id == 12 then
        return get_buff_value(owner.magic_def, self)
    elseif effect_id == 13 then
        return get_buff_value(owner.magic_def, self) * -1
    elseif effect_id == 14 then
        return get_buff_value(owner.hit, self)
    elseif effect_id == 15 then
        return get_buff_value(owner.hit, self) * -1
    elseif effect_id == 16 then
        return get_buff_value(owner.dodge, self)
    elseif effect_id == 17 then
        return get_buff_value(owner.dodge, self) * -1
    elseif effect_id == 18 then
        return get_buff_value(owner.cri, self)
    elseif effect_id == 19 then
        return get_buff_value(owner.cri, self) * -1
    elseif effect_id == 20 then
        return get_buff_value(owner.cri_coeff, self)
    elseif effect_id == 21 then
        return get_buff_value(owner.cri_ded_coeff, self)
    elseif effect_id == 22 then
        return get_buff_value(owner.block, self)
    elseif effect_id == 23 then
        return get_buff_value(owner.block, self) * -1
    elseif effect_id == 28 then
        return get_buff_value(owner.ductility, self)
    elseif effect_id == 29 then
        return get_buff_value(owner.ductility, self) * -1
    end
    return 0
end
function FMBuff:str_data()
    local temp = ""
    local buff_info = self.skill_buff_info
    temp = temp.." buffID:"..tostring(buff_info.id)
    temp = temp.."--类型:"..tostring(buff_info.effectId)
    temp = temp.."--当前持续回合:"..tostring(self.continue_num)
    temp = temp.."--持续回合:"..tostring(buff_info.continue)
    temp = temp.."--数值类型:"..tostring(buff_info.valueType)
    temp = temp.."--基础数值效果:"..tostring(buff_info.valueEffect)
    temp = temp.."--作用方:"..tostring(buff_info.effectRole)
    temp = temp.."--是否是主技能:"..tostring(buff_info.skill_key)
    temp = temp.."--作用位置:"..tostring(get_str(buff_info.effectPos))
    temp = temp.."--是否叠加:"..tostring(buff_info.overlay)
    temp = temp.."--替换权重:"..tostring(buff_info.replace)
    temp = temp.."--触发率:"..tostring(buff_info.triggerRate)
    temp = temp.."--值:"..tostring(self.value)
    return temp
end
-- 数值处理小数点的数值, 返回string
function roundNumberIfNumber(value)
    print(value, "wzp======1", type(value))
    if type(value) ~= "number" then
        return tostring(value)
    end
    -- return math.round(number)        -- 四舍五入
    return tostring(math.floor(value))           -- 舍去小数点
end


return FMBuff
