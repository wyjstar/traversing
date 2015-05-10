
SoulShopTemplate = SoulShopTemplate or class("SoulShopTemplate")
import("..config.soul_shop_config")


function SoulShopTemplate:ctor(controller)
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
end

-- 获得武魂碎片名字
function SoulShopTemplate:getSoulName(soulId)
    local soulName = nil
    local soulInfo = self:getSoulShopTempLateById(soulId)
    if nil == soulInfo then
        return "没有该碎片"
    end
    if soulInfo.gain["103"] ~= nil then
        local soulNameId = soulInfo.gain["103"][3]
        soulName = self.chipTemp:getChipName(soulNameId) .. "X" .. soulInfo.gain["103"][1]
    elseif soulInfo.gain["105"] ~= nil then
        local soulNameId = soulInfo.gain["105"][3]
        local cur_laId = self.bagTemp:getItemById(soulNameId).name
        soulName = getTemplateManager():getLanguageTemplate():getLanguageById(cur_laId) .. "X" .. soulInfo.gain["105"][1]
    end

    if nil == soulName then
        return "没有该碎片"
    end

    return soulName
end

-- 获取兑换武魂碎片价格
function SoulShopTemplate:getSoulExchangePrice(soulId)
    local soulInfo = self:getSoulShopTempLateById(soulId)
    if nil == soulInfo then
        return 1000
    end

    local status = 3
    local  consume = soulInfo.consume["3"]
    if not consume then
    	consume = soulInfo.consume["2"]
    	status = 2
    end

    if not consume then
    	return 0, 0
    end

    for k, v in pairs(consume) do
        if v then
            return status, v
        end
    end

    return 1000
end

--获得道具icon
function SoulShopTemplate:getSoulIcon(soulId)
    local soulInfo = self:getSoulShopTempLateById(soulId)
    if nil == soulInfo then
        return ""
    end

    local status = 103
    local  gain = soulInfo.gain["103"]
    if not gain then
    	status = 104
    	gain = soulInfo.gain["104"]
    end
     if not gain then
     	status = 105
    	gain = soulInfo.gain["105"]
    end

    if not gain then
    	return ""
    end

    local  resId = 0
   	local itemid = gain[3]
    local icon = CONFIG_RES_ICON_EQUIPMENT_PAHT
    if status == 103 or status == 104 then -- 103 104  去chip表里面找
    	resId = getTemplateManager():getChipTemplate():getResIdById(itemid)
        -- local restype = getTemplateManager():getChipTemplate():getTypeById(itemid)
        -- local icon = getTemplateManager():getResourceTemplate():getResourceById(resId)
        -- if restype == 1 then

        -- else

        -- end
        if status == 103 then
            icon = CONFIG_RES_ICON_HERO_PAHT
        end

    elseif status == 105 then	--  105 item 表里去找
    	resId = getTemplateManager():getBagTemplate():getItemResById(itemid)
        -- local icon = getTemplateManager():getResourceTemplate():getResourceById(resId)
        icon = CONFIG_RES_ICON_ITEM_PAHT

    end


    icon = icon..getTemplateManager():getResourceTemplate():getResourceById(resId)



    return icon
end

--获得武魂商店数据
function SoulShopTemplate:getSoulShopTempLateById(soulId)
    local item = soul_shop_config[soulId]
    if item == nil then
        cclog("ERROR:can not find soulId shop id=" .. soulId)
    end

    return item
end


return SoulShopTemplate
