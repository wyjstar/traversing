--装备模板

local EquipTemplate = EquipTemplate or class("EquipTemplate")

import("..config.equipment_config")
import("..config.equipment_strengthen_config")
import("..config.equipment_attribute_config")

function EquipTemplate:ctor(controller)
   self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
   self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
end

--查找模板数据,
--@param eqiupId: 即为chip_config中combineResult
--                也是EquipmentPB中no
function EquipTemplate:getTemplateById(equipId)
	local data = equipment_config[equipId]
	if data == nil then
		cclog("ERROR: cant find getTemplateById ,equipId===" .. equipId)
		return
	end
    return data
end

function EquipTemplate:getEquipTypeMinMax(equipId, type)
	print("equipId:"..equipId)
	print("type:"..type)

	local _id = equipment_config[equipId]["attr"]
	if equipment_attribute_config[_id] == nil then
		print("没有")
		return 0,0
	end

	print("equipment_attribute_config[_id] ========== ", equipment_attribute_config[_id])
	if equipment_attribute_config[_id]["minorAttr"] == nil then

		print("没有")
		return 0,0
	end

	local min = equipment_attribute_config[_id]["minorAttr"][tostring(type)][3]
	local max = equipment_attribute_config[_id]["minorAttr"][tostring(type)][4]
	cclog(min,max)
	return min,max
end
function EquipTemplate:getEquipTypeMinMaxMainAttr(equipId, type)
	print("equipId:"..equipId)
	print("type:"..type)
	local _id = equipment_config[equipId]["attr"]
	if equipment_attribute_config[_id] == nil then
		print("没有")
		return 0,0
	end
	if equipment_attribute_config[_id]["mainAttr"] == nil then

		print("没有")
		return 0,0
	end
	local min = equipment_attribute_config[_id]["mainAttr"][tostring(type)][3]
	local max = equipment_attribute_config[_id]["mainAttr"][tostring(type)][4]
	cclog(min,max)
	return min,max
end


--查询装备名字
function EquipTemplate:getEquipName(equipId)
	local _nameId = equipment_config[equipId].name
	cclog("--------equipId-----".._nameId)
	return self.c_LanguageTemplate:getLanguageById(_nameId)
end

function EquipTemplate:getDescribe(equipId)
	local _nameId = equipment_config[equipId].describe
	return self.c_LanguageTemplate:getLanguageById(_nameId)
end

--查询装备品质
function EquipTemplate:getQuality(equipId)
	return equipment_config[equipId].quality
end

--查看装备熔炼的获得
function EquipTemplate:getGains(equipId)
	print("~@", equipId)
	return equipment_config[equipId].gain
end

function EquipTemplate:getEquipResIcon(equipId)
	local equipItem = self:getTemplateById(equipId)
    local resIcon = equipItem.resIcon
    local resStr = self.c_ResourceTemplate:getResourceById(resIcon)
    -- local fianlRes = "#" .. resStr
    return resStr
end

function EquipTemplate:getEquipResHD(equipId)
	cclog("---------getEquipResHD------"..equipId)
	local equipItem = self:getTemplateById(equipId)
    local res = equipItem.resId
    local resStr = self.c_ResourceTemplate:getResourceById(res)
    -- local fianlRes = "#" .. resStr
    return resStr
end

--查询装备是否可强化
function EquipTemplate:getIsCanStrength(equipId)
	local equipItem = self:getTemplateById(equipId)
	if equipItem.currencyDir == 0 then return false
	else return true end
end


--查找装备中主属性增强的概括描述  -- 新版本中将弃用
--@param equipId: 装备id
--@preturn str, baseValue, growValue, [other]: 提示语，base值, grow值, 其他提升的属性(键值对表)
function EquipTemplate:getMainAttributeById(equipId)

	local str = nil
	local growValue = 0
	local baseValue = 0
	local data = self:getTemplateById(equipId)
	print("data========")
	-- table.print(data)
	print("data========")
	local _growAtk = data.growAtk
	local _growHp = data.growHp
	local _growPdef = data.growPdef
	local _growMdef = data.growMdef
	if _growAtk ~= 0 then -- to do 以后要加到language_config里头
		str = Localize.query("equipTemp.1")
		growValue = _growAtk
		baseValue = data.baseAtk
	elseif _growHp ~= 0 then
		str = Localize.query("equipTemp.2")
		growValue = _growHp
		baseValue = data.baseHp
	elseif _growPdef ~= 0 then
		str = Localize.query("equipTemp.3")
		growValue = _growPdef
		baseValue = data.basePdef
	elseif _growMdef ~= 0 then
		str = Localize.query("equipTemp.4")
		growValue = _growMdef
		baseValue = data.baseMdef
	end

	--其他属性
	local _otherList = {}
	if data.hit ~= 0 then table.insert(_otherList, { Localize.query("equipTemp.5") , data.hit}) end
	if data.dodge ~= 0 then table.insert(_otherList, { Localize.query("equipTemp.6") , data.dodge}) end
	if data.cri ~= 0 then table.insert(_otherList, { Localize.query("equipTemp.7") , data.cri}) end
	if data.criCoeff ~= 0 then table.insert(_otherList, { Localize.query("equipTemp.8") , data.criCoeff}) end
	if data.criDedCoeff ~= 0 then table.insert(_otherList, { Localize.query("equipTemp.9") , data.criDedCoeff}) end
	if data.block ~= 0 then table.insert(_otherList, { Localize.query("equipTemp.10") , data.block}) end
	if data.ductility ~= 0 then table.insert(_otherList, { Localize.query("equipTemp.11") , data.ductility }) end

	return str, baseValue, growValue, _otherList
end

-----------------------------------------------------
function EquipTemplate:getAttrName( idx )
	local str = ""
    if idx == "hp" then str = Localize.query("equipTemp.2")  end
    if idx == "atk" then str = Localize.query("equipTemp.1")  end
    if idx == "physicalDef" then str = Localize.query("equipTemp.3")  end
    if idx == "magicDef" then str = Localize.query("equipTemp.4")  end
    if idx == "hit" then str = Localize.query("equipTemp.5")  end
    if idx == "dodge" then str = Localize.query("equipTemp.6")  end
    if idx == "cri" then str = Localize.query("equipTemp.7")  end
    if idx == "criCoeff" then str = Localize.query("equipTemp.8")  end
    if idx == "criDedCoeff" then str = Localize.query("equipTemp.9")  end
    if idx == "block" then str = Localize.query("equipTemp.10")  end
    if idx == "ductility" then str = Localize.query("equipTemp.11")  end
    if idx == "hpRate" then str = Localize.query("equipTemp.2")  end
    if idx == "atkRate" then str = Localize.query("equipTemp.1")  end
    if idx == "physicalDefRate" then str = Localize.query("equipTemp.3")  end
    if idx == "magicDefRate" then str = Localize.query("equipTemp.4")  end
    return str
end
function EquipTemplate:setSXName( idx )
	local str = ""
    if idx == 1 then str = Localize.query("equipTemp.2")  end
    if idx == 2 then str = Localize.query("equipTemp.1")  end
    if idx == 3 then str = Localize.query("equipTemp.3")  end
    if idx == 4 then str = Localize.query("equipTemp.4")  end
    if idx == 5 then str = Localize.query("equipTemp.5")  end
    if idx == 6 then str = Localize.query("equipTemp.6")  end
    if idx == 7 then str = Localize.query("equipTemp.7")  end
    if idx == 8 then str = Localize.query("equipTemp.8")  end
    if idx == 9 then str = Localize.query("equipTemp.9")  end
    if idx == 10 then str = Localize.query("equipTemp.10")  end
    if idx == 11 then str = Localize.query("equipTemp.11")  end
    return str
end


--根据ID查询装备类型
--@param equipId: 装备id
function EquipTemplate:getTypeById(equipId)
	return equipment_config[equipId].type
end

--根据ID查找装备能激发羁绊的武将list
function EquipTemplate:getLinks(equipId)
	return equipment_config[equipId].link
end

--根据装备ID返回强化升级所需金币
--@param equipId: 装备id
--@param nowLevel: 当前强化等级
--@param nextLevel: 要提升的等级, 缺省的值为nil，即为下一级
--@return useMoney: 可只获取第一个值
function EquipTemplate:getStengthMoneyById(equipId, nowLevel, nextLevel)


	local way = equipment_config[equipId].currencyDir
	if nextLevel == nil then nextLevel = nowLevel end
	local useMoney = 0
	if way == 1 then
		for i=nowLevel, nextLevel do  --累加
			local currMoney = equipment_strengthen_config[i].currencyCost1
			useMoney = useMoney + currMoney
		end
	elseif way == 2 then
		for i=nowLevel, nextLevel do  --累加
			local currMoney = equipment_strengthen_config[i].currencyCost2
			useMoney = useMoney + currMoney
		end
	elseif way == 3 then
		for i=nowLevel, nextLevel do  --累加
			local currMoney = equipment_strengthen_config[i].currencyCost3
			useMoney = useMoney + currMoney
		end
	elseif way == 4 then
		for i=nowLevel, nextLevel do  --累加
			local currMoney = equipment_strengthen_config[i].currencyCost4
			useMoney = useMoney + currMoney
		end
	else
		for i=nowLevel, nextLevel do  --累加
			local currMoney = equipment_strengthen_config[i].currencyCost5
			useMoney = useMoney + currMoney
		end
	end

	return useMoney

end


-- @ return level, usedmoney
function EquipTemplate:getOneKeyStrengthLevel(equipItem)

	local way = equipment_config[equipItem.no].currencyDir
	local money = getDataManager():getCommonData():getCoin()
	local teamLevel = getDataManager():getCommonData():getLevel()
	local levelStreng = getDataManager():getEquipmentData():getStrengLv(equipItem.id)
	local moreLevel = getTemplateManager():getBaseTemplate():getEquipStrengthMax()
	local useMoney = 0
	local costWay = "currencyCost"..tostring(way)
	local _idx = levelStreng
	while true do
		local currMoney = equipment_strengthen_config[_idx][costWay]
		useMoney = useMoney + currMoney
		if useMoney > money or _idx == 200 or _idx >= moreLevel + teamLevel then
			return _idx - levelStreng, useMoney - currMoney
		end
		_idx = _idx + 1
	end
end

--获取装备属性
function EquipTemplate:getMainAttribute(equipId)
    local attributeItem = {}
	local attrId = equipment_config[equipId].attr
    attributeItem = equipment_attribute_config[attrId]
	return attributeItem
end

--获取装备特殊属性
function EquipTemplate:getSpecialAttribute(equipId)
    local specialAttrItem = {}
	local specialAttrId = equipment_config[equipId].specialAttr
    specialAttrItem = equipment_attribute_config[specialAttrId]
	return specialAttrItem
end



--@return
return EquipTemplate
