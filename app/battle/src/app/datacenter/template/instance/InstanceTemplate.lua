-- 关卡模板

local InstanceTemplate = InstanceTemplate or class("InstanceTemplate")
import("..config.stage_config")     		-- 剧情关卡
import("..config.stage_story_config")     	-- 剧情关卡
import("..config.warriors_config")  		-- 无双
import("..config.stage_break_config")		--乱入
import("..config.special_stage_config")

function InstanceTemplate:ctor()
end

--扫荡数据
function InstanceTemplate:setPopUpData(data)
	self.popUpData = data
end

--------------------------------------------
---- 剧情关卡
function InstanceTemplate:getTemplateById(id) -- 特殊关卡请用： getSpecialStageById （id）
	if stage_config[id] == nil then return nil end
	return stage_config[id]
end
---- 剧情关卡 描述
function InstanceTemplate:getDesById(id) 
	local str = "@@@@@@@@@@@"
	local strId = stage_config[id].info
	str = getTemplateManager():getLanguageTemplate():getLanguageById(strId)
	return str
end

---- 获取列表 ----

-- 获取章节列表
function InstanceTemplate:getChapterList()
	local _chapters = {}
	for k,v in pairs(stage_config) do
		if v.type == 1 or v.type == 2 or v.type == 3 or v.type == 0 then
			if v.chaptersTab == 1 then
				_chapters[v.chapter] = v
			end
		end
	end
	return _chapters
end

-- 获取章节内全部关卡list
function InstanceTemplate:getStageList(no)
	local _list = {}
	for k,v in pairs(stage_config) do
		if v.type == 1 or v.type == 2 or v.type == 3 or v.type == 0 then
			if v.chaptersTab == 0 and v.chapter == no then
				_list[v.id] = v
			end
		end
	end
	return _list
end

-- 按章节号获取该章节的简单关卡列表Id, 要按照顺序排列
function InstanceTemplate:getSimpleStageList(chapterNo)
	local _list = {}
	local count = 0
	for k,v in pairs(stage_config) do
		if v.chaptersTab == 0 and v.chapter == chapterNo and v.type == 1 then
			_list[v.section] = v.id
			count = count + 1
		end
		if chapterNo == 1 then
			if count == 3 then return _list end
		else
			if count == 7 then return _list end
		end
	end
	print("！！！ 关卡数据可能不完整")
	return _list
end


-- 按章节号获取该章节的普通关卡列表Id, 要按照顺序排列
function InstanceTemplate:getNormalStageList(chapterNo)
	local _list = {}
	local count = 0
	for k,v in pairs(stage_config) do
		if v.chaptersTab == 0 and v.chapter == chapterNo and v.type == 2 then
			_list[v.section] = v.id
			count = count + 1
		end
		if chapterNo == 1 then
			if count == 3 then return _list end
		else
			if count == 7 then return _list end
		end
	end
	print("！！！ 关卡数据可能不完整")
	return _list
end


-- 根据stage id，返回章节号，关卡号
-- @param id: stage id
-- @return : chapter index, stage index
function InstanceTemplate:getIndexofStage(id)
	return stage_config[id].chapter, stage_config[id].section
end

-- 按照章节号,关卡号，获取关卡的简单难度关卡id
function InstanceTemplate:getSimpleStage(chapterNo, stageNo)
	for k,v in pairs(stage_config) do
		if v.chapter == chapterNo and v.section == stageNo and v.type == 1 then
			return v.id
		end
	end
end

-- 按照章节号,关卡号，获取关卡的普通难度关卡id
function InstanceTemplate:getNormalStage(chapterNo, stageNo)
	for k,v in pairs(stage_config) do
		if v.chapter == chapterNo and v.section == stageNo and v.type == 2 then
			return v.id
		end
	end
end

-- 按照章节号,关卡号，获取关卡的困难难度关卡id
function InstanceTemplate:getDiffcultStage(chapterNo, stageNo)
	for k,v in pairs(stage_config) do
		if v.chapter == chapterNo and v.section == stageNo and v.type == 3 then
			return v.id
		end
	end
end

-- 按照章节号返回章节项
function InstanceTemplate:getChapterItemByChapterNo(chapterNo)
	for k,v in pairs(stage_config) do
		if v.chaptersTab == 1 and v.chapter == chapterNo then
			return v
		end
	end
	return nil --没找到
end

-- 查找简单关卡的上一个简单关卡id
-- @ return : id，-1:无上一个关卡
function InstanceTemplate:getLastStage(id)
	local _cidx, _sidx = self:getIndexofStage(id)
	if _cidx == 1 and _sidx == 1 then return -1
	elseif _cidx == 2 and _sidx == 1 then return self:getSimpleStage(1, 3)
	else
		if _sidx == 1 then return self:getSimpleStage(_cidx - 1, 7)
		else return self:getSimpleStage(_cidx, _sidx-1)
		end
	end
end

-- 查找下一个简单关卡id
-- @ return : id, -1:无下一个关卡
function InstanceTemplate:getNextStage(id)
	cclog("----------getNextStage------"..id)
	local _stageMax = #self:getChapterList()
	local _cidx, _sidx = self:getIndexofStage(id)
	if _cidx == _stageMax and _sidx == 7 then return -1
	elseif _cidx == 1 and _sidx == 3 then return self:getSimpleStage(2, 1)
	else
		if _sidx == 7 then return self:getSimpleStage(_cidx + 1, 1)
		else return self:getSimpleStage(_cidx, _sidx+1)
		end
	end
end

--
function InstanceTemplate:getNextDiffStage( id )
	local refId = nil
	local cidx, sidx = self:getIndexofStage(id)
	local type = stage_config[id].type
	if cidx == 1 then return -1
	elseif cidx == 2 and type == 2 then return -1
	else
		if type == 3 then return -1 end
		for k,v in pairs(stage_config) do
			if v.chapter == cidx and v.section == sidx and v.type == type+1 then
				return k
			end
		end
	end
end

-------------------------------------------
---- 无双
function InstanceTemplate:getWSList()
	local _list = {}
	local index = 1
	for k,v in pairs(warriors_config) do
		if v.is_open == 1 then
			v.isActive = false  -- 添加一个属性，用于标记是否被激活了ß
			_list[index] = v
			index = index + 1
		end
	end
	-- sort
    local function cmp(a,b)
        if a.id < b.id then return true
        else return false
        end
    end
	table.sort(_list, cmp)

	return _list
end

-- 获取无双信息
function InstanceTemplate:getWSInfoById(id)
	return warriors_config[id]
end

function InstanceTemplate:getWSHeroNum(id)
	local item = warriors_config[id]
	if item == nil then
		return nil
	end

	local tempIndex = 0
	for i = 1, 6 do
		local name = "condition" .. i
		local conditionValue = item[name]
		if conditionValue ~= 0 then
			tempIndex = tempIndex + 1
		end
	end
	return tempIndex
end

-------------------------------------------
--获取场景资源id
function InstanceTemplate:getStageResId(id)
	local chapterIdx, stageIdx = self:getIndexofStage(id)
	local simpleId = self:getSimpleStage(chapterIdx, stageIdx)
    local stage_res = stage_config[simpleId].res
    if stage_res ~= nil then
    	return stage_res
    else
    	return nil
    end
end

function InstanceTemplate:getTravelResId(id)
	local ref = stage_config[id].res
	if ref then return ref
	else return "@@@@@@"
	end
end

--获取乱入条件
function InstanceTemplate:getConditionDetail(break_id)
	return stage_break_config[break_id]
end

--获取过关的金钱奖励
function InstanceTemplate:getClearanceMoney(id)
	local type = self:getTypeById(id)
	if type == TYPE_STAGE_NORMAL then
		return stage_config[id].currency
	elseif type == TYPE_STAGE_ELITE or type == TYPE_STAGE_ACTIVITY then
		return special_stage_config[id].currency
	end
end

--获取过关的经验奖励
function InstanceTemplate:getClearanceExp(id)
	local type = self:getTypeById(id)
	if type == TYPE_STAGE_NORMAL then
		return stage_config[id].playerExp
	elseif type == TYPE_STAGE_ELITE or type == TYPE_STAGE_ACTIVITY then
		return special_stage_config[id].playerExp
	end
end

--获取过关的英雄经验奖励
function InstanceTemplate:getClearanceHeroExp(id)
	local type = self:getTypeById(id)
	if type == TYPE_STAGE_NORMAL then
		return stage_config[id].HeroExp
	elseif type == TYPE_STAGE_ELITE or type == TYPE_STAGE_ACTIVITY then
		return special_stage_config[id].HeroExp
	end
end

-------------------------------------------
--精英关卡

function InstanceTemplate:getTypeById(id)
	local number = math.floor(id / 100000)
	if number <= 5 and number >= 1 then  -- 剧情
        return TYPE_STAGE_NORMAL
    elseif number == 7 then  -- 精英
        return TYPE_STAGE_ELITE
    elseif number == 6 then  -- 活动
        return TYPE_STAGE_ACTIVITY
    end
end

function InstanceTemplate:translateTime(strTime)
	local _year = string.sub(strTime, 1, 4)
	local _month = string.sub(strTime, 6, 7)
	local _day = string.sub(strTime, 9, 10)
	local _hour = string.sub(strTime, 12, 13)
	local _min = string.sub(strTime, 15, 16)
	local _time = os.time{year=_year, month=_month, day=_day, hour=_hour, sec=_min}
	return _time
end

function InstanceTemplate:getFBList()
	local _list = {}
	for k,v in pairs(special_stage_config) do
		if v.type == 6 then
			local openTime = self:translateTime( v.open_time )
			local closeTime = self:translateTime( v.close_time )
			local openLv = v.levelLimit
			local currTime = getDataManager():getCommonData():getTime()
			local currLevel = getDataManager():getCommonData():getLevel()
			if currTime >= openTime and currTime < closeTime and currLevel >= openLv then
				table.insert(_list, v)
			end
		end
	end
	local function cmp(a, b) -- 按id从大到小排序
		return a.id < b.id
	end
	table.sort( _list, cmp )
	return _list
end

--------------------------------------------
--活动关卡

function InstanceTemplate:getIsHDStageOpened()

end

function InstanceTemplate:translateWeek(week, nowTime)
	local weekDay = os.date("%w", nowTime) + 1  -- %w return 0-6 (Sunday-Saturday)
	-- print("weekDay ============= ", weekDay)
	-- print("week[weekDay] ============ ", week[weekDay])
	if week[weekDay] == 1 then return true
	elseif week[weekDay] == 0 then return false
	end
end
--1、3、5、7开启
function InstanceTemplate:getHDList()
	local hdStageList = {}
	local hdStageOtherList = {}
	local sundayList = {}
	local weekDay = os.date("%w", getDataManager():getCommonData():getTime()) + 1  			-- %w return 0-6 (Sunday-Saturday)
	for k,v in pairs(special_stage_config) do
		if v.type == 5 then
			local currTime = getDataManager():getCommonData():getTime()
			local openTime = self:translateTime( v.open_time )
			local closeTime = self:translateTime( v.close_time )
			local weekly = self:translateWeek( v.weeklyControl, currTime )
			local openLv = v.levelLimit
			local currLevel = getDataManager():getCommonData():getLevel()
			-- if currTime >= openTime and currTime < closeTime and currLevel >= openLv and weekly then
			if weekDay ~= 1 then
				if currTime >= openTime and currTime < closeTime and v.weeklyControl[2] == 1 then
					print("hdStageList ======= ", table.getn(hdStageList))
					table.insert(hdStageList, v) 						--1、3、5
				else
					print("hdStageOtherList ======= ", table.getn(hdStageOtherList))
					table.insert(hdStageOtherList, v)					--2、4、6
				end
			else
				if currTime >= openTime and currTime < closeTime and weekly then
					table.insert(sundayList , v)
				end
			end
		end
	end

	if weekDay == 1 then
		for k ,v in pairs(sundayList) do
			if v.weeklyControl[2] == 1 then
				table.insert(hdStageList, v)
			else
				table.insert(hdStageOtherList, v)
			end
		end
	end

	local function cmp(a, b) -- 按id从大到小排序
		return a.id < b.id
	end
	table.sort( hdStageList, cmp )
	table.sort( hdStageOtherList, cmp )
	print("活动副本的1 ============== ")
	table.print(hdStageList)
	print("活动副本2 =============== ")
	table.print(hdStageOtherList)
	return hdStageList, hdStageOtherList
end

function InstanceTemplate:getSpecialStageById( id )
	if special_stage_config[id] == nil then return nil end
	return special_stage_config[id]
end

-- 根据关卡ID获取怪物组
function InstanceTemplate:getMonsterGroupByStageID(stage_id)
	local _roundID = stage_config[stage_id].round1
	local _monsterGroup = getTemplateManager():getSoldierTemplate():getMonsterGroup(_roundID)

	return _monsterGroup
end



-------------------------------  剧情关卡对话
-- 根据剧情关卡获取剧情对话信息
function InstanceTemplate:getStageStoryInfoByStageId(stageId, status, round)
	if stageId == nil then return nil end

	for k,v in pairs(stage_story_config) do
		if v.stageId == stageId and v.trigger == status and v.monsterGroup == round then

			return v
		end
	end

	return nil
end

function InstanceTemplate:getStageStoryInfoByID(id)
	if id == nil then return nil end

	return stage_story_config[id]
end

function InstanceTemplate:getStageIntroByID(stageId)
	cclog("-----------getStageIntroByID-----"..stageId)
	if stageId == nil then return nil end
	for k,v in pairs(stage_story_config) do
		if v.stageId == stageId then
			return v.languageId
		end
	end
end

function InstanceTemplate:getStageChapterByID(stageId)
	if stageId == nil then return nil end
	for k,v in pairs(stage_story_config) do
		if v.stageId == stageId then
			return v.chapter
		end
	end
end
function InstanceTemplate:getChapterByStageId(stageId)
	cclog("----------getChapterByStageId----"..stageId)
	local chapterIdx = 0
	for k,v in pairs(stage_config) do
		if v.id == stageId then
			chapterIdx = v.chapter
			break
		end
	end
	for k,v in pairs(stage_config) do
		if v.chapter == chapterIdx and v.chaptersTab == 1 then
			return v.id
		end
	end

end
return InstanceTemplate






