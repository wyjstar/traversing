-- 资源模板

local ResourceTemplate = ResourceTemplate or class("ResourceTemplate")

import("..config.resource_config")

function ResourceTemplate:ctor(controller)

end

function ResourceTemplate:getResourceById(id)

	local pngfile = "ui_common_pro.png"

	id = tonumber(id)  -- 将一写string转为数字
	local resouceConfig = resource_config[id]
	if resouceConfig then
		pngfile = resouceConfig.pathWithName .. ".png"
	else
		cclog("ERROR:can't find getResourceById By id＝==" .. id)
	end

    return pngfile
end

function ResourceTemplate:getPathNameById(id)

	local pathName = ""

	local resouceConfig = resource_config[id]
	if resouceConfig then
		pathName = resouceConfig.pathWithName
	else
		cclog("ERROR:can't find getResourceById By id====", id)
	end

    return pathName
end

function ResourceTemplate:getResourceName(id)
	local nameId = resource_config[id].name
	if nameId ~= 0 then return getTemplateManager():getLanguageTemplate():getLanguageById(nameId)
	else return "@@@@@@"
	end
end

function ResourceTemplate:getDesIdById(id)
	return resource_config[id].des
end

function ResourceTemplate:getDescribe(id)
    local resLangId = resource_config[id].des
    local name_chinese = getTemplateManager():getLanguageTemplate():getLanguageById(resLangId)
    return name_chinese
end


return ResourceTemplate
