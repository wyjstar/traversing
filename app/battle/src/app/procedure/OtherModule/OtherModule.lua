--其他页面小提示，dialog
local PVPopTips = import("...ui.other.PVPopTips")
local PVFunctionNotOpen = import("...ui.other.PVFounctionNotOpen")
local LabelCommon = import("...ui.other.LabelCommon")
local Toast = import("...ui.other.Toast")
local PVNetLoading = import("...ui.other.PVNetLoading")
local PVConfirmDialog = import("...ui.other.PVConfirmDialog")
local PVAlertDialog = import("...ui.other.PVAlertDialog")
local NewbieGuide = import("...ui.other.NewbieGuide")
local PVGetPath = import("...ui.homepage.equipment.PVChipGetDetail")
local PVUseItemTips = import("...ui.bag.PVUseItemTips")
local PVSystemTips = import("...ui.homepage.common.SystemTips")
local PVChatCheck = import("...ui.homepage.chat.PVChatCheck")
local PVLegionExit = import("...ui.homepage.legion.PVLegionExit")
local PVLegionCreate = import("...ui.homepage.legion.PVLegionCreate")
local PVLegionAnnouncement = import("...ui.homepage.legion.PVLegionAnnouncement")   --编辑公告
local PVEquipmentSmelting = import("...ui.homepage.equipment.PVEquipmentSmelting")
local PVPromoteForce = import("...ui.homepage.soldier.PVPromoteForce")              --武将觉醒  提升战力
local PVTravelCongratulations = import("...ui.homepage.travel.PVTravelCongratulations")
local PVTravelChooseBuyNum = import("...ui.homepage.travel.PVTravelChooseBuyNum")
local PVTravelChooseAutoTime = import("...ui.homepage.travel.PVTravelChooseAutoTime")
local PVEmailDetail = import("...ui.email.PVEmailDetail")     --私信详细信息
local PVTravelPropItem = import("...ui.homepage.travel.PVTravelPropItem")
-- local PVTravelTraveling = import("...ui.homepage.travel.PVTravelTraveling")
local PVTravelMeet = import("...ui.homepage.travel.PVTravelMeet")
local PVTravelFengwuzhiShow = import("...ui.homepage.travel.PVTravelFengwuzhiShow")
local PVFriendSecondMenu = import("...ui.homepage.friend.PVFriendSecondMenu")   --点击好友头像后的菜单界面
local PVFriendPrivateChat = import("...ui.homepage.friend.PVFriendPrivateChat")   --好友私聊界面
local PVFriendPop = import("...ui.homepage.friend.PVFriendPop")                 --弹出消息

local PVBuyStamina = import("...ui.homepage.activity.PVBuyStamina")                  --购买提示界面

local PVRuneCheck = import("...ui.homepage.rune.PVRuneCheck")                   --符文查看摘除
local PVRuneLook = import("...ui.homepage.rune.PVRuneLook")                   --符文查看摘除
local PVRuneDetail = import("...ui.homepage.rune.PVRuneDetail")                 --符文详情界面

local PVReceiveDialog = import("...ui.homepage.rune.PVReceiveDialog")               --恭喜获得

local PVCongratulationsGainDialog = import("...ui.homepage.common.PVCongratulationsGainDialog")  --恭喜获得列表界面

local PVInheritLTList = import("...ui.homepage.inherit.PVInheritLTList")        --传承武将列表


local DialogGetCard = import("...ui.homepage.common.DialogGetCard")
local DialogGetCardUpdate = import("...ui.homepage.common.DialogGetCardUpdate")

local PVShopBuyByNum = import("...ui.homepage.shop.PVShopBuyByNum")

local ImproveAbility = import("...ui.other.ImproveAbility")

local PVHeadChange = import("...ui.homepage.head.PVHeadChange")
local PVHeadSet = import("...ui.homepage.head.PVHeadSet")

local PVCommonDetail = import("...ui.homepage.common.PVCommonDetail")               --道具详细界面
local PVCommonChipDetail = import("...ui.homepage.common.PVCommonChipDetail")       --碎片说明

local PVExchangeDialog = import("...ui.homepage.soul.PVExchangeDialog")          --兑换结果

local PVLegionWorship = import("...ui.homepage.legion.PVLegionWorship")          --军团膜拜

--创建战队名称
local PVCreateTeam = import("...platform.PVCreateTeam")

local PVBoundTourist = import("...platform.PVBoundTourist")

local PVStarAwardShow = import("...ui.homepage.instance.PVStarAwardShow")

local PVCommonDialog = import("...ui.homepage.legion.PVCommonDialog")

local OtherModule = class("OtherModule")

-- 阵容按钮弹框
local PVLineUpCheck = import("...ui.lineup.PVLineUpCheck")

_PVNetLoading = nil

function OtherModule:ctor()
   -- self.super.ctor(self)
   -- self._PVNetLoading = nil
   self._Toast = nil
   self._PVConfirmDialog = nil
   self._PVAlertDialog = nil

    self.uiTable = {}

    table.insert(self.uiTable, PVFunctionNotOpen)
    table.insert(self.uiTable, Toast)
    table.insert(self.uiTable, NewbieGuide)
    table.insert(self.uiTable, PVGetPath)
    table.insert(self.uiTable, PVUseItemTips)
    table.insert(self.uiTable, PVSystemTips)
    table.insert(self.uiTable, PVChatCheck)
    table.insert(self.uiTable, PVLegionExit)
    table.insert(self.uiTable, PVLegionCreate)
    table.insert(self.uiTable, PVLegionAnnouncement)
    table.insert(self.uiTable, PVEquipmentSmelting)
    table.insert(self.uiTable, PVPromoteForce)

    table.insert(self.uiTable, PVTravelCongratulations)
    table.insert(self.uiTable, PVTravelChooseBuyNum)
    table.insert(self.uiTable, PVTravelChooseAutoTime)
    table.insert(self.uiTable, PVEmailDetail)
    table.insert(self.uiTable, PVTravelPropItem)
    -- table.insert(self.uiTable, PVTravelTraveling)
    table.insert(self.uiTable, PVTravelMeet)
    table.insert(self.uiTable, PVFriendSecondMenu)
    table.insert(self.uiTable, PVFriendPrivateChat)
    table.insert(self.uiTable, PVFriendPop)

    table.insert(self.uiTable, PVTravelFengwuzhiShow)

    table.insert(self.uiTable, PVRuneCheck)
    table.insert(self.uiTable, PVRuneLook)
    table.insert(self.uiTable, PVRuneDetail)

    table.insert(self.uiTable, PVBuyStamina)

    -- table.insert(self.uiTable, PVInheritLTList)
    -- table.insert(self.uiTable, PVInheritZBList)

    table.insert(self.uiTable, PVReceiveDialog)

    table.insert(self.uiTable, DialogGetCard)
    table.insert(self.uiTable, DialogGetCardUpdate)

    table.insert(self.uiTable, PVShopBuyByNum)

    table.insert(self.uiTable, PVCongratulationsGainDialog)

    table.insert(self.uiTable, PVInheritLTList)
    table.insert(self.uiTable, ImproveAbility)

    table.insert(self.uiTable, PVHeadChange)
    table.insert(self.uiTable, PVHeadSet)

    table.insert(self.uiTable, PVCommonDetail)

    table.insert(self.uiTable, PVCommonChipDetail)

   table.insert(self.uiTable, PVExchangeDialog)

   table.insert(self.uiTable, PVLegionWorship)

   table.insert(self.uiTable, PVStarAwardShow)

   table.insert(self.uiTable, PVBoundTourist)

   table.insert(self.uiTable, PVCreateTeam)

   table.insert(self.uiTable, PVCommonDialog)
   table.insert(self.uiTable, PVLineUpCheck)
end

function OtherModule:showOtherView(_name, ...)
    print("showOtherView:" .. _name)
    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initBaseUI()
            view:initFunc( {...} )
            view:onMVCEnter()
            getPlayerScene():addOtherView(view)
            return
        end
    end
end

--
function OtherModule:showInOtherView(_name, ...)
    print("showInOtherView:" .. _name)
    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initFunc( {...} )
            view:onMVCEnter()
            getPlayerScene():showInOtherView(view)
            return
        end
    end
end

function OtherModule:showOtherViewInRunningScene(_name, ...)
    print("showOtherViewInRunningScene:" .. _name)
    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initFunc( {...} )
            view:onMVCEnter()
            cc.Director:getInstance():getRunningScene():addChild(view, 999991)
            -- getPlayerScene():showInOtherView(view)
            return
        end
    end
end

function OtherModule:showOtherViewByRoot(_name, ...)
    print("showOtherViewByRoot:" .. _name)
    for k, v in pairs(self.uiTable) do
        if v.__cname == _name then
            local view = v.new(v.__cname)
            view:initBaseUI()
            view:initFunc( {...} )
            view:onMVCEnter()
            -- getPlayerScene():addOtherView(view)
            return
        end
    end
end

function OtherModule:showToastView(...)
    -- if self._Toast ~= nil then
    --     self._Toast:removeFromParent()
    --     self._Toast = nil
    -- end
    self._Toast = Toast.new("Toast")
    self._Toast:initFunc( {...} )
    self._Toast:onMVCEnter()
    cc.Director:getInstance():getRunningScene():addChild(self._Toast, 999991)
end

function OtherModule:showCombatPowerUpView(...)
    self._improveAbility = ImproveAbility.new("ImproveAbility")
    self._improveAbility:initFunc( {...} )
    self._improveAbility:onMVCEnter()
    cc.Director:getInstance():getRunningScene():addChild(self._improveAbility, 999991, 9999998)
end

function OtherModule:showNetLoading()
    print("OtherModule:showNetLoading")
    if _PVNetLoading ~= nil then

        return
        -- self._PVNetLoading:removeLoading()
        -- self._PVNetLoading = nil
    end
    -- print("OtherModule:showNetLoading2222222222")
    _PVNetLoading = PVNetLoading.new("PVNetLoading")
    _PVNetLoading:onMVCEnter()
    game.getRunningScene():addChild(_PVNetLoading, 99999)
    -- getPlayerScene():addOtherView(self._PVNetLoading)
end

function OtherModule:removeNetLoading()
    local _callfunc = function ()
        _PVNetLoading = nil
    end

    if _PVNetLoading ~= nil and _PVNetLoading.removeLoading then
        _PVNetLoading:removeLoading(_callfunc)
        _PVNetLoading = nil
    else
        _PVNetLoading = nil
    end
end

-- 确认，取消对话框
function OtherModule:showConfirmDialog(sureCallfunc, cancelCallfunc, text)
    if self._PVConfirmDialog then
        return
    end
    local _callfunc = function()
        self._PVConfirmDialog = nil
        getPlayerScene():setKeyEnabled(true)
    end
    getPlayerScene():setKeyEnabled(false)
    self._PVConfirmDialog = PVConfirmDialog.new("PVConfirmDialog")
    self._PVConfirmDialog:initParams(sureCallfunc, cancelCallfunc, text, _callfunc)
    self._PVConfirmDialog:onMVCEnter()
    cc.Director:getInstance():getRunningScene():addChild(self._PVConfirmDialog, 99999)
end

-- alert 对话框
function OtherModule:showAlertDialog(sureCallfunc, text, zOrder)
    if self._PVAlertDialog then
        return
    end
    local _callfunc = function()

        -- stepCallBack(G_GUIDE_50114)
        -- stepCallBack(G_GUIDE_50118)
        -- stepCallBack(G_GUIDE_50122)

        groupCallBack(GuideGroupKey.BTN_FUWEN_CONFIRM_IN_TIP)

        self._PVAlertDialog = nil
        getPlayerScene():setKeyEnabled(true)
    end
    getPlayerScene():setKeyEnabled(false)

    self._PVAlertDialog = PVAlertDialog.new("PVAlertDialog")
    self._PVAlertDialog:initParams(sureCallfunc, text, _callfunc)
    self._PVAlertDialog:onMVCEnter()
    if zOrder then
        cc.Director:getInstance():getRunningScene():addChild(self._PVAlertDialog, zOrder)
    else
        cc.Director:getInstance():getRunningScene():addChild(self._PVAlertDialog, 99999)
    end

end

function OtherModule:clear()
    self._PVAlertDialog = nil
    self._PVConfirmDialog = nil
    _PVNetLoading = nil
    self._Toast = nil
end

return OtherModule

