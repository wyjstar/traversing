-- 关卡网络协议
--[[
获取关卡信息	901	stage.proto / StageInfoRequest	stage.proto / StageInfoResponse
获取章节奖励信息	902	stage.proto / ChapterInfoRequest	stage.proto / ChapterInfoResponse
开始战斗	903	stage.proto / StageStartRequest	stage.proto / StageStartResponse
战斗结算 904	stage.proto / StageSettlementRequest	stage.proto / StageSettlementResponse
]]
local InstanceNet = class("InstanceNet", BaseNetWork)


INST_STAGE_INFO_CODE = 901
INST_CHAPTER_PRIZE_CODE = 902
INST_START_FIGHT_CODE = 903
INST_END_FIGHT_CODE = 904

INST_UNPARALLELED_CODE = 906
INST_FIGHT_SWEEP_CODE = 907
INST_STAGE_RESET_CODE = 908

INST_STAR_RAFFLES = 909   --星级抽奖

INST_STAR_RAFFLES_FULL = 910   --星级抽奖zuihou

INST_CORP_UPGRADE = 840  --战队升级
INST_PLOT_CHAPTER_CODE = 912  --章节编号

function InstanceNet:ctor()
	self.super.ctor(self, self.__cname)
	self:initRegisterNet()
end

----------------------------------
---- request

--请求获取全部Stageinfo
function InstanceNet:sendGetAllStageInfoMsg()
	cclog("send to Get All StageInfo")
	local data = {stage_id = 0}
	self:sendMsg( INST_STAGE_INFO_CODE, "StageInfoRequest", data )
end

--请求获取某关卡的StageInfo
function InstanceNet:sendGetStageInfoMsg(id)
	cclog("send to Get Stage Info", id)
	local data = {stage_id = id}
	self:sendMsg( INST_STAGE_INFO_CODE, "StageInfoRequest", data )
end

--请求获取全部章节奖励
function InstanceNet:sendGetAllChapterPrizeMsg()
	cclog("send to get all chapter prize")
	local data = {chapter_id = 0}
	self:sendMsg( INST_CHAPTER_PRIZE_CODE, "ChapterInfoRequest", data )
end

--请求获取章节奖励
function InstanceNet:sendGetChapterPrizeMsg(id)
	cclog("send to Get Chapter Prize")
	local data = {chapter_id = id}
	self:sendMsg( INST_CHAPTER_PRIZE_CODE, "ChapterInfoRequest", data )
end

--获取无双信息
function InstanceNet:sendGetUnparalleledMsg()
	cclog("send to get Unparalleled information")
	self:sendMsg( INST_UNPARALLELED_CODE )
end

--请求开始战斗
function InstanceNet:sendStartFight(data)
	cclog("send start fight")
	table.print(data)
	local _data = data
	self:sendMsg( INST_START_FIGHT_CODE, "StageStartRequest", _data )
end

--请求结算
-- @param id: 关卡id
-- @param isWin: 是否胜利: 1, 0
function InstanceNet:sendSettlement(id, type, isWin)
	cclog("send settlement %d, %d",id, type,isWin)
	local data = {stage_id = id, stage_type = type, result = isWin}
	self:sendMsg( INST_END_FIGHT_CODE, "StageSettlementRequest", data )
end

--扫荡
function InstanceNet:sendSweepOne(stageid)
	cclog("send sweep stage .. %d", stageid)
	local data = {stage_id = stageid, times = 1}
	self:sendMsg( INST_FIGHT_SWEEP_CODE, "StageSweepRequest", data )
end

function InstanceNet:sendSweepTen(stageid, times)
	cclog("send sweep stage .. %d ten ",stageid)
	local data = {stage_id = stageid, times = times}
	self:sendMsg( INST_FIGHT_SWEEP_CODE, "StageSweepRequest", data )
end

--星级抽奖
function InstanceNet:sendStarRaffles(chapter_id, award_type)
	local data = {chapter_id = chapter_id, award_type = award_type}
	self:sendMsg( INST_STAR_RAFFLES, "StarAwardRequest", data )
end

function InstanceNet:sendStarRafflesFull(chapter_id)
	local data = {chapter_id = chapter_id, award_type = 3}
	self:sendMsg( INST_STAR_RAFFLES_FULL, "StarAwardRequest", data )
end

function InstanceNet:sendGropUpgrade()
	print("sendGropUpgrade----------=-=-=-=-=--")
	self:sendMsg(INST_CORP_UPGRADE)
end

--重置fb次数
function InstanceNet:sendResetStage(stageid)
	cclog("send reset stage .. %d", stageid)
	local data = {stage_id = stageid}
	self:sendMsg( INST_STAGE_RESET_CODE, "ResetStageRequest", data )
end

--章节编号
function InstanceNet:sendPlotChapter(no)
	local data = {chapter_id = no}
	self:sendMsg( INST_PLOT_CHAPTER_CODE, "UpdataPlotChapterRequest", data )
end

------------------------------
---- response

--处理Response
function InstanceNet:initRegisterNet()

	local function stageInfoCallback(data)
		cclog("response 获取关卡信息")
		-- table.print(data)
		
		table.remove(g_netResponselist)

		for k,v in pairs(data.stage) do
			getDataManager():getStageData():addStage(v)
		end
		print("data.elite_stage_times====", data.elite_stage_times)
		getDataManager():getStageData():setEliteStageTimes(data.elite_stage_times)
		getDataManager():getStageData():setActStageTimes(data.act_stage_times)
		getDataManager():getStageData():setPlotChapter(data.plot_chapter)
		print("-------data.plot_chapter---------",data.plot_chapter)
		-- getDataManager():getStageData():setStageSweepTimes(data.sweep_times)
	end
	local function chapterPrizeCallback(data)
		print("response 获取章节奖励")
		table.remove(g_netResponselist)
		for k,v in pairs(data) do
			for a,b in pairs(v) do
				print(b.chapter_id, b.award, b.dragon_gift)
				-- table.print(b.award)
			end
		end
		print("response 获取章节奖励")

		for k,v in pairs(data.stage_award) do
			getDataManager():getStageData():addAwardInfo(v)
		end
	end
	local function startFightCallback(data)
		print("response 开始战斗")
		table.print(data)


        if data.res.result == true then
            print("返回数据正确 =========== ")
            -- 将数据传入DataCenter
            local fightData = getDataManager():getFightData()
            -- fightData:setLineup(self.lineup)
            -- -- table.print(self.lineup)
            fightData:setData(data)

            -- fightData:setFightingStageId(self.stageId)

            enterFightScene() --开打


            --世界boss战斗后增加活跃度数值
            if self.type == "boss" then
                getDataManager():getActiveData():setActiveDegreeNum(10)
            end
        end
	end
	
	local function unparalleledCallback(data)

	end

	local function settlementCallback(data)

		cclog("response 结算")
		table.print(data)
		local stageType = getDataManager():getFightData():getFightType()
		if stageType == TYPE_MINE_MONSTER or stageType == TYPE_MINE_OTHERUSER then

			-- 调用显示出战斗结算的页面
			getFightScene().fvLayerUI:showFightVictory()
			return
		end

		print("904 CommonResponse :", data.res.result)

		-- getDataManager():getFightData():setDrops(data.drops)
		-- getDataProcessor():gainGameResourcesResponse(data.drops)

		local stageId = getDataManager():getFightData():getFightingStageId()

		local isWin = getDataManager():getFightData():getIsWin()

		if isWin then
			cclog("win ..")
			print("stageId=====" .. stageId)

			getDataManager():getFightData():setDrops(data.drops)
		    getDataProcessor():gainGameResourcesResponse(data.drops)
		    getDataManager():getCommonData():setLevel(getDataManager():getCommonData().level)

		    local commondata = getDataManager():getCommonData()
		    commondata:setLevel(commondata.level)

			if stageType == TYPE_STAGE_NORMAL then
				print("==stageType == TYPE_STAGE_NORMAL===")
				getDataManager():getStageData():setCurrStageWin(stageId)
				getDataManager():getStageData():setNextStageOpen(stageId)
		        
		        local teamExp = getTemplateManager():getInstanceTemplate():getClearanceExp(stageId)
		        local teamMoney = getTemplateManager():getInstanceTemplate():getClearanceMoney(stageId)
				local exp = commondata:getExp()
				local money = commondata:getCoin()
				local level = commondata:getLevel()
				local maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)
				if exp + teamExp > maxExp then
					commondata:setLevel(level+1)
					commondata:setExp(exp + teamExp - maxExp)
				else
					commondata:setExp(exp + teamExp)
				end
				commondata:setCoin(money + teamMoney)
				-- commondata:setCoin(money + data.drops.finance.coin)
				
			elseif stageType == TYPE_STAGE_ELITE then
				getDataManager():getStageData():setCurrStageWin(stageId)
				getDataManager():getStageData():setNextEliteStageOpen(stageId)
				local num = getDataManager():getStageData():getEliteStageTimes()
				getDataManager():getStageData():setEliteStageTimes(num+1)
			elseif stageType == TYPE_STAGE_ACTIVITY then
				getDataManager():getStageData():setCurrStageWin(stageId)
				local num = getDataManager():getStageData():getActStageTimes()
				getDataManager():getStageData():setActStageTimes(num+1)
			elseif stageType == TYPE_PVP then
				getDataManager():getArenaData():setChallengeNum(1)
			elseif stageType == TYPE_MINE_MONSTER then  -- 秘境矿    TYPE_MINE_OTHERUSER
				-- getDataManager():getArenaData():setChallengeNum(1)

			end

			-- 调用显示出战斗结算的页面
			getFightScene().fvLayerUI:showFightVictory()
		else
			cclog("failed ..")
			if stageType == TYPE_STAGE_ELITE then
				getDataManager():getStageData():setCurrStageFail(stageId)
				-- local num = getDataManager():getStageData():getEliteStageTimes()
				-- getDataManager():getStageData():setEliteStageTimes(num+1)
			elseif stageType == TYPE_STAGE_ACTIVITY then
				getDataManager():getStageData():setCurrStageFail(stageId)
			 -- 	local num = getDataManager():getStageData():getActStageTimes()
				-- getDataManager():getStageData():setActStageTimes(num+1)
			elseif stageType == TYPE_STAGE_NORMAL then
				getDataManager():getStageData():setCurrStageFail(stageId)
			elseif stageType == TYPE_PVP then
				--失败也要增加挑战次数
				getDataManager():getArenaData():setChallengeNum(1)
			end
			
			-- 调用显示出战斗结算的页面
			getFightScene().fvLayerUI:showFightDefeat()
		end
	end

	local function sweepFightCallback(data)
		print("扫荡结算")
		--table.print(data.res.result)
		  --   required bool result = 1;  //处理结果 True：正确
    -- optional int32 result_no = 2;
    -- optional string message = 3;
    	-- print(result)
    	-- print(result_no)
    	-- print(message)

		print("扫荡结算")
		if data.res.result then
			getDataManager():getStageData():setMopUpData(data.drops)
			for k, v in pairs(data.drops) do
				getDataProcessor():gainGameResourcesResponse(v)
			end
		end
	end

	local function starAwardCallBack(data)
		print("starAwardCallBack-------------")
	    if data.res.result then

	    	-- getDataManager():getStageData():setMopUpData(data.drops)
	    	getDataProcessor():gainGameResourcesResponse(data.drops)
	    end
	end

	local function starAwardFullCallBack(data)
		print("starAwardCallBack-------------")
		table.print(data.drops)
	    if data.res.result then
	    	getDataProcessor():gainGameResourcesResponse(data.drops)
	    end
	end

	local function gropUpgradeCallBack(data)
		print("gropUpgradeCallBack=============")
		if not data.res.result then
			-- return
		end
		print("data.res.result===", data.res.result)
		table.print(data.level_info)
		print("data.res.result===", data.res.result)
		getDataManager():getStageData():setGropUpgradeData(data.level_info)
		-- getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVCorpsUpgrade")

		for k,v in pairs(data.level_info) do
			getDataProcessor():gainGameResourcesResponse(v.drops)
		end

		-- if data.level_info then
		-- 	local size = table.nums(data.level_info)
			-- print("size====level_info=====", size)
			-- if size > 0 then
				getCorpsUpgrade():startView()
			-- end

		-- end
	end

	local function resetSatgeCallback(data)
		print("resetSatgeCallback-------------")
	    if data.res.result then
	    	local _currentStageId = getDataManager():getStageData():getCurrStageId()
	    	local _currentResetNum = getDataManager():getStageData():getResetedStageNum(_currentStageId)
	    	local _viplevel = getDataManager():getCommonData():getVip()
	    	local _stageResetPrice = getTemplateManager():getBaseTemplate():getPriceByResetStageNum(_currentResetNum)
	    	getDataManager():getStageData():changeResetedStageNum(_currentStageId,_currentResetNum + 1)
	    	getDataManager():getStageData():changeFightNum(_currentStageId,0)
	    	getDataManager():getStageData():setIsMopUpOrResetStage(true)
	    	getDataManager():getCommonData():subGold(_stageResetPrice)
	    	print(_currentStageId)
	    end
	end

	local function updataPlotChapterCallback(data)
		print("updataPlotChapterCallback-------------")
	    if data.res.result then
	    	local _plotChapter  = getDataManager():getStageData():getPlotChapter()
	    	getDataManager():getStageData():setPlotChapter(_plotChapter+1)
	    end
	end

	self:registerNetMsg(MINE_WIN_SETTLE, "CommonResponse", settlementCallback)
	self:registerNetMsg(INST_STAGE_INFO_CODE, "StageInfoResponse", stageInfoCallback)
	self:registerNetMsg(INST_CHAPTER_PRIZE_CODE, "ChapterInfoResponse", chapterPrizeCallback)
	self:registerNetMsg(INST_START_FIGHT_CODE, "StageStartResponse", startFightCallback)
	self:registerNetMsg(INST_UNPARALLELED_CODE, "UnparalleledResponse", unparalleledCallback)
	self:registerNetMsg(INST_END_FIGHT_CODE, "StageSettlementResponse", settlementCallback)
	self:registerNetMsg(INST_FIGHT_SWEEP_CODE, "StageSweepResponse", sweepFightCallback)
	self:registerNetMsg(INST_STAR_RAFFLES, "StarAwardResponse", starAwardCallBack)
	self:registerNetMsg(INST_STAR_RAFFLES_FULL, "StarAwardResponse", starAwardFullCallBack)
	self:registerNetMsg(INST_CORP_UPGRADE, "NewLevelGiftResponse", gropUpgradeCallBack)

	self:registerNetMsg(INST_STAGE_RESET_CODE, "ResetStageResponse", resetSatgeCallback)
	self:registerNetMsg(INST_PLOT_CHAPTER_CODE, "UpdataPlotChapterResponse", updataPlotChapterCallback)

end



--@ return
return InstanceNet

