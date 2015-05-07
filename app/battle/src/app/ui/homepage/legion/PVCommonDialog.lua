
local PVCommonDialog = class("PVCommonDialog", BaseUIView)

function PVCommonDialog:ctor(id)
    PVCommonDialog.super.ctor(self, id)
end

function PVCommonDialog:onMVCEnter()
    self.UICommonDialogView = {}
    self:initTouchListener()

    self:loadCCBI("common/ui_common_dialog.ccbi", self.UICommonDialogView)
    self:initData()
    self:initView()
end

function PVCommonDialog:initData()
    self.detailStr = self.funcTable[1]
end

function PVCommonDialog:initView()
    self.titleLayer = self.UICommonDialogView["UICommonDialogView"]["titleLayer"]
    self.contentLayer = self.UICommonDialogView["UICommonDialogView"]["contentLayer"]
    self.detailLabel1 = self.UICommonDialogView["UICommonDialogView"]["detailLabel1"]

    self.detailLabel1:setString(self.detailStr)
end

function PVCommonDialog:initTouchListener()

    local function onRechargeClick()
        cclog("onRechargeClick")
        self:onHideView()
        --getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLegionPanel")
        getModule(MODULE_NAME_SHOP):showUIViewAndInTop("PVshopRecharge")
    end

    local function onCloseClick()
        self:onHideView(1)
    end

    local function onCancleClick()
        self:onHideView(1)
    end

    self.UICommonDialogView["UICommonDialogView"] = {}
    self.UICommonDialogView["UICommonDialogView"]["onRechageClick"] = onRechargeClick
    self.UICommonDialogView["UICommonDialogView"]["onCloseClick"] = onCloseClick
    self.UICommonDialogView["UICommonDialogView"]["onCancleClick"] = onCancleClick
end

return PVCommonDialog
