local PVBagItem = class("PVBagItem", function()
    return game.newNode()
end)

function PVBagItem:ctor(data, clickCallBack)
    self:initView(data)
    self.data_ = data
    self.callback_ = clickCallBack
end

function PVBagItem:getData()
    return self.data_
end

function PVBagItem:initView(data)
    self.UIBagItem = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("bag/ui_bag_item.ccbi", proxy, self.UIBagItem)

    self.propIcon = self.UIBagItem["UIBagItem"]["propIcon"]
    local itemName = self.UIBagItem["UIBagItem"]["itemName"]
    local itemNumber = self.UIBagItem["UIBagItem"]["itemNumber"]
    self.touchRect = self.UIBagItem["UIBagItem"]["touchRect"]

    local name_chinese = getTemplateManager():getLanguageTemplate():getLanguageById(data.item.name)
    local cur_quality = getIconByQuality(data.item.quality)
    local res = getTemplateManager():getResourceTemplate():getResourceById(data.item.res)
    local itemNum = data.itemNum

    itemName:setString(name_chinese)
    itemName:enableOutline(ui.COLOR_BLACK, 3)
    itemNumber:setString(itemNum)
    itemNumber:enableOutline(ui.COLOR_BLACK, 3)

    setItemImageNew(self.propIcon, res, cur_quality)

    self:addChild(node)
    self:setContentSize(node:getContentSize())
    self.touchBox = node
end

function PVBagItem:setSelected(selected)
    if selected then
        self.propIcon:setScale(1.2)
        self.propIcon:setOpacity(255)
    else
        self.propIcon:setScale(1)
        self.propIcon:setOpacity(200)
    end
end

function PVBagItem:isTouched(x, y)
    local pos = self.touchBox:convertToNodeSpace(cc.p(x, y))
    return cc.rectContainsPoint(self.touchRect:getBoundingBox(), pos)
end

return PVBagItem
