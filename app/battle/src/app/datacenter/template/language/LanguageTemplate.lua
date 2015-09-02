
LanguageTemplate = LanguageTemplate or class("LanguageTemplate")

import("..config.language_config")

function LanguageTemplate:ctor(controller)

end

function LanguageTemplate:getLanguageById(id)
	if not id then
		return "@@@@@@@@"
	end

	-- print("getLanguageById="..id)

    local languageItem = language_config[tostring(id)]

    if languageItem == nil then
        print("ERROR: can not find getLanguageById by id = ", id)
        return "@@@@@@@@"
    end

    -- print(languageItem.cn)
    local a = string.gsub( tostring(languageItem.cn) ,"\\n","\n")

    return a
end

function LanguageTemplate:getNetRandTips()
    local netTips = {}
    for k, v in pairs(language_config) do
        local idStr = tostring(v.id)
        if string.len(idStr) > 9 then
            local subStr = string.sub(idStr, 1, 2)
            if subStr == "50" then
                table.insert(netTips, v)
            end
        end
    end
    return netTips
end

return LanguageTemplate
