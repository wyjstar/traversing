
local CursorInputLayer = class("CursorInputLayer", function() return game.newNode() end)

function CursorInputLayer:ctor()
    self.editName = nil
    self.strFmt = nil
    self.inputEdit = nil
end


function CursorInputLayer:initEditBox(layerSize, word ,maxLeght)
    local editBoxSize = cc.size(layerSize.width - 20, 40)


    local function editBoxTextEventHandle(strEventName,pSender)
        self.inputEdit = pSender
        -- print(strEventName)
        if strEventName == "changed" then
            self.strFmt = string.format("%s",self.inputEdit:getText())
            strFmt = string.format("editBox %p TextChanged, text: %s ", pSender, pSender:getText())
            print(self.strFmt)
        elseif strEventName == "return" then
            self.strFmt = string.format("%s",self.inputEdit:getText())
        end
    end


    self.editName = cc.EditBox:create(editBoxSize, cc.Scale9Sprite:create())
    self.editName:setAnchorPoint(0.5,0.5)
    self.editName:setFont(const.FONT_NAME, 24)
    self.editName:setPlaceHolder(word)
    self.editName:setPlaceholderFontColor(cc.c3b(255,255,255))
    self.editName:setMaxLength(maxLeght)
    self.editName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE )
    --Handler
    self.editName:registerScriptEditBoxHandler(editBoxTextEventHandle)

    self:addChild(self.editName)
end

function CursorInputLayer:getInputText()
    if self.strFmt ~= nil then
        return self.strFmt
    else
        return nil
    end
end

function CursorInputLayer:cleanText()
    self.editName:setText("")
end

-- function CursorInputLayer:getEditBox()
--     if self.inputEdit ~= nil then
--         return self.inputEdit
--     else
--         return nil
--     end
-- end

return CursorInputLayer
