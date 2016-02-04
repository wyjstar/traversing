-- 通过技能的作用位置，找到作用对象Unit
local process = nil

function single_attack(value, attacker, target_units)
    local attack_orders = {
        {1,2,3,4,5,6},
        {2,3,1,5,6,4},
        {3,1,2,6,5,4},
        {1,2,3,4,5,6},
        {2,3,1,5,6,4},
        {3,1,2,6,4,5},
    }

    local order = attack_orders[attacker.pos]
    for _,i in pairs(order) do
        local unit_i = target_units[i]
        if unit_i then
            return {unit_i}, TYPE_NORMAL_POS
        end
    end
    return {}, TYPE_NORMAL_POS
end

function all_attack(value, attacker, target_units)
    return table.values(target_units), TYPE_ALL_POS
end

function front_attack(value, attacker, target_units)
    local front_units = {}
    for _, i in pairs({1,2,3}) do
        local unit_i = target_units[i]
        if unit_i then
            table.insert(front_units, unit_i)
        end
    end
    if table.nums(front_units) ~= 0 then
        return front_units, TYPE_FRONT_ROW
    else
        return table.values(target_units), TYPE_BACK_ROW
    end
end

function back_attack(value, attacker, target_units)
    local back_units = {}
    for _, i in pairs({4,5,6}) do
        local unit_i = target_units[i]
        if unit_i then
            table.insert(back_units, unit_i)
        end
    end
    if #back_units ~= 0 then
        return back_units, TYPE_BACK_ROW
    else
        return table.values(target_units), TYPE_FRONT_ROW
    end
end

function vertical_attack(value, attacker, target_units)
    print("vertical_attack==========="..table.nums(target_units))
    local viewTargetPos = nil
    local attack_orders = {
        [1]={{1, 4}, {2, 5}, {3, 6}},
        [4]={{1, 4}, {2, 5}, {3, 6}},
        [2]={{2, 5}, {3, 6}, {1, 4}},
        [5]={{2, 5}, {3, 6}, {1, 4}},
        [3]={{3, 6}, {1, 4}, {2, 5}},
        [6]={{3, 6}, {1, 4}, {2, 5}}
    }

    local vertical_units = {}
    local order = attack_orders[attacker.pos]
    for _, v in pairs(order) do
        local i = v[1]
        local j = v[2]
        print("i====="..i.."j========="..j)
        local unit_i = target_units[i]
        local unit_j = target_units[j]
        print(unit_i)
        print(unit_j)
        if unit_i then
            table.insert(vertical_units, unit_i)
        end
        if unit_j then
            table.insert(vertical_units, unit_j)
        end
        if table.nums(vertical_units) ~= 0 then
            print("=================has unit")
            local first_unit = vertical_units[1]
            if table.inv({1, 4}, first_unit.pos) then
                viewTargetPos = TYPE_FIRST_COLUMN
            elseif table.inv({2, 5}, first_unit.pos) then
                viewTargetPos = TYPE_SECOND_COLUMN
            elseif table.inv({3, 6}, first_unit.pos) then
                viewTargetPos = TYPE_THIRD_COLUMN
            end
            return vertical_units, viewTargetPos
        end
    end
    return {}, viewTargetPos
end

function random_attack(value, attacker, target_units)
    local target_nos = get_random_lst(target_units, value)
    local random_units = {}
    for _,no in pairs(target_nos) do
        table.insert(random_units, target_units[no])
    end
    return random_units, TYPE_NORMAL_POS
end

function hp_max_attack(value, attacker, target_units)
    local target_units_lst = table.values(target_units)
    table.sort(target_units_lst, function (t1, t2)
        if t1:get_hp_percent() > t2:get_hp_percent() then
            return true
        end
        return false
    end)
    print("target_units_lst==========")
    for i,v in pairs(target_units_lst) do
        print(v.no)
    end
    return table.firstItems(target_units_lst, value), TYPE_NORMAL_POS
end

function hp_min_attack(value, attacker, target_units)
    local target_units_lst = table.values(target_units)
    table.sort(target_units_lst, function (t1, t2)
        if t1:get_hp_percent() < t2:get_hp_percent() then
            return true
        end
        return false
    end)
    return table.firstItems(target_units_lst, value), TYPE_NORMAL_POS
end

function mp_max_attack(value, attacker, target_units)
    local target_units_lst = table.values(target_units)
    table.sort(target_units_lst, function (t1, t2)
        if t1.skill:get_mp() > t2.skill:get_mp() then
            return true
        end
        return false
    end)
    return table.firstItems(target_units_lst, value), TYPE_NORMAL_POS
end

function mp_min_attack(value, attacker, target_units)
    local target_units_lst = table.values(target_units)
    table.sort(target_units_lst, function (t1, t2)
        if t1.skill:get_mp() < t2.skill:get_mp() then
            return true
        end
        return false
    end)
    return table.firstItems(target_units_lst, value), TYPE_NORMAL_POS
end

function self_attack(value, attacker, target_units)
    return {attacker}, TYPE_NORMAL_POS
end


find_target_types = {
     [ 1  ] = single_attack,   -- 单体攻击
     [ 2  ] = all_attack,      -- 全体攻击
     [ 3  ] = front_attack,    -- 前排攻击
     [ 4  ] = back_attack,     -- 后排攻击
     [ 5  ] = vertical_attack, -- 竖排攻击
     [ 6  ] = random_attack,   -- 随机攻击
     [ 7  ] = hp_min_attack,   -- 血量百分比最小攻击
     [ 8  ] = hp_max_attack,   -- 血量百分比最大攻击
     [ 9  ] = mp_min_attack,   -- 怒气最小攻击
     [ 10 ] = mp_max_attack,   -- 怒气最大攻击
     [ 11 ] = self_attack     -- 自己
}

-- 根据作用位置找到作用武将
function find_target_units(skill_buff_info, main_target_units, viewMainTargetPos) 
    --local attacker = skill_buff_info
    local attacker = process.attacker
    local target_pos = skill_buff_info.effectPos
    -- table.print(target_pos)
    local key = 0
    local value = 0
    for k, v in pairs(target_pos) do
        key = tonumber(k)
        value = v
        break
    end
    print("key++++++"..key.."value++++++++"..value,"buffID:",skill_buff_info.id)

    local target_side = find_side(skill_buff_info)
    if key == 12 then
        print(table.nums(main_target_units))
        return main_target_units, target_side, viewMainTargetPos
    end

    local func = find_target_types[key]
    local result, viewTargetPos = func(value, attacker, target_side)
    print(table.nums(result))
    print(viewTargetPos)
    return result, target_side, viewTargetPos
end

--反击目标位置
function find_back_target_units(skill_buff_info, target)
    local attacker = process.attacker
    local target_pos = skill_buff_info.effectPos
    local key = 0
    local value = 0
    for k, v in pairs(skill_buff_info.effectPos) do
        key = tonumber(k)
        value = v
        break
    end
    --if key ~= 13 then
        --print("error! 反击作用位置为｛13: 0｝")
    --end
    local target_side = find_side(skill_buff_info)
    if key == 13 then
        return {target}, target_side, TYPE_NORMAL_POS
    end
    if key == 12 then
        print(table.nums(main_target_units))
        return main_target_units, target_side, viewMainTargetPos
    end

    local func = find_target_types[key]
    local result, viewTargetPos = func(value, attacker, target_side)
    if skill_buff_info.id == 30044721 then
        --print("find_back_target_units:=======", skill_buff_info.id, target_side[1].no)
    end
    return result, target_side, viewTargetPos
end

function find_side(skill_buff_info)
    local target_role = skill_buff_info.effectRole
    if target_role == 1 then --enemy
        return process.enemy
    else
        return process.army
    end
end
function init_find_target_units(_process)
    process = _process
end
