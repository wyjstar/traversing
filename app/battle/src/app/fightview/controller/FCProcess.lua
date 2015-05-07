--战斗数据层
require("src.app.fightview.controller.InitData")
local FightProcess = import(".zhengpu_process")
local FCProcess = class("FCProcess", mvc.ModelBase)

function FCProcess:ctor(id)
    self.id = id
    --self.red_units = {}--我方阵容
    --self.blue_units = {}--敌方阵容
    --self.red_unpara_skill = nil--我方无双
    --self.blue_unpara_skill = nil--敌方无双
    --self.buddy_skill = nil--小伙伴
    self.dropInfoTable = {}--掉落包
    ----BaseTemplate.lua 获取基本信息
    --self.baseTemplate = getTemplateManager():getBaseTemplate()
    ----战斗数据对象
    --self.fightData = getDataManager():getFightData()    
    ----初始值
    --self.red_step = 1--我方步数
    --self.blue_step = 1--敌方步数
    --self.current_round = 1--当前回合数
    --self.current_fight_times = 1--当前战斗回合数
    ----最大战斗回合数
    --self.fight_times_max = self.baseTemplate:getBaseInfoById("max_times_fight")
    --战斗逻辑
    self.fightProcess = FightProcess.new(handler(self, self.send_message))
    --已掉落
    self.hadDropNum = 0
    --掉落数量    
    self.dropNum = 0
end
--不再监听消息，直接调用此类方法
function FCProcess:onMVCEnter()
end

-- 初始化数据，测试阶段目前为假值
function FCProcess:init()
    cclog("FCProcess:init=====================>")
    self.fight_type = getDataManager():getFightData():getFightType()
    self.fight_type = TYPE_GUIDE
    self.fightProcess:init(self.fight_type)

    self.dropNum = 3
    --self.red_units, self.blue_groups, self.red_unpara_skill, self.blue_unpara_skill, self.buddy_skill = initData(self)
    --self.blue_units = self.blue_groups[self.current_round]
    ----总回合数
    --self.max_round = table.nums(self.blue_groups)
    --self.blue_hp_total = self:get_blue_hp_total()

    if self.fight_type ~= TYPE_WORLD_BOSS and self.fight_type ~= TYPE_GUIDE then
        self:initDrop()
    end
    --self.back_skill_buff = nil -- 保存反击buff
end

-- 下一轮数据
function FCProcess:next_round()
    self.fightProcess:next_round()
end

function FCProcess:perform_open_skill()
    cclog("FCProcess:perform_open_skill begin========>")
    local red_actions = self.fightProcess:update_open_state_red()
    local blue_actions = self.fightProcess:update_open_state_blue()
    local data = {red_actions=red_actions, blue_actions=blue_actions}
    self:send_message(const.EVENT_FIGHT_BEFORE_BUFF, data)
end

function FCProcess:send_message(key, data)
    if data then
        print("FCProcess:send_message===========>")
        -- self:dispatchEvent(const.EVENT_ROUND_BEGIN, step_action)
        self:dispatchEvent(key, data)        
    end
end

-- 判断是否是最后一轮
function FCProcess:is_last_round()
    return self.max_round == self.current_round
end

-- 检查当前回合结果
function FCProcess:check_result()
    --阵亡或战斗回合达到最大值则输
    return self.fightProcess:check_result()
end
--
--执行一步，即一个战斗动作
function FCProcess:perform_one_step()
    return self.fightProcess:perform_one_step()
end
--

--获取所有技能no，用于预加载动画
function FCProcess:get_all_skill_nos()
    return self.fightProcess:get_all_skill_nos()
end

-- 攻击后 显示掉血等效果
function FCProcess:afterAttackDisplay(buff)
    print("-- 攻击后 显示掉血等效果")
    print("FCProcess:afterAttackDisplay",table.nums(self.red_units),table.nums(self.blue_units),"buffid:",buff.buff_info.id)
    local endCount = 0
    for k, target_info in pairs(buff.target_infos) do
        local target_unit = target_info.target_unit
        print("=======>target_infos:",k,target_unit.hp)
    -- local i = 0
    -- for i = 1 , #buff.target_infos do
    --     local target_info = buff.target_infos[i]
        
        if target_unit:is_dead()  then --如果死亡，播放死亡动画
            endCount = endCount + 1
            self:dispatchEvent(const.EVENT_DEAD_ITEM, target_unit.viewPos)
            --死亡特效
            local isplay = self:isLastHeroDead(target_unit)
            self:dispatchEvent(const.EVENT_PLAY_DEAD_ANI, target_unit, isplay)
            --处理掉落包
            if target_unit.side == "blue" then
                local drop = self:getDropNum(target_unit.pos)
                if drop > 0 then
                    self.hadDropNum = self.hadDropNum + drop
                    self:dispatchEvent(const.EVENT_PLAY_DROPPING, target_unit.HOME.point)                     
                end                
            end
            -- 删除死亡武将
            --self:removeDeadUnit(target_unit)
            -- i = i - 1
        end
    end
end

function FCProcess:removeDeadUnit(target_unit)
    print("begin removeDeadUnit=============="..target_unit.pos.."====="..target_unit.no.."side:"..target_unit.side,table.getn(self.red_units),table.getn(self.blue_units))
    if target_unit.side == "red" then
        
        -- for k = 1, #self.red_units do 
        --     print(self.red_units[k].pos)
        -- end

        self.red_units = table.removeItem(self.red_units, target_unit.pos)
    elseif target_unit.side == "blue" then
        self.blue_units = table.removeItem(self.blue_units, target_unit.pos)
    end
    print("end removeDeadUnit=============="..target_unit.pos.."====="..target_unit.no.."side:"..target_unit.side,table.getn(self.red_units),table.getn(self.blue_units))
end

function FCProcess:isLastHeroDead(target_unit)
    return self.fightProcess:is_last_hero_dead(target_unit)
end

function FCProcess:get_red_unpara_value()
    return self.fightProcess.red_unpara_skill.mp
end

function FCProcess:getBuddyValue()
    if not self.fightProcess.buddy_skill then
        return 0
    end
    return self.fightProcess.buddy_skill.mp
end

-- 获取乱入unit
function FCProcess:getReplace()
    return self.fightProcess:get_replace()
end

-- 获取小伙伴
function FCProcess:getBuddySkill()
    return self.fightProcess.buddy_skill
end

-- 获取我方无双
function FCProcess:getRedUnparaSkill()
    return self.fightProcess.red_unpara_skill
end

-- 获取敌方无双
function FCProcess:getBlueUnparaSkill()
    return self.fightProcess.blue_unpara_skill
end

-- 最大回合（怪物组）
function FCProcess:getMaxRound()
    return self.fightProcess.max_round
end

-- 当前回合（怪物组）
function FCProcess:getCurrentRound()
    return self.fightProcess.current_round
end

-- 最大回合（怪物组）
function FCProcess:getMaxRound()
    return self.fightProcess.max_round
end

-- 当前战斗次数(所有卡牌打完算一次）
function FCProcess:getCurrentFightTimes()
    return self.fightProcess.current_fight_times
end
-- 战斗Max次数(所有卡牌打完算一次）
function FCProcess:getFightTimesMax()
    return self.fightProcess.fight_times_max
end

function FCProcess:getRedUnits()
    return self.fightProcess.red_units
end

function FCProcess:getBlueUnits()
    return self.fightProcess.blue_units
end

-- 点击无双
function FCProcess:doUnparaSkill()
    if self.fightProcess.red_unpara_skill:is_can() then
        self.fightProcess.red_unpara_skill.ready = true
    end
end
-- 点击小伙伴
function FCProcess:doBuddySkill()
    print("doBuddySkill==========")
    print(self.fightProcess.buddy_skill:is_full())
    if self.fightProcess.buddy_skill:is_full() then
        self.fightProcess.buddy_skill.ready = true
        if self.fightProcess.attacker.side == "blue" and self.fightProcess.small_step == STEP_BEGIN_ACTION then
            -- 小伙伴打断怒气技能, 跳到下一步
            self.fightProcess.small_step = STEP_DO_BUFF
        end
    end
end

function FCProcess:initDrop()
    if self.dropNum == nil or self.dropNum == 0 then
        return
    end
    local maxGroup = self.max_round
    local grounInfoTable = {}
    for i = 1, maxGroup do
        grounInfoTable[i] = 0
    end
    --先把掉落数随机分配到各回合
    for i = 1, self.dropNum do
        local tempData = math.random(1, maxGroup)
        grounInfoTable[tempData] = grounInfoTable[tempData] + 1
    end
    --随机分配每回合掉落数
    for i = 1, maxGroup do
        self.dropInfoTable[i] = {}
        --每轮敌人个数
        local units = self.blue_groups[i]
        local groupNum = #units
        local item = grounInfoTable[i]
        if item > 0 then
            for j = 1, item do
                while true do
                    local pos = math.random(1, groupNum)
                    local enemy = units[pos]
                    if enemy ~= nil then
                        local seat = enemy.pos
                        if self.dropInfoTable[i][pos] then
                            if item > groupNum then --如果已分配并且掉落数大于人数，则一个人掉多个，否则再此循环，存在每回合分配不均时造成掉落多个
                                self.dropInfoTable[i][pos].dropNum = self.dropInfoTable[i][pos].dropNum + 1
                                break                         
                            end                        
                        else
                            self.dropInfoTable[i][pos] = {seat = seat, dropNum = 1}
                            break                        
                        end
                    end
                end
            end
        end
    end  
end
--根据seat获得掉落的数量
function FCProcess:getDropNum(seat)
    local item = self.dropInfoTable[self.currentRound]
    if item then
        for k, v in pairs(item) do
            if v.seat == seat then
                return v.dropNum
            end
        end
    end
    return 0
end

function FCProcess:getHadDropNum()
    return self.hadDropNum
end

function FCProcess:get_blue_hp_total()
    return self.fightProcess:get_blue_hp_total()
    --local total = 0
    --for _,v in pairs(self.blue_groups) do
        --for _,unit in pairs(v) do
            --total = total + unit.hp_begin
        --end
    --end
    --return total
end

-- 累计伤害
function FCProcess:getTotalDamage()
    --local left = 0
    --for _,v in pairs(self.blue_groups) do
        --for _,unit in pairs(v) do
            --left = left + unit.hp_begin
        --end
    --end
    --return self.blue_hp_total - left
    return self.fightProcess:get_total_damage()
end


return FCProcess
