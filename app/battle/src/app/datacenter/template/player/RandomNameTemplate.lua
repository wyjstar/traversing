-- 战队昵称
local RandomNameTemplate = class("RandomNameTemplate")
import("..config.rand_name_config")

function RandomNameTemplate:ctor()
	
end

function RandomNameTemplate:getOfficeById(id)
    return rand_name_config[id].office
end

function RandomNameTemplate:getPrefix_2ById(id)
    return rand_name_config[id].prefix_2
end

function RandomNameTemplate:getPrefix_1ById(id)
    return rand_name_config[id].prefix_1
end


return RandomNameTemplate


