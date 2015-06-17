--商城
local PVShopPage = import("...ui.shop.PVShopPage2")
local PVChargePage = import("...ui.shop.PVShopRecharge")
local PVVIPPage = import("...ui.shop.PVShopRechargeVip")
local PVRCBUYPage = import("...ui.shop.PVShopRecruitBuy")
local PVRCBUYGODPage = import("...ui.shop.PVShopRecruitBuyGod")
local PVRCSHOWPage = import("...ui.shop.PVShopShowCards")
local PVRChest1Page = import("...ui.shop.PVShopChestNum")
local PVRPropNumPage = import("...ui.shop.PVShopPropNum")
local PVShopEquBuySuccess = import("...ui.shop.PVShopEquBuySuccess")
local PVShopHeroPreview = import("...ui.shop.PVShopHeroPreview")


local ShopModule = class("ShopModule", BaseModuleView)

function ShopModule:ctor()
    self.super.ctor(self)
    self.moduleName = self.__cname
    self:pushModule(PVShopPage)
    self:pushModule(PVChargePage)  --充值模块加入
    self:pushModule(PVVIPPage)     --vip特权模块加入
    self:pushModule(PVRCBUYPage)     --良将招募弹出框
    self:pushModule(PVRCBUYGODPage)     --神将招募弹出框
    self:pushModule(PVRCSHOWPage)     --获得将卡牌展示页
    self:pushModule(PVRChest1Page)     --抽取宝箱界面
    self:pushModule(PVRPropNumPage)    --输入购买道具的数量界面
    self:pushModule(PVShopEquBuySuccess)    --装备全部购买列表界面
    self:pushModule(PVShopHeroPreview)
end


return ShopModule

