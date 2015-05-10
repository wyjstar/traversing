-- 掉落包模板

DropTemplate = DropTemplate or class("DropTemplate")
import("..config.big_bag_config")   -- boss掉落包
import("..config.small_bag_config") -- 小包

function DropTemplate:ctor(controller)

end

-- 获取大包模板数据
function DropTemplate:getBigBagById(id)
	id = tonumber(id)
    return big_bag_config[id]
end

-- 获取小包模板数据
function DropTemplate:getSmallBagById(id)
	for k, v in pairs(small_bag_config) do
		if v.dropId == id then
			return v
		end
	end

    return nil
end

-- 获取小包id对应的所有物品
function DropTemplate:getAllItemsByDropId(dropId)
	local _list = {}
	local index = 1
	for k,v in pairs(small_bag_config) do
		if v.dropId == dropId and v.weight ~= 0 then
			_list[index] = {type= v.type, detailId = v.detailID, count = v.count}
			index = index + 1
		end
	end
	return _list
end

-- 根据大包Id获取对应的物品
function DropTemplate:getAllItemByBigbagId(id)
	local smallId = big_bag_config[id].smallPacketId[1]
	return self:getAllItemsByDropId(smallId)
end

-- 根据奖励编号获得奖励 ID
function DropTemplate:getAwardBydetailID(meetJLId)

	cclog("meetJLId==%d", meetJLId)

	return small_bag_config[meetJLId].detailID
end

--根据大包的id获取小包id列表
function DropTemplate:getSmallBagIds(bigDropId)
	return big_bag_config[bigDropId].smallPacketId
end
--id是大包id,获取大包下所有小包里的物品，如果小包数量大于1则取小包数量，如小包数量等于1则取小包里物品的数量
function DropTemplate:getAllItemById(id)
	local bigBag = big_bag_config[id]
	if not bigBag then return nil end
	local items = {}
	for i = 1, #bigBag.smallPacketId do
		local smallId = bigBag.smallPacketId[i]
		local count = bigBag.smallPacketTimes[i] or 1
		--循环判断小包的掉落id
		for _, v in pairs(small_bag_config) do	
			if v.dropId == smallId then
				if count == 1 then
					count = v.count or 1
				end					
				table.insert(items, {
					item_type=v.type,
					item_id =v.detailID,
					item_count =count
					})				
			end
		end
	end
	return items
end

return DropTemplate
