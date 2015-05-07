--装备碎片模板

local ChipTemplate = ChipTemplate or class("ChipTemplate")

import("..config.chip_config")
import("..config.to_get_config")

function ChipTemplate:ctor(controller)
   self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
   self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
end

--查找模板数据,
--@param eqiupId: 即为chip_config中combineResult
--                也是EquipmentPB中no
function ChipTemplate:getTemplateById(chipId)
    return chip_config[chipId]
end

--查找碎片名字
function ChipTemplate:getChipName(chipId)
    print("chip template id", chipId)
    if chip_config[chipId] == nil then
        return "@@@@@"
    end

    local _nameId = chip_config[chipId].language
    return self.c_LanguageTemplate:getLanguageById(_nameId)
end

--查找合成后的装备No
--@param chipId: 
function ChipTemplate:getEquipNoById(chipId)
	return chip_config[chipId].combineResult
end

--查找碎片类型
--@param chipId:
function ChipTemplate:getTypeById(chipId)
	return chip_config[chipId].type
end

--查找resId
--@param chipId:
function ChipTemplate:getResIdById(chipId)
	return chip_config[chipId].resId
end

function ChipTemplate:getChipIconById(chipId)
    
    print("---ChipTemplate:getChipIconById----")
    print(chipId)

    local chipItem = self:getTemplateById(chipId)
    local resIcon = chipItem.resId
    local resStr = self.c_ResourceTemplate:getResourceById(resIcon)
    -- local fianlRes = "#" .. resStr
    return resStr
end

--查看掉落
function ChipTemplate:getAllDropPlace(id)
    local togetId = chip_config[id].toGet
    if togetId == 0 then
        print("getAllDropPlace 没有获取数据")
        return nil
    else
        for k,v in pairs(to_get_config) do
            if v.id == togetId then 
                return v
            end
        end
    end
end

-- 查看获取途径
function ChipTemplate:getDropListById(id)
    for k,v in pairs(to_get_config) do
        if v.id == id then 
            return v
        end
    end
    return {}
end




--@return
return ChipTemplate