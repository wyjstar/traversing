-- 关卡节点
--[[
	@ 需要 setData(stageId) 来设置属性
	@ setStarHide(boolean) : 用来设置星星是否隐藏
	@ setLocked(boolean) : 用来设置关卡节点是否可点击
]]

local PVChapterNode = class("PVChapterNode", function ()
    return cc.Node:create()
end)

function PVChapterNode:ctor()

	self:init()
	self:initView()

    self._stageTemp = getTemplateManager():getInstanceTemplate()
    self._languageTemp = getTemplateManager():getLanguageTemplate()
    self._stageData = getDataManager():getStageData()
    self._resourceTemp = getTemplateManager():getResourceTemplate()
end

function PVChapterNode:init()

	self.ccbiNode = {}
    -- 添加CCB界面
    self:initTouchListener()
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("instance/ui_chapters_node.ccbi", proxy, self.ccbiNode)
    self:addChild(node)

end

function PVChapterNode:initTouchListener()

    local function EnterCallback()
        print("Enter Stage .....")
        getAudioManager():playEffectButton2()
        -- 进入关卡
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVStageDetails", self.data)

        groupCallBack(GuideGroupKey.BTN_GUANKA)

        -- stepCallBack(G_GUIDE_00102)
        -- stepCallBack(G_SELECT_FIRST_POINT)

        -- stepCallBack(G_GUIDE_20074)

        -- stepCallBack(G_GUIDE_30101)                  -- 30004 点击关卡
        -- stepCallBack(G_GUIDE_30127)                  -- 点击2.2关卡 G_GUIDE_30114 没有
        -- stepCallBack(G_GUIDE_30122)                  -- 30027 点击2.5关卡  
        -- stepCallBack(G_GUIDE_40116)
        -- stepCallBack(G_GUIDE_40124)


    end
    self.ccbiNode["UIChaptersNode"] = {}
    self.ccbiNode["UIChaptersNode"]["MenuClickEnter"] = EnterCallback
end

--初始化控件
function PVChapterNode:initView()

	--获取控件
	self.ccbiRootNode = self.ccbiNode["UIChaptersNode"]
	self.labelName = self.ccbiRootNode["label_name"]
	self.star1 = self.ccbiRootNode["sprite_star1"]
	self.star2 = self.ccbiRootNode["sprite_star2"]
	self.star3 = self.ccbiRootNode["sprite_star3"]
	self.frame = self.ccbiRootNode["img_frame_locked"]  -- 关卡框
	self.frameLock = self.ccbiRootNode["img_frame_unlock"]
	self.btnMenu = self.ccbiRootNode["menu_btn"]    -- 武将头像
	self.maskLayer = self.ccbiRootNode["mask_laycolor"]
	self.posNode = self.ccbiRootNode["node_pos"]
	self.imgLock = self.ccbiRootNode["img_lock"]
	self.chapterNum = self.ccbiRootNode["chapterNum"]

	-- 设置初始的位置
	local _posx, _posy = self.posNode:getPosition()
	self:setPosition(_posx, _posy)

	-- local node = UI_Guankatielian()
	-- self:addChild(node)
end

function PVChapterNode:setData(stageId)

	assert(stageId, "SetData(), parameter 1 can not be nil !")
	self.data = stageId

	local stageItem = self._stageTemp:getTemplateById(stageId)
	local _name = self._languageTemp:getLanguageById(stageItem.name)
    self.starNum = self:getStarNumBySimpleStageId(stageId)
    local _iconFrame = self._resourceTemp:getResourceById(stageItem.icon)
    local _iconFrameMask = string.gsub(_iconFrame, ".png", "_mask.png")
    local _icon = self._resourceTemp:getResourceById(stageItem.iconHero)

	self.labelName:setString(_name)
	self.frame:setSpriteFrame(_iconFrame)
	self.frameLock:setSpriteFrame(_iconFrameMask)
	self.btnMenu:setNormalImage(game.newSprite(_icon))

	-- 胜利关卡显示星星砸落特效 -- 新关卡开启特效
	local currentStageId = self._stageData:getCurrStageId()
	if currentStageId ~= nil then
		local chapterNo, stageNo = self._stageTemp:getIndexofStage(stageId)
		local simpleStageId = self._stageTemp:getSimpleStage(chapterNo,stageNo)
		local normalStageId = self._stageTemp:getNormalStage(chapterNo,stageNo)
		local diffcultStageId = self._stageTemp:getDiffcultStage(chapterNo,stageNo)
		local currentStageState = self._stageData:getStageState(currentStageId)
		print("-------currentStageState-------",currentStageState)
	   	if currentStageState == 1 then
	   		print("-------currentStageState-------",currentStageId)
	   		if currentStageId == simpleStageId then
	   			print("-------simpleStageId-------",currentStageId)
	   			local node = UI_Guankaxingxing()        -- 关卡星星
	   			self.star1:addChild(node)
			elseif currentStageId == normalStageId then
				print("-------normalStageId-------",currentStageId)
				local node = UI_Guankaxingxing()        -- 关卡星星
			    self.star2:addChild(node)
			elseif currentStageId == diffcultStageId then
				print("-------diffcultStageId-------",currentStageId)
				local node = UI_Guankaxingxing()        -- 关卡星星
			    self.star3:addChild(node)
			end

			--[[local function showNewGuide()
		        print("---PVChapterNode: 执行是否有新手引导检查---")
		        local guideItem = getNewGManager():getCurrentInfo()
		        local trigger=guideItem.trigger
		        if trigger==4 then
		            if getNewGManager():getCurrentGid() == G_GUIDE_20115 then
		                getNewGManager():createOtherRewards()
		            end
		            getNewGManager():startGuide()
		        end
		    end]]--

		    ------ 测试通关关卡开启新功能开启使用
		    -- getStagePassOpen():startShowViewByStageId(currentStageId,false)

			-- 新关卡开启特效
			local nextStageId = self._stageTemp:getNextStage(currentStageId)	    --获取下一关id
			if nextStageId ~= -1 and nextStageId == simpleStageId then
				local _nextStageState, _firstOpen = self._stageData:getStageStateAndFirstOpen(nextStageId)	--获取下一关的状态-1:开启没打过,是否第一次开启
			    self._stageData:setStageNoFirstOpen(nextStageId)

			    print("-------nextStageId, ", nextStageId)	
			    print("-------_nextStageState ",_nextStageState)	
			    print("-------_firstOpen ",_firstOpen)					-- 取消关卡第一次开启状态
			    if _nextStageState == -1 and _firstOpen == true then
			       print("------新关卡开启-------")
			       local function callBack()
			       		self:setLocked(false)
			       end  
				   local node = UI_Guankatielian(callBack)         								-- 关卡开启特效
				   self.posNode:addChild(node)
				   local item = self._stageTemp:getTemplateById(currentStageId)
                   if item.open[1] ~= nil then 
                   		print("------通关关卡开启新功能-------")
				   		getStagePassOpen():startShowViewByStageId(currentStageId,false)
				   end
				end
			else
				-- self._stageData:setStageNoFirstOpen(nextStageId)
			end		
		end
	else
		local _stageState, _firstOpen = self._stageData:getStageStateAndFirstOpen(stageId)
		if _firstOpen then
			self._stageData:setStageNoFirstOpen(stageId)
			self:setLocked(false)
		end
	end


	self:resetData() -- 重置属性

	local chapterIdx = self._stageTemp:getIndexofStage(stageId)
	if chapterIdx == 2 then self:setStarMax(2) end

	local chapterNo, stageNo = self._stageTemp:getIndexofStage(stageId)
	self.chapterNum:setString(chapterNo .. "-" .. stageNo)
end

function PVChapterNode:resetData()

	-- print(self.starNum)
	-- star
	if self.starNum <= 2 then self.star3:setSpriteFrame("ui_common_startdown.png") end
	if self.starNum <= 1 then self.star2:setSpriteFrame("ui_common_startdown.png") end
	if self.starNum == 0 then self.star1:setSpriteFrame("ui_common_startdown.png") end
	-- icon
end

function PVChapterNode:setStarHide(flag)
	print("flag ======== ", flag)
	self.star1:setVisible(flag)
	self.star2:setVisible(flag)
	self.star3:setVisible(flag)
end

-- 根据最大星级数更改布局
function PVChapterNode:setStarMax(num)
	if num == 1 then
		self.star3:setVisible(false)
		local posX,posY = self.star2:getPosition()
		self.star1:setPosition(posX, posY)
		self.star2:setVisible(false)
	elseif num == 2 then
		local starSize = self.star1:getContentSize()
		local posCenterX,posCenterY = self.star2:getPosition()
		self.star1:setPositionX(posCenterX-starSize.width/2)
		self.star2:setPosition(posCenterX+starSize.width/4, self.star1:getPositionY())
		self.star3:setVisible(false)
	else
		-- do nothing
	end
end

-- 设置是否上锁
-- @ param flag : false 不上锁，true 上锁
function PVChapterNode:setLocked(flag)
	self.btnMenu:setEnabled(not flag)
	self.maskLayer:setVisible(flag)
	self.frame:setVisible(not flag)
	self.frameLock:setVisible(flag)
	self.imgLock:setVisible(flag)
end

-- 根据简单关卡id获取星星数目
function PVChapterNode:getStarNumBySimpleStageId( id )
    local count = 0
    local chapterIdx, stageIdx = self._stageTemp:getIndexofStage(id)
    if self._stageData:getStageState(id) == 1 then count = count + 1 end

    if chapterIdx == 1 then return count end -- 第一章只有simple

    local _normalId = self._stageTemp:getNormalStage(chapterIdx, stageIdx)
    if self._stageData:getStageState(_normalId) == 1 then count = count + 1 end

    if chapterIdx == 2 then return count end -- 第二章没有diffcult

    local _diffId = self._stageTemp:getDiffcultStage(chapterIdx, stageIdx)
    if self._stageData:getStageState(_diffId) == 1 then count = count + 1 end

    return count
end


--@return
return PVChapterNode

