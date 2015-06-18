local s1 = 2.0
local s2 = 3.0
require("math")

function set_seed(x1, x2)
    s1 = x1
    s2 = x2
    s1 = math.random(os.time())
    s2 = math.random(os.time())
end

function get_random_int(_begin, _end)
    -- 获取随机数，从begin到end
    s1 = math.random(os.time())
    s2 = math.random(os.time())
    s1, s2, ran = rnd(s1, s2)
    x = (_end - _begin) * ran + _begin
    return math.floor(x)
end

function get_random_lst(lst, n)
    -- 获取随机数列表，从begin到end
    local len = table.nums(lst)
    if len <= n then
        return lst
    end
    local keys = {}
    while table.nums(keys) ~= n do 
        x = get_random_int(1, table.nums(lst))
        if not table.inv(keys, x) then
            table.insert(keys, x)
        end
    end
    return keys
end

function get_fight_mode(fight_type)
--TYPE_GUIDE = 0              --演示关卡
--TYPE_STAGE_NORMAL = 1       -- 普通关卡（剧情）， stage_config
--TYPE_STAGE_ELITE = 2        -- 精英关卡， special_stage_config
--TYPE_STAGE_ACTIVITY = 3     -- 活动关卡， special_stage_config
--TYPE_TRAVEL         = 4     --travel

--TYPE_PVP            = 6     --pvp

--TYPE_WORLD_BOSS     = 7     --世界boss

--TYPE_MINE_MONSTER           = 8       -- 攻占也怪
--TYPE_MINE_OTHERUSER         = 9       -- 攻占其他玩家
    if fight_type == TYPE_GUIDE or fight_type == TYPE_PVP or fight_type == TYPE_MINE_OTHERUSER then
        return TYPE_MODE_PVP
    else
        return TYPE_MODE_PVE
    end
end