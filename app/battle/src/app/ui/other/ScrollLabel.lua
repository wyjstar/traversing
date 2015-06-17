
local ScrollLabel = class("ScrollLabel", function ()
    return cc.Node:create()
end)

local ScrollLabelBase = import(".ScrollLabelBase")

function ScrollLabel:ctor(number)
    self.itemList = {}
    self.currentNum = number
    self.currentLen = 0
    self:init(number)
end

function ScrollLabel:init(number)
    local tempStr = tostring(number)
    local len = string.len(tempStr)
    self.currentLen = len
    print("number=====" .. number)
    local startPosX = -len/2 * 34
    for i = 1, len do
        local temp = tempStr
        local strItem = string.sub(temp, i, i)
        local ScrollLabelBase = ScrollLabelBase.new(tonumber(strItem))
        ScrollLabelBase:setPosition(startPosX + ( i - 1 ) * 34 , 0)
        -- ScrollLabelBase:setTag(i)
        self:addChild(ScrollLabelBase)

        -- print("xxxxxx======" .. startPosX + ( i - 1 ) * 34)
        self.itemList[#self.itemList + 1] = ScrollLabelBase
    end
end

function ScrollLabel:initPosition()
    -- local
end

function ScrollLabel:setNum(newNumber)
    local tempStr = tostring(newNumber)
    local len = string.len(tempStr)
    if self.currentLen ~= len then
    end

    for i = 1, len do
        -- local listItem = self.itemList[i]
        -- local temp = tempStr
        -- local strItem = string.sub(temp, i, i)
        -- listItem:setNum(tonumber(strItem))
    end
end



return ScrollLabel
