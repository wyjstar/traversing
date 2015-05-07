local protectedLayerTag = 15643

NewGManager = NewGManager or class("NewGManager")
import("..datacenter.template.config.newbee_guide_config")
import(".NewGContent")

GUID_DISTROY_ID     = 999999    ---非强制引导点击跳过后 修改 引导编号

local GuideId = GuideId

local GUIDE_GROUP = {}
local PageIndex = {
    HOME = 10,
    LINE_UP = 20
}

local TriggerIndex = {
    PAGE = 2,
    LEVEL = 3,
    STAGE_OVER = 4,
    STAGE_START = 5
}

local RewardIndex = {
    HERO = "101"
}

function NewGManager:ctor(controller)

    self.languageTemplate = getTemplateManager():getLanguageTemplate()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.resourceData = getDataManager():getResourceData()
    self.area_x = 200
    self.area_y = 50
    self.area_w = 50
    self.area_h = 50
    self.currentGID = 0
    self.gWordIndex = 0
    self.guideItem = nil
    self.dBoxView = nil
    self.gHeroView = nil
    self.newBieNet = getNetManager():getNewBieNet()
    self.commonData = getDataManager():getCommonData()

    self.zorderNewHero = 35  --新英雄
    self.zorderHighLight = 20 
    self.zorderTouchLayer = 30 --触摸层
    self.zorderHandLayer = 40 --小手
    self.zorderDBox = 50
    self._isGuiding = false

    self.guideProtectedLayer = game.createShieldLayer()
    self.guideProtectedLayer:retain()
    self.guideProtectedLayer:setTag(protectedLayerTag)

    self.runScene = nil

    self.touchOffSet = cc.p(0,0)
    self.handOffSet = cc.p(0,0)

    self.newBeeFightWin = false   --  新手引导过程中战斗胜利

    self.netManager = getNetManager():getHttpCenter()
    self:registerNetCallback()
end

--新手引导，参数传入组id, 附加参数用于判断
function NewGManager:startGuideForGroupId(groupid, params)
    print("NewGManager:startGuideForGroupId===========>",groupid)

    --引导id检查
    if not self.currentGID then return end

    local groups = GuideGroup[groupid]
    table.print(groups)
    print("NewGManager:startGuideForGroupId currentGID=",self.currentGID)
    print("NewGManager:startGuideForGroupId===========<")   
    --组id检查
    if not groups then return end
    --获取引导数据
    if not self.guideItem or self.guideItem.id ~= self.currentGID then
        self.guideItem = self:getNewBeeConfigById(self.currentGID)        
    end

    if not self.guideItem then
        print("============startGuideForGroupId, guideItem = null=============", self.currentGID) 
        return 
    end

    local nextGuideId = self.guideItem.skip_to
    --查找下一个引导id是否在当前组中，如果没有则不引导
    print("----nextGuideId ", nextGuideId)

    if table.find(groups, nextGuideId) then
        print("---------find-----------")
        self:startGuideForGuideId_(nextGuideId, params)       
    end
end

--新手引导，参数传入引导id, 附加参数用于判断
function NewGManager:startGuideForGuideId(guideid, params)
    print("NewGManager:startGuideForGuideId===========>",guideid)    
    if self.currentGID == 0 or self.currentGID == GuideId.G_START_GUIDE_FIGHT then        
        self:startGuide(guideid)
    else
        --获取引导数据
        if not self.guideItem or self.guideItem.id ~= self.currentGID then
            self.guideItem = self:getNewBeeConfigById(self.currentGID)        
        end
        if not self.guideItem then
            print("============startGuideForGuideId, guideItem = null=============", self.currentGID)  
            return 
        end        
        --下一个引导id
        local nextGuideId = self.guideItem.skip_to
        print("=======startGuideForGuideId=====nextGuideId=============", nextGuideId) 
        if nextGuideId == guideid then
            self:startGuideForGuideId_(nextGuideId, params)        
        end        
    end
end

--新手引导，参数传入引导id, 附加参数用于判断
function NewGManager:startGuideForGuideId_(guide, params)
    local guideItem = self:getNewBeeConfigById(tonumber(guide))
    --检查引导的触发条件
    local trigger = tonumber(guideItem.trigger)
    local triggerValue = tonumber(guideItem.triggerValue)
    local isGuide  = false

    print("----startGuideForGuideId_-----")
    print(triggerValue)
    print(trigger)
    --
    if trigger == TriggerIndex.PAGE then --界面触发，没用
        isGuide = true
    elseif trigger == TriggerIndex.LEVEL then --等级触发，没用
        isGuide = true                
    elseif trigger == TriggerIndex.STAGE_OVER then --完成关卡触发
        local stageState = getDataManager():getStageData():getStageStateAndFirstOpen(triggerValue)
        print(stageState)
        if stageState == 1 then   ---胜利       
            isGuide = true
        end          
    elseif trigger == TriggerIndex.START then --到达关卡触发
        isGuide = true       
    else
        isGuide = true        
    end

    print("----isGuide----")
    print(isGuide)
    --
    if isGuide then
        self:startGuide(guide, params)          
    end
end

function NewGManager:protected()
    if not self.isProtected then
        print("protected")
        self.guideProtectedLayer:setTouchEnabled(true)
        self.runScene:addChild(self.guideProtectedLayer)
        self.isProtected = true
    end
end

function NewGManager:unprotected()
    if self.isProtected then
        print("unprotected")
        self.guideProtectedLayer:setTouchEnabled(false)
        self.runScene:removeChildByTag(protectedLayerTag)
        self.isProtected = false
    end
end

function NewGManager:setIsGuideLevel()
    self.isGuideLevel = true
    self.isShowLevelView = true
end

function NewGManager:setCurrentGID(currentGID)
    if self.currentGID == currentGID then return end
    print("NewGManager:setCurrentGID========" .. currentGID)    
    self.currentGID = currentGID
    self.guideItem = self:getNewBeeConfigById(self.currentGID)
end

function NewGManager:getCurrentGid()    
    return self.currentGID
end

function NewGManager:getCurrentInfo()
    return self.guideItem
end


---通关后检查是否有新的引导
function NewGManager:checkStageGuide()
    if ISSHOW_GUIDE == false then
        return false
    end

    if self.guideItem == nil then
        return false
    end 
    
    local nextGuideId = self.guideItem.skip_to
    local tempItem = self:getNewBeeConfigById(tonumber(nextGuideId))
    print("checkStageGuide:nextGuideId ", nextGuideId)
    
    if tempItem == nil then
        return false
    end
    --检查引导的触发条件
    local trigger = tonumber(tempItem.trigger)
    local triggerValue = tonumber(tempItem.triggerValue)
    
    print("nextGuideId ",nextGuideId)
    print("trigger ", trigger)
    print("triggerValue ", triggerValue)

    local isGuide  = false
    if trigger == TriggerIndex.STAGE_OVER then --完成关卡触发
        --[[local _curStageId = getDataManager():getStageData():getCurrStageId()
        print("_curStageId ", _curStageId)
        if _curStageId and tonumber(_curStageId) == triggerValue then                
            isGuide = true
        end]]-- 

        isGuide = getDataManager():getStageData():getIsOpenByStageId(triggerValue)
    end

    return isGuide
end

--战斗结束之后调用，检测是否有引导, TODO: 暂注视掉有问题，再重新写
function NewGManager:checkGuide()
    -- if ISSHOW_GUIDE == false then
    --     return
    -- end
    
    -- --self.currentGID = G_GUIDE_20065 --G_GUIDE_20072
    -- print("checkGuide =========== self.currentGID === " .. self.currentGID)

    -- self.guideItem = self:getNewBeeConfigById(self.currentGID)
    -- if self.guideItem == nil then return end
    -- --test
    -- --getModule(MODULE_NAME_HOMEPAGE):showUIView("PVChapters")
    -- --self:startGuide()

    -- --这些情况都不能进入
    -- if self.currentGID == 0 or self.currentGID == -1 then
    --     local resultData = getDataProcessor():getCreateResult()
    --     if resultData ~= nil then
    --         print("-----NewGManager:checkGuide---")
    --         local isCreateSuccess = resultData.result
    --         if  isCreateSuccess then
    --             --assert(false)
    --            self:startGuide()
    --         end
    --     end
    --     return
    -- end

    -- local isMust = self.guideItem.isMust --是否强制

    -- --
    -- print("firstEnter ", getPlayerScene().firstEnter)
    -- print("isMust ", isMust)
    -- print("self.currentGID ", self.currentGID)

    -- --[[if isMust == 1 and self.currentGID == G_FIGHT_OVER_SUER and getPlayerScene().firstEnter == true then   ---战斗中结束后重新进入战斗
    --     getPlayerScene():enterBattle(100101)
    --     return
    -- end]]--

    -- if isMust == 1 and (self.currentGID == G_RECEIVE_HERO) then
    --     self:startGuide()
    -- end

    -- if isMust == 1 and self.currentGID ==G_CHANGE_WS then 
    --     getModule(MODULE_NAME_LINEUP):showUIView("PVLineUp")
    --     self:startGuide()
    -- end
    
    -- if isMust == 1 and (self.currentGID == G_SELECT_LINEUP or self.currentGID == G_SELECT_FIGHT
    --  or self.currentGID == G_GUIDE_20093 or self.currentGID == G_GUIDE_20072
    --  or self.currentGID == G_SELECT_LINEUP_2 or self.currentGID == G_GUIDE_00100 or self.currentGID == G_GUIDE_130003) then
    --     self:startGuide()
    -- end

    -- if isMust == 1 and (self.currentGID == G_GUIDE_20042 or self.currentGID == G_GUIDE_20046) then
    --     getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", 100102, "normal")
    --     self:startGuide()
    -- end

    -- if isMust == 1 and self.currentGID == G_GUIDE_00103 then
    --     getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", 100101, "normal")
    --     self:startGuide()
    -- end

    -- --[[if isMust == 1 and self.currentGID == G_GUIDE_20115 then
    --     self:createOtherRewards()
    --     self:startGuide()
    -- end]]--

    -- --特殊情况处理， 
    -- --[[if self.currentGID == G_GUIDE_20043 then
    --     --显示英雄模块，用于升级页签得引导
    --     getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierMain")
    -- end]]--

    --  --特殊情况处理，
    -- --[[if self.currentGID == G_GUIDE_20082 then
    --     isEntry = false
    --     getModule(MODULE_NAME_SHOP):showUIView("PVShopPage")
    -- end]]--

    -- --[[local item = self:getNewBeeConfigById(self.currentGID)
    -- local trigger = item.trigger
    
    -- local skipEnd = item.skipEnd --阶段结束
    --  if trigger == 2 or self.currentGID == 1 then
    --      self:startGuide()
    -- end
    --  if trigger == 2 and isMust == 1 and skipEnd == 0 then
    --     print("trigger == 2 and isMust == 1 and skipEnd == 0")
    --      self:startGuide()
    --  end
    -- if self.currentGID < G_GUIDE_20097 then
    --    self:startGuide()
    -- end]]--

end

--事件处理
function NewGManager:eventBeTriggered()
    if self.guideItem.trigger==4 then
        self:clearView()
    end
end

--受制于网络协议的新手引导
function NewGManager:onNetReceive(comid, data)
    
    print("NewGManager:onNetReceive===========>" .. self.currentGID)
    
    --if commid == NewbeeGuideStep then
        self:unprotected()
    --end
    -- print("协议的id =============== ", comid)
    print("comid --", comid)
    if comid == NewbeeGuideStep then
        -- if self.currentGID == G_FIRST_LOGIN then
        --     local isCreateSuccess = getDataProcessor():getCreateResult().result
        --     if isCreateSuccess then
        --         self:startGuide()
        --     end
        -- end
        print("data.res.result ", data.res.result)
    else

    end
end

function NewGManager:registerNetCallback()
    local function getGoodsByGuidCallback(data)
        print(" getGoodsByGuidCallback ")
        table.print(data)

        local bFind = table.find(GuidIdNeedWait, self.currentGID)
        --local bStart = self:checkStageGuide()
        print("---self.currentGID ",self.currentGID)
        print("---bFind ",bFind)
        print("---data.res.result ",data.res.result)

        if data.res.result == true and bFind then
            print("start next")
            self:startGuide(self.currentGID)
        else

        end
    end
    local socket = getNetManager():getSocket()
    socket:registerCallback(NewbeeGuideStep, "NewbeeGuideStepResponse", getGoodsByGuidCallback)
end

--开始引导
function NewGManager:startGuide(guideId, params)

    print("NewGManager:startGuide------------------", guideId)

    if guideId ~= nil then self:setCurrentGID(guideId) end

    print("NewGManager:startGuide------------------", self.currentGID)

    if self.currentGID == 0 or self.currentGID == GUID_DISTROY_ID then
        return
    end

    if not self.guideItem then return end
    

    --跳转页面判断
	local page_to = tonumber(self.guideItem.page_to)
    print("NewGManager:==========> page to ", page_to)
    if page_to ~= 0 then
        if page_to < PageIndex.HOME then
            local homePage = getPlayerScene().homeModuleView.moduleView
            homePage:scrollToPage(page_to)
        --[[elseif page_to < PageIndex.LINE_UP and page_to > PageIndex.HOME and g_isInterrupt then
            local slot = page_to -- - (PageIndex.LINE_UP - 10)
            getModule(MODULE_NAME_LINEUP):showUIView("PVLineUp", slot)]]--
        end                       
    end    

    local rewardHero = self.guideItem.rewards[RewardIndex.HERO]

    if rewardHero then
        local soldierId = rewardHero[3]
        if soldierId ~= nil then
            local res = getTemplateManager():getSoldierTemplate():getHeroAudio(soldierId)
            if res == 0 then
                cclog("没有音效")
            else
                cclog("播放音效")
                getAudioManager():playHeroEffect(res)
            end             
        end       
    end
    --显示引导页面
    self:startViewGuide()
    --发送协议
    if self.guideItem.disassembly ~=1 then
        self:sendGuidProtocol(false, self.currentGID,params)
    end

    --[[if self.currentGID == GuideId.G_GUIDE_20044 then
        self:createOtherRewards()
    end]]--
end

--阶段结束为1或者-1时发送协议，记录当前新手引导编号值
function NewGManager:sendGuidProtocol(showLoading, gid, no1, no2)
    --TODO: 注释掉判断
    -- if self.guideItem ~= nil then
    --     local rewards = self.guideItem["rewards"]
    --     local num = table.nums(rewards)
    --     print("rewards count ", num)

    --     if self.guideItem.skipEnd ~= 0 or num>0 then
    --         self:protected()
    --         -- 不清楚为什么不是每一步都发
    --         -- 现在服务器那边做法是记住你最后一次发的id
    --         -- self.newBieNet:sendDoGuideId(self.currentGID)
    --     end
    -- end
    print("----gid ",gid)

    local common_id = no1

    local sub_common_id = no2
    
    if not common_id then
        if table.find(GuideIdNeedHero, gid) then
            local soldier = getDataManager():getLineupData():getSelectSoldier()
            if soldier then common_id = soldier[1].hero.hero_no end            
        end        
    end

    self.newBieNet:sendDoGuideId(showLoading, gid, common_id, sub_common_id)
end

function NewGManager:startViewGuide()
    self.gWordIndex = 0
    self.dBoxView = nil
    game.addSpriteFramesWithFile("res/ccb/resource/ui_newHandLead.plist")

    self:checkGuideNode()
    self.guideNode:removeAllChildren()
    self:createTouchLayer()
    if self.currentGID == GuideId.G_GUIDE_20005 then
        self:createNewHeroView()
    end
    self:createHandLayer()
    self:checkShowDBox()
    self:createJumpView()
end

--isMust
--创建是否跳过引导，强制引导
function NewGManager:createJumpView()
    local isMust = self.guideItem.isMust
    if isMust == 1 then
        return
    end
    self.newHandJump = {}
    self.newHandJump["newHandJump"] = {}
    local function jumpCallBack()
        self:clearView() --清理view
        self.currentGID = GUID_DISTROY_ID
        self.guideItem = nil

        self:sendGuidProtocol(false, self.currentGID)
    end

    self.newHandJump["newHandJump"]["jumpCallBack"] = jumpCallBack
    local proxy = cc.CCBProxy:create()
    self.jumpNode = CCBReaderLoad("newHandLead/ui_newHand_jump.ccbi", proxy, self.newHandJump)

    self.guideNode:addChild(self.jumpNode, 10000)
end

--创建引导基础的node，其中有适配
function NewGManager:checkGuideNode()
    
    self.runningScene = game.getRunningScene()
    
    if self.adapterLayer and self.runningScene.scenename ~= self.adapterLayer:getParent().scenename then
        self.adapterLayer:removeFromParent()
        self.adapterLayer = nil
    end

    if self.adapterLayer == nil then
        local sharedDirector = cc.Director:getInstance()
        local glsize = sharedDirector:getWinSize()
        self.adapterLayer = cc.Layer:create()

        self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
        self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

        self.guideNode = game.newNode()
        self.adapterLayer:addChild(self.guideNode)
        self.runningScene:addChild(self.adapterLayer, 10002)
        self._isGuiding = true
        -- local function update(dt)
        --     print("===========guide update==============>")
        --     if self._isGuiding then return end
        --     self.adapterLayer:unscheduleUpdate()
        --     self:guideOver()
        -- end
        -- self.adapterLayer:scheduleUpdateWithPriorityLua(update,0)                      
    end   
    print("guide node runningScene ", self.runningScene.scenename, self.adapterLayer:getParent().scenename)
end

--开始下一个引导
function NewGManager:startGuideNext_()
    -- self.guideItem = self:getNewBeeConfigById(self.currentGID)

    -- if self.currentGID == 0  or self.currentGID == GUID_DISTROY_ID  or self.guideItem == nil then
    --     return
    -- end

    -- local skip_to = self.guideItem.skip_to
    -- local skipEnd = self.guideItem.skipEnd
    -- --当skipEnd == -1  代表阶段结束，暂停引导
    -- if skipEnd == -1 then
    --     print("=====self.currentGID "..self.currentGID.." guide pasue=====")
    --     self.currentGID = skip_to                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    --     self:startGuide()
    -- elseif skipEnd == 1 then
    --     print("=====self.currentGID "..self.currentGID.." guide over=====")

    --     self:sendGuidProtocol()
    --     self:guideOver()
    --     self.currentGID = skip_to                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ntGID = skip_to

    -- else
    --     self.currentGID = skip_to

    --     print("---------------startGuideNext---------------"..self.currentGID)
    --     self:startGuide()
    -- end
    if self.guideItem.id ~= self.currentGID then return end
    if self.guideItem.skipEnd == 0 then
        self:startGuide(self.guideItem.skip_to)
    else
        self:guideOver()        
    end
end

--引导结束，如需开始需要重新调用checkGuide() or startGuide()
function NewGManager:guideOver()
    self:clearView() --清理view
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_newHandLead.plist")
    self:guideOverEvent()
end

--引导结束，相应一些事件 TODO: 暂注释掉
function NewGManager:guideOverEvent()
    print("----NewGManager:guideOverEvent------")
    if self.currentGID == GuideId.G_GUIDE_20023 or self.currentGID == GuideId.G_GUIDE_20024 or self.currentGID == GuideId.G_GUIDE_20089 or self.currentGID == GuideId.G_GUIDE_20042 then
        getFEControl():nextStep()
        print("---nextStep----")
    elseif self.currentGID == GuideId.G_SRART_GUIDE_ANI then
        print("---newEnterFightScene----")
        newEnterFightScene()
    elseif self.currentGID == GuideId.G_GUIDE_ANI_OVER then
        print("---newExitFightScene----")
        newExitFightScene()
    end
end

--清除view
function NewGManager:clearView()
    print("NewGManager:clearView=============================>")
    if self.adapterLayer ~= nil then
        self.guideProtectedLayer:setTouchEnabled(false)
        self.adapterLayer:removeFromParent(true)
        self._isGuiding = false
    end
    self.adapterLayer = nil
    self.clipNode = nil
    self.dBoxView = nil
    self.guideNode = nil
    self.boxColerlayer = nil
    self.boxSprite = nil
    self.handNode = nil
    self.taouchLayer = nil
    self.handSprite = nil
    self.colerlayer = nil
    self.runScene = nil
    print("NewGManager clearView")
end

--检测是否显示
function NewGManager:checkShowDBox()
    local guideWord = self.guideItem.guideWord
    if #guideWord~=0 then
        self:showDBox()
    end
end

--显示对话框
function NewGManager:showDBox()
    print("_____________start_showDBox_____________")
    print("self.currentGID========" .. self.currentGID)
    local guideWord = self.guideItem.guideWord

    self.boxColerlayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 0), 640, 960)
    self.guideNode:addChild(self.boxColerlayer, self.zorderDBox)
    local lgId = guideWord[1]

    local languageStr = self.languageTemplate:getLanguageById(lgId)
    local stop_type = tonumber(self.guideItem.stop_type)
    local proxy = cc.CCBProxy:create()

    if self.dBoxView == nil then

        self.newHandNode = {}
        self.newHandNode["newHandNode"] = {}

        self.dBoxView = CCBReaderLoad("newHandLead/ui_newHand_view.ccbi", proxy, self.newHandNode)
        if self.dBoxView == nil then
            cclog("Error: in loadCCBI _name==" .. _name)
            return
        end
        self.aniNode = self.newHandNode["newHandNode"]["aniNode"]

        self.guideNode:addChild(self.dBoxView, self.zorderDBox + 1)

        -- if self.taouchLayer == nil then
            self.dBoxSLayer = game.newLayer()
            local function onTouchEvent(eventType, x, y)
                if eventType == "began" then
                    print("showDBox stop_type====" .. stop_type,self.currentGID)
                    local isConnect = self.netManager:checkNetwork()
                    print("isConnect ",isConnect)
                    if isConnect == false then
                        getOtherModule():showAlertDialog(nil, Localize.query("toast.1"))
                        return false
                    end

                    if stop_type == 0 then
                        return true
                    else
                        -- --TODO:加这不合适
                        -- if table.find(GuideIdNeedOver, self.currentGID) then
                        --     self:guideOver()                            
                        -- end                        
                        return false
                    end
                elseif  eventType == "ended" then
                    print("showDBox ==================ended",self.currentGID)
                    if self.currentGID == GuideId.G_GUIDE_50006 then
                        local equipData = getDataManager():getEquipmentData()
                        local tempNum = table.nums(equipData:getChipsList())
                        local isCanCom = equipData:getIsComEquip()
                        print("tempNum ", tempNum)
                        print("isCanCom ", isCanCom)
                        if tempNum <= 0 or isCanCom == false then
                            self:setCurrentGID(GuideId.G_GUIDE_50008)
                        end
                    end
                    --self:showDBox()
                    self:startGuideNext_()
                end
            end
            print("防止穿透 ============== ")
            self.dBoxSLayer:setTouchEnabled(true)
            self.dBoxSLayer:registerScriptTouchHandler(onTouchEvent)
            self.dBoxView:addChild(self.dBoxSLayer)
        -- end

    end
    self.dBoxView:setVisible(true)

    local npc_x = self.guideItem["npc_x"]
    local npc_y = self.guideItem["npc_y"]

    self.dBoxView:setPosition(npc_x, npc_y)
    print("self.currentGID====dBoxView==", self.currentGID)

    self.deslabel = self.newHandNode["newHandNode"]["deslabel"]
    self.newHandJT = self.newHandNode["newHandNode"]["newHandJT"]
    self.newHandBg = self.newHandNode["newHandNode"]["newHandBg"]
    self.newhandPeople = self.newHandNode["newHandNode"]["newhandPeople"]
    self.desKuang = self.newHandNode["newHandNode"]["desKuang"]
    if self.colerlayer ~= nil then
        print("boxColerlayer ------------------- false ")
        self.boxColerlayer:setVisible(false)
    else
        print("boxColerlayer ------------------- true ")
        self.boxColerlayer:setVisible(true)
    end
    self.deslabel:setString(languageStr)
    self.deslabel:setLocalZOrder(2)
    self.deslabel:setPosition(197, 73)
    self.deslabel:setDimensions(420, 110)

    local actionBy1 = cc.MoveBy:create(0.5, cc.p(0, -10))
    local actionBy2 = cc.MoveBy:create(0.5, cc.p(0,10))
    local sequence = cc.Sequence:create(actionBy1, actionBy2)
    local repeatForever = cc.RepeatForever:create( sequence )
    self.newHandJT:runAction(repeatForever)

    self.desKuang:removeChildByTag(1005003)
    local _node = UI_NewHandJTtexiao()
    _node:setTag(1005003)
    self.desKuang:addChild(_node)

    if self.guideItem.stop_type == 0 then
        self.newHandJT:setVisible(true)
        _node:setVisible(true)
    else
        self.newHandJT:setVisible(false)
        _node:setVisible(false)
    end

    --self.aniNode
    local heroId = self.guideItem["hero"]
    print("heroId=====", heroId)
    --根据id判断对话框上面的半身像，如果是-1 是小乔，不然根据id获得资源
    if heroId == -1 then
        local aniCcb = {}
        --self.newHandNode["newHandNode"] = {}

        game.addSpriteFramesWithFile("res/ccb/resource/haixiu.plist")


        local proxy = cc.CCBProxy:create()
        local weixiaoNode = CCBReaderLoad("newHandLead/ui_xiaonvhai_weixiao.ccbi", proxy, aniCcb)
        -- game.removeSpriteFramesWithFile("res/ccb/resource/haixiu.plist")
        if weixiaoNode and self.aniNode then
            self.aniNode:addChild(weixiaoNode)
            weixiaoNode:setScale(0.7)
            weixiaoNode:setPosition(0, 0)
        end
    elseif heroId ~= 0 then

        -- pictureName==== hero1_10048_all
        -- res====    hero1_10048_2.png

        local pictureName, res = self.soldierTemplate:getHeroImageName(heroId)
        -- local finalUrl = "#hero_" .. heroId .. "_2.png"
        -- local resFrame = "hero_" .. heroId .. "_all"
        print("pictureName====", pictureName)
        print("res====", res)
        getDataManager():getResourceData():loadHeroImageDataById(pictureName)
        local hero = game.newSprite("#" .. res)
        hero:setAnchorPoint(cc.p(0, 0))
        if self.aniNode then
            self.aniNode:addChild(hero)
            self.aniNode:setPosition(-50,-50)
        end
        getDataManager():getResourceData():removeHeroImageDataById(pictureName)
    else
        local newHandBg = self.newHandNode["newHandNode"]["desKuang"]
        self.deslabel:setPosition(95, 70)
        self.deslabel:setDimensions(newHandBg:getContentSize().width-15,newHandBg:getContentSize().height-10)
    end

end

-- 没用上
function NewGManager:removeDBox()
    if self.boxColerlayer then
        print("remove___boxColerlayer")
        self.boxColerlayer:removeFromParent(true)
        self.boxColerlayer = nil
    end
    self.gWordIndex = 0
    if self.dBoxView then
        print("remove___dBoxView")
        self.dBoxView:removeFromParent(true)
        self.dBoxView = nil
    end
end

--显示高亮区域
function NewGManager:showHighLightArea()
    if self.clipNode then
        --self.clipNode:removeFromParent(true)
        self.clipNode = nil
        --self.boxSprite:removeFromParent(true)
        self.boxSprite = nil
        self.colerlayer = nil
    end

    local area_x = self.guideItem["area_x"]
    local area_y = self.guideItem["area_y"]
    local area_w = self.guideItem["area_w"]
    local area_h = self.guideItem["area_h"]
    if  area_x == 0 and area_y == 0 and area_w == 0 and area_h == 0 then
        cclog("no____________showHighLightArea")

        return
    end

    self.clipNode = cc.ClippingNode:create()
    self.guideNode:addChild(self.clipNode, self.zorderHighLight)

    self.clipNode:setContentSize(cc.size(640, 960))
    self.clipNode:setInverted(true)
    self.colerlayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 125), 640, 960)
    self.clipNode:addChild(self.colerlayer)

    self.boxSpriteStencil = game.newScale9Sprite("#ui_newHand_liangK.png", cc.rect(area_x, area_y, area_w, area_h))
    self.clipNode:setStencil(self.boxSpriteStencil)
    self.boxSpriteStencil:setPosition(area_x + area_w / 2, area_y + area_h / 2)

    --self.boxSprite = game.newScale9Sprite("#ui_newHand_liangK.png", cc.rect(area_x, area_y, area_w, area_h))
    --local ui_newHand_bg = game.newScale9Sprite("#ui_newHand_bg.png", cc.rect(area_x, area_y, area_w, area_h))
    --self.boxSprite:setPosition(area_x + area_w / 2, area_y + area_h / 2)
    -- self.boxSprite:addChild(ui_newHand_bg, -1)
    -- ui_newHand_bg:setOpacity(125)
    -- ui_newHand_bg:setPosition(area_w / 2, area_h / 2)

    local part = createEffect(area_w, area_h)
    -- part:setPosition(area_x + area_w / 2, area_y + area_h / 2)
    part:setPosition(area_x, area_y)
    -- self.boxSprite:addChild(part)
    part:setTag(100001)
    self.guideNode:addChild(part, self.zorderHighLight + 1)
end

--创建点击区域
function NewGManager:createTouchLayer()
    if self.taouchLayer then
        -- self.taouchLayer:setTouchEnabled(false)
        -- self.taouchLayer:removeFromParent(true)
        self.taouchLayer = nil
    end

    --[[local touch_x = self.guideItem["touch_x"]+self.touchOffSet.x
    local touch_y = self.guideItem["touch_y"]+self.touchOffSet.y
    local touch_w = self.guideItem["touch_w"]
    local touch_h = self.guideItem["touch_h"]]--
    --始终创建touch层
    -- if touch_x == 0 and touch_y == 0 then
    --     return
    -- end
    local  tempOffsetX = self.touchOffSet.x
    local  tempOffsetY = self.touchOffSet.y
    self.taouchLayer = game.newLayer()
    local function onTouchEvent(eventType, x, y)
        if eventType == "began" then
            local target = self.taouchLayer:getParent()

            local locationInNode = target:convertToNodeSpace(cc.p(x, y))
            local touch_x = self.guideItem["touch_x"]+tempOffsetX
            local touch_y = self.guideItem["touch_y"]+tempOffsetY
            local touch_w = self.guideItem["touch_w"]
            local touch_h = self.guideItem["touch_h"]

            print("touch_x====" .. touch_x)
            print("touch_y====" .. touch_y)
            print("touch_w====" .. touch_w)
            print("touch_h====" .. touch_h)
            print("touchOffSet ",self.touchOffSet.y)

            local rectArea = cc.rect(touch_x, touch_y, touch_w, touch_h)
            local isInRect = cc.rectContainsPoint(rectArea, locationInNode)
            print("isInRect========")
            table.print(rectArea)
            print(isInRect)
            table.print(locationInNode)
            print("isInRect========")
            if isInRect then
                print("guide:onTouchEvent=============================>", self.currentGID)
               -- if table.find(GuideIdNeedOver, self.currentGID) then
               --      self:guideOver()                            
               --  end
                --让引导画面移除
                local isConnect = self.netManager:checkNetwork()
                print("isConnect ",isConnect)

                if isConnect == false then
                    getOtherModule():showAlertDialog(nil, Localize.query("toast.1"))
                    return true
                end

                if self.guideItem.skipEnd ~= 0 then
                    -- self._isGuiding = false
                    self:guideOver() 
                end
                return false
            else
                return true
            end

        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end
    self.taouchLayer:registerScriptTouchHandler(onTouchEvent)
    self.guideNode:addChild(self.taouchLayer, self.zorderTouchLayer)
    self.taouchLayer:setTouchEnabled(true)

    self.touchOffSet = cc.p(0,0)
end

--创建小手
function NewGManager:createHandLayer()
    print("NewGManager:createHandLayer===================>")
    if self.handSprite then
        -- self.handSprite:removeFromParent(true)
        self.handSprite = nil
    end

    local hand_start_point_x = self.guideItem["hand_start_point_x"]+self.handOffSet.x
    local hand_start_point_y = self.guideItem["hand_start_point_y"]+self.handOffSet.y
    local hand_end_point_x = self.guideItem["hand_end_point_x"]
    local hand_end_point_y = self.guideItem["hand_end_point_y"]

    if hand_start_point_x == 0 and hand_start_point_y == 0 then
        return
    end
    self.handSprite =  game.newSprite("#ui_newHand_hand.png")
    -- self.handSprite:setAnchorPoint(cc.p(0.5,0))
    self.guideNode:addChild(self.handSprite, self.zorderHandLayer)


    local hand_direction = self.guideItem["hand_direction"]

    print("handY: ",hand_start_point_y)
    -- 左上：1
    -- 右上：2
    -- 左下：3
    -- 右下：4
    local _posx, _posy = 10, 65   --特效位置
    if hand_direction == 2 then
        --self.handSprite:setFlipX(true)
        self.handSprite:setFlippedX(true)  
        _posx = 65
    elseif hand_direction == 3 then
        self.handSprite:setFlippedY(true)
        _posy = 5
    elseif hand_direction == 4 then
        self.handSprite:setFlippedX(true)
        self.handSprite:setFlippedY(true)
        _posx, _posy = 65, 5
    end

    ---小手特效
    self.handSprite:removeAllChildren()
    local _node = UI_NewBeeHandtexiao(_posx, _posy)
    self.handSprite:addChild(_node)


    --[[print("hand_start_point_x===" .. hand_start_point_x)
    print("hand_start_point_y===" .. hand_start_point_y)
    print("hand_end_point_x===" .. hand_end_point_x)
    print("hand_end_point_y===" .. hand_end_point_y)

    print("contentSize.width====", contentSize.width)
    print("contentSize.height====", contentSize.height)]]--
    local contentSize = self.handSprite:getContentSize()

    local tempStartX = hand_start_point_x + contentSize.width / 2
    local tempStartY = hand_start_point_y - contentSize.height / 2

    local tempStopX = hand_end_point_x + contentSize.width / 2
    local tempStopY = hand_end_point_y - contentSize.height / 2

    print("小手的方向 -====================- ", hand_direction)
    if hand_direction == 2 then
        print("hand_direction == 2 ========== ", hand_start_point_x,  contentSize.width)
        tempStartX = hand_start_point_x - contentSize.width / 2
        tempStartY = hand_start_point_y - contentSize.height / 2

        tempStopX = hand_end_point_x - contentSize.width / 2
        tempStopY = hand_end_point_y - contentSize.height / 2

    elseif hand_direction == 3 then
        print("hand_direction == 3 ========== ")
        tempStartX = hand_start_point_x + contentSize.width / 2
        tempStartY = hand_start_point_y + contentSize.height / 2

        tempStopX = hand_end_point_x + contentSize.width / 2
        tempStopY = hand_end_point_y + contentSize.height / 2
    elseif hand_direction == 4 then
        print("hand_direction == 4 ========== ")
        tempStartX = hand_start_point_x - contentSize.width / 2
        tempStartY = hand_start_point_y + contentSize.height / 2

        tempStopX = hand_end_point_x - contentSize.width / 2
        tempStopY = hand_end_point_y + contentSize.height / 2
    end

    self.handSprite:setPosition(tempStartX, tempStartY)

    if hand_end_point_x ~= 0 and hand_end_point_y ~= 0 then

        local moveToAction1 = cc.MoveTo:create(1.5, cc.p(tempStopX, tempStopY))
        local moveToAction2 = cc.MoveTo:create(0, cc.p(tempStartX, tempStartY))
        local sequence1 = cc.Sequence:create(moveToAction1, moveToAction2)
        local repeatForever = cc.RepeatForever:create(sequence1)
        self.handSprite:runAction(repeatForever)
    else
        local dur = 0.5
        local scaleTo1 = cc.ScaleTo:create(dur, 1.2)
        local scaleTo2 = cc.ScaleTo:create(dur, 1)
        local sequence1 = cc.Sequence:create(scaleTo1, scaleTo2)
        local repeatForever = cc.RepeatForever:create(sequence1)
        self.handSprite:runAction(repeatForever)
    end
    

            --     stepCallBack(G_GUIDE_20035)
            -- stepCallBack(G_GUIDE_20056)
            -- stepCallBack(G_GUIDE_20074)
            -- stepCallBack(G_GUIDE_20095)

    --[[if self.currentGID == G_GUIDE_20035 or self.currentGID == G_GUIDE_20056 or self.currentGID == G_GUIDE_20074 or self.currentGID == G_GUIDE_20095 then
        self.handSprite:setVisible(false)
        local delayAction = cc.DelayTime:create(2.3)
        local function callBack()
            self.handSprite:setVisible(true)
        end
        local sequenceAction1 = cc.Sequence:create(delayAction, cc.CallFunc:create(callBack))
        self.guideNode:runAction(sequenceAction1)
    end]]--

    self.handOffSet = cc.p(0,0)
end

--创建获取新英雄，刘备和蔡文姬
function NewGManager:createNewHeroView()
    
    print("createNewHeroView createNewHeroView -----------")
    game.addSpriteFramesWithFile("res/ccb/resource/ui_common1.plist")

    local rewards = self.guideItem["rewards"]
    local item = rewards["101"]
    table.print(rewards)

    if item == nil then
        if self.gHeroView then
            -- self.gHeroView:removeFromParent(true)
            self.gHeroView = nil
        end
        return
    end

    local heroId = rewards["101"][3]
    print("heroId=====" .. heroId)
    --getHeroBigImageById
    local pictureName = self.soldierTemplate:getHeroImageName(heroId)
    local len = string.len(pictureName)
    local startPos = len - 4
    local tempName = pictureName
    local resFrame = string.sub(tempName, 1, startPos)

    self.resourceData:loadHeroImageDataById(resFrame)
    local node = self.soldierTemplate:getBigImageByResName(pictureName, heroId)
    self.resourceData:removeHeroImageDataById(resFrame)

    local function menuClickMakeSure()
        print("getPlayerScene().firstEnter ", getPlayerScene().firstEnter)

        self:startGuideForGuideId(self.guideItem.skip_to)
    end

    self.newHandCon = {}
    self.newHandCon["newHandCon"] = {}

    local proxy = cc.CCBProxy:create()
    self.newHandCon["newHandCon"]["menuClickMakeSure"] = menuClickMakeSure

    self.gHeroView = CCBReaderLoad("newHandLead/ui_newHand_con.ccbi", proxy, self.newHandCon)
    if self.gHeroView == nil then
        cclog("Error: in loadCCBI _name==" .. _name)
        return
    end
    self.guideNode:addChild(self.gHeroView, self.zorderNewHero)

    local labelName = self.newHandCon["newHandCon"]["labelName"]
    local starSelect1 = self.newHandCon["newHandCon"]["starSelect1"]
    local starSelect2 = self.newHandCon["newHandCon"]["starSelect2"]
    local starSelect3 = self.newHandCon["newHandCon"]["starSelect3"]
    local starSelect4 = self.newHandCon["newHandCon"]["starSelect4"]
    local starSelect5 = self.newHandCon["newHandCon"]["starSelect5"]
    local starSelect6 = self.newHandCon["newHandCon"]["starSelect6"]
    
    local starTable = {}
    table.insert(starTable, starSelect1)
    table.insert(starTable, starSelect2)
    table.insert(starTable, starSelect3)
    table.insert(starTable, starSelect4)
    table.insert(starTable, starSelect5)
    table.insert(starTable, starSelect6)

    local heroNode = self.newHandCon["newHandCon"]["heroNode"]
    heroNode:addChild(node)
    local heroName = self.soldierTemplate:getHeroName(heroId)
    labelName:setString(heroName)
    if heroId == 10020 then
        labelName:setColor(ui.COLOR_BLUE)
    end
    local soldierTemplateItem = self.soldierTemplate:getHeroTempLateById(heroId)
    local quality = soldierTemplateItem.quality

    updateStarLV(starTable, quality)

    print("createNewHeroView----------- end")
end

--奖励：掉落包
function NewGManager:createOtherRewards()
    print("createOtherRewards = createOtherRewards ================createOtherRewards = createOtherRewards ================ ")
    local rewards = self.guideItem["rewards"]
    local otherAwards = rewards["106"]
    print("otherAwards ============ ", otherAwards)

    if otherAwards == nil or table.nums(otherAwards) == 0 then
        return
    end
    local dropBigId = otherAwards[3]
    local smallBagIds = getTemplateManager():getDropTemplate():getSmallBagIds(dropBigId)
    print("smallBagIds ========== smallBagIds ============ ")
    table.print(smallBagIds)
    getOtherModule():showOtherView("PVCongratulationsGainDialog", 5, smallBagIds)
    

end

--设置触摸区域偏离位置
function NewGManager:setTouchOffSet(offPosition)
   self.touchOffSet = offPosition
   print("set touch ", self.touchOffSet.y)
end

--设置小手偏离位置
function NewGManager:setHandOffSet(offPosition)
    self.handOffSet = offPosition
end

function NewGManager:getNewBeeConfigById(id)
    return newbee_guide_config[id]
end

function NewGManager:getBackId(id)
    print("---NewGManager:getBackId",id)

    local gItem = self:getNewBeeConfigById(id)
    if gItem == nil then
        return id
    end
    return  gItem["backID"]
end

--隐藏小手
function NewGManager:hideHandSprite()
    if self.handSprite ~= nil then
        self.handSprite:setVisible(false)
    end
end

function NewGManager:isHaveGuide()
    return self._isGuiding
end

-- 设置新手引导战斗是否胜利
function NewGManager:setNewBeeFightWin(flag)
    self.newBeeFightWin = flag
end

-- 获取新手引导战斗是否胜利
function NewGManager:getNewBeeFightWin()
    print("self.newBeeFightWin ", self.newBeeFightWin)
    return self.newBeeFightWin
end


function NewGManager:setGidWithProtocol(showLoading,gid)
    if gid ~= nil then self:setCurrentGID(gid) end
    self:sendGuidProtocol(showLoading, gid)
end

function NewGManager:checkIsSendRewards()
    if not self.currentGID then 
        return false 
    end
    if not self.guideItem or self.guideItem.id ~= self.currentGID then
        self.guideItem = self:getNewBeeConfigById(self.currentGID)        
    end

    if not self.guideItem then
        return false 
    end

    local nextGuideId = self.guideItem.skip_to
    local bFind = table.find(GuidIdNeedWait, nextGuideId)
    local bStart = self:checkStageGuide()

    if bFind and bStart then
        print("---------checkIsSendRewards()-----------")

        self:setGidWithProtocol(true,nextGuideId)
        return true
    end

    return false
end



return NewGManager  


--[[
逻辑处理
----MenuScene:onNetMsgUpdateUI 根据服务器返回新手引导编号及nickName判断进入哪个场景

----进入游戏主界面时 getPlayerScene enterPlayerScene()中调用 getNewGManager():checkGuide() 检查是否有要进行的强制新手引导

----在战斗中通关某关卡后，如果该关卡胜利或者有升级奖励则检查是否有通关引导 FVLayerUI:addStageGuide()

----从战斗场景退回到游戏时 由于需要判断是否有新功能开启功能界面 故在 PVActivityPage 与 StagePassOpen 判断是否开启新手 getNewGManager():startGuide()

----非强制引导 点击跳过时 将 currentGuid设置为GUID_DISTROY_ID 表示该阶段结束

----步骤卡死有可能是缺少引导步骤

关键点：
1、服务器只记录新手引导当前编号，该编号对应有奖励时则 服务器发送奖励，客户端显示
2、客户端根据服务器返回的编号以及数值表中BackId 确认当前引导编号
3、阶段结束类型说明 0 引导不暂停 协议不发送； -1 引导不暂停 发送协议； 1 引导结束 发送协议 需重新调用startGuide()
目前问题：
2、 添加关卡剧情介绍后需修改 关卡新功能开启界面 同时修改触发新手引导的位置  
3、 新手引导界面修改 换成新的界面 注册完后第一次进战斗里对话里显示的英雄不对 小手光圈没有

]]--








