local PVReceiveDialog = class("PVReceiveDialog", BaseUIView)

function PVReceiveDialog:ctor(id)
    self.super.ctor(self, id)
end

function PVReceiveDialog:onMVCEnter()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self:initData()
    self:initView()
end

function PVReceiveDialog:initData()
    self.receiveId = self.funcTable[1]
end

function PVReceiveDialog:initTouchListener()
    --关闭
    local function onCloseClick()
        self:onHideView()
    end
    --确定
    local function onSureClick()
        self:onHideView()
    end

    self.UICommonGetCard["UICommonGetCard"] = {}
    self.UICommonGetCard["UICommonGetCard"]["onCloseClick"] = onCloseClick
    self.UICommonGetCard["UICommonGetCard"]["onSureClick"] = onSureClick
end

function PVReceiveDialog:initView()
    self.UICommonGetCard = {}
    self:initTouchListener()

    self:loadCCBI("common/ui_common_getcard.ccbi", self.UICommonGetCard)

    self.contentLayer = self.UICommonGetCard["UICommonGetCard"]["contentLayer"]
    self.propIcon = self.UICommonGetCard["UICommonGetCard"]["propIcon"]
    self.propIcon:setVisible(true)
    self:updateShowView()
end

function PVReceiveDialog:updateShowView()
    if self.receiveId ~= nil then
        local quality = self.c_StoneTemplate:getStoneItemById(self.receiveId).quality
        local resId = self.c_StoneTemplate:getStoneItemById(self.receiveId).res
        local resIcon = self.c_ResourceTemplate:getResourceById(resId)
        setItemImage(self.propIcon, "res/icon/rune/" .. resIcon, quality)
    end
end

return PVReceiveDialog
