--每日签到界面
local PVActivityNode = import(".PVActivityNode")
local PVCardNode = import(".PVCardCanGet")

local PVSignEveryDay = class("PVSignEveryDay", BaseUIView)

local TAG_DAY_7  = 101
local TAG_DAY_15 = 102
local TAG_DAY_25 = 103


function PVSignEveryDay:ctor(id)
	self.super.ctor(self, id)
	self.baseTemp = getTemplateManager():getBaseTemplate()
	self.activityNet = getNetManager():getActivityNet()
	self.commonData = getDataManager():getCommonData()
	self.dropTemp = getTemplateManager():getDropTemplate()
	self.bagTemp = getTemplateManager():getBagTemplate()
	self.resourceTemp = getTemplateManager():getResourceTemplate()
	self.soldierTemp = getTemplateManager():getSoldierTemplate()
	self.equipTemp = getTemplateManager():getEquipTemplate()
	self.chipTemp = getTemplateManager():getChipTemplate()
	self.stageData = getDataManager():getStageData()
	self.stoneTemp = getTemplateManager():getStoneTemplate()

	self:registerNetCallback()

	cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
end

function PVSignEveryDay:onMVCEnter()
	cclog("-------------onMVCEnter-------------")
	self.ccbiNode = {}
	self:initTouchListener()
	self:loadCCBI("home/ui_activity_sign.ccbi", self.ccbiNode)	
	self:initView()
end

function PVSignEveryDay:registerNetCallback()
    local baseTemp = getTemplateManager():getBaseTemplate()
    local commonData = getDataManager():getCommonData()
    local function responseCallback1(id, data)  -- 签今天到
    	cclog("-------签到今天---------")
        if data.res.result then
            local reward = getDataManager():getActiveData():getGettingSignReward()
            getOtherModule():showOtherView("DialogGetCard", reward)
            local _times = commonData:getRepaireTimes()
            commonData:setSignedByDay(commonData:getSignCurrDay())
    		local _days = commonData:getContinuousSignDays()
            commonData:setContinuousSignDays(_days+1)
    		self:updateSignInView()  -- 更新签到数据
        end
    end
    local function responseCallback2(id, data)  -- 补签
    	cclog("-------补签回调---------")
        -- 扣钱
      	if data["res"].result == true then
	        local _times = commonData:getRepaireTimes()
	        local money = baseTemp:getRepaireSignMoney(_times+1)
	        commonData:subGold(money)
	        commonData:setRepaireTimes(_times+1)
	        commonData:setSignedByDay(ACTIVITY_REPAIRE_DAY)
	        local _days = commonData:getContinuousSignDays()
	        commonData:setContinuousSignDays(_days+1)
	        --getOtherModule():showOtherView("DialogGetCard",data)
	        ACTIVITY_REPAIRE_DAY = 0
	        self:updateSignInView()  -- 更新签到数据
	        local reward = getDataManager():getActiveData():getGettingSignReward()
	        table.print(reward)
	        getOtherModule():showOtherView("DialogGetCard",reward)
	    end
    end
    
    local function responseCallback3(id, data)-- 连续签到
    	-- 更新界面
    	cclog("--------连续签到领取------------")
    	table.print(data)
    	if data.res.result then
    		local reward = self.commonData:getCurContinuousSigned()
	        table.print(reward)
	        getOtherModule():showOtherView("DialogGetCard",reward)
	        self.commonData:setContinuousSignedByDay(ACTIVITY_CONTINUOUS_DAY)
    		self:updateSignInView()
    		ACTIVITY_CONTINUOUS_DAY = 0
    	end
    	
    end

    local function responseCallback4(id,data)
    	cclog("--------额外奖励领取------------")
    	table.print(data)
    	if data.res.result then
    		local reward = getDataManager():getActiveData():getGettingSignReward()
	        table.print(reward)
	        getOtherModule():showOtherView("DialogGetCard",reward)
	        self.commonData:addExtraSignGiftListByID(ACTIVITY_REPAIRE_DAY)
    		self:updateSignInView()
    		ACTIVITY_REPAIRE_DAY = 0
    	end
    end
    self:registerMsg(ACTIVITY_SIGN_IN_CODE, responseCallback1) -- 签到
    self:registerMsg(ACTIVITY_SIGN_REPAIRE_CODE, responseCallback2) -- 补签
    self:registerMsg(ACTIVITY_SIGN_TOTAL_CODE, responseCallback3) -- 连续签到
    self:registerMsg(ACTIVITY_SIGN_BOX, responseCallback4) -- 额外领取
end


function PVSignEveryDay:initView()
	self.ccbiRootNode = self.ccbiNode["UIActivitySign"]

	self.signLayer = self.ccbiRootNode["layer_signview"]
	self._7dayNode = self.ccbiRootNode["node_pos_7day"]
	self._15dayNode = self.ccbiRootNode["node_pos_15day"]
	self._25dayNode = self.ccbiRootNode["node_pos_25day"]

	self._7daySprite = self.ccbiRootNode["sprite_pos_7day"]
	self._15daySprite = self.ccbiRootNode["sprite_pos_15day"]
	self._25daySprite = self.ccbiRootNode["sprite_pos_25day"]

	-- self.totalSign1Label = self.ccbiRootNode["totalSign1"]
	-- self.totalSign2Label = self.ccbiRootNode["totalSign2"]
	-- self.totalSign3Label = self.ccbiRootNode["totalSign3"]

	self.cumuldaysLabel = self.ccbiRootNode["cumuldaysLabel"]
	self.node_cumula_sign = self.ccbiRootNode["node_cumula_sign"]
	self.node_cumula_sign:setPositionY(self.node_cumula_sign:getPositionY()+20)

	self:initData()
end

function PVSignEveryDay:initTouchListener()
	local function onMenuClose()
		getAudioManager():playEffectButton2()
		print("关闭")
		self:onHideView()
	end

	local function onMenuSignRule()
		getAudioManager():playEffectButton2()
		print("签到规则")
		getOtherModule():showAlertDialog(nil, Localize.query("SignRule.1"))
	end

	self.ccbiNode["UIActivitySign"] = {}
	self.ccbiNode["UIActivitySign"]["onMenuClose"] = onMenuClose
	self.ccbiNode["UIActivitySign"]["onSignRuleClick"] = onMenuSignRule
end

function PVSignEveryDay:initData()

	local _continuousSignedList = self.commonData:getContinuousSignedList()
	local function isGetContinuPrize(day)  -- 某连续奖励是否已获得
		for _i,_v in ipairs(_continuousSignedList) do
			if _v == day then return true end
		end
		return false
	end

	local function getDropImg(day, item) -- 获取到图片
		local img = game.newSprite()
		-- img:setScale(0.8)
		local k = tonumber(table.getKeyByIndex(item.reward, 1))
		local v = item.reward[tostring(k)][3]
		local count = item.reward[tostring(k)][1]
		local labelRewardNum = game.newText("x50","Berlin.ttf", 20); 
		if k == 101 then -- hero
			local _temp = self.soldierTemp:getSoldierIcon(v)
            local quality = self.soldierTemp:getHeroQuality(v)
            changeNewIconImageBottom(img, _temp, quality)
            -- labelRewardNum:setString("X" .. count)
		elseif k == 102 then -- equipment
			local _temp = self.equipTemp:getEquipResIcon(v)
            local quality = self.equipTemp:getQuality(v)
            setNewEquipCardWithFrame(img, _temp, quality)
            -- labelRewardNum:setString("X" .. count)
		elseif k == 103 then -- hero chip;
            local _temp = self.chipTemp:getTemplateById(v).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            local _quality = self.chipTemp:getTemplateById(v).quality
            setChipWithFrameNew(img,"res/icon/hero/".._icon, _quality)
            -- labelRewardNum:setString("X" .. count)
        elseif k == 104 then -- equipment chip
            local _temp = self.chipTemp:getTemplateById(v).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            local _quality = self.chipTemp:getTemplateById(v).quality
            setChipWithFrameNew(img,"res/icon/equipment/".._icon, _quality)
            -- labelRewardNum:setString("X" .. count)
		elseif k == 105 then -- item
            local _temp = self.bagTemp:getItemResIcon(v)
            local quality = self.bagTemp:getItemQualityById(v)
            setCardWithFrame(img, "res/icon/item/".._temp, quality)
            -- labelRewardNum:setString("X" .. count)
		elseif k == 106 then -- big_bag
			-- to do 不用大包吧
		elseif k == 107 then
            local _res = self.resourceTemp:getResourceById(v)
            setNewItemImageClick(img, "res/icon/resource/".._res, 1)
            -- labelRewardNum:setString("X" .. count)
		else
			local _res = self.resourceTemp:getResourceById(v)
            setNewItemImageClick(img, "#".._res, 1)
            -- labelRewardNum:setString("X" .. count)
		end
		labelRewardNum:setString(tostring(count))
		img:addChild(labelRewardNum,10)
		labelRewardNum:setPosition(cc.p(30,16))
		local _size = img:getContentSize()
		local card = PVCardNode.new(img,day,item.reward)
		local _curPosX,_curPosY = card:getPosition()
		card:setPosition(_curPosX-_size.width/2, _curPosY-_size.height/2)
		-- card:setPosition(cc.p(-50,-46))
		if isGetContinuPrize(day) == true then card:setState(2)
		else card:setState(1) end

		return card
	end

	self.signGiftList = self.baseTemp:getSignGiftList()
	self:initSignTableViewData()
	self:addExtraGift()

	self.signListView = self:g_createSignListView(self.signLayer, self.signListViewData)
	-- self.signLayer:removeAllChildren()
	self.signLayer:addChild(self.signListView)

	self.TotalSignPrize = self.baseTemp:getTotalSignPrize()	-- 累积签到{["25"]=1003,["15"]=1002,["7"]=1001,}

	self._7dayNode:addChild( getDropImg(self.TotalSignPrize[1].parameterA, self.TotalSignPrize[1]),1,TAG_DAY_7 )
	-- self.totalSign1Label:setString(self.TotalSignPrize[1].parameterA.."天")
	self._15dayNode:addChild( getDropImg(self.TotalSignPrize[2].parameterA, self.TotalSignPrize[2]),1,TAG_DAY_15 )
	-- self.totalSign2Label:setString(self.TotalSignPrize[2].parameterA.."天")
	self._25dayNode:addChild( getDropImg(self.TotalSignPrize[3].parameterA, self.TotalSignPrize[3]),1,TAG_DAY_25 )
	-- self.totalSign3Label:setString(self.TotalSignPrize[3].parameterA.."天")
	self:updateSignInView()  -- 更新签到界面
end

-- 初始化出每日签到tableview列表的数据
function PVSignEveryDay:initSignTableViewData()
	self.signListViewData = {}
	local _dayNum = table.getn(self.signGiftList)
	local _itemNum = math.ceil( _dayNum/5 )
	for i = 1, _itemNum do
		-- print("initTablewView Data", i)
		local _start = 5 * (i-1) + 1
		local _ended = 5 * (i-1) + 5
		if _ended > _dayNum then _ended = _dayNum end
		self.signListViewData[i] = {}
		for j = _start, _ended do
			-- print(i)
			table.insert(self.signListViewData[i], self.signGiftList[j])
		end
	end

end
function PVSignEveryDay:addExtraGift()
	self.signExtraGiftCol = self.baseTemp:getExtraGiftlieCol()
	self.signExtraGiftRow = self.baseTemp:getExtraGiftlieRow()
end

function PVSignEveryDay:g_createSignListView(signLayer, signListViewData)
	cclog("-------------g_createSignListView-------------")

    local commonData = getDataManager():getCommonData()
    local baseTemp = getTemplateManager():getBaseTemplate()

    local todayDate = commonData:getSignCurrDay()

    if g_create_singListView == nil then
        -- 用listview实现
        local layerSize = signLayer:getContentSize()

        g_create_singListView = ccui.ListView:create()
        g_create_singListView:retain()
        g_create_singListView:setDirection(ccui.ScrollViewDir.vertical)
        g_create_singListView:setTouchEnabled(true)
        g_create_singListView:setBounceEnabled(true)
        g_create_singListView:setBackGroundImageScale9Enabled(true)
        g_create_singListView:setSize(layerSize)
        -- g_create_singListView:setScrollable(false)
        local idx = 0
        for k, v in pairs(signListViewData) do
            local layout = game.newLayout(108*6, 100)   --106,147   
            for _k, _v in pairs(v) do
                
                local signNode = PVActivityNode.new()
                signNode:setPosition(108*(_k-1), -30)

                signNode:setTag((k-1)*5 + _k)
                signNode:setData(_v)
                layout:addChild(signNode)
               	idx = _k
            end
            --在这里插入此行的额外奖励
            local signNode = PVActivityNode.new()
            signNode:setPosition(108*(idx), -30)
            signNode:setTag(9000+k)      --900x代表是行的额外奖励
            signNode:setData(self.signExtraGiftCol[k])
            layout:addChild(signNode)

            g_create_singListView:pushBackCustomItem(layout)
        end
        --这里插入额外的此列奖励
        local layout = game.newLayout(108*6, 100)   --106,147   
        for _k, _v in pairs(self.signExtraGiftRow) do
            local signNode = PVActivityNode.new()
            signNode:setPosition(108*(_k-1), -30)

            signNode:setTag(_k*1000+1)         --x001代表第x列的额外奖励
            signNode:setData(_v)
            layout:addChild(signNode)
        end
        g_create_singListView:pushBackCustomItem(layout)
    end
    cclog("-------------g_createSignListView-------------")
    return g_create_singListView
end

function PVSignEveryDay:updateSignInView()
	cclog("-----------updateSignInView-------------")
	self.cumuldaysLabel:setString(self.commonData:getContinuousSignDays())

	if ACTIVITY_CONTINUOUS_DAY == self.TotalSignPrize[1].parameterA then
		self._7dayNode:getChildByTag(TAG_DAY_7):setState(2)
		-- self._7dayCardsetState(2)
	elseif ACTIVITY_CONTINUOUS_DAY == self.TotalSignPrize[2].parameterA then
		self._15dayNode:getChildByTag(TAG_DAY_15):setState(2)
		-- self._15dayCardsetState(2)
	elseif ACTIVITY_CONTINUOUS_DAY == self.TotalSignPrize[3].parameterA then
		self._25dayNode:getChildByTag(TAG_DAY_25):setState(2)
		-- self._25dayCardsetState(2)
	end

	if self.commonData:getContinuousSignDays() >= self.TotalSignPrize[1].parameterA and not self:checkAccGiftGot(self.TotalSignPrize[1].parameterA) then
		self._7dayNode:getChildByTag(TAG_DAY_7):setState(3)
		-- self._7dayCardsetState(3)
	end
	if self.commonData:getContinuousSignDays() >= self.TotalSignPrize[2].parameterA and not self:checkAccGiftGot(self.TotalSignPrize[2].parameterA) then
		self._15dayNode:getChildByTag(TAG_DAY_15):setState(3)
		-- self._15dayCardsetState(3)
	end
	if self.commonData:getContinuousSignDays() >= self.TotalSignPrize[3].parameterA and not self:checkAccGiftGot(self.TotalSignPrize[3].parameterA) then
		self._25dayNode:getChildByTag(TAG_DAY_25):setState(3)
		-- self._25dayCardsetState(3)
	end
    -- 更新signInview
    self:updateListView()
    self:traverseSignListShowArrow()
end

function PVSignEveryDay:checkAccGiftGot(day)
	local continuousSignedList = self.commonData:getContinuousSignedList()
	for k,v in pairs(continuousSignedList) do 
		if v == day then
			return true
		end
	end
	return false
end

--更新签到

function PVSignEveryDay:updateListView()
	cclog("-----------updateListView-------------")
	local todayDate = self.commonData:getSignCurrDay()

	for k,v in pairs(self.signListViewData) do

        local item = self.signListView:getItem(k-1)
        for _k, _v in pairs(v) do

        	local tag = (k-1)*5 + _k
        	local signNode = item:getChildByTag(tag)
            local iDay = _v.times
            if todayDate == iDay then
                if self.commonData:lookIsSigned(iDay) == false then
                    signNode:setState(3) -- 当天的，可签
                else
                    signNode:setState(1) -- 当天的，已签
                end
            elseif todayDate > iDay then -- 已经过了的日期，查找已签和可补签的
                local _usedRepaire = self.commonData:getRepaireTimes()
                local _allRepaire = self.baseTemp:getTotalRepaireSignDays()
                local _signDayList = self.commonData:getSignedList()
                if self.commonData:lookIsSigned(iDay) == true then
                    signNode:setState(1)
                else
                    if _usedRepaire < _allRepaire then -- 可补签
                        signNode:setState(2)
                    else
                        signNode:setState(0)
                    end
                end
            else -- 还没有到的日期的 4
                signNode:setState(4)
            end
        end
    end

    for k,v in pairs(self.signExtraGiftCol) do
    	local item = self.signListView:getItem(k-1) 
    	local tag = 9000 + k
    	local signNode = item:getChildByTag(tag)
    	signNode:setState(4)
    	if self:checkExtraCanGet(v.parameterC) and not self:extraGifeSigned(v.id) then signNode:setState(3) end 
    	if self:checkExtraCanGet(v.parameterC) and self:extraGifeSigned(v.id) then signNode:setState(1) end   
    end
    local item = self.signListView:getItem(6)
 	for k,v in pairs(self.signExtraGiftRow) do 
 		local tag = k * 1000 + 1
    	local signNode = item:getChildByTag(tag)
    	signNode:setState(4)
    	if self:checkExtraCanGet(v.parameterC)and not self:extraGifeSigned(v.id) then signNode:setState(3) end    --再加条件判断是否已领取
    	if self:checkExtraCanGet(v.parameterC) and self:extraGifeSigned(v.id) then signNode:setState(1) end
    end

end
function PVSignEveryDay:extraGifeSigned(id)
	local extraSignGiftList = self.commonData:getExtraSignGiftList()
	for k,v in pairs(extraSignGiftList) do 
		if id == v then return true end
	end
	return false
end
function PVSignEveryDay:traverseSignListShowArrow()
	local todayDate = self.commonData:getSignCurrDay()
	local reachRows = 0
	if todayDate%5 ~= 0 then
		reachRows = roundNumber(todayDate/5)+1
	else
		reachRows = roundNumber(todayDate/5)
	end

	local function comparePara(list,para)
		for _k,_v in pairs(list) do
			if para == _v then return true end
		end
		return false
	end

	local signedList = self.commonData:getSignedList()
	local unsignDays = {}
	for i=1,todayDate do 
		if not comparePara(signedList,i) then table.insert(unsignDays,i) end
	end
	local crushOutRow = {}
	local crushOutCol = {}
	for k,v in pairs(unsignDays) do 
		if v < todayDate then
			local row = roundNumber(v/5.1)+1
			local col = v%5
			if col == 0 then col = 5 end
			if not comparePara(crushOutRow,row) then table.insert(crushOutRow,row) end
			if not comparePara(crushOutCol,col) then table.insert(crushOutCol,col) end
		end 
	end
	cclog("-----------crushOutRow----------")
	table.print(crushOutRow)
	cclog("-----------crushOutCol----------")
	table.print(crushOutCol)
	for k,v in pairs(crushOutRow) do
		cclog("-----------crushOutRow-@@---------"..v)
		local item = self.signListView:getItem(v-1)
		local viewDataItem = self.signListViewData[v]
		for _k,_v in pairs(viewDataItem) do 
			local tag = (v-1)*5 + _k
        	local signNode = item:getChildByTag(tag)
        	signNode:setArrowRightDark()
		end
	end

	for k,v in pairs(crushOutCol) do
		for i=1,reachRows do
			local item = self.signListView:getItem(i-1)
			local tag = (i-1)*5 + v
			local signNode = item:getChildByTag(tag)
        	signNode:setArrowDownDark()
		end
	end
end

function PVSignEveryDay:checkExtraCanGet(parameter)
	local signedList = self.commonData:getSignedList()
	local function comparePara(para)
		for _k,_v in pairs(signedList) do
			if para == _v then return true end
		end
		return false
	end

	for k,v in pairs(parameter) do
		if not comparePara(v) then return false end
	end
	return true
end


function PVSignEveryDay:onReloadView()
    if COMMON_TIPS_BOOL_RETURN == true then
    	cclog("---------PVSignEveryDay:onReloadView--------------")
        COMMON_TIPS_BOOL_RETURN = false
        -- getNetManager():getActivityNet():sendRepaireSignMsg(ACTIVITY_REPAIRE_DAY)
        if EXTRA_SIGN_GIFT then 
        	getNetManager():getActivityNet():sendRepaireSignBoxMsg(ACTIVITY_REPAIRE_DAY)
        	EXTRA_SIGN_GIFT = false
        else
	        local _times = getDataManager():getCommonData():getRepaireTimes()
		    local money = getTemplateManager():getBaseTemplate():getRepaireSignMoney(_times+1)
		    if getDataManager():getCommonData():getGold() >= money then
		    	getNetManager():getActivityNet():sendRepaireSignMsg(ACTIVITY_REPAIRE_DAY)
		    else 
		    	getOtherModule():showAlertDialog(nil, Localize.query("activity.5"))
	   		end
	   	end
    else
        UI_ACTIVITY_TEXIAO_TAG = -1
    end

end

return PVSignEveryDay