--无双属性页面
-- @ 需要传入无双Id
-- @ 

local PVWSDetailPage = class("PVWSDetailPage", BaseUIView)

function PVWSDetailPage:ctor(id)
    self.super.ctor(self, id)
    self.stageTemp = getTemplateManager():getInstanceTemplate()
    self.langTemp = getTemplateManager():getLanguageTemplate()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.heroTemp = getTemplateManager():getSoldierTemplate()
    self.lineupData = getDataManager():getLineupData()
    self.heroData = getDataManager():getSoldierData()

    self:registerNetCallback()
end

function PVWSDetailPage:onMVCEnter()
    self.ccbiNode = {}

    self:initTouchListener()
    self:loadCCBI("lineup/ui_lineup_ws_page.ccbi", self.ccbiNode)
    self:initView()
    self:initViewData()
    self:updateViewData()
end

function PVWSDetailPage:registerNetCallback()
    local function getWSUpgrade(id, data)
        if data.result then 
            print("@@@ 升级成功")
            self.lineupData:setWSLevel(self.data, self.wsLevel+1)
            print("self.data", self.data)
            getDataManager():getCommonData():subCoin(self.coinNum)
            getDataManager():getCommonData():subYuanqi(self.shitouNum)

            getOtherModule():showAlertDialog(nil, Localize.query("wushuang.7"))
            self:updateViewData()
        else
            print("@@@ 升级失败")
        end
    end
    self:registerMsg(NET_ID_WS_UPGRADE, getWSUpgrade)
end

-- 获取控件与设置属性
function PVWSDetailPage:initView()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

    assert(self.funcTable, "PVWSDetailPage's funcTable must not be nil !")
    self.data = self.funcTable[1]  -- 传入的无双id
    self.isinherit = self.funcTable[2]  -- 传入的无双id

    --获取属性
    self.ccbiRootNode = self.ccbiNode["UIWSPage"]

    self.menuUpgrade = self.ccbiRootNode["menu_upgrade"]
    self.labelWSName = self.ccbiRootNode["ws_name"]
    self.imgWS = self.ccbiRootNode["ws_img"]
    self.bmFontLevel = self.ccbiRootNode["label_lv"]
    self.nodeWSCondition = self.ccbiRootNode["node_richtext"]
    self.nodeHeroMenu = self.ccbiRootNode["node_menu"]
    self.labelSkillName = self.ccbiRootNode["skillname"]
    self.labelSkillDes = self.ccbiRootNode["skillDec"]
    self.bmFontShiTou = self.ccbiRootNode["shitou_num"]
    self.bmFontShiTou2 = self.ccbiRootNode["shitou_num2"]
    self.bmFontGold = self.ccbiRootNode["gold_num"]
    self.labelTouchTips = self.ccbiRootNode["unlock_hero"]
    self.animationNode = self.ccbiRootNode["animationNode"]

    self.ritchTextNode = self.ccbiRootNode["ritchTextNode"]
    local ws_bg = self.ccbiRootNode["ws_bg"]
    
    -- ws_bg:setTexture("res/ccb/effectpng/ui_ws_bg.png")
    

    self.sjLayer = self.ccbiRootNode["sjLayer"]
    self.changeLayer = self.ccbiRootNode["changeLayer"] 
    self.barNode = self.ccbiRootNode["barNode"]
    
    ---------传承
    if self.isinherit then 
        self.sjLayer:setVisible(false)
        self.changeLayer:setVisible(true)
    end

    -----给无双技能加段位
    local sprite1 = game.newSprite("#ui_fight_wstiao_bg.png")
    local sprite2 = game.newSprite("#ui_fight_wstiao.png")
    local sprite3 = game.newSprite()
     self.slider = cc.ControlSlider:create(sprite1, sprite2, sprite3)
    self.slider:setEnabled(false)
    self.slider:setMinimumValue(0)
    self.slider:setMaximumValue(100)
    self.slider:setAnchorPoint(cc.p(0,0.5))
    self.barNode:addChild(self.slider)
end

function PVWSDetailPage:initTouchListener()

    local function backMenuClick()
        getAudioManager():playEffectButton2()

        -- stepCallBack(G_GUIDE_20117)
        groupCallBack(GuideGroupKey.BTN_CLOSE_WS)
        
        self:onHideView(101)
    end
    local function upgradeMenuClick()
        getAudioManager():playEffectButton2()

        if getDataManager():getCommonData():getCoin() < self.coinNum and getDataManager():getCommonData():getYuanqi() < self.shitouNum then
            getOtherModule():showAlertDialog(nil, Localize.query("wushuang.8"))
            return
        end

        if getDataManager():getCommonData():getCoin() < self.coinNum then
            getOtherModule():showAlertDialog(nil, Localize.query("wushuang.9"))
            return
        end
        if getDataManager():getCommonData():getYuanqi() < self.shitouNum then
            getOtherModule():showAlertDialog(nil, Localize.query("wushuang.10"))
            return
        end

        getNetManager():getLineUpNet():sendWSUpgrade(self.data, self.wsLevel+1)
    end
    local function changeWS()
        print("更改无双")
        if self.isinherit == 0 then 
            local ws = {}
            getDataManager():getInheritData():setws2(ws)
            self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritWSList", 0) 
            -- getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritZBList", 0)
        else  
            _inherit = self.funcTable[2]
            self:onHideView()
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritWSList", _inherit) 
            _inherit = nil
        end
    end

    self.ccbiNode["UIWSPage"] = {}
    self.ccbiNode["UIWSPage"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UIWSPage"]["menuClickUpgrade"] = upgradeMenuClick
    self.ccbiNode["UIWSPage"]["changeWS"] = changeWS

end

function PVWSDetailPage:initViewData()
    
    self.itemData = self.stageTemp:getWSInfoById(self.data)
    local nameId = self.itemData.name
    local wsName = self.langTemp:getLanguageById(nameId)

    self.labelWSName:setString(wsName)

    local _icon = self.resourceTemp:getResourceById(self.itemData.icon)
    game.setSpriteFrame(self.imgWS, "res/icon/ws/".._icon)

    -- to do -- 要根据类型来分配不同的特效
    local node = UI_wushuangjiemian(callback)
    self.animationNode:addChild(node)

    -- 英雄名字，头像
    local richtext = ccui.RichText:create()
    local menu = cc.Menu:create()

    local condition = {}
    local v = self.stageTemp:getWSInfoById(self.data)
    if v.condition1 ~= 0 then table.insert(condition, v.condition1) end
    if v.condition2 ~= 0 then table.insert(condition, v.condition2) end
    if v.condition3 ~= 0 then table.insert(condition, v.condition3) end
    if v.condition4 ~= 0 then table.insert(condition, v.condition4) end
    if v.condition5 ~= 0 then table.insert(condition, v.condition5) end
    if v.condition6 ~= 0 then table.insert(condition, v.condition6) end
    if v.condition7 ~= 0 then table.insert(condition, v.condition7) end

    local count = table.nums(condition)
    local isActive = true
    local _index = -1
    for k,v in pairs(condition) do
        _index = _index + 1
        local _nameId = self.heroTemp:getHeroTempLateById(v).nameStr
        local _nameStr = self.langTemp:getLanguageById(_nameId)
        local menuItem = self:getSoldierMenuItem(v)
        local color = ui.COLOR_GREY
        if self:getSoldierIsActivity(v) then
            color = ui.COLOR_BLUE2
            -- menuItem:setEnabled(false)
        else 
            isActive = false 
            SpriteGrayUtil:drawSpriteTextureGray(menuItem:getNormalImage())
            -- menuItem:setEnabled(true)
        end
        local re1 = ccui.RichElementText:create(1, color, 255, _nameStr, "res/ccb/resource/miniblack.ttf", 22)
        richtext:pushBackElement(re1)
        local re2 = ccui.RichElementText:create(1, ui.COLOR_GREY, 255, " ", "res/ccb/resource/miniblack.ttf", 22)
        richtext:pushBackElement(re2)
        menuItem:setPosition(cc.p(-100+115*_index,30*_index-40))
        menu:addChild(menuItem)
    end

    local color = nil
    local str = nil
    if isActive then 
        color = ui.COLOR_WHITE
        str = Localize.query("wushuang.4")
        self.menuUpgrade:setEnabled(true)
        self.labelTouchTips:setVisible(false)
    else 
        color = ui.COLOR_WHITE
        str = Localize.query("wushuang.5")
        self.menuUpgrade:setEnabled(false)
        self.labelTouchTips:setVisible(true)
    end

    local active = ccui.RichElementText:create(1, color, 255, str, "res/ccb/resource/miniblack.ttf", 22)
    richtext:insertElement(active, 0)
    self.nodeWSCondition:addChild(richtext)
    -- richtext:set
    richtext:setAnchorPoint(cc.p(1,0.5))

    -- 头像位置
    -- menu:alignItemsHorizontallyWithPadding(20)
    -- menu:alignItemsVerticallyWithPadding(20)
    menu:setPosition(cc.p(0,0))
    self.nodeHeroMenu:addChild(menu)

end

--无双是否激活
function PVWSDetailPage:getSoldierIsActivity(soldierId)
    local selectSoldier = self.lineupData:getSelectSoldier()

    for k, v in pairs(selectSoldier) do
        if v.hero.hero_no == soldierId then
            return true
        end
    end
    return false
end

function PVWSDetailPage:onExit()

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
end

--返回英雄的按钮
function PVWSDetailPage:getSoldierMenuItem(soldierId)
    local quality = self.heroTemp:getHeroQuality(soldierId)
    local normal = self.heroTemp:getSoldierIcon(soldierId)
    local disabled = self.heroTemp:getSoldierIcon(soldierId)
    local normalSprite = game.newSprite()
    changeNewIconImage(normalSprite, normal, quality)
    local disabledSprite = game.newSprite()
    changeNewIconImage(disabledSprite, disabled, quality)
    -- SpriteGrayUtil:drawSpriteTextureGray(disabledSprite)

    local item = cc.MenuItemSprite:create(disabledSprite, disabledSprite, normalSprite)
    local function cardDetailCallback()
        local _heroData = self.heroData:getSoldierDataById(soldierId)
        if _heroData == nil then
            print("------_heroData-------")
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", soldierId)
        else
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierMyLookDetail", soldierId)
        end
        -- local soldierToGetId = self.heroTemp:getHeroTempLateById(soldierId).toGet
        -- local _data = getTemplateManager():getChipTemplate():getDropListById(soldierToGetId)
        -- if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
        --     and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
        --     and _data.arenaShop == 0 and _data.stageBreak == 0  then

        --     local tipText = self.langTemp:getLanguageById(3300010001)
        --     -- getOtherModule():showToastView(tipText)
        --     getOtherModule():showAlertDialog(nil, tipText)

        -- else
        --     -- getOtherModule():showOtherView("PVChipGetDetail", _data)
        --     getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVChipGetDetail", _data)
        -- end
    end
    item:registerScriptTapHandler(cardDetailCallback)
    item:setScale(0.9)
    return item
end

function PVWSDetailPage:updateViewData()
    self.wsLevel = self.lineupData:getWSLevel(self.data)
    self.bmFontLevel:removeAllChildren()
    local levelNode = getLevelNode(tostring(self.wsLevel))
    self.bmFontLevel:addChild(levelNode)
    -- self.bmFontLevel:setString(self.wsLevel)
    self.labelSkillName:setString()
    
    local skillName = nil
    local skillDes = nil
    self.shitouNum = 0
    self.coinNum = 0
    if self.wsLevel == 1 then 
        local skillId = self.itemData.triggle2
        local info = getTemplateManager():getSoldierTemplate():getSkillTempLateById(skillId)
        skillName = self.langTemp:getLanguageById(info.name)
        skillDes = self.langTemp:getLanguageById(info.describe)
        self.shitouNum = self.itemData.expend2[1]
        self.coinNum = self.itemData.expend2[2]
    elseif self.wsLevel == 2 then
        local skillId = self.itemData.triggle3
        local info = getTemplateManager():getSoldierTemplate():getSkillTempLateById(skillId)
        skillName = self.langTemp:getLanguageById(info.name)
        skillDes = self.langTemp:getLanguageById(info.describe)
        self.shitouNum = self.itemData.expend3[1]
        self.coinNum = self.itemData.expend3[2]
    elseif self.wsLevel == 3 then
        local skillId = self.itemData.triggle3
        local info = getTemplateManager():getSoldierTemplate():getSkillTempLateById(skillId)
        skillName = self.langTemp:getLanguageById(info.name)
        skillDes = self.langTemp:getLanguageById(info.describe)
        self.shitouNum = 0
        self.coinNum = 0
        self.menuUpgrade:setEnabled(false)
    end
    self.labelSkillName:setString(skillName)
    self.labelSkillDes:setString(skillDes)
    local allNum = getDataManager():getCommonData():getYuanqi()
    -- local str = tostring(self.shitouNum).."/"..tostring(allNum)

    local color = ui.COLOR_WHITE
    if self.shitouNum > allNum then
        color = ui.COLOR_RED
    else
        color = ui.COLOR_GREEN
    end
    
    self.ritchTextNode:removeChildByTag(1001)
    local richtext = ccui.RichText:create()
    richtext:setAnchorPoint(cc.p(0,0.5))
    richtext:setTag(1001)

    -- local re0 = ccui.RichElementText:create(1, color, 255, tostring(self.shitouNum), "res/ccb/resource/miniblack.ttf", 25)
    -- richtext:pushBackElement(re0)

    -- local re1 = ccui.RichElementText:create(1, ui.COLOR_WHITE, 255, ("/"..tostring(allNum)), "res/ccb/resource/miniblack.ttf", 25)
    -- richtext:pushBackElement(re1)

    local re1 = ccui.RichElementText:create(1, color, 255, (tostring(allNum)), "res/ccb/resource/miniblack.ttf", 25)
    richtext:pushBackElement(re1)

    local re0 = ccui.RichElementText:create(1, ui.COLOR_WHITE, 255, ("/"..tostring(self.shitouNum)), "res/ccb/resource/miniblack.ttf", 25)
    richtext:pushBackElement(re0)

   

    self.ritchTextNode:addChild(richtext)
    self.bmFontShiTou:setVisible(false)
    self.bmFontShiTou2:setVisible(false)


    local allNum = getDataManager():getCommonData():getCoin()
    self.bmFontGold:setString(self.coinNum)
    if self.coinNum > allNum then
        self.bmFontGold:setColor(ui.COLOR_RED)
    end

    --- 无双段位
    local unparaValue = nil
    if self.wsLevel == 1 then
        unparaValue = 36    
    elseif self.wsLevel == 2 then
        unparaValue = 64
    elseif self.wsLevel == 3 then
        unparaValue = 100
    end
    self.slider:setValue(unparaValue)
end

return PVWSDetailPage
