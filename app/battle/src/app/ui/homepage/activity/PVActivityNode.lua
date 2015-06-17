-- 每日签到的节点
-- setState(d) : d: 1 已签状态，2 可补签状态，3 当前可签状态，4 未签不可签状态

local PVActivityNode = class("PVActivityNode", function ()
	return ccui.Layout:create()
end)

function PVActivityNode:ctor()
	game.addSpriteFramesWithFile("res/ccb/resource/ui_shop.plist")

	self:initView()
	self.currState = 4
	self:updateData()

	self.resourceTemp = getTemplateManager():getResourceTemplate()
	self.soldierTemp = getTemplateManager():getSoldierTemplate()
	self.equipTemp = getTemplateManager():getEquipTemplate()
	self.chipTemp = getTemplateManager():getChipTemplate()
	self.bagTemp = getTemplateManager():getBagTemplate()
	self.dropTemp = getTemplateManager():getDropTemplate()
	self.resTemp = getTemplateManager():getResourceTemplate()

	self.vipNo = getDataManager():getCommonData():getVip()
end

-- param data : 是sign_in_config中的一条数据
-- {["id"]=1,["times"]=1,["month"]=1,["reward"]={["1"]={[1]=1000,[2]=1000,[3]=0,},},}
function PVActivityNode:setData(data)
	self.isEquip = false
	self.isChip = false
	self.rewardData = data

	local function setItemImage(img, res, quality)
		-- img:loadTexture(res, 1) --竟然会编译提示出spriteFrameName不可用
		local _x, _y = img:getPosition()
		local _z = img:getLocalZOrder()
		img:removeFromParent(true)
		-- print("res -=======================- ", res)
		img = game.newImageView(res)
		img:setPosition(_x, _y)
		img:setLocalZOrder(_z)
		img:setScale(0.56)
		self:addChild(img)

		local _contentSize = img:getContentSize()
		-- local frame = game.newImageView("#"..getIconByQuality(quality))
		local frame = game.newImageView("#"..getNewIconByQuality(quality))
		frame:setScale(0.71)
		-- frame:setPosition(_contentSize.width/2, _contentSize.height/2)
		frame:setPosition(_x, _y)
		self:addChild(frame,_z-1)
	end
	local function changeNewIconImage(img, res, quality)
		img = game.newImageView(res)
		-- local frame = game.newImageView("#"..getHeroIconQuality(quality))
		local frame = game.newImageView("#"..getNewIconByQuality(quality))
		img:addChild(frame)
	end
	local function setChipImage(img, res, quality)
		-- img = game.newImageView(res)
		local _x, _y = img:getPosition()
		local _z = img:getLocalZOrder()
		img:removeFromParent(true)
		img = game.newImageView(res)
		img:setPosition(_x, _y)
		img:setLocalZOrder(_z)
		if self.isEquip then img:setScale(0.26)
		else img:setScale(0.56) end
		self:addChild(img)

	 	if quality == 1 or quality == 2 then
	        bgSprite = game.newImageView("#ui_common2_bg2_lv.png")
	    elseif quality == 3 or quality == 4 then
	        bgSprite = game.newImageView("#ui_common2_bg2_lan.png")
	    elseif quality == 5 or quality == 6 then
	        bgSprite = game.newImageView("#ui_common2_bg2_zi.png")
	    end
	    bgSprite:setScale(0.71)
		bgSprite:setPosition(_x, _y)
		bgSprite:setLocalZOrder(_z-1)
		self:addChild(bgSprite)

		local chipSprite = game.newImageView("#ui_common2_cuipian.png")
		
		chipSprite:setScale(0.71)
		chipSprite:setPosition(_x+38, _y+36)
		chipSprite:setLocalZOrder(_z+1)
		self:addChild(chipSprite)
	end
	-- 右上角数字
	if data.times ~= nil then 
		self.number = data.times  -- 日期，每月的几号
		-- self:setTimeNum(self.number,self.sprLeftTimesNum,self.sprRightTimesNum)
		self.labelTimeNum:setString(self.number)
		self.labelTimeNumd:setString(self.number)
		self.labelTimeNum:setVisible(true)
	end

	if self.rewardData.vipDouble ~= nil and self.rewardData.vipDouble ~= 0 then
		self.nodeVip:setVisible(true)
		self:setVipNo(self.rewardData.vipDouble,self.imgVipNol,self.imgVipNor)
	end
	-- if data.Type ~= nil and data.Type == 12 then    
	-- 	self.imgArrowRight:setVisible(false)
	-- 	self.imgLastTimesBg:setVisible(false)
	-- 	self.imgTimesBg:setVisible(false)
	-- elseif data.Type ~= nil and data.Type == 13 then
	-- 	self.imgArrowDown:setVisible(false)
	-- 	self.imgLastTimesBg:setVisible(false)
	-- 	self.imgTimesBg:setVisible(false)
	-- end
	-- self.labelDaySign:setString("第"..self.number.."天")

	-- 获取到图片
	for k,v in pairs(data.reward) do
		-- k 就是类型，len小于三位数就是资源图id
		if k == "101" then -- hero
			local _temp = self.soldierTemp:getSoldierIcon(v[3])
            local _quality = self.soldierTemp:getHeroQuality(v[3])
            -- changeNewIconImage(self.menuCard, _temp, _quality)
            setItemImage(self.menuCard, "res/icon/hero_new/".._temp, _quality)
            -- self.labelRewardNum:setString("X" .. v[1])
		elseif k == "102" then -- equipment
			local _temp = self.equipTemp:getEquipResIcon(v[3])
            local _quality = self.equipTemp:getQuality(v[3])
            setItemImage(self.menuCard, "res/equipment/".._temp, _quality)
            -- self.labelRewardNum:setString("X" .. v[1])
		elseif k == "103" then -- hero chip;
			local _temp = self.chipTemp:getTemplateById(v[3]).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            local _quality = self.chipTemp:getTemplateById(v[3]).quality
            setChipImage(self.menuCard, "res/icon/hero_new/".._icon, _quality)
            -- self.labelRewardNum:setString("X" .. v[1])
		elseif k == "104" then -- equipment chip
			self.isEquip = true
			-- self.isChip = true
            local _temp = self.chipTemp:getTemplateById(v[3]).resId
            local _icon = self.resourceTemp:getResourceById(_temp)
            local _quality = self.chipTemp:getTemplateById(v[3]).quality
            setChipImage(self.menuCard, "res/equipment/".._icon, _quality)
            -- self.labelRewardNum:setString("X" .. v[1])
		elseif k == "105" then -- item
            local _temp = self.bagTemp:getItemResIcon(v[3])
            local _quality = self.bagTemp:getItemQualityById(v[3])
            setItemImage(self.menuCard, "res/icon/item/".._temp, _quality)
            -- self.labelRewardNum:setString("X" .. v[1])
		elseif k == "106" then -- big_bag
			-- to do 不用大包吧
		elseif k == "107" then
			local _res = self.resourceTemp:getResourceById(v[3])
			setItemImage(self.menuCard, "res/icon/resource/".._res, 1)
            -- self.labelRewardNum:setString("X" .. v[1])
		else
			local _res = self.resourceTemp:getResourceById(k)
            setItemImage(self.menuCard, "res/icon/resource/".._res, 1)
            -- self.labelRewardNum:setString("X" .. v[1])
		end
		self.labelRewardNum:setString(tostring(v[1]))
	end

end

--设置签到序号标签
function PVActivityNode:setTimeNum(num,sprlef,sprrig)
	-- cclog("输出签到日期"..num)
	local decade = roundNumber(num / 10)
	local unit = num % 10
	-- cclog("十位数  "..decade.."  ge位数  "..unit)
	local function setNum(temNum,sprite)
		local str = string.format("#ui_activity_num_%d.png",temNum)
		game.setSpriteFrame(sprite,str)
	end
	setNum(decade,sprlef)
	setNum(unit,sprrig)
	if decade == 0 then
		sprlef:setVisible(false)
		sprrig:setPosition(25,109)
	end
end
--设置签到VIP显示
function PVActivityNode:setVipNo(num,sprlef,sprrig)
	local decade = roundNumber(num / 10)
	local unit = num % 10
	local function setNum(temNum,sprite)
		local str = string.format("#vipNo_%d.png",temNum)
		game.setSpriteFrame(sprite,str)
	end
	setNum(decade,sprlef)
	setNum(unit,sprrig)
	if decade == 0 then
		sprlef:setVisible(false)
		sprrig:setPosition(cc.p(sprrig:getPositionX()-3,sprrig:getPositionY()+2))
	end
end
-- 设置状态：
-- @ param state : 0 时间过了又不能补签 1 已签状态，2 可补签状态，3 当前可签状态，4 未签不可签状态
function PVActivityNode:setState(state)
	assert(type(state) == "number", "PVActivityNode:setState() parameter error !")
	self.currState = state
	-- 更新界面
	self:updateData()
end

function PVActivityNode:initView()

	self:setSize(cc.size(106, 127))
	self:setAnchorPoint(0, 0)

	-- self.imgBgSigned = game.newImageView("#ui_activity_7.png"); self:addChild(self.imgBgSigned, 1)
	-- self.imgBgNormal = game.newImageView("#ui_activity_6.png"); self:addChild(self.imgBgNormal, 2)
	-- self.imgBgCurrent = game.newImageView("#ui_activity_5.png"); self:addChild(self.imgBgCurrent, 3)
	self.imgBgSigned = game.newImageView("#ui_common2_bg2_bai.png"); self:addChild(self.imgBgSigned, 1)
	self.imgBgNormal = game.newImageView("#ui_common2_bg2_bai.png"); self:addChild(self.imgBgNormal, 2)
	self.imgBgCurrent = game.newImageView("#ui_common2_bg2_bai.png"); self:addChild(self.imgBgCurrent, 3)
	self.imgBgSigned:setScale(0.7)
	self.imgBgNormal:setScale(0.7)
	self.imgBgCurrent:setScale(0.7)
	self.menuCard = game.newImageView(); self:addChild(self.menuCard, 4)

	self.imgLastTimesBg = game.newImageView("#ui_activity_9.png"); self:addChild(self.imgLastTimesBg,25) -- 签到序号背景图
	self.imgTimesBg = game.newImageView("#ui_activity_8.png"); self:addChild(self.imgTimesBg, 26) -- 补签状态签到序号背景图
	--self.labelTimesNum = game.newText("10","miniblack.ttf", 20); self:addChild(self.labelTimesNum, 7) -- 签到序号
	-- self.sprLeftTimesNum = game.newSprite(); self:addChild(self.sprLeftTimesNum, 27)    --签到左序号
	-- self.sprRightTimesNum = game.newSprite(); self:addChild(self.sprRightTimesNum, 27)   --签到右序号
	self.labelTimeNum = cc.LabelAtlas:_create("0", "res/ui/sign_world_light.png", 15, 23, string.byte("0"));self:addChild(self.labelTimeNum, 27)
	self.labelTimeNumd = cc.LabelAtlas:_create("0", "res/ui/sign_world_dark.png", 12.5, 20, string.byte("0"));self:addChild(self.labelTimeNumd, 27)
	self.labelTimeNum:setVisible(false)
	self.labelTimeNum:setAnchorPoint(cc.p(0.5,0.5))
	self.labelTimeNumd:setVisible(false)
	self.labelTimeNumd:setAnchorPoint(cc.p(0.5,0.5))
	-- self.labelRewardNum = game.newText("x50","miniblack.ttf", 20); self:addChild(self.labelRewardNum, 8) -- 奖励的数量
	self.labelRewardNum = game.newText("x50","Berlin.ttf", 20); self:addChild(self.labelRewardNum, 38) -- 奖励的数量
	self.labelRewardNum:setAnchorPoint(cc.p(0,0.5))

	self.imgUnSigned = game.newImageView("#ui_activity_10.png"); self:addChild(self.imgUnSigned, 9) -- 补签图
	local retroactiveEff = UI_Buqiantishi()   --补签特效
	self.imgUnSigned:addChild(retroactiveEff)

	self.imgSigning = game.newImageView("#ui_activity_qiandao.png"); self:addChild(self.imgSigning, 9) -- 签到图
	-- self.laycolorMask = game.newPanel(106, 127, cc.c3b(0,0,0)); self:addChild(self.laycolorMask, 10)
	self.laycolorMask = game.newImageView("#layerMask.png"); self:addChild(self.laycolorMask, 10)
	self.imgChecked = game.newImageView("#ui_activity_4.png"); self:addChild(self.imgChecked, 11) -- 已签到的标志图
	self.nodeVip = cc.Node:create();self:addChild(self.nodeVip,15)

	self.imgVip = game.newSprite("#vip_double_bottom.png"); self.nodeVip:addChild(self.imgVip)
	self.imgVip:setPosition(cc.p(100,124))
	self.imgVipDoub = game.newSprite("#vip_double.png"); self.imgVip:addChild(self.imgVipDoub)
	self.imgVipDoub:setPosition(46,34)
	self.imgVipNol = game.newSprite("#vipNo_6.png"); self.imgVipDoub:addChild(self.imgVipNol)
	self.imgVipNor = game.newSprite("#vipNo_6.png"); self.imgVipDoub:addChild(self.imgVipNor)

	self.imgVipNol:setPosition(cc.p(13,30))
	self.imgVipNor:setPosition(cc.p(19,27))
	self.nodeVip:setScale(0.71)
	self.nodeVip:setVisible(false)

	self.imgArrowRight = game.newSprite("#arrow_dark.png"); self:addChild(self.imgArrowRight,28)
	self.imgArrowDown = game.newSprite("#arrow_dark.png"); self:addChild(self.imgArrowDown,28)	
	self.imgArrowRight:setPosition(103,68)
	self.imgArrowRight:setRotation(-90)
	self.imgArrowDown:setPosition(50,20)

	self.imgBgSigned:setPosition(53, 70)
	self.imgBgNormal:setPosition(53, 70)
	self.imgBgCurrent:setPosition(53, 70)
	self.menuCard:setPosition(53, 70)
	self.imgLastTimesBg:setPosition(25, 104)
	self.imgTimesBg:setPosition(25, 104)

	-- self.sprLeftTimesNum:setPosition(20,109)
	-- self.sprRightTimesNum:setPosition(30,109)
	self.labelTimeNum:setPosition(23,105)
	self.labelTimeNumd:setPosition(23,105)

	self.labelRewardNum:setPosition(15, 48)

	self.imgUnSigned:setPosition(55, 70)
	self.imgSigning:setPosition(65, 70)

	self.laycolorMask:setPosition(cc.p(54,68))
	-- self.laycolorMask:setBackGroundColorOpacity(100)

	self.imgChecked:setPosition(54, 70)
	-- self.imgChecked:setScale(0.5)

	-- self.labelDaySign:setPosition(55, 0)

	local function menuClicked(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.vipNo = getDataManager():getCommonData():getVip()
			local rewardData = {}
			rewardData["reward"] = clone(self.rewardData.reward)
			if self.rewardData.vipDouble ~= nil and self.rewardData.vipDouble ~= 0 and self.vipNo >= self.rewardData.vipDouble then
				cclog("-------vip double------------")
				local key = table.getKeyByIndex(rewardData.reward,1)
		        rewardData.reward[key][1] = rewardData.reward[key][1] * 2 
		        rewardData.reward[key][2] = rewardData.reward[key][2] * 2 
			end


		    getAudioManager():playEffectButton2()

            ACTIVITY_REPAIRE_DAY = self:getTag()
            local _times = getDataManager():getCommonData():getRepaireTimes()
            local money = getTemplateManager():getBaseTemplate():getRepaireSignMoney(_times+1)

            getDataManager():getActiveData():setGettingSignReward(rewardData.reward)
            getOtherModule():showOtherView("SystemTips", string.format(Localize.query("activity.1"), money))
        end
	end
	local function signClicked(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.vipNo = getDataManager():getCommonData():getVip()
			local rewardData = {}
			rewardData["reward"] = clone(self.rewardData.reward)
			if self.rewardData.vipDouble ~= nil and self.rewardData.vipDouble ~= 0 and self.vipNo >= self.rewardData.vipDouble then
				cclog("-------vip double------------")
				local key = table.getKeyByIndex(rewardData.reward,1)
		        rewardData.reward[key][1] = rewardData.reward[key][1] * 2 
		        rewardData.reward[key][2] = rewardData.reward[key][2] * 2 
			end

			getAudioManager():playEffectButton2()
			
			getNetManager():getActivityNet():sendGetSignMsg()
            getDataManager():getActiveData():setGettingSignReward(rewardData.reward)
            -- getOtherModule():showOtherView("DialogGetCard",self.rewardData.reward)
        end
	end

	local function onItemClick(sender, eventType)
	 cclog("-------------------11111111-----------")
  		local signState = self.currState
  		if self.rewardData.Type ~= nil then
  			ACTIVITY_REPAIRE_DAY = self.rewardData.id
  			EXTRA_SIGN_GIFT = true
  		else
  			ACTIVITY_REPAIRE_DAY = self:getTag()
  			EXTRA_SIGN_GIFT = false
  		end

		self.vipNo = getDataManager():getCommonData():getVip()
		local rewardData = {}
		rewardData["reward"] = clone(self.rewardData.reward)
		if self.rewardData.vipDouble ~= nil and self.rewardData.vipDouble ~= 0 and self.vipNo >= self.rewardData.vipDouble then
			cclog("-------vip double------------")
			local key = table.getKeyByIndex(rewardData.reward,1)
	        rewardData.reward[key][1] = rewardData.reward[key][1] * 2 
	        rewardData.reward[key][2] = rewardData.reward[key][2] * 2 
		end

  		getDataManager():getActiveData():setGettingSignReward(rewardData.reward)
        
		if eventType == ccui.TouchEventType.ended then
			for k,v in pairs(self.rewardData.reward) do
				k = tonumber(k)
				if k == 101 then -- 武将
			        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", v[3], 2, nil, 1)
			    elseif k == 102 then -- 装备
			        local equipment = getTemplateManager():getEquipTemplate():getTemplateById(v[3])
			        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, nil)
			    elseif k == 103 then -- 武将碎片
			        local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(v[3])
			        if signState == 3 then 	--签到
			        	getOtherModule():showOtherView("PVCommonChipDetail", 1, v[3], nowPatchNum, 3)
			        elseif signState == 2 then
			        	getOtherModule():showOtherView("PVCommonChipDetail", 1, v[3], nowPatchNum, 4)
			        else
			        	getOtherModule():showOtherView("PVCommonChipDetail", 1, v[3], nowPatchNum, 1)
			        end
			    elseif k == 104 then -- 装备碎片
			        local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(v[3])
			        if signState == 3 then 	--签到
			        	getOtherModule():showOtherView("PVCommonChipDetail", 2, v[3], nowPatchNum, 3)
			        elseif signState == 2 then 	--补签
			        	getOtherModule():showOtherView("PVCommonChipDetail", 2, v[3], nowPatchNum, 4)
			        else
			        	getOtherModule():showOtherView("PVCommonChipDetail", 2, v[3], nowPatchNum, 1)
			        end
			    elseif k == 105 then  -- 道具
			    	if signState == 3 then 	--签到
			        	getOtherModule():showOtherView("PVCommonDetail", 1, v[3], 3)
			        elseif signState == 2 then --补签
			        	getOtherModule():showOtherView("PVCommonDetail", 1, v[3], 4)
			        else
			        	getOtherModule():showOtherView("PVCommonDetail", 1, v[3], 1)
			        end
			    elseif k < 100 then
			    	-- if k == 2 then
        --         		getOtherModule():showOtherView("PVCommonDetail", 2, k, 2)
        --         	else
			     --    	getOtherModule():showOtherView("PVCommonDetail", 2, k, 1)
			     --    end
			        if signState == 3 then 	--签到
			        	getOtherModule():showOtherView("PVCommonDetail", 2, k, 3)
			        elseif signState == 2 then  --补签
			        	getOtherModule():showOtherView("PVCommonDetail", 2, k, 4)
			        else
			        	getOtherModule():showOtherView("PVCommonDetail", 2, k, 1)
			        end
			    elseif k == 107 then
			    	if signState == 3 then 	--签到
			        	getOtherModule():showOtherView("PVCommonDetail", 2, v[3], 3)
			        elseif signState == 2 then --补签
			        	getOtherModule():showOtherView("PVCommonDetail", 2, v[3], 4)
			        else
			    		getOtherModule():showOtherView("PVCommonDetail", 2, v[3], 1)
			    	end
			    end
			end
		end
	end

	--物品详细信息查看
	self.imgBgSigned:setTouchEnabled(true)
	self.imgBgSigned:addTouchEventListener(onItemClick)
	self.imgBgCurrent:setTouchEnabled(true)
	self.imgBgCurrent:addTouchEventListener(onItemClick)
	self.imgBgNormal:setTouchEnabled(true)
	self.imgBgNormal:addTouchEventListener(onItemClick)
	--签到使用
	self.imgUnSigned:setTouchEnabled(false)
	-- self.imgUnSigned:addTouchEventListener(menuClicked)
	self.imgSigning:setTouchEnabled(false)
	-- self.imgSigning:addTouchEventListener(signClicked)

end

function PVActivityNode:updateData()
	-- 1 已签状态，2 可补签状态，3 当前可签状态，4 未签不可签状态

	if self.currState == 1 then
		self:setBgState("signed")
		self:removeChildByTag(100)
		-- self:stopAllActions()
		self.laycolorMask:setVisible(true)
		self.imgTimesBg:setVisible(true)
		self.imgLastTimesBg:setVisible(false)
		self.imgUnSigned:setVisible(false)
		self.imgChecked:setVisible(true)
		self.imgSigning:setVisible(false)
		--self.imgBgSigned:setTouchEnabled(false)
		self.imgBgSigned:setTouchEnabled(true)

		game.setSpriteFrame(self.imgArrowRight, "#arrow_light.png")
		game.setSpriteFrame(self.imgArrowDown, "#arrow_light.png")
		self.labelTimeNumd:setVisible(true)
		self.labelTimeNum:setVisible(false)
		
	elseif self.currState == 2 then
		self:setBgState("signed")
		self.laycolorMask:setVisible(false)
		self.imgTimesBg:setVisible(false)
		self.imgLastTimesBg:setVisible(true)
		self.imgUnSigned:setVisible(true)
		self.imgSigning:setVisible(false)
		self.imgChecked:setVisible(false)

		-- local timeEff = self:getChildByTag(100)
		-- if timeEff == nil then
		-- 	-- timeEff = UI_Wujiangbuzhenxuanze()
		-- 	timeEff = UI_Buqiantishi()
		-- 	-- timeEff:setScale(1.3)
		-- 	timeEff:setPosition(cc.p(-9,5))
		-- 	timeEff:setTag(100)
		-- 	self:addChild(timeEff,1003)
		-- end
		
	elseif self.currState == 3 then
		self:setBgState("current")
		self.laycolorMask:setVisible(false)
		self.imgTimesBg:setVisible(true)
		self.imgLastTimesBg:setVisible(false)
		self.imgUnSigned:setVisible(false)
		self.imgSigning:setVisible(true)
		self.imgChecked:setVisible(false)

		local timeEff = self:getChildByTag(100)
		if timeEff == nil then
			timeEff = UI_Meiriqiandao()
			-- timeEff:setScale(1.3)
			timeEff:setPosition(cc.p(50,70))
			timeEff:setTag(100)
			self:addChild(timeEff,1003)
		end

	elseif self.currState == 4 then
		self:setBgState("normal")
		-- self.laycolorMask:setVisible(true)
		self.laycolorMask:setVisible(false)
		self.imgTimesBg:setVisible(true)
		self.imgLastTimesBg:setVisible(false)
		self.imgUnSigned:setVisible(false)
		self.imgChecked:setVisible(false)
		self.imgSigning:setVisible(false)
	elseif self.currState == 0 then
		self:setBgState("signed")

		self.imgBgSigned:setTouchEnabled(false)

		--self.imgBgSigned:setTouchEnabled(false)
		--self.imgBgSigned:setTouchEnabled(true)
		self.laycolorMask:setVisible(true)
		self.imgTimesBg:setVisible(true)
		self.imgLastTimesBg:setVisible(false)
		self.imgUnSigned:setVisible(false)
		self.imgChecked:setVisible(false)
		self.imgSigning:setVisible(false)
		
	end
	self.imgSigning:setVisible(false)

	if self.rewardData ~= nil and self.rewardData.Type ~= nil then 
		if self.rewardData.Type == 12 then 
			self.imgArrowRight:setVisible(false)			
		elseif self.rewardData.Type == 13 then
			self.imgArrowDown:setVisible(false)			
		end
		self.imgLastTimesBg:setVisible(false)
		self.imgTimesBg:setVisible(false)
	end

end

-- @ param _sta : "signed", "normal", "current"
function PVActivityNode:setBgState(_sta)
	if _sta == "current" then
		self.imgBgCurrent:setVisible(true)
		self.imgBgCurrent:setTouchEnabled(true)
		self.imgBgNormal:setVisible(false)
		self.imgBgNormal:setTouchEnabled(false)
		self.imgBgSigned:setVisible(false)
		self.imgBgSigned:setTouchEnabled(false)
	elseif _sta == "normal" then
		self.imgBgCurrent:setVisible(false)
		self.imgBgCurrent:setTouchEnabled(false)
		self.imgBgNormal:setVisible(true)
		self.imgBgNormal:setTouchEnabled(true)
		self.imgBgSigned:setVisible(false)
		self.imgBgSigned:setTouchEnabled(false)
	else
		self.imgBgCurrent:setVisible(false)
		self.imgBgCurrent:setTouchEnabled(false)
		self.imgBgNormal:setVisible(false)
		self.imgBgNormal:setTouchEnabled(false)
		self.imgBgSigned:setVisible(true)
		self.imgBgSigned:setTouchEnabled(true)
	end
end

function PVActivityNode:setArrowRightDark()
	game.setSpriteFrame(self.imgArrowRight, "#arrow_dark.png")
end
function PVActivityNode:setArrowDownDark()
	game.setSpriteFrame(self.imgArrowDown, "#arrow_dark.png")
end

return PVActivityNode


