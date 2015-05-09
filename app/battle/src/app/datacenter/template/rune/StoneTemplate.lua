local StoneTemplate = StoneTemplate or class("StoneTemplate")
import("..config.stone_config")

function StoneTemplate:ctor(controller)
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()

    self.attributes = {}
end

--获取符文信息
function StoneTemplate:getStoneItemById(rune_id)

    return stone_config[rune_id]
end

--获取符文的描述
function StoneTemplate:getDesById(runeId)
    local runeItem = stone_config[runeId]
    if runeItem ~= nil then
        local desId = runeItem.description
        local desStr = self.c_LanguageTemplate:getLanguageById(desId)
        return desStr
    else
        return nil
    end
end

--根据id获取摘除所需要的金币
function StoneTemplate:getPickPriceById(runeId)
    return stone_config[runeId].PickPrice
end
--熔炼获得原石数量
function StoneTemplate:getStone1ById(runeId)
    return stone_config[runeId].stone1
end
--熔炼获得晶石数量
function StoneTemplate:getStone2ById(runeId)
    return stone_config[runeId].stone2
end

--符文打造消费
function StoneTemplate:getBuildCostById(runeId)
    local buildCost = self:getStoneItemById(runeId).price
    return buildCost
end

--获取符文属性的类型
function StoneTemplate:getAttriStrByType(typeVale)
    local attributeStr = {}

    attributeStr[1] = Localize.query("soldierAtt.1")             --1生命
    attributeStr[2] = Localize.query("soldierAtt.2")             --2攻击
    attributeStr[3] = Localize.query("soldierAtt.3")             --3物防
    attributeStr[4] = Localize.query("soldierAtt.4")             --4法防

    attributeStr[5] = Localize.query("equipTemp.5")              --命中率
    attributeStr[6] = Localize.query("equipTemp.6")              --闪避率
    attributeStr[7] = Localize.query("equipTemp.7")              --暴击率
    attributeStr[8] = Localize.query("equipTemp.8")              --暴击伤害系数
    attributeStr[9] = Localize.query("equipTemp.9")              --暴击减免系数
    attributeStr[10] = Localize.query("equipTemp.10")            --格挡率
    attributeStr[11] = Localize.query("soldierAtt.8")            --韧性

    return attributeStr[tonumber(typeVale)]
end
--获取符文属性的类型
function StoneTemplate:getAttrName(attr_type)
    local attributeStr = {}

    attributeStr["hp"] = Localize.query("soldierAtt.1")             --1生命
    attributeStr["atk"] = Localize.query("soldierAtt.2")             --2攻击
    attributeStr["physicalDef"] = Localize.query("soldierAtt.3")             --3物防
    attributeStr["magicDef"] = Localize.query("soldierAtt.4")             --4法防

    attributeStr["hit"] = Localize.query("equipTemp.5")              --命中率
    attributeStr["dodge"] = Localize.query("equipTemp.6")              --闪避率
    attributeStr["cri"] = Localize.query("equipTemp.7")              --暴击率
    attributeStr["criCoeff"] = Localize.query("equipTemp.8")              --暴击伤害系数
    attributeStr["criDedCoeff"] = Localize.query("equipTemp.9")              --暴击减免系数
    attributeStr["block"] = Localize.query("equipTemp.10")            --格挡率
    attributeStr["ductility"] = Localize.query("soldierAtt.8")            --韧性

    return attributeStr[attr_type]
end

-- --更具品质值获取品质颜色值
-- function StoneTemplate:getColorByQuality(curQuality)
--     local color = ui.COLOR_WHITE
--     if curQuality == 1 then
--         color = ui.COLOR_WHITE
--     elseif curQuality == 2 then
--         color = ui.COLOR_GREEN
--     elseif curQuality == 3 or curQuality == 4 then
--         color = ui.COLOR_BLUE
--     elseif curQuality == 5 or curQuality == 6 then
--         color = ui.COLOR_PURPLE
--     end
--     return color
-- end

--更具品质值获取品质颜色值
function StoneTemplate:getColorByQuality(curQuality)
    local color = ui.COLOR_WHITE
    if curQuality == 1 then
        color = ui.COLOR_WHITE
    elseif curQuality == 2 then
        color = ui.COLOR_GREEN
    elseif curQuality == 3 or curQuality == 4 then
        color = ui.COLOR_BLUE
    elseif curQuality == 5 or curQuality == 6 then
        color = ui.COLOR_PURPLE
    end
    return color
end

function StoneTemplate:getStoneIconByID(stone_id)
	cclog("stone_id=="..stone_id)

	local _resID = stone_config[stone_id].res
	if _resID == nil then
		cclog("res not find ".._resID)
		return
	end

	local _pngRes = self.c_ResourceTemplate:getResourceById(_resID)

	return CONFIG_RES_ICON_RUNE_PAHT.._pngRes, stone_config[stone_id].quality
end

function StoneTemplate:getMainValue(runeId, typeValue)

    local mainAttr = stone_config[runeId].mainAttr

    local runeType = tostring(typeValue)
    return mainAttr[runeType][3], mainAttr[runeType][4]
end

function StoneTemplate:getminorAttrNum(runeId)

    return stone_config[runeId].minorAttrNum
end

function StoneTemplate:getMintorValue(runeId, typeValue)
    local mintorAttr = stone_config[runeId].minorAttr
    local runeType = tostring(typeValue)
    if mintorAttr ~= nil then
        local runeType = tostring(typeValue)
        return mintorAttr[runeType][3], mintorAttr[runeType][4]
    end
end

function StoneTemplate:getminorAttr(runeId)

    return stone_config[runeId].minorAttr
end

function StoneTemplate:getStoneNameByID(stone_id)

    cclog("stone_id=="..stone_id)

    local _nameID = stone_config[stone_id].name
    if _nameID == nil then
        cclog("name not find ".._nameID)
        return
    end

    local stoneName = self.c_LanguageTemplate:getLanguageById(_nameID)

    return stoneName
end

return StoneTemplate
