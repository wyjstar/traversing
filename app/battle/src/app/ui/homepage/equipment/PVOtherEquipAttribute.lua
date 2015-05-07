--未获得装备属性
--使用时，采用showUIView（,）将equipment的数据传给self.funcTable
-- @ setChageModel
-- funcTable[2] = type : 1 : 显示更换卸下按钮

local PVOtherEquipAttribute = class("PVOtherEquipAttribute", BaseUIView)
-- g_seat = nil
g_equipData = nil

function PVOtherEquipAttribute:ctor(id)
    print("PVOtherEquipAttribute ============== ")
    PVOtherEquipAttribute.super.ctor(self, id)
end

function PVOtherEquipAttribute:onMVCEnter()
    print("PVOtherEquipAttribute ============== onMVCEnter =======  ")
    self.ccbiNode = {}

    self:initTouchListener()

    self:loadCCBI("equip/ui_equipment_attribute.ccbi", self.ccbiNode)
    self:initView()

    self:createScrollView()
    self:createBasicAttribute()
end

-- 获取控件与设置属性
function PVOtherEquipAttribute:initView()
    print("获取控件与设置属性 PVOtherEquipAttribute:initView ======= ")
    assert(self.funcTable, "PVOtherEquipAttribute's funcTable must not be nil !")
    self.equipData = self.funcTable[1]
    self.type = self.funcTable[2]
    self.shopType = self.funcTable[3]
    -- g_seat = self.funcTable[3]

    --获取属性
    self.ccbiRootNode = {}
    self.ccbiRootNode = self.ccbiNode["UIEquipAttribute"]
    self.equipPrefix = self.ccbiRootNode["equipPrefix"]
    -- self.pointSprite = self.ccbiRootNode["pointSprite"]
    self.labelEquipName = self.ccbiRootNode["equipName"]
    self.labelEquipLv = self.ccbiRootNode["equipLv"]
    self.labelEquipDec = self.ccbiRootNode["equipDec"]
    self.nowLv = self.ccbiRootNode["nowLv"]
    -- self.labelAttr = self.ccbiRootNode["attributeKind"]  -- 主要属性增强
    self.labelEquipTo = self.ccbiRootNode["equipTo"]
    self.labelEquipToTip = self.ccbiRootNode["label_fnt_e_to_who"]
    self.imgPic = self.ccbiRootNode["equipPic"]
    -- self.imgPic:setScale(1.2,1.2)
    -- self.imgIcon = self.ccbiRootNode["icon_img"]

    self.menuChange = self.ccbiRootNode["equipMenuB"]  -- 更换和卸下按钮
    self.menuDown = self.ccbiRootNode["equipMenuC"]
    self.imgFntTakeoff = self.ccbiRootNode["img_fnt_takeoff"]
    self.imgFntChange = self.ccbiRootNode["img_fnt_change"]

    self:setChageModel(false)

    self.listLayer = self.ccbiRootNode["listLayer"]
    self.labelTips = self.ccbiRootNode["label_tips"]
    self.nodeEffectLabels = self.ccbiRootNode["node_effects"]
    self.menus = self.ccbiRootNode["menu_node"]

    self.equipMenuA = self.ccbiRootNode["equipMenuA"]

    self.getButton = self.ccbiRootNode["getButton"]

    --模板
    local languageTemp = getTemplateManager():getLanguageTemplate()
    local equipTemp = getTemplateManager():getEquipTemplate()
    local _equipTempItem = equipTemp:getTemplateById(self.equipData.id)
    -- local squipTemp = getTemplateManager():getSquipmentTemplate()

    if self.type == 1 then
        self:setChageModel()
        self.equipMenuA:setVisible(true)
        ----------------  传承 ---------------
        local _inherit = self.funcTable[4]
        local _inheritP = self.funcTable[5]
        if _inherit ~= nil then
            -- self.menuDown:setVisible(false)
            -- self.menuChange:setPosition(320, 60)
            self.equipMenuA:setVisible(false)
            -- self:setChageModel(false)
        end
        --------------------------------------
    end

    if self.type == 2 then
        self:setChageModel()
        self.equipMenuA:setVisible(false)
        self.getButton:setVisible(true)
        local posY = self.getButton:getPositionY()
        self.getButton:setPosition(cc.p(320, posY))
        self.menuChange:setVisible(false)
        self.menuDown:setVisible(false)
    elseif self.type == 10 then
        self.equipMenuA:setVisible(false)
        self.getButton:setVisible(true)
        local posY = self.getButton:getPositionY()
        self.getButton:setPosition(cc.p(320, posY))
    elseif self.type == nil then
        self.getButton:setVisible(false)
        self.equipMenuA:setVisible(false)
    end


    self.equipMenuA_text = self.ccbiRootNode["equipMenuA_text"]

    if _equipTempItem.type == 5 or _equipTempItem.type == 6 then
        self.equipMenuA:setVisible(false)
        self.equipMenuA_text:setVisible(false)
        -- SpriteGrayUtil:drawSpriteTextureGray(self.menuSuit1:getNormalImage())
    end

    --装备名字
    self._name = languageTemp:getLanguageById(_equipTempItem.name)
    local _reshd = equipTemp:getEquipResHD(self.equipData.id)
    local _icon = equipTemp:getEquipResIcon(self.equipData.id)
    local _quality = equipTemp:getQuality(self.equipData.id)
    -- changeEquipIconImageBottom(self.imgIcon, _icon, _quality)
    self.imgPic:setTexture("res/equipment/".._reshd)
    -- --装备在谁
    -- local _equipedWho = self.lineupData:getEquipTo(self.equipData.id)
    -- --描述
    self._descript = languageTemp:getLanguageById(_equipTempItem.describe)
    -- --level
    -- self._level = self.equipData.strengthen_lv

    -- --给控件赋值
    local _x,_y = self.labelEquipName:getPosition()
    self.labelEquipName:setPosition(cc.p(_x-50,_y))
    self.labelEquipName:setString(self._name)
    local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
    self.labelEquipName:setColor(color)

    local levelNode = getLevelNode(1)
    self.labelEquipLv:addChild(levelNode)

    -- self.labelEquipLv:setString("1")
    self.labelEquipToTip:setString("")
    self.labelEquipTo:setString("")

    self.labelEquipDec:setString(self._descript)

    self.equipPrefix:setVisible(false)
    -- self.pointSprite:setVisible(false)

end

function PVOtherEquipAttribute:setChageModel(flag)
    if flag == nil then flag = true end
    self.menuChange:setVisible(flag)
    self.menuDown:setVisible(flag)
    ----------------  传承 ---------------
    local _inherit = self.funcTable[4]
    local _inheritP = self.funcTable[5]
    if _inherit ~= nil then
        self.menuDown:setVisible(false)
        self.menuChange:setPosition(320, 60)
        self.equipMenuA:setVisible(false)
        -- self:setChageModel(false)
    end
    --------------------------------------
end

function PVOtherEquipAttribute:initTouchListener()

    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    local function strengthenMenuClick()
        getAudioManager():playEffectButton2()
        -- print("strengthen menu click")
        g_equipData = self.equipData

        ----------------  传承 ---------------
        local _inherit = self.funcTable[4]
        if _inherit ~= nil then
            if _inherit == 0 then
                self:onHideView(-1)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentStrengthen", g_equipData, 0)
            else
                self:onHideView(-1)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentStrengthen", g_equipData, 1)
            end
            return
        end
        --------------------------------------

        self:onHideView(-1)
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentStrengthen", g_equipData)


        -- self:onHideView()
    end

    --更换装备
    -- function onChangeClick()
    --     ----------------  传承 ---------------
    --     local _inherit = self.funcTable[4]
    --     if _inherit ~= nil then

    --         if _inherit == 0 then
    --             local equ = {}
    --             getDataManager():getInheritData():setequId2(equ)
    --             self:onHideView()
    --             getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritZBList", 0, 0)
    --         else
    --             _inherit = self.funcTable[4]
    --             _inheritP = self.funcTable[5]
    --             self:onHideView()
    --             getModule(MODULE_NAME_HOMEPAGE):showUIView("PVInheritZBList", _inherit, _inheritP)
    --             _inherit = nil
    --             _inheritP = nil
    --         end

    --         return
    --     end
    --     --------------------------------------
    --     getAudioManager():playEffectButton2()
    --     self:onHideView(-1)
    --     getModule(MODULE_NAME_LINEUP):showUIView("PVSelectEquipment", g_seat)
    --     g_seat = nil
    -- end
    -- function onTakeOffClick()
    --     getAudioManager():playEffectButton2()
    --     self:onHideView(0)
    -- end

    function onGetSoldierClick()
        print("onGetSoldierClick ============ ")
        local equToGetId = getTemplateManager():getEquipTemplate():getTemplateById(self.equipData.id).toGet
        local _data =  getTemplateManager():getChipTemplate():getDropListById(equToGetId)
        if (type(_data.stage) == "table" and table.nums(_data.stage) == 0) and _data.coinHero == 0
            and _data.moneyHero == 0 and _data.coinEqu == 0 and _data.moneyEqu == 0 and _data.soulShop == 0
            and _data.arenaShop == 0 and _data.stageBreak == 0  then
        -- if _data and type(_data) == "table" and table.nums(_data) == 0 then
            local tipText = getTemplateManager():getLanguageTemplate():getLanguageById(3300010001)
            -- getOtherModule():showToastView(tipText)
            getOtherModule():showAlertDialog(nil, tipText)

        else
            getOtherModule():showOtherView("PVChipGetDetail", _data, self.equipData.id, 3)
        end
     end

    self.ccbiNode["UIEquipAttribute"] = {}
    self.ccbiNode["UIEquipAttribute"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UIEquipAttribute"]["equipMenuClickA"] = strengthenMenuClick
    -- self.ccbiNode["UIEquipAttribute"]["equipMenuChange"] = onChangeClick
    -- self.ccbiNode["UIEquipAttribute"]["MenuTakeOff"] = onTakeOffClick
    self.ccbiNode["UIEquipAttribute"]["onGetSoldierClick"] = onGetSoldierClick
end

function PVOtherEquipAttribute:createScrollView()
    -- local function scrollView2DidScroll()
    --     print("scrollView2DidScroll")
    -- end
    self.scrollView = cc.ScrollView:create()
    local screenSize = self.listLayer:getContentSize()
    if nil ~= self.scrollView then
        self.scrollView:setViewSize(cc.size(screenSize.width, screenSize.height))
        self.scrollView:ignoreAnchorPointForPosition(true)

        self.svContaner = cc.Layer:create()
        self.svContaner:setAnchorPoint(cc.p(0,0))
        self.scrollView:setContainer(self.svContaner)
        self.scrollView:updateInset()

        self.scrollView:setDirection(1)
        self.scrollView:setClippingToBounds(true)
        self.scrollView:setBounceable(true)
        self.scrollView:setDelegate()
    end

    self.listLayer:addChild(self.scrollView)
    -- self.scrollView:registerScriptHandler(scrollView2DidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
end

-- 获得羁绊描述
local function getSkillInfo(strText, skillId)
    local function getBuffInfo(buff)
        local strEffect = ""
        for i,v in ipairs(buff) do
            local buffInfo = getTemplateManager():getSoldierTemplate():getSkillBuffTempLateById(buff[i])
            local buffEffectId = buffInfo.effectId
            local buffType = buffInfo.valueType
            local buffValue = buffInfo.valueEffect
            local strValue = nil
            if buffType == 1 then strValue = tostring(buffValue)
            elseif buffType == 2 then strValue = tostring(buffValue) .. "%"
            end
            strEffect = strEffect .. getTemplateManager():getSoldierTemplate():getSkillBuffEffectName(buffEffectId) .. strValue
        end
        return strEffect
    end

    local skillInfo = getTemplateManager():getSoldierTemplate():getSkillTempLateById(skillId)
    local buff = skillInfo.group
    strText = string.gsub(strText, "s%%", "")
    strText = strText .. getBuffInfo(buff)
    return strText
end

function PVOtherEquipAttribute:createBasicAttribute()

    local languageTemp = getTemplateManager():getLanguageTemplate()
    local equipTemp = getTemplateManager():getEquipTemplate()
    local equipTempItem = equipTemp:getTemplateById(self.equipData.id)
    local squipTemp = getTemplateManager():getSquipmentTemplate()
    local soldierTemp = getTemplateManager():getSoldierTemplate()

    self.nodeToContain = game.newNode()  -- 存放部件的node
    self.svContaner:addChild(self.nodeToContain)

    --基本属性
    local _descrip = ""
    local isJB = false
    local attributeItem = {}
    if self.shopType == nil then
        attributeItem = equipTemp:getMainAttribute(self.equipData.id)
    elseif self.shopType == 1 then
        attributeItem = equipTemp:getSpecialAttribute(self.equipData.id)
    end

    local main_attr = attributeItem.mainAttr
    print("主要属性 ============= ")
    table.print(main_attr)
    local mainNum = table.nums(main_attr)
    if mainNum == 0 then
        isJB = false
        print("没有主属性")
    else
        isJB = true
        for i = 1, 4 do
            local key = tostring(i)
            if main_attr[key] ~= nil then
                local str = getTemplateManager():getEquipTemplate():setSXName(i)
                -- local min,max = getTemplateManager():getEquipTemplate():getEquipTypeMinMax(self.equipData.id, i)
                local min = main_attr[key][3]
                local max = main_attr[key][4]
                _descrip = _descrip .. str .. " (" .. min .."-".. max .. ")".."\n"
            end
        end

        _descrip = "从以下属性中随机产生1条" .. "\n" .. _descrip
    end
    local theHight = 0
    if isJB then

        self._suitId = equipTempItem.suitNo

        self.attrNode = {}
        local proxy = cc.CCBProxy:create()
        local node1 = CCBReaderLoad("equip/ui_equip_other_item1.ccbi", proxy, self.attrNode)
        self.nodeToContain:addChild(node1)
        local labelMainAttr = self.attrNode["UIAttriItem"]["label_attri"]
        -- self.label_name = self.attrNode["UIAttriItem"]["label_name"]
        -- self.label_name:setString()
        labelMainAttr:setColor(ui.COLOR_WHITE)
        labelMainAttr:setString(_descrip)   --(_promoteString)

        local node1Size = self.attrNode["UIAttriItem"]["node_item"]:getContentSize()
        theHight = node1Size.height
        node1:setPositionY(-theHight)
    end

    --次要属性
    local _descrip = ""
    local copeStr = ""
    local isCB = false

    local minor_attr = attributeItem.minorAttr
    local cope = attributeItem.minorAttrNum
    print("次要属性 =========== ")
    -- table.print(minor_attr)
    local ciNum = table.nums(minor_attr)
    if ciNum == 0 then
        isCB = false
        print("没有次属性")
    else
        isCB = true
        local copeMin = cope[1]
        local copeMax = cope[2]
        for i = 1, 11 do
            local key = tostring(i)
            if minor_attr[key] ~= nil then
                local str = getTemplateManager():getEquipTemplate():setSXName(i)
                -- local min,max = getTemplateManager():getEquipTemplate():getEquipTypeMinMax(self.equipData.id, i)
                local min = minor_attr[key][3]
                local max = minor_attr[key][4]
                _descrip = _descrip .. str .. " (" .. min .."-".. max .. ")".."\n"
            end
        end
        if copeMin == copeMax then
            copeStr = "从以下属性中随机产生" .. copeMin .. "条"
        else
            copeStr = "从以下属性中随机产生" .. copeMin .. " - " .. copeMax .. "条"
        end
    end
    if isCB then
        -- cell.mainAttrLabel:setString(_descrip)
        local _quality = getTemplateManager():getEquipTemplate():getQuality(self.equipData.id)    -- 装备品质
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
        -- cell.mainAttrLabel:setColor(color)

        self._suitId = equipTempItem.suitNo

        self.attrNode = {}
        local proxy = cc.CCBProxy:create()
        local node2 = CCBReaderLoad("equip/ui_equip_other_item2.ccbi", proxy, self.attrNode)
        self.nodeToContain:addChild(node2)
        self.labelMainAttr = self.attrNode["UIAttriItem"]["label_attri"]
        self.desLabel = self.attrNode["UIAttriItem"]["desLabel"]
        self.labelMainAttr:setString(_descrip)   --(_promoteString)
        self.labelMainAttr:setColor(color)
        print("labelMainAttr ===================== ", ciNum)
        self.labelMainAttr:setDimensions(450, 28 * ciNum)
        self.desLabel:setString(copeStr)
        local node2Size = self.attrNode["UIAttriItem"]["node_item"]:getContentSize()
        theHight = theHight+node2Size.height
        node2:setPositionY(-theHight)
    end

    -- 套装
    if self._suitId ~= 0 then
        self.suitNode = {}
        local proxy = cc.CCBProxy:create()
        local node3 = CCBReaderLoad("equip/ui_equip_attri_item.ccbi", proxy, self.suitNode)
        self.nodeToContain:addChild(node3)

        local node3Size = self.suitNode["UIAttriItem"]["node_item"]:getContentSize()
        theHight = theHight + node3Size.height
        node3:setPositionY(-theHight)

        local labelSuitName = self.suitNode["UIAttriItem"]["label_suit_name"]
        local suitsImg = {}
        local suitsName = {}
        for i=1, 4 do
            local strkey1 = "img_suit"..tostring(i)
            local strkey2 = "label_name"..tostring(i)
            local imgSuit = self.suitNode["UIAttriItem"][strkey1]
            local suitName = self.suitNode["UIAttriItem"][strkey2]
            print("suitname", suitName, strkey2)
            table.insert( suitsImg, imgSuit )
            table.insert( suitsName, suitName )
        end
        local labelAttr1 = self.suitNode["UIAttriItem"]["label_attr1"]
        local labelAttr2 = self.suitNode["UIAttriItem"]["label_attr2"]
        local labelAttr3 = self.suitNode["UIAttriItem"]["label_attr3"]

        --套装
        local _suitId = self._suitId
        local suitTempItem = squipTemp:getTemplateById(_suitId)
        --套装名
        local _suitName = languageTemp:getLanguageById(suitTempItem.suitName)
        labelSuitName:setString(_suitName)
        --套装装备
        local _suitEquipIds = suitTempItem.suitMapping  -- 套装表
        for i,v in ipairs(_suitEquipIds) do
            local _icon = equipTemp:getEquipResIcon(v)  -- 资源名
            local _quality = equipTemp:getQuality(v)    -- 装备品质
            local _name = equipTemp:getEquipName(v)
            suitsName[i]:setString(_name)
            changeEquipIconImageBottom(suitsImg[i], _icon, _quality)
        end
        --提升技能buff
        local skillAttr1 = suitTempItem.attr1
        local skillAttr2 = suitTempItem.attr2
        local skillAttr3 = suitTempItem.attr3
        local _skillAttr1TempItem = soldierTemp:getSkillTempLateById(skillAttr1[2])
        local _skillAttr2TempItem = soldierTemp:getSkillTempLateById(skillAttr2[2])
        local _skillAttr3TempItem = soldierTemp:getSkillTempLateById(skillAttr3[2])
        local _skillInfo1 = ""
        local _skillInfo2 = ""
        local _skillInfo3 = ""
        local _skillBuffList1 = _skillAttr1TempItem.group
        local _skillBuffList2 = _skillAttr2TempItem.group
        local _skillBuffList3 = _skillAttr3TempItem.group
        for i,v in ipairs(_skillBuffList1) do
            _skillInfo1 = _skillInfo1 .. " " .. soldierTemp:getSkillBuffInfo(v)
        end
        for i,v in ipairs(_skillBuffList2) do
            _skillInfo2 = _skillInfo2 .. " " .. soldierTemp:getSkillBuffInfo(v)
        end
        for i,v in ipairs(_skillBuffList3) do
            _skillInfo3 = _skillInfo3 .. " " .. soldierTemp:getSkillBuffInfo(v)
        end
        labelAttr1:setString(_skillInfo1)
        labelAttr2:setString(_skillInfo2)
        labelAttr3:setString(_skillInfo3)
    end

    -- 羁绊
    local links = equipTemp:getLinks(self.equipData.id)
    for k,v in pairs(links) do -- v is hero_no
        local linkTable = soldierTemp:getLinkDataById(v)
        -- table.print(linkTable)
        local linkNameID = nil -- 找到羁绊信息
        local desID = nil
        local linkID = nil
        for _k,_v in pairs(linkTable) do
            for __k, __v in pairs(_v.trigger) do
                if __v == self.equipData.id then
                    linkNameID = _v.name
                    desID = _v.text
                    linkID = _v.link
                    break
                end
            end
            if linkNameID ~= nil then break end
        end

        local function toGetTheHero()  --  查看掉落
            getAudioManager():playEffectButton2()
            print("clicked heroIcon: ", v)
            local soldierToGetId = soldierTemp:getHeroTempLateById(v).toGet
            local _data =  getTemplateManager():getChipTemplate():getDropListById(soldierToGetId)
            if _data and type(_data) == "table" and table.nums(_data) == 0 then
                local tipText = languageTemp:getLanguageById(3300010001)
                -- getOtherModule():showToastView(tipText)
                getOtherModule():showAlertDialog(nil, tipText)
            else
                getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVChipGetDetail", _data)
            end
        end

        local linkNode = {}  -- 创建羁绊的界面
        linkNode["UIAttriItem"] = {}
        linkNode["UIAttriItem"]["onGetWay"] = toGetTheHero
        local proxy = cc.CCBProxy:create()
        local node4 = CCBReaderLoad("equip/ui_equip_attri_item3.ccbi", proxy, linkNode)
        self.nodeToContain:addChild(node4)

        local node4Size = linkNode["UIAttriItem"]["node_item"]:getContentSize()
        theHight = theHight + node4Size.height
        node4:setPositionY(-theHight)

        local linkName = linkNode["UIAttriItem"]["link_name"]
        local heroName = linkNode["UIAttriItem"]["hero_name"]
        local descLabel = linkNode["UIAttriItem"]["label_desc"]
        local menuHero = linkNode["UIAttriItem"]["menu_head"]

        linkName:setString(languageTemp:getLanguageById(linkNameID))
        heroName:setString(soldierTemp:getHeroName(v))

        local strDes = languageTemp:getLanguageById(desID)
        strDes = getSkillInfo(strDes, linkID)
        descLabel:setString(strDes)

        local icon = game.newSprite()
        local res = soldierTemp:getSoldierIcon(v)
        local quality = soldierTemp:getHeroQuality(v)
        changeNewIconImage(icon, res, quality)
        menuHero:setNormalImage(icon)
    end

    self.nodeToContain:setPositionY(theHight)
    self.svContaner:setContentSize( cc.size(self.listLayer:getContentSize().width, theHight) )
    self.scrollView:setContentSize( cc.size(self.listLayer:getContentSize().width, theHight) )

    -- self.scrollView:updateInset()
    self.scrollView:setContentOffset(self.scrollView:minContainerOffset())
end


return PVOtherEquipAttribute
