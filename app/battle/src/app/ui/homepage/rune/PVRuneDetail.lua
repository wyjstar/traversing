--符文详情
local PVRuneDetail = class("PVRuneDetail", BaseUIView)

function PVRuneDetail:ctor(id)
    self.super.ctor(self, id)
end

function PVRuneDetail:onMVCEnter()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()

    self:initData()
    self:initView()

end

function PVRuneDetail:onExit()
    --self:unregisterScriptHandler()
    --game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")
end

function PVRuneDetail:initView()
    self.UITravelPropItem = {}
    self:initTouchListener()

    self:loadCCBI("travel/ui_travel_prop_item.ccbi", self.UITravelPropItem)

    self.itemIconImg = self.UITravelPropItem["UITravelPropItem"]["itemIcon"]
    self.itemName = self.UITravelPropItem["UITravelPropItem"]["itemName"]
    self.attributeLabel = self.UITravelPropItem["UITravelPropItem"]["attributeLabel"]
    self.itemTimes = self.UITravelPropItem["UITravelPropItem"]["itemTimes"]
    self.itemDes = self.UITravelPropItem["UITravelPropItem"]["itemDes"]
    self.itemTimes:setVisible(false)
    self.itemDes:setVisible(false)
    self:updateDetail()
end

function PVRuneDetail:updateDetail()
    local nameId = self.c_StoneTemplate:getStoneItemById(self.curRuneItem.runt_id).name
    local nameStr = self.c_LanguageTemplate:getLanguageById(nameId)
    self.itemName:setString(nameStr)
    --符文icon
    local resId = self.c_StoneTemplate:getStoneItemById(self.curRuneItem.runt_id).res
    local resIcon = self.c_ResourceTemplate:getResourceById(resId)
    local quality = self.c_StoneTemplate:getStoneItemById(self.curRuneItem.runt_id).quality
    local icon = "res/icon/rune/" .. resIcon
    setItemImage(self.itemIconImg, icon, quality)
    --符文属性
    local mainAttribute = self.curRuneItem.main_attr
    local minorAttribute = self.curRuneItem.minor_attr
    for k, v in pairs(mainAttribute) do
        local attr_type = v.attr_type
        local attr_value = v.attr_value
        attr_value = math.floor(attr_value * 10) / 10
        local typeStr = self.c_StoneTemplate:getAttriStrByType(attr_type)
        local mainAttriStr = typeStr .. "+" .. attr_value
        self.attributeLabel:setString(mainAttriStr)
    end
end

function PVRuneDetail:initData()
    self.curRuneItem = self.funcTable[1]
end

function PVRuneDetail:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    self.UITravelPropItem["UITravelPropItem"] = {}
    self.UITravelPropItem["UITravelPropItem"]["onCloseClick"] = onCloseClick
end

function PVRuneDetail:onReloadView()

end

return PVRuneDetail

