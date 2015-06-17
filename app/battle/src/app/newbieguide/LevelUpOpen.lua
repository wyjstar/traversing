
LevelUpOpen = LevelUpOpen or class("LevelUpOpen")

function LevelUpOpen:ctor(controller)
    game.addSpriteFramesWithFile("res/ccb/resource/ui_navi.plist")
    self.languageTemplate = getTemplateManager():getLanguageTemplate()
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.resourceData = getDataManager():getResourceData()
    self.expPlayerTemp = getTemplateManager():getPlayerTemplate()
    self.resourceTemplate = getTemplateManager():getResourceTemplate()
end

function LevelUpOpen:startShowView(level)
    -- 新版本弃用
    -- self.nowLevel = level
    -- local item = self.expPlayerTemp:getEXPItemByLevel(level)
    -- self.open = item.open
    -- local size = #self.open
    -- if size == 0 then
    --     return
    -- end
    -- self:checkGuideNode()
    -- self:startLevelGuide()
end

function LevelUpOpen:checkGuideNode()
    if self.adapterLayer == nil then
        local sharedDirector = cc.Director:getInstance()
        local glsize = sharedDirector:getWinSize()
        self.adapterLayer = cc.Layer:create()

        self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
        self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

        self.upViewNode = game.createShieldLayer()
        self.upViewNode:setTouchEnabled(true)
        self.adapterLayer:addChild(self.upViewNode)
        local runningScene = game.getRunningScene()
        runningScene:addChild(self.adapterLayer, 10001)
    end
end

function LevelUpOpen:startLevelGuide()
    self.UINewHandOpenView = {}
    self.UINewHandOpenView["UINewHandOpenView"] = {}

    local function onEnter()
        --assert(false)
        self.adapterLayer:removeFromParent(true)
        self.adapterLayer = nil

        -- getNewGManager():startGuideNext()

    end
    self.UINewHandOpenView["UINewHandOpenView"]["onEnter"] = onEnter
    local proxy = cc.CCBProxy:create()
    self.openLevel = CCBReaderLoad("newHandLead/ui_newHand_open.ccbi", proxy, self.UINewHandOpenView)
    if self.openLevel == nil then
        -- cclog("Error: in loadCCBI _name==" .. _name)
        return
    end
    self.tubiaoLayer1 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoLayer1"]
    self.tubiaoLayer2 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoLayer2"]
    self.tubiaoLayer3 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoLayer3"]
    self.tubiaoLayer4 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoLayer4"]
    self.tubiaoLayer5 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoLayer5"]

    self.biaotiLabel1 = self.UINewHandOpenView["UINewHandOpenView"]["biaotiLabel1"]
    self.biaotiLabel2 = self.UINewHandOpenView["UINewHandOpenView"]["biaotiLabel2"]
    self.biaotiLabel3 = self.UINewHandOpenView["UINewHandOpenView"]["biaotiLabel3"]
    self.biaotiLabel4 = self.UINewHandOpenView["UINewHandOpenView"]["biaotiLabel4"]
    self.biaotiLabel5 = self.UINewHandOpenView["UINewHandOpenView"]["biaotiLabel5"]

    self.tubiaoSp1 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoSp1"]
    self.tubiaoSp2 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoSp2"]
    self.tubiaoSp3 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoSp3"]
    self.tubiaoSp4 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoSp4"]
    self.tubiaoSp5 = self.UINewHandOpenView["UINewHandOpenView"]["tubiaoSp5"]
    self.upViewNode:addChild(self.openLevel)
    local size = #self.open

    -- game.addSpriteFramesWithFile("res/ccb/resource/ui_navi.plist")



    if size == 1 then
        self.tubiaoLayer1:setVisible(true)
        self.tubiaoLayer2:setVisible(false)
        self.tubiaoLayer3:setVisible(false)
        self.tubiaoLayer4:setVisible(false)
        self.tubiaoLayer5:setVisible(false)
        local resId1 = self.open[1]
        local imageName = self.resourceTemplate:getPathNameById(resId1)
        local name = self.resourceTemplate:getResourceName(resId1)
        local url = "#" .. imageName .. ".png"
        game.setSpriteFrame(self.tubiaoSp1, url)
        -- local language = self.languageTemplate:getLanguageById(name)
        self.biaotiLabel1:setString(name)

    elseif size == 2 then
        self.tubiaoLayer1:setVisible(false)
        self.tubiaoLayer2:setVisible(false)
        self.tubiaoLayer3:setVisible(false)
        self.tubiaoLayer4:setVisible(true)
        self.tubiaoLayer5:setVisible(true)

        local resId1 = self.open[1]
        local imageName = self.resourceTemplate:getPathNameById(resId1)
        local name = self.resourceTemplate:getResourceName(resId1)
        local url = "#" .. imageName .. ".png"
        game.setSpriteFrame(self.tubiaoSp4, url)
        -- local language = self.languageTemplate:getLanguageById(name)
        self.biaotiLabel4:setString(name)

        local resId2 = self.open[2]
        local imageName = self.resourceTemplate:getPathNameById(resId2)
        local name = self.resourceTemplate:getResourceName(resId2)
        local url = "#" .. imageName .. ".png"
        game.setSpriteFrame(self.tubiaoSp5, url)
        -- local language = self.languageTemplate:getLanguageById(name)
        self.biaotiLabel5:setString(name)

    elseif size == 3 then
        self.tubiaoLayer1:setVisible(true)
        self.tubiaoLayer2:setVisible(true)
        self.tubiaoLayer3:setVisible(true)
        self.tubiaoLayer4:setVisible(false)
        self.tubiaoLayer5:setVisible(false)

        local resId1 = self.open[1]
        local imageName = self.resourceTemplate:getPathNameById(resId1)
        local name = self.resourceTemplate:getResourceName(resId1)
        local url = "#" .. imageName .. ".png"
        game.setSpriteFrame(self.tubiaoSp1, url)
        -- local language = self.languageTemplate:getLanguageById(name)
        self.biaotiLabel1:setString(name)

        local resId2 = self.open[2]
        local imageName = self.resourceTemplate:getPathNameById(resId2)
        local name = self.resourceTemplate:getResourceName(resId2)
        local url = "#" .. imageName .. ".png"
        game.setSpriteFrame(self.tubiaoSp2, url)
        -- local language = self.languageTemplate:getLanguageById(name)
        self.biaotiLabel2:setString(name)

        local resId3 = self.open[3]
        local imageName = self.resourceTemplate:getPathNameById(resId3)
        local name = self.resourceTemplate:getResourceName(resId3)
        local url = "#" .. imageName .. ".png"
        game.setSpriteFrame(self.tubiaoSp3, url)
        -- local language = self.languageTemplate:getLanguageById(name)
        self.biaotiLabel3:setString(name)


    end
end

function LevelUpOpen:clearView()
    --self.upViewNode:setTouchEnabled(false)
    if self.adapterLayer then
        self.adapterLayer:removeFromParent(true)
        self.adapterLayer = nil
    end
    
end

return LevelUpOpen













