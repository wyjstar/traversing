-- 套装模板

local SquipmentTemplate = SquipmentTemplate or class("SquipmentTemplate")

import("..config.set_equipment_config")

function SquipmentTemplate:ctor(controller)
   
end


--查找模板数据,
function SquipmentTemplate:getTemplateById(squipId)
    local item = set_equipment_config[squipId]
    if item == nil then
        cclog("ERROR: cant find set_equipment_config by id ==".. squipId)
    end
    return item
end


--@return
return SquipmentTemplate