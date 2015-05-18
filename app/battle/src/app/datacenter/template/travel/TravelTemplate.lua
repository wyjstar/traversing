
local TravelTemplate = class("TravelTemplate")
import("..config.travel_event_config")
import("..config.travel_item_config")
import("..config.travel_item_group_config")

function TravelTemplate:ctor(controller)

end

function TravelTemplate:getTemplateById(id)

	return travel_event_config[id%100000]
end

-- 根据事件ID获取事件类型
function TravelTemplate:getEventTypeByEventID(eventID)
	-- cclog("---getEventTypeByEventID-----")
	-- print(eventID)
	-- cclog("----------")
	return travel_event_config[eventID%100000]["type"]
end
-- 根据事件ID获取NPC名称
function TravelTemplate:getNPCNameByEventID(eventID)
	local npcId = travel_event_config[eventID%100000]["npcName"]
	if npcId < 0 then
		return "直接领取奖励"
	end
	local _npcName = language_config[tostring(npcId)]["cn"]
	return _npcName
end

-- 根据事件ID获取时间描述
function TravelTemplate:getDiscriptionByEventID(eventID)      --事件描述
	local _meetDesId = travel_event_config[eventID%100000]["description"]
    local _meetDes = language_config[tostring(_meetDesId)]["cn"]
    return _meetDes
end

-- 根据事件ID获取游历时间
function TravelTemplate:getTimeByEventID(eventID)          -- 等待时间事件的时间
	local time = travel_event_config[eventID%100000]["parameter"]
	local num = table.nums(time)
	if num == 1 then
		for k,v in pairs(time) do
			return 	tonumber(k)
		end
	end
    return 30
end

-- 
function TravelTemplate:getItemByDetailID(detailID)        --风物志
	  return travel_item_config[detailID]
end

function TravelTemplate:getItemTypeByDetailID(detailID)        --风物志
	  return travel_item_config[detailID]["type"]
end

function TravelTemplate:getItemGroupByDetailID(detailID)        --风物志
	  return travel_item_config[detailID]["group"]
end 

function TravelTemplate:getTravelItemByDetailID(detailID)    --风物志名字
	local detailNameId = travel_item_config[detailID]["name"]
    local detailName = getTemplateManager():getLanguageTemplate():getLanguageById(detailNameId)
    return detailName
end

function TravelTemplate:getDiscriptionByDetailID(detailID)   --风物志描述
	local detailDescriptionID = travel_item_config[detailID]["description"]
    local detailDescription = getTemplateManager():getLanguageTemplate():getLanguageById(detailDescriptionID)
    return detailDescription
end

-- 获取res
function TravelTemplate:getResIconByeventID(detailID)        --风物志res
	  local _resId = travel_item_config[detailID]["icon"]
	  local resPath = getTemplateManager():getResourceTemplate():getResourceById(_resId)
	  return resPath
end
function TravelTemplate:getAddByeventID(detailID)        --
    local str = ""
    local hp = travel_item_group_config[detailID]["hp"]
    if hp ~= 0 then str = str.."  生命+"..hp end
    local atk = travel_item_group_config[detailID]["atk"]
    if atk ~= 0 then str = str.."  攻击+"..atk end
    local physicalDef = travel_item_group_config[detailID]["physicalDef"]
    if physicalDef ~= 0 then str = str.."  物防＋"..physicalDef end
    local magicDef = travel_item_group_config[detailID]["magicDef"]
    if magicDef ~= 0 then str = str.."  魔防+"..magicDef end
    return str
end

function TravelTemplate:getAddByGroupId(v)  
    local hp = travel_item_group_config[v]["hp"]
    local atk = travel_item_group_config[v]["atk"]
    local physicalDef = travel_item_group_config[v]["physicalDef"]
    local magicDef = travel_item_group_config[v]["magicDef"]
    return hp, atk, physicalDef, magicDef
end

-- 是否显示询问高人按钮
function TravelTemplate:isShowAskByEventID(eventID)

	local _ask = travel_event_config[eventID%100000]["ask"]

	if _ask ~= nil then
		return travel_event_config[eventID%100000]["ask"][1]
	end

	return nil

end

-- 如果是询问高人事件获取显示内容
function TravelTemplate:getAskDisByEventID(eventID)
	
	local askBtnId = travel_event_config[eventID%100000]["ask"][1]
    local askBtnName = getTemplateManager():getLanguageTemplate():getLanguageById(askBtnId)

    return askBtnName
end
-- 
function TravelTemplate:getAskWorldByEventID(eventID)
	--随机选择一个问寻文本
    local askId3 = travel_event_config[eventID%100000]["ask"][3]
    local askId = 0
    if askId3 == nil then
        askId = travel_event_config[eventID%100000]["ask"][2]
    else
        tempAskId2 =  math.random(2, 3)
        askId = travel_event_config[eventID%100000]["ask"][tempAskId2]
    end
    return getTemplateManager():getLanguageTemplate():getLanguageById(askId)
end

-- 获取res
function TravelTemplate:getResNameByeventID(eventID)

	if eventID == nil then
		print("传进的事件id == 0")
		return
	end

	local _resId = travel_event_config[eventID%100000]["resId"]
	local resPath = getTemplateManager():getResourceTemplate():getPathNameById(_resId)


	if resPath == nil or string.len(resPath) <=0 then
		print("么有")
		print(eventID)
		print(_resId)
	  	resPath = "stage_monster_25_all"
	end

    resPath = string.gsub(resPath, "_2.png", "_all")
    print("tupian "..resPath)
	getDataManager():getResourceData():loadHeroImageDataById(resPath)

	resPath = string.gsub(resPath, "_all", "_2.png")
	-- resPath = "res/card/"..resPath

	return resPath
end

-- 获取价格
function TravelTemplate:getPriceByeventID(eventID)

	  return travel_event_config[eventID%100000]["price"]
end

-- 根据回答选项,判断是否正确
function TravelTemplate:isRightAnswerByAnwerID(eventID, answerID)
	-- print(answerID)
	-- local _answerstr = string.format("%d", answerID)
	-- print("_----------_")
	-- print(_answerstr)
	local _answerstr = tostring(answerID)
	-- print("_----------_")
	-- print(_answerstr)

	local boolTrue = travel_event_config[eventID%100000]["parameter"][_answerstr]
	-- table.print(travel_event_config[eventID%100000]["parameter"])
	print(boolTrue)
	return boolTrue == 0, boolTrue
end

-- 获取四个答案

function TravelTemplate:getFourAnswerByeventID(eventID, btnNumber)

	local languageId  = 4*1000000000+eventID%100000*10+1+btnNumber-1
	local languageId2  = 4*1000000000+eventID%100000*10+1+btnNumber-1
	local btnName = getTemplateManager():getLanguageTemplate():getLanguageById(languageId)

	 return btnName, languageId, languageId2
end

function TravelTemplate:getAnswerIdByeventID(eventID, btnNumber)

	return 4*1000000000+eventID%100000*10+1+btnNumber-1
end

function TravelTemplate:getFentWuzhiByAwardId(awardID)
	
	 local _name = travel_item_config[awardID].name

	 return getTemplateManager():getLanguageTemplate():getLanguageById(_name)
end

-- 获取战斗事件的关卡ID
function TravelTemplate:getFightEventStageID(eventID)
	local _x = eventID%100000 - 20000
	local _stage_id = 910000 + _x
	
	return _stage_id
end


function TravelTemplate:getGroupToItems()
    local group_to_item = {}
    for no,item in pairs(travel_item_config) do
        if group_to_item[item.group] == nil then
            group_to_item[item.group] = {}
        end
        group_to_item[item.group][no] = item
    end
    return group_to_item
end

function TravelTemplate:getGroupItems(groupId)
    local groupList = {}
    for k,v in pairs(travel_item_config) do
    	if v.group == groupId then
    		-- groupList
    		table.insert(groupList, v.id)
    	end
    end
    return groupList
end


function TravelTemplate:getTravelGroupsByNo(no)
    return travel_item_group_config[no]
end



return TravelTemplate
