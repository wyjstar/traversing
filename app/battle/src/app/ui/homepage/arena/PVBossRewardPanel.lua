local PVBossRewardPanel = class("PVBossRewardPanel", BaseUIView)

function PVBossRewardPanel:ctor(id)
    self.super.ctor(self, id)

end

function PVBossRewardPanel:onMVCEnter()
    --加载相关plist文件
    game.addSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")

    self.c_bossData = getDataManager():getBossData()
    
    self:initData()
    self:initView()

end

function PVBossRewardPanel:initData()
    self.rewardData = self.c_bossData:getRewardInfo()

    local gain = self.rewardData.gain
    local heroCount = gain.heros and #gain.heros or 0   --武将的个数
    self.dropItems = {}
    if heroCount >0  then
        for k,v in pairs(gain.heros) do 
            table.insert(self.dropItems,{type=RES_TYPE_HERO,count=1,detailId=v.hero_no})
        end
    end
    local equipCount = gain.equipments and #gain.equipments or 0 --装备的个数
    if equipCount > 0 then
        for k,v in pairs(gain.equipments) do 
            table.insert(self.dropItems,{type=RES_TYPE_EQUIP,count=1,detailId=v.id})
        end
    end

    local itemsCount = gain.items and #gain.items or 0 --Item 个数
    
    if itemsCount > 0 then
        for k,v in pairs(gain.items) do 
            table.insert(self.dropItems,{type=RES_TYPE_ITEM_CHIP,count=v.item_num,detailId=v.item_no})
        end
    end

    local heroChipCount = gain.hero_chips and #gain.hero_chips or 0
    if heroChipCount > 0 then
        for k,v in pairs(gain.hero_chips) do 
            table.insert(self.dropItems,{type=RES_TYPE_HERO_CHIP,count=v.hero_chip_num,detailId=v.hero_chip_no})
        end
    end

    local equipChipCount = gain.equipment_chips and #gain.equipment_chips or 0
    if equipChipCount > 0 then
        for k,v in pairs(gain.equipment_chips) do 
            table.insert(self.dropItems,{type=RES_TYPE_EQUIP_CHIP,count=v.equipment_chip_num,detailId=v.equipment_chip_no})
        end
    end

    local financeCount = gain.finance.finance_changes and #gain.finance.finance_changes or 0

    if financeCount > 0 then
        for k,v in pairs(gain.finance.finance_changes) do
            if v.item_no ~= nil then
                table.insert(self.dropItems,{type = v.item_type, detailId = v.item_no, count = v.item_num})
            end
        end
    end

    table.print(self.dropItems)
end

--界面加载以及初始化
function PVBossRewardPanel:initView()
    self.shieldlayer = game.createShieldLayer()
    self.shieldlayer:setTouchEnabled(true)

    self:addChild(self.shieldlayer)

    self.UICommonGetCard = {}
    self:initTouchListener()

    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("boss/ui_boss_get_reward.ccbi", proxy,  self.UICommonGetCard)

    self:addChild(node,2)

    self.titleSp = self.UICommonGetCard["UICommonGetCard"]["titleSp"]                                     --标题
    self.contentLayer = self.UICommonGetCard["UICommonGetCard"]["contentLayer"]                                 --内容

    -- 奖励类型:排行奖1, 累积奖励2, 最后击杀3, 参与奖4
    local titleRes = {"#ui_boss_reward_title_rank.png","#ui_boss_reward_title_hurt.png","#ui_boss_reward_title_kill.png","#ui_boss_reward_title_part.png"}
    
    game.setSpriteFrame(self.titleSp,titleRes[self.rewardData.award_type])

    self:createTableView()
end

--界面监听事件
function PVBossRewardPanel:initTouchListener()
    --返回
    local function onSureClick()
        local event = cc.EventCustom:new("NextReward")
        self:getEventDispatcher():dispatchEvent(event)
        self:onHideView()

    end

    self.UICommonGetCard["UICommonGetCard"] = {}

    self.UICommonGetCard["UICommonGetCard"]["onSureClick"] = onSureClick                          --关闭
end

function PVBossRewardPanel:createTableView()
    self.dropItemsCount = #self.dropItems
    print(self.dropItemsCount,"self.dropItemsCount")
    local function numberOfCellsInTableView(tab)
        return self.dropItemsCount
    end
    local function cellSizeForTable(tbl, idx)
        return 90, 110
    end

    local function tableCellAtIndex(tabl, idx)
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


        if table.getn(self.dropItems) > 0 then
            local v = self.dropItems[idx + 1]

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
            end
        end

        return curCell
    end

    local function tableCellTouched(tbl, cell)
        local index = cell:getIdx()
        local v = self.dropItems[idx + 1]
        checkCommonDetail(v.type, v.detailId)
    end

    local layerSize = self.contentLayer:getContentSize()
    self.contentLayer:removeAllChildren()

    self.dropTableView = cc.TableView:create(layerSize)    -- 剧情列表
    self.dropTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.dropTableView:setDelegate()
    self.dropTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.dropTableView)

    self.dropTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.dropTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.dropTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.dropTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.dropTableView:reloadData()
end

return PVBossRewardPanel
