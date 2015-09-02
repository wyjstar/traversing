
--活跃度相关数据
local ActiveDegreeData = class("ActiveDegreeData")


function ActiveDegreeData:ctor()
    self.c_AchievementTempalte = getTemplateManager():getAchievementTemplate()

    self.rewardList = {}                        --奖励列表
    self.activeDegreeList = {}                  --数据列表
    self.taskList = {}                          --任务列表
    self.activeDegreeNum = 0                    --活跃度数值
    self.isReceiveReward = false
    self.GettingSignReward = {}
    self.levelReward = {}                       --等级奖励
    self.dayReward  = {}                        --每日签到奖励
end

-- 获取奖励列表
function ActiveDegreeData:getRewardList()
    -- self.rewardList = nil
    -- self.rewardList = {}
    -- if self.activeDegreeList ~= nil then
    --     for k,v in pairs(self.activeDegreeList) do
    --         local achievementSort = self.c_AchievementTempalte:getItemById(v.tid).sort
    --         if achievementSort == 3 then
    --             table.insert(self.rewardList, v)
    --         end
    --     end

    --     local function mySort(item1, item2)
    --         return item1.target < item2.target
    --     end
    --     table.sort(self.rewardList, mySort)
    --     return self.rewardList
    -- end

    if self.rewardList ~= nil then
        local function mySort(item1, item2)
            return item1.target < item2.target
        end
        table.sort(self.rewardList, mySort)
        return self.rewardList
    end
end

-- 活跃度相关初始化
function ActiveDegreeData:setActiveDegreeList(data)
    self.activeDegreeList = data
    self.activeDegreeNum = 0
    self.taskList = nil
    self.taskList = {}
    if self.activeDegreeList ~= nil then
        for k,v in pairs(self.activeDegreeList) do
            local achievementSort = self.c_AchievementTempalte:getItemById(v.tid).sort
            if achievementSort == 2 then
                table.insert(self.taskList, v)
            end
        end
    end

    for m,n in pairs(self.taskList) do
        if n.current == n.target then
            local curDegreeValue = self.c_AchievementTempalte:getTaskDegreeValue(n.tid)
            self.activeDegreeNum = self.activeDegreeNum + curDegreeValue
        end
    end


    self.rewardList = nil
    self.rewardList = {}
    if self.activeDegreeList ~= nil then
        for k,v in pairs(self.activeDegreeList) do
            local achievementSort = self.c_AchievementTempalte:getItemById(v.tid).sort
            if achievementSort == 3 then
                table.insert(self.rewardList, v)
            end
        end
    end
end

-- 获取活跃度相关数据列表
function ActiveDegreeData:getActiveDegreeList()
    if self.activeDegreeList ~= nil then
        return self.activeDegreeList
    end
end

--获取活跃度获取路径的列表
function ActiveDegreeData:getTaskList()
    -- self.taskList = nil
    -- self.taskList = {}
    -- if self.activeDegreeList ~= nil then
    --     for k,v in pairs(self.activeDegreeList) do
    --         local achievementSort = self.c_AchievementTempalte:getItemById(v.tid).sort
    --         if achievementSort == 2 then
    --             table.insert(self.taskList, v)
    --         end
    --     end

    --     return self.taskList
    -- end
    return self.taskList
end

--活跃度数值设置
function ActiveDegreeData:setActiveDegreeNum(addDegreeNum)
    self.activeDegreeNum = 0
    self.activeDegreeNum = self.activeDegreeNum + addDegreeNum
end

--获取活跃度数值
function ActiveDegreeData:getActiveDegreeNum()
        return self.activeDegreeNum
end

function ActiveDegreeData:getNotice()
    local flag = false
    for k,v in pairs(self.rewardList) do
        if v.status == 2 then
            flag = true
            break
        end
    end
    return flag
end

function ActiveDegreeData:setGettingSignReward(data)
    self.GettingSignReward = data
end
function ActiveDegreeData:getGettingSignReward(data)
    return self.GettingSignReward
end


--等级奖励
function ActiveDegreeData:setLevelReward(data)
    self.levelReward = data
end
function ActiveDegreeData:getLevelReward()
     -- 解析出物件
    local heros = self.levelReward.heros                --武将
    local equips = self.levelReward.equipments          --装备
    local items = self.levelReward.items                --道具
    local h_chips = self.levelReward.hero_chips         --英雄灵魂石
    local e_chips = self.levelReward.equipment_chips    --装备碎片
    local finance = self.levelReward.finance            --finance
    local stamina = self.levelReward.stamina

    local _itemList = {}  -- 将创建物件需要的数据暂存到_itemList中
    local _index = 1
    if equips ~= nil then
        for k,var in pairs(equips) do
            _itemList[_index] = {type = 102, detailId = var.no, nums = 1 , id = var.id}
            _index = _index + 1
        end
    end
    return _itemList
end

--每日签到奖励
function ActiveDegreeData:setDayReward(data)
    self.dayReward = data
end
function ActiveDegreeData:getDayReward()
     -- 解析出物件
    local heros = self.dayReward.heros                --武将
    local equips = self.dayReward.equipments          --装备
    local items = self.dayReward.items                --道具
    local h_chips = self.dayReward.hero_chips         --英雄灵魂石
    local e_chips = self.dayReward.equipment_chips    --装备碎片
    local finance = self.dayReward.finance            --finance
    local stamina = self.dayReward.stamina

    local _itemList = {}  -- 将创建物件需要的数据暂存到_itemList中
    local _index = 1
    if equips ~= nil then
        for k,var in pairs(equips) do
            _itemList[_index] = {type = 102, detailId = var.no, nums = 1 , id = var.id}
            _index = _index + 1
        end
    end
    return _itemList
end
return ActiveDegreeData
