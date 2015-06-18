
LegionTemplate = LegionTemplate or class("LegionTemplate")

import("..config.guild_config")

function LegionTemplate:ctor(controller)

end

function LegionTemplate:getGuildTemplateByLevel(level)
    return guild_config[level]
end

return LegionTemplate
