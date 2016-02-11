import("..models.FindTargetUnits")
import("..models.FMExecuteSkill")

local BuffSetForView = import("..models.BuffSetForView")
local Buff = import("..models.FMBuff")
local FightProcess = class("FightProcess")

function FightProcess:ctor(send_message)
	self.send_message = send_message
    --动作数据类，可获取action.json和buff_action.json数据
    self.actionUtil = getActionUtil()	
    self.is_begin_action = nil -- 是否是起手动作
    init_find_target_units(self)
    self.small_step = 0 -- 1:before buff 攻击前清buff  2:begin action 起手动作 3:do buff 攻击 4:after buff 攻击后清buff

    self.red_units = {}--我方阵容
    self.blue_units = {}--敌方阵容
    self.red_unpara_skill = nil--我方无双
    self.blue_unpara_skill = nil--敌方无双
    self.buddy_skill = nil--小伙伴
    self.dropInfoTable = {}--掉落包
    --BaseTemplate.lua 获取基本信息
    self.baseTemplate = getTemplateManager():getBaseTemplate()
    --战斗数据对象
    self.fightData = getDataManager():getFightData()    
    --初始值
    self.red_step = 1--我方步数
    self.blue_step = 1--敌方步数
    self.current_red_round = 1--当前回合数
    self.current_blue_round = 1--当前回合数
    self.current_fight_times = 1--当前战斗回合数
    self.current_lose = "" -- 当前回合，输方:red or blue 用来显示轮数
    --最大战斗回合数
    self.fight_times_max = self.baseTemplate:getBaseInfoById("max_times_fight")
    --buff数据集合, 用于一次攻击的buff管理，用于View显示
    self.temp_buff_set = BuffSetForView.new(self)
    -- 玩家等级
    self.playerLevel = 0
    self.step_id = 0  -- 自增
    self.steps = {} -- 同步数据
    self.back_skill_buff = nil -- 保存反击buff
    self.current_skill_type = TYPE_NORMAL  -- 当前技能类型
    self.damage_rate = 0
    
    set_process(self)
end

function FightProcess:init(fight_type)
    cclog("FightProcess:init=====================>")
    createFile()
    self.fight_type = getDataManager():getFightData():getFightType()
    self.fight_type = fight_type
    self.dropNum = 3
    self.red_groups, self.blue_groups, self.red_unpara_skill, self.blue_unpara_skill, self.buddy_skill = initData(self)
    self.redAtkArray = self:get_atk_array(self.red_units, self.red_unpara_skill) -- 用来计算无双值
    print("==========redAtkArray", self.redAtkArray)
    self:init_round()
    self.red_units = self.red_groups[self.current_red_round]
    self.blue_units = self.blue_groups[self.current_blue_round]
    --总回合数
    self.max_red_round = table.nums(self.red_groups)
    self.max_blue_round = table.nums(self.blue_groups)
    self.blue_hp_total = self:get_blue_hp_total()
    self.red_hp_total = self:get_red_hp_total()
    self.round_to_kill_num = {}
    self.init_blue_units_num = table.nums(self.blue_groups[1])
    self.playerLevel=getDataManager():getCommonData():getLevel()
    self.best_skill_used_num = 0
    if self.fight_times_max == TYPE_ESCORT then
        self.fight_times_max = self.baseTemplate:getBaseInfoById("max_times_fight")
    end
    self:logInfo()
    -- self.red_unpara_skill.mp_step = 50
    -- self.buddy_skill.mp_step = 50
end

function FightProcess:get_atk_array(units, unpara_skill)
    local nos = unpara_skill:get_hero_nos()
    local atk_array = 0
    for k=1,6 do
        local v = units[k]
        if v then
            if table.inv(nos, v.origin_no) then
                print("*********", v:get_atk(), v.origin_no, v.no)
                atk_array = atk_array + v:get_atk()
            end
        end
    end
    return atk_array
end

function FightProcess:init_round()
    self.red_step = 1--我方步数
    self.blue_step = 1--敌方步数
    self.current_red_round = 1--当前回合数
    self.current_blue_round = 1--当前回合数
    self.current_fight_times = 1--当前战斗回合数
    self.small_step = 0 
    self.current_skill_type = TYPE_NORMAL
    self.back_skill_buff = nil
    self.step_id = 0
    self.steps = {}
    self.playerStep = 30
end

--执行开场技能
function FightProcess:perform_open_buff(attacker)
    print("perform_open_buff=============")
    for i,skill_buff_info in pairs(attacker.skill:get_open_skill_buffs()) do
        print("perform_open_buff:", attacker.no, self.attacker.no)
        local target_units, target_side, viewTargetPos = find_target_units(skill_buff_info)
        self:handle_skill_buff(target_side, target_units, skill_buff_info, viewTargetPos)
    end
end

--执行反击技能
function FightProcess:perform_back_skill(attacker, skill_buff_info, target)
    appendFile2("反击者-------------------\n", 0)
    appendFile2(attacker:str_data(), 0)
    --print("perform_back_skill=============", skill_buff_info.id)
    local target_units, target_side, viewTargetPos = find_back_target_units(skill_buff_info, target)
    --print("back_target_units:", table.nums(target_units), skill_buff_info.id, target_units[1].no)
    self:handle_skill_buff(target_side, target_units, skill_buff_info, viewTargetPos)
    return self:construct_step_action(attacker, TYPE_NORMAL, SKILL_STAGE_IN_BUFF, self.temp_buff_set.buffs)
end

--正常战斗
function FightProcess:perform_one_skill(army, enemy, attacker)
    print("FightProcess:perform_one_skill")
    self.army = army
    self.enemy = enemy
    self.attacker = attacker
    --local step_action = self:perform_one_skill(army, enemy, attacker)
    print("getTotalDamage============", self:get_total_damage(), self.blue_hp_total)
    local step_action = nil
    self:set_small_step()
    print("small_step:"..self.small_step)
    local small_step = self.small_step
    if small_step == STEP_BEFORE_BUFF then
        step_action = self:perform_before_buff(army, enemy, attacker)
    elseif small_step == STEP_BEGIN_ACTION then
        step_action = self:perform_begin_action(army, enemy, attacker)
    elseif small_step == STEP_DO_BUFF then
        step_action = self:perform_buff_skill(army, enemy, attacker)
    elseif small_step == STEP_AFTER_BUFF then
        step_action = self:perform_after_buff(army, enemy, attacker)
    end
    --self:logInfo()
    print("send_messsage=======", self.send_message)
    self.send_message(const.EVENT_ROUND_BEGIN, step_action)        
end

-- 攻击前buff
function FightProcess:perform_before_buff(army, enemy, attacker)
    print("FightProcess:perform_begin_action====================")
    local skill = attacker.skill
    -- 攻击前进行执行buff
    if skill:get_skill_type() == TYPE_NORMAL and (attacker.buff_manager and not attacker.buff_manager:is_dizzy()) then
        attacker.buff_manager:perform_hp_mp_buff(self) -- hp mp buff

        if not table.ink(army, attacker.pos) then
            return self:construct_step_action(attacker, TYPE_NORMAL, SKILL_STAGE_IN_BUFF, self.temp_buff_set.before_buffs)
        end
        attacker.buff_manager:perform_passive_buff(self) -- 被动buff
    end

    return self:construct_step_action(attacker, self:get_current_type(), SKILL_STAGE_IN_BUFF, self.temp_buff_set.before_buffs, STEP_BEFORE_BUFF)
end

-- 起手动作
function FightProcess:perform_begin_action(army, enemy, attacker)
    print("FightProcess:perform_begin_action====================")
    local skill = attacker.skill
    local is_mp_skill = skill:is_mp_skill()
    local step_action = self:construct_step_action(attacker, self:get_current_type(), SKILL_STAGE_IN_BUFF, self.temp_buff_set.before_buffs, STEP_BEGIN_ACTION)
    if attacker.buff_manager and attacker.buff_manager:is_dizzy() then
        step_action.beginAction = attacker.skill:get_begin_action(is_mp_skill)
    end
    return step_action
end


--正常战斗
function FightProcess:perform_buff_skill(army, enemy, attacker)
    local skill = attacker.skill
    local is_mp_skill = skill:is_mp_skill()
    --
    appendFile2("攻击者-------------------\n", 0)
    appendFile2(attacker:str_data(), 0)
    --if attacker.no == 30063 then
        --print("刘邦：", )
    --end
    attacker.attacker_side = army    
    self.attacker = attacker
    self.army = army
    self.enemy = enemy
    --"""执行技能：普通技能或者怒气技能"""
    print("-----------perform_one_skill----------------")
    local attacker = self.attacker
    print("enemy ++++++++")
    print(attacker.no, attacker.buff_manager:is_dizzy())
    
    if is_mp_skill then
        skill:clear_mp()
    end
    main_skill_buff = skill:main_skill_buff(is_mp_skill)
    print("main_skill_buff", main_skill_buff)

    if attacker.buff_manager:is_dizzy() then
        --logger_cal.debug("    攻击者在buff中，无法攻击！")
        print("1===========")
        appendFile2("\t\t dizzy=====", 0)
        --if attacker.buff_manager then
            --attacker.buff_manager:perform_active_buff(self)
        --end
        --appendFile2("\t\t dizzy=====1", 0)
        return self:construct_step_action(attacker, TYPE_NORMAL, SKILL_STAGE_IN_BUFF, {}, STEP_DO_BUFF)
    end

    print("2===========")
    print("main skill buff +++++++++")
    -- table.print(main_skill_buff)

    local main_target_units, main_target_side, viewMainTargetPos = find_target_units(main_skill_buff)  -- 主技能作用目标

    print("main target units+++++"..viewMainTargetPos)
    print(table.nums(main_target_units))

    if table.nums(main_target_units) == 0 then
        print("3===========")
        self:perform_one_step()
        return nil        
    end
    local main_target_unit_infos = {}
    
    -- 1.计算命中, 格挡
    for i=1,6 do
        local target_unit = main_target_units[i]
        if target_unit then
            is_block = check_block(attacker, target_unit, main_skill_buff)
            is_hit = check_hit(main_skill_buff, attacker, target_unit) 
            table.insert(main_target_unit_infos, {target_unit, is_block, is_hit})
            skill:set_after_skill_buffs(is_hit, is_mp_skill)
            local back_buff_infos = target_unit.skill:get_back_skill_buffs(is_hit, is_block)
            for i,v in pairs(back_buff_infos) do
                print("back_buff_infos============"..v.id)
                if v and check_trigger(v) then
                    local result = {}
                    result.army = enemy
                    result.enemy = army
                    result.attacker = target_unit
                    result.skill_buff_info = v 
                    self.back_skill_buff = result
                    break
                end
            end
        end
    end
    -- 2.主技能释放前，触发的buff
    print("before_skill_buffs+++++")
    -- table.print(skill:get_before_skill_buffs())
    for _, skill_buff_info in pairs(skill:get_before_skill_buffs()) do
        self:before_or_after_skill(skill_buff_info, main_target_units)
    end

    -- 3.触发攻击技能
    print("attack_skill_buffs+++++")
    -- table.print(skill:attack_skill_buffs(is_mp_skill))
    for _, skill_buff_info in pairs(skill:attack_skill_buffs(is_mp_skill)) do
        local temp_buff = {}
        if skill_buff_info.skill_key == 1 then
            self:handle_main_skill_buff(main_target_side, main_target_unit_infos, skill_buff_info, viewMainTargetPos)
        else
            target_units, target_side, viewTargetPos = find_target_units(skill_buff_info, main_target_units, nil, viewMainTargetPos)
            self:handle_skill_buff(target_side, target_units, skill_buff_info, viewTargetPos)
        end
    end

    -- 4.主技能释放后，触发的buff
    print("after_skill_buffs+++++")
    for _, skill_buff_info in pairs(skill:get_after_skill_buffs()) do
        self:before_or_after_skill(skill_buff_info, main_target_units, viewMainTargetPos)
    end

    -- 移除triggerType==11的buff
    for i=1,6 do
        local target_unit = main_target_units[i]
        if target_unit then
            target_unit.buff_manager:remove(11)
        end
    end
    skill:clear()
    -- 在攻击技能触发完成后，处理mp
    --if self.current_skill_type == TYPE_NORMAL then
        --skill:add_mp(is_mp_skill)
    --end

    if self.current_skill_type == TYPE_NORMAL then
        skill:add_mp(is_mp_skill)
        self.red_unpara_skill:add_mp()
        self.blue_unpara_skill:add_mp()
    end
    if attacker.side == "blue" and self.buddy_skill and self.current_skill_type == TYPE_NORMAL then  --小伙伴被攻击则增加怒气
        self.buddy_skill:add_mp()
        print("buddy_skills1===="..self.buddy_skill.mp)
    end



    -- 构造播放攻击所需的所有信息
    local skillType = skill:get_skill_type()
    print("skillType========"..skillType)

    if self.back_skill_buff and not table.ink(target_side, self.back_skill_buff.attacker.no) then
        -- 如果反击武将已死，则清空反击技能
        self.back_skill_buff = nil
    end

    return self:construct_step_action(attacker, self:get_current_type(), SKILL_STAGE_IN_BUFF, self.temp_buff_set.buffs, STEP_DO_BUFF)
end

-- 攻击后buff
function FightProcess:perform_after_buff(army, enemy, attacker)
    appendFile2("FightProcess:perform_after_buff", 0)
    -- 攻击后进行执行buff
    if attacker.buff_manager and not attacker.buff_manager:is_dizzy() then
        attacker.buff_manager:perform_active_buff(self)   --主动buff，在攻击有效后触发
    end
    return self:construct_step_action(attacker, self:get_current_type(), SKILL_STAGE_IN_BUFF, self.temp_buff_set.after_buffs, STEP_AFTER_BUFF)
end

function FightProcess:construct_step_action(attacker, skillType, skillStage, buffs, skillSmallStep)
    local step_action = {skillType = skillType, skillStage = skillStage, skillSmallStep = skillSmallStep, buffs = buffs}
    --step_action.buffs = self.temp_buff_set.buffs
    --step_action.before_buffs = self.temp_buff_set.before_buffs
    --step_action.after_buffs = self.temp_buff_set.after_buffs
    step_action.before_buffs = {}
    step_action.after_buffs = {}
    step_action.attacker = attacker
    self.temp_buff_set:clear()
    print("FightProcess:construct_step_action=======")
    return step_action
end

function FightProcess:before_or_after_skill(skill_buff_info, main_target_units, viewMainTargetPos)
    -- body
    target_units, target_side, viewTargetPos = find_target_units(skill_buff_info, main_target_units, viewMainTargetPos)
    self:handle_skill_buff(target_side, target_units, skill_buff_info, viewTargetPos)
end
-- 处理buff
function FightProcess:handle_skill_buff(target_side, target_units, skill_buff_info, viewTargetPos)
    print("FightProcess:handle_skill_buff")
    print("trigger1=========", skill_buff_info.id)
    appendFile2("trigger1========="..tostring(skill_buff_info.id), 0)
    self.temp_buff_set:add(skill_buff_info, viewTargetPos)
    local is_trigger = check_trigger(skill_buff_info)
    if not is_trigger then
        return
    end
    print("trigger=========", skill_buff_info.id)
    for _, target_unit in pairs(target_units) do
        if target_unit.hp > 0 then
            local result = self.temp_buff_set:add_data(target_unit) -- add data for view
            local buff = Buff.new(target_side, skill_buff_info, self)
            target_unit.buff_manager:add(buff, result)
        end
    end
end
-- 处理主技能
function FightProcess:handle_main_skill_buff(target_side, main_target_unit_infos, skill_buff_info, viewTargetPos)
    print("FightProcess:handle_main_skill_buff")
    self.temp_buff_set:add(skill_buff_info, viewTargetPos)
    local temp_buff = {}
    local target_infos = {}
    for _, target_info in pairs(main_target_unit_infos) do
        local target_unit = target_info[1]
        local result = self.temp_buff_set:add_data(target_unit)
        result.is_hit = target_info[3] -- 判定命中
        result.is_block = target_info[2] -- 判定格挡
        
        local buff = Buff.new(target_side, skill_buff_info, self)
        target_unit.buff_manager:add(buff, result)
    end
end

function FightProcess:getActions(skill_buff_info)
    if skill_buff_info.actEffect ~= 0 then
        return self.actionUtil.buffdata[string.format(skill_buff_info.actEffect)].actions
    end
    return {}
end

function FightProcess:set_small_step()
    self.small_step = self.small_step + 1
    print("set_small_step:"..self.small_step)
end

-- 下一轮数据
function FightProcess:next_round()
    if self.current_lose == "red" and self.current_red_round ~= self.max_red_round then
        self.current_red_round = self.current_red_round + 1
    end
    if self.current_lose == "blue" and self.current_blue_round ~= self.max_blue_round then
        self.current_blue_round = self.current_blue_round + 1
    end
    if self.fight_type ~= TYPE_ESCORT then
        self.current_fight_times = 1
    end
    self.red_step = 1
    self.blue_step = 1
    self.small_step = 0

    self.red_units = self.red_groups[self.current_red_round]
    self.blue_units = self.blue_groups[self.current_blue_round]

    -- 重置我方数据
    for _,v in pairs(self.red_units) do
        if self.fight_type ~= TYPE_ESCORT then
            v:reset()
        end
    end
end

--function FightProcess:perform_open_buff()
    --cclog("FightProcess:perform_open_buff begin========>")
    --local red_actions = self:update_open_state(self.red_units, self.blue_units)
    --local blue_actions = self:update_open_state(self.blue_units, self.red_units)
    --local data = {red_actions=red_actions, blue_actions=blue_actions}
    --self:send_message(data)

--end

-- 我方开场buff
function FightProcess:update_open_state_red()
    return self:update_open_state(self.red_units, self.blue_units)
end

-- 敌方开场buff
function FightProcess:update_open_state_blue()
    return self:update_open_state(self.blue_units, self.red_units)
end

function FightProcess:update_open_state(army, enemy)
    self.army = army
    self.enemy = enemy
    for i=1,6 do
        local v = army[i]
        if v then
            self.attacker = v
            self:perform_open_buff(v)
            for i,buff in pairs(self.temp_buff_set.buffs) do
                print("attacker======:", buff.attacker, buff.attacker.no)
            end
            print("attacker.HOME", self.attacker.HOME, self.attacker.no)
        end
    end
    local step_action = self:construct_step_action(nil, TYPE_NORMAL, SKILL_STAGE_OPEN, self.temp_buff_set.buffs)
    return step_action
end

function FightProcess:perform_open_skill()
    cclog("FCProcess:perform_open_skill begin========>")
    local red_actions = self:update_open_state_red()
    local blue_actions = self:update_open_state_blue()
    local data = {red_actions=red_actions, blue_actions=blue_actions}
    self.send_message(const.EVENT_FIGHT_BEFORE_BUFF, data)
end

--function FightProcess:send_message(step_action)
    --if step_action then
        --print("FightProcess:send_message===========>")
        ---- self:dispatchEvent(const.EVENT_ROUND_BEGIN, step_action)
        --self:dispatchEvent(const.EVENT_FIGHT_BEFORE_BUFF, step_action)        
    --end
--end

-- 判断是否是最后一轮
function FightProcess:is_last_round()
    return self.max_blue_round == self.current_blue_round
end

-- 检查当前回合结果
function FightProcess:check_result()
    --阵亡或战斗回合达到最大值则输
    print("red_units:",table.nums(self.red_units),"blue_units:",table.nums(self.blue_units))
    -- if table.nums(self.red_units) == 0 then
    if table.nums(self.red_units) == 0 or self.current_fight_times > self.fight_times_max then
        self:logInfo()
        appendFile2("lose========"..self.current_fight_times.."=="..self.fight_times_max, 0)
        self.current_lose = "red"
        return -1 -- lose
    elseif table.nums(self.blue_units) == 0 then
        self:logInfo()
        appendFile2("win========", 0)
        self.current_lose = "blue"
        return 1 -- win
    else
        return 0 -- continue
    end
end

function FightProcess:check_final_result(result)
    if result == -1 and self.max_red_round == self.current_red_round then
        return -1
    elseif result == 1 and self.max_blue_round == self.current_blue_round then
        return 1
    else
        return 0
    end
end

--执行一步，即一个战斗动作
function FightProcess:perform_one_step()
    appendFile2("perform one step=============="..self.step_id)
    cclog("FightProcess:perform_one_step=================>".."skill_type:"..self.current_skill_type.."small_step:"..self.small_step.."red_step:"..self.red_step.."blue_step:"..self.blue_step)
    self:set_step()
    --获取回合结果
    local result = self:check_result()
    --如果战斗结束则发送结束消息
    if result == 1 or result == -1 then
        -- 战斗结束，发送结果
        print("lose============")
        self.send_message(const.EVENT_FIGHT_RESULT, self:check_final_result(result))
        return 
    end
    self.step_id = self.step_id + 1
    --如果可以执行反击buff，则先执行反击buff
    if self.current_skill_type == TYPE_BACK then
        self:perform_back_buff() 
    elseif self.current_skill_type == TYPE_BUDDY then
        self:do_buddy_skill()
    elseif self.current_skill_type == TYPE_RED_UNPARAL then
        self:do_unpara_skill()
    elseif self.current_skill_type == TYPE_BLUE_UNPARAL then
        self:do_unpara_skill()
    elseif self.current_skill_type == TYPE_NORMAL then
        self:do_normal_skill()
    end    
    --如果可以执行小伙伴技能，则先执行小伙伴
    --if self:do_buddy_skill() then return end    
    --如果可以执行无双技能，则先执行无双
    --if self:do_unpara_skill() then return end

end

function FightProcess:do_normal_skill()
    print("do_normal_skill==================", self.red_step, self.blue_step, table.nums(self.blue_units), self.blue_units)
    local attack_units = nil--攻击阵容
    local defend_units = nil--防御阵容
    local who_step = nil--攻击者位置
    --我方回合
    if self.red_step == self.blue_step then
        attack_units = self.red_units
        defend_units = self.blue_units
        who_step = self.red_step
    else
    --敌方回合
        attack_units = self.blue_units
        defend_units = self.red_units
        who_step = self.blue_step      
    end
    --获取攻击者
    local attacker = attack_units[who_step]
    --如存在则执行技能，否则执行下一步
    if attacker then
        print("attacker is not nil")
        self:perform_one_skill(attack_units, defend_units, attacker)
    else
        self:set_normal_step()
        print("attacker is nil")
        self:perform_one_step()
        return
    end
    if self.small_step == STEP_AFTER_BUFF then
        self:set_normal_step()
    end
end


--计步器
function FightProcess:set_step()
    print("set_step===========", self.red_unpara_skill.mp)
    print("set_step===========", self.blue_unpara_skill.mp)
    if self:is_current_skill_end() then
        print("is_current_skill_end=============")
        print(self.red_unpara_skill:is_ready())
        if self.back_skill_buff then
            print("change to back")
            self.current_skill_type = TYPE_BACK
        elseif self.red_unpara_skill:is_ready() then
            print("change to red_unpara_skill")
            self.current_skill_type = TYPE_RED_UNPARAL
        elseif self.blue_unpara_skill:is_ready() then
            print("change to blue_unpara_skill")
            self.current_skill_type = TYPE_BLUE_UNPARAL
        elseif self.buddy_skill and self.buddy_skill:is_ready() then
            print("change to buddy_skill")
            self.current_skill_type = TYPE_BUDDY
        else
            print("change to normal")
            self.current_skill_type = TYPE_NORMAL
        end
    end
end

function FightProcess:is_current_skill_end()
    -- 是否当前技能结束
    
    if self.current_skill_type == TYPE_BACK and not self.back_skill_buff then
        print("is_current_skill_end======back")
        return true
    end
    if self.current_skill_type == TYPE_NORMAL and self.small_step == 0 then
        print("is_current_skill_end======normal")
        return true
    end
    if self.current_skill_type == TYPE_RED_UNPARAL and self.small_step == 0 then
        print("is_current_skill_end======red_unpara")
        return true
    end
    if self.current_skill_type == TYPE_BLUE_UNPARAL and self.small_step == 0 then
        print("is_current_skill_end======blue_unpara")
        return true
    end
    if self.current_skill_type == TYPE_BUDDY and self.small_step == 0 then
        print("is_current_skill_end======buddy")
        return true
    end
    return false
end


function FightProcess:set_normal_step()
    self.small_step = 0
    print("set_normal_step===", self.red_step, self.blue_step)

    if self.red_step == self.blue_step then
        self.red_step = self.red_step + 1
    else
        self.blue_step = self.blue_step + 1
    end
    if self.red_step == 7 and self.blue_step == 7 then
        if self.round_to_kill_num[self.current_fight_times] == nil then
            print("FightProcess:set_step=======>next round"..tostring(self.init_blue_units_num - table.nums(self.blue_groups[1])))
            self.round_to_kill_num[self.current_fight_times] = self.init_blue_units_num - table.nums(self.blue_groups[1])
        end
        self.current_fight_times = self.current_fight_times + 1
        appendFile2("current_fight_times:"..self.current_fight_times, 0)
        self.red_step = 1 
        self.blue_step = 1 
    end
end


--处理反击相关的buff
function FightProcess:perform_back_buff()
    print("FightProcess:perform_back_buff=============")
    local v = self.back_skill_buff
    if not v then return false end

    local army = v["army"]
    local enemy = v["enemy"]
    local attacker = v["attacker"]
    local target = v["target"]
    --print("perform_back_buff1====", army[1].no, attacker.no)
    --print("perform_back_buff1====", enemy[1].no, attacker.no)
    self.army = army
    self.enemy = enemy
    self.attacker = attacker
    if table.ink(army, attacker.pos) and v then
        local step_action = self:perform_back_skill(attacker, v["skill_buff_info"], target)
        if step_action then
            self.send_message(const.EVENT_ROUND_BEGIN, step_action)        
        end
    end
    self.back_skill_buff = nil
    self.small_step = 0
    return true
end

--获取所有技能no，用于预加载动画
function FightProcess:get_all_skill_nos()
    local skill_nos = {}
    for _, v in pairs(self.red_units) do
        table.insert(skill_nos, v.unit_info.normalSkill) -- 普通技能
        table.insert(skill_nos, v.unit_info.rageSkill)-- 怒气技能
        table.insertTo(skill_nos, v:get_break_skill_nos())-- 突破技能
    end
    for _,_v in pairs(self.blue_groups) do
        for _, v in pairs(_v) do
            table.insert(skill_nos, v.unit_info.normalSkill)
            table.insert(skill_nos, v.unit_info.rageSkill)
            table.insertTo(skill_nos, v:get_break_skill_nos())
        end
    end
    table.insertTo(skill_nos, self.red_unpara_skill:get_skill_nos())
    table.insertTo(skill_nos, self.blue_unpara_skill:get_skill_nos())
    if self.buddy_skill then
        table.insertTo(skill_nos,self.buddy_skill:get_skill_nos())
    end
    return skill_nos
end

-- 执行无双
function FightProcess:do_unpara_skill()
    --if self.red_unpara_skill:is_ready() and self.small_step ~= 1  then return false end
    print("do_unpara_skill==============", self.current_skill_type, self.small_step)
    
    local skill = nil
    local isDone = false
    local attacker = nil
    local attack_units = nil
    local defend_units = nil


    if self.current_skill_type == TYPE_RED_UNPARAL then
        isDone = true
        skill = self.red_unpara_skill
        attack_units = self.red_units
        defend_units = self.blue_units        
    elseif self.current_skill_type == TYPE_BLUE_UNPARAL then
        isDone = true
        skill = self.blue_unpara_skill
        attack_units = self.blue_units
        defend_units = self.red_units                        
    end

    if isDone then
        local attacker = skill:construct_attacker()
        self:perform_one_skill(attack_units, defend_units, attacker)
        skill:reset()
    end
    if self.small_step == STEP_BEFORE_BUFF then
        local stepData = {}
        stepData.step_id = self.step_id
        stepData.step_type = self:get_current_type()
        table.insert(self.steps, stepData)
    end
    if self.small_step == STEP_DO_BUFF then
        self.small_step = 0
    end

    return isDone
end

-- 执行小伙伴
function FightProcess:do_buddy_skill()
    if self.current_skill_type == TYPE_BUDDY then
        print("do_buddy_skill============")
        local attacker = self.buddy_skill.unit
        attacker.skill = self.buddy_skill
        attacker.side = "red"
        attacker.viewPos = BUDDY_SEAT
        attacker.pos = 5
        attacker.HOME = const.HOME_ARMY[BUDDY_SEAT]
        self:perform_one_skill(self.red_units, self.blue_units, attacker)
        --self.buddy_skill:reset()
        -- 保存数据用于与服务器同步
        if self.small_step == STEP_AFTER_BUFF then
            self.small_step = 0
        end
        if self.small_step == STEP_BEFORE_BUFF then
            local stepData = {}
            stepData.step_id = self.step_id
            stepData.step_type = self:get_current_type()
            table.insert(self.steps, stepData)
        end
        return true
    end
    return false
end

function FightProcess:logInfo()
    appendFile2("我方:----------\n", 0)
    for i=1,6 do
        local v = self.red_units[i]
        if v then
            appendFile2(v:str_data(), 0)
        end
    end
    appendFile2("敌方:----------\n", 0)
    for i=1,6 do
        local v = self.blue_units[i]
        if v then
            appendFile2(v:str_data(), 0)
        end
    end
    appendFile2(""..self.max_blue_round.."=="..self.current_blue_round.."回合＝＝＝＝＝＝＝", 0)
end

function FightProcess:get_blue_hp_total()
    local total = 0
    for _,v in pairs(self.blue_groups) do
        for _,unit in pairs(v) do
            total = total + unit.hp
        end
    end
    return total
end

function FightProcess:get_red_hp_total()
    local total = 0
    for _, unit in pairs(self.red_units) do
        total = total + unit.hp
    end
    return total
end

-- 累计伤害
function FightProcess:get_total_damage()
    local left = 0
    for _,v in pairs(self.blue_groups) do
        for _,unit in pairs(v) do
            left = left + unit.hp
        end
    end
    return self.blue_hp_total - left
end
--
-- 获取乱入unit
function FightProcess:get_replace()
    for k,v in pairs(self.red_units) do
        if v.is_break then
            return v
        end
    end
    return nil
end

-- 我方剩余血量
function FightProcess:get_red_units_left_hp()
    local left = 0
    for _,unit in pairs(self.red_units) do
        left = left + unit.hp
    end
    return left
end

function FightProcess:is_last_hero_dead(target_unit)
    --不是最后一轮
    if not self:is_last_round() then return false end

    -- local _quality = target_unit.unit_info.quality
    --品级不正确
    -- if _quality ~= 5 and _quality ~= 6 then return false end

    local units = nil
    
    if target_unit.side == "red" then
        units = self.red_units
    else
        units = self.blue_units
    end
    if table.nums(units) > 0 then return false end
    if table.nums(units) == 0 then return true end
    return false
end

function FightProcess:get_current_type()
    if self.current_skill_type == TYPE_RED_UNPARAL or self.current_skill_type == TYPE_BLUE_UNPARAL then
        return TYPE_UNPARAL
    end
    return self.current_skill_type
end
return FightProcess
