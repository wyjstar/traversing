local PVRuneItem = class("PVRuneItem", function()
	return game.newNode()
end)

function PVRuneItem:ctor(data)
    self.data_ = data
    if self.data_.enabled ~= nil then
        self.isBag = true
    end
	self.UIRuneItem = {}
    local node = nil
    if self.isBag then
        node = game.newCCBNode("rune/ui_rune_item2.ccbi", self.UIRuneItem)
    else
        node = game.newCCBNode("rune/ui_rune_item.ccbi", self.UIRuneItem)
        self.checked = self.UIRuneItem["UIRuneItem"]["selected"]
        self.checkRect = self.UIRuneItem["UIRuneItem"]["touchRect2"]
        self.checked:setVisible(self.data_.selected)
    end
    self.touchRect = self.UIRuneItem["UIRuneItem"]["touchRect"]
    self:addChild(node)
    self:setContentSize(node:getContentSize())
    game.setSpriteFrame(self.touchRect, getQualityBgImg(self.data_.quality))
    self.touchBox = node
    self:initView()
end

function PVRuneItem:getData()
    return self.data_
end

function PVRuneItem:initView()
    self.icon = self.UIRuneItem["UIRuneItem"]["rune_icon"]
    self.numLayer = self.UIRuneItem["UIRuneItem"]["numLayer"]
    if self.numLayer ~= nil then
        self.numLayer:setVisible(false)
    end
    if not self.isBag then
        -- self.UIRuneItem["UIRuneItem"]["rune_num"]:setString(self.data_.rune_num)
        self.UIRuneItem["UIRuneItem"]["yinding_num"]:setString(self.data_.stone1)
        self.UIRuneItem["UIRuneItem"]["yuanbao_num"]:setString(self.data_.stone2)
    end
    self.icon:setOpacity(200)
    self.UIRuneItem["UIRuneItem"]["rune_name"]:setString(self.data_.rune_name)
    game.setSpriteFrame(self.icon, "res/icon/rune/"..self.data_.rune_icon)
end
--点击选择框
function PVRuneItem:isClickCheck()
    return self.isClickCheck_
end
--点击石头
function PVRuneItem:isClickStone()
    return self.isClickStone_
end

function PVRuneItem:isChecked()
    return self.checked:isVisible()
end

function PVRuneItem:clickCheck()
    local ischecked = (not self.checked:isVisible() or false)
    self.checked:setVisible(ischecked)
    self.data_.selected = ischecked
    self:setSelected(ischecked)
end

function PVRuneItem:setSelected(selected)
    if selected then
        self.icon:setScale(1.2)
        self.icon:setOpacity(255)
    else
        self.icon:setScale(1)
        self.icon:setOpacity(200)
    end
end

function PVRuneItem:isEqual(item)
    return self.data_.runt_no == item:getData().runt_no
end

function PVRuneItem:isTouched(x, y)
    local pos = self.touchBox:convertToNodeSpace(cc.p(x, y))
    self.isClickCheck_ = false
    self.isClickStone_ = false

    if not self.isBag and cc.rectContainsPoint(self.checkRect:getBoundingBox(), pos) then
        self.isClickCheck_ = true
        return true
    elseif cc.rectContainsPoint(self.touchRect:getBoundingBox(), pos) then
        self.isClickStone_ = true
        return true
    end

    return false
end

return PVRuneItem
