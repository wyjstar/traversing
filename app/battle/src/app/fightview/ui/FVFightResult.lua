--战斗结果页面
--去掉FVFightFailUI.lua、FVFightWinUI、

-- 战斗胜利结算

local FVFightResult = FVFightResult or class("FVFightResult", BaseUIView)


function FVFightResult:ctor(id)
    self.super.ctor(self, id)
    self:initBaseUI()
    self.fightType = nil
    self.fightResult = nil
end

--_fightResult 1为胜,0为败
function FVFightResult:initViewData(_fightType , _fightResult)

	self:init()
	
	self.fightType = _fightType
	self.fightResult = _fightResult
	
	self:initWinMenu()

    self:initData()
    self:initTouchListener()
    self:initView()
end


--初始化属性
function FVFightResult:init()
    -- getAudioManager():stopAllEffect()

    self.ccbiNode = {}

    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self._resourceTemp = getTemplateManager():getResourceTemplate()
    self._chipTemp = getTemplateManager():getChipTemplate()
    self.commonData = getDataManager():getCommonData()
    self.c_EquipmentData = getDataManager():getEquipmentData()
    self.stageData = getDataManager():getStageData()
    self.stageTemp = getTemplateManager():getInstanceTemplate()
    self.bagTemplate = getTemplateManager():getBagTemplate()
end

function FVFightResult:showOtherViewByBtn(index)

    exitFightScene(80)

    local __refreshCurrent = function()
        timer.unscheduleGlobal(__refreshCurrentView10)
        __refreshCurrentView10 = nil

        if index == 1 then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipmentMain", 1)
        elseif index == 4 then
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMain", 4)
        elseif index == 3 then
             getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierMain",3)
        end

    end
    __refreshCurrentView10 = timer.scheduleGlobal(__refreshCurrent, 0.02)
end

function FVFightResult:runLightAction()
    local act = cc.RotateBy:create(10, 360)
    local rep = cc.RepeatForever:create( act )
    self.lightImg:runAction(rep)
end

--注册失败时的消息监听
function FVFightResult:initFailTouchListener( ... )
	--发送游历失败的信息
    local function sendTravelFail()
        if self.fightType  == TYPE_TRAVEL then
            -- todo
            TRAVEL_WIN = false
            cclog("----TYPE_TRAVEL--fail----")
            local event = cc.EventCustom:new(UPDATE_WAITGAIN)
            self:getEventDispatcher():dispatchEvent(event)
        end
    end 

    local function onSureClick()
       	cclog("menuClick Back")
        getAudioManager():playEffectButton2()

        if self.fightType  == TYPE_PVP then
            PVP_WIN = false
        end
        sendTravelFail()
        exitFightScene()
    end

	-----暂未知道80是什么意思，之前是这么传参的
    local function onSoldierCulture( ... )
    	getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMain")
    	exitFightScene(80)
    end 
    --点击跳转至商城-招募界面
    local function onSoldierRecruit()
    	getModule(MODULE_NAME_SHOP):showUIView("PVShopPage")
    	exitFightScene(80)
    end

    --点击跳转至商城-装备界面
    local function onEquiprGet()
    	getModule(MODULE_NAME_SHOP):showUIView("PVShopPage",2)
    	exitFightScene(80)
    end

    local function onEquipStrength()
    	getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEquipmentMain")
    	exitFightScene(80)
    end

    self.ccbiNode["PVFightView"]["onFailSureClick"] = onSureClick
    self.ccbiNode["PVFightView"]["onSoldierRecruit"] = onSoldierRecruit --神将招募
    self.ccbiNode["PVFightView"]["onSoldierCulture"] = onSoldierCulture --武将培养
    self.ccbiNode["PVFightView"]["onEquiprGet"] = onEquiprGet --获取神装
    self.ccbiNode["PVFightView"]["onEquipStrength"] = onEquipStrength --装备强化
end

function FVFightResult:initWinMenu()
	
	self.menuTable = {}

	function onbackTouch()
		getAudioManager():playEffectButton2()

        local isOpenGuide = getNewGManager():checkStageGuide()
        print("isOpenGuide ", isOpenGuide)
        
        if isOpenGuide then
            getNewGManager():setNewBeeFightWin(true)
            getModule(MODULE_NAME_HOMEPAGE):removeLastView()
        end

        
        if self.fightType == TYPE_PVP then
            PVP_WIN = true
        end
        if self.fightType == TYPE_TRAVEL then
            TRAVEL_WIN = true
        end
 		exitFightScene(TYPE_TRAVEL)
	end

	--秘境返回
	function mineBack(data)
		getAudioManager():playEffectButton2()

        if getDataManager():getMineData():getOtherPlayersCanGet() then
            exitFightScene(nil, "win")
        else
            exitFightScene(data, "win")
        end
	end

	function nextLevel()
		local stageId = getDataManager():getFightData():getFightingStageId()
		local nextSimpleId = getTemplateManager():getInstanceTemplate():getNextStage(stageId)

		if nextSimpleId > 0 then
            getDataManager():getFightData():setFightingStageId(nextSimpleId)
			enterFightByStageIdAndType(nextSimpleId,self.fightType)
		end
	end

	function continueBattle()
		enterFightByStageIdAndType(getDataManager():getFightData():getFightingStageId(),self.fightType)
	end

	--秘境 野怪
	self.menuTable[TYPE_MINE_MONSTER]={
		menu1 = {visible=false},
		menu2 = {visible = true,func = function()
			    mineBack(8)
		end,normal = "#ui_common_button_y182.png",selected="#ui_secret_lb_zhsh.png"},
		menu3 = {visible = false}
	}
	--秘境 玩家
	self.menuTable[TYPE_MINE_OTHERUSER] = {
		menu1 = {visible=false},	
		menu2 = {visible = true,func = function()
			 mineBack(9)    
		end,normal = "#ui_common_button_y182.png",selected="#ui_secret_lb_zhsh.png"},
		menu3 = {visible = false}
	}

	--活动关卡
	self.menuTable[TYPE_STAGE_ACTIVITY] = {
		menu1 = {visible = true,func =onbackTouch,normal = "#ui_common_button_blue.png",selected="#ui_common_back.png",disabled="#ui_common_button_blue_false.png"},
		menu2 = {visible=false},
		menu3 = {visible = true,func = function ()
			enterFightScene()
		end,normal="#ui_common_button_y182.png",selected="#ui_fight_rebattle.png",disabled="#ui_common_button_y_false.png" }
	}

		--精英关卡
	self.menuTable[TYPE_STAGE_ELITE] = {
		menu1 = {visible = true,func =onbackTouch,normal = "#ui_common_button_blue.png",selected="#ui_common_back.png",disabled="#ui_common_button_blue_false.png"},
		menu2 = {visible = true,func = function ()
			continueBattle()
		end,normal="#ui_common_button_y182.png",selected="#ui_fight_rebattle.png",disabled="#ui_common_button_y_false.png" },
		menu3 = {visible = true,func = nextLevel,normal="#ui_common_button_y182.png",selected="#ui_fight_nextlevel.png",disabled="#ui_common_button_y_false.png" }
	}

	--剧情关卡
	self.menuTable[TYPE_STAGE_NORMAL] = {
		menu1 = {visible = true,func =onbackTouch,normal = "#ui_common_button_blue.png",selected="#ui_common_back.png",disabled="#ui_common_button_blue_false.png"},
		menu2 = {visible = true,func = function ()
			continueBattle()
		end,normal="#ui_common_button_y182.png",selected="#ui_fight_rebattle.png",disabled="#ui_common_button_y_false.png" },
		menu3 = {visible = true,func = nextLevel,normal="#ui_common_button_y182.png",selected="#ui_fight_nextlevel.png",disabled="#ui_common_button_y_false.png" }
	}

	--擂台
	self.menuTable[TYPE_PVP] = {
        menu1 = {visible=false},
		menu2 = {visible = true,func =onbackTouch,normal = "#ui_common_button_blue.png",selected="#ui_common_back.png",disabled="#ui_common_button_blue_false.png"},
		menu3 = {visible = false }
	}

	--游历
	self.menuTable[TYPE_TRAVEL] = {
		menu1 = {visible= false},
        menu2 = {visible = true,func =onbackTouch,normal = "#ui_common_button_blue.png",selected="#ui_common_back.png",disabled="#ui_common_button_blue_false.png"},
		menu3 = {visible = false }
	}

end

function FVFightResult:initWinTouchListener()
	local menuCfg = self.menuTable[self.fightType]
	print("self.fightType:",self.fightType)
	table.print(self.menuTable)
	for i = 1,3 do
		if menuCfg[string.format("menu%d",i)].visible then
			self.ccbiNode["PVFightView"][string.format("onMenu%d",i)] = menuCfg[string.format("menu%d",i)].func
		end
	end
end

--绑定事件
function FVFightResult:initTouchListener()

	self.ccbiNode["PVFightView"] = {}
    if self.fightResult == 1 then
    	self:initWinTouchListener()
    else
    	self:initFailTouchListener()
    end
end

function FVFightResult:initView()

    -- 战后结算页面
    local proxy = cc.CCBProxy:create()
    self.node = CCBReaderLoad("fight/ui_fight_view.ccbi", proxy, self.ccbiNode)
    self:addChild(self.node)

    -- 获取控件
    self.ccbiRootNode = self.ccbiNode["PVFightView"]

    self.nodeSucess = self.ccbiRootNode["successNode"]
    self.nodeFail = self.ccbiRootNode["failNode"]
    self.commonNode = self.ccbiRootNode["commonNode"]
    
    self.nodeSucess:setVisible(self.fightResult == 1)
    self.nodeFail:setVisible(self.fightResult ~= 1)

    self.lightImg = self.ccbiRootNode["light_img"]
    self.layerContent = self.ccbiRootNode["list_content"]
    self.menuRight = self.ccbiRootNode["arrow_right"]
    self.menuLeft = self.ccbiRootNode["arrow_left"]
    -- self.menuRight:setAllowScale(false)
    -- self.menuLeft:setAllowScale(false)

    self.teamNodeGroup = self.ccbiRootNode["teamNodeGroup"]

    self:showTeamExp()

    if self.fightResult == 1 then 
    	
    	self:runLightAction()

    	self.fightWinTitle = self.ccbiRootNode["fightWinTitle"]
    	self.fightWinReward = self.ccbiRootNode["fightWinReward"]

    	if TYPE_TRAVEL == self.fightType then
    		self.fightWinReward:setVisible(false)

    	else
    		self.fightWinReward:setVisible(true)
            self:createDropTableView()

    		self.noticeTable = {}

			self.noticeTable[TYPE_STAGE_NORMAL] = "#ui_fight_win_reward_title1.png"
			self.noticeTable[TYPE_STAGE_ELITE] = "#ui_fight_win_reward_title2.png"
			self.noticeTable[TYPE_STAGE_ACTIVITY] = "#ui_fight_win_reward_title2.png"
			self.noticeTable[TYPE_PVP] = "#ui_fight_win_reward_title3.png"
			self.noticeTable[TYPE_MINE_MONSTER] = "#ui_fight_win_reward_title3.png"
			self.noticeTable[TYPE_MINE_OTHERUSER] = "#ui_fight_win_reward_title3.png"

			game.setSpriteFrame(self.fightWinTitle,self.noticeTable[self.fightType])
    	end

    	local menuCfg = self.menuTable[self.fightType]

    	for i = 1, 3 do
    		local cfg = menuCfg[ string.format("menu%d",i)]
    		local menu = self.ccbiRootNode[string.format("fightWinMenu%d",i)]
    		if cfg.visible then
    			print("menuImage:",cfg.normal,cfg.selected)
    			menu:setNormalSpriteFrame(game.newSpriteFrame(string.sub(cfg.normal,2)))
    			menu:setSelectedSpriteFrame(game.newSpriteFrame(string.sub(cfg.selected,2)))
                menu:setDisabledSpriteFrame(game.newSpriteFrame(string.sub(cfg.disabled,2)))
                menu:setEnabled(true)
    		end
    		menu:setVisible(cfg.visible)
    	end

        self.numNode = self.ccbiRootNode["numNode"]
        self.tiliNode = self.ccbiRootNode["tiliNode"]

        self.tiliNumLabel = self.ccbiRootNode["tiliNumLabel"]
        self.numLabel = self.ccbiRootNode["numLabel"]

        self.numNode:setVisible(false)
        self.tiliNode:setVisible(false)
        
        local stageId = getDataManager():getFightData():getFightingStageId()
        local vip = getDataManager():getCommonData():getVip()

        local menu2 = self.ccbiRootNode[string.format("fightWinMenu%d",2)]
        local menu3 = self.ccbiRootNode[string.format("fightWinMenu%d",3)]

        if self.fightType == TYPE_STAGE_NORMAL then
            self.numNode:setVisible(true)
            self.tiliNode:setVisible(true)

            self.stageTempItem = self.stageTemp:getTemplateById(stageId)
            local _currFightNum = self.stageData:getStageFightNum(stageId)
            local _maxFightNum = self.stageTempItem.limitTimes  --挑战次数
            local _useVigor = self.stageTempItem.vigor --消耗体力

            self.numLabel:setString(string.format("%d/%d", _maxFightNum-_currFightNum, _maxFightNum))

            if _currFightNum >= _maxFightNum then --次数不够
                menu2:setEnabled(false)
            end

            local max = getTemplateManager():getBaseTemplate():getStaminaMax()
            self.commonData:addStamina(-_useVigor)
            local curr = self.commonData:getStamina()
            
            self.tiliNumLabel:setString(curr.."/"..max)

            if curr < _useVigor then --体力不足
                menu2:setEnabled(false)
                menu3:setEnabled(false)
            end
            self.numNode:setPosition(-97,0)

        elseif self.fightType  == TYPE_STAGE_ELITE then
            local curFbTimes = self.stageData:getEliteStageTimes()
            local fbMaxTimes = getTemplateManager():getBaseTemplate():getNumEliteTimes(vip)

            self.numNode:setString((fbMaxTimes - curFbTimes).."/"..fbMaxTimes)
            if curFbTimes >= fbMaxTimes then
                menu2:setEnabled(false)
                menu3:setEnabled(false)
            end

            self.numNode:setPosition(-197,0)
        elseif self.fightType == TYPE_STAGE_ACTIVITY then

            self.numNode:setVisible(true)

            local curHdTimes = self.stageData:getActStageTimes()
            local hdMaxTimes = getTemplateManager():getBaseTemplate():getNumActTimes(vip)
            local actStageTimes = hdMaxTimes - curHdTimes
            self.numNode:setString(actStageTimes.."/"..hdMaxTimes)

            if actStageTimes > 0 then
                menu2:setEnabled(false)
            end
        end
    end
end

--创建掉落列表
function FVFightResult:createDropTableView()

    print("FVFightResult:createDropTableView===========>")
	self.drops = getDataManager():getFightData():getDrops()

    if self.drops == nil then
        print("无掉落")
        self.fightWinReward:setVisible(false)
        return
    end
    table.print(self.drops)
    -- 解析出物件
    local heros = self.drops.heros                --武将
    local equips = self.drops.equipments          --装备
    local items = self.drops.items                --道具
    local h_chips = self.drops.hero_chips         --英雄灵魂石
    local e_chips = self.drops.equipment_chips    --装备碎片
    local finance = self.drops.finance            --finance
    local stamina = self.drops.stamina

    local _itemList = {}  -- 将创建物件需要的数据暂存到_itemList中
    local _index = 1
    if heros ~= nil then
        for k,var in pairs(heros) do
            _itemList[_index] = {type = 101, detailId = var.hero_no, nums = 1,name = self.soldierTemp:getHeroName(var.hero_no)}
            _index = _index + 1
        end
    end
    if equips ~= nil then
        for k,var in pairs(equips) do
            _itemList[_index] = {type = 102, detailId = var.no, nums = 1 , id = var.id, name = self.equipTemp:getEquipName(var.no)}
            _index = _index + 1
        end
    end
    if h_chips ~= nil then
        for k,var in pairs(h_chips) do
            _itemList[_index] = {type = 103, detailId = var.hero_chip_no, nums = var.hero_chip_num,name = self._chipTemp:getChipName(var.hero_chip_no)}
            _index = _index + 1
        end
    end
    if e_chips ~= nil then
        for k,var in pairs(e_chips) do
            _itemList[_index] = {type = 104, detailId = var.equipment_chip_no, nums = var.equipment_chip_num,name = self._chipTemp:getChipName(var.equipment_chip_no)}
            _index = _index + 1
        end
    end
    if items ~= nil then
        for k,var in pairs(items) do
            _itemList[_index] = {type = 105, detailId = var.item_no, nums = var.item_num,name = self.bagTemplate:getItemName(var.item_no)}
            _index = _index + 1
        end
    end

   cclog("++droplist++++++++++++++++++++")
    table.print(_itemList)
   cclog("++droplist++++++++++++++++++++")

    -- 将dropList用tableView显示 --
    local function tableCellTouched(tbl, cell)
       -- cclog("cell item", cell:getIdx())
       local _idx = cell:getIdx()
       local _v = _itemList[_idx+1]
       print("--_v.type--",_v.type)
       table.print(_v)
       if _v.type == 105 then -- item
            getOtherModule():showOtherViewInRunningScene("PVCommonDetail", 1, _v.detailId, 1)
        elseif _v.type == 101 then --hero
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInRunningScence("PVSoldierOtherDetail", _v.detailId, 101)
        elseif _v.type == 102 then --equipment
            local _equipment = self.c_EquipmentData:getEquipById(_v.id)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInRunningScence("PVEquipmentAttribute", _equipment, 101)
        elseif _v.type == 103 then --heroChip
            getOtherModule():showOtherViewInRunningScene("PVCommonChipDetail", 1, _v.detailId, _v.nums, 1) --1 herochip
        elseif  _v.type == 104 then --equipmentChip
            getOtherModule():showOtherViewInRunningScene("PVCommonChipDetail", 2, _v.detailId, _v.nums, 1) --2 equipmentchip
       end
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(_itemList)
    end
    local function cellSizeForTable(tbl, idx)
        return 110,105
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local cardinfo = {}
            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("common/ui_card_withnumber.ccbi", proxy, cardinfo)
            cell:addChild(node)
            cell.card = cardinfo["UICommonGetCard"]["img_card"]
            cell.card:setVisible(false)
            cell.number = cardinfo["UICommonGetCard"]["label_number"]
        end

        cell.number:setString("X "..tostring(_itemList[idx+1].nums))
        cell.number:setLocalZOrder(10)

        local v = _itemList[idx+1]

        local sprite = game.newSprite()
        setCommonDrop(v.type,v.detailId,sprite,nil,nil)
        cell.card:getParent():addChild(sprite)
        sprite:setPosition(53, 53)

        if self._flag_showArrow == true then
            if self.dropTableView:getContentOffset().x >= self.dropTableView:maxContainerOffset().x then
                self.menuLeft:setVisible(true)
                self.menuRight:setVisible(false)
            elseif self.dropTableView:getContentOffset().x <= self.dropTableView:minContainerOffset().x then
                self.menuLeft:setVisible(false)
                self.menuRight:setVisible(true)
            end
        end

        return cell
    end

    local layerSize = self.layerContent:getContentSize()

    self.dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.dropTableView:setBounceable(true)
    self.dropTableView:setTouchEnabled(true)
    self.dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.dropTableView:setDelegate()
    self.dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.layerContent:addChild(self.dropTableView)

    self.dropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    if table.nums(_itemList) >= 4 then
        self._flag_showArrow = true
        self.menuLeft:setVisible(true)
        self.menuRight:setVisible(true)
    else
        self._flag_showArrow = false
        self.menuLeft:setVisible(false)
        self.menuRight:setVisible(false)
    end

    self.dropTableView:reloadData()
end

--初始化上阵英雄信息,没有删除是因为防止在后续过中需要调用
function FVFightResult:initData()



    self.heroIDs = {}

    local lineUpList = getDataManager():getLineupData():getSelectSoldier()

    local _heroList = {}
    for k,v in pairs(lineUpList) do
        _heroList[v.slot_no] = v.hero.hero_no
    end

    local index = 1
    for k,v in pairs(_heroList) do
        if v ~= 0 then
            self.heroIDs[index] = v
            index = index + 1
        end
    end
end

function FVFightResult:showHeroWithExp()

    print("----showHeroWithExp-----")

    local heroExp = nil
    local soldierData = getDataManager():getSoldierData()
    if self.fightType  == TYPE_PVP or self.fightType  == TYPE_TRAVEL then
        heroExp = 0
    else
        local stageId = getDataManager():getFightData():getFightingStageId()
        heroExp = 0--getTemplateManager():getInstanceTemplate():getClearanceHeroExp(stageId)
        --战斗失败应该为0
        print("------------heroExp:"..heroExp)
    end


    local function showHeroCard(pos, heroId) -- pos: 界面上左到右的头像位置
        local icon = self.soldierTemp:getSoldierIcon(heroId)
        local quality = self.soldierTemp:getHeroQuality(heroId)

        self.heroImgs[pos]:setTexture("res/icon/hero/"..icon)
        self.heroFrames[pos]:setSpriteFrame(getHeroIconQuality(quality))
        self.heroExpNums[pos]:setString("+"..tostring(heroExp))

        self.heroProgress[pos]:setVisible(false)

        -- exp progress timer
        local expProgress = cc.ProgressTimer:create(self.heroProgress[pos])
        expProgress:setAnchorPoint(cc.p(0, 0.5))
        expProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        expProgress:setMidpoint(cc.p(0, 0))
        expProgress:setBarChangeRate(cc.p(1, 0))
        expProgress:setPosition(self.heroProgress[pos]:getPosition())
        self.heroProgress[pos]:getParent():addChild(expProgress)

    end

    for i=1, 6 do
        local hero_id = self.heroIDs[i]
        if hero_id then
            showHeroCard(i, hero_id)
        else
            self.heroImgs[i]:setVisible(false)
            self.heroFrames[i]:setVisible(false)
            self.heroProgress[i]:getParent():setVisible(false)
            self.heroExpNums[i]:setVisible(false)
        end
    end
end

--
function FVFightResult:showTeamExp()

	if self.fightType == TYPE_STAGE_NORMAL then --只有关卡战斗才显示战斗经验
    	self.teamNodeGroup:setVisible(true)

		self.labelTeamExp = self.ccbiRootNode["expTeamValue"]
		self.labelTeamMoney = self.ccbiRootNode["moneyValue"]
		self.lbTeamLevel = self.ccbiRootNode["lbTeamLevel"]
		self.progressline = self.ccbiRootNode["progress_line"]

		-- local commonData = getDataManager():getCommonData()
		local level = self.commonData:getLevel()
		self.lbTeamLevel:setString(level)

		local maxExp = getTemplateManager():getPlayerTemplate():getMaxExpByLevel(level)
		local _exp = self.commonData:getExp()

		self.progressline:setVisible(false)
		self.expPrgress = cc.ProgressTimer:create(self.progressline)
		self.expPrgress:setAnchorPoint(self.progressline:getAnchorPoint())
		self.expPrgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
		self.expPrgress:setBarChangeRate(cc.p(1, 0))
		self.expPrgress:setMidpoint(cc.p(0, 0))
		self.expPrgress:setLocalZOrder(0)
		self.expPrgress:setScaleX(self.progressline:getScaleX());

		self.expPrgress:setPosition(self.progressline:getPosition())
		self.progressline:getParent():addChild(self.expPrgress)

		self.expPrgress:setPercentage(_exp / maxExp * 100)

		if self.fightResult == 1 and self.fightType ~= TYPE_PVP and self.fightType ~= TYPE_TRAVEL then
	        local stageId = getDataManager():getFightData():getFightingStageId()
	        local teamExp = getTemplateManager():getInstanceTemplate():getClearanceExp(stageId)
	        local teamMoney = getTemplateManager():getInstanceTemplate():getClearanceMoney(stageId)
	        self.labelTeamExp:setString(tostring(teamExp))
	        self.labelTeamMoney:setString(tostring(teamMoney))
	    else
		    --------------------ljr 战斗失败，不应该获得经验和银币
		    self.labelTeamExp:setString(tostring(0))
		    self.labelTeamMoney:setString(tostring(0))
		    ----------------------------------------
		end
	else
		self.teamNodeGroup:setVisible(false)
	end
end


return FVFightResult
