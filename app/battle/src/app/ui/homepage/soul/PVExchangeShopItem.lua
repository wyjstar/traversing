local PVExchangeShopItem = class("PVExchangeShopItem", function()
    return game.newNode()
end)

function PVExchangeShopItem:ctor(data, _type)
    print("PVArenaShopItem:ctor ======== ", data)
    self.type = _type                 --1:武魂商店    2:精华商店
    self:initView(data)
    self.data_ = data
end

function PVExchangeShopItem:getData()
    return self.data_
end


function PVExchangeShopItem:initView(data)
    print("PVArenaShopItem:ctor ========")
    table.print(data)
    self.UIArenaShopItem = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("arena/ui_shop_item1.ccbi", proxy, self.UIArenaShopItem)
    local headIcon = self.UIArenaShopItem["UIArenaShopItem"]["headIcon"]
    local equipName = self.UIArenaShopItem["UIArenaShopItem"]["equipName"]
    local money_value = self.UIArenaShopItem["UIArenaShopItem"]["money_value"]
    local consumeType = self.UIArenaShopItem["UIArenaShopItem"]["consum_type"]
    local goodsGot = self.UIArenaShopItem["UIArenaShopItem"]["goodsGot"]
    self.touchRect = self.UIArenaShopItem["UIArenaShopItem"]["touchRect"]
    local gainData = data.gain
    local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
    local gainValue = table.getValueByIndex(gainData, 1)
    setCommonDrop(gainKey, gainValue[3], headIcon, equipName)
    local consumeData = data.consume
    local useMoney = table.getValueByIndex(consumeData, 1)[1]
    money_value:setString(useMoney)
    self:addChild(node)
    self:setContentSize(node:getContentSize())
    self.touchBox = node

    if self.type ~= nil and self.type == 1 then
        game.setSpriteFrame(consumeType, "#ui_common_shitou_g.png")
    elseif self.type ~= nil and self.type == 2 then
        game.setSpriteFrame(consumeType, "#ui_rongLian.png")
    end 
    if data.got then goodsGot:setVisible(true) 
    else goodsGot:setVisible(false) end
end

function PVExchangeShopItem:isTouched(x, y)
    local pos = self.touchBox:convertToNodeSpace(cc.p(x, y))
    return cc.rectContainsPoint(self.touchRect:getBoundingBox(), pos)
end

return PVExchangeShopItem
