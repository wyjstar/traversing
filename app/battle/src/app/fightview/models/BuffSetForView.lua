--buff数据集合, 用于一次攻击的buff管理，用于View显示
--
local BuffSetForView = class("BuffSetForView")

function BuffSetForView:ctor(process)
    self.buffs = {} -- 攻击buff
    self.before_buffs = {} -- 被击者身上的buff: 攻击前清buff
    self.after_buffs = {} -- 被击者身上的buff: 攻击后清buff
    self.open_stage_buffs = {} -- 开场buff
    self.actionUtil = getActionUtil()	
    self.process = process
end

-- add buff
function BuffSetForView:add(buff_info, viewTargetPos)
    local temp_buff = {}
    temp_buff.buff_info = buff_info
    temp_buff.target_infos = {}
    temp_buff.viewTargetPos = viewTargetPos
    temp_buff.actions = self:getActions(buff_info)
    temp_buff.attacker = self.process.attacker
    table.insert(self.buffs, temp_buff)
end

-- 添加before buff
function BuffSetForView:add_before_buff(target_unit, buff, value)
    self:add_on_buff_util(target_unit, buff, value, self.before_buffs)
end
-- 添加after buff
function BuffSetForView:add_after_buff(target_unit, buff, value)
    self:add_on_buff_util(target_unit, buff, value, self.after_buffs)
end

function BuffSetForView:add_on_buff_util(target_unit, buff, value, buff_group)
    local temp = {}
    --temp.target_unit = target_unit
    temp.buff_info = buff.skill_buff_info
    local target_info = {}
    target_info.target_unit = target_unit
    target_info.value = value
    target_info.is_hit = true
    temp.target_infos = {target_info}

    temp.continue_num = buff.continue_num
    --temp.value = value
    temp.viewTargetPos = TYPE_NORMAL_POS
    temp.actions = self:getActions(buff.skill_buff_info)
    temp.attacker = self.process.attacker
    table.insert(buff_group, temp)
end

function BuffSetForView:str_data(buff_group)
    print("BuffSetForView:str_data====")
    for i,v in pairs(buff_group) do
        print("buff_id", v.buff_info.id)
        target_info = v.target_infos[1]
        print("target_no", target_info.value, target_info.target_unit.no)
        print("continue_num", v.continue_num)
    end
end

-- 添加buff data
function BuffSetForView:add_data(target_unit)
    local temp = {
        ["is_hit"] = nil,
        ["is_cri"] = false,
        ["is_block"] = false,
        ["value"] = 0,
        ["extra_msgs"] = {},
        ["target_unit"]=target_unit}
    local lastBuff = table.getLastItem(self.buffs)
    table.insert(lastBuff.target_infos, temp)
    return temp
end
--
-- 获取最后一个buff
function BuffSetForView:get_last()
    local lastBuff = table.getLastItem(self.buffs)
    return lastBuff
end

--获取最后一个buff data
function BuffSetForView:get_last_data()
    local lastBuff = table.getLastItem(self.buffs)
    return table.getLastItem(lastBuff.target_infos)
end

function BuffSetForView:getActions(buff_info)
    if not self.actionUtil then
        return {}
    end
    print("getAction:=======", buff_info.actEffect, self.actionUtil.buffdata[string.format(buff_info.actEffect)])
    if buff_info.actEffect ~= 0 then
        assert(self.actionUtil.buffdata[string.format(buff_info.actEffect)],"not find act_effect in skill_buff_info by actEffect:"..buff_info.actEffect)
        return self.actionUtil.buffdata[string.format(buff_info.actEffect)].actions
    end
    return {}
end

function BuffSetForView:clear()
    self.buffs = {}
    self.before_buffs = {}
    self.after_buffs = {}
    self.open_stage_buffs = {}
end
return BuffSetForView
