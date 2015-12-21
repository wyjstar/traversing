-- SkillBuffManager
-- 每个武将身上的buff集合
import(".FMExecuteSkill")


local FMBuffManager = class("FMBuffManager")

function FMBuffManager:ctor(owner)
    self.owner = owner
    self.buffs = {} -- 作用在自身的buff
    self.target_buffs = {} -- 作用在其他人的buff
end

function FMBuffManager:add(buff, result)
    -- 添加buff
    print("add:======", buff.skill_buff_info.id)
    if result.is_hit == nil and not buff:check_hit(self.owner) then
        result.is_hit = false
        return result
    elseif result.is_hit == false then
        return result
    else 
        result.is_hit = true
    end
    print("buff_info:=====", buff.skill_buff_info.id)

    local effect_id = buff.skill_buff_info.effectId
    if not table.ink(self.buffs, effect_id) then
        self.buffs[effect_id] = {}
    end
    if buff.skill_buff_info.overlay == 1 then   -- 叠加
        self:_add_buff(buff, effect_id, false, result)
    elseif buff.skill_buff_info.overlay == 0 then   -- 替换
        if table.nums(self.buffs[effect_id]) > 0 then
            local temp = self.buffs[effect_id][1]
            if temp.skill_buff_info.replace <= buff.skill_buff_info.replace then --替换
                self:_add_buff(buff, effect_id, true, result)
            end
        else
            self:_add_buff(buff, effect_id, false, result)
        end
    end
end

--执行hp mp buff
function FMBuffManager:perform_hp_mp_buff(process)
    print("perform_hp_mp_buff=========")
    appendFile2("hp mp 相关buff------------------------------", 1)
    for k, buffs in pairs(self.buffs) do
        if table.inv({3, 8, 9, 26, 27, 33, 34, 35}, k) then
            local i = 1
            while buffs[i] do
                local buff = buffs[i]
                buff:perform_hp_mp_buff(self.owner)
                process.temp_buff_set:add_before_buff(self.owner, buff, buff.value)
                print("perform_hp_mp_buff=======", buff.skill_buff_info.id, buff.continue_num)

                if buff.continue_num <= 0 then
                    table.remove(buffs, i)
                else
                    i = i + 1
                end
            end
            --appendFile2("hp_mp_buff=========", 1)
            --appendFile2(self.owner:str_data(), 1)
        end
    end
end

-- 执行主动buff
function FMBuffManager:perform_active_buff(process)
    appendFile2("主动buff------------------------------", 1)
    print("FMBuffManager:perform_active_buff======")
    -- 在回合开始时，使buff生效
    for k, buffs in pairs(self.buffs) do
        if table.inv({6, 7, 14, 15, 18, 19, 20, 21, 24, 25, 31, 32, 36}, k) then
            local i = 1
            while buffs[i] do
                local buff = buffs[i]
                appendFile2("buff前："..self.owner:str_data(), 1)
                buff.continue_num = buff.continue_num - 1
                process.temp_buff_set:add_after_buff(self.owner, buff, 0)
                print("perform_buff=======", buff.skill_buff_info.id, buff.skill_buff_info.effectId)
                if buff.continue_num <= 0 then
                    table.remove(buffs, i)
                else
                    i = i + 1
                end
                appendFile2("buff："..buff:str_data(), 1)
                appendFile2("buff后："..self.owner:str_data(), 1)
                appendFile2("------------------------------", 1)
            end
        end
    end
end

-- 执行被动buff
function FMBuffManager:perform_passive_buff(process)
    print("FMBuffManager:perform_passive_buff======")
    -- 在回合开始时，使buff生效
    appendFile2("被动buff------------------------------", 1)
    for k, buffs in pairs(self.buffs) do
        if table.inv({4, 5, 10, 11, 12, 13, 16, 17, 22, 23, 28, 29}, k) then
            local i = 1
            while buffs[i] do
                local buff = buffs[i]
                --print("passive_buff=================", buffs[i].continue_num, table.nums(buffs))
                appendFile2("buff前："..self.owner:str_data(), 1)
                appendFile2("buff===="..buff.continue_num, 0)
                buff.continue_num = buff.continue_num - 1
                appendFile2("buff===="..buff.continue_num, 0)
                process.temp_buff_set:add_before_buff(self.owner, buff, 0)
                --print("perform_buff=======", buff.skill_buff_info.id, buff.skill_buff_info.effectId)
                if buff.continue_num <= 0 then
                    table.remove(buffs, i)
                else
                    i = i + 1
                end
                print("passive_buff=================", table.nums(buffs))
                appendFile2("buff====len"..table.nums(buffs), 0)
                appendFile2("buff："..buff:str_data(), 1)
                appendFile2("buff后："..self.owner:str_data(), 1)
                appendFile2("------------------------------", 1)
            end
        end
    end
end

function FMBuffManager:_add_buff(buff, effect_id, replace, result)
    local effectIds = {1, 2, 3, 8, 9, 26, 30, 33, 34, 35}
    if table.inv(effectIds, effect_id) then
        buff:perform_buff(self.owner, result)
    end
    if not table.inv(effectIds, effect_id) then
        appendFile2("buff前："..self.owner:str_data(), 1)
        buff.value = buff:get_buff_value_util(self.owner)
    end
    if buff.continue_num > 0 then
        if replace then
            self.buffs[effect_id] = {buff}
        else
            table.insert(self.buffs[effect_id], buff)
        end
    end
    if not table.inv(effectIds, effect_id) then
        appendFile2("buff："..buff:str_data(), 1)
        appendFile2("buff后："..self.owner:str_data(), 1)
        appendFile2("------------------------------", 1)
    end

end

function FMBuffManager:remove(triggerType)
    print("FMBuffManager:remove======")
    for k,v in pairs(self.buffs) do
        temp = {}
        for _, buff in pairs(v) do
            --buff.continue_num = buff.continue_num - 1
            print("triggerType======", buff.skill_buff_info.triggerType)
            if buff.skill_buff_info.triggerType ~= triggerType then
                table.insert(temp, buff)
            end
        end
        self.buffs[k] = temp
    end
end

function FMBuffManager:get_buffed_atk(atk)
    return self:get_buff_value_util(6, 7, atk)
end
function FMBuffManager:get_buffed_dodge(dodge)
    return self:get_buff_value_util(16, 17, dodge)
end

function FMBuffManager:get_buffed_physical_def(physical_def)
    return self:get_buff_value_util(10, 11, physical_def)
end

function FMBuffManager:get_buffed_magic_def(magic_def)
    return self:get_buff_value_util(12, 13, magic_def)
end

function FMBuffManager:get_buffed_hit(hit)
    return self:get_buff_value_util(14, 15, hit)
end

function FMBuffManager:get_buffed_cri(cri)
    return self:get_buff_value_util(18, 19, cri)
end


function FMBuffManager:get_buffed_cri_coeff(cri_coeff)
    return self:get_buff_value_util(20, -1, cri_coeff)
end

function FMBuffManager:get_buffed_cri_ded_coeff(cri_ded_coeff)
    return self:get_buff_value_util(21, -1, cri_ded_coeff)
end

function FMBuffManager:get_buffed_block(block)
    return self:get_buff_value_util(22, 23, block)
end

function FMBuffManager:get_buffed_ductility(ductility)
    return self:get_buff_value_util(28, 29, ductility)
end

function FMBuffManager:is_dizzy()
    return self:is_state_util({24, 31, 32})
end

function FMBuffManager:is_slient()
    return self:is_state_util({25, 36})
end

function FMBuffManager:is_state_util(nos)
    for _, no in pairs(nos) do
        local temp_buffs = self.buffs[no]
        if not temp_buffs then
            temp_buffs = {}
        end
        for _,buff_info in pairs(temp_buffs) do
            return true
        end
    end
    return false
end

function FMBuffManager:get_buff_value_util(add, sub, temp)
    local temp_buffs = self.buffs[add]
    if not temp_buffs then
        temp_buffs = {}
    end
    for _, buff in pairs(temp_buffs) do
        temp = temp + buff.value
    end

    local temp_buffs = self.buffs[sub]
    if not temp_buffs then
        temp_buffs = {}
    end
    for _, buff in pairs(temp_buffs) do
        temp = temp + buff.value
    end
    return temp
end

function FMBuffManager:str_data()
    local info = ""
    for _, buffs in pairs(self.buffs) do
        local len = table.nums(buffs)
        for i=1,len do
            local buff = buffs[i]
            info = info.."\t\t"..buff:str_data().."\n"
        end
    end
    return info
end

function get_str(t)
    local temp = ""
    for k,v in pairs(t) do
        temp = temp.."{"..k..":"..v.."}"
        return temp
    end
    return temp
end

function FMBuffManager:clear()
    self.buffs = {}
end

return FMBuffManager
