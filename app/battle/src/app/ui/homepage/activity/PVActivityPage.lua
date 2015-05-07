--活动领奖

local PVActivityNode = import(".PVActivityNode")
local PVCardNode = import(".PVCardCanGet")
local PVActivityVipGift = import(".PVActivityVipGift")
-- local PVScrollBar = import("..scrollbar.PVScrollBar")

local PVActivityPage = class("PVActivityPage", BaseUIView)
BREW_START = false

ACTIVITY_REPAIRE_DAY = 0
ACTIVITY_CONTINUOUS_DAY = 0
ACTIVITY_GIFTID = 0
ACTIVITY_LOGIN_TYPE = 0

local TAG_DAY_7  = 101
local TAG_DAY_15 = 102
local TAG_DAY_25 = 103

local SIGN = 1
local STAMINA = 2
local LOGIN = 3
local RANK = 4
local BREW = 5
local VIPGIFT = 10

local RECHARGE_HF = 6        --历史首次充值
local RECHARGE_F = 7        --每日首次充值
local RECHARGE_S = 8		--单次充值
local RECHARGE_A = 9		--累计充值

UI_ACTIVITY_TEXIAO_TAG = -1

function PVActivityPage:ctor(id)
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

function PVActivityPage:onExit()
    cclog("-------onExit----")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
    getDataManager():getResourceData():clearResourcePlistTexture()
end

function PVActivityPage:clearResource()
	-- print("-11-"..collectgarbage("count"))
	self.ccbiNode = nil

	-- collectgarbage("collect")
	-- print("-22-"..collectgarbage("count"))
end

-- 注册网络response回调
function PVActivityPage:registerNetCallback()
    local baseTemp = getTemplateManager():getBaseTemplate()
    local commonData = getDataManager():getCommonData()

    local function responseGetStamina(id, data) -- 获取体力
    	-- 设置上次体力领取时间 在ActivityNet中
    	if data.res == 2 then 
    		local function callBack()
    			local staNum = getTemplateManager():getBaseTemplate():getManualValue()
		    	cclog("----responseGetStamina-----"..staNum)
		    	getOtherModule():showOtherView("PVCongratulationsGainDialog", 7, string.format(Localize.query("activity.13"),staNum))
    		end 
	    	
	    	self:updateStaminaView()
	    	local node = UI_Tililingqu(callBack)
	    	self.animationNode:addChild(node)
	        self:updateEatNotice()
	    end
    end

    local function responseGetLevelGift(id, data) -- 获取等级奖励
    	self.rankFlag = true
    	if data.result == true then
	    	self.commonData:addGotLevelGift(ACTIVITY_GIFTID)
	    	getOtherModule():showOtherView("DialogGetCardUpdate",self.rankDropList)
	    	table.print(self.rankDropList)
	    	-- self:updateLoginView()
	    	self:updateRankView()
	    	ACTIVITY_GIFTID = 0
	        self:updateRankNotice()
	    end
    end
    local function responseGetLoginGift(id, data)   --获取登陆奖励
    	self.loginFlag = true
    	if data.result == true then
    		if ACTIVITY_LOGIN_TYPE == 1 then
    			self.commonData:addLoginTotalGift(ACTIVITY_GIFTID)
    		elseif ACTIVITY_LOGIN_TYPE == 2 then
    			self.commonData:addLoginContinueGift(ACTIVITY_GIFTID)
    		end
    		getOtherModule():showOtherView("DialogGetCardUpdate",self.loginDropList)
    		self:updateLoginView()
    	end
    	ACTIVITY_GIFTID = 0
        self:updateLoginNotice()
    end
    local function getBrewResult()  -- 煮酒
        -- self.brewGoing = false
        BREW_START = false
        self:updateZJMenu()
        self:updateWineNotice()
    end
    local function getRechargeGiftResult(id,data)
    	self.clickFlag = true
    	if data.res.result == true then
    		self.commonData:setRechargeGiftGot(self.rewardId)
    		getOtherModule():showOtherView("DialogGetCardUpdate",self.rechargeDropList)
    		self:updateRechargeView(self.rewardType)
    	end
    end
    local function getVipGiftResult(id,data)
    	cclog("getVipGiftResult"..id)	
		if self.vipGiftNode ~=nil then
			self.vipGiftNode:receiveVipData(data.id,data.buyed_id)
		end
	     
    end
    local function getBuyVipGiftResult(id,data)
    	cclog("getVipGiftResult"..id)
    	table.print(data)
    	if self.vipGiftNode ~=nil then
    		self.vipGiftNode:receiveVipBuy(data)
    		if data.res.result == true  then
    			self:updataVipGiftMenu()
    		end
			
		end
	     
    end
	

    self:registerMsg(ACTIVITY_LEVEL_CODE, responseGetLevelGift) -- 获得等级奖励
    self:registerMsg(ACTIVITY_GETLOGIN_CODE, responseGetLoginGift) -- 获得登陆奖励
    self:registerMsg(ACTIVITY_GETSTMINA_CODE, responseGetStamina) -- 获取体力
    self:registerMsg(ACTIVITY_DO_BREW_CODE, getBrewResult) -- 1601 --煮酒
    self:registerMsg(ACTIVITY_TAKEN_BREW_CODE, getBrewResult) -- 1602
    self:registerMsg(ACTIVITY_RECHARGE_GIFT, getRechargeGiftResult) -- 1151
    self:registerMsg(SHOP_GET_ITEM_CODE, getVipGiftResult) -- 508vip礼包协议
    self:registerMsg(SHOP_BUY_GOODS_CODE, getBuyVipGiftResult)

end

function PVActivityPage:onMVCEnter()
	self.ccbiNode = {}
	
	self:initTouchListener()
	-- self:loadCCBI("home/ui_activity_page.ccbi", self.ccbiNode)
	self:loadCCBI("home/ui_activity_page_new.ccbi", self.ccbiNode)
	self.rankFlag = true
	self.loginFlag = true
	self.recharge = false
	-- self.brewGoing = false
	self.clickFlag = true
	self:initView()

	-- self:initLableTitle()
	self:createActivityTableView()
	getNetManager():getActivityNet():sendGetRechargeListMsg()
	-- cclog("------------self.tabCell----------------")
 --    -- table.print(self.tabCell)
 --    for k,v in pairs(self.tabCell) do
 --    	print("------v.id-----"..v.id)
 --    end
	-- ProFi:start()
 --    self:initView()
 --    ProFi:stop()
 --    ProFi:writeReport( 'MyProfilingReport.txt' )

 	self:updateEatNotice()
    self:updateLoginNotice()
    self:updateWineNotice()
    self:updateRankNotice()


end

function PVActivityPage:initTouchListener()

	local function onMenuClose()
		getAudioManager():playEffectButton2()
		print("关闭")
		--TODO: 此处注释掉，有问题重写
		-- local currentGID = getNewGManager():getCurrentGid()
  --       if currentGID == G_GUIDE_20124 then
  --           local homePage = getPlayerScene().homeModuleView.moduleView
  --           homePage:scrollToTPage()
            
  --           getNewGManager():startGuide()
  --       end
        -- groupCallBack(GuideGroupKey.HOME)   ----添加home
		self:onHideView()
	end
	
	local function onMenuGetStamina()
		getAudioManager():playEffectButton2()
		print("获取到奖励")
		self.activityNet:sendGetStminaMsg()
	end
	local function onMenuStartZJ()
		getAudioManager():playEffectButton2()
		print("煮酒开始")
		BREW_START = true
		local startLv = self.baseTemp:getBrewStartLevel()
		-- local lv = getDataManager():getCommonData():getLevel()
		-- if lv >= startLv then
			local nectar_cur = self.commonData:getNectarCur()
			self.labelZJJiuCur:setString(tostring(nectar_cur))
        	self:updateZJMenu(true)
        -- else
        	-- getOtherModule():showAlertDialog(nil, Localize.query("activity.6"))
        -- end
        groupCallBack(GuideGroupKey.BTN_CLICK_ZHUJIU)
	end
	local function onMenuZJGet()
		getAudioManager():playEffectButton2()
		print("煮酒收取")
        self.activityNet:sendTakenBrewMsg()
        local preNectar = self.commonData:getNectarCur()
        reward = {["107"] = {[1] = tonumber(preNectar),[2] = tonumber(preNectar),[3] = 13}}
        getOtherModule():showOtherView("DialogGetCard",reward)

	end
	local function onMenuZJGoon()
		getAudioManager():playEffectButton2()
		print("银樽煮酒")
		local allGold = getDataManager():getCommonData():getGold()
		if self.jx_gold <= allGold then
			self.preNectar = self.commonData:getNectarCur()
	        self.activityNet:sendBrewMsg(2)
		else
			-- self:toastShow(Localize.query("activity.5"))
			getOtherModule():showAlertDialog(nil, Localize.query("activity.5"))
		end
	end
	local function onMenuZJGold()
		getAudioManager():playEffectButton2()
		print("金樽煮酒")
		local allGold = getDataManager():getCommonData():getGold()
		cclog("金樽金币"..allGold.."金樽数量"..self.jz_token)
		-- if self.jz_gold <= allGold and self.jz_token <= self.jz_num then
		if self.jz_token <= self.jz_num then
			self.preNectar = self.commonData:getNectarCur()
			self.jz_flag = true
	        self.activityNet:sendBrewMsg(3)
		else
			-- self:toastShow(Localize.query("activity.5"))
			getOtherModule():showAlertDialog(nil, Localize.query("activity.8"))
		end
	end
	local function onMenuZJGotoWJ()
		getAudioManager():playEffectButton2()
		print("解锁武将封印")
		--
		getModule(MODULE_NAME_LINEUP):removeLastView()
        getModule(MODULE_NAME_LINEUP):showUIView("PVLineUp")

		-- getModule(MODULE_NAME_LINEUP):showUIView("PVLineUp")
	end
	local function onMenuRecharge()
		getAudioManager():playEffectButton2()
        print("PVshopRecharge 。。。")
        self.recharge = true
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
	end
	local function onMenuArrowLeft()
		if self.mainTableView == nil then return end 
		local pos = self.mainTableView:getContentOffset()
		local addnum = roundNumber(pos.x/(-110))
		local cellNum = 5 + addnum
		if pos.x%(-110) ~= 0 then cellNum = cellNum + 1 end
		if cellNum > 5 then 
			cellNum = cellNum - 1
			if cellNum <= 5 then self.menuArrowLeft:setVisible(false) end
			self.menuArrowRight:setVisible(true) 
			self.mainTableView:setContentOffset((cc.p(-110*(cellNum - 5),0)))
		end
	end
	local function onMenuArrowRight()
		if self.mainTableView == nil then return end 
		local pos = self.mainTableView:getContentOffset()
		local addnum = roundNumber(pos.x/(-110))
		local cellNum = 5 + addnum
		if cellNum < table.getn(self.tabTitle) then
			cellNum = cellNum + 1
			if cellNum >= table.getn(self.tabTitle) then self.menuArrowRight:setVisible(false) end
			self.menuArrowLeft:setVisible(true) 
			self.mainTableView:setContentOffset((cc.p(-110*(cellNum - 5),0)))
			
		end
	end
	-- 顶部三按钮
	self.ccbiNode["UIActvityPage"] = {}
	self.ccbiNode["UIActvityPage"]["onMenuClose"] = onMenuClose
	self.ccbiNode["UIActvityPage"]["onMenuArrowLeft"] = onMenuArrowLeft
	self.ccbiNode["UIActvityPage"]["onMenuArrowRight"] = onMenuArrowRight

    -- 领取体力
	self.ccbiNode["UIActvityPage"]["onMenuGetStamina"] = onMenuGetStamina
	self.ccbiNode["UIActvityPage"]["onMenuClickStartZJ"] = onMenuStartZJ
	self.ccbiNode["UIActvityPage"]["onMenuClickGotoWJ"] = onMenuZJGotoWJ
	self.ccbiNode["UIActvityPage"]["menuClickZJGet"] = onMenuZJGet
	self.ccbiNode["UIActvityPage"]["menuClickZJSq"] = onMenuZJGet
	self.ccbiNode["UIActvityPage"]["menuClickZJGoon"] = onMenuZJGoon
	self.ccbiNode["UIActvityPage"]["menuClickZJGold"] = onMenuZJGold
	self.ccbiNode["UIActvityPage"]["onMenuRecharge"] = onMenuRecharge
end

function PVActivityPage:initView()
	self.ccbiRootNode = self.ccbiNode["UIActvityPage"]
	--主标签可滑动
	self.upMenuLayer = self.ccbiRootNode["upMenuLayer"]
	self.menuArrowLeft = self.ccbiRootNode["menu_arrow_left"]
	self.menuArrowRight = self.ccbiRootNode["menu_arrow_right"]
	-- self.menuNode = self.ccbiRootNode["menuNode"]
	-- self.menuNode:setVisible(false)
	--不可滑动
	self.menuSign = self.ccbiRootNode["menu_sign"]
	self.menuStamina = self.ccbiRootNode["menu_stamina"]
	self.menuLogin = self.ccbiRootNode["menu_login"]
	self.menuZhujiu = self.ccbiRootNode["menu_zhujiu"]
	self.menuRank = self.ccbiRootNode["menu_rank"]

	self.nodeSign = self.ccbiRootNode["node_signed"]
	self.nodeStamina = self.ccbiRootNode["node_bodypower"]
	self.nodeLogin = self.ccbiRootNode["node_loadin"]
	self.nodeZhujiu = self.ccbiRootNode["node_zhuju"]
	self.nodeRank = self.ccbiRootNode["node_rank"]
	self.nodeZJAnimaNode = self.ccbiRootNode["zj_animation_node"]
	self.titleZJGet = self.ccbiRootNode["titleZJGet"]
	--充值活动
	self.fistDoubleNode = self.ccbiRootNode["fistDoubleNode"]   --历史首充双倍
	self.oneChongNode = self.ccbiRootNode["oneChongNode"]		--单次充值
	self.nChongNode = self.ccbiRootNode["nChongNode"]			--累计充值
	self.dayChongNode = self.ccbiRootNode["dayChongNode"]		--每日首充
	self.layer_Single = self.ccbiRootNode["layer_Single"]      
	self.layer_Acc = self.ccbiRootNode["layer_Acc"]
	self.layer_DayFirst = self.ccbiRootNode["layer_DayFirst"]
	self.fistDoubleSizeLayer = self.ccbiRootNode["fistDoubleSizeLayer"]
	self.nChongTimeLabel = self.ccbiRootNode["nChongTimeLabel"]
	self.dayChongTimeLabel = self.ccbiRootNode["dayChongTimeLabel"]
	self.oneChongTimeLabel = self.ccbiRootNode["oneChongTimeLabel"]

	--煮酒红点
	self.redDotZhujiu = self.ccbiRootNode["redDot_wine"]
	self.redDotLogin = self.ccbiRootNode["redDot_login"]
	self.redDotRank = self.ccbiRootNode["redDot_rank"]
	local node = UI_zhujiu()
	self.nodeZJAnimaNode:addChild(node)
    --流光特效节点
    self.nodeEffectZhuJiu = self.ccbiRootNode["Effect_wine"]
    self.nodeEffectLogin = self.ccbiRootNode["Effect_login"]
    self.nodeEffectRank = self.ccbiRootNode["Effect_rank"]
    self.nodeEffectSign = self.ccbiRootNode["Effect_sign"]
	-- 每日签到相关
	self._7dayNode = self.ccbiRootNode["node_pos_7day"]
	self._15dayNode = self.ccbiRootNode["node_pos_15day"]
	self._25dayNode = self.ccbiRootNode["node_pos_25day"]
	self.signLayer = self.ccbiRootNode["layer_signview"]
	self.totalSign1Label = self.ccbiRootNode["totalSign1"]
	self.totalSign2Label = self.ccbiRootNode["totalSign2"]
	self.totalSign3Label = self.ccbiRootNode["totalSign3"]
	-- self.nodeMonth = self.ccbiRootNode["nodeLableatlas"]

	-- 体力领取相关
	self.menuGetStamina = self.ccbiRootNode["menu_getStamina"]
	-- self.imgGetStamina = self.ccbiRootNode["img_stamina_get"]
	self.labelTime1 = self.ccbiRootNode["label_time1"]
	self.labelTime2 = self.ccbiRootNode["label_time2"]
	self.labelTime3 = self.ccbiRootNode["label_time3"]
	self.labelTime = {}
	table.insert(self.labelTime, self.labelTime1)
	table.insert(self.labelTime, self.labelTime2)
	table.insert(self.labelTime, self.labelTime3)

	-- 登陆奖励相关
	self.loginView = self.ccbiRootNode["layer_list"]  --放登录奖励tableview
	self.labelTip = self.ccbiRootNode["label_stamina_tips"]
	self.imgTable = self.ccbiRootNode["img_table"]
	--等级奖励相关
	self.rankView = self.ccbiRootNode["layer_list2"]  --放等级奖励tableview

	-- 煮酒
	self.menuZJStart = self.ccbiRootNode["menu_zj_start"]
	self.menuZJGet = self.ccbiRootNode["menu_zj_get"]
	self.menuZJGoon = self.ccbiRootNode["menu_zj_goon"]
	self.menuZJShouqu = self.ccbiRootNode["menu_zj_shouqu"]
	--充值礼包
	self.vipGiftLayer = self.ccbiRootNode["ui_activity_vipgiftlayer"]
	-- self.brewBg = self.ccbiRootNode["brewBg"]
	-- game.setSpriteFrame(self.brewBg,"res/ccb/effectpng/ui_activity_zj_bg.png")
	--self.menuZJGold = self.ccbiRootNode["menu_zj_jzzj"]
	self.menuZJGoToWJ = self.ccbiRootNode["menu_zj_gotowj"]
	self.nodeZJ_Money = self.ccbiRootNode["node_zj_jzzj_money"]
    self.labelZJtimes = self.ccbiRootNode["label_zjcs"]
    self.labelZJJiu = self.ccbiRootNode["label_zj_jiu"]
    self.labelZJJiuCur = self.ccbiRootNode["label_zhuju_num"]
    self.labelZJGold = self.ccbiRootNode["label_zj_gold"]
    self.labelZJJZGold = self.ccbiRootNode["label_zjjz_gold"]
    self.labelZJJConsum = self.ccbiRootNode["label_zjjz_comsum"]
    self.labelZJJXGold = self.ccbiRootNode["label_zjjx_gold"]
    self.nodeZJ_jz = self.ccbiRootNode["goldNode"]
    self.effectBG = self.ccbiRootNode["effectBG"]
	self.animationNode = self.ccbiRootNode["animationNode"]
	self.animationNodeBrew = self.ccbiRootNode["animationNode"]
	self.layerZCEff = self.ccbiRootNode["layerZCEff"]

    self.sign_notice = self.ccbiRootNode["sign_notice"]
    self.get_phy_notice = self.ccbiRootNode["get_phy_notice"]

    self.adpterNode = self.ccbiRootNode["adpter_node"]
    self.clipNode = cc.ClippingNode:create()
    self.clipNode:setContentSize(cc.size(535, 330))
    self.clipNode:setAnchorPoint(cc.p(0, 0))
    -- self.clipNode:setPosition(self.adpterNode:getPosition())
    self.clipNode:setPosition(cc.p(270,170))
    self.adpterNode:addChild(self.clipNode)
    local stencil = cc.LayerColor:create(cc.c4b(100, 100, 0, 255))
    local imgsize = self.signLayer:getContentSize()
    local imgposx, imgposy = self.signLayer:getPosition()
    cclog("self.layerZCEff_width"..imgsize.width.."self.layerZCEff_height"..imgsize.height.."layposx"..imgposx.."layposy"..imgposy)
    stencil:setContentSize(imgsize)
    stencil:setPosition(cc.p(imgposx - imgsize.width/2, imgposy - imgsize.height/2))

    self.clipNode:setStencil(stencil)
    self.animationNodeBrew:removeFromParent(false)
    self.clipNode:addChild(self.animationNodeBrew, 100, 1)

	-- -- 初始化数值
	self:initData()
	self:initLableTitle()
	-- 从其他界面跳转
	local pageIdx = self.funcTable[1]
	if pageIdx == nil then
		pageIdx = 2	
	end
	self:updateMenu(pageIdx)
end

--更新领取体力notice
function PVActivityPage:updateEatNotice()
	local cell = self:findCellById(STAMINA)
	if cell == nil then return end 
    self.timeCanGet = self.commonData:getTimeCanGet()
    local isFeastTime = self.commonData:isFeastTime(self.timeCanGet)
    if isFeastTime then
        local isEatFeast = self.commonData:isEatFeast(self.timeCanGet)
        if isEatFeast then
        	cell.redDot:setVisible(false)
            cell.effNode:setVisible(false)
        else
        	cell.redDot:setVisible(true)
            cell.effNode:setVisible(true)
        end
    else
    	cell.redDot:setVisible(false)
    	cell.effNode:setVisible(false)
    end
end

--更新煮酒提醒
function PVActivityPage:updateWineNotice()
	local cell = self:findCellById(BREW)
	if cell == nil then return end 
	--需要做nil判断吗
	local startLv = self.baseTemp:getBrewStartLevel()
	local lv = getDataManager():getCommonData():getLevel()
	local brewFlag = (lv >= startLv)
	if brewFlag then
    	local brew_times = self.commonData:getBrewTimes()
    	local brew_times_max = self.baseTemp:getBrewTimesMax()
    	local isCanBrew = (brew_times_max - brew_times ) > 0
    	cell.redDot:setVisible(isCanBrew)
    	cell.effNode:setVisible(isCanBrew)
    	-- self.redDotZhujiu:setVisible(isCanBrew)
    	-- self.nodeEffectZhuJiu:setVisible(isCanBrew)
    else
    	cell.redDot:setVisible(brewFlag)
    	cell.effNode:setVisible(brewFlag)
    	-- self.redDotZhujiu:setVisible(brewFlag)
    	-- self.nodeEffectZhuJiu:setVisible(brewFlag)
    end
end
function PVActivityPage:updataVipGiftMenu()
	local cell = self:findCellById(VIPGIFT)
	if cell == nil then return end 
	local vipgiftData = getDataManager():getShopData():getVipGiftData()
	table.print(vipgiftData)
	cclog("updataVipGiftMenu=============="..vipgiftData["BuyEnable"])
	if vipgiftData["BuyEnable"] == 1 then
		cell.redDot:setVisible(true)
        cell.effNode:setVisible(true)
	else
		cell.redDot:setVisible(false)
        cell.effNode:setVisible(false)
	end
	
	-- body
end

--更新签到提醒
function PVActivityPage:updateSineNotice()
	local cell = self:findCellById(SIGN)
	if cell == nil then return end
    local nowDay = self.commonData:getSignCurrDay()
    local isSigned = self.commonData:lookIsSigned(nowDay)
    cell.redDot:setVisible(not isSigned)
    cell.effNode:setVisible(not isSigned)
    -- self.sign_notice:setVisible(not isSigned)
    -- self.nodeEffectSign:setVisible(not isSigned)
end

--更新登陆提醒
function PVActivityPage:updateLoginNotice()
	local cell = self:findCellById(LOGIN)
	if cell == nil then return end
	 --累计登录奖励
    local isCanGetTotleReward = self.commonData:getIsCanGetTotleReward()
    --连续登陆奖励
    local isCanGetSeriesReward = self.commonData:getIsCanGetSeriesReward()
    cell.redDot:setVisible(isCanGetTotleReward or isCanGetSeriesReward)
    cell.effNode:setVisible(isCanGetTotleReward or isCanGetSeriesReward)
	-- self.redDotLogin:setVisible(isCanGetTotleReward or isCanGetSeriesReward)
	-- self.nodeEffectLogin:setVisible(isCanGetTotleReward or isCanGetSeriesReward)
end
--更新等级提醒
function PVActivityPage:updateRankNotice()
	local cell = self:findCellById(RANK)
	if cell == nil then return end
	local isCanGetLevelReward = self.commonData:getIsCanGetLevelReward()
	cell.redDot:setVisible(isCanGetLevelReward)
	cell.effNode:setVisible(isCanGetLevelReward)
	 -- self.redDotRank:setVisible(isCanGetLevelReward)
	 -- self.nodeEffectRank:setVisible(isCanGetLevelReward)
end
--更新单次充值提醒
function PVActivityPage:updateRechargeSingleNotice()
	local cell = self:findCellById(RECHARGE_S)
	if cell == nil then return end
	local isCanRechargeReward = self.commonData:giftCanGetByType(8)
	cell.redDot:setVisible(isCanRechargeReward)
	cell.effNode:setVisible(isCanRechargeReward)
	
end
--更新累计充值提醒
function PVActivityPage:updateRechargeAccNotice()
	local cell = self:findCellById(RECHARGE_A)
	if cell == nil then return end
	local isCanRechargeReward = false
	if self.reAccList == nil then self.reAccList = self.baseTemp:getRchargeAcc() end
    for k,v in pairs(self.reAccList) do
    	if not self.commonData:rechargeGiftIsGot(v.id) and (self.commonData:getRechargeAcc() >= v.parameterA) then
    		isCanRechargeReward = true
    	end
    end
	cell.redDot:setVisible(isCanRechargeReward)
	cell.effNode:setVisible(isCanRechargeReward)

end
--更新每日充值提醒
function PVActivityPage:updateRechargeDayNotice()
	local cell = self:findCellById(RECHARGE_F)
	if cell == nil then return end
	local isCanRechargeReward = self.commonData:giftCanGetByType(10)
	cell.redDot:setVisible(isCanRechargeReward)
	cell.effNode:setVisible(isCanRechargeReward)
	
end

function PVActivityPage:initLableTitle()
	self.tabTitle = {}
	-- self.tabTitle[1] = {id = SIGN, selected = false, redshow = false}
	-- self.tabTitle[2] = {id = STAMINA, selected = false, redshow = false}
	-- self.tabTitle[3] = {id = LOGIN, selected = false, redshow = false}
	-- self.tabTitle[4] = {id = RANK, selected = false, redshow = false}
	-- self.tabTitle[5] = {id = BREW, selected = false, redshow = false}
	self.tabTitle[1] = {id = STAMINA, selected = false, redshow = false}
	self.tabTitle[2] = {id = LOGIN, selected = false, redshow = false}
	self.tabTitle[3] = {id = RANK, selected = false, redshow = false}
	self.tabTitle[4] = {id = BREW, selected = false, redshow = false}
	self.tabTitle[5] = {id = VIPGIFT, selected = false, redshow = false}
	
	local tmTab1 = {id = RECHARGE_F, selected = false, redshow = false}
	local tmTab2 = {id = RECHARGE_HF, selected = false, redshow = false}
	local tmTab3 = {id = RECHARGE_A, selected = false, redshow = false}
	local tmTab4 = {id = RECHARGE_S, selected = false, redshow = false}

    local startTime,endTime = self.commonData:analysisTime(self.baseTemp:getTimeDayFirst())
    if self:rechargeIsOpened(startTime,endTime) then
    	self.dayChongTimeLabel:setString(string.format("%d年%d月%d日-%d年%d月%d日",startTime.year,startTime.month,startTime.day,endTime.year,endTime.month,endTime.day))
    	table.insert(self.tabTitle,tmTab1)
    end

    startTime,endTime = self.commonData:analysisTime(self.baseTemp:getTimeHisFirst())
    if self:rechargeIsOpened(startTime,endTime) then
    	table.insert(self.tabTitle,tmTab2)
    end
    startTime,endTime = self.commonData:analysisTime(self.baseTemp:getTimeAcc())
	if self:rechargeIsOpened(startTime,endTime) then
		self.nChongTimeLabel:setString(string.format("%d年%d月%d日-%d年%d月%d日",startTime.year,startTime.month,startTime.day,endTime.year,endTime.month,endTime.day))
		table.insert(self.tabTitle,tmTab3)
	end
	startTime,endTime = self.commonData:analysisTime(self.baseTemp:getTimeSingle())
	if self:rechargeIsOpened(startTime,endTime) then
		self.oneChongTimeLabel:setString(string.format("%d年%d月%d日-%d年%d月%d日",startTime.year,startTime.month,startTime.day,endTime.year,endTime.month,endTime.day))
		table.insert(self.tabTitle,tmTab4)
	end
    
end

function PVActivityPage:updateLabelTitle(posidx)
	if self.tabTitle == nil then return end
	for k,v in pairs(self.tabTitle) do 
		if v.id == posidx then 
			v.selected = true 
		else
			v.selected = false
		end 
	end
end
--判断充值活动是否开启
function PVActivityPage:rechargeIsOpened(startTime,endTime)
	local curTime = self.commonData:getTime()
	local startNum = os.time{year = startTime.year,month = startTime.month,day = startTime.day,hour = startTime.hour,min = startTime.min,sec = startTime.sec }
	local endNum = os.time{year = endTime.year,month = endTime.month,day = endTime.day,hour = endTime.hour,min = endTime.min,sec = endTime.sec }
	if curTime >= startNum and curTime <= endNum then
		return true
	end
	return false
end
function PVActivityPage:checkArrowShow()
	if self.mainTableView == nil then return end 
	local pos = self.mainTableView:getContentOffset()
	local addnum = roundNumber(pos.x/(-110))
	local cellNum = 5 + addnum
	self.menuArrowLeft:setVisible(true)
	self.menuArrowRight:setVisible(true) 
	if cellNum >= table.getn(self.tabTitle) then 
		self.menuArrowRight:setVisible(false) 
	end
	if pos.x%(-110) ~= 0 then cellNum = cellNum + 1 end
	if cellNum <= 5 then 
		self.menuArrowLeft:setVisible(false) 
	end
	
end
-- 创建精彩活动的主标签列表
function PVActivityPage:createActivityTableView()
	self.tabCell = {}
	 local function tableCellTouched(tbl, cell)
        -- self:updateMenu(cell.id)
        if cell.id == SIGN then 
    		getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSignEveryDay")
    	else
    		self:updateMenu(cell.id)
    	end
        for k,v in pairs(self.tabCell) do
        	if v.id == cell.id then
        		v.selected = true
        		v.normalSpr:setVisible(false)
        		v.selectedSpr:setVisible(true)
        		v.sprDirection:setVisible(true)
        	else
        		v.selected = false
        		v.normalSpr:setVisible(true)
        		v.selectedSpr:setVisible(false)
        		v.sprDirection:setVisible(false)
        	end
        end
        -- self.mainTableView:reloadData()
    end

	local function numberOfCellsInTableView(tab)
	 	for k,v in pairs(self.tabCell) do
        	if v.selected then
        		v.normalSpr:setVisible(false)
        		v.selectedSpr:setVisible(true)
        		v.sprDirection:setVisible(true)
        	else
        		v.normalSpr:setVisible(true)
        		v.selectedSpr:setVisible(false)
        		v.sprDirection:setVisible(false)
        	end
        end
        self:updateEatNotice()
	    self:updateLoginNotice()
	    self:updateWineNotice()
	    -- self:updateSineNotice()
	    self:updateRankNotice()
	    self:updateRechargeDayNotice()
	    self:updateRechargeAccNotice()
	    self:updateRechargeSingleNotice()
	    self:updataVipGiftMenu()

	    self:checkArrowShow()
       return table.getn(self.tabTitle)
    end
    local function cellSizeForTable(tbl, idx)
    	if table.getn(self.tabTitle) < 5 then
    		return 128,136
    	else
        	return 128,110
        end
    end
    local function tableCellAtIndex(tbl, idx)

        local cell = tbl:dequeueCell()
        local label = nil
        print("tableCellAtIndex=======",idx,cell == nil)
        if nil == cell then
            cell = cc.TableViewCell:new()
            table.insert(self.tabCell,cell)

            local function onMenuClick()
            	-- self:updateMenu(cell.id)
            	if cell.id == SIGN then 
            		getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSignEveryDay")
            	else
            		self:updateMenu(cell.id)
            	end
            	cell.selected = true
            end
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UIActivityNodeMenu"] = {}
            cell.itemInfo["UIActivityNodeMenu"]["onMenuClick"] = onMenuClick
            local node = CCBReaderLoad("home/ui_activity_node2.ccbi", proxy, cell.itemInfo)
            node:setPositionY(node:getPositionY()-27)
            cell:addChild(node)
            cell.menuBtn = cell.itemInfo["UIActivityNodeMenu"]["menuBtn"]
		    cell.tubiaoSp = cell.itemInfo["UIActivityNodeMenu"]["tubiaoSp"]
		    cell.sprDirection = cell.itemInfo["UIActivityNodeMenu"]["sprDirection"]
			cell.tubiaoNameSp = cell.itemInfo["UIActivityNodeMenu"]["tubiaoNameSp"]
			cell.redDot = cell.itemInfo["UIActivityNodeMenu"]["redDot"]
			cell.effNode = cell.itemInfo["UIActivityNodeMenu"]["Effect_sign"]
			cell.normalSpr = cell.itemInfo["UIActivityNodeMenu"]["normalSpr"]
		    cell.selectedSpr = cell.itemInfo["UIActivityNodeMenu"]["selectedSpr"]

			-- cell.id = self.tabTitle[idx+1].id 
   --      	cell.selected = self.tabTitle[idx+1].selected
   --      	cell.redshow = self.tabTitle[idx+1].redshow
        end

        if cell.effNode:getChildByTag(100) ~= nil then --先移除效果，再把效果给加上，这是因为TableView共用一些Node，效果可能会重叠 先实现
        	cell.effNode:removeChildByTag(100,true)
        end
        local eff = createEffect(90,90)
		eff:setPosition(cc.p(-42,-42))
		eff:setTag(100)
		cell.effNode:addChild(eff)

        cell.id = self.tabTitle[idx+1].id
        cclog("vipgiftData"..cell.id)
        cell.selected = self.tabTitle[idx+1].selected
        cell.redshow = self.tabTitle[idx+1].redshow

        if cell.selected then
        	cell.normalSpr:setVisible(false)
        	cell.selectedSpr:setVisible(true)
        	cell.sprDirection:setVisible(true)
        else
        	cell.normalSpr:setVisible(true)
        	cell.selectedSpr:setVisible(false)
        	cell.sprDirection:setVisible(false)
       	end

       	if cell.redshow then
        	cell.redDot:setVisible(true)
        else
        	cell.redDot:setVisible(false)
       	end
       	local str = string.format("#ui_activity_norpic_0%02d.png", cell.id)
       	game.setSpriteFrame(cell.normalSpr,str)
       	str = string.format("#ui_activity_selpic_0%02d.png", cell.id)
       	game.setSpriteFrame(cell.selectedSpr,str)
       	local strName = string.format("#ui_activity_s_0%02d.png", cell.id)

       	-- game.setSpriteFrame(cell.tubiaoSp,str)
       	game.setSpriteFrame(cell.tubiaoNameSp,strName)
        return cell
    end

    local layerSize = self.upMenuLayer:getContentSize()
    self.mainTableView = cc.TableView:create(layerSize)
    self.mainTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.mainTableView:setDelegate()
    self.mainTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.upMenuLayer:addChild(self.mainTableView)

    self.mainTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.mainTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.mainTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.mainTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    self.mainTableView:reloadData()
end

function PVActivityPage:findCellById(id)
	if self.tabCell == nil then
		return
	end
	for k,v in pairs(self.tabCell) do 
		if v.id == id then
			return v
		end
	end
end

-- 初始化数据
function PVActivityPage:initData()
	self.jz_flag = false    --初始化标志金樽煮酒的flag
	---- 体力相关 ----
	local function onToTime(strTime) -- 解析出时间
		local _len = string.len(strTime)
		local _posS, _posE = string.find(strTime, ":")
		if _posS == _posE then
			local _hour = tonumber(string.sub(strTime, 1, _posS-1))
			local _min = tonumber(string.sub(strTime, _posS+1, _len))
			return _hour, _min
		else
			print("!!!base_config表中manual_time有数据错误")
		end
	end

	self._stamina_value = self.baseTemp:getManualValue()
	self._stamina_time = self.baseTemp:getManualTime()
	
	local _timeNum = #self._stamina_time
	if _timeNum == 1 then
		self.labelTime2:setVisible(false)
		self.labelTime3:setVisible(false)
	elseif _timeNum == 2 then
		self.labelTime3:setVisible(false)
	end
	self._timeCanGet = {}  -- 保存可领取体力的时间{{startHour,startMin,endedHour,endedMin}...}
	for k,v in pairs(self._stamina_time) do
		local str = v[1] .. "-" .. v[2]
		self.labelTime[k]:setString(str)
		self._timeCanGet[k] = {}
		self._timeCanGet[k].startHour,
        self._timeCanGet[k].startMin = onToTime(v[1])
		self._timeCanGet[k].endedHour,
        self._timeCanGet[k].endedMin = onToTime(v[2])
	end
	table.print(self._timeCanGet)

	self:updateStaminaView() -- 更新体力界面
end

-- 创建登录奖励的tableview
function PVActivityPage:createLoginTableView()
	local function tableCellTouched(tbl, cell)
		self.cell = cell
	end

	local function numberOfCellsInTableView(tab)
       return table.getn(self.loginList)
    end
    local function cellSizeForTable(tbl, idx)
        return 260,640
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onMenuClick()
            	if self.loginFlag then 
            		self.loginFlag = false
	            	getAudioManager():playEffectButton2()
	            	cclog("^^^^^^^^ 领取 ", cell.type, cell.id)
	            	local activityNet = getNetManager():getActivityNet()
	            	ACTIVITY_GIFTID = cell.id
	            	ACTIVITY_LOGIN_TYPE = cell.type
	            	-- if cell.type == 3 then
	            	-- 	activityNet:sendGetLevelGift(cell.id)
	            	if cell.type == 2 then
	            		activityNet:sendGetLoginGiftMsg(cell.id, 2)
	            	elseif cell.type == 1 then
	            		activityNet:sendGetLoginGiftMsg(cell.id, 1)
	            	end
	            	self.loginDropList = cell.dropList
	            	
	            end
            end
            local function arrowRightClick()
            	local childTab = cell.layerView:getChildren()
            	for k,v in pairs(childTab) do
            		local pos = v:getContentOffset()
            		local addnum = roundNumber(pos.x/(-120))
            		local cellNum = 4 + addnum
            		if cellNum < table.getn(cell.dropList) then
            			cellNum = cellNum + 1
            			if cellNum >= table.getn(cell.dropList) then cell.arrowRight:setVisible(false) end
            			cell.arrowLeft:setVisible(true)
            			v:setContentOffset((cc.p(-120*(cellNum - 4),0)))
            			
            		end
            	end
            end
            local function arrowLeftClick()
            	local childTab = cell.layerView:getChildren()
            	for k,v in pairs(childTab) do
            		local pos = v:getContentOffset()
            		local addnum = roundNumber(pos.x/(-120))
            		local cellNum = 4 + addnum
            		if pos.x%(-120) ~= 0 then cellNum = cellNum + 1 end
            		if cellNum > 4 then 
            			cellNum = cellNum - 1
            			if cellNum <= 4 then cell.arrowLeft:setVisible(false) end
            			cell.arrowRight:setVisible(true)
            			v:setContentOffset((cc.p(-120*(cellNum - 4),0)))
            		end
            	end
            end
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UILoginItem"] = {}
            cell.itemInfo["UILoginItem"]["MenuClick"] = onMenuClick
            cell.itemInfo["UILoginItem"]["arrowRightClick"] = arrowRightClick
            cell.itemInfo["UILoginItem"]["arrowLeftClick"] = arrowLeftClick
            local node = CCBReaderLoad("home/ui_activity_prizeItem_new.ccbi", proxy, cell.itemInfo)

            cell:addChild(node)
		    -- cell.labelTitle = cell.itemInfo["UILoginItem"]["label_title"]
		    cell.layerMask = cell.itemInfo["UILoginItem"]["layer_mask"]
		    cell.imgTitle = cell.itemInfo["UILoginItem"]["img_title"]
			cell.layerView = cell.itemInfo["UILoginItem"]["layer_tableview"]
			cell.arrowRight = cell.itemInfo["UILoginItem"]["img_arrow_right"]
			cell.arrowLeft = cell.itemInfo["UILoginItem"]["img_arrow_left"]
			cell.menuGet = cell.itemInfo["UILoginItem"]["menu_btn"]
			cell.nodeTitle = cell.itemInfo["UILoginItem"]["node_label"]

			-- local labelTitle = cc.LabelAtlas:_create("10", "res/ui/ui_common_num.png", 20, 34, string.byte("0"))
			local imagNum = game.newSprite("#ui_common_rank_reward_1.png")
			imagNum:setAnchorPoint(0.5,0.5)
			cell.nodeTitle:addChild(imagNum)
			imagNum:setPosition(cc.p(-24,0))
			imagNum:setTag(1001)
        end

        local _type = self.loginList[idx+1].type
        local _premise = self.loginList[idx+1].parameterA     --参数A
        local _reward = self.loginList[idx+1].reward          --奖励
        local _id = self.loginList[idx+1].id                  --id
        local _title = nil  -- 奖励名字
        local _isGot = false  -- 是否已获得
        local _isCanGet = false -- 是否能获得
        cell.type = _type
        cell.id = _id
        cell.reward = _reward
        if _type == 1 then
        	game.setSpriteFrame(cell.imgTitle,"#ui_activity_ljdl_gift.png")
        	_title = Localize.query("activity.2")
        	_isGot = self.commonData:isGetLoginTotalGift(_id)
        	if self.commonData:getLoginTotalDay() >= _premise then _isCanGet = true end
        elseif _type == 2 then
        	game.setSpriteFrame(cell.imgTitle,"#ui_activity_lxdl_gift.png")
        	_title = Localize.query("activity.3")
        	_isGot = self.commonData:isGetLoginContinueGift(_id)
        	if self.commonData:getLoginContinueDay() >= _premise then _isCanGet = true end
        end
		game.setSpriteFrame(cell.nodeTitle:getChildByTag(1001),string.format("#ui_common_rank_reward_%d.png",_premise))   
		
		local img1,img2,img3
		if _isCanGet then
			if _isGot then
				img1 = game.newSprite("#ui_activity_isgot.png")
				img2 = game.newSprite("#ui_activity_isgot.png")
				img3 = game.newSprite("#ui_activity_isgot.png")
				cell.menuGet:setEnabled(false)
				cell.layerMask:setVisible(true)
				-- cell.menuGet:setSelectedImage(img1)
				cell.menuGet:setNormalImage(img2)
				cell.menuGet:setDisabledImage(img3)
				cell.menuGet:setSelectedImage(img1)
			else
				img1 = game.newSprite("#ui_activity_get.png")
				img2 = game.newSprite("#ui_activity_get.png")
				img3 = game.newSprite("#ui_activity_get.png")
				cell.menuGet:setEnabled(true)
				cell.layerMask:setVisible(false)
				cell.menuGet:setNormalImage(img2)
				cell.menuGet:setDisabledImage(img3)
				cell.menuGet:setSelectedImage(img1)
				
			end
			
		else
			img1 = game.newSprite("#ui_activity_unachieve.png")
			img2 = game.newSprite("#ui_activity_unachieve.png")
			img3 = game.newSprite("#ui_activity_unachieve.png")
			cell.menuGet:setEnabled(false)
			cell.layerMask:setVisible(false)
			-- cell.menuGet:setSelectedImage(img1)
			cell.menuGet:setNormalImage(img2)
			cell.menuGet:setDisabledImage(img3)
			cell.menuGet:setSelectedImage(img1)
		end

		for k,v in pairs(_reward) do
	    	cell.dropList = self:getDropList(v[3])
		end

		table.print(cell.dropList)
		self:createDropList(cell.dropList,cell.layerView)
		if table.getn(cell.dropList) <= 4 then 
			cell.arrowRight:setVisible(false)
			cell.arrowLeft:setVisible(false)
		else
			cell.arrowRight:setVisible(true)
			cell.arrowLeft:setVisible(false)
		end
		print("===== function tableCellAtIndex")
        return cell
    end

    local layerSize = self.loginView:getContentSize()
    self.loginTableView = cc.TableView:create(layerSize)
    self.loginTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.loginTableView:setDelegate()
    self.loginTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.loginView:addChild(self.loginTableView)

    self.loginTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.loginTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.loginTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.loginTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.loginTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.loginView:addChild(scrBar,2)

    self.loginTableView:reloadData()
end
function PVActivityPage:loginListSort()
 	for k,v in pairs(self.loginList) do
        local canget = false
        local isgot = false
        if v.type == 1 then
        	isgot = getDataManager():getCommonData():isGetLoginTotalGift(v.id)
            canget = (not getDataManager():getCommonData():isGetLoginTotalGift(v.id)) and (getDataManager():getCommonData():getLoginTotalDay() >= v.parameterA)   
        elseif v.type == 2 then
        	isgot = getDataManager():getCommonData():isGetLoginContinueGift(v.id)
            canget = (not getDataManager():getCommonData():isGetLoginContinueGift(v.id)) and (getDataManager():getCommonData():getLoginContinueDay() >= v.parameterA)
        end
        self.loginList[k].canget = canget
        self.loginList[k].isgot = isgot
    end
	local function cmp(a,b)
        if a.canget == true and b.canget == false then return true 
        elseif a.canget == false and b.canget == true then return false
      --   elseif a.canget == false and b.canget == false then
      --   	if a.isgot == false and b.isgot == true then return true
    		-- elseif a.isgot == true and b.isgot == false then return false
    		-- else
    		-- 	if a.type < b.type then return true
	     --        elseif a.type == b.type then
	     --            if a.parameterA < b.parameterA then return true
	     --            else return false end
	     --        else return false
	     --        end
    		-- end 
        else
        	if a.isgot == false and b.isgot == true then return true
    		elseif a.isgot == true and b.isgot == false then return false
    		else
    			if a.type < b.type then return true
	            elseif a.type == b.type then
	                if a.parameterA < b.parameterA then return true
	                else return false end
	            else return false
	            end
    		end 
        end
    end
    table.sort( self.loginList, cmp )
end
function PVActivityPage:getDG(lay,dropId,arrow)
	local _smallDrop = self.dropTemp:getBigBagById(dropId).smallPacketId
	lay:removeAllChildren()
	for ky,_smallDropId in pairs(_smallDrop) do
		-- cclog("dropId===="..dropId.."ky======="..ky.."_smallDropId======".._smallDropId)
		local proxy = cc.CCBProxy:create()
		local itemInfo = {}
		local node = CCBReaderLoad("common/ui_card_withnumber_new.ccbi", proxy, itemInfo)
		lay:addChild(node,ky)
		local labelNum = itemInfo["UICommonGetCard"]["label_number"]
		local img = itemInfo["UICommonGetCard"]["img_card"]
		local contentSize = node:getContentSize()
		node:setPositionX((ky-1) * contentSize.width)
		if ky > 3 then
			node:setVisible(false)
			arrow:setVisible(true)
		end

		local _itemList = self.dropTemp:getAllItemsByDropId(_smallDropId)
		-- 查出物品类型type,分类处理1，继续查表 2，直接获取图片
	    local _index = 1
	    for k,v in pairs(_itemList) do  -- _itemList = {[1]={type = v.type, detailId = v.detailID},...}
	        if v.type < 100 then  -- 可直接读的资源图
	            local _icon = self.resourceTemp:getResourceById(v.type)
	            setItemImage(img, "#".._icon, 1)
	        else  -- 需要继续查表
	            if v.type == 101 then -- 武将
	                local _temp = self.soldierTemp:getSoldierIcon(v.detailId)
	                local quality = self.soldierTemp:getHeroQuality(v.detailId)
	                changeNewIconImage(img,_temp,quality)
	            elseif v.type == 102 then -- equpment
	                local _temp = self.equipTemp:getEquipResIcon(v.detailId)
	                local quality = self.equipTemp:getQuality(v.detailId)
	                changeEquipIconImageBottom(img, _temp, quality)
	            elseif v.type == 103 then -- hero chips
	                local _temp = self.chipTemp:getTemplateById(v.detailId).resId
	                local _icon = self.resourceTemp:getResourceById(_temp)
	                local quality = self.chipTemp:getTemplateById(v.detailId).quality
	                setChipWithFrame(img,"res/icon/hero/".._icon, quality)
	            elseif v.type == 104 then -- equipment chips
	                local _temp = self.chipTemp:getTemplateById(v.detailId).resId
	                local _icon = self.resourceTemp:getResourceById(_temp)
	                local quality = self.chipTemp:getTemplateById(v.detailId).quality
	                setChipWithFrame(img,"res/icon/equipment/".._icon, quality)
	            elseif v.type == 105 then  -- item
	                local _temp = self.bagTemp:getItemResIcon(v.detailId)
	                local quality = self.bagTemp:getItemQualityById(v.detailId)
	                setCardWithFrame(img,"res/icon/item/".._temp, quality)
	            end
	        end
	        labelNum:setString("X "..v.count)
	    end
	end
end

--创建等级奖励的tableview
function PVActivityPage:createRankTableView()
	local function tableCellTouched(tbl, cell)
		self.cell = cell
	end

	local function numberOfCellsInTableView(tab)
       return table.getn(self.rankList)
    end
    local function cellSizeForTable(tbl, idx)
        return 260,640
    end
    local function tableCellAtIndex(tbl, idx)
    	-- print("-=-=-=-===创建等级奖励的tableview-------")
        local cell = tbl:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onMenuClick()
            	if self.rankFlag then          --防止其点击两个，只获得一个
            		self.rankFlag = false
	            	getAudioManager():playEffectButton2()
	            	cclog("vvvvvvvvvv 领取 ", cell.type, cell.id)
	            	local activityNet = getNetManager():getActivityNet()
	            	ACTIVITY_GIFTID = cell.id
	            	ACTIVITY_LOGIN_TYPE = cell.type
	            	--if cell.type == 3 then
	            	activityNet:sendGetLevelGift(cell.id)
	            	
	            	self.rankDropList = cell.dropList
	            	
	            end
            end
            local function arrowRightClick()
            	local childTab = cell.layerView:getChildren()
            	for k,v in pairs(childTab) do
            		local pos = v:getContentOffset()
            		local addnum = roundNumber(pos.x/(-120))
            		local cellNum = 4 + addnum
            		if cellNum < table.getn(cell.dropList) then
            			cellNum = cellNum + 1
            			if cellNum >= table.getn(cell.dropList) then cell.arrowRight:setVisible(false) end
            			cell.arrowLeft:setVisible(true)
            			v:setContentOffset((cc.p(-120*(cellNum - 4),0)))
            			
            		end
            	end
            end
            local function arrowLeftClick()
            	local childTab = cell.layerView:getChildren()
            	for k,v in pairs(childTab) do
            		local pos = v:getContentOffset()
            		local addnum = roundNumber(pos.x/(-120))
            		local cellNum = 4 + addnum
            		if pos.x%(-120) ~= 0 then cellNum = cellNum + 1 end
            		if cellNum > 4 then 
            			cellNum = cellNum - 1
            			if cellNum <= 4 then cell.arrowLeft:setVisible(false) end
            			cell.arrowRight:setVisible(true)
            			v:setContentOffset((cc.p(-120*(cellNum - 4),0)))
            		end
            	end
            end
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UILoginItem"] = {}
            cell.itemInfo["UILoginItem"]["MenuClick"] = onMenuClick
            cell.itemInfo["UILoginItem"]["arrowRightClick"] = arrowRightClick
            cell.itemInfo["UILoginItem"]["arrowLeftClick"] = arrowLeftClick
            local node = CCBReaderLoad("home/ui_activity_prizeItem_new.ccbi", proxy, cell.itemInfo)

            cell:addChild(node)
		    cell.layerMask = cell.itemInfo["UILoginItem"]["layer_mask"]
		    cell.imgTitle = cell.itemInfo["UILoginItem"]["img_title"]
			cell.layerView = cell.itemInfo["UILoginItem"]["layer_tableview"]
			cell.arrowRight = cell.itemInfo["UILoginItem"]["img_arrow_right"]
			cell.arrowLeft = cell.itemInfo["UILoginItem"]["img_arrow_left"]
			cell.menuGet = cell.itemInfo["UILoginItem"]["menu_btn"]
			cell.nodeTitle = cell.itemInfo["UILoginItem"]["node_label"]

			local labelTitle = cc.LabelAtlas:_create("10", "res/ui/ui_common_num.png", 20, 34, string.byte("0"))
			cell.nodeTitle:addChild(labelTitle)
			labelTitle:setAnchorPoint(cc.p(0.5,0.5))	
			labelTitle:setTag(1001)
        end

        local _type = self.rankList[idx+1].type
        local _premise = self.rankList[idx+1].parameterA     --参数A
        local _reward = self.rankList[idx+1].reward          --奖励
        local _id = self.rankList[idx+1].id                  --id
        local _title = nil  -- 奖励名字
        local _isGot = false  -- 是否已获得
        local _isCanGet = false -- 是否能获得
        cell.type = _type
        cell.id = _id
        cell.reward = _reward
        if _type == 3 then
            _title = Localize.query("activity.4")
            _isGot = self.commonData:isGetLevelGift(_id)
            if self.commonData:getLevel() >= _premise then _isCanGet = true end    --type==3即是等级奖励
        end
  --       _title = string.format(_title, _premise)
		-- cell.labelTitle:setString(_title)
		cell.nodeTitle:getChildByTag(1001):setString(_premise)

		local img1,img2,img3
		if _isCanGet then
			
			if _isGot then
				img1 = game.newSprite("#ui_activity_isgot.png")
				img2 = game.newSprite("#ui_activity_isgot.png")
				img3 = game.newSprite("#ui_activity_isgot.png")
				cell.menuGet:setEnabled(false)
				cell.layerMask:setVisible(true)
			else
				img1 = game.newSprite("#ui_activity_get.png")
				img2 = game.newSprite("#ui_activity_get.png")
				img3 = game.newSprite("#ui_activity_get.png")
				cell.menuGet:setEnabled(true)
				cell.layerMask:setVisible(false)
			end
			
		else
			img1 = game.newSprite("#ui_activity_unachieve.png")
			img2 = game.newSprite("#ui_activity_unachieve.png")
			img3 = game.newSprite("#ui_activity_unachieve.png")
			cell.menuGet:setEnabled(false)
			cell.layerMask:setVisible(false)
			
		end

		cell.menuGet:setNormalImage(img2)
		cell.menuGet:setDisabledImage(img3)
		cell.menuGet:setSelectedImage(img1)

		-- if _isGot == false then
		-- 	local img = game.newSprite("#ui_activity_s_8.png")
		-- 	cell.menuGet:setSelectedImage(img)
		-- else
		-- 	local img = game.newSprite("#ui_activity_s_7.png")
		-- 	cell.menuGet:setSelectedImage(img)
		-- end
		-- if _isCanGet == true and _isGot == false then
		--     cell.menuGet:setEnabled(true)
		-- else
		-- 	cell.menuGet:setEnabled(false)
		-- end
		-- cell.arrowRight:setVisible(false)

		for k,v in pairs(_reward) do
	    	cell.dropList = self:getDropList(v[3])
		end
		self:createDropList(cell.dropList,cell.layerView)
		if table.getn(cell.dropList) <= 4 then 
			cell.arrowRight:setVisible(false)
			cell.arrowLeft:setVisible(false)
		else
			cell.arrowRight:setVisible(true)
			cell.arrowLeft:setVisible(false)
		end


        return cell
    end

    local layerSize = self.rankView:getContentSize()
    self.rankTableView = cc.TableView:create(layerSize)
    self.rankTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.rankTableView:setDelegate()
    self.rankTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.rankView:addChild(self.rankTableView)

    self.rankTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.rankTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.rankTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.rankTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.rankTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.rankView:addChild(scrBar,2)

    self.rankTableView:reloadData()
end
function PVActivityPage:rankListSort()
 	for k,v in pairs(self.rankList) do
        local canget = (not self.commonData:isGetLevelGift(v.id)) and (self.commonData:getLevel() >= v.parameterA)   
        local isgot = self.commonData:isGetLevelGift(v.id)
        self.rankList[k].canget = canget
        self.rankList[k].isgot = isgot
    end
	local function cmp(a,b)
        if a.canget == true and b.canget == false then return true 
        elseif a.canget == false and b.canget == true then return false
        else
        	if a.isgot == false and b.isgot == true then return true
    		elseif a.isgot == true and b.isgot == false then return false
    		else
    			if a.type < b.type then return true
	            elseif a.type == b.type then
	                if a.parameterA < b.parameterA then return true
	                else return false end
	            else return false
	            end
    		end 
        end
    end
    table.sort( self.rankList, cmp )
end

--对下面所注册的方法的一个改善，为了兼容接口
function PVActivityPage:createDropList(tabList,layerView)
	layerView:removeAllChildren()

    local function tableCellTouched(tbl, cell)
        cclog("cell item ================ ")
        local reward = tabList[cell:getIdx() + 1]
        table.print(reward)
        for k,v in pairs(reward) do
	        if tonumber(k) < 100 then  -- 可直接读的资源图
	            if k == "2" then
	                getOtherModule():showOtherView("PVCommonDetail", 2, tonumber(k), 2)
	            else
	                getOtherModule():showOtherView("PVCommonDetail", 2, tonumber(k), 1)
	            end
	        elseif k == "101" then -- 武将
	            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", v[3], 1, nil, nil)
	        elseif k == "102" then -- 装备
	             -- print("v.dropDetailId ============ ", v[3])
	            local equipment = getTemplateManager():getEquipTemplate():getTemplateById(v[3])
	            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, nil)
	        elseif k == "103" then -- 武将碎片
	            local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(v[3])
	            getOtherModule():showOtherView("PVCommonChipDetail", 1, v[3], nowPatchNum, 1)
	        elseif k == "104" then -- 装备碎片
	            local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(v[3])
	            -- print("nowPatchNum ======== nowPatchNum ========== ", nowPatchNum)
	            getOtherModule():showOtherView("PVCommonChipDetail", 2, v[3], nowPatchNum, 1)
	        elseif k == "105" then  -- 道具
	            getOtherModule():showOtherView("PVCommonDetail", 1, v[3], 1)
            elseif k == "107" then
		    	getOtherModule():showOtherView("PVCommonDetail", 2, v[3], 1)
		    elseif k == "108" then
	            local runeItem = {}
	            runeItem.runt_id = v[3]
	            runeItem.inRuneType = getTemplateManager():getStoneTemplate():getStoneItemById(v[3]).type
	            runeItem.runePos = 0
	            getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)
	        end
	    end
    end

	local function numberOfCellsInTableView(tab)
		-- cclog("这里是创建掉落列表"..table.getn(tabList))
		if self.cell == nil then return table.getn(tabList) end 
		local childTab = self.cell.layerView:getChildren()
		for k,v in pairs(childTab) do
			local pos = v:getContentOffset()
			local addnum = roundNumber(pos.x/(-120))
			local cellNum = 4 + addnum
			self.cell.arrowRight:setVisible(true)
			self.cell.arrowLeft:setVisible(true)
			if cellNum >= table.getn(self.cell.dropList) then
				self.cell.arrowRight:setVisible(false)
			end
			if pos.x%(-120) ~= 0 then cellNum = cellNum + 1 end
			if cellNum <= 4 then 
				self.cell.arrowLeft:setVisible(false)
			end
		end

       return table.getn(tabList)
    end
    local function cellSizeForTable(tbl, idx)
    	-- cclog("-------cellSizeForTable-----"..idx)
        return 105,120
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
	        cell.itemInfo = {}
	        local proxy = cc.CCBProxy:create()
	        cell.itemInfo["UICommonGetCard"] = {}
	        local node = CCBReaderLoad("common/ui_card_withnumber_new.ccbi", proxy, cell.itemInfo)
	        -- node:setScale(0.85)
	        cell:addChild(node)
		    cell.img = cell.itemInfo["UICommonGetCard"]["img_card"]
			cell.labelNum = cell.itemInfo["UICommonGetCard"]["label_number"]
			cell.labelName = cell.itemInfo["UICommonGetCard"]["element_name"]
			node:setPositionY(node:getPositionY()-10)
        end

        local reward = tabList[idx+1]
        local name = ""
        for k,v in pairs(reward) do
	        --index = index + 1
	        if k == "101" then -- hero
	            local _temp = self.soldierTemp:getSoldierIcon(v[3])
	            local quality = self.soldierTemp:getHeroQuality(v[3])
	            name = self.soldierTemp:getHeroName(v[3])
	            changeNewIconImage(cell.img, _temp, quality)
	            -- cell.labelNum:setString("X "..v[1])
	        elseif k == "102" then -- equipment
	            local _temp = self.equipTemp:getEquipResIcon(v[3])
	            local quality = self.equipTemp:getQuality(v[3])
	            name = self.equipTemp:getEquipName(v[3])
	            changeEquipIconImageBottom(cell.img, _temp, quality)
	            -- cell.labelNum:setString("X "..v[1])
	        elseif k == "103" then -- hero chip
	            local _temp = self.chipTemp:getTemplateById(v[3]).resId
	            local _icon = self.resourceTemp:getResourceById(_temp)
	            local _quality = self.chipTemp:getTemplateById(v[3]).quality
	            name = self.chipTemp:getChipName(v[3])
	            -- setChipWithFrame(cell.img, "res/icon/hero/".._icon, _quality)
	            changeHeroChipIconBottom(cell.img, _icon, _quality)
	           	-- cell.labelNum:setString("X "..v[1])
	        elseif k == "104" then -- equipment chip
	            local _temp = self.chipTemp:getTemplateById(v[3]).resId
	            local _icon = self.resourceTemp:getResourceById(_temp)
	            local quality = self.chipTemp:getTemplateById(v[3]).quality
	            name = self.chipTemp:getChipName(v[3])
	            -- setChipWithFrame(cell.img, "res/icon/equipment/".._icon, quality)
	            changeEquipChipIconImageBottom(cell.img, _icon, quality)
	            -- cell.labelNum:setString("X "..v[1])
	        elseif k == "105" then -- item
	            _temp = self.bagTemp:getItemResIcon(v[3])
	            local quality = self.bagTemp:getItemQualityById(v[3])
	            name = self.bagTemp:getItemName(v[3])
	            -- setItemImage(cell.img, "res/icon/item/".._temp, quality)
	            setItemImageNew(cell.img, "res/icon/item/".._temp, quality)
	           -- cell.labelNum:setString("X "..v[1])
	        elseif k == "106" then -- big_bag
	        	--这个大包应该不会用到了吧
	            --self:getDropBag(cell.img, cell.labelNum, v[3])
	    
	        elseif k == "107" then
                local _res = self.resourceTemp:getResourceById(v[3])
                name = self.resourceTemp:getResourceName(v[3])
                setItemImageNew(cell.img, "res/icon/resource/".._res, 1)
                -- cell.labelNum:setString("X" .. v[1])
            elseif k == "108" then
            	local res,quality= self.stoneTemp:getStoneIconByID(v[3])
            	name = self.stoneTemp:getStoneNameByID(v[3])
            	setItemImageNew(cell.img, res, quality)
            	-- cell.labelNum:setString("X" .. v[1])
	        else
	            local _res = self.resourceTemp:getResourceById(k)
	            print("GGGGG", _res)
	            name = self.resourceTemp:getResourceName(v[3])
	            -- setItemImageNew(cell.img, "#".._res, 1)
	            setItemImageNew(cell.img, "res/icon/resource/".._res, 1)
	            -- cell.labelNum:setString("X "..v[1])
	        end
	        cell.labelNum:setString(v[1])
	        cell.labelName:setString(name)
    	end
	   return cell
	end

    local layerSize = layerView:getContentSize()
    local tabView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    tabView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    --tabView:setPosition(cc.p(0, -8))
    tabView:setDelegate()
    tabView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    layerView:addChild(tabView)

    tabView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    tabView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tabView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tabView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    tabView:reloadData()
end
function PVActivityPage:getDropList(dropId)
	local _smallDrop = self.dropTemp:getBigBagById(dropId).smallPacketId
	local dropList = {}
	for k,_smallDropId in pairs(_smallDrop) do
		local _itemList = self.dropTemp:getAllItemsByDropId(_smallDropId)
		
		local dropType = _itemList[1].type
		dropList[k] = {[tostring(dropType)] = {_itemList[1].count,_itemList[1].type,_itemList[1].detailId} }

	end
	return dropList
end

function PVActivityPage:checkAccGiftGot(day)
	local continuousSignedList = self.commonData:getContinuousSignedList()
	for k,v in pairs(continuousSignedList) do 
		if v == day then
			return true
		end
	end
	return false
end

function PVActivityPage:updateStaminaView()

	local function getTheTimeMin(_hour, _min)
		return _hour*60 + _min
	end

	local function isFeastTime() -- 检测时间是否为可领取体力时间
		local _curHour = self.commonData:getCurrHour()
		local _curMin = self.commonData:getCurrMin()
		print("current :", _curHour,_curMin)
		for k,v in pairs(self._timeCanGet) do
			print("self._timeCanGet",v.startHour, v.startMin, v.endedHour, v.endedMin)
			if getTheTimeMin(v.startHour,v.startMin) <= getTheTimeMin(_curHour,_curMin) and
					getTheTimeMin(v.endedHour,v.endedMin) > getTheTimeMin(_curHour,_curMin) then
				return true
			end
		end
		return false
	end
	local function isEatFeast() -- 检测是否已经吃过了
		local _curHour = self.commonData:getCurrHour()
		local _curMin = self.commonData:getCurrMin()
		local _curDay = self.commonData:getDay()
		local _curMonth = self.commonData:getMonth()
		local _curYear = self.commonData:getYear()
		local _lastTime = self.commonData:getLastStminaTime()
		local _lastTimeHour = os.date("*t", _lastTime).hour
		local _lastTimeMin = os.date("*t", _lastTime).min
		local _lastTimeDay = os.date("*t", _lastTime).day
		local _lastTimeMonth = os.date("*t", _lastTime).month
		local _lastTimeYear = os.date("*t", _lastTime).year

		local function inWhichTime(hour,min)
			local index = 1
			for k,v in pairs(self._timeCanGet) do
				-- print(v.startHour, v.startMin, v.endedHour, v.endedMin)
				if getTheTimeMin(v.startHour,v.startMin) <= getTheTimeMin(hour,min) and
						getTheTimeMin(v.endedHour,v.endedMin) > getTheTimeMin(hour,min) then
					return index
				end
				index = index + 1
			end
		end

		if _lastTimeYear == _curYear and _lastTimeMonth == _curMonth and _lastTimeDay == _curDay then -- Sameday
			local _curWhich = inWhichTime(_curHour,_curMin)
			local _lastWhich = inWhichTime(_lastTimeHour,_lastTimeMin)
			if _curWhich == _lastWhich then return true -- 同一时间段，已经吃了
			else return false
			end
		else -- not same day
			return false
		end
	end

	cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGB565)
	-- @ 如果吃过了，不可点；还没吃，显示按钮，并可点；还没到时间，不显示按钮 to do
	if isFeastTime() == true then -- 可领取时间
		if isEatFeast() == true then -- 已吃
			self.menuGetStamina:setVisible(true)
			self.menuGetStamina:setEnabled(false)
			game.setSpriteFrame(self.imgTable,"res/ccb/effectpng/ui_activity_tl_ready.png")
		else -- 可吃
			self.menuGetStamina:setVisible(true)
			self.menuGetStamina:setEnabled(true)
			game.setSpriteFrame(self.imgTable,"res/ccb/effectpng/ui_activity_ti_eat.png")
		end
	else -- 未到可领取时间
		self.menuGetStamina:setVisible(false)
		game.setSpriteFrame(self.imgTable,"res/ccb/effectpng/ui_activity_tl_ready.png")
	end

	cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

	local str = self.labelTip:getString()
	self.labelTip:setString(string.format(str, table.nums(self._timeCanGet)))
end

function PVActivityPage:updateLoginView()
	self:loginListSort()
	self.loginTableView:reloadData()

end
--更新等级奖励界面
function PVActivityPage:updateRankView()
	self:rankListSort()
	self.rankTableView:reloadData()
end

function PVActivityPage:updateSignView()
	self.signTabView:reloadData()
end

function PVActivityPage:setMenuItem(index)

	print(">>>>>>>>>>>>>>>>>>  "..index)
	self.animationNodeBrew:setVisible(false)     --煮酒特效和动画节点
	
	
	if index == 1 then
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 

		self.menuSign:setEnabled(false)
		self.menuStamina:setEnabled(true)
		self.menuLogin:setEnabled(true)
		self.menuZhujiu:setEnabled(true)
		self.menuRank:setEnabled(true)
		self.nodeSign:setVisible(true)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(false)
		self.nodeRank:setVisible(false)

		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(false)
	elseif index == 2 then
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 

		self.menuSign:setEnabled(true)
		self.menuStamina:setEnabled(false)
		self.menuLogin:setEnabled(true)
		self.menuZhujiu:setEnabled(true)
		self.menuRank:setEnabled(true)
		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(true)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(false)
		self.nodeRank:setVisible(false)
		self:updateStaminaView()         --这里应该在更新一下状态

		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(false)
	elseif index == 3 then
		---- 登陆奖励相关 ----
		cclog("－－－－－－－登陆奖励相关－－－－－－")
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 

		-- if self.loginTableView == nil then
			self.loginList = self.baseTemp:getLoginPrizeList() -- 获取到所有登陆奖励，等级奖励
			self:loginListSort()
			self:createLoginTableView()
			self:updateLoginView()   -- 更新登陆奖励界面
		-- end
		self.menuSign:setEnabled(true)
		self.menuStamina:setEnabled(true)
		self.menuLogin:setEnabled(false)
		self.menuZhujiu:setEnabled(true)
		self.menuRank:setEnabled(true)
		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(true)
		self.nodeZhujiu:setVisible(false)
		self.nodeRank:setVisible(false)
		
		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(false)
	elseif index == 4 then
		-- ---- 等级奖励相关 ----
		cclog("－－－－－－－等级奖励相关－－－－－－")
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 

        --self.signLayer:removeAllChildren()
		-- if self.rankTableView == nil then
			self.rankList = self.baseTemp:getGradePrizeList()
			self:rankListSort()
			self:createRankTableView()
			self:updateRankView()
		-- end
		self.menuSign:setEnabled(true)
		self.menuStamina:setEnabled(true)
		self.menuLogin:setEnabled(true)
		self.menuZhujiu:setEnabled(true)
		self.menuRank:setEnabled(false)
		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(false)
		self.nodeRank:setVisible(true)

		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(false)
	elseif index == 5 then
		self.animationNodeBrew:removeAllChildren()
		self:stopActionByTag(999)
		self.animationNodeBrew:setVisible(true)
		self.effectBG:setVisible(false)
		self.effectBG:setTouchEnabled(false)
        -- 功能等级开放提示
		-- local startLv = self.baseTemp:getBrewStartLevel()
		-- local lv = getDataManager():getCommonData():getLevel()
		-- if lv < startLv then
		--     -- 功能等级开放提示
  --           self:removeChildByTag(1000)
  --           self:addChild(getLevelTips(startLv), 0, 1000)

		-- 	return
		-- end

		-- 关卡开启功能
		local _stageId = self.baseTemp:getCookingWineOpenStage()
        local _isOpen = self.stageData:getIsOpenByStageId(_stageId)
        if not _isOpen then
        	getStageTips(_stageId)
            return
        end
        
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 

		self.menuSign:setEnabled(true)
		self.menuStamina:setEnabled(true)
		self.menuLogin:setEnabled(true)
		self.menuZhujiu:setEnabled(false)
		self.menuRank:setEnabled(true)
		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(true)
		self.nodeRank:setVisible(false)

		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(false)

	elseif index == 6 then           --历史首次充值
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 

		self.reHisList = self.baseTemp:getRchargeHisFirst()
		-- self:rankListSort()
		-- self:createRankTableView()
		-- self:updateRankView()

		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(false)
		self.nodeRank:setVisible(false)
		self.fistDoubleNode:setVisible(true)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(false)
	elseif index == 7 then          --每日首次充值
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 

		self.reDayFirstList = self.baseTemp:getRchargeDayFirst()
		-- self:rankListSort()
		self:createRechargeDayFirst()
		-- self:updateRankView()

		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(false)
		self.nodeRank:setVisible(false)

		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(true)
	elseif index == 8 then           --单次充值
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 

		self.reSingleList = self.baseTemp:getRchargeSingle()
		-- self:rankListSort()
		self:createRechargeSingle()
		-- self:updateRankView()

		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(false)

		self.nodeRank:setVisible(false)
		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(true) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(false)
	elseif index == 9 then	     --累计充值
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		if self.vipGiftNode ~=nil then
		   self.vipGiftNode:removeFromParent()
		   self.vipGiftNode = nil 
		end 
		self.reAccList = self.baseTemp:getRchargeAcc()
		-- self:rankListSort()
		self:createRechargeAcc()
		-- self:updateRankView()

		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(false)
		self.nodeRank:setVisible(false)

		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(true) 
		self.dayChongNode:setVisible(false)
	elseif index == VIPGIFT then	     --累计充值
		self.loginView:removeAllChildren()
		self.rankView:removeAllChildren()
		self.layer_Acc:removeAllChildren()
		self.layer_Single:removeAllChildren()
		self.layer_DayFirst:removeAllChildren()	
		
		
        self.vipGiftNode = PVActivityVipGift.new("PVActivityVipGift")

        cclog("vipGiftNode"..self.vipGiftNode:getContentSize().width.."     "..self.vipGiftNode:getContentSize().height)
        self.vipGiftLayer:addChild(self.vipGiftNode)
		-- self:updateRankView()

		self.nodeSign:setVisible(false)
		self.nodeStamina:setVisible(false)
		self.nodeLogin:setVisible(false)
		self.nodeZhujiu:setVisible(false)
		self.nodeRank:setVisible(false)

     
		self.fistDoubleNode:setVisible(false)
		self.oneChongNode:setVisible(false) 
		self.nChongNode:setVisible(false) 
		self.dayChongNode:setVisible(false)
	end
end

function PVActivityPage:initBrew()
	local gold = self.commonData:getGold()
	-- local nectar_num = self.commonData:getNectarNum()
	local nectar_num = self.commonData:getFinance(DROP_BREW)
	self.labelZJJiu:setString(tostring(nectar_num))
	self.labelZJGold:setString(tostring(gold))
	local brew_times = self.commonData:getBrewTimes()
	local brew_times_max = self.baseTemp:getBrewTimesMax()
	if brew_times >= brew_times_max then
		self:setState(3)
	else
		self:setState(1)
	end
end

function PVActivityPage:updateMenu(index)
	self:updateLabelTitle(index)
	self.cell = nil 
	if index == 1 then
		self:setMenuItem(1)
	elseif index == 2 then
		self:setMenuItem(2)
	elseif index == 3 then
		self:setMenuItem(3)
	elseif index == 4 then
		self:setMenuItem(4)
	elseif index == 5 then
		self:setMenuItem(5)
		--self:updateZJMenu()
		-- self:initBrew()
		local brew_step = self.commonData:getBrewStep()
		if BREW_START or (brew_step > 1 and brew_step <= 4) then
			self:updateZJMenu(true)
		else
			self:initBrew()
		end
	elseif index == 6 then
		self:setMenuItem(6)
	elseif index == 7 then
		self:setMenuItem(7)
	elseif index == 8 then
		self:setMenuItem(8)
	elseif index == 9 then	
		self:setMenuItem(9)
	elseif index == VIPGIFT then
		self:setMenuItem(VIPGIFT)
	end
end

function PVActivityPage:updateZJMenu(begin)
    begin = begin or false

    local brew_times = self.commonData:getBrewTimes()      --使用过的煮酒次数
    --self.brew_times = self.commonData:getBrewTimes()
    print("煮酒的次数"..brew_times)

    local brew_step = self.commonData:getBrewStep()
    cclog("煮酒的步数"..brew_step)
    local nectar_num = self.commonData:getFinance(DROP_BREW)
    local nectar_cur = self.commonData:getNectarCur()
    --self.preNectar = nectar_cur
    local gold = self.commonData:getGold()
    local brew_times_max = self.baseTemp:getBrewTimesMax()       --获取能够使用它煮酒的次数

    local function getGoldCupId(brew_type, brew_step)
    	return base_config['cookingWinePrice'][brew_type][brew_step]["105"][3]     --获取金樽的ID
	end

    local jz_id = nil

    if brew_step ~= 5 then
    	self.jx_gold = self.baseTemp:getBrewPrice('2', brew_step)
    	-- self.jz_gold = self.baseTemp:getBrewPrice('3', brew_step)
    	self.jz_token = self.baseTemp:getBrewGoldCup('3',brew_step)

		jz_id = getGoldCupId('3', brew_step)
    	cclog("我哈哈哈："..jz_id)
     	if brew_step >= 2 and self.jz_flag then
     		self.jz_num = getDataManager():getBagData():getSubNumById(jz_id,self.jz_token)
     		self.jz_flag = false
     	else
     		self.jz_num = getDataManager():getBagData():getItemNumById(jz_id)
     	end

    else
     	self.jx_gold = self.baseTemp:getBrewPrice('2', 4)    --银樽煮酒所需要的金币数量
    	self.jz_token = self.baseTemp:getBrewGoldCup('3',4)  --得到金樽煮酒需要的金樽数量

    	jz_id = getGoldCupId('3', 4)
    	if self.jz_flag then 
    		self.jz_num = getDataManager():getBagData():getSubNumById(jz_id,self.jz_token)
    		self.jz_flag = false
    	else
    		self.jz_num = getDataManager():getBagData():getItemNumById(jz_id)
    	end
    end

    --print("!!!!!! ", brew_step)
    print("!!!!!! ", nectar_num)
    if self.preNectar ~= nil then
    	
    	local strTemp = Localize.query("activity.7")
    	local strNum = (nectar_cur - self.preNectar) / 60
		local str = string.format(strTemp,strNum)
		cclog("百分比"..strNum)
		
		self:BrewEffCCBI(strNum)
		self.preNectar = nil
	end

    self.labelZJtimes:setString(tostring(brew_times_max - brew_times) ..'/'.. brew_times_max)
    self.labelZJJiu:setString(tostring(nectar_num))
    self.labelZJGold:setString(tostring(gold))
    self.labelZJJiuCur:setString(tostring(nectar_cur))

    print('getMoneyFromNet: ', self.jx_gold)

    if self.jx_gold == nil then
        self.labelZJJXGold:setString(tostring(0))
    else
        self.labelZJJXGold:setString(tostring(self.jx_gold))
    end
    if self.jz_num == nil then
        self.labelZJJZGold:setString(tostring(0))
    else
    	self.labelZJJConsum:setString(tostring(self.jz_token))
        self.labelZJJZGold:setString(self.jz_num.." /")
    end

    if begin == true then
        self.state = 2
    elseif brew_times >= brew_times_max then
        self.state = 3
    elseif brew_step > 1 then
    	if brew_step < 5 then
    	   self.state = 2
    	else
           self.state = 4
       end
    else
        self.state = 1
    end


    self:setState(self.state)
end


function PVActivityPage:setState(state) 
	-- self.titleZJGet:setVisible(true)     
	if state == 1 then         						--有煮酒次数的煮酒直接进来的显示
		local brew_step = self.commonData:getBrewStep()    --如果超过4步没有收取，下次进入的时候直接显示收取
		local nectar_cur = self.commonData:getNectarCur()
		if brew_step == 5 then
			self.labelZJJiuCur:setString(tostring(nectar_cur))
			self.menuZJStart:setVisible(false)
			self.menuZJShouqu:setVisible(true)
		else
			self.menuZJStart:setVisible(true)
			self.menuZJShouqu:setVisible(false)
			self.labelZJJiuCur:setString('0')
		end
        self.menuZJGoon:setVisible(false)
        self.menuZJGet:setVisible(false)
        --self.menuZJGold:setVisible(false)
        self.nodeZJ_jz:setVisible(false)
        self.menuZJGoToWJ:setVisible(false)
        self.nodeZJ_Money:setVisible(false)

        local brew_times = self.commonData:getBrewTimes()
        local brew_times_max = self.baseTemp:getBrewTimesMax()
        self.labelZJtimes:setString(tostring(brew_times_max - brew_times) ..'/'.. brew_times_max)
    elseif state == 2 then                             --煮酒主功能
        self.menuZJStart:setVisible(false)
        self.menuZJGet:setVisible(true)
        self.menuZJShouqu:setVisible(false)
        self.menuZJGoToWJ:setVisible(false)
        self.nodeZJ_Money:setVisible(true)
        self.menuZJGoon:setVisible(true)
        --做金樽判断是否显示金樽
        if self.jz_num~=nil and self.jz_num > 0 then
        	cclog("self.jz_num-----"..self.jz_num)
        	self.nodeZJ_jz:setVisible(true)
        else
        	self.nodeZJ_jz:setVisible(false)
        end
        --self.menuZJGold:setVisible(true)

        -- if self.jx_gold then
        --     self.menuZJGoon:setEnabled(true)      --这里为什么要加这个？
        --     --self.menuZJGold:setEnabled(true)
        -- else
        --     self.menuZJGoon:setEnabled(false)
        --     --self.menuZJGold:setEnabled(false)
        -- end
    elseif state == 3 then                           --煮酒次数用完，显示解除武将封印  现不显示武将封印
        self.menuZJStart:setVisible(false)
        self.menuZJShouqu:setVisible(false)
        self.menuZJGoon:setVisible(false)
        self.menuZJGet:setVisible(false)
        self.nodeZJ_jz:setVisible(false)
        self.titleZJGet:setVisible(false)
        --self.menuZJGold:setVisible(false)
        self.menuZJGoToWJ:setVisible(false)
        self.nodeZJ_Money:setVisible(false)
        self.labelZJtimes:setString(tostring(0))
    else   												--煮酒收取
    	self.menuZJStart:setVisible(false)
        self.menuZJShouqu:setVisible(true)
        self.menuZJGoon:setVisible(false)
        self.menuZJGet:setVisible(false)
        self.nodeZJ_jz:setVisible(false)
        --self.menuZJGold:setVisible(false)
        self.menuZJGoToWJ:setVisible(false)
        self.nodeZJ_Money:setVisible(false)
    end
end

function PVActivityPage:BrewEffCCBI(strnum)
	local function callBack1()
		local node = UI_zengchanjiemian()
		-- node:setPosition(cc.p(300,500))
		node:setPosition(cc.p(60,360))
		self.animationNodeBrew:addChild(node)
		local pos = self.animationNodeBrew:convertToNodeSpace(cc.p(node:getPositionX(),node:getPositionX()))
		-- cclog("convertToNodeSpace==="..pos.x.."layposy==="..pos.y)
		self.effectBG:setVisible(true)
		local function onTouchEvent(eventType, x, y)
	        if eventType == "began" then
	            return true
	        end
    	end
    	self.effectBG:setTouchEnabled(true)
    	self.effectBG:registerScriptTouchHandler(onTouchEvent)

	end
	local function callBack2()
		local node = self:loadBrewEffCCBI(strnum)
		node:setPosition(cc.p(-270,-130))
		self.animationNodeBrew:addChild(node)
	end
	local function callBack3()
		self.animationNodeBrew:removeAllChildren()
		self.effectBG:setVisible(false)
		self.effectBG:setTouchEnabled(false)
		local nectar_cur = self.commonData:getNectarCur()
		self.labelZJJiuCur:setString(tostring(nectar_cur))
	end
	--local seq = cc.Sequence:create(cc.CallFunc:create(callBack1),cc.DelayTime:create(0.4),cc.CallFunc:create(callBack2))
	local seq1 = cc.Sequence:create(cc.DelayTime:create(1.1),cc.CallFunc:create(callBack2))
	local seq2 = cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(callBack3))
	local spwa = cc.Spawn:create(cc.CallFunc:create(callBack1),seq1,seq2)
	spwa:setTag(999)
	self:runAction(spwa)
end
function PVActivityPage:loadBrewEffCCBI(strnum)

	--self.animationNode:removeAllChildren()
	local UIEquipAwakenItem = {}
    local proxy = cc.CCBProxy:create()
    local brewEffView = CCBReaderLoad("effect/ui_zhujiu_effect.ccbi", proxy, UIEquipAwakenItem)
    local integerSpr = UIEquipAwakenItem["UIEquipAwakenItem"]["integerSpr"]
    local pointSpr = UIEquipAwakenItem["UIEquipAwakenItem"]["pointSpr"]
    local decimalsSpr = UIEquipAwakenItem["UIEquipAwakenItem"]["decimalsSpr"]

    if strnum == 1 then
	elseif strnum > 1 and strnum < 2 then
		game.setSpriteFrame(integerSpr,"#zhujiu_effect5.png")
		game.setSpriteFrame(decimalsSpr,"#zhujiu_effect10.png")
	elseif strnum == 2 then
		game.setSpriteFrame(decimalsSpr,"#zhujiu_effect7.png")
		pointSpr:setVisible(false)
		integerSpr:setVisible(false)
	elseif strnum > 2 and strnum < 3 then
		game.setSpriteFrame(integerSpr,"#zhujiu_effect7.png")
		game.setSpriteFrame(decimalsSpr,"#zhujiu_effect10.png")
	elseif strnum ==3 then
		game.setSpriteFrame(decimalsSpr,"#zhujiu_effect8.png")
		pointSpr:setVisible(false)
		integerSpr:setVisible(false)
	elseif strnum > 3 and strnum < 4 then
		game.setSpriteFrame(integerSpr,"#zhujiu_effect8.png")
		game.setSpriteFrame(decimalsSpr,"#zhujiu_effect10.png")
	else
		game.setSpriteFrame(decimalsSpr,"#zhujiu_effect9.png")
		pointSpr:setVisible(false)
		integerSpr:setVisible(false)
	end
	--self.animationNode:addChild(brewEffView)
	print(brewEffView)
	return brewEffView
end


function PVActivityPage:onReloadView()
    -- if COMMON_TIPS_BOOL_RETURN == true then
    --     COMMON_TIPS_BOOL_RETURN = false
    --     -- getNetManager():getActivityNet():sendRepaireSignMsg(ACTIVITY_REPAIRE_DAY)
    --     local _times = getDataManager():getCommonData():getRepaireTimes()
	   --  local money = getTemplateManager():getBaseTemplate():getRepaireSignMoney(_times+1)
	   --  if getDataManager():getCommonData():getGold() >= money then
	   --  	getNetManager():getActivityNet():sendRepaireSignMsg(ACTIVITY_REPAIRE_DAY)
	   --  else 
	   --  	getOtherModule():showAlertDialog(nil, Localize.query("activity.5"))
   	-- 	end
    -- else
    --     UI_ACTIVITY_TEXIAO_TAG = -1
    -- end
    if self.recharge then
    	self.recharge = false
    	getNetManager():getActivityNet():sendGetRechargeListMsg()       --充值界面回来刷新数据
    end
end

-- 创建每日首充的tableview
function PVActivityPage:createRechargeDayFirst()

	local function numberOfCellsInTableView(tab)
       return table.getn(self.reDayFirstList)
    end
    local function cellSizeForTable(tbl, idx)
        return 186,557
    end
    local function tableCellAtIndex(tbl, idx)
    	
        local cell = tbl:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onMenuClick()
            	if self.clickFlag then          --防止其点击两个，只获得一个
            		self.clickFlag = false
	            	getAudioManager():playEffectButton2()
	            	cclog("vvvvvvvvvv 领取 ", cell.type, cell.id)
	            	self.rewardType = cell.type
	            	self.rewardId = cell.id
	            	local data = {}
	            	local tab = self.commonData:getSendInfo(cell.id)
	            	table.insert(data,tab)
	            
	            	getNetManager():getActivityNet():sendGetRechargeGift(data)
	            	
	            	self.rechargeDropList = cell.dropList
	            	
	            end
            end
            local function arrowRightClick()
            	
            end
            local function arrowLeftClick()

            end
            local function onRechargeClick()
            	-- getNetManager():getActivityNet():sendGetRechargeTest(100)
            	self.recharge = true
            	getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
            end
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UIRechargeItem"] = {}
            cell.itemInfo["UIRechargeItem"]["MenuClick"] = onMenuClick
            cell.itemInfo["UIRechargeItem"]["MenuRechargeClick"] = onRechargeClick
            cell.itemInfo["UIRechargeItem"]["arrowRightClick"] = arrowRightClick
            local node = CCBReaderLoad("home/ui_activity_recharge_prizeItem.ccbi", proxy, cell.itemInfo)

            cell:addChild(node)
		    cell.labelTitle = cell.itemInfo["UIRechargeItem"]["label_title"]
			cell.layerView = cell.itemInfo["UIRechargeItem"]["layer_tableview"]
			cell.arrowRight = cell.itemInfo["UIRechargeItem"]["img_arrow_right"]
			cell.menuGet = cell.itemInfo["UIRechargeItem"]["menu_getbtn"]
			cell.menuRecharge = cell.itemInfo["UIRechargeItem"]["menu_rechargebtn"]
			cell.imgHaveGot = cell.itemInfo["UIRechargeItem"]["spr_havegot"]
			cell.label_haveRecharged = cell.itemInfo["UIRechargeItem"]["label_haveRecharged"]
			cell.label_needRecharge = cell.itemInfo["UIRechargeItem"]["label_needRecharge"]
        end

        local _type = self.reDayFirstList[idx+1].type
        local _premise = self.reDayFirstList[idx+1].parameterA     --参数A
        local _reward = self.reDayFirstList[idx+1].reward          --奖励
        local _id = self.reDayFirstList[idx+1].id                  --id
        local _title = nil  -- 奖励名字
        local _isGot = false  -- 是否已获得
        local _isCanGet = false -- 是否能获得
        cell.type = _type
        cell.id = _id
        cell.reward = _reward

        _isGot = self.commonData:rechargeGiftIsGot(_id)
        if self.commonData:rechargeGiftCanGet(_id) then _isCanGet = true end    
      
        _title = Localize.query("activity.9")

        _title = string.format(_title, _premise)
		cell.labelTitle:setString(_title)
		cell.label_haveRecharged:setString("0")
		cell.label_needRecharge:setString("/".._premise)

		if _isCanGet then
			if _isGot then
				cell.menuGet:setVisible(false)
				cell.menuRecharge:setVisible(false)
				cell.imgHaveGot:setVisible(true)
			else
				cell.menuGet:setVisible(true)
				cell.menuRecharge:setVisible(false)
				cell.imgHaveGot:setVisible(false)
			end
		else
			cell.menuGet:setVisible(false)
			cell.menuRecharge:setVisible(true)
			cell.imgHaveGot:setVisible(false)
		end
		cell.arrowRight:setVisible(false)

		for k,v in pairs(_reward) do
	    	cell.dropList = self:getDropList(v[3])
		end
		table.print(cell.dropList)
		self:createDropList(cell.dropList,cell.layerView)


        return cell
    end

    local layerSize = self.layer_DayFirst:getContentSize()
    self.reDayFirstTableView = cc.TableView:create(layerSize)
    self.reDayFirstTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.reDayFirstTableView:setDelegate()
    self.reDayFirstTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layer_DayFirst:addChild(self.reDayFirstTableView)

    self.reDayFirstTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.reDayFirstTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.reDayFirstTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.reDayFirstTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.layer_DayFirst:addChild(scrBar,2)

    self.reDayFirstTableView:reloadData()
end

-- 创建单次充值的tableview
function PVActivityPage:createRechargeSingle()

	local function numberOfCellsInTableView(tab)
       return table.getn(self.reSingleList)
    end
    local function cellSizeForTable(tbl, idx)
        return 186,557
    end
    local function tableCellAtIndex(tbl, idx)
    	
        local cell = tbl:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onMenuClick()
            	if self.clickFlag then          --防止其点击两个，只获得一个
            		self.clickFlag = false
	            	getAudioManager():playEffectButton2()
	            	cclog("vvvvvvvvvv 领取 ", cell.type, cell.id)
	            	self.rewardType = cell.type
	            	self.rewardId = cell.id
	            	local data = {}
	            	local tab = self.commonData:getSendInfo(cell.id)
	            	table.insert(data,tab)
	            
	            	getNetManager():getActivityNet():sendGetRechargeGift(data)
	            	
	            	self.rechargeDropList = cell.dropList
	            	
	            end
            end
            local function arrowRightClick()

            end
            local function arrowLeftClick()

            end
            local function onRechargeClick()
            	-- getNetManager():getActivityNet():sendGetRechargeTest(100)
            	self.recharge = true
            	getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
            end
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UIRechargeItem"] = {}
            cell.itemInfo["UIRechargeItem"]["MenuClick"] = onMenuClick
            cell.itemInfo["UIRechargeItem"]["MenuRechargeClick"] = onRechargeClick
            cell.itemInfo["UIRechargeItem"]["arrowRightClick"] = arrowRightClick
            local node = CCBReaderLoad("home/ui_activity_recharge_prizeItem.ccbi", proxy, cell.itemInfo)

            cell:addChild(node)
		    cell.labelTitle = cell.itemInfo["UIRechargeItem"]["label_title"]
			cell.layerView = cell.itemInfo["UIRechargeItem"]["layer_tableview"]
			cell.arrowRight = cell.itemInfo["UIRechargeItem"]["img_arrow_right"]
			cell.menuGet = cell.itemInfo["UIRechargeItem"]["menu_getbtn"]
			cell.menuRecharge = cell.itemInfo["UIRechargeItem"]["menu_rechargebtn"]
			cell.imgHaveGot = cell.itemInfo["UIRechargeItem"]["spr_havegot"]
			cell.label_haveRecharged = cell.itemInfo["UIRechargeItem"]["label_haveRecharged"]
			cell.label_needRecharge = cell.itemInfo["UIRechargeItem"]["label_needRecharge"]
        end

        local _type = self.reSingleList[idx+1].type
        local _premise = self.reSingleList[idx+1].parameterA     --参数A
        local _reward = self.reSingleList[idx+1].reward          --奖励
        local _id = self.reSingleList[idx+1].id                  --id
        local _title = nil  -- 奖励名字
        local _isGot = false  -- 是否已获得
        local _isCanGet = false -- 是否能获得
        cell.type = _type
        cell.id = _id
        cell.reward = _reward

        _isGot = self.commonData:rechargeGiftIsGot(_id)
        if self.commonData:rechargeGiftCanGet(_id) then _isCanGet = true end
   
        _title = Localize.query("activity.10")

        _title = string.format(_title, _premise)
		cell.labelTitle:setString(_title)
		cell.label_haveRecharged:setString("0")
		cell.label_needRecharge:setString("/".._premise)

		if _isCanGet then
			if _isGot then
				cell.menuGet:setVisible(false)
				cell.menuRecharge:setVisible(false)
				cell.imgHaveGot:setVisible(true)
			else
				cell.menuGet:setVisible(true)
				cell.menuRecharge:setVisible(false)
				cell.imgHaveGot:setVisible(false)
			end
		else
			cell.menuGet:setVisible(false)
			cell.menuRecharge:setVisible(true)
			cell.imgHaveGot:setVisible(false)
		end
		cell.arrowRight:setVisible(false)

		for k,v in pairs(_reward) do
	    	cell.dropList = self:getDropList(v[3])
		end

		self:createDropList(cell.dropList,cell.layerView)


        return cell
    end

    local layerSize = self.layer_Single:getContentSize()
    self.reSingleTableView = cc.TableView:create(layerSize)
    self.reSingleTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.reSingleTableView:setDelegate()
    self.reSingleTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layer_Single:addChild(self.reSingleTableView)

    self.reSingleTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.reSingleTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.reSingleTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.reSingleTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.layer_Single:addChild(scrBar,2)

    self.reSingleTableView:reloadData()
end

-- 创建累计充值的tableview
function PVActivityPage:createRechargeAcc()

	local function numberOfCellsInTableView(tab)
       return table.getn(self.reAccList)
    end
    local function cellSizeForTable(tbl, idx)
        return 186,557
    end
    local function tableCellAtIndex(tbl, idx)
    	
        local cell = tbl:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onMenuClick()
            	if self.clickFlag then          --防止其点击两个，只获得一个
            		self.clickFlag = false
	            	getAudioManager():playEffectButton2()
	            	cclog("vvvvvvvvvv 领取 ", cell.type, cell.id)
	            	self.rewardType = cell.type
	            	self.rewardId = cell.id
	            	local data = {}
	            	local tab = self.commonData:getSendInfo(cell.id)
	            	table.insert(data,tab)
	            
	            	getNetManager():getActivityNet():sendGetRechargeGift(data)
	            	
	            	self.rechargeDropList = cell.dropList
	            	
	            end
            end
            local function arrowRightClick()
       
            end
            local function arrowLeftClick()

            end
            local function onRechargeClick()
            	-- getNetManager():getActivityNet():sendGetRechargeTest(100)
            	self.recharge = true
            	getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
            end
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UIRechargeItem"] = {}
            cell.itemInfo["UIRechargeItem"]["MenuClick"] = onMenuClick
            cell.itemInfo["UIRechargeItem"]["MenuRechargeClick"] = onRechargeClick
            cell.itemInfo["UIRechargeItem"]["arrowRightClick"] = arrowRightClick
            local node = CCBReaderLoad("home/ui_activity_recharge_prizeItem.ccbi", proxy, cell.itemInfo)

            cell:addChild(node)
		    cell.labelTitle = cell.itemInfo["UIRechargeItem"]["label_title"]
			cell.layerView = cell.itemInfo["UIRechargeItem"]["layer_tableview"]
			cell.arrowRight = cell.itemInfo["UIRechargeItem"]["img_arrow_right"]
			cell.menuGet = cell.itemInfo["UIRechargeItem"]["menu_getbtn"]
			cell.menuRecharge = cell.itemInfo["UIRechargeItem"]["menu_rechargebtn"]
			cell.imgHaveGot = cell.itemInfo["UIRechargeItem"]["spr_havegot"]
			cell.label_haveRecharged = cell.itemInfo["UIRechargeItem"]["label_haveRecharged"]
			cell.label_needRecharge = cell.itemInfo["UIRechargeItem"]["label_needRecharge"]
        end

        local _type = self.reAccList[idx+1].type
        local _premise = self.reAccList[idx+1].parameterA     --参数A
        local _reward = self.reAccList[idx+1].reward          --奖励
        local _id = self.reAccList[idx+1].id                  --id
        local _title = nil  -- 奖励名字
        local _isGot = false  -- 是否已获得
        local _isCanGet = false -- 是否能获得
        cell.type = _type
        cell.id = _id
        cell.reward = _reward
  
        _isGot = self.commonData:rechargeGiftIsGot(_id)
        if self.commonData:getRechargeAcc() >= _premise then _isCanGet = true end
        _title = Localize.query("activity.11")
          print("------cell.id---".._id,_isCanGet)
        _title = string.format(_title, _premise)
		cell.labelTitle:setString(_title)
		cell.label_haveRecharged:setString(self.commonData:getRechargeAcc())
		cell.label_needRecharge:setString("/".._premise)

		if _isCanGet then
			if _isGot then
				cell.menuGet:setVisible(false)
				cell.menuRecharge:setVisible(false)
				cell.imgHaveGot:setVisible(true)
			else
				cell.menuGet:setVisible(true)
				cell.menuRecharge:setVisible(false)
				cell.imgHaveGot:setVisible(false)
			end
		else
			cell.menuGet:setVisible(false)
			cell.menuRecharge:setVisible(true)
			cell.imgHaveGot:setVisible(false)
		end
		cell.arrowRight:setVisible(false)

		for k,v in pairs(_reward) do
	    	cell.dropList = self:getDropList(v[3])
		end
		self:createDropList(cell.dropList,cell.layerView)

        return cell
    end

    local layerSize = self.layer_Acc:getContentSize()
    self.reAccTableView = cc.TableView:create(layerSize)
    self.reAccTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.reAccTableView:setDelegate()
    self.reAccTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layer_Acc:addChild(self.reAccTableView)

    self.reAccTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.reAccTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.reAccTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.reAccTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.layer_Acc:addChild(scrBar,2)

    self.reAccTableView:reloadData()
end
function PVActivityPage:updateRechargeView(_type)
	if _type == 7 then
	elseif _type == 8 then
		self:updateRechargeSingleNotice()
		self.reSingleTableView:reloadData()
	elseif _type == 9 then
		self:updateRechargeAccNotice()
		self.reAccTableView:reloadData()
	elseif _type == 10 then
		self:updateRechargeDayNotice()
		self.reDayFirstTableView:reloadData()
	end
end
return PVActivityPage

