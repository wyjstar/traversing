-- 玩家相关模板
local PlayerTemplate = class("PlayerTemplate")


import("..config.player_exp_config")

function PlayerTemplate:ctor()

end

--根据玩家等级返回当前等级升到下一等级所需exp
function PlayerTemplate:getMaxExpByLevel(level)
	cclog("level....", level)
	assert(level > 0,"level must large 0,now level"..level)
	return player_exp_config[level].exp
end

function PlayerTemplate:getEXPItemByLevel(level)
    return player_exp_config[level]
end

return PlayerTemplate


