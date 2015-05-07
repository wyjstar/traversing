
-- 赠送，领取奖励

local PVEmailView = class("PVEmailView", BaseUIView)

function PVEmailView:ctor(id)
    self.super.ctor(self, id)
    game.addSpriteFramesWithFile("res/ccb/resource/ui_mail.plist")
    -- self:showAttributeView()
    self:registerNetCallback()
    self.emailNet = getNetManager():getEmailNet()
    self.emailData = getDataManager():getEmailData()
    self.emailData:clearData()
    self.emailNet:sendGetEmailListMsg()
    self.mailTemplate = getTemplateManager():getMailTemplate()
end

--[[
EMAIL_LIST_REQUEST               = 1301      --信箱列表
EMAIL_READ_REQUEST               = 1302      --读取邮件、领取奖励
EMAIL_DELETE_REQUEST             = 1303      --删除邮件
EMAIL_SEND_REQUEST               = 1304      --发送邮件
EMAIL_RECIVE_REQUEST             = 1305      --接收邮件 （服务器主动推送过来的暂时放这）
]]

function PVEmailView:reloadMailList()
    self:initData()
    if self.curTabIndex == 1 then
        self.itemCount = table.nums(self.generalItems1)
    elseif self.curTabIndex == 2 then
        self.itemCount = table.nums(self.generalItems2)
    elseif self.curTabIndex == 3 then
        self.itemCount = table.nums(self.generalItems3)
    elseif self.curTabIndex == 4 then
        self.itemCount = table.nums(self.generalItems4)
    end
    self:initTableView()  -- 界面上重新显示
    self.tableView:reloadData()
    self:updateNotice()
end

-- 注册网络response回调
function PVEmailView:registerNetCallback()
    local function getReadCallback(id, data)
        print("========= read callback ....")
        table.print(data)
        print("-----------",data.res.result)
        if data.res.result == true then
            print("----22222222------")
            for k,v in pairs(self.reciveEmailList.mail_ids) do
                self.emailData:removeEmail(v)
            end
            local mail_type = self.reciveEmailList.mail_type
            print("mail_type --------- ", mail_type)
            if mail_type == 1 then
                -- self:toastShow(Localize.query("mail.1"))
                -- getOtherModule():showAlertDialog(nil, Localize.query("mail.1"))
                getDataProcessor():gainGameResourcesResponse(data.gain)
                local rewards = self:createTableData(data.gain)
                if rewards ~= nil then
                    getOtherModule():showOtherView("PVCongratulationsGainDialog", 4, rewards)
                end
            elseif mail_type == 2 then
                -- if self.smallBags ~= nil then
                    -- getOtherModule():showOtherView("PVCongratulationsGainDialog", 5, self.smallBags)
                -- end
                print("mail_type == 2 =========== ")
                table.print(data.gain)
                getDataProcessor():gainGameResourcesResponse(data.gain)
                local rewards = self:createTableData(data.gain)
                if rewards ~= nil then
                    getOtherModule():showOtherView("PVCongratulationsGainDialog", 4, rewards)
                end
                -- getOtherModule():showOtherView("PVCongratulationsGainDialog",6,data.gain.finance.finance_changes)

                -- stepCallBack(G_GUIDE_30007)
                -- getOtherModule():showAlertDialog(nil, Localize.query("mail.1"))
            else
                -- self:toastShow(Localize.query("mail.2"))
                getOtherModule():showAlertDialog(nil, Localize.query("mail.2"))
            end
        end

        self.reciveEmailList = nil
        self:reloadMailList()
        self:setReceiveStatus(self.itemCount)
    end

    local function receiveMailCallBack(id, data)
        self:reloadMailList()
        self:setReceiveStatus(self.itemCount)
    end

    local function getEmailListCallBack(id,data)
        self:reloadMailList()
        self:setReceiveStatus(self.itemCount)
    end

    self:registerMsg(EMAIL_LIST_REQUEST,getEmailListCallBack)
    self:registerMsg(EMAIL_READ_REQUEST, getReadCallback)
    self:registerMsg(EMAIL_RECEIVE_REQUEST, receiveMailCallBack)
    --处理邀请
    local function dealCallBack(id, data)
        print("处理邀请 ============= ")
        table.print(data)
        if not data.result then
            getOtherModule():showAlertDialog(nil, data.message)
        else
            if self.legionEmailInfo ~= nil then
                if self.legionEmailInfo.is_readed == false then
                    local data = {}
                    data.mail_ids = {}
                    table.insert(data.mail_ids, self.legionEmailInfo.mail_id)
                    data.mail_type = 3
                    self.emailNet:sendReadEmail(data)
                    self.reciveEmailList = data
                end
            end
        end
    end

    self:registerMsg(DEAL_INVITE_JOIN_LEGION, dealCallBack)
end

function PVEmailView:initData()

    -- 获取DataCenter中邮件列表，分类提取
    self.content = {}
    self.generalItems1 = {}
    self.generalItems2 = {}
    self.generalItems3 = {}
    self.generalItems4 = {}

    local _list = self.emailData:getEmailList()

    for k,v in pairs(_list) do
        local mail_type = nil
        if v.config_id and v.config_id ~= 0 then
            v.mail_type = self.mailTemplate:getMailTypeById(v.config_id)
        end

        if v.mail_type == 1 then
            table.insert(self.generalItems1, v)
        elseif v.mail_type == 2 then
            table.insert(self.generalItems2, v)
        elseif v.mail_type == 3 then
            table.insert(self.generalItems3, v)
        else
            table.insert(self.generalItems4, v)
        end
    end

    -- 邮件排序@jiang
    function  sortMailDesc(x, y)
        return x.send_time > y.send_time
    end
    table.sort(self.generalItems1, sortMailDesc)
    table.sort(self.generalItems2, sortMailDesc)
    table.sort(self.generalItems3, sortMailDesc)
    table.sort(self.generalItems4, sortMailDesc)

end

function PVEmailView:onMVCEnter()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_mail.plist")

    self:initData()
    self.UIEmailView = {}
    self.menuItems = {}
    self.menuItemsLabel = {}
    self.curTabIndex = 1

    self:initTouchListener()

    self:loadCCBI("email/ui_mail_gift_list.ccbi", self.UIEmailView)


    self.itemCount = table.nums(self.generalItems1)
    self:initView()
    self:initTableView()


    self.tableView:reloadData()


    -- local function onNodeEvent(event)
    --     if "exit" == event then
    --         self:onExit()
    --     end
    -- end

    -- self:registerScriptHandler(onNodeEvent)

    -- local event = cc.EventCustom:new(UPDATE_HEAD_ICON)
    -- self:getEventDispatcher():dispatchEvent(event)

end

function PVEmailView:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()
    getDataManager():getResourceData():clearResourcePlistTexture()

end

function PVEmailView:initTouchListener()

    function menuClickA()
        getAudioManager():playEffectButton2()
        cclog("-menuClickA-")
        self.pageNode1:setVisible(false)
        self.pageNode2:setVisible(true)
        self.shadowBorder:setVisible(true)
        self.changeTimeLable:setVisible(true)
        self.drawTimesRate:setString(self.emailData.current..'/'..self.emailData.target)
        self.drawTimesRate:setVisible(true)

        self:updateTab(1)
        self:initTableView();
        self.itemCount = table.nums(self.generalItems1)
        self:setReceiveStatus(self.itemCount)
        self.tableView:reloadData()
    end

    function menuClickB()
        getAudioManager():playEffectButton2()
        cclog("-menuClickB-")
        self.pageNode1:setVisible(false)
        self.pageNode2:setVisible(true)
        self.shadowBorder:setVisible(true)
        self.changeTimeLable:setVisible(false)
        self.drawTimesRate:setVisible(false)

        self:updateTab(2)
        self:initTableView()
        self.itemCount = table.nums(self.generalItems2)
        self:setReceiveStatus(self.itemCount)
        self.tableView:reloadData()
    end

    function menuClickC()
        getAudioManager():playEffectButton2()
        cclog("-menuClickC-")
        self.pageNode1:setVisible(true)
        self.pageNode2:setVisible(false)
        self.shadowBorder:setVisible(false)
        self:updateTab(3)
        self:initTableView()
        self.itemCount = table.nums(self.generalItems3)
        self:setReceiveStatus(self.itemCount)
        self.tableView:reloadData()
    end

    function menuClickD()
        getAudioManager():playEffectButton2()
        cclog("-menuClickD-")
        self.pageNode1:setVisible(true)
        self.pageNode2:setVisible(false)
        self.shadowBorder:setVisible(false)
        self:updateTab(4)
        self:initTableView()
        self.itemCount = table.nums(self.generalItems4)
        self:setReceiveStatus(self.itemCount)
        self.tableView:reloadData()
    end

    function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    function onOneKeyRecive()  -- 一键领取回调
        getAudioManager():playEffectButton2()
        local data = {}
        data.mail_ids = {}
        if self.curTabIndex == 1 then
            for k,v in pairs(self.generalItems1) do
                table.insert(data.mail_ids, v.mail_id)
            end
            data.mail_type = 1
        end
        if self.curTabIndex == 2 then
            for k,v in pairs(self.generalItems2) do
                table.insert(data.mail_ids, v.mail_id)
            end
            data.mail_type = 2
        end
        print("==============发送一键领取 data")
        table.print(data)
        if table.nums(data.mail_ids) > 0 then
            self.emailNet:sendReadEmail(data)
            self.reciveEmailList = data
        end
    end

    self.UIEmailView["UIEmailView"] = {}
    self.UIEmailView["UIEmailView"]["menuClickA"] = menuClickA
    self.UIEmailView["UIEmailView"]["menuClickB"] = menuClickB
    self.UIEmailView["UIEmailView"]["menuClickC"] = menuClickC
    self.UIEmailView["UIEmailView"]["menuClickD"] = menuClickD
    self.UIEmailView["UIEmailView"]["backMenuClick"] = backMenuClick
    self.UIEmailView["UIEmailView"]["onOneKeyRecive"] = onOneKeyRecive

end

-- 更新tab 标签，设置菜单按钮的切换
function PVEmailView:updateTab(index)
    self.menuItems[self.curTabIndex]:setEnabled(true);
    self.menuItems[index]:setEnabled(false);
    self.menuItems[index]:getSelectedImage():setVisible(false)
    local  strName = {}
    if 1 == index then
    	strName = "#ui_mail_s_zsl.png"
    elseif 2 == index then
    	strName = "#ui_mail_s_ljl.png"
    elseif 3 == index then
    	strName = "#ui_mail_s_ggl.png"
    elseif 4 == index then
    	strName = "#ui_mail_s_xiaoxl.png"
    end
    game.setSpriteFrame(self.menuItemsLabel[index], strName)

    local strName = {}
    if 1 == self.curTabIndex then
    	strName = "#ui_mail_s_zs.png"
    elseif 2 == self.curTabIndex then
    	strName = "#ui_mail._lj.png"
    elseif 3 == self.curTabIndex then
    	strName = "#ui_mail_s_gongg.png"
    elseif 4 == self.curTabIndex then
    	strName = "#ui_mail_s_xiaox.png"
    end

    game.setSpriteFrame(self.menuItemsLabel[self.curTabIndex], strName)

    self.curTabIndex = index
end

function PVEmailView:initView()

    self.pageNode1 = self.UIEmailView["UIEmailView"]["pageNode1"]  -- 带有一键领取的背景
    self.pageNode2 = self.UIEmailView["UIEmailView"]["pageNode2"]  -- 不带一键领取的背景
    self.listLayer1 = self.UIEmailView["UIEmailView"]["listLayer1"]
    self.listLayer2 = self.UIEmailView["UIEmailView"]["listLayer2"]
    self.shadowBorder = self.UIEmailView["UIEmailView"]["shadowBorder"]
    self.receiveBtn= self.UIEmailView["UIEmailView"]["receiveBtn"]
    --红点提示
    self.notice1= self.UIEmailView["UIEmailView"]["notice1"]
    self.notice2= self.UIEmailView["UIEmailView"]["notice2"]
    self.notice3= self.UIEmailView["UIEmailView"]["notice3"]
    self.notice4= self.UIEmailView["UIEmailView"]["notice4"]

    self.shadowBorder:setVisible(true)
    self.listLayer2:setVisible(true)
    self.listLayer1:setLocalZOrder(10)
    self.changeTimeLable = self.UIEmailView["UIEmailView"]["changeTimeLable"]
    self.drawTimesRate = self.UIEmailView["UIEmailView"]["label_today_get"]

    self.changeTimeLable:setVisible(true)
    self.drawTimesRate:setString(self.emailData.current..'/'..self.emailData.target)
    self.drawTimesRate:setVisible(true)

    for i=1,4 do
        local itemName = string.format("menuItem%d", i)
        local menuItem = self.UIEmailView["UIEmailView"][itemName]
        menuItem:getSelectedImage():setVisible(false)
        menuItem:setAllowScale(false)
        table.insert(self.menuItems, i, menuItem)

        local itemLableName = string.format("menuItemLabel%d", i)
        local menuItemLabel = self.UIEmailView["UIEmailView"][itemLableName]

        table.insert(self.menuItemsLabel, i, menuItemLabel)
    end

    self.curMenuItem = self.menuItems[1]
    self.curMenuItemLabel = self.menuItemsLabel[1]
    self.curMenuItem:setEnabled(false);
    self.curMenuItem:getSelectedImage():setVisible(false)
    game.setSpriteFrame(self.curMenuItemLabel, "#ui_mail_s_zsl.png")

    self:setReceiveStatus(self.itemCount)

    self:updateNotice()

end

function PVEmailView:updateNotice()
    local count1 = table.nums(self.generalItems1)
    if count1 > 0 then
        self.notice1:setVisible(true)
    else
        self.notice1:setVisible(false)
    end

    local count2 = table.nums(self.generalItems2)
    if count2 > 0 then
        self.notice2:setVisible(true)
    else
        self.notice2:setVisible(false)
    end

    local count3 = table.nums(self.generalItems3)
    if count3 > 0 then
        self.notice3:setVisible(true)
    else
        self.notice3:setVisible(false)
    end

    local count4 = table.nums(self.generalItems4)
    if count4 > 0 then
        self.notice4:setVisible(true)
    else
        self.notice4:setVisible(false)
    end
end

function PVEmailView:setReceiveStatus(itemCount)
     if itemCount > 0 then
        self.receiveBtn:setEnabled(true)
    else
        self.receiveBtn:setEnabled(false)
    end
end

function PVEmailView:initTableView()

    if self.tableView ~= nil then
        self.tableView:removeFromParent(true)
    end

    if 1 == self.curTabIndex or 2 == self.curTabIndex then
        self.layerSize = self.listLayer2:getContentSize()
    else
        self.layerSize = self.listLayer1:getContentSize()
    end

    self.tableView = cc.TableView:create(cc.size(self.layerSize.width, self.layerSize.height))
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()

    self.listLayer1:removeChildByTag(999)
    self.listLayer2:removeChildByTag(999)

    if 1 == self.curTabIndex or 2 == self.curTabIndex then
    	self.listLayer2:addChild(self.tableView)

        local scrBar = PVScrollBar:new()
        scrBar:setTag(999)
        scrBar:init(self.tableView,1)
        scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
        self.listLayer2:addChild(scrBar,2)
    else
    	self.listLayer1:addChild(self.tableView)

        local scrBar = PVScrollBar:new()
        scrBar:setTag(999)
        scrBar:init(self.tableView,1)
        scrBar:setPosition(cc.p(self.layerSize.width,self.layerSize.height/2))
        self.listLayer1:addChild(scrBar,2)
    end

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    if 1 == self.curTabIndex then
        self.drawTimesRate:setString(self.emailData.current..'/'..self.emailData.target)
        self.drawTimesRate:setVisible(true)
    end

    -- self.tableView:reloadData()
end

function PVEmailView:tableCellTouched(tab, cell)

end

function PVEmailView:cellSizeForTable(table, idx)

    return 150, 557
end

-- 设置发送者头像
function PVEmailView:setSenderIcon(senderIcon, id, is_hero_id)
    -- is_hero_id：1 or 0 。1:英雄id  0：icon id
    local icon = nil
    local quality = 5
    if is_hero_id == 1 then
        local c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
        local soldier_template = c_SoldierTemplate:getHeroTempLateById(id)
        if soldier_template then
            icon = c_SoldierTemplate:getSoldierIcon(id)
            quality = soldier_template.quality
        else
            return
        end
    else
        local c_ResourceTemplate = getTemplateManager():getResourceTemplate()
        icon = c_ResourceTemplate:getResourceById(id)
    end
    changeNewIconImage(senderIcon, icon, quality)
end

function PVEmailView:tableCellAtIndex(tbl, currIdx)

    self.cell = tbl:dequeueCell()
    ---- 赠送列表 ----
    if self.curTabIndex == 1 then
        self.cell = nil
        if table.nums(self.generalItems1) < currIdx + 1 then
            return
        end

        self.cell = cc.TableViewCell:new()
        local _curEmailData = nil

        local function onHeadItemClick()
            print("-onHeadItemClick-", currIdx+1)

        end

        -- 领取体力
        local function onGiveClick(item)
            local data = {}
            data.mail_ids = {_curEmailData.mail_id}
            data.mail_type = _curEmailData.mail_type
            self.emailNet:sendReadEmail(data)
            self.reciveEmailList = data
        end

        self.cell.UIMailGiveItem = {}
        self.cell.UIMailGiveItem["UIMailGiveItem"] = {}
        self.cell.UIMailGiveItem["UIMailGiveItem"]["onHeadItemClick"] = onHeadItemClick
        self.cell.UIMailGiveItem["UIMailGiveItem"]["onGiveClick"] = onGiveClick

        local proxy = cc.CCBProxy:create()
        local giveItem = CCBReaderLoad("email/ui_mail_give.ccbi", proxy, self.cell.UIMailGiveItem)
        self.cell:addChild(giveItem)

        _curEmailData = self.generalItems1[currIdx + 1]

        local labelSenderName = self.cell.UIMailGiveItem["UIMailGiveItem"]["nameLabel"]
        local labelTime = self.cell.UIMailGiveItem["UIMailGiveItem"]["timeLable"]
        local iconImg = self.cell.UIMailGiveItem["UIMailGiveItem"]["iconBg"]
        local labelContent = self.cell.UIMailGiveItem["UIMailGiveItem"]["contentLabel"]

        labelSenderName:setString(_curEmailData.sender_name)
        self:setSenderIcon(iconImg, _curEmailData.sender_icon, 1)

        local _time = _curEmailData.send_time  -- to do
        local _curtime = os.time() -- to do 获取服务器的登录时间+计时器后=当前服务器时间
        local _timeDiff = os.difftime(_curtime, _time)
        local _dayDiff = math.floor(_timeDiff/86400)
        if _dayDiff >= 1 then
            labelTime:setString(string.format(Localize.query("mail.3"), _dayDiff))
        else
            local _hourDiff = math.floor(_timeDiff/3600)
            if _hourDiff >= 1 then
                labelTime:setString(string.format(Localize.query("mail.4"), _hourDiff))
            else
                local _minDiff = math.floor(_timeDiff/60)
                if _minDiff >= 1 then
                    labelTime:setString(string.format(Localize.query("mail.5"), _minDiff))
                else
                    labelTime:setString(Localize.query("mail.6"))
                end
            end
        end

    ---- 领奖 ----
    elseif self.curTabIndex == 2 then
        self.cell = nil

        self.cell = cc.TableViewCell:new()

        local _curEmailData = nil
        local function onItemClick()
            print("onItemClick", currIdx+1)
        end
        --领取
        local function oningotsClick()
            print("-oningotsClick-", currIdx+1)
            local data = {}
            data.mail_ids = {_curEmailData.mail_id}
            data.mail_type = _curEmailData.mail_type
            self.emailNet:sendReadEmail(data)
            -- data.gain = self.mailTemplate:getMailGainById(_curEmailData.config_id)
            print("读取邮件获取的奖励 ============")
            -- table.print(data.gain)
            self.reciveEmailList = data

            --当前邮件可以领取的奖励
            -- local rewards = self.mailTemplate:getMailGainById(_curEmailData.config_id)
            -- local dropId = rewards["106"][3]                                            --掉落大包的id
            -- self.smallBags = getTemplateManager():getDropTemplate():getSmallBagIds(dropId)
        end

        self.cell.UIMailgetItem = {}
        self.cell.UIMailgetItem["UIMailgetItem"] = {}
        self.cell.UIMailgetItem["UIMailgetItem"]["onItemClick"] = onItemClick
        self.cell.UIMailgetItem["UIMailgetItem"]["oningotsClick"] = oningotsClick

        local proxy = cc.CCBProxy:create()
        local cellItem = CCBReaderLoad("email/ui_mail_get.ccbi", proxy, self.cell.UIMailgetItem)

        self.cell:addChild(cellItem)

        if table.nums(self.generalItems2) > 0 then
            local labelTitle = self.cell.UIMailgetItem["UIMailgetItem"]["title_label"]
            local labelSender = self.cell.UIMailgetItem["UIMailgetItem"]["sender_label"]
            local iconImg = self.cell.UIMailgetItem["UIMailgetItem"]["iconBg"]
            local tagImg = self.cell.UIMailgetItem["UIMailgetItem"]["tagBg"]
            local labelDate = self.cell.UIMailgetItem["UIMailgetItem"]["time_label"]
            local labelTime = self.cell.UIMailgetItem["UIMailgetItem"]["timeLabel"]

            _curEmailData = self.generalItems2[currIdx+1]
            table.print(_curEmailData)
            local _senderName = nil
            local _title = nil
            local _icon = nil
            -- local _time = os.time({year=2014,month=8,day=19,hour=20,min=34,sec=30}) --_curEmailData.send_time  -- to do
            -- local _curtime = os.time() -- to do 获取服务器的登录时间+计时器后=当前服务器时间
            -- local _timeDiff = os.difftime(_curtime, _time)
            -- local _dayDiff = math.floor(_timeDiff/86400)
            print("_curEmailData.config_id -========= ", _curEmailData.config_id)
            if _curEmailData.config_id ~= 0 then
                _senderName = self.mailTemplate:getSendNameById(_curEmailData.config_id)
                _title = self.mailTemplate:getTitleById(_curEmailData.config_id)
                _icon = self.mailTemplate:getIconById(_curEmailData.config_id)
                self:setSenderIcon(iconImg, _icon, 0)
            else
                _senderName = _curEmailData.sender_name
                _title = _curEmailData.title
                _icon = _curEmailData.sender_icon
                self:setSenderIcon(iconImg, _icon, 1)
            end

            -- if _dayDiff >= 1 then
            --     labelTime:setString(string.format(Localize.query("mail.3"), _dayDiff))
            -- else
            --     local _hourDiff = math.floor(_timeDiff/3600)
            --     if _hourDiff >= 1 then
            --         labelTime:setString(string.format(Localize.query("mail.4"), _hourDiff))
            --     else
            --         local _minDiff = math.floor(_timeDiff/60)
            --         if _minDiff >= 1 then
            --             labelTime:setString(string.format(Localize.query("mail.5"), _minDiff))
            --         else
            --             labelTime:setString(Localize.query("mail.6"))
            --         end
            --     end
            -- end
            labelSender:setString(_senderName)
            local curTime = _curEmailData.send_time
            local _strDate = os.date("%Y-%m-%d",curTime)
            labelDate:setString(_strDate)
            labelTitle:setString(_title)
        end

    ---- 公告 ----
    elseif self.curTabIndex == 3 then
        self.cell = nil
        if nil == self.cell then
            self.cell = cc.TableViewCell:new()

            local function onChangeClick()  -- 添加参数传给detail窗体
                local _emailInfo = self.generalItems3[currIdx + 1]
                if _emailInfo.is_readed == false then
                    local data = {}
                    data.mail_ids = {}
                    table.insert(data.mail_ids, _emailInfo.mail_id)
                    data.mail_type = 3
                    self.emailNet:sendReadEmail(data)
                    self.reciveEmailList = data
                end
                getOtherModule():showOtherView("PVEmailDetail", self.generalItems3[currIdx + 1])
                -- getModule(MODULE_NAME_EMAIL):showUIViewAndInTop("PVEmailDetail", self.generalItems3[currIdx + 1])
            end
            --同意邀请加入军团
            local function onAgreeClick()
                self.legionEmailInfo = self.generalItems3[currIdx + 1]
                getNetManager():getLegionNet():sendDealInviteJoin(1, self.legionEmailInfo.guild_id)
            end
            --忽略邀请加入军团
            local function onIgnoreClick()
                self.legionEmailInfo = self.generalItems3[currIdx + 1]
                getNetManager():getLegionNet():sendDealInviteJoin(0, self.legionEmailInfo.guild_id)
            end

            self.cell.UImailnoticeItem = {}
            self.cell.UImailnoticeItem["UImailnoticeItem"] = {}
            self.cell.UImailnoticeItem["UImailnoticeItem"]["onChangeClick"] = onChangeClick
            self.cell.UImailnoticeItem["UImailnoticeItem"]["onIgnoreClick"] = onIgnoreClick
            self.cell.UImailnoticeItem["UImailnoticeItem"]["onAgreeClick"] = onAgreeClick

            local proxy = cc.CCBProxy:create()
            local cellItem = CCBReaderLoad("email/ui_mail_notice.ccbi", proxy, self.cell.UImailnoticeItem)

            self.cell:addChild(cellItem)
        end

        if table.nums(self.generalItems3) > 0 then
            local iconImg = self.cell.UImailnoticeItem["UImailnoticeItem"]["icon_img"]
            local labelTitle = self.cell.UImailnoticeItem["UImailnoticeItem"]["title_label"]
            local labelSender = self.cell.UImailnoticeItem["UImailnoticeItem"]["sender_label"]
            local labelDate = self.cell.UImailnoticeItem["UImailnoticeItem"]["date_label"]

            local changeMenu = self.cell.UImailnoticeItem["UImailnoticeItem"]["changeMenu"]
            local inviteLayer = self.cell.UImailnoticeItem["UImailnoticeItem"]["inviteLayer"]
            local detailLabel = self.cell.UImailnoticeItem["UImailnoticeItem"]["detailLabel"]

            local otherLayer = self.cell.UImailnoticeItem["UImailnoticeItem"]["otherLayer"]

            local _curEmailData = self.generalItems3[currIdx+1]

            print("公告邮件的详细信息 ============= ")
            table.print(_curEmailData)

            local _senderName = _curEmailData.sender_name
            local _title = _curEmailData.title
            local title = self.mailTemplate:getTitleById(_curEmailData.config_id)

            title = string.gsub(title, "%$%w+%$", "")
            local contentStr = self.mailTemplate:getEmailContent(_curEmailData.config_id)

            self.content[1] = _curEmailData.invite_name
            self.content[2] = _curEmailData.guild_name
            self.content[3] = _curEmailData.guild_level
            self.content[4] = _curEmailData.guild_person_num
            local idx = 1
            for findStr in string.gmatch(contentStr, "%$%w+%$") do
                for _var in string.gmatch(findStr, "%w+") do
                    contentStr = string.gsub(contentStr, "%$%w+%$", self.content[idx], 1)
                    idx = idx + 1
                end
            end

            if _curEmailData.config_id == 131 then
                otherLayer:setVisible(false)
                inviteLayer:setVisible(true)
                labelTitle:setString(title)
                detailLabel:setString(contentStr)
            else
                labelTitle:setString(_title)
                otherLayer:setVisible(true)
                inviteLayer:setVisible(false)
            end

            labelSender:setString(_senderName)
            local _time = _curEmailData.send_time
            local _strDate = os.date("%Y-%m-%d",_time)
            labelDate:setString("(" .. _strDate .. ")")
        end

    ---- 消息 ----
    elseif self.curTabIndex == 4 then
        self.cell = nil
        if nil == self.cell then
            self.cell = cc.TableViewCell:new()

            local function onChangeClick() -- 查看邮件
                print("see email", currIdx+1)
                local _emailInfo = self.generalItems4[currIdx + 1]

                -- 查看后直接删除邮件，不需要标记已读
                -- if _emailInfo.is_readed == false then
                --     local data = {}
                --     data.mail_ids = {}
                --     table.insert(data.mail_ids, self.generalItems4[currIdx + 1].mail_id)
                --     data.mail_type = 4
                --     self.emailNet:sendReadEmail(data)
                --     self.reciveEmailList = data
                -- end
                getOtherModule():showOtherView("PVEmailDetail", self, _emailInfo)
            end

            self.cell.UIMailmailitem = {}
            self.cell.UIMailmailitem["UIMailmailitem"] = {}
            self.cell.UIMailmailitem["UIMailmailitem"]["onChangeClick"] = onChangeClick

            local proxy = cc.CCBProxy:create()
            local cellItem = CCBReaderLoad("email/ui_mail_mail.ccbi", proxy, self.cell.UIMailmailitem)

            self.cell:addChild(cellItem)
        end

        if table.nums(self.generalItems4) > 0 then
            local iconImg = self.cell.UIMailmailitem["UIMailmailitem"]["icon_img"]
            local labelTitle = self.cell.UIMailmailitem["UIMailmailitem"]["title_label"]
            local labelSender = self.cell.UIMailmailitem["UIMailmailitem"]["sender_label"]
            local labelDate = self.cell.UIMailmailitem["UIMailmailitem"]["date_label"]

            local _curEmailData = self.generalItems4[currIdx+1]
            local _senderName = _curEmailData.sender_name
            local _title = _curEmailData.title
            -- local _time = os.time({year=2014,month=8,day=19,hour=20,min=34,sec=30}) --_curEmailData.send_time  -- to do

            labelTitle:setString(_title)
            labelSender:setString(_senderName)
            local _time = _curEmailData.send_time
            local _strDate = os.date("%Y-%m-%d",_time)
            labelDate:setString(_strDate)
        end
    end

    return self.cell
end

function PVEmailView:numberOfCellsInTableView(table)

   return self.itemCount
end

function PVEmailView:onReloadView()
    cclog("--PVEmailView:onReloadView--")
end

function PVEmailView:update()

	cclog('--PVEmailView:update--')
end

function PVEmailView:clearResource()
    cclog("-----PVEmailView-clearResource-------")

    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_mail.plist")
end


function PVEmailView:createTableData(dropItem)

    local heros = dropItem.heros                --武将
    local equips = dropItem.equipments          --装备
    local items = dropItem.items                --道具
    local h_chips = dropItem.hero_chips         --英雄灵魂石
    local e_chips = dropItem.equipment_chips    --装备碎片
    local finance = dropItem.finance            --finance
    local stamina = dropItem.stamina
    local runt = dropItem.runt                  --符文

    local _itemList = {}  -- 将创建物件需要的数据暂存到_itemList中
    local _index = 1
    --武将
    if heros ~= nil then
        for k,var in pairs(heros) do
            _itemList[_index] = {type = 101, detailID = var.hero_no, count = 1}
            _index = _index + 1
        end
    end
    --装备
    if equips ~= nil then
        for k,var in pairs(equips) do
            _itemList[_index] = {type = 102, detailID = var.no, count = 1}
            _index = _index + 1
        end
    end
    --英雄碎片
    if h_chips ~= nil then
        for k,var in pairs(h_chips) do
            _itemList[_index] = {type = 103, detailID = var.hero_chip_no, count = var.hero_chip_num}
            _index = _index + 1
        end
    end
    --装备碎片
    if e_chips ~= nil then
        for k,var in pairs(e_chips) do
            _itemList[_index] = {type = 104, detailID = var.equipment_chip_no, count = var.equipment_chip_num}
            _index = _index + 1
        end
    end
    --道具碎片
    if items ~= nil then
        for k,var in pairs(items) do
            _itemList[_index] = {type = 105, detailID = var.item_no, count = var.item_num}
            _index = _index + 1
        end
    end
    --其他
    if finance ~= nil then
        --更改获取资源数据结构
        local finance_changes = finance.finance_changes
        for k,v in pairs(finance_changes) do
            if v.item_no ~= nil then
                _itemList[_index] = {type = v.item_type, detailID = v.item_no, count = v.item_num}
                _index = _index + 1
            end
        end
    end
    --符文
    if runt ~= nil then
        for k, v in pairs(runt) do
            _itemList[_index] = {type = 108, detailID = v.runt_id, count = 1}
            _index = _index + 1
        end
    end
    return _itemList
end

return PVEmailView
