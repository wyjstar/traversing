
-- local CursorInputLayer = import("...input.CursorInputLayer")
import("....datacenter.template.wordcheck.trie_tree")

local PVChatPanel = class("PVChatPanel", BaseUIView)

function PVChatPanel:ctor(id)
    PVChatPanel.super.ctor(self, id)
    self.worldChatItems = {}                --世界聊天列表
    self.legionChatItems = {}               --军团聊天列表
    self.endTime = 0
end

function PVChatPanel:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_chat.plist")

    self.chatData = getDataManager():getChatData()
    self.chatNet = getNetManager():getChatNet()
    self.commonData = getDataManager():getCommonData()
    self:registerDataBack()

    self:initData()
    self:initView()
end

function PVChatPanel:registerDataBack()
    --发送消息返回
    local function getSendBack()
        local data = self.chatData:getData()
        local result = data.result
        if result then
            if self.type == 1 then
                self.endTime = self.commonData:getTime()
            end
            self.inputEditbox:setText("")
        else
            self.inputEditbox:setText("")
        end

        self.tableView:reloadData()
        --聊天记录新的显示在下方
       -- local _count = 0
       --  if self.chatItem.channel == 1 then
       --      _count = self.worldItemCount
       --  elseif self.chatItem.channel == 2 then
       --      _count =  self.legionItemCount
       --  end

       --  local _offSet = self.tableView:getContentOffset()
       --  _offSet.y = self.tableView:getViewSize().height - _count*self.itemHeight

       --  if _offSet.y <0 then
       --      self.tableView:setContentOffset(cc.p(_offSet.x, 0))
       --  else
       --      self.tableView:setContentOffset(cc.p(_offSet.x, (_offSet.y)))
       --  end

    end
    self:registerMsg(CHAT_SEND, getSendBack)

    --系统推送消息列表
    local function getWordListBack()
        -- self.inputEditbox:setText("")
        self.chatItem = self.chatData:getWordsData()
        if self.chatItem.channel == 1 then
            self.worldChatItems = self.chatData:getChatWords(1)
            self.worldItemCount = table.nums(self.worldChatItems)
        elseif self.chatItem.channel == 2 then
            self.legionChatItems = self.chatData:getChatWords(2)
            self.legionItemCount = table.nums(self.legionChatItems)
        end

        self.tableView:reloadData()
        --聊天记录新的显示在下方
        -- local _count = 0
        -- if self.chatItem.channel == 1 then
        --     _count = self.worldItemCount
        -- elseif self.chatItem.channel == 2 then
        --     _count =  self.legionItemCount
        -- end

        -- local _offSet = self.tableView:getContentOffset()
        -- _offSet.y = self.tableView:getViewSize().height - _count*self.itemHeight


        -- print("----_offSet.y====")


        -- if _offSet.y <0 then
        --     self.tableView:setContentOffset(cc.p(_offSet.x, 0))
        -- else
        --     self.tableView:setContentOffset(cc.p(_offSet.x, (_offSet.y)))
        -- end

    end
    self:registerMsg(CHAT_SYSTEM, getWordListBack)
end

function PVChatPanel:initData()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    self.legionData = getDataManager():getLegionData()

    self.openLevel = self.c_BaseTemplate:getChatOpenLevel()
    self.interval = self.c_BaseTemplate:getChatInterval()
    self.playerLevel = self.commonData:getLevel()

    self.vip = self.commonData:getVip()

    self.chatItem = {}

    self.type = 1

    self.UIChatItem = {}
    self.UIChatItem["UIChatItem"] = {}

    local proxy = cc.CCBProxy:create()
    local chat = CCBReaderLoad("chat/ui_chat_item.ccbi", proxy, self.UIChatItem)

    local chatItemNode = self.UIChatItem["UIChatItem"]["chatItemNode"]

    local layerSize = chatItemNode:getContentSize()
    self.itemWidth = layerSize.width
    self.itemHeight = layerSize.height

    --世界聊天缓存
    self.curWorldChatItems = self.chatData:getChatWords(1)
    if table.getn(self.curWorldChatItems) > 30 or self.curWorldChatItems == nil then
        local preCount = table.getn(self.curWorldChatItems)
        local removeCount = preCount - 30
        for i=1, removeCount do
            table.remove(self.curWorldChatItems, i)
        end
        self.worldChatItems = self.curWorldChatItems
        self.worldItemCount = table.getn(self.worldChatItems)
    else
        self.worldChatItems = self.curWorldChatItems
        if self.type == 1 then
            self.worldItemCount = table.getn(self.worldChatItems)
        end
    end
    --军团聊天缓存
    self.curLegionChatItems = self.chatData:getChatWords(2)
    if table.getn(self.curLegionChatItems) > 30 or self.curLegionChatItems == nil then
        local preCount = table.getn(self.curLegionChatItems)
        local removeCount = preCount - 30
        for i=1, removeCount do
            table.remove(self.curLegionChatItems, i)
        end
        self.legionChatItems = self.curLegionChatItems
        self.legionItemCount = table.getn(self.legionChatItems)
    else
        self.legionChatItems = self.curLegionChatItems
        if self.type == 2 then
            self.legionItemCount = table.getn(self.legionChatItems)
        end
    end
end

function PVChatPanel:initView()
    self.UIChatView = {}
    self:initTouchListener()
    self:loadCCBI("chat/ui_chat_panel.ccbi", self.UIChatView)

    self.contentLayer = self.UIChatView["UIChatView"]["contentLayer"]
    self.worldMenu = self.UIChatView["UIChatView"]["worldMenu"]
    self.legionMenu = self.UIChatView["UIChatView"]["legionMenu"]
    self.worldMenuItem = self.UIChatView["UIChatView"]["worldMenuItem"]
    self.legionMenuItem = self.UIChatView["UIChatView"]["legionMenuItem"]
    self.animationManager = self.UIChatView["UIChatView"]["mAnimationManager"]

    self.worldNor = self.UIChatView["UIChatView"]["worldNor"]
    self.worldSelect = self.UIChatView["UIChatView"]["worldSelect"]

    self.legionNor = self.UIChatView["UIChatView"]["legionNor"]
    self.legionSelect = self.UIChatView["UIChatView"]["legionSelect"]

    self.inputLayer = self.UIChatView["UIChatView"]["inputLayer"]
    self.inputEdit = self.UIChatView["UIChatView"]["inputEdit"]
    self.contentLabel = self.UIChatView["UIChatView"]["contentLabel"]
    self.mainNode = self.UIChatView["UIChatView"]["mainNode"]

    self.worldMenuItem:setAllowScale(false)
    self.legionMenuItem:setAllowScale(false)

    self.worldMenuItem:setEnabled(false)

    self.worldNor:setVisible(false)
    self.worldSelect:setVisible(true)
    self.legionNor:setVisible(true)
    self.legionSelect:setVisible(false)

    -- self.shieldlayer:setTouchEnabled(true)

    if self.inputEditbox ~= nil then
        self.inputEditbox:removeFromParent(true)
    end

    self.inputEditbox = ui.newEditBox({
        image = cc.Scale9Sprite:create(),
        size = cc.size(self.inputEdit:getContentSize().width - 30, self.inputEdit:getContentSize().height),
        x = self.contentLabel:getPositionX(),
        y = self.contentLabel:getPositionY(),
        listener = function(strEventName,pSender)
            -- self:editBoxTextEventHandle(strEventName,pSender)
        end
        })

    -- self.editboxUser:setFontColor(cc.c3b(255,0,0))
    self.inputEditbox:setFont(MINI_BLACK_FONT_NAME, 20)
    self.inputEditbox:setPlaceHolder("可输入20个字符")
    self.inputEditbox:setPlaceholderFontColor(cc.c3b(255,255,255))
    self.inputEditbox:setMaxLength(19)
    self.inputEditbox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE )
    self.inputEditbox:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS)
    self.inputEditbox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.inputEditbox:setAnchorPoint(0.5,0.5)
    self.inputEdit:getParent():addChild(self.inputEditbox)

    self:nodeRegisterTouchEvent()
    self:initTable()
end

function PVChatPanel:initTable()
    if self.type == 1 then
        self.layerSize = self.contentLayer:getContentSize()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
        end
        self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))
    elseif self.type == 2 then
        self.layerSize = self.contentLayer:getContentSize()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
        end
        self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))
    end

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    -- self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)              --聊天记录新的显示在上方
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)               --聊天记录新的显示在下方
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    -- local offSet = self.tableView:getContentOffset()
    -- cclog(offSet.x.."===="..offSet.y)
    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVChatPanel:initTouchListener()
    --世界对话
    local function onWordClick()
        self.type = 1
        self.inputEditbox:setText("")
        getAudioManager():playEffectPage()
        self.worldMenuItem:setEnabled(false)
        self.legionMenuItem:setEnabled(true)

        self.worldNor:setVisible(false)
        self.worldSelect:setVisible(true)
        self.legionNor:setVisible(true)
        self.legionSelect:setVisible(false)

        self.worldItemCount = table.nums(self.worldChatItems)

        if self.tableView == nil then
            self:initTable()
        end

        self.tableView:reloadData()
    end

    --军团对话
    local function onLegionClick()
        getAudioManager():playEffectPage()
        self.inputEditbox:setText("")
        ---------------ljr
        self.playerLevel = getDataManager():getCommonData():getLevel()
        self.breakupOpenLeve = getTemplateManager():getBaseTemplate():getJoinGuildOpenLeve()
        if self.playerLevel >= self.breakupOpenLeve then
            -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierBreakDetail", g_selectID)
        else
            --功能等级开放提示
            self:removeChildByTag(1000)
            self:addChild(getLevelTips(self.breakupOpenLeve), 0, 1000)
            return
        end
        ----------------

        self.type = 2
        self.worldMenuItem:setEnabled(true)
        self.legionMenuItem:setEnabled(false)
        --self.contentLayer:removeAllChildren()

        self.worldNor:setVisible(true)
        self.worldSelect:setVisible(false)
        self.legionNor:setVisible(false)
        self.legionSelect:setVisible(true)

        self.legionItemCount = table.nums(self.legionChatItems)
        if self.tableView == nil then
            self:initTable()
        end

        self.tableView:reloadData()
    end

    --发言
    local function onSpeakClick()
        if self.playerLevel >= self.openLevel then
            local nowTime = self.commonData:getTime()
            local stopTime = nowTime - self.endTime
            local content = self.inputEditbox:getText() --self.cursorInputLayer:getInputText()
            self.inputEditbox:setText("")
            content = string.trim(content)
            if string.len(content)<= 0 then
                getOtherModule():showAlertDialog(nil, Localize.query("chat.1"))
                return
            end
            local id = self.commonData:getAccountId()
            local name = self.commonData:getUserName()
            local role = {}
            role.id = id
            role.nickname = name
            local legionInfo = self.legionData:getLegionInfo()
            --说话时间间隔限制
            if self.type == 1 and stopTime < self.interval then
                getOtherModule():showAlertDialog(nil, Localize.query("chat.2"))
            else
                if content ~= nil and id ~= nil then
                    local checkResult = checkWord.get_bad_word(content)
                    if self.type == 1 and stopTime >= self.interval then
                        self.chatNet:sendWords(role, self.type, content, nil, self.vip)
                    elseif self.type == 2 then
                        if legionInfo == nil  then
                            getOtherModule():showAlertDialog(nil, Localize.query("chat.3"))
                            return
                        else
                            self.chatNet:sendWords(role, self.type, content, legionInfo.g_id, self.vip)
                        end
                    end
                    content = nil
                else
                    getOtherModule():showAlertDialog(nil, Localize.query("chat.4"))
                end
            end
        else
            local tip = "您尚未达到聊天等级" .. self.openLevel .. "级"
            -- getOtherModule():showToastView(tip)
            getOtherModule():showAlertDialog(nil, tip)
            self.inputEditbox:setText("")
        end
    end

    --聊天关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        cclog("onCloseClick")
        self.animationManager:runAnimationsForSequenceNamed("hideAnimation")
        -- self:addChild(self.cursorInputLayer)
        self.chatData:setChatWords(self.worldChatItems, 1)
        self.chatData:setChatWords(self.legionChatItems, 2)
        self:onHideView()
    end

    self.UIChatView["UIChatView"] = {}

    self.UIChatView["UIChatView"]["onWordClick"] = onWordClick
    self.UIChatView["UIChatView"]["onLegionClick"] = onLegionClick
    self.UIChatView["UIChatView"]["onSpeakClick"] = onSpeakClick
    self.UIChatView["UIChatView"]["onCloseClick"] = onCloseClick
end

function PVChatPanel:scrollViewDidScroll(view)
end

function PVChatPanel:scrollViewDidZoom(view)
end

function PVChatPanel:tableCellTouched(table, cell)
    local curIndex = cell:getIdx()
    local posx, posy = cell:getPosition()
    if self.type == 1 then
        self.chatObject = self.worldChatItems[curIndex + 1].owner
    elseif self.type == 2 then
        self.chatObject = self.legionChatItems[curIndex + 1].owner
    end
    local name = self.chatObject.nickname
    local my_id = self.commonData:getAccountId()
    local id = self.chatObject.id
    if my_id ~= id then
        getOtherModule():showOtherView("PVChatCheck", id, self.itemHeight, self.curPosY, name)
    end

end

function PVChatPanel:cellSizeForTable(table, idx)
    self.UIChatItem = {}
    self.UIChatItem["UIChatItem"] = {}

    local proxy = cc.CCBProxy:create()
    local chat = CCBReaderLoad("chat/ui_chat_item.ccbi", proxy, self.UIChatItem)

    local chatItemNode = self.UIChatItem["UIChatItem"]["chatItemNode"]

    local layerSize = chatItemNode:getContentSize()

    return self.itemHeight, self.itemWidth
end

function PVChatPanel:tableCellAtIndex(tabl, idx)
    self.cell = tabl:dequeueCell()

    cclog("index=="..idx)

    if self.type == 1 then
        self.cell = nil
        if nil == self.cell then
            self.cell = cc.TableViewCell:new()

            local function onUseClick()
                self:dispatchEvent(const.EVENT_PV_USEITEMTIPS_SHOW, number, idx)
            end

            local function onItemClick()
                local number = self.cell.label:getString()
                self:dispatchEvent(const.EVENT_PV_USEITEMTIPS_SHOW, number)
            end

            -- self.cell = cc.TableViewCell:new()

            self.cell.UIChatItem = {}
            self.cell.UIChatItem["UIChatItem"] = {}

            local proxy = cc.CCBProxy:create()
            local chat = CCBReaderLoad("chat/ui_chat_item.ccbi", proxy, self.cell.UIChatItem)

            self.cell:addChild(chat)
        end

        if table.nums(self.worldChatItems) > 0 then
            local chatObject = self.worldChatItems[idx + 1].owner
            local name = chatObject.nickname
            local viplevel = chatObject.vip_level
            local words = self.worldChatItems[idx + 1].content

            local time = self.worldChatItems[idx + 1].time
            local hour = os.date("*t",time).hour
            local min = os.date("*t",time).min

            if hour < 10 then
                self.currentHour = "0" .. hour
            else
                self.currentHour = tostring(hour)
            end

            if min < 10 then
                self.currentMin = "0" .. min
            else
                self.currentMin = tostring(min)
            end

            -- local detailLayer = self.cell.UIChatItem["UIChatItem"]["detailLayer"]
            local playerName = self.cell.UIChatItem["UIChatItem"]["playerName"]
            local label1 = self.cell.UIChatItem["UIChatItem"]["label1"]

            local label2 = self.cell.UIChatItem["UIChatItem"]["label2"]

            local vipBMLabel = self.cell.UIChatItem["UIChatItem"]["vipBMLabel"]

            local otherContent = self.cell.UIChatItem["UIChatItem"]["otherContent"]


            otherContent:setString("[" .. self.currentHour .. ":" .. self.currentMin .. "]")

            vipBMLabel:setString("VIP".. viplevel)

            label2:setVisible(false)

            playerName:setString(name)
            label1:setString(words)
        end
    elseif self.type == 2 then
        self.cell = nil
        if nil == self.cell then
            self.cell = cc.TableViewCell:new()

            local function onUseClick()
                self:dispatchEvent(const.EVENT_PV_USEITEMTIPS_SHOW, number, idx)
            end

            local function onItemClick()
                local number = self.cell.label:getString()
                self:dispatchEvent(const.EVENT_PV_USEITEMTIPS_SHOW, number)
            end

            self.cell = cc.TableViewCell:new()

            self.cell.UIChatItem = {}
            self.cell.UIChatItem["UIChatItem"] = {}

            local proxy = cc.CCBProxy:create()
            local chat = CCBReaderLoad("chat/ui_chat_item.ccbi", proxy, self.cell.UIChatItem)

            self.cell:addChild(chat)
        end

        if table.nums(self.legionChatItems) > 0 then
            local chatObject = self.legionChatItems[idx + 1].owner
            local name = chatObject.nickname
            local words = self.legionChatItems[idx + 1].content

            local viplevel = chatObject.vip_level

            local time = self.legionChatItems[idx + 1].time
            local hour = os.date("*t",time).hour
            local min = os.date("*t",time).min

            if hour < 10 then
                self.currentHour = "0" .. hour
            else
                self.currentHour = tostring(hour)
            end

            if min < 10 then
                self.currentMin = "0" .. min
            else
                self.currentMin = tostring(min)
            end

            -- local detailLayer = self.cell.UIChatItem["UIChatItem"]["detailLayer"]
            local playerName = self.cell.UIChatItem["UIChatItem"]["playerName"]
            local label1 = self.cell.UIChatItem["UIChatItem"]["label1"]

            local label2 = self.cell.UIChatItem["UIChatItem"]["label2"]

            local vipBMLabel = self.cell.UIChatItem["UIChatItem"]["vipBMLabel"]

            local otherContent = self.cell.UIChatItem["UIChatItem"]["otherContent"]

            otherContent:setString("[" .. self.currentHour .. ":" .. self.currentMin .. "]")

            vipBMLabel:setString("VIP"..self.vip)

            label2:setVisible(false)

            playerName:setString(name)
            label1:setString(words)
        end
    end

    return self.cell
end

function PVChatPanel:nodeRegisterTouchEvent()
    local posX, posY = self.contentLayer:getPosition()

    local function onTouchEvent(eventType, x, y)

        pos = self.contentLayer:convertToNodeSpace(cc.p(x,y))
        self.curPosY = math.round(pos.y)
    end
    self.contentLayer:registerScriptTouchHandler(onTouchEvent)
    self.contentLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.contentLayer:setTouchEnabled(true)
end

function PVChatPanel:numberOfCellsInTableView(table)

    if self.type == 1 then
        return self.worldItemCount
    else
        return self.legionItemCount
    end
end

function PVChatPanel:onReloadView()
    local data = self.funcTable[1]
    if data ~= 1 then
        self:onHideView()
    end
end

function PVChatPanel:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_chat.plist")
end

return PVChatPanel
