
AchievementTemplate = AchievementTemplate or class("AchievementTemplate")
import("..config.achievement_config")

function AchievementTemplate:ctor(controller)
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
end

function AchievementTemplate:getItemById(curId)
    return achievement_config[curId]
end

--获取任务描述的内容
function AchievementTemplate:getTaskDes(curId)
    local textId = achievement_config[curId].text
    local textDes = self.c_LanguageTemplate:getLanguageById(textId)
    return textDes
end

--每次任务完成可以获得的活跃度的数值
function AchievementTemplate:getTaskDegreeValue(curId)
    local rewards = achievement_config[curId].reward
    local getDegreeValue = rewards["17"][1]
    if getDegreeValue ~= nil then
        return getDegreeValue
    end
end

--获取奖励的相关数值
function AchievementTemplate:getRewardData(curId)
    local reward = achievement_config[curId].reward
    local getRewardNum = reward["106"][1]
    if getRewardNum ~= nil then
        return getRewardNum
    end
end

--获取当前奖励的掉落大包id
function AchievementTemplate:getBigBagId(curId)
    local reward = achievement_config[curId].reward
    local bigBagId = reward["106"][3]
    return bigBagId
end

--获取需要达到的活跃度数值
function AchievementTemplate:getNeedDegree(curId)
    local condition = achievement_config[curId].condition
    local degreeValue = condition["1"][2]
    if degreeValue ~= nil then
        return degreeValue
    end
end

--获取当前的达成条件类型
function AchievementTemplate:getConditionType(curId)
    local conditionItem = achievement_config[curId].condition
    local conditionType = conditionItem["1"][1]
    if conditionType ~= nil then
        return conditionType
    end
end


return AchievementTemplate
