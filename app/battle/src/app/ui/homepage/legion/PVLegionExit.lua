
local PVLegionExit = class("PVLegionExit", BaseUIView)

function PVLegionExit:ctor(id)
    PVLegionExit.super.ctor(self, id)
end

function PVLegionExit:onMVCEnter()
    self.legionNet = getNetManager():getLegionNet()
    self.legionData = getDataManager():getLegionData()
    self:registerDataBack()

    self:initView()
end

function PVLegionExit:registerDataBack()
    --退出军团
    local function getExitBack(id, data)
        if data.result then
            getDataManager():getCommonData().updateCombatPower()
            self:onHideView()
            showModuleView(MODULE_NAME_HOMEPAGE)
        end
    end
    self:registerMsg(EXIT_LEGION, getExitBack)
end

function PVLegionExit:initView()
    self.UILegionExitView = {}
    self:initTouchListener()

    self:loadCCBI("legion/ui_legion_exit.ccbi", self.UILegionExitView)

    self.titleLayer = self.UILegionExitView["UILegionExitView"]["titleLayer"]
    self.contentLayer = self.UILegionExitView["UILegionExitView"]["contentLayer"]
end

function PVLegionExit:initTouchListener()
    --继续退出
    local function onContinueExitClick()
        cclog("onContinueExitClick")
        getAudioManager():playEffectButton2()
        self.legionNet:sendExitLegion()
    end

    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --取消退出
    local function onCancleClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    self.UILegionExitView["UILegionExitView"] = {}
    self.UILegionExitView["UILegionExitView"]["onContinueExitClick"] = onContinueExitClick
    self.UILegionExitView["UILegionExitView"]["onCloseClick"] = onCloseClick
    self.UILegionExitView["UILegionExitView"]["onCancleClick"] = onCancleClick
end

function PVLegionExit:showExitDialogView()
    self:setVisible(true)
end

function PVLegionExit:hideExitDialogView()
    self:setVisible(false)
end

return PVLegionExit
