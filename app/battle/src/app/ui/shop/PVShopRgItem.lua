local PVShopRgItem = class("PVShopRgItem", function()
	return game.newNode()
end)

function PVShopRgItem:ctor(data)
    self.data_ = data
    table.print(self.data_)
	self.UIShopRechargeItem = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("shop/ui_rg_item.ccbi", proxy, self.UIShopRechargeItem)
    self.touchRect = self.UIShopRechargeItem["UIShopRechargeItem"]["itemTouchLayer"]
    self:addChild(node)
    self:setContentSize(node:getContentSize())
    self.touchBox = node
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self:initView()
end

function PVShopRgItem:getData()
    return self.data_
end

function PVShopRgItem:initView()
    self.itemNameLabel = self.UIShopRechargeItem["UIShopRechargeItem"]["itemNameLabel"]   --名字["name"]
    --self.itemIconImg = self.UIShopRechargeItem["UIShopRechargeItem"]["itemIconImg"]   --图标["res"]
    self.itemInfoLabel = self.UIShopRechargeItem["UIShopRechargeItem"]["itemInfoLabel"]   --描述["description"] = 0(月卡周卡有描述，普通元宝 描述= 0)
    self.itemPriceLabel = self.UIShopRechargeItem["UIShopRechargeItem"]["itemPriceLabel"]   --价格["currence"]

    local nameStr = self.c_LanguageTemplate:getLanguageById(self.data_["name"])
    self.itemNameLabel:setString(nameStr)

    --local icon = self.c_ResourceTemplate:getResourceById(self.data_["res"])
    --game.setSpriteFrame(self.itemIconImg,icon)

    local infoStr = nil
    if self.data_["description"] ~= 0 then
        infoStr = self.c_LanguageTemplate:getLanguageById(self.data_["description"])
    else
    	local setting = self.data_["setting"]
    	local item = setting["107"]
    	local valueinfo = item[1]
        infoStr = "价值"..valueinfo.."元宝"    --暂时占位，后续数值表中补充描述
    end
    self.itemInfoLabel:setString(infoStr)

    self.itemPriceLabel:setString(self.data_["currence"])         --单位应由数值表读出，目前没有     
end

function PVShopRgItem:isTouched(x, y)
    local pos = self.touchBox:convertToNodeSpace(cc.p(x, y))
    if cc.rectContainsPoint(self.touchRect:getBoundingBox(), pos) then
        return true
    else
    	return false
    end
end

return PVShopRgItem