-- fromtype


local PVRuneLook = class("PVRuneLook", BaseUIView)

function PVRuneLook:ctor(id)
    self.super.ctor(self, id)
end

function PVRuneLook:onMVCEnter()
    self.c_runeData = getDataManager():getRuneData()
    self.commonData = getDataManager():getCommonData()

    self.c_runeNet = getNetManager():getRuneNet()

    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()

    self:registerDataBack()

    self:initData()
    self:initView()
end

--网络返回
function PVRuneLook:registerDataBack()
end

--相关数据初始化
function PVRuneLook:initData()
    self.curRuneItem = self.funcTable[1]
    self.typeIndex = self.funcTable[2]--typeIndex 1:从符文镶嵌界面跳转  2:从符文炼化界面跳转  3:从选择符文界面
    self.curRuneId = self.curRuneItem.runt_id
    self.curRuneNo = self.curRuneItem.runt_no
    self.curRuneType = self.curRuneItem.runeType
    self.curRunePos = self.curRuneItem.runePos
end

--界面加载以及初始化
function PVRuneLook:initView()
    print("PVRuneLook:initView======================>")
    self.UIRuneLook = {}

    self:initTouchListener()
    self:loadCCBI("rune/ui_rune_look.ccbi", self.UIRuneLook)

    self.itemName = self.UIRuneLook["UIRuneLook"]["itemName"]
    self.itemIconImg = self.UIRuneLook["UIRuneLook"]["itemIconImg"]
    self.mainAtrribute = self.UIRuneLook["UIRuneLook"]["mainAtrribute"]
    self.mintorLayer = self.UIRuneLook["UIRuneLook"]["mintorLayer"]
    self.costValue = self.UIRuneLook["UIRuneLook"]["costValue"]

    self.glodBG = self.UIRuneLook["UIRuneLook"]["glodBG"]
    self.deleteBtn = self.UIRuneLook["UIRuneLook"]["deleteBtn"]
    self.changeBtn = self.UIRuneLook["UIRuneLook"]["changeBtn"]

    self.randLabel = self.UIRuneLook["UIRuneLook"]["randLabel"]

    self.minorLayer = self.UIRuneLook["UIRuneLook"]["minorLayer"]

    self.attrs = {}
    for i=1,10 do
        local _name = string.format("attr%d", i)
        local _attrLabel = self.UIRuneLook["UIRuneLook"][_name]
        table.insert(self.attrs, _attrLabel)
    end

    self:updateShowView()
end

--界面监听事件
function PVRuneLook:initTouchListener()
    --返回
    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --更换符文
    local function onChangeClick()
        getAudioManager():playEffectButton2()
        if self.curRuneItem ~= nil then
            cclog("跳到符文背包更换符文 ========= ")
            local haveCoin = self.commonData:getCoin()
            local pickPrice = self.c_StoneTemplate:getPickPriceById(self.curRuneItem.runt_id)
            if haveCoin >= pickPrice then
                self.c_runeData:setPreRuneItem(self.curRuneItem)
                self:onHideView()            
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVRuneBagPanel", 3)  
            else
                getOtherModule():showAlertDialog(nil, Localize.query(101))
            end                       
        end
    end

    --摘除
    local function onDeleteClick()
        getAudioManager():playEffectButton2()
        local curSoldierId = self.c_runeData:getCurSoliderId()
        if self.typeIndex == 1 then--从符文镶嵌页面过来
            local haveCoin = self.commonData:getCoin()
            local pickPrice = self.c_StoneTemplate:getPickPriceById(self.curRuneId)
            if haveCoin >= pickPrice then
                self.c_runeNet:sendDeleRune(curSoldierId, self.curRuneType, self.curRunePos)
                self:onHideView()
            else
                getOtherModule():showAlertDialog(nil, Localize.query(101))
            end
        elseif self.typeIndex == 2 then--从符文炼化界面过来
            self:onHideView("cancel_selected_rune", self.curRuneItem.runePos)--取消选择符文
        end
    end

    self.UIRuneLook["UIRuneLook"] = {}

    self.UIRuneLook["UIRuneLook"]["backMenuClick"] = backMenuClick                  --返回
    self.UIRuneLook["UIRuneLook"]["onDeleteClick"] = onDeleteClick                  --摘除
    self.UIRuneLook["UIRuneLook"]["onChangeClick"] = onChangeClick                  --更换
end

function PVRuneLook:updateShowView()
    --符文名称
    local nameId = self.c_StoneTemplate:getStoneItemById(self.curRuneId).name
    local nameStr = self.c_LanguageTemplate:getLanguageById(nameId)
    self.itemName:setString(nameStr)
    --符文摘除需要的价格
    local delePrice = self.c_StoneTemplate:getStoneItemById(self.curRuneId).PickPrice
    self.costValue:setString(delePrice)
    --符文icon
    local resId = self.c_StoneTemplate:getStoneItemById(self.curRuneId).res
    local resIcon = self.c_ResourceTemplate:getResourceById(resId)
    local quality = self.c_StoneTemplate:getStoneItemById(self.curRuneId).quality
    local icon = "res/icon/rune/" .. resIcon
    self.itemIconImg:setTexture(icon)
    self.itemIconImg:setScale(1.5)
    -- setItemImage(self.itemIconImg, icon, quality)

    if self.fromtype ~= 2 then
        --符文主要属性
        local mainAttribute = self.curRuneItem.main_attr

        for k, v in pairs(mainAttribute) do
            local attr_type = v.attr_type
            local attr_value = v.attr_value
            attr_value = math.floor(attr_value * 10) / 10
            local typeStr = self.c_StoneTemplate:getAttriStrByType(attr_type)
            local min, max = self.c_StoneTemplate:getMainValue(self.curRuneId, attr_type)
            local mainAttriStr = typeStr .. "+" .. attr_value .. " (" .. min .. " - " .. max .. ")"

            self.mainAtrribute:setString(mainAttriStr)
        end

        local minorAttribute = self.curRuneItem.minor_attr
        if table.getn(minorAttribute) == 0 then
            self.minorLayer:setVisible(false)
        end
        for k,v in pairs(minorAttribute) do
            local label = cc.LabelTTF:create("", MINI_BLACK_FONT_NAME, 22)
            local attriStr = nil
            label:setAnchorPoint(cc.p(0, 0.5))
            local color = self.c_StoneTemplate:getColorByQuality(quality)
            label:setColor(color)
            local typeStr = self.c_StoneTemplate:getAttriStrByType(v.attr_type)
            print("v.attr_type =============== ", v.attr_type)
            v.attr_value = math.floor(v.attr_value * 10) / 10
            local min, max = self.c_StoneTemplate:getMintorValue(self.curRuneId, v.attr_type)
            if min ~= nil and max ~= nil then
                attriStr = typeStr .. "+" .. v.attr_value .. " (" .. min .. " - " .. max .. ")"
            else
                attriStr = typeStr .. "+" .. v.attr_value
            end

            label:setPosition(cc.p(15, 145 - (k - 1) * 30))
            label:setString(attriStr)
            self.mintorLayer:addChild(label)
        end
    else
        self.glodBG:setVisible(false)
        self.deleteBtn:setVisible(false)
        self.changeBtn:setVisible(false)
        self:lookDetailInfo()
    end

    if self.typeIndex == 2 then
        self.glodBG:setVisible(false)
        self.deleteBtn:setPosition(cc.p(320, 150))
        self.changeBtn:setVisible(false)
    elseif self.typeIndex == 3 then
        self.glodBG:setVisible(false)
        self.deleteBtn:setVisible(false)
        self.changeBtn:setVisible(false)
    end
end

-- 秘境中查看属性
function PVRuneLook:lookDetailInfo()
     local typeStr = self.c_StoneTemplate:getAttriStrByType(self.curRuneType)
     local quality = self.c_StoneTemplate:getStoneItemById(self.curRuneId).quality
    local min, max = self.c_StoneTemplate:getMainValue(self.curRuneId, self.curRuneType)
    local mainAttriStr = typeStr  .. " (" .. min .. " - " .. max .. ")"

    self.mainAtrribute:setString(mainAttriStr)

    local _minorAttrNum = self.c_StoneTemplate:getminorAttrNum(self.curRuneId)

    if _minorAttrNum == 0 then
        self.minorLayer:setVisible(false)
    end

    if _minorAttrNum > 0 then
        self.randLabel:setVisible(true)
        self.randLabel:setString(string.format(Localize.query("PVSecretPlaceSeizeMineInfo.3"), _minorAttrNum))

        local _minorAttrs = self.c_StoneTemplate:getminorAttr(self.curRuneId)

        for k=1,10 do
            if k == 10 then k = 11 end
            local _attr_type = string.format("%d", k)

            local typeStr = self.c_StoneTemplate:getAttriStrByType(k)
            local _attriStr = typeStr .. " (" .. _minorAttrs[_attr_type][3] .. " - " .. _minorAttrs[_attr_type][4] .. ")"

            -- self.attrs[k]:setString(_attriStr)
            if k == 11 then k = 10 end
            local color = self.c_StoneTemplate:getColorByQuality(quality)
            self.attrs[tonumber(k)]:setColor(color)
            self.attrs[tonumber(k)]:setString(_attriStr)
            self.attrs[tonumber(k)]:setVisible(true)
        end
    end
end

function PVRuneLook:onReloadView()
end

function PVRuneLook:clearResource()
end

return PVRuneLook
