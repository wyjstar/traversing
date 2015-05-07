
-- self.funcTable[1]   是类型
-- self.funcTable[2]   是数据列表


-- stoneType  1 符文石  2 献祭武魂

--恭喜获得
local PVCongratulationsGainDialog = class("PVCongratulationsGainDialog", BaseUIView)

function PVCongratulationsGainDialog:ctor(id)
    self.super.ctor(self, id)
end

function PVCongratulationsGainDialog:onMVCEnter()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()

    game.addSpriteFramesWithFile("res/ccb/resource/ui_common.plist")
    --self:showAttributeView()
    self.UICommonGetCard = {}
    self:initTouchListener()
    --加载本界面的ccbi
    self:loadCCBI("common/ui_common_getcard.ccbi", self.UICommonGetCard)
    self:initData()

    print("***************")
    self:initView()


end

-- 初始化数据
function PVCongratulationsGainDialog:initData()
    self.type = self.funcTable[1]
    self.awards = self.funcTable[2]

    self.itemCount = table.nums(self.awards)

    print("self.itemCount =========== ", self.itemCount)
    print(self.type)

    print("-----PVCongratulationsGainDialog:initData----")
    --[[
    for k,v in pairs(self.awards) do
        if v.runt_id == 0 then

        end
    end ]]


    --     self.label_number:setString(string.format("X %d", self.funcTable[2].shoes_info[1].shoes_no))
    -- else

    -- end
    if self.type == 1 then
        for k,v in pairs(self.awards) do
            cclog("----------"..v.runt_id)
            -- table.print(v.main_attr)
            for _k,_v in pairs(v.main_attr) do
                cclog("-----v.main_attr.attr_value_type-----".._v.attr_value_type)
                cclog("-----v.main_attr.attr_value-----".._v.attr_value)
                cclog("-----v.main_attr.attr_increment-----".._v.attr_increment)
                cclog("-----v.main_attr.attr_type-----".._v.attr_type)
            end
            cclog("----------------------------------------------------")
            for _k2,_v2 in pairs(v.minor_attr) do
                cclog("-----v.minor_attr.attr_value_type-----".._v2.attr_value_type)
                cclog("-----v.minor_attr.attr_value-----".._v2.attr_value)
                cclog("-----v.minor_attr.attr_increment-----".._v2.attr_increment)
                cclog("-----v.minor_attr.attr_type-----".._v2.attr_type)
            end
        end
        self.runtList = {}
        local idx = 1
        local function isRepeated(data)
            for k,v in pairs(self.runtList) do
                if v.runt_id == data.runt_id then
                    return true,k
                end
            end
            return false
        end
        for k,v in pairs(self.awards) do
            local isSame,itemId = isRepeated(v)
            if isSame then
                self.runtList[itemId]["runt_num"] = self.runtList[itemId]["runt_num"] + 1
            else
                self.runtList[idx] = v
                self.runtList[idx].runt_num = 1
                idx = idx + 1
            end
        end
        self.itemCount = table.nums(self.runtList)
    end
    -- print("-+_+_+_+fuwenshiganhuo------"..self.itemCount)
end

function PVCongratulationsGainDialog:initView()

    self.contentView = self.UICommonGetCard["UICommonGetCard"]["contentLayer"]
    if self.type == 7 then
        cclog("--------self.type == 7------")
        local label = cc.LabelTTF:create("xxxxxxxxx", MINI_BLACK_FONT_NAME, 24)
        label:setString(self.awards)
        label:setPosition(cc.p(self.contentView:getContentSize().width/2,self.contentView:getContentSize().height/2))
        self.contentView:addChild(label)
    else
        self:initTableView()
        self.tableView:reloadData()
    end
end

function PVCongratulationsGainDialog:initTouchListener()
    --退出
    local function onCloseClick()
        getAudioManager():playEffectButton2()

        --groupCallBack(GuideGroupKey.BTN_NEW_CHAPTER_CLOSE)

        self:onHideView()
    end

    --退出
    local function onSureClick()
        getAudioManager():playEffectButton2()
        getDataManager():getBagData():setUseNum(0)
        -- stepCallBack(G_GUIDE_20115)
        --[[if getPlayerScene().firstEnter == true then
            if getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20044 then
                getNewGManager():setCurrentGID(GuideId.G_GUIDE_20078)
                groupCallBack(GuideGroupKey.HOME)
            end
        else
            groupCallBack(GuideGroupKey.BTN_NEW_CHAPTER_CLOSE)
        end]]--

        groupCallBack(GuideGroupKey.BTN_WUHUN)

        self:onHideView()
    end

    self.UICommonGetCard["UICommonGetCard"] = {}
    self.UICommonGetCard["UICommonGetCard"]["onCloseClick"] = onCloseClick
    self.UICommonGetCard["UICommonGetCard"]["onSureClick"] = onSureClick
end

function PVCongratulationsGainDialog:initTableView()
    local layerSize = self.contentView:getContentSize()

    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

    if self.itemCount ~= nil and self.itemCount < 4 then
        self.tableView:setPosition(cc.p((4 - self.itemCount) * 105 / 2, 0))
    else
        self.tableView:setPosition(cc.p(0, 0))
    end
    self.tableView:setDelegate()
    self.contentView:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    self.tableView:reloadData()
end

function PVCongratulationsGainDialog:tableCellTouched(table, cell)
    --[[local bHave = getNewGManager():isHaveGuide()
    if bHave == true and getNewGManager():getCurrentGid() == GuideId.G_GUIDE_20044 then
        return
    end]]--

    if self.type == 5 then
        local smallBagId = self.awards[cell:getIdx() + 1]
        local smallItem = getTemplateManager():getDropTemplate():getSmallBagById(smallBagId)
        local itemId = smallItem.detailID

        if smallItem.type < 100 then  -- 可直接读的资源图
            if smallItem.type == 2 then
                getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 2)
            else
                getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 1)
            end
        elseif smallItem.type == 101 then -- 武将
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", itemId, 1, nil, nil)
        elseif smallItem.type == 102 then -- 装备
            local equipment = getTemplateManager():getEquipTemplate():getTemplateById(itemId)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, nil)
        elseif smallItem.type == 103 then -- 武将碎片
            local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(itemId)
            getOtherModule():showOtherView("PVCommonChipDetail", 1, itemId, nowPatchNum, 1)
        elseif smallItem.type == 104 then -- 装备碎片
            local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(itemId)
            getOtherModule():showOtherView("PVCommonChipDetail", 2, itemId, nowPatchNum, 1)
        elseif smallItem.type == 105 then  -- 道具
            getOtherModule():showOtherView("PVCommonDetail", 1, itemId, 1)
        elseif smallItem.type == 107 then
            getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 1)
        elseif smallItem.type == 108 then
            -- local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(itemId)
            -- getOtherModule():showOtherView("PVRuneDetail", 2, itemId, 3)
        end
    elseif self.type == 1 then
        local runeItem = self.runtList[cell:getIdx()+1]
        getOtherModule():showOtherView("PVRuneDetail", runeItem)
    elseif self.type == 4 then
        local itemType = self.awards[cell:getIdx()+1].type
        local itemId = self.awards[cell:getIdx()+1].detailID
        if itemType < 100 then  -- 可直接读的资源图
            if itemType == 2 then
                getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 2)
            else
                getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 1)
            end
        elseif itemType == 101 then -- 武将
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", itemId, 1, nil, nil)
        elseif itemType == 102 then -- 装备
            local equipment = getTemplateManager():getEquipTemplate():getTemplateById(itemId)
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, nil)
        elseif itemType == 103 then -- 武将碎片
            local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(itemId)
            getOtherModule():showOtherView("PVCommonChipDetail", 1, itemId, nowPatchNum, 1)
        elseif itemType == 104 then -- 装备碎片
            local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(itemId)
            getOtherModule():showOtherView("PVCommonChipDetail", 2, itemId, nowPatchNum, 1)
        elseif itemType == 105 then  -- 道具
            getOtherModule():showOtherView("PVCommonDetail", 1, itemId, 1)
        elseif itemType == 107 then
            getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 1)
        end
    end
end

function PVCongratulationsGainDialog:cellSizeForTable(table, idx)

    return 135.0, 105
end

function PVCongratulationsGainDialog:tableCellAtIndex(tbl, idx)

    local cell = nil
    -- tbl:dequeueCell()

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

    if nil == cell then
        cell = cc.TableViewCell:new()

        local proxy = cc.CCBProxy:create()
        local itemInfo = {}
        local node = CCBReaderLoad("common/ui_card_withnumber2.ccbi", proxy, itemInfo)

        cell.labelNum = itemInfo["UICommonGetCard"]["label_number"]
        cell.img = itemInfo["UICommonGetCard"]["img_card"]

        cell:addChild(node)
    end

    -- if self.type == 1 and table.nums(self.awards)>0 then
    --     local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(self.awards[idx+1].runt_id)
    --     self:setItemImage(cell.img, _respng, _quality)
    --     -- setItemImage(cell.img, _respng, _quality)
    --     -- cell.labelNum:setVisible(false)
    --     -- cell.labelNum:setString(string.format("X%d", self.awards[idx+1].stone_num))
    --     cell.labelNum:setString("X1")
    if self.type == 1 and table.nums(self.runtList)>0 then
        local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(self.runtList[idx+1].runt_id)
        self:setItemImage(cell.img, _respng, _quality)
        cell.labelNum:setString("X"..self.runtList[idx+1].runt_num)
    elseif self.type == 2 and table.nums(self.awards)>0 then
        print("-----恭喜获得------")
        if self.awards.finance.hero_soul > 0 and idx == 0 then
            cell.img:setSpriteFrame("resource_3.png")
            cell.labelNum:setString(self.awards.finance.hero_soul .. "武魂")
            if self.awards.items[1].item_num == 0 then
                local _x,_y = cell.img:getPosition()
                cell.img:setPosition(cc.p(_x+50,_y))
                cell.labelNum:setPosition(cc.p(_x+50,cell.labelNum:getPositionY()))
            end
        elseif self.awards.items[1].item_num > 0 and idx == 1 then
            cell.img:setTexture(self.awards.items[1].icon)
            cell.labelNum:setString(self.awards.items[1].item_num .. "经验丹")
        else
            cell.img:setVisible(false)
            cell.labelNum:setVisible(false)
        end
    elseif self.type == 3 then
        if self.awards[idx + 1].stone_type == 1 then
            local resIcon = getTemplateManager():getResourceTemplate():getResourceById(self.awards[idx+1].stone_id)
            setItemImage(cell.img, "res/icon/resource/" .. resIcon, 0)
            cell.labelNum:setString("X " .. self.awards[idx + 1].stone_num)
        elseif self.awards[idx + 1].stone_type == 2 then
            local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(self.awards[idx+1].stone_id)
            setItemImage(cell.img, _respng, _quality)
            cell.labelNum:setString("X " .. self.awards[idx+1].stone_num)
        end
    elseif self.type == 4 then
        -- local resIcon = getTemplateManager():getResourceTemplate():getResourceById(self.awards[idx+1].detailID)
        -- setItemImage(cell.img, "res/icon/resource/" .. resIcon, 0)
        -- cell.labelNum:setString("X " .. self.awards[idx + 1].count)

        local itemType = self.awards[idx+1].type
        if itemType < 100 then  -- 可直接读的资源图
            _temp = itemType
            local _icon = self.c_ResourceTemplate:getResourceById(self.awards[idx+1].detailID)
            setItemImage3(cell.img,"res/icon/resource/".._icon,1)
            cell.labelNum:setString(" X " .. self.awards[idx + 1].count)
        else
            if itemType == 101 then -- 武将
                _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(self.awards[idx+1].detailID)
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(self.awards[idx+1].detailID)
                changeNewIconImageBottom(cell.img,_temp,quality)

            elseif itemType == 102 then -- equpment
                _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(self.awards[idx+1].detailID)
                local quality = getTemplateManager():getEquipTemplate():getQuality(self.awards[idx+1].detailID)
                changeEquipIconImageBottom(cell.img, _temp, quality)

            elseif itemType == 103 then -- hero chips
                _temp = getTemplateManager():getChipTemplate():getTemplateById(self.awards[idx+1].detailID).resId
                local _icon = self.c_ResourceTemplate:getResourceById(_temp)
                local _quality = getTemplateManager():getChipTemplate():getTemplateById(self.awards[idx+1].detailID).quality
                changeHeroChipIconBottom(cell.img, _icon, _quality)

            elseif itemType == 104 then -- equipment chips
                _temp = getTemplateManager():getChipTemplate():getTemplateById(self.awards[idx+1].detailID).resId
                local _icon = self.c_ResourceTemplate:getResourceById(_temp)
                local _quality = getTemplateManager():getChipTemplate():getTemplateById(self.awards[idx+1].detailID).quality
                changeEquipChipIconImageBottom(cell.img, _icon, _quality)

            elseif itemType == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(self.awards[idx+1].detailID)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(self.awards[idx+1].detailID)
                setItemImage3(cell.img,"res/icon/item/".._temp,quality)

            elseif itemType == 107 then
                local _icon = self.c_ResourceTemplate:getResourceById(self.awards[idx+1].detailID)
                setItemImage3(cell.img,"res/icon/resource/".._icon,1)

             elseif itemType == 108 then
                local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(self.awards[idx+1].detailID)
                setItemImage3(cell.img, _respng, _quality)
                -- cell.labelNum:setString("X"..self.runtList[idx+1].runt_num)
            end
            cell.labelNum:setString(" X " .. self.awards[idx + 1].count)
        end
    elseif self.type == 6 then
        local finance = self.awards[idx + 1]
        local resIcon = getTemplateManager():getResourceTemplate():getResourceById(self.awards[idx+1].item_no)
        setItemImage(cell.img, "res/icon/resource/" .. resIcon, 1)
        cell.labelNum:setString("X " .. self.awards[idx + 1].item_num)
    elseif self.type == 5 then
        local smallBagId = self.awards[idx + 1]
        local smallItem = getTemplateManager():getDropTemplate():getSmallBagById(smallBagId)
        -- local smallItem = {["type"]=107,['count']=10,['detailID']=8}
        local itemType = smallItem.type                                     --物品的类型
        local itemCount = smallItem.count                                     --物品的数量

        if itemType < 100 then  -- 可直接读的资源图
            _temp = itemType
            local _icon = self.c_ResourceTemplate:getResourceById(smallItem.detailID)
            setItemImage(cell.img,"res/icon/resource/".._icon,1)
            cell.labelNum:setString(" X " .. itemCount)
        else
            if itemType == 101 then -- 武将
                _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(smallItem.detailID)
                local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(smallItem.detailID)
                changeNewIconImage(cell.img,_temp,quality)

            elseif itemType == 102 then -- equpment
                _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(smallItem.detailID)
                local quality = getTemplateManager():getEquipTemplate():getQuality(smallItem.detailID)
                changeEquipIconImageBottom(cell.img, _temp, quality)
            elseif itemType == 103 then -- hero chips
                _temp = getTemplateManager():getChipTemplate():getTemplateById(smallItem.detailID).resId
                local _icon = self.c_ResourceTemplate:getResourceById(_temp)
                local _quality = getTemplateManager():getChipTemplate():getTemplateById(smallItem.detailID).quality
                setChipWithFrame(cell.img,"res/icon/hero/".._icon, _quality)
            elseif itemType == 104 then -- equipment chips
                _temp = getTemplateManager():getChipTemplate():getTemplateById(smallItem.detailID).resId
                local _icon = self.c_ResourceTemplate:getResourceById(_temp)
                local _quality = getTemplateManager():getChipTemplate():getTemplateById(smallItem.detailID).quality
                setChipWithFrame(cell.img,"res/icon/equipment/".._icon, _quality)
            elseif itemType == 105 then  -- item
                _temp = getTemplateManager():getBagTemplate():getItemResIcon(smallItem.detailID)
                local quality = getTemplateManager():getBagTemplate():getItemQualityById(smallItem.detailID)
                setCardWithFrame(cell.img,"res/icon/item/".._temp,quality)
            elseif itemType == 107 then
                local _icon = self.c_ResourceTemplate:getResourceById(smallItem.detailID)
                setItemImage(cell.img,"res/icon/resource/".._icon,1)
                cell.labelNum:setString(" X " .. itemCount)
            elseif itemType == 108 then
                local _respng, _quality =  getTemplateManager():getStoneTemplate():getStoneIconByID(smallItem.detailID)
                self:setItemImage(cell.img, _respng, _quality)
                cell.labelNum:setString(" X " .. itemCount)
            end
        end
        local useNum = getDataManager():getBagData():getUseNum()
        if useNum ~= 0 then
            local gainNum = useNum * itemCount
            if gainNum < 100000 then
                cell.labelNum:setString(" X " .. gainNum)
            elseif gainNum >= 100000 then
                local num = gainNum / 100000 * 10
                cell.labelNum:setString(" X " .. num .. "万")
            end
        else
            cell.labelNum:setString(" X " .. itemCount)
        end
        -- curCell.rewardIcon:setSpriteFrame(resStr)
    end

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

    return cell
end

function PVCongratulationsGainDialog:setItemImage(sprite, res, quality)
    sprite:removeAllChildren()
    game.setSpriteFrame(sprite, res)
    local bgSprite = cc.Sprite:create()
    sprite:addChild(bgSprite)
    if quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_kuang.png")
    elseif quality == 3 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    elseif quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

function PVCongratulationsGainDialog:numberOfCellsInTableView(table)
    -- if self.type == 1 then
    --     return table.getn(self.runtList)
    -- else
    --     return self.itemCount
    -- end
    return self.itemCount
end



return PVCongratulationsGainDialog
