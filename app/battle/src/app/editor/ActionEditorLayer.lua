
local ActionEditorList = import(".ActionEditorList")
local ActionEditorView = import(".ActionEditorView")

local ActionEditorLayer = class("ActionEditorLayer", function()
    return game.newColorLayer(cc.c4b(100, 100, 100, 180))
end)

function ActionEditorLayer:ctor()
    self.curNo = nil
    self.curIdx = nil
    self.curKind = nil
    self.actionUtil = getActionUtil()
    self.actionUtil:init()
    self.actionEditorList = ActionEditorList.new({width = 100, height = 700})
    self.actionEditorList:setPosition(10, 100)
    self.actionEditorList:resetAllItems(self.actionUtil.data)
    self:addChild(self.actionEditorList, 20)

    self.actionEditorView = ActionEditorView.new({width = 490, height = 700})
    self.actionEditorView:setPosition(120, 100)
    self:addChild(self.actionEditorView, 10)

    self.editAdd = ui.newEditBox({size = {width = 94, height = 30}, image = "res/ui/c9b.png", listener = function(event, sender) end})
    self.editAdd:setPosition(60, 910)
    self:addChild(self.editAdd, 100)

    self.editCell = ui.newEditBox({size = {width = 54, height = 30}, image = "res/ui/c9b.png", listener = function(event, sender) end})
    self.editCell:setPosition(620, 850)
    self:addChild(self.editCell, 100)

    self.btnAdd = ui.newTTFLabelMenuItem({text = "添加", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickAdd() end})
    self.btnAdd:setPosition(80, 870)
    self.btnDel = ui.newTTFLabelMenuItem({text = "删除", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickDel() end})
    self.btnDel:setPosition(80, 830)
    self.btnSave = ui.newTTFLabelMenuItem({text = "保存", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickSave() end})
    self.btnSave:setPosition(170, 910)
    self.btnKCard = ui.newTTFLabelMenuItem({text = "卡牌", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickCard() end})
    self.btnKCard:setPosition(160, 850)
    self.btnKBoard = ui.newTTFLabelMenuItem({text = "底板", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickBoard() end})
    self.btnKBoard:setPosition(220, 850)
    self.btnKHero = ui.newTTFLabelMenuItem({text = "英雄", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickHero() end})
    self.btnKHero:setPosition(280, 850)
    self.btnKBullet1 = ui.newTTFLabelMenuItem({text = "弹道1", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickBullet1() end})
    self.btnKBullet1:setPosition(340, 850)
    self.btnKBullet2 = ui.newTTFLabelMenuItem({text = "弹道2", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickBullet2() end})
    self.btnKBullet2:setPosition(410, 850)
    self.btnKBullet3 = ui.newTTFLabelMenuItem({text = "弹道3", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
    listener = function() self:onChickBullet3() end})
    self.btnKBullet3:setPosition(490, 850)
    self.btnCellAdd = ui.newTTFLabelMenuItem({text = "增加", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickCellAdd() end})
    self.btnCellAdd:setPosition(550, 870)
    self.btnCellSub = ui.newTTFLabelMenuItem({text = "减少", color = ui.COLOR_GREEN, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, 
        listener = function() self:onChickCellSub() end})
    self.btnCellSub:setPosition(550, 830)
    
    
    self.menu = ui.newMenu({self.btnAdd, self.btnDel, self.btnSave, 
        self.btnKCard, self.btnKBoard, self.btnKHero, self.btnKBullet1, self.btnKBullet2,self.btnKBullet3, self.btnCellAdd, self.btnCellSub, })
    self:addChild(self.menu, 100)

    self.slider = cc.ControlSlider:create("res/ui/sliderTrack.png","res/ui/sliderProgress.png" ,"res/ui/sliderThumb.png")
    self.slider:setMinimumValue(-7300)
    self.slider:setMaximumValue(0)
    self.slider:setValue(-7300)
    self.slider:setPosition(620, 440)
    self.slider:setRotation(90)
    self.slider:setScale(2.5, 1)
    self.slider:registerControlEventHandler(function(pSender) self.actionEditorView:setContentOffset({x = 0, y = pSender:getValue()}) end, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)

    self:addChild(self.slider, 100)
end

function ActionEditorLayer:onChickList(no, idx)
    cclog("chick list %s %s", no, idx)

    if self.actionEditorList.items[self.curIdx] then self.actionEditorList.items[self.curIdx]:getLabel():setColor(ui.COLOR_WHITE) end

    self.curNo = no
    self.curIdx = idx

    self.actionEditorList.items[self.curIdx]:getLabel():setColor(ui.COLOR_RED)
    self.editAdd:setText(string.format("%s", self.curNo))

    self:onChickCard()
end

function ActionEditorLayer:onChickAdd()
    cclog("chick add")

    local newno = string.lower(self.editAdd:getText())
    if not newno or newno == "" or self.actionUtil.data[newno] then return end

    self.actionUtil.data[newno] = {card = {}, board = {}, hero = {}, bullet1 = {}, bullet2 = {}, bullet3 = {}}

    self.actionEditorList:addItem(newno)
end

function ActionEditorLayer:onChickDel()
    cclog("chick del")

    local newno = string.lower(self.editAdd:getText())
    if not newno or newno == "" or not self.actionUtil.data[newno] then return end

    self.actionUtil.data[newno] = nil

    self.curNo = nil
    self.curKind = nil

    self.btnKCard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBoard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKHero:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet1:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet2:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet3:getLabel():setColor(ui.COLOR_GREEN)
    self.actionEditorList:resetAllItems(self.actionUtil.data)
    self.actionEditorView:resetAllCells({})
end

function ActionEditorLayer:onChickSave()
    cclog("chick save")

    self:updateData()
    
    self.actionUtil:save()
end

function ActionEditorLayer:onChickCard()
    cclog("chick card")

    if not self.actionUtil.data[self.curNo] then return end

    self.curKind = "card"

    self.actionEditorView:resetAllCells(self.actionUtil.data[self.curNo].card)

    self.btnKCard:getLabel():setColor(ui.COLOR_RED)
    self.btnKBoard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKHero:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet1:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet2:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet3:getLabel():setColor(ui.COLOR_GREEN)
end

function ActionEditorLayer:onChickBoard()
    cclog("chick board")

    if not self.actionUtil.data[self.curNo] then return end

    self.curKind = "board"

    self.actionEditorView:resetAllCells(self.actionUtil.data[self.curNo].board)

    self.btnKCard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBoard:getLabel():setColor(ui.COLOR_RED)
    self.btnKHero:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet1:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet2:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet3:getLabel():setColor(ui.COLOR_GREEN)
end

function ActionEditorLayer:onChickHero()
    cclog("chick hero")

    if not self.actionUtil.data[self.curNo] then return end

    self.curKind = "hero"

    self.actionEditorView:resetAllCells(self.actionUtil.data[self.curNo].hero)

    self.btnKCard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBoard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKHero:getLabel():setColor(ui.COLOR_RED)
    self.btnKBullet1:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet2:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet3:getLabel():setColor(ui.COLOR_GREEN)
end

function ActionEditorLayer:onChickBullet1()
    cclog("chick bullet1")

    if not self.actionUtil.data[self.curNo] then return end

    self.curKind = "bullet1"

    self.actionEditorView:resetAllCells(self.actionUtil.data[self.curNo].bullet1)

    self.btnKCard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBoard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKHero:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet1:getLabel():setColor(ui.COLOR_RED)
    self.btnKBullet2:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet3:getLabel():setColor(ui.COLOR_GREEN)
end

function ActionEditorLayer:onChickBullet2()
    cclog("chick bullet2")

    if not self.actionUtil.data[self.curNo] then return end

    self.curKind = "bullet2"

    self.actionEditorView:resetAllCells(self.actionUtil.data[self.curNo].bullet2)

    self.btnKCard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBoard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKHero:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet1:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet2:getLabel():setColor(ui.COLOR_RED)
    self.btnKBullet3:getLabel():setColor(ui.COLOR_GREEN)
end

--弹道3点击事件
function ActionEditorLayer:onChickBullet3()
    cclog("chick bullet3")

    if not self.actionUtil.data[self.curNo] then return end

    self.curKind = "bullet3"

    self.actionEditorView:resetAllCells(self.actionUtil.data[self.curNo].bullet3)

    self.btnKCard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBoard:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKHero:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet1:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet2:getLabel():setColor(ui.COLOR_GREEN)
    self.btnKBullet3:getLabel():setColor(ui.COLOR_RED)
end

function ActionEditorLayer:onChickCellAdd()
    cclog("chick cell add")

    if not self.curKind then return end
    if not self.actionUtil.data[self.curNo] then return end

    local data = self.actionUtil.data[self.curNo][self.curKind]
    local idx = tonumber(self.editCell:getText())

    if not idx or idx < 1 or idx > #data then
        data[#data + 1] = {dur = 0.0, }
    else
        for i = #data + 1, idx, -1 do
            data[i + 1] = data[i]
        end
        data[idx] = {dur = 0.0, }
    end

    self.actionEditorView:resetAllCells(data)
end
    
function ActionEditorLayer:onChickCellSub()
    cclog("chick cell sub")

    if not self.curKind then return end
    if not self.actionUtil.data[self.curNo] then return end

    local data = self.actionUtil.data[self.curNo][self.curKind]
    local idx = tonumber(self.editCell:getText())

    if not idx or idx < 1 or idx > #data then
        data[#data] = nil
    else
        for i = idx, #data - 1, 1 do
            data[i] = data[i + 1]
        end
        data[#data] = nil
    end

    self.actionEditorView:resetAllCells(data)
end

function ActionEditorLayer:updateData()
    if not self.curNo then return end
    if not self.curKind then return end

    self.actionUtil.data[self.curNo][self.curKind] = self.actionEditorView:resolveToData()
end

return ActionEditorLayer
