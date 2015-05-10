
BagTemplate = BagTemplate or class("BagTemplate")
import("..config.item_config")

function BagTemplate:ctor(controller)
	self.baseTemplate = getTemplateManager():getBaseTemplate()
	self.resourceTemplate = getTemplateManager():getResourceTemplate()
end

function BagTemplate:getItemById(item_id)
    return item_config[item_id]
end


function BagTemplate:getItemResById(item_id)

    return item_config[item_id].res
end

--返回道具资源名
function BagTemplate:getItemResIcon(item_id)

    print(item_id)

    local itemItem = self:getItemById(item_id)
    local resIcon = itemItem.res
    local resStr = self.resourceTemplate:getResourceById(resIcon)
    -- local fianlRes = "#" .. resStr
    return resStr
end

--返回道具品质
function BagTemplate:getItemQualityById(item_id)
    return item_config[item_id].quality
end

function BagTemplate:getItemName(item_id)
    local itemLangId = item_config[item_id].name
    local name_chinese = getTemplateManager():getLanguageTemplate():getLanguageById(itemLangId)
    return name_chinese
end

function BagTemplate:getDescribe(item_id)
    local itemLangId = item_config[item_id].describe
    local name_chinese = getTemplateManager():getLanguageTemplate():getLanguageById(itemLangId)
    return name_chinese
end

-- 根据经验值获取经验药水icon
function BagTemplate:getExpIconAndNum(exp)
    if exp <=0 then
        return 0, 0
    end
	local item_id = self.baseTemplate:getBaseInfoByExp(exp)
    cclog("------getExpIconAndNum---item_id"..item_id)

	local res_id = self:getItemResById(item_id)

	local icon = self.resourceTemplate:getResourceById(res_id)

	local num = 1
    -- if math.modf(exp/10^5) > 0 then
    --     num = math.modf(exp/10^5)
    -- elseif math.modf(exp/10^4) > 0 then
    --     num = math.modf(exp/10^4)
    -- elseif math.modf(exp/10^3) > 0 then
    --     num = math.modf(exp/10^3)
    -- elseif math.modf(exp/10^2) > 0 then
    --     num = math.modf(exp/10^2)
    -- end
    if math.modf(exp/10^3) > 0 then
        num = math.modf(exp/10^3)
    elseif math.modf(exp/10^2) > 5 then
        num = math.modf(exp/(5*10^2))
    elseif math.modf(exp/10^2) > 0 then
        num = math.modf(exp/10^2)
    end

    return num, icon
end

--根据道具id获取获取途径的id
function BagTemplate:getToGetById(item_id)
    print("----------getToGetById------------",item_id)
    return item_config[item_id].toGet
end

return BagTemplate
