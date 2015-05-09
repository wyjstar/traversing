
ArenaShopTemplate = ArenaShopTemplate or class("ArenaShopTemplate")
import("..config.arena_shop_config")

function ArenaShopTemplate:ctor(controller)
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
end

function ArenaShopTemplate:getItemById(curId)
    return arena_shop_config[curId]
end

--获取兑换碎片所需声望数值
function ArenaShopTemplate:getChipReputation(curId)
    local arenaChipItem = self:getItemById(curId).consume
    if arenaChipItem ~= nil then
        return arenaChipItem["8"][1]
    end
end

--获取兑换碎片的名称
function ArenaShopTemplate:getArenaChipName(curId)
    local chipName = nil
    local arenaChipItem = self:getItemById(curId).gain
    if nil == arenaChipItem then
        return "没有该碎片"
    end
    if arenaChipItem["104"] ~= nil then
        local chipId = arenaChipItem["104"][3]
        chipName = self.chipTemp:getChipName(chipId) .. "X" .. arenaChipItem["104"][1]
    elseif arenaChipItem["105"] ~= nil then
        local chipId = arenaChipItem["105"][3]
        local cur_laId = self.bagTemp:getItemById(chipId).name
        chipName = getTemplateManager():getLanguageTemplate():getLanguageById(cur_laId) .. "X" .. arenaChipItem["105"][1]
    end

    if nil == chipName then
        return "没有该碎片"
    end

    return chipName
end

--获取碎片的icon
function ArenaShopTemplate:getArenaChipIcon(curId)
    local resId = nil
    local icon = nil
    local arenaChipItem = self:getItemById(curId).gain
    if nil == arenaChipItem then
        return "没有该碎片"
    end
    if arenaChipItem["104"] ~= nil then
        local chipId = arenaChipItem["104"][3]
        resId = self.chipTemp:getResIdById(chipId)
        -- icon = CONFIG_RES_ICON_EQUIPMENT_PAHT
    elseif arenaChipItem["105"] ~= nil then
        local chipId = arenaChipItem["105"][3]
        resId = self.bagTemp:getItemResById(chipId)
        -- icon = CONFIG_RES_ICON_ITEM_PAHT
    end

    if nil == resId then
        return "没有该碎片"
    end

    icon = getTemplateManager():getResourceTemplate():getResourceById(resId)

    return icon
end

--获取碎片的品质
function ArenaShopTemplate:getArenaChipQuality(curId)
    local quality = nil
    local arenaChipItem = self:getItemById(curId).gain
    if nil == arenaChipItem then
        return "没有该碎片"
    end
    if arenaChipItem["104"] ~= nil then
        local chipId = arenaChipItem["104"][3]
        quality = self.chipTemp:getTemplateById(chipId).quality
    elseif arenaChipItem["105"] ~= nil then
        local chipId = arenaChipItem["105"][3]
        quality = self.bagTemp:getItemQualityById(chipId)
    end

    return quality
end

return ArenaShopTemplate
