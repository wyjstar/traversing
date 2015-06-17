
StoryDialogManager = StoryDialogManager or class("StoryDialogManager")

import(".NewGContent")

function StoryDialogManager:ctor(controller)
    self.zorderDBox = 50
    self.languageTemplate = getTemplateManager():getLanguageTemplate()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.instanceTemplate = getTemplateManager():getInstanceTemplate()
    self.resourceTemplate = getTemplateManager():getResourceTemplate()


end

--战斗结束之后调用，检测是否有引导
function StoryDialogManager:checkGuide()
    -- if ISSHOW_GUIDE == false then
    --     return
    -- end
    -- print("checkGuide===========self.currentGID===" .. self.currentGID)
    -- --这些情况都不能进入
    -- if self.currentGID == 0 or self.currentGID == -1 or self.currentGID == G_FIRST_LOGIN then

    --     return
    -- end

    -- --ruguo如果这些都是强制引导的从战斗返回，就需要进行下一步
    -- if self.currentGID == G_FIGHT_OVER_SUER or self.currentGID == G_GUIDE_20036 or self.currentGID == G_GUIDE_20057 or self.currentGID == G_GUIDE_20075 or self.currentGID == G_GUIDE_20096 then
    --     print("222222222")
    --     self:startGuideNext() --开始next的guide，就是gid+ 1 然后执行startGUide
    --     return
    -- end
    -- --特殊情况处理，
    -- if self.currentGID == G_GUIDE_20043 then
    --     --显示英雄模块，用于升级页签得引导
    --     getModule(MODULE_NAME_HOMEPAGE):showUIView("PVSoldierMain")
    -- end

    --  --特殊情况处理，
    -- if self.currentGID == G_GUIDE_20082 then
    --     isEntry = false
    --     getModule(MODULE_NAME_SHOP):showUIView("PVShopPage")
    -- end
end


--事件处理
function StoryDialogManager:eventBeTriggered()
    if self.currentGID == G_FIGHT_OVER_SUER or self.currentGID == G_GUIDE_20036 or self.currentGID == G_GUIDE_20057 or self.currentGID == G_GUIDE_20075 or self.currentGID == G_GUIDE_20096 then
        print("G_FIGHT_OVER_SUER======" .. G_FIGHT_OVER_SUER)
        self:clearView()
    end
end

-- 是否存在剧情关卡
function StoryDialogManager:isExitsStoryDialog(stageId, status, round)

    local _info = self.instanceTemplate:getStageStoryInfoByStageId(stageId, status, round)

    return _info ~= nil 
end

--开始剧情对话
function StoryDialogManager:startStoryDialog(stageId, status, round)

    self._info = self.instanceTemplate:getStageStoryInfoByStageId(stageId, status, round)
    self.dialogT = {}

    cclog("-----------startStoryDialog--------")
    table.print(self._info)

    self.curStoryId = self._info.id

    self:initStoryView()
    
end

function StoryDialogManager:initStoryView()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_newHandLead.plist")
    
    self:initGuideNode()

    self.guideNode:removeAllChildren()

    -- self:initShowDBox()

    local _info = self._info
    self.netxtStoryId = _info.next
    self.curStoryId = _info.id
    self:initShowDBox_s()
    -- self:updateShowDBoxInfo()
    
end

-- function StoryDialogManager:updateShowDBoxInfo()

--     local _info = self._info
--     self.netxtStoryId = _info.next
--     self.curStoryId = _info.id

--     local _resPath =  self.resourceTemplate:getPathNameById(_info.resId)
   
--     local hero = self.soldierTemplate:getBigImageByResName(_resPath)
    
--     self.rightHero:setVisible(false)
--     self.leftHero:setVisible(false)

--     if self.rightHero:getParent():getChildByTag(100) then
--         self.rightHero:getParent():removeChildByTag(100)
--     end

--     if self.leftHero:getParent():getChildByTag(101) then
--         self.leftHero:getParent():removeChildByTag(101)
--     end

--     if _info.position == 2 then
--         local _parent = self.rightHero:getParent()

--         local x, y = self.rightHero:getPosition()
--         hero:setPosition(cc.p(x, y-50))
--         _parent:addChild(hero, -10, 100)
       
--         hero:setScale(1.2)
--     else
--         local _parent = self.leftHero:getParent()
        
--         _parent:addChild(hero, -10, 101)
--         local x, y = self.leftHero:getPosition()
--         hero:setPosition(cc.p(x, y-50))
       
--         hero:setScale(1.2)
--     end

--     local languageStr = self.languageTemplate:getLanguageById(_info.languageId)
--     self.deslabel:setString(languageStr)


-- end

--穿件引导基础的node，其中有适配
function StoryDialogManager:initGuideNode()
    if self.adapterLayer == nil then
        local sharedDirector = cc.Director:getInstance()
        local glsize = sharedDirector:getWinSize()
        self.adapterLayer = cc.Layer:create()

        self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
        self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

        self.guideNode = game.newNode()
        self.adapterLayer:addChild(self.guideNode)
        local runningScene = game.getRunningScene()
        runningScene:addChild(self.adapterLayer, 10002)
    end
end

--开始下一个引导
function StoryDialogManager:startStoryNext()
    
    if self.netxtStoryId == -1 then
       local _storyId = string.format("%d", self.curStoryId)
        print("-----_storyId------")
        print(_storyId)

        cc.UserDefault:getInstance():setBoolForKey(_storyId, true)
        cc.UserDefault:getInstance():flush()

        self:guideOver()

        return
    end

    print("-----StoryDialogManager:startStoryNext----")
    print(self.netxtStoryId)

    self._info = self.instanceTemplate:getStageStoryInfoByID(self.netxtStoryId)
    
    table.print(self._info)

    self:updateShowDBoxInfo()
end

--暂时结束，
function StoryDialogManager:guideOver()
    cclog("guideOver-----------------")
    self:clearView() --清理view
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_newHandLead.plist")
    self:guideOverEvent()
end

--引导结束，相应一些事件
function StoryDialogManager:guideOverEvent()
    -- if self.currentGID == G_UNPARA_2 or self.currentGID == G_UNPARA_3 then
        getFEControl():nextStep()
    -- end
end

--清除view
function StoryDialogManager:clearView()
    self.adapterLayer:removeFromParent(true)
    self.adapterLayer = nil
    self.clipNode = nil
    self.dBoxView = nil
    self.boxColerlayer = nil
    self.boxSprite = nil
    self.handNode = nil
    self.taouchLayer = nil
    self.handSprite = nil
    self.colerlayer = nil
end

--显示对话框
-- function StoryDialogManager:initShowDBox()

--     self.boxColerlayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 125), 640, 960)
--     self.guideNode:addChild(self.boxColerlayer, self.zorderDBox)
--     -- local lgId = guideWord[self.gWordIndex]

--     -- local languageStr = self.languageTemplate:getLanguageById(lgId)
--     -- local stop_type = self.guideItem.stop_type

--     local proxy = cc.CCBProxy:create()

--     if self.dBoxView == nil then

--         self.newHandNode = {}
--         self.newHandNode["newHandNode"] = {}

--         self.dBoxView = CCBReaderLoad("newHandLead/ui_story_view.ccbi", proxy, self.newHandNode)
--         if self.dBoxView == nil then
--             cclog("Error: in loadCCBI _name==" .. _name)
--             return
--         end

--         self.guideNode:addChild(self.dBoxView, self.zorderDBox + 1)

--         self.dBoxSLayer = game.newLayer()
--         self.dBoxSLayer:setContentSize(640, 960)

--         local function onTouchEvent(eventType, x, y)
--             if eventType == "began" then

--                 return true
--             elseif  eventType == "ended" then
--                 print("ended-----------")
--                 self:startStoryNext()
--             end
--         end

--         self.dBoxSLayer:setTouchEnabled(true)
--         self.dBoxSLayer:registerScriptTouchHandler(onTouchEvent)
--         self.dBoxView:addChild(self.dBoxSLayer)


--     end
--     self.dBoxView:setVisible(true)

--     self.deslabel = self.newHandNode["newHandNode"]["deslabel"]
--     self.newHandJT = self.newHandNode["newHandNode"]["newHandJT"]
--     self.newHandBg = self.newHandNode["newHandNode"]["newHandBg"]
--     self.leftHero = self.newHandNode["newHandNode"]["leftHero"]
--     self.rightHero = self.newHandNode["newHandNode"]["rightHero"]

--     local actionBy1 = cc.MoveBy:create(1, cc.p(0, -20))
--     local actionBy2 = cc.MoveBy:create(1, cc.p(0,20))
--     local sequence = cc.Sequence:create(actionBy1, actionBy2)
--     local repeatForever = cc.RepeatForever:create( sequence )
--     self.newHandJT:runAction(repeatForever)

-- end

function StoryDialogManager:removeDBox()
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

function StoryDialogManager:initShowDBox_s()
    if self.boxColerlayer == nil then
        self.boxColerlayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 125), 640, 960)
        self.guideNode:addChild(self.boxColerlayer, self.zorderDBox)
    end

    print("-----StoryDialogManager:startStoryNext----")
    print(self.netxtStoryId)
    self.isCanTouch = true

    local proxy = cc.CCBProxy:create()

        local newHandNode = {}
        newHandNode["newHandNode"] = {}

        local dBoxView = CCBReaderLoad("newHandLead/ui_story_view.ccbi", proxy, newHandNode)
        if dBoxView == nil then
            cclog("Error: in loadCCBI _name==" .. _name)
            return
        end

        self.guideNode:addChild(dBoxView, self.zorderDBox + 1)

        cclog("-------------self.dBoxSLayer--------")
        self.dBoxSLayer = game.newLayer()
        self.dBoxSLayer:setContentSize(640, 960)
             local function onTouchEvent(eventType, x, y)
            if eventType == "began" then

                return true
            elseif  eventType == "ended" then
                print("ended-------------")
                -- self:initShowDBox_s()
                -- self:createDia()
                if self.isCanTouch then
                    self.isCanTouch = false
                    self:dialogMov()
                end
            end
        end

        self.dBoxSLayer:setTouchEnabled(true)
        self.dBoxSLayer:registerScriptTouchHandler(onTouchEvent)
        self.guideNode:addChild(self.dBoxSLayer,self.zorderDBox + 100000)

       
    self.dialogT[#self.dialogT+1] = {newHandNode = newHandNode,dBoxView = dBoxView}

    dBoxView:setVisible(true)
    dBoxView:setPositionY(dBoxView:getPositionY()-110)

    self.deslabel = newHandNode["newHandNode"]["deslabel"]
    self.newHandJT = newHandNode["newHandNode"]["newHandJT"]
    self.newHandBg = newHandNode["newHandNode"]["newHandBg"]
    self.leftHero = newHandNode["newHandNode"]["leftHero"]
    self.rightHero = newHandNode["newHandNode"]["rightHero"]

    local actionBy1 = cc.MoveBy:create(1, cc.p(0, -20))
    local actionBy2 = cc.MoveBy:create(1, cc.p(0,20))
    local sequence = cc.Sequence:create(actionBy1, actionBy2)
    local repeatForever = cc.RepeatForever:create( sequence )
    self.newHandJT:runAction(repeatForever)

    self:updateShowDBoxInfo()
end
function StoryDialogManager:dialogMov()
    if self.netxtStoryId == -1 then
       local _storyId = string.format("%d", self.curStoryId)
        print("-----_storyId------")
        print(_storyId)

        cc.UserDefault:getInstance():setBoolForKey(_storyId, true)
        cc.UserDefault:getInstance():flush()

        self:guideOver()

        return
    end

    local function callBack()
        self:createDialog()
        self.isCanTouch = true
        -- self:initShowDBox_s()
    end
    for k,v in pairs(self.dialogT) do
        v.newHandNode["newHandNode"]["newHandJT"]:stopAllActions()
        local action = cc.MoveBy:create(0.05, cc.p(0,240))
        local seque = action
        if k == #self.dialogT then
            seque = cc.Sequence:create(action,cc.CallFunc:create(callBack))
        end
        v.dBoxView:runAction(seque)
    end
    
end
function StoryDialogManager:createDialog()
    if self.netxtStoryId == -1 then
       local _storyId = string.format("%d", self.curStoryId)
        print("-----_storyId------")
        print(_storyId)

        cc.UserDefault:getInstance():setBoolForKey(_storyId, true)
        cc.UserDefault:getInstance():flush()

        self:guideOver()

        return
    end

    print("-----StoryDialogManager:startStoryNext----")
    print(self.netxtStoryId)

    local proxy = cc.CCBProxy:create()

        local newHandNode = {}
        newHandNode["newHandNode"] = {}

        local dBoxView = CCBReaderLoad("newHandLead/ui_story_view.ccbi", proxy, newHandNode)
        if dBoxView == nil then
            cclog("Error: in loadCCBI _name==" .. _name)
            return
        end

        self.guideNode:addChild(dBoxView, self.zorderDBox + 1)

    self.dialogT[#self.dialogT+1] = {newHandNode = newHandNode,dBoxView = dBoxView}

    dBoxView:setVisible(true)
    dBoxView:setPositionY(dBoxView:getPositionY()-110)

    self.deslabel = newHandNode["newHandNode"]["deslabel"]
    self.newHandJT = newHandNode["newHandNode"]["newHandJT"]
    self.newHandBg = newHandNode["newHandNode"]["newHandBg"]
    self.leftHero = newHandNode["newHandNode"]["leftHero"]
    self.rightHero = newHandNode["newHandNode"]["rightHero"]

    local actionBy1 = cc.MoveBy:create(1, cc.p(0, -20))
    local actionBy2 = cc.MoveBy:create(1, cc.p(0,20))
    local sequence = cc.Sequence:create(actionBy1, actionBy2)
    local repeatForever = cc.RepeatForever:create( sequence )
    self.newHandJT:runAction(repeatForever)

    
    self:updateShowDBoxInfo()
end
function StoryDialogManager:updateShowDBoxInfo()

    local _info = self._info
    self.netxtStoryId = _info.next
    self.curStoryId = _info.id

    local _resPath =  self.resourceTemplate:getPathNameById(_info.resId)
   
    local hero = self.soldierTemplate:getBigImageByResName(_resPath)
    
    self.rightHero:setVisible(false)
    self.leftHero:setVisible(false)

    if self.rightHero:getParent():getChildByTag(100) then
        self.rightHero:getParent():removeChildByTag(100)
    end

    if self.leftHero:getParent():getChildByTag(101) then
        self.leftHero:getParent():removeChildByTag(101)
    end

    if _info.position == 2 then
        local _parent = self.rightHero:getParent()

        local x, y = self.rightHero:getPosition()
        hero:setPosition(cc.p(x, y-50))
        _parent:addChild(hero, 10, 100)
       self.deslabel:setPositionX(self.deslabel:getPositionX()-150)
        -- hero:setScale(1.2)
    else
        local _parent = self.leftHero:getParent()
        
        _parent:addChild(hero, 10, 101)
        local x, y = self.leftHero:getPosition()
        hero:setPosition(cc.p(x, y-50))
       
        -- hero:setScale(1.2)
    end

    if self.soldierTemplate:getHeroQualityByResId(_info.resId) == 5 or self.soldierTemplate:getHeroQualityByResId(_info.resId) == 6 then
        hero:setScale(1)
    else
        hero:setScale(1.1)
    end

    self.deslabel:setLocalZOrder(1000)

    local languageStr = self.languageTemplate:getLanguageById(_info.languageId)
    self.deslabel:setString(languageStr)

    self._info = self.instanceTemplate:getStageStoryInfoByID(self.netxtStoryId)
end

return StoryDialogManager













