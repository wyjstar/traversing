UPDATE_BOSS_NOTICE = "UPDATE_BOSS_NOTICE"
UPDATE_PVP_NOTICE = "UPDATE_PVP_NOTICE"
UPDATE_MINE_NOTICE = "UPDATE_MINE_NOTICE"

-- local PVScrollBar = import("..scrollbar.PVScrollBar")
local PVArenaPanel = class("PVArenaPanel", BaseUIView)

local TYPE_SHOP_PVP = 10

function PVArenaPanel:ctor(id)
    self.super.ctor(self, id)

    self.arenaData = getDataManager():getArenaData()                      --竞技数据

    self.arenaShopTemplate = getTemplateManager():getArenaShopTemplate()  --商品基本数据

    self.shopTemp = getTemplateManager():getShopTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.shopData = getDataManager():getShopData()
    self.commonData = getDataManager():getCommonData()
    self.baseTemp = getTemplateManager():getBaseTemplate()
    self.dropTemp = getTemplateManager():getDropTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()

    self.arenaNet = getNetManager():getArenaNet()                         --网络控制类
    self.shopNet = getNetManager():getShopNet()

    -- self.arenaNet:sendGetArenaList()                 --竞技场中竞技列表
    self.arenaNet:sendGetRankList()                  --竞技场中排行列表
    cclog("----------------竞技场中兑换商店-----------")
    -- self.shopNet:sendGetShopList(TYPE_SHOP_PVP)      --竞技场中兑换商店

    self:registerDataBack()

end

function PVArenaPanel:onExit()
    cclog("-------onExit----")
    -- self:unregisterScriptHandler()

end

function PVArenaPanel:onMVCEnter()
    --加载相关plist文件
    game.addSpriteFramesWithFile("res/ccb/resource/ui_arena.plist")

    self:initData()

    self:initView()

    self:initTableView()


    local data = self.funcTable[1]             --从tips进来
    print("************", data)
    if data == 3 then self:updateMenu(data) end

end


function PVArenaPanel:updateBossNoticeData()

end

function PVArenaPanel:updatePVPNoticeData()

end

function PVArenaPanel:updateMineNoticeData()

end

--网络返回
function PVArenaPanel:registerDataBack()

    --竞技列表返回
    local function getArenaListCallBack(id, data)
        cclog("================ getArenaListCallBack")
        self:updateData(1)
    end
    self:registerMsg(ARENA_ARENALIST, getArenaListCallBack)

    --排行
    local function getRankListCallback(id, data)
        cclog(" =================== getRankListCallback")
        self:updateData(2)
    end
    self:registerMsg(ARENA_RANKLIST, getRankListCallback)

    --查看返回
    local function getCheckCallBack()
        cclog("getCheckCallBack")

        local data = self.arenaData:getArenaRankCheck()
        if data ~= nil then
            getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaCheckInfo", self.curTeamName)
        end
    end
    self:registerMsg(ARENA_RANK_CHECK, getCheckCallBack)

    --兑换商店相关
    function onGetShopListCallBack(id, data)
        cclog("-------------onGetShopListCallBack-----333333----")
        if data.res.result ~= true then
        else
            cclog("-------------onGetShopListCallBack---------")
            table.print(data)

            self.shopData:setPvpList(data.id)
            self.shopData:setPvpGotList(data.buyed_id)

            self:updateData(3)
        end
    end
    local function onRefreshCallback(id, data) -- flash
        if data.res.result ~= true then
            cclog("!!! 数据返回错误")
        else
            cclog("!!! onRefreshCallback")
            self.shopData:setPvpList(data.id)
            self.shopData:setPvpGotList(data.buyed_id)
            self.commonData:subGold(self.flashMoney)  -- 应该根据类型扣*，self.flashType

            self:updateData(3)
        end
    end
    --兑换返回
    local function getGoodsCallback(id, data)
        if data.res.result ~= true then
            cclog("!!! 数据返回错误")
        else
            self.curPvpStore = self.commonData:subPvpStore(self.useMoney)
            self.curPvpStore = self.commonData:getPvpStore()
            -- self.commonData:setPvpScore(self.curPvpStore)
            self.reputationValue:setString(self.curPvpStore)

            getModule(MODULE_NAME_HOMEPAGE):showUITopShowLastView("PVExchangeDialog", self.buyGoodsId)

            -- self:updateData(3)
        end
    end


    -- self:registerMsg(SHOP_GET_ITEM_CODE, onGetShopListCallBack)
    -- self:registerMsg(SHOP_REFRESH_CODE, onRefreshCallback)
    -- self:registerMsg(SHOP_BUY_GOODS_CODE, getGoodsCallback)

    --挑战次数重置返回
    local function getResetCallBack(id, data)
        if data.res.result then
            getDataProcessor():consumeGameResourcesResponse(data.consume)
            self.buyMenuItem:setEnabled(false)
            self.compRedPoint:setVisible(true)
            self.challengeTimes = 0
            self.commonData:setPvpTimes(0)
            self.challengeNum:setString(self.freeTime)
            --扣除消耗
            self.commonData:subGold(self.resetCost)

            self.commonData:updatePvpRefreshCount(1)
            self.pvpResetTimes = self.commonData:getPvpRefreshCount()
            self.resetValue:setString(self.buyTimes - self.pvpResetTimes)
        end
    end

    self:registerMsg(ARENA_RESET_CHALLENGE, getResetCallBack)
end

--相关数据初始化
function PVArenaPanel:initData()
    self.type = 1
    self.maxVipLevel = self.baseTemp:getMaxVipLevel()              --vip的最大等级
    self.shortTime = self.baseTemp:getArenaShortTime()            --奖励间隔时间
    self.freeTime = self.baseTemp:getArenaFreeTime()              --每日免费挑战次数
    self.challengeTimes = self.commonData:getPvpTimes()           --已经挑战的次数

    self.pvpResetTimes = self.commonData:getPvpRefreshCount()     --重置次数

    self.viplevel = self.commonData:getVip()                     --获取战队vip等级
    self.buyTimes = self.baseTemp:getBuyArenaTimes(self.viplevel) --根据vip等级获取可以重置的次数

    self.resetTimes = self.baseTemp:getReceiveTimes()             --付费重置后可以获取的挑战次数

    self.resetCost = self.baseTemp:getArenaTimePrice()            --重置消耗的元宝数

    self.curPvpStore = self.commonData:getPvpStore()
    self.haveGold = self.commonData:getGold()                   --目前拥有的元宝数量

    self.isTouchMember = false

    self.arenaList = self.arenaData:getArenaList()
end

--更新网络协议返回数据
function PVArenaPanel:updateData(index)
    self.curPvpStore = self.commonData:getPvpStore()
    self.myRank = self.arenaData:getRankOrder()
    self.rankNum:setString(self.myRank)
    self.scoreLabel:setString(self.curPvpStore)
    if index == 1 then
        --竞技列表初始化
        self.arenaList = self.arenaData:getArenaList()
        --获取总共挑战的次数
        -- self.useChallengeNum = self.arenaData:getChallengeNum()
        -- print("self.useChallengeNum =============== ", self.useChallengeNum)
        -- if self.useChallengeNum >= 5 then
        --     self.challengeNum:setString("0")
        --     -- self.buyMenuItem:setEnabled(true)
        -- else
        --     local leaveTimes = self.freeTime - self.useChallengeNum
        --     self.challengeNum:setString(leaveTimes)
        --     -- self.buyMenuItem:setEnabled(false)
        -- end

        -- self.commonData:setPvpStore(self.pvpScore)
        self.tableView:reloadData()
        self:tableViewItemAction(self.tableView)
        self:setOffset()
    elseif index == 2 then
        --排行列表初始化
        self.rankList = self.arenaData:getRankList()
    elseif index == 3 then
        --兑换列表初始化
        local _idsList = self.shopData:getPvpList()
        local _idsGotList = self.shopData:getPvpGotList()
        local _flashMoney, _flashType = self.shopTemp:getFlashMoney(TYPE_SHOP_PVP)
        self.labelFlashMoney:setString(_flashMoney)
        self.flashMoney = _flashMoney

        self.reputationValue:setString( self.curPvpStore )

        -- 获取商城装备数据
        self.exchangeList = {}
        for k,v in pairs(_idsList) do
            local value = self.shopTemp:getTemplateById(v)
            value.got = false
            table.insert(self.exchangeList, value)
        end
        for k,v in pairs(_idsGotList) do
            local value = self.shopTemp:getTemplateById(v)
            value.got = true
            table.insert(self.exchangeList, value)
        end

        table.sort( self.exchangeList, function (a,b) return a.id < b.id end )
    end

    if 1 == self.type then
        self.itemCount = table.nums(self.arenaList)
    elseif 2 == self.type then
        self.itemCount = table.nums(self.rankList)
    elseif 3 == self.type then
        self.itemCount = table.nums(self.exchangeList)
    end

    self.tableView:reloadData()
    self:tableViewItemAction(self.tableView)

    --初始化列表时显示限制
    if index == 1 then
        self:setOffset()
    end
end

--界面加载以及初始化
function PVArenaPanel:initView()
    self.UIArenaPanel = {}
    self:initTouchListener()
    self:loadCCBI("arena/ui_arena_panel.ccbi", self.UIArenaPanel)

    self.contentLayer = self.UIArenaPanel["UIArenaPanel"]["contentLayer"]
    self.contentLayer2 = self.UIArenaPanel["UIArenaPanel"]["contentLayer2"]
    self.commonLable = self.UIArenaPanel["UIArenaPanel"]["commonLable"]

    --竞技
    self.compSelect = self.UIArenaPanel["UIArenaPanel"]["compSelect"]
    self.compNor = self.UIArenaPanel["UIArenaPanel"]["compNor"]
    self.comMenuItem = self.UIArenaPanel["UIArenaPanel"]["comMenuItem"]
    self.compRedPoint = self.UIArenaPanel["UIArenaPanel"]["attackArenaRedPoint"]
    self.comMenuItem:setAllowScale(false)
    --排行
    self.rankSelect = self.UIArenaPanel["UIArenaPanel"]["rankSelect"]
    self.rankNor = self.UIArenaPanel["UIArenaPanel"]["rankNor"]
    self.rankMenuItem = self.UIArenaPanel["UIArenaPanel"]["rankMenuItem"]
    self.rankMenuItem:setAllowScale(false)
    --兑换
    self.exchangeSelect = self.UIArenaPanel["UIArenaPanel"]["exchangeSelect"]
    self.exchangeNor = self.UIArenaPanel["UIArenaPanel"]["exchangeNor"]
    self.exchangeMenuItem = self.UIArenaPanel["UIArenaPanel"]["exchangeMenuItem"]
    self.rewardMenuItem = self.UIArenaPanel["UIArenaPanel"]["rewardMenuItem"]
    self.rewardMenuItem:setAllowScale(false)
    --竞技层
    self.arenaLayer = self.UIArenaPanel["UIArenaPanel"]["arenaLayer"]
    self.rankNum = self.UIArenaPanel["UIArenaPanel"]["rankNum"]                             --当前排名
    self.scoreLabel = self.UIArenaPanel["UIArenaPanel"]["scoreLabel"]                       --积分
    self.challengeNum = self.UIArenaPanel["UIArenaPanel"]["challengeNum"]                   --挑战次数
    --兑换层
    self.exchangeLayer = self.UIArenaPanel["UIArenaPanel"]["exchangeLayer"]
    self.reputationValue = self.UIArenaPanel["UIArenaPanel"]["reputationValue"]             --声望
    --排行层
    self.rankContentLayer = self.UIArenaPanel["UIArenaPanel"]["rankContentLayer"]
    self.labelFlashMoney = self.UIArenaPanel["UIArenaPanel"]["gold_value"]

    --排行的layer
    self.commonLayer = self.UIArenaPanel["UIArenaPanel"]["commonLayer"]

    --竞技场的layer
    self.firstLayer = self.UIArenaPanel["UIArenaPanel"]["firstLayer"]

    --挑战次数重置次数
    self.resetValue = self.UIArenaPanel["UIArenaPanel"]["resetValue"]

    --挑战重置
    self.resetValue:setString(self.buyTimes - self.pvpResetTimes)
    self.buyMenuItem = self.UIArenaPanel["UIArenaPanel"]["buyMenuItem"]

    local leaveTimes = self.freeTime - self.challengeTimes
    self.challengeNum:setString(leaveTimes)

    if leaveTimes > 0 then
        self.buyMenuItem:setEnabled(false)
        self.compRedPoint:setVisible(true)
    else
        self.buyMenuItem:setEnabled(true)
        self.compRedPoint:setVisible(false)
    end

    --初始化部分显示
    self.comMenuItem:setEnabled(false)
    self.compNor:setVisible(false)
    self.compSelect:setVisible(true)

    self.arenaLayer:setVisible(true)
    self.exchangeLayer:setVisible(false)
    self.rankContentLayer:setVisible(false)
    self.contentLayer:setVisible(true)
    self.contentLayer2:setVisible(false)

    self.commonLable:setVisible(true)

    local _index = self.funcTable[1]  ---获取途径进来
    if _index == 3 then
        self.type = _index
        self:updateMenu(3)
        self.firstLayer:setVisible(false)
        self.commonLayer:setVisible(false)
    end
end

--界面监听事件
function PVArenaPanel:initTouchListener()
    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        cclog("onCloseClick")
        local isHave = self.freeTime - self.challengeTimes
        print("界面监听事件 -----  竞技场 ------- ", isHave)
        if isHave > 0 then
            touchNotice(ARENA_NOTICE, true)
        else
            touchNotice(ARENA_NOTICE, false)
        end
        self:onHideView()
    end
    --竞技
    local function onCompetiveClick()
        getAudioManager():playEffectPage()
        cclog("onCompetiveClick")
        self:updateMenu(1)
        self.firstLayer:setVisible(true)
        self.commonLayer:setVisible(false)
        self.commonLable:setVisible(true)
    end
    --排行
    local function onRankClick()
        getAudioManager():playEffectPage()
        cclog("onRankClick")
        self:updateMenu(2)
        self.firstLayer:setVisible(false)
        self.commonLayer:setVisible(true)
        self.commonLable:setVisible(true)
        -- self.arenaNet:sendGetRankList(ARENA_RANKLIST)
    end
    --奖励
    local function onRewardClick()
        getAudioManager():playEffectPage()
        self:updateMenu(3)
        self.firstLayer:setVisible(false)
        self.commonLayer:setVisible(true)
        self.commonLable:setVisible(false)
    end

    --兑换
    local function onExchangeClick()
        getAudioManager():playEffectPage()
        -- cclog("onExchangeClick")
        -- self.firstLayer:setVisible(false)
        -- self.commonLayer:setVisible(false)
        getModule(MODULE_NAME_HOMEPAGE):showUIView("PVArenaShop")
        groupCallBack(GuideGroupKey.BIN_EXCHANGE_IN_LEITAI)
    end
    --刷新
    local function onRefreshClick()
        getAudioManager():playEffectButton2()
        cclog("onRefreshClick")
        if self.commonData:getGold() < self.flashMoney then
            -- self:toastShow(Localize.query("shop.8"))
            getOtherModule():showAlertDialog(nil, Localize.query("shop.8"))
        else
            getNetManager():getShopNet():sendRefreshShopList(TYPE_SHOP_PVP)
        end
    end

    --重置挑战次数
    local function onBuyTimes()
        getAudioManager():playEffectButton2()

        self.pvpResetTimes = self.commonData:getPvpRefreshCount()
        local num = self.buyTimes - self.pvpResetTimes
        if num <= 0 then
            if self.viplevel < self.maxVipLevel then
                getOtherModule():showAlertDialog(nil, Localize.query("arena.2"))
            else
                getOtherModule():showAlertDialog(nil, Localize.query("arena.3"))
            end
            return
        end
        getOtherModule():showOtherView("SystemTips", "", 2 , 1)
    end

    self.UIArenaPanel["UIArenaPanel"] = {}

    self.UIArenaPanel["UIArenaPanel"]["onCloseClick"] = onCloseClick                        --关闭
    self.UIArenaPanel["UIArenaPanel"]["onCompetiveClick"] = onCompetiveClick                --竞技
    self.UIArenaPanel["UIArenaPanel"]["onRankClick"] = onRankClick                          --排行
    self.UIArenaPanel["UIArenaPanel"]["onRewardClick"] = onRewardClick                  --奖励
    self.UIArenaPanel["UIArenaPanel"]["onExchangeClick"] = onExchangeClick                  --兑换

    self.UIArenaPanel["UIArenaPanel"]["onRefreshClick"] = onRefreshClick                    --返回
    self.UIArenaPanel["UIArenaPanel"]["onBuyTimes"] = onBuyTimes                            --挑战次数重置
end

-- 切换标签
function PVArenaPanel:updateMenu(index)
    self.type = index
    self.curPvpStore = self.commonData:getPvpStore()
    if index == 1 then
        self.comMenuItem:setEnabled(false)
        self.rankMenuItem:setEnabled(true)
        self.rewardMenuItem:setEnabled(true)

        self.compNor:setVisible(false)
        self.compSelect:setVisible(true)
        self.rankNor:setVisible(true)
        self.rankSelect:setVisible(false)
        -- self.exchangeNor:setVisible(true)
        self.exchangeSelect:setVisible(false)

        self.arenaLayer:setVisible(true)
        self.exchangeLayer:setVisible(false)
        self.rankContentLayer:setVisible(false)
        self.contentLayer:setVisible(true)
        self.contentLayer2:setVisible(false)

        self.itemCount = table.nums(self.arenaList)
        self.scoreLabel:setString(self.curPvpStore)
        self:updateData(1)
    elseif index == 2 then
        self.comMenuItem:setEnabled(true)
        self.rankMenuItem:setEnabled(false)
        self.rewardMenuItem:setEnabled(true)

        self.compNor:setVisible(true)
        self.compSelect:setVisible(false)
        self.rankNor:setVisible(false)
        self.rankSelect:setVisible(true)
        -- self.exchangeNor:setVisible(true)
        self.exchangeSelect:setVisible(false)

        self.arenaLayer:setVisible(false)
        self.exchangeLayer:setVisible(false)
        self.rankContentLayer:setVisible(true)
        self.contentLayer:setVisible(false)
        self.contentLayer2:setVisible(false)

        self.itemCount = table.nums(self.rankList)

    elseif index == 3 then
        self.comMenuItem:setEnabled(true)
        self.rankMenuItem:setEnabled(true)
        self.rewardMenuItem:setEnabled(false)

        self.compNor:setVisible(true)
        self.compSelect:setVisible(false)
        self.rankNor:setVisible(true)
        self.rankSelect:setVisible(false)
        self.exchangeNor:setVisible(false)
        self.exchangeSelect:setVisible(true)

        self.arenaLayer:setVisible(false)
        self.exchangeLayer:setVisible(true)
        self.rankContentLayer:setVisible(false)
        self.contentLayer:setVisible(false)
        self.contentLayer2:setVisible(true)

        self.itemCount = table.nums(self.exchangeList)
        self.reputationValue:setString(self.curPvpStore)
    end

    self:initTableView()
    self.tableView:reloadData()
    self:tableViewItemAction(self.tableView)

    if index == 1 then
        if self.myRank ~= 0 then
            self:setOffset()
        end
    end
end

function PVArenaPanel:initTableView()
    local layerSize = nil
    if self.type == 1 then
        layerSize = self.contentLayer:getContentSize()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
        end
        self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    elseif self.type == 2 then
        layerSize = self.rankContentLayer:getContentSize()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
        end
        self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    elseif self.type == 3 then
        layerSize = self.contentLayer2:getContentSize()
        if self.tableView ~= nil then
            self.tableView:removeFromParent(true)
        end
        self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    end

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()

    if self.scrBar ~= nil then self.scrBar:removeFromParent(true) end
    self.scrBar = PVScrollBar:new()
    self.scrBar:init(self.tableView,1)
    self.scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))

    if self.type == 1 then
        self.contentLayer:addChild(self.tableView)
        self.contentLayer:addChild(self.scrBar,2)
    elseif self.type == 3 then
        self.contentLayer2:addChild(self.tableView)
        self.contentLayer2:addChild(self.scrBar,2)
        self:updateData(1)
    elseif self.type == 2 then
        self.rankContentLayer:addChild(self.tableView)
        self.rankContentLayer:addChild(self.scrBar,2)
    end


    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)


    -- self.tableView:reloadData()
    -- self:tableViewItemAction(self.tableView)
end

function PVArenaPanel:tableCellTouched(table, cell)
    -- self.clickIndex = cell:getIdx()
    -- if self.isTouchMember then
    --     if self.type == 1 then
    --         self.arenaNet:sendCheckInfo(self.arenaList[self.clickIndex + 1].rank)
    --         self.curTeamName = self.arenaList[self.clickIndex + 1].nickname
    --     elseif self.type == 2 then
    --         self.arenaNet:sendCheckInfo(self.rankList[self.clickIndex + 1].rank)
    --         self.curTeamName = self.rankList[self.clickIndex + 1].nickname
    --     end
    -- end
    -- self.isTouchMember = true

end

function PVArenaPanel:cellSizeForTable(table, idx)
    if self.type == 1 or self.type == 2 then
        return 150, 640
    elseif self.type == 3 then
        return 148, 555
    end
end

function PVArenaPanel:tableCellAtIndex(tabl, idx)

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
    local cell = tabl:dequeueCell()

    if self.type == 1 or self.type == 2 then
        cell = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            --排行中的查看方法
            local function onCheckClick()
                self.arenaNet:sendCheckInfo(self.rankList[idx + 1].rank)
                self.curTeamName = self.rankList[idx + 1].nickname
            end
            --竞技中的挑战方法
            local function onChallengeClick()
                -- self.arenaNet:sendResetChallenge()
                self.pvpResetTimes = self.commonData:getPvpRefreshCount()
                local num = self.buyTimes - self.pvpResetTimes
                if num <= 0 and self.challengeTimes >= 5 then
                    if self.viplevel < self.maxVipLevel then
                        getOtherModule():showAlertDialog(nil, Localize.query("arena.2"))
                    else
                        getOtherModule():showAlertDialog(nil, Localize.query("arena.3"))
                    end
                elseif self.challengeTimes >= 5 then
                    getOtherModule():showOtherView("SystemTips", "", 2 , 1)
                    -- getOtherModule():showOtherView("PVBuyStamina", "pvArenaPanel", Localize.query("arena.1"))
                else
                    local curRank = self.arenaList[idx + 1].rank
                    if self.myRank == 0 then
                        self.isChange = true
                    elseif self.myRank < curRank then
                        self.isChange = false
                    else
                        self.isChange = true
                    end
                    getModule(MODULE_NAME_HOMEPAGE):showUIView("PVEmbattle", curRank, "pvp")
                end
            end

            --查看阵容
            local function onLineUpClick()
                getModule(MODULE_NAME_HOMEPAGE):showUIView("PVLineUp")
            end

            --信息查看界面
            local function onCheckInfoClick()
                if self.type == 1 then

                elseif self.type == 2 then
                end
                -- self.curTeamName = self.rankList[idx + 1].nickname
                -- getOtherModule():showOtherView("PVChatCheck", rankItem.id, self.itemHeight, self.curPosY, rankItem.nickname)
            end

            cell = cc.TableViewCell:new()

            cell.UIArenaItem = {}
            cell.UIArenaItem["UIArenaItem"] = {}
            cell.UIArenaItem["UIArenaItem"]["onChallengeClick"] = onChallengeClick
            cell.UIArenaItem["UIArenaItem"]["onCheckClick"] = onCheckClick
            cell.UIArenaItem["UIArenaItem"]["onLineUpClick"] = onLineUpClick
            cell.UIArenaItem["UIArenaItem"]["onCheckInfoClick"] = onCheckInfoClick

            local proxy = cc.CCBProxy:create()
            local arenaItem = CCBReaderLoad("arena/ui_arena_item.ccbi", proxy, cell.UIArenaItem)

            cell.rankBg = cell.UIArenaItem["UIArenaItem"]["rankBg"]               --背景图
            cell.icon = cell.UIArenaItem["UIArenaItem"]["headIcon"]
            cell.comp = cell.UIArenaItem["UIArenaItem"]["comp"]                             --挑战按钮层
            cell.rank = cell.UIArenaItem["UIArenaItem"]["rank"]                             --排行按钮层
            cell.lineup = cell.UIArenaItem["UIArenaItem"]["lineup"]                             --阵容按钮层
            cell.memberLayer = cell.UIArenaItem["UIArenaItem"]["memberLayer"]               --战队成员layer
            cell.teamName = cell.UIArenaItem["UIArenaItem"]["teamName"]                     --战队名称
            cell.powerValue = cell.UIArenaItem["UIArenaItem"]["powerValue"]                 --战斗力
            cell.lvBMLabel = cell.UIArenaItem["UIArenaItem"]["lvBMLabel"]                   --战队等级
            cell.scoreValue = cell.UIArenaItem["UIArenaItem"]["scoreValue"]                 --奖励积分
            cell.rankValue = cell.UIArenaItem["UIArenaItem"]["rankValue"]                   --排名
            cell.challengeMenuItem = cell.UIArenaItem["UIArenaItem"]["challengeMenuItem"]   --挑战按钮
            cell.rankCheckMenuItem = cell.UIArenaItem["UIArenaItem"]["rankCheckMenuItem"]   --查看按钮
            cell.countSprite = cell.UIArenaItem["UIArenaItem"]["countSprite"]               --挑战倒计时界面
            cell.countDowmValue = cell.UIArenaItem["UIArenaItem"]["countDowmValue"]         --挑战倒计时
            cell.desLabel = cell.UIArenaItem["UIArenaItem"]["desLabel"]                     --奖励时间间隔
            cell.topRank = cell.UIArenaItem["UIArenaItem"]["topRank"]                       --排行

            cell.rankSprite = cell.UIArenaItem["UIArenaItem"]["rankSprite"]                 --排行标志

            cell.levelNode = cell.UIArenaItem["UIArenaItem"]["levelNode"]                   --等级node

            cell.rankSpriteBg = cell.UIArenaItem["UIArenaItem"]["rankSpriteBg"]

            cell.rankBg = cell.UIArenaItem["UIArenaItem"]["rankBg"]

            cell:addChild(arenaItem)
        end

        if self.type == 1 then
            if table.nums(self.arenaList) > 0 then
                --初始化战队成员列表头像
                if self.arenaList[idx + 1] ~= nil then
                    self:initMemberData(cell.memberLayer, self.arenaList[idx + 1].hero_ids)
                    -- 获取相关需要显示的数值
                    local teamNameValue = self.arenaList[idx + 1].nickname                                  --战队名称
                    local teamRankValue = self.arenaList[idx + 1].rank                                      --战队排名
                    local teamLevel = self.arenaList[idx + 1].level                                         --战队等级
                    local teamPowerValue = self.arenaList[idx + 1].ap                                    --战队战斗力
                    local arena_shorttime_points = self.baseTemp:getArenaShorTimePoints(teamRankValue)  --奖励积分
                    if self.myRank == teamRankValue then
                        cell.rankBg:setSpriteFrame("ui_arena_rank_1.png")
                        cell.comp:setVisible(false)
                        cell.lineup:setVisible(true)
                    else
                        cell.rankBg:setSpriteFrame("ui_arena_rank_4.png")
                        cell.comp:setVisible(true)
                        cell.lineup:setVisible(false)
                    end

                    cell.teamName:setString(teamNameValue)
                    cell.rankValue:setString("第" .. teamRankValue .. "名")
                    -- cell.lvBMLabel:setString(teamLevel)
                    cell.lvBMLabel:setVisible(false)
                    local levelNode = getLevelNode(teamLevel)
                    cell.levelNode:addChild(levelNode)
                    cell.powerValue:setString(teamPowerValue)
                    cell.desLabel:setString("每" .. self.shortTime / 60 .. "分钟奖励积分:")
                    cell.scoreValue:setString(arena_shorttime_points)
                    cell.rankSprite:setVisible(false)
                    cell.rank:setVisible(false)
                    cell.rankCheckMenuItem:setEnabled(false)
                end
            end
        elseif self.type == 2 then
            if table.nums(self.rankList) > 0 then
                self:initMemberData(cell.memberLayer, self.rankList[idx + 1].hero_ids)

                -- 获取相关需要显示的数值
                local teamNameValue = self.rankList[idx + 1].nickname                                   --战队名称
                local teamRankValue = self.rankList[idx + 1].rank                                       --战队排名
                local teamLevel = self.rankList[idx + 1].level                                          --战队等级
                local teamPowerValue = self.rankList[idx + 1].ap                                        --战队战斗力
                local arena_shorttime_points = self.baseTemp:getArenaShorTimePoints(teamRankValue)      --奖励积分
                if teamRankValue == 1 then
                    cell.rankValue:setVisible(false)
                    cell.topRank:setVisible(true)
                    cell.rankSprite:setVisible(true)
                    cell.rankSprite:setSpriteFrame("ui_arena_rank1.png")
                    cell.rankSpriteBg:setSpriteFrame("ui_arena_rank_b1.png")
                    cell.rankBg:setSpriteFrame("ui_arena_rank_1.png")
                elseif teamRankValue == 2 then
                    cell.rankValue:setVisible(false)
                    cell.topRank:setVisible(true)
                    cell.rankSprite:setVisible(true)
                    cell.rankSprite:setSpriteFrame("ui_arena_rank2.png")
                    cell.rankSpriteBg:setSpriteFrame("ui_arena_rank_b2.png")
                    cell.rankBg:setSpriteFrame("ui_arena_rank_2.png")
                elseif teamRankValue == 3 then
                    cell.rankValue:setVisible(false)
                    cell.topRank:setVisible(true)
                    cell.rankSprite:setVisible(true)
                    cell.rankSprite:setSpriteFrame("ui_arena_rank3.png")
                    cell.rankSpriteBg:setSpriteFrame("ui_arena_rank_b3.png")
                    cell.rankBg:setSpriteFrame("ui_arena_rank_3.png")
                else
                    cell.topRank:setVisible(false)
                    cell.rankSprite:setVisible(false)
                    cell.rankBg:setSpriteFrame("ui_arena_rank_4.png")
                end
                cell.teamName:setString(teamNameValue)
                cell.rankValue:setString("第" .. teamRankValue .. "名")
                -- cell.lvBMLabel:setString(teamLevel)
                cell.lvBMLabel:setVisible(false)
                local levelNode = getLevelNode(teamLevel)
                cell.levelNode:addChild(levelNode)
                cell.powerValue:setString(teamPowerValue)
                cell.desLabel:setString("每" .. self.shortTime / 60 .. "分钟奖励积分:")
                cell.scoreValue:setString(arena_shorttime_points)

                cell.comp:setVisible(false)
                cell.rank:setVisible(true)
                cell.rankCheckMenuItem:setEnabled(true)
            end
        end
    elseif self.type == 3 then
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function onBuyMenuClick()
                self.isRefresh = true
                local id = self.exchangeList[cell:getIdx()+1].id
                self.buyGoodsId = id
                self.useMoney = tonumber(cell.labelMoney:getString())
                if self.curPvpStore >= self.useMoney then
                    self.shopNet:sendBuyGoods(id)
                else
                    -- self:toastShow(Localize.query("shop.15"))
                    getOtherModule():showAlertDialog(nil, Localize.query("shop.15"))
                end
            end

            local function onItemClick()
                self.isRefresh = false
                local soulData = self.exchangeList[cell:getIdx()+1]
                cclog("------兑换列表初始化---------")

                local gainData = soulData.gain
                local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
                local gainValue = table.getValueByIndex(gainData, 1)
                checkCommonDetail(gainKey, gainValue[3])
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UISecretShopItem"] = {}
            cell.cardinfo["UISecretShopItem"]["onChangeClick"] = onBuyMenuClick
            cell.cardinfo["UISecretShopItem"]["onItemClick"] = onItemClick
            local node = CCBReaderLoad("arena/ui_shop_item.ccbi", proxy, cell.cardinfo)

            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UISecretShopItem"]["headIcon"]
            cell.equipName = cell.cardinfo["UISecretShopItem"]["equipName"]
            cell.imgHalf = cell.cardinfo["UISecretShopItem"]["img_half"]
            cell.labelMoney = cell.cardinfo["UISecretShopItem"]["money_value"]
            cell.menuBuy = cell.cardinfo["UISecretShopItem"]["menu_buy"]
            cell.labelNum = cell.cardinfo["UISecretShopItem"]["label_num"]

            cell:addChild(node)
        end
        cell.index = idx
        -- 获取数据中的值

        local soulData = self.exchangeList[idx+1]
        cclog("------兑换列表初始化---------")

        local gainData = soulData.gain
        local gainKey = tonumber(table.getKeyByIndex(gainData, 1))
        local gainValue = table.getValueByIndex(gainData, 1)
        setCommonDrop(gainKey, gainValue[3], cell.icon, cell.equipName)

        local consumeData = soulData.consume
        local useMoney = table.getValueByIndex(consumeData, 1)[1]
        local discout = soulData.discountPrice
        if table.nums(discout) ~= 0 then cell.imgHalf:setVisible(true); useMoney = useMoney / 2
        else cell.imgHalf:setVisible(false)
        end

        cell.labelMoney:setString(useMoney)
        cell.labelNum:setString(tostring("x "..gainValue[1]))

        if soulData.got then
            cell.menuBuy:setEnabled(false)
            cell.menuBuy:setSelectedImage(game.newSprite("#ui_shop_s_gotit.png"))
        else
            cell.menuBuy:setEnabled(true)
            cell.menuBuy:setSelectedImage(game.newSprite("#ui_soul_s_dh.png"))
        end
    end

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
    return cell
end

function PVArenaPanel:numberOfCellsInTableView(table)
    return self.itemCount
end

--初始化每个cell中的战队成员头像列表
function PVArenaPanel:initMemberData(itemLayer, meberItemList)
    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()

    local memberItemCount = table.getn(meberItemList)

    function tableCellTouched(table, cell)
        self.isTouchMember = true
    end

    function cellSizeForTable(table, idx)
        return 50, 63
    end

    function tableCellAtIndex(tabl, idx)
        local curCell = tabl:dequeueCell()
        if nil == curCell then
            curCell = cc.TableViewCell:new()

            curCell.UIArenaMemberItem = {}
            curCell.UIArenaMemberItem["UIArenaMemberItem"] = {}

            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("arena/ui_arena_small_item.ccbi", proxy, curCell.UIArenaMemberItem)

            curCell.itemSprite = curCell.UIArenaMemberItem["UIArenaMemberItem"]["itemSprite"]                     --英雄头像
            self.sizeLayer = curCell.UIArenaMemberItem["UIArenaMemberItem"]["sizeLayer"]
            curCell.itemSprite:setScale(0.5)
            curCell:addChild(node)
        end
        if table.getn(meberItemList) > 0 then
            local hero_id = meberItemList[idx + 1]
            local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(hero_id)
            local quality = soldierTemplateItem.quality
            local resIcon = self.c_SoldierTemplate:getSoldierIcon(hero_id)
            changeNewIconImage(curCell.itemSprite, resIcon, quality) --更新icon
        end

        return curCell
    end

    function numberOfCellsInTableView(tabl)
        self.isTouchMember = false
        return memberItemCount
    end

    local layerSize = itemLayer:getContentSize()
    self.memberTableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    self.memberTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.memberTableView:setPosition(cc.p(-20, 0))
    self.memberTableView:setDelegate()
    itemLayer:addChild(self.memberTableView)

    self.memberTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.memberTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.memberTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.memberTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.memberTableView:reloadData()
end

function PVArenaPanel:onReloadView()
    cclog("--PVArenaPanel:onReloadView--")
    if COMMON_TIPS_BOOL_RETURN == true then
        -- 发送协议
        self.arenaNet:sendResetChallenge()

        COMMON_TIPS_BOOL_RETURN = false
    end
    if self.type == 1 and PVP_WIN then
        if self.isChange then
            self.arenaNet:sendGetArenaList()
        end
    end
    if self.type == 3 then
        if self.isRefresh then
            self.shopNet:sendGetShopList(TYPE_SHOP_PVP)
        end
    end
    --
    self.challengeTimes = self.commonData:getPvpTimes()
    local leaveTimes = self.freeTime - self.challengeTimes
    self.challengeNum:setString(leaveTimes)
    if leaveTimes <= 0 then
        self.buyMenuItem:setEnabled(true)
        self.compRedPoint:setVisible(false)
    end
end

--初始化显示设置
function PVArenaPanel:setOffset()
    local showIndex = 0
    for k,v in pairs(self.arenaList) do
        if self.myRank == v.rank then
            showIndex = k
        end
    end
    local totalCount = table.getn(self.arenaList)
    local _offSet = self.tableView:getContentOffset()

    local tag = showIndex - totalCount + 4
    if tag <= 0 and showIndex ~= 1 then
        _offSet.y = (showIndex - totalCount + 4) * 100
    end

    if showIndex == totalCount then
        _offSet.y = 0
    end
    self.tableView:setContentOffset(cc.p(_offSet.x, (0)))
end

function PVArenaPanel:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_arena.plist")
end

return PVArenaPanel
