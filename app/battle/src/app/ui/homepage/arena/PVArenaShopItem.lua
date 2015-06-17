local PVArenaShopItem = class("PVArenaShopItem", function()
    return game.newNode()
end)

function PVArenaShopItem:ctor(data)
    print("PVArenaShopItem:ctor ======== ", data)
    self:initView(data)
    self.data_ = data
end

function PVArenaShopItem:getData()
    return self.data_
end


function PVArenaShopItem:initView(data)
    print("PVArenaShopItem:ctor ========")
    table.print(data)
    self.UIArenaShopItem = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("arena/ui_shop_item1.ccbi", proxy, self.UIArenaShopItem)
    self.headIcon = self.UIArenaShopItem["UIArenaShopItem"]["headIcon"]
    local equipName = self.UIArenaShopItem["UIArenaShopItem"]["equipName"]
    local money_value = self.UIArenaShopItem["UIArenaShopItem"]["money_value"]
    self.touchRect = self.UIArenaShopItem["UIArenaShopItem"]["touchRect"]
    local goodsGot = self.UIArenaShopItem["UIArenaShopItem"]["goodsGot"]
    local gainData = data.gain
    local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
    local gainValue = table.getValueByIndex(gainData, 1)
    setCommonDrop(gainKey, gainValue[3], self.headIcon, equipName)
    local consumeData = data.consume
    local useMoney = table.getValueByIndex(consumeData, 1)[1]
    money_value:setString(useMoney)
    if data.got then
        goodsGot:setVisible(true)
    else
        goodsGot:setVisible(false)
    end
    self:addChild(node)
    self:setContentSize(node:getContentSize())
    self.touchBox = node
end

function PVArenaShopItem:setSelected(selected)
    if selected then
        -- self.headIcon:setScale(1.2)
        self.headIcon:setOpacity(200)
    else
        -- self.headIcon:setScale(1)
        self.headIcon:setOpacity(255)
    end
end

function PVArenaShopItem:isTouched(x, y)
    local pos = self.touchBox:convertToNodeSpace(cc.p(x, y))
    return cc.rectContainsPoint(self.touchRect:getBoundingBox(), pos)
end

return PVArenaShopItem
