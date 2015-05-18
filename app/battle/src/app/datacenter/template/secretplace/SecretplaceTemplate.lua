-- 符文秘境

local SecretplaceTemplate = class("SecretplaceTemplate")
 
 import("..config.mine_config")

function SecretplaceTemplate:ctor(controller)

end

function SecretplaceTemplate:getMineProtectTimeFree()
	for k,v in pairs(mine_config) do
		if v.type == 2 then
			return v.protectTimeFree
		end
	end
	return 0
end
function SecretplaceTemplate:getStoneIconByID(stone_id)
	local _resID = mine_config[stone_id]
	if _resID == nil then	
		cclog("res not find ".._resID)
		return
	end

	local _pngRes = getDataManager():getResourceData():getResourceById(_resID)

	return "res/icon/rune".._pngRes
end

return SecretplaceTemplate
