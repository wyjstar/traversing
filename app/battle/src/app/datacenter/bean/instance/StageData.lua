-- 关卡数据

local StageData = class("StageData")

function StageData:ctor()
	self.instanceTemplate = getTemplateManager():getInstanceTemplate()
	self.stageList = {}
	self.stageAwardInfo = {}
end
--[[
message Stage{
	required int32 stage_id = 1;  //关卡编号
	optional int32 attacks = 2;  //攻击次数
	optional int32 state = 3;  //关卡状态 -2:没资格 -1:开启没打过 0：输  1：赢
}
]]

function StageData:setTempBoxIndex(index)
	self.tempBoxIndex = index
end

function StageData:getTempBoxIndex()
	return self.tempBoxIndex
end

-- 添加一个关卡数据
function StageData:addStage(data)
	self.stageList[data.stage_id] = data
	self.stageList[data.stage_id].firstOpen = false
	self.stageList[data.stage_id].isFirstWin = false
	-- print(data.stage_id, data.state, data.attacks)
end

--扫荡临时数据
function StageData:setMopUpData(data)
	self.mopUpData = data
end

function StageData:getMopUpData()
	return self.mopUpData
end

function StageData:setGropUpgradeData(gropUpgradeData)
	self.gropUpgradeData = gropUpgradeData
end

function StageData:getGropUpgradeData()
	return self.gropUpgradeData
end

--剧情关卡成功次数
function StageData:getPlotTotalNum()
	local plotNum = 0
	for k,v in pairs(self.stageList) do
		local instanceItem = self.instanceTemplate:getTemplateById(v.stage_id)
		if instanceItem ~= nil then
			plotNum = plotNum + v.attacks
		end
	end

	print("plotNum =================== ", plotNum)
	return plotNum
end

--副本关卡成功的次数
function StageData:getCopyTotalNum()
	local copyNum = 0
	for k,v in pairs(self.stageList) do
		local instanceItem = self.instanceTemplate:getSpecialStageById(v.stage_id)
		if instanceItem ~= nil then
			if instanceItem.type == 6 then
				print("副本关卡的id ================ ", v.stage_id)
				copyNum = copyNum + v.attacks
			end
		end
	end

	print("copyNum ============== ", copyNum)
	return copyNum
end

--活动关卡成功的次数
function StageData:getActivityTotalNum()
	local activityNum = 0
	for k,v in pairs(self.stageList) do
		local instanceItem = self.instanceTemplate:getSpecialStageById(v.stage_id)
		if instanceItem ~= nil then
			if instanceItem.type == 5 then
				print("副本关卡的id ================ ", v.stage_id)
				activityNum = activityNum + v.attacks
			end
		end
	end
	print("activityNum ================== ", activityNum)
	return activityNum
end

--世界boss
function StageData:getWorldBossNum()
	local bossNum = 0
	for k,v in pairs(self.stageList) do
		local instanceItem = self.instanceTemplate:getSpecialStageById(v.stage_id)
		if instanceItem ~= nil then
			if instanceItem.type == 7 then
				print("副本关卡的id ================ ", v.stage_id)
				bossNum = bossNum + v.attacks
			end
		end
	end
	print("bossNum ================== ", bossNum)
	return bossNum
end

--[[
message StageAward{
	required int32 chapter_id = 1; //章节编号
	repeated int32 award = 2;  //奖励数组 -1:奖励没达成 0：奖励达成没有领取 1：已经领取
	optional int32 dragon_gift = 3; //龙纹奖励 -1:奖励没达成 0：奖励达成没有领取 1：已经领取
}
]]
-- 添加一个章节的奖励信息
function StageData:addAwardInfo(data)
	self.stageAwardInfo[data.chapter_id] = data  -- 这个chapter_id 是章节号

	-- print("awardinfo..")
	-- print(data.chapter_id, data.dragon_gift)
	-- table.print(data.award)
end

-- 返回章节奖励信息
-- @param chapterNo : 章节号
function StageData:getAwardInfoByNo(chapterNo)
	return self.stageAwardInfo[chapterNo]
end

function StageData:getAwardInfo()
	return self.stageAwardInfo
end

function StageData:setAwardInfo(stageAwardInfo)
	self.stageAwardInfo = stageAwardInfo
end

-- 查询某关卡state
-- @ return state: -1 未打过，0 败，1 胜
function StageData:getStageState(id)
	return self.stageList[id].state
end

-- 查询某关卡state,关卡是否第一次开启
-- @ return state: -1 未打过，0 败，1 胜
-- @ return firstOpen: true 第一次开启
function StageData:getStageStateAndFirstOpen(id)
	return self.stageList[id].state, self.stageList[id].firstOpen
end

-- 设置开启关卡状态为非第一次开启
function StageData:setStageNoFirstOpen(id)
	self.stageList[id].firstOpen = false
end

-- 查询某关卡的挑战次数
function StageData:getStageFightNum(id)
	return self.stageList[id].attacks
end

function StageData:changeFightNum(id, num)
	self.stageList[id].attacks = num
end

-- 查询某章是否解锁
-- @return bool: false 开锁，true 已锁
function StageData:getChapterIsLock(no)
	if no == 1 then
	    return false
	elseif no == 2 then
		local _stageId = getTemplateManager():getInstanceTemplate():getSimpleStage(1, 3)
		local _state = self:getStageState(_stageId)
		if _state == 1 then return false
		else return true
		end
	else  -- 查看上一章节的最后一关
		local _stageId = getTemplateManager():getInstanceTemplate():getSimpleStage(no-1, 7)
		local _state = self:getStageState(_stageId)
		if _state == 1 then return false
		else return true
		end
	end
end

-- 查看本关卡是否解锁
-- @return bool: true 已锁，false 开锁
function StageData:getStageIsLock(id)
	-- assert(id ~= nil, "getStageIsLock(id) : id can not be nil !")
	local _lastStageId = getTemplateManager():getInstanceTemplate():getLastStage(id)
	if _lastStageId == -1 then return false end  -- 无前一关，开锁
	local _lastStageState = self:getStageState(_lastStageId)
	if _lastStageState == 1 then return false
	else return true
	end
end

-- 第no章是否通关
-- @ param no : 章节序号
-- @ return : false,true
function StageData:getChapterIsClear(no)
	-- 只需找难度为1（简单）的是否都过了
	-- assert(table.nums(self.stageList) ~= 0, "you must add stage data first !")
	local _list = getTemplateManager():getInstanceTemplate():getSimpleStageList(no)
	for i,v in ipairs(_list) do
		local _state = self.stageList[v].state
		if _state ~= 1 then
			return false
		end
	end
	return true  -- all are 1: is clear
end

-- 查询第no章的星星数, 返回第一个数为当前星星数，第二个数为总共数
-- @ param no : 章节号
-- @ return : 第一个数为当前星星数，第二个数为总共数
function StageData:getStarNum(no)

	-- assert(table.nums(self.stageList) ~= 0, "you must add stage data first !")
	local _totalNum = 0
	local _currNum = 0

	if no == 1 then _totalNum = 3
	elseif no == 2 then _totalNum = 14
	else _totalNum = 21
	end

	local _list = getTemplateManager():getInstanceTemplate():getStageList(no)  -- 获取到本章全部的关卡
	for k,v in pairs(_list) do
		if self.stageList[v.id].state == 1 then  -- 遍历每一个关卡，获取状态为赢，统计加1
			_currNum = _currNum + 1
		end
	end

	return _currNum, _totalNum
end

--当前要挑战的关卡id: 包括剧情，精英，活动
function StageData:setCurrStageId( id )
	self.currStageId = id
end
function StageData:getCurrStageId()
	return self.currStageId
end

-- 精英副本是否开启
function StageData:getFBStageIsOpen(id)
	if self.stageList[id].state == -2 then
		return false
	else
		return true
	end
end

-- 副本关卡（精英）次数
function StageData:setEliteStageTimes(num) self.elite_stage_times = num end
function StageData:getEliteStageTimes() return self.elite_stage_times end

-- 活动关卡次数
function StageData:setActStageTimes(num) self.act_stage_times = num end
function StageData:getActStageTimes() return self.act_stage_times end

-- 关卡扫荡次数
function StageData:setStageSweepTimes(num) self.sweepTimes = num end
function StageData:getStageSweepTimes() return self.sweepTimes end

-- 设置关卡挑战状态
function StageData:setCurrStageWin(stageId)
	if self.stageList[stageId].state ~= 1 then
		self.stageList[stageId].state = 1
		self.stageList[stageId].isFirstWin = true
	else
		self.stageList[stageId].isFirstWin = false
	end
	self.stageList[stageId].attacks = self.stageList[stageId].attacks + 1
end
function StageData:setCurrStageFail(stageId)
	print("--StageData:setCurrStageFail----")
	print(stageId)
	if self.stageList[stageId].state == -1 then
		self.stageList[stageId].state = 0
	end
	-- self.stageList[stageId].attacks = self.stageList[stageId].attacks + 1
end
-- 设置下一个剧情关卡开启
function StageData:setNextStageOpen(stageId)
	local nextSimpleId = getTemplateManager():getInstanceTemplate():getNextStage(stageId)
	if nextSimpleId ~= -1 then
		local nextSimpleState = self.stageList[nextSimpleId].state
		--self.stageList[nextSimpleId].firstOpen = false
		print("----nextSimpleState----",nextSimpleState)
		if nextSimpleState == -2 then
			self.stageList[nextSimpleId].state = -1
			self.stageList[nextSimpleId].firstOpen = true
		end
	end
	local nextDiffId = getTemplateManager():getInstanceTemplate():getNextDiffStage(stageId)
	if nextDiffId ~= -1 then
		local nextDiffState = self.stageList[nextDiffId].state
		if nextDiffState == -2 then self.stageList[nextDiffId].state = -1 end
	end
end
-- 设置下个精英关卡开启
function StageData:setNextEliteStageOpen(stageId)
	for k,v in pairs(special_stage_config) do
		if v.type == 6 and v.condition == stageId then
			self.stageList[v.id].state = -1
			return
		end
	end
end

-----------------
-- 无双数据, 返回无双id列表
function StageData:getUnparalleledList()
	local soldiers = getDataManager():getLineupData():getSelectSoldier()
	local wslist = getTemplateManager():getInstanceTemplate():getWSList()

	local function haveTheSoldier(soldierNo)
		for k,v in pairs(soldiers) do
			local soldierID = v.hero.hero_no
			if soldierNo == soldierID then return true end
		end
		return false
	end

	local _list = {}
	for k,v in pairs(wslist) do
		local isTure = true
		for i=1, 7 do
			local strCon = "condition" .. tostring(i)
			local conditionValue = v[strCon]
			if conditionValue ~= 0 then
				if haveTheSoldier(conditionValue) == false then isTure = false; break end
			end
		end
		if isTure == true then table.insert(_list, v.id) end
	end

	return _list
end

-- 返回当前已选的无双id
function StageData:getCurrUnpara()
	return self.unparalleled
end
function StageData:setCurrUnpara(id)
	cclog("到达这里")
	self.unparalleled = id
end
-- 返回当前已选的小伙伴
function StageData:setCurrFriend(id)
	self.currFriendId = id
end
function StageData:getCurrFriend()
	return self.currFriendId
end

-- 设置战斗为扫荡形式或重置fb true 是  false 否
function StageData:setIsMopUpOrResetStage(isMopUpStage)
	self.isMopUpStage = isMopUpStage
end
-- 获取战斗是否为扫荡形式或重置fb true 是  false 否
function StageData:getIsMopUpOrResetStage()
	return self.isMopUpStage
end

-- 查询某关卡的重置次数
function StageData:getResetedStageNum(id)
	print("当前关卡重置次数" .. self.stageList[id].reset.times)
	return self.stageList[id].reset.times
end

function StageData:changeResetedStageNum(id, num)
	self.stageList[id].reset.times = num
	print("重置后关卡重置次数" .. self.stageList[id].reset.times)
end

-- 设置taps关闭不更新
function StageData:setCloseTips(closeTips)
	self.closeTips = closeTips
end

function StageData:getCloseTips()
	return self.closeTips
end

--判断关卡是否触发新功能开启
function StageData:getIsOpenByStageId(stageId)
	if ISSHOW_STAGE_OPEN then
		if self.stageList[stageId].state == 1 then
			return true
		else
			return false
		end
	else
		return true
	end
end

-- 获取该场战斗是否第一次胜利
function StageData:getIsFirstWin(stageId)
	if stageId ~= nil then
		return self.stageList[stageId].isFirstWin
	else
		return false
	end
end

-- 设置下一个要显示的章节故事
function StageData:setPlotChapter(plot_chapter)
	self.plot_chapter = plot_chapter
end

-- 获取下一个要显示的章节故事
function StageData:getPlotChapter()
	return self.plot_chapter 
end

-- 是否要现实章节故事
function StageData:getPlotChapterIsShow()
	print("--------self.plot_chapter---------",self.plot_chapter)
	-- -- 获取章节列表
    self.currStageList_ = {}
    local stageList_ = self.instanceTemplate:getChapterList()
    for k,v in pairs(stageList_) do
        if  self:getChapterIsLock(k) ~= true then
            table.insert(self.currStageList_,v)
        end
    end
    local function comp(a,b)
        if tonumber(a.chapter) > tonumber(b.chapter) then return true end
    end
    table.sort(self.currStageList_,comp)
    if self.plot_chapter == #self.currStageList_ then
    	local _stageId = self.instanceTemplate:getSimpleStage(self.plot_chapter, 1)
	    local _state = self.stageList[_stageId].state
	    if _state == -1 then
			return true, _stageId
		end
    end
	return false, _stageId
end

-- @return
return StageData


