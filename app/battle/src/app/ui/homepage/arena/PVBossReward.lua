require("src.app.ui.homepage.arena.PVBossRankParticle")

local PVBossReward = class("PVBossReward", BaseUIView)

function PVBossReward:ctor(id)
    self.super.ctor(self, id)

end

function PVBossReward:onMVCEnter()
    --加载相关plist文件
    game.addSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")
    self:registerDataBack()

    self.c_commonData = getDataManager():getCommonData()
    self.c_bossData = getDataManager():getBossData()
    self.c_bossNet = getNetManager():getBossNet()
    self.c_stageTemp = getTemplateManager():getInstanceTemplate()
    self.c_baseTemplate = getTemplateManager():getBaseTemplate()
    self.c_mailTemplate = getTemplateManager():getMailTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()

    self._resourceTemp = getTemplateManager():getResourceTemplate()

    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()

    self.dropTemplate = getTemplateManager():getDropTemplate()

    self:initData()
    self:initView()

end

--网络返回
function PVBossReward:registerDataBack()
end

function PVBossReward:addEffect( )
    -- local node = UI_Dengjipaihangbiankuang()
    -- self:addChild(node, 40)
end


--相关数据初始化
function PVBossReward:initData()
    --排名奖励(mail)
    local rewardList = self.c_baseTemplate:getRewardList()
    --击杀奖励(mail)
    local killReward = self.c_baseTemplate:getKillReward()
    --参与奖励(直接可以获取资源)
    local partReward = self.c_baseTemplate:getPartReward()
    --最后击杀
    local killDropId = nil
    local rewardsMail = self.c_mailTemplate:getMailGainById(killReward)
    for k, v in pairs(rewardsMail) do
        killDropId = v[3]
    end

    self.dropList = {}
    for k,v in pairs(rewardList) do
        local dropItem = {}
        local rewards = self.c_mailTemplate:getMailGainById(v[3])
        dropItem.pos = v[3]
        for m, n in pairs(rewards) do
            dropItem.dropId = n[3]
        end
        table.insert(self.dropList, dropItem)
    end

    local dropKillItem = {}
    dropKillItem.pos = 12
    dropKillItem.dropId = killDropId
    table.insert(self.dropList, dropKillItem)

    self.bossRewards = {}
    for k, v in pairs(self.dropList) do
        local rewardItem = {}
        local smallBags = self.dropTemplate:getSmallBagIds(v.dropId)
        rewardItem.smallBagItems = smallBags
        rewardItem.rewardPos = v.pos
        table.insert(self.bossRewards, rewardItem)
    end

    self.lastRewardList = {}
    for k,v in pairs(self.bossRewards) do
        local rewardItem = {}
        local smallBagItemList = {}
        for m, n in pairs(v.smallBagItems) do
            smallBagItemList[m] = self.dropTemplate:getAllItemsByDropId(n)
        end
        rewardItem.itemList = smallBagItemList
        rewardItem.soldierPos = v.rewardPos
        table.insert(self.lastRewardList, rewardItem)
    end

    local partItem = {}
    partItem.soldierPos = 13
    partItem.itemList = {}
    for k,v in pairs(partReward) do
        local part = {}
        local item = {}
        item.type = v
        item.count = 0
        item.detailId = v

        table.insert(part, item)
        table.insert(partItem.itemList, part)
    end

    table.insert(self.lastRewardList, partItem)

    self.itemCount = table.getn(self.lastRewardList)

    if self.lastRewardList ~= nil then
        local function mySort(item1, item2)
            return item1.soldierPos < item2.soldierPos
        end
        table.sort(self.lastRewardList, mySort)
        return self.lastRewardList
    end

end

--界面加载以及初始化
function PVBossReward:initView()
    self.UIBossRewardView = {}
    self:initTouchListener()
    self:loadCCBI("boss/ui_boss_reward.ccbi", self.UIBossRewardView)

    self.bagContentLayer = self.UIBossRewardView["UIBossRewardView"]["bagContentLayer"]

    self:initTable()
    self:addEffect()
end

--界面监听事件
function PVBossReward:initTouchListener()
    --返回
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    self.UIBossRewardView["UIBossRewardView"] = {}

    self.UIBossRewardView["UIBossRewardView"]["onCloseClick"] = onCloseClick                          --关闭
end

function PVBossReward:initTable()
    local layerSize = self.bagContentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()

    self.bagContentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.bagContentLayer:addChild(scrBar,2)

    self.tableView:reloadData()
end

function PVBossReward:tableCellTouched(table, cell)
end

function PVBossReward:cellSizeForTable(table, idx)
    if idx <= 2 then
        return 220, 640
    else
        return 170,640
    end
end

function PVBossReward:tableCellAtIndex(tabl, idx)
    local curCell = nil
    if nil == curCell then
        curCell = cc.TableViewCell:new()

        curCell.UIRewardItem = {}
        curCell.UIRewardItem["UIRewardItem"] = {}

        local proxy = cc.CCBProxy:create()
        local node = CCBReaderLoad("boss/ui_reward_item.ccbi", proxy, curCell.UIRewardItem)

        curCell.nameLabel = curCell.UIRewardItem["UIRewardItem"]["nameLabel"]
        curCell.rewardLayer = curCell.UIRewardItem["UIRewardItem"]["rewardLayer"]

        curCell.rewardItemType1 = curCell.UIRewardItem["UIRewardItem"]["rewardItemType1"]
        curCell.rewardItemType2 = curCell.UIRewardItem["UIRewardItem"]["rewardItemType2"]
        curCell.rewardType = curCell.UIRewardItem["UIRewardItem"]["rewardType"]
        curCell.rewardItemType2_Num = curCell.UIRewardItem["UIRewardItem"]["rewardItemType2_Num"]
        curCell.rewardType1_Num = curCell.UIRewardItem["UIRewardItem"]["rewardType1_Num"]
        curCell.rewardItemType1Bar = curCell.UIRewardItem["UIRewardItem"]["rewardItemType1Bar"]
        curCell.index = idx

        curCell:addChild(node)
    end

    -- if idx == 0 then 
    --     local node = UI_Dengjipaihangbiankuang_first()
    --     curCell:addChild(node)
    -- end
    local ParticleTag = 10000

   curCell:removeChildByTag(ParticleTag,true)

    if idx == 0 then
        local node1 = UI_Dengjipaihangbiankuang_first()
        curCell:addChild(node1,40,ParticleTag)
    elseif idx == 1 then
        local node1 = UI_Dengjipaihangbiankuang_second()
        curCell:addChild(node1,40,ParticleTag)
    elseif idx == 2 then
        local node1 = UI_Dengjipaihangbiankuang_third()
        curCell:addChild(node1,40,ParticleTag)
    end

    if table.getn(self.lastRewardList) > 0 then
        local itemList = self.lastRewardList[idx + 1].itemList
        local pos = self.lastRewardList[idx + 1].soldierPos
        local part = nil
        if pos <= 4 then
            curCell.rewardItemType1:setVisible(true);
            curCell.rewardItemType2:setVisible(false);
            game.setSpriteFrame(curCell.rewardType1_Num,"#ui_boss_rank_reward_"..(pos - 1)..".png")
            
            local barRes = {"#ui_boss_linebar_gold.png","#ui_boss_linebar_silver.png","#ui_boss_linebar_copper.png"}
            game.setSpriteFrame(curCell.rewardItemType1Bar,barRes[pos-1])
        else
            curCell.rewardItemType2:setVisible(true);
            curCell.rewardItemType1:setVisible(false);

            curCell.rewardItemType2_Num:setVisible(false)
            if pos == 12 then
                game.setSpriteFrame(curCell.rewardType,"#ui_boss_reward_type2.png")
                -- curCell.nameLabel:setString("斩杀奖励")
            elseif pos == 13 then
                game.setSpriteFrame(curCell.rewardType,"#ui_boss_reward_type3.png")
                -- curCell.nameLabel:setString("参与奖励")
                part = 1
            else
                curCell.rewardItemType2_Num:setVisible(true)
                game.setSpriteFrame(curCell.rewardItemType2_Num,"#ui_boss_rank_reward_"..(pos - 1)..".png")
                game.setSpriteFrame(curCell.rewardType,"#ui_boss_rank_reward_name.png")
                -- curCell.nameLabel:setString("第" .. pos - 1 .. "名奖励")
            end
        end
        self:initMemberData(curCell.rewardLayer, itemList,part)
    end

    return curCell
end

function PVBossReward:numberOfCellsInTableView(table)
    return self.itemCount
end

--幸运武将的头像列表
function PVBossReward:initMemberData(itemLayer, meberItemList, part)
    local memberItemCount = table.getn(meberItemList)
    print("initMemberData ======= initMemberData ")
    table.print(meberItemList)
    function tableCellTouched(table, cell)
        local index = cell:getIdx()

        local v = {}
        for k,n in pairs(meberItemList[index + 1]) do
            v = n
        end
        checkCommonDetail(v.type, v.detailId)
    end

    function cellSizeForTable(table, idx)
        return 90, 110
    end

    function tableCellAtIndex(tabl, idx)
        print("idx ====================== ", idx)
        local curCell = tabl:dequeueCell()
        if nil == curCell then
            curCell = cc.TableViewCell:new()

            curCell.UICommonGetCard = {}
            curCell.UICommonGetCard["UICommonGetCard"] = {}

            local proxy = cc.CCBProxy:create()
            local node = CCBReaderLoad("common/ui_card_withnumber.ccbi", proxy, curCell.UICommonGetCard)
            -- local node = CCBReaderLoad("arena/ui_arena_small_item.ccbi", proxy, curCell.UIArenaMemberItem)

            curCell.itemLayer = curCell.UICommonGetCard["UICommonGetCard"]["itemLayer"]
            -- curCell.itemLayer:setScale(1)
            curCell.img_card = curCell.UICommonGetCard["UICommonGetCard"]["img_card"]
            curCell.label_number = curCell.UICommonGetCard["UICommonGetCard"]["label_number"]
            curCell:addChild(node)
        end


        if table.getn(meberItemList) > 0 then
            local v = {}
            for k,n in pairs(meberItemList[idx + 1]) do
                v = n
            end
            setCommonDrop(v.type, v.detailId, curCell.img_card, nil)
           
            if part ~= nil then
                curCell.label_number:setString("")
            else
                 if v.count <= 10000 then
                    curCell.label_number:setString(" X " .. v.count)
                elseif v.count >= 100000 then
                    local num = v.count / 100000
                    curCell.label_number:setString(" X " .. num .. "万")
                end
                -- curCell.label_number:setString("X "..tostring(v.count))
            end
        end

        return curCell
    end

    function numberOfCellsInTableView(tabl)
        return memberItemCount
    end

    local layerSize = itemLayer:getContentSize()
    self.memberTableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))
    self.memberTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.memberTableView:setPosition(cc.p(10, 0))
    self.memberTableView:setDelegate()
    itemLayer:addChild(self.memberTableView)

    self.memberTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.memberTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.memberTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.memberTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.memberTableView:reloadData()
end

function PVBossReward:removeScheduler1()
    if self.scheduer1 ~= nil then
        timer.unscheduleGlobal(self.scheduer1)
        self.scheduer1 = nil
    end
end

function PVBossReward:clearResource()
end

return PVBossReward
