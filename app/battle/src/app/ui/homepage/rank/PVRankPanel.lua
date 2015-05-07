local CustomLabelMenu = import("....util.CustomLabelMenu")
local CustomLabelItem = import("....util.CustomLabelItem")
local PVRankPowerItem = import(".PVRankPowerItem")

local PVRankPanel = class("PVRankPanel", BaseUIView)

function PVRankPanel:ctor(id)
    PVRankPanel.super.ctor(self, id)
    self.rankData = getDataManager():getRankData()
    self.rankNet = getNetManager():getRankNet()
end

function PVRankPanel:onMVCEnter()
    self.curType = 1               --当前排行的类型标记
    self:registerDataBack()
    -- self:initData()

    self:initView()
    self:initTableView()
    self.curPage = 1
    self.secondStar = 11            --第二页请求排行起始点
    self.requestRankNums = 6        --第二次请求的排行数
    self.isTopChange = 1            --1是没变 2变化 前三名是否需要重新赋值
end

--网络协议返回接口
function PVRankPanel:registerDataBack()
    local function getRankListCallBak(id, data)
        print("data.res.result =====getRankListCallBak  ", data.res.result)
        if data.res.result then
            self:updateData()
        end
    end
    self:registerMsg(RANK_LIST, getRankListCallBak)
end

function PVRankPanel:updateData()
    local totalNums = 0
    self.curRankList = {}
    self.rankList = self.rankData:getRankList(self.curType)
    if self.rankList ~= nil then
        if self.isTopChange == 1 then
            self.topRankList = self.rankData:getTopList(self.curType)
            self.myRankInfo = self.rankData:getMyRankInfo()
            --总共的排行数
            totalNums = self.rankData:getRankNums()
            if totalNums <= 3 then
                self.totalPage = 0
                self.curPage = 0
            else
                 self.curPage = 1
                self.totalPage = math.ceil((totalNums - 3) / self.requestRankNums)
            end
            for k,v in pairs(self.rankList) do
                if k > 3 and v ~= nil then
                    table.insert(self.curRankList, v)
                end
            end
        else
            self.curRankList = self.rankList
        end
    end

    self.pageNum:setString(self.curPage .. "/" .. self.totalPage)
    self:updateMainView()
end

--界面相关内容初始化
function PVRankPanel:initView()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_rank.plist")

    self.UIRankPanel = {}
    self:initTouchListener()
    self:loadCCBI("rank/ui_rank_panel.ccbi", self.UIRankPanel)

    self.rankLayer = {}

    self.rankLayer[1] = self.UIRankPanel["UIRankPanel"]["rankLayer1"]
    self.rankLayer[2] = self.UIRankPanel["UIRankPanel"]["rankLayer2"]
    self.rankLayer[3] = self.UIRankPanel["UIRankPanel"]["rankLayer3"]
    self.commonRankLayer = self.UIRankPanel["UIRankPanel"]["commonRankLayer"]
    self.pageNum = self.UIRankPanel["UIRankPanel"]["pageNum"]                   --页数
    self.myRank = self.UIRankPanel["UIRankPanel"]["myRank"]                     --我的排名
    self.changeNum = self.UIRankPanel["UIRankPanel"]["changeNum"]               --我的排名变化
    self.changeSprite = self.UIRankPanel["UIRankPanel"]["changeSprite"]         --变化状态
    self.heroLevel = self.UIRankPanel["UIRankPanel"]["heroLevel"]               --我的等级
    self.powerNum = self.UIRankPanel["UIRankPanel"]["powerNum"]                 --我的战力

    --标签父类
    self.labelMenu = CustomLabelMenu.new(self.UIRankPanel["UIRankPanel"]["totalLayer"])
    --战力
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIRankPanel["UIRankPanel"]["powerNode"], function()
        self:onChangeMenuClick(1)
    end))
    --星级
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIRankPanel["UIRankPanel"]["starNode"], function()
        self:onChangeMenuClick(2)
    end))
    --等级
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIRankPanel["UIRankPanel"]["levelNode"], function()
        self:onChangeMenuClick(3)
    end))

    self.labelMenu:changeLabel(1)

    self:nodeRegisterTouchEvent()
    self:updateMainView()
end

function PVRankPanel:updateMainView()
    if self.topRankList ~= nil then
        local topRanks = {}
        for k,v in pairs(self.topRankList) do
            topRanks[k] = PVRankPowerItem.new(self.curType, k, v)
            print("topRanks[k] ======== ", topRanks[k])
            if topRanks[k] ~= nil then
                self.rankLayer[k]:removeAllChildren()
                self.rankLayer[k]:addChild(topRanks[k])
            end
        end
    end

    if self.myRankInfo ~= nil then
        local myCurRank = self.myRankInfo.rank
        local last_rank = self.myRankInfo.last_rank
        self.myRank:setString(myCurRank)
        self.changeNum:setString(myCurRank - last_rank)                             --我的排名变化
        if myCurRank - last_rank > 0 then
            self.changeSprite:setSpriteFrame("ui_common_green_arr.png")
        elseif myCurRank - last_rank == 0 then
            self.changeSprite:setSpriteFrame("ui_common_nochange.png")
        elseif myCurRank - last_rank < 0 then
            self.changeSprite:setSpriteFrame("ui_common_red_arr.png")
        end
        local levelNode = getLevelNode(self.myRankInfo.level)
        self.heroLevel:addChild(levelNode)
        self.powerNum:setString(self.myRankInfo.fight_power)
    end
    if self.tableView ~= nil then
        self.tableView:reloadData()
        self:tableViewItemAction(self.tableView)
    end
end

function PVRankPanel:initTouchListener()
    --关闭
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    --上一页
    local function onLastPageClick()
        getAudioManager():playEffectButton2()
        self.isTopChange = 0
        print("上一页 ======= ")
        if self.curPage > 1 then
            local curStarRankNum =  (self.curPage - 2) * self.requestRankNums + self.secondStar
            print("curStarRankNum ============ ", curStarRankNum)
            local prePage = self.curPage - 1                              --点击上一页按钮之后的页码
            if prePage == 1 then
                self.rankNet:sendGetRankList(4, 10, self.curType)
            else
                -- local firstNo = curStarRankNum - (self.curPage - 2) * self.requestRankNums
                local firstNo = curStarRankNum - self.requestRankNums

                print("firstNo ========== ", firstNo)

                local lastNo = firstNo + self.requestRankNums
                print("lastNo ========== ", lastNo)
                self.rankNet:sendGetRankList(firstNo, lastNo, self.curType)
            end
            self.curPage = prePage
        else
            getOtherModule():showAlertDialog(nil, "已经是第一页了")
        end
    end

    --下一页
    local function onNextPageClick()
        getAudioManager():playEffectButton2()
        self.isTopChange = 0
        if self.curPage >= self.totalPage then
            getOtherModule():showAlertDialog(nil, "已经是最后一页了")
        else
            local nextPage = self.curPage + 1
            local firstNo = (nextPage - 2) * self.requestRankNums + self.secondStar
            local lastNo = firstNo + self.requestRankNums
            self.rankNet:sendGetRankList(firstNo, lastNo, self.curType)

            self.curPage = nextPage
        end

    end

    self.UIRankPanel["UIRankPanel"] = {}
    self.UIRankPanel["UIRankPanel"]["onCloseClick"] = onCloseClick
    self.UIRankPanel["UIRankPanel"]["onNextPageClick"] = onNextPageClick
    self.UIRankPanel["UIRankPanel"]["onLastPageClick"] = onLastPageClick
end

function PVRankPanel:onChangeMenuClick(index)
    self.curType = index
    self.isTopChange = 1
    self.curPage = 1
    getDataManager():getRankData():setCurType(self.curType)
    self.rankNet:sendGetRankList(1, 10, self.curType)
end

function PVRankPanel:initTableView()
    local layerSize = self.commonRankLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.commonRankLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    -- local scrBar = PVScrollBar:new()
    -- scrBar:init(self.tableView,1)
    -- scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    -- self.commonRankLayer:addChild(scrBar,2)

end

function PVRankPanel:tableCellTouched(table, cell)
    local index = cell:getIdx()
    local rankItem = self.curRankList[index + 1]
    print("rankItem.id =========== ", rankItem.id)
    print("rankItem.nickname ========== ", rankItem.nickname)
    getOtherModule():showOtherView("PVChatCheck", rankItem.id, self.itemHeight, self.curPosY, rankItem.nickname)
end

function PVRankPanel:cellSizeForTable(table, idx)
    self.itemHeight = 62
    return 62, 640
end

function PVRankPanel:tableCellAtIndex(tbl, idx)
    local cell = tbl:dequeueCell()

    if self.curType == 1 or self.curType == 3 then
        cell = nil
        if cell == nil then
            cell = cc.TableViewCell:new()

            cell.UIRankItem1 = {}

            local proxy = cc.CCBProxy:create()
            local arenaItem = CCBReaderLoad("rank/ui_rankItem1.ccbi", proxy, cell.UIRankItem1)

            cell.rankNum = cell.UIRankItem1["UIRankItem1"]["rankNum"]                       --排名
            cell.playerName = cell.UIRankItem1["UIRankItem1"]["playerName"]           --玩家名称
            cell.heroLevel = cell.UIRankItem1["UIRankItem1"]["heroLevel"]                   --玩家等级
            cell.powerNum = cell.UIRankItem1["UIRankItem1"]["powerNum"]                     --玩家战力

            cell:addChild(arenaItem)
        end
        if table.getn(self.curRankList) > 0 then
            local rankItem = self.curRankList[idx + 1]
            --排名
            local rankNode = getLevelNode(rankItem.rank)
            cell.rankNum:addChild(rankNode)
            --玩家名称
            cell.playerName:setString(rankItem.nickname)
            --玩家等级
            local heroLevelNode = getLevelNode(rankItem.level)
            cell.heroLevel:addChild(heroLevelNode)
            --玩家战斗力
            cell.powerNum:setString(rankItem.fight_power)
        end
    elseif self.curType == 2 then
        cell = nil
        if nil == cell then
            cell = cc.TableViewCell:new()

            cell.UIRankItem2 = {}

            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("rank/ui_rankItem2.ccbi", proxy, cell.UIRankItem2)

            -- 获取Item上的控件
            cell.rankNum = cell.UIRankItem2["UIRankItem2"]["rankNum"]
            cell.playerName = cell.UIRankItem2["UIRankItem2"]["playerName"]                 --玩家名称
            cell.heroLevel = cell.UIRankItem2["UIRankItem2"]["heroLevel"]                   --玩家等级
            cell.starNum = cell.UIRankItem2["UIRankItem2"]["starNum"]                       --玩家星级
            cell.stageState = cell.UIRankItem2["UIRankItem2"]["stageState"]                 --关卡进度

            cell:addChild(node)
        end

        if table.nums(self.curRankList) > 0 then
            local starRankItem = self.curRankList[idx + 1]
            --排名
            local rankNode = getLevelNode(starRankItem.rank)
            cell.rankNum:addChild(rankNode)
            --玩家名称
            cell.playerName:setString(starRankItem.nickname)
            --玩家等级
            local heroLevelNode = getLevelNode(starRankItem.level)
            cell.heroLevel:addChild(heroLevelNode)
            --玩家战斗力
            cell.starNum:setString(starRankItem.star_num)

            local _chapterNo, _stageNo = getTemplateManager():getInstanceTemplate():getIndexofStage(starRankItem.stage_id)
            cell.stageState:setString(_chapterNo .. "-" .. _stageNo)
        end
    end

    return cell
end

function PVRankPanel:numberOfCellsInTableView(tab)
   return table.getn(self.curRankList)
end

function PVRankPanel:nodeRegisterTouchEvent()
    local posX, posY = self.commonRankLayer:getPosition()

    local function onTouchEvent(eventType, x, y)

        pos = self.commonRankLayer:convertToNodeSpace(cc.p(x,y))
        self.curPosY = math.round(pos.y)
    end
    self.commonRankLayer:registerScriptTouchHandler(onTouchEvent)
    self.commonRankLayer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.commonRankLayer:setTouchEnabled(true)
end

--界面返回更新回调
function PVRankPanel:onReloadView()
end

return PVRankPanel
