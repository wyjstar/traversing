-- 公共UI
-- 使用：getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("DialogGetCard", data)

local DialogGetCard = class("DialogGetCard", BaseUIView)

function DialogGetCard:ctor(id)
    DialogGetCard.super.ctor(self, id)
    print("DialogGetCard, ctor ...")

    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
    self.dropTemp = getTemplateManager():getDropTemplate()
end

function DialogGetCard:onMVCEnter()
    self:initData()
	self.ccbiNode = {}
	self:initTouchListener()
    self:loadCCBI("common/ui_common_getcard.ccbi", self.ccbiNode)
    self:initView()
end

function DialogGetCard:initData()
	assert(self.funcTable ~= nil, "if you used DialogGetCard UI, you must to give a text in !")
	self.reward = self.funcTable[1]
    self.dayReward = getDataManager():getActiveData():getDayReward()
    print("this is DialogGetCard~~~~~~~~~~~哈哈啊哈哈")
    table.print(self.reward)
end

function DialogGetCard:initTouchListener()

    local function onMenuClickOk()
        getAudioManager():playEffectButton2()
        print("------ click OK")
        self:onHideView()
    end
    local function onMenuClickCancle()
        getAudioManager():playEffectButton2()
    	print("---- click cancle")
        self:onHideView()
    end
    self.ccbiNode["UICommonGetCard"] = {}
    self.ccbiNode["UICommonGetCard"]["onSureClick"] = onMenuClickOk
    self.ccbiNode["UICommonGetCard"]["onCloseClick"] = onMenuClickCancle
end

function DialogGetCard:initView()

    self.contentView = self.ccbiNode["UICommonGetCard"]["contentLayer"]
    print("~~~!!!!!!!!!!!!!!", self.contentView)

    -- 赋值
    local index = 0
    local _cardNum = table.nums(self.reward)
    print("this is initView--------------------哈哈啊哈哈".._cardNum)

    self:createDropList(self.reward,self.contentView)
    -- for k,v in pairs(self.reward) do

    --     local proxy = cc.CCBProxy:create()
    --     local itemInfo = {}
    --     local node = CCBReaderLoad("common/ui_card_withnumber2.ccbi", proxy, itemInfo)
    --     self.contentView:addChild(node)
    --     local labelNum = itemInfo["UICommonGetCard"]["label_number"]
    --     local img = itemInfo["UICommonGetCard"]["img_card"]
    --     if _cardNum == 1 then 
    --         local laySize = self.contentView:getContentSize()
    --         local cardSize = node:getContentSize()
    --         node:setPositionX(laySize.width/2 - cardSize.width/2)
    --     else
    --         local laySize = node:getContentSize()
    --         node:setPositionX(index * laySize.width)
    --     end
    --     index = index + 1
    --     if k == "101" then -- hero
    --         local _temp = self.soldierTemp:getSoldierIcon(v[1])
    --         local quality = self.soldierTemp:getHeroQuality(v[1])
    --         changeNewIconImage(img, _temp, quality)
    --         labelNum:setString(1)
    --     elseif k == "102" then -- equipment
    --         local _temp = self.equipTemp:getEquipResIcon(v[1])
    --         local quality = self.equipTemp:getQuality(v[1])
    --         changeEquipIconImageBottom(img, _temp, quality)
    --         labelNum:setString(1)
    --     elseif k == "103" then -- hero chip
    --         -- local _temp = self.chipTemp:getTemplateById(v[1]).resId
    --         -- local _icon = self.resourceTemp:getResourceById(_temp)
    --         -- setChipWithFrame(img, "res/icon/hero/".._icon, 1)
    --         -- labelNum:setString(1)
    --         local _temp = self.chipTemp:getTemplateById(v[3]).resId
    --         local _icon = self.resourceTemp:getResourceById(_temp)
    --         local _quality = self.chipTemp:getTemplateById(v[3]).quality
    --         setChipWithFrame(img, "res/icon/hero/".._icon, _quality)
    --         labelNum:setString("X"..v[1])
    --     elseif k == "104" then -- equipment chip
    --         local _temp = self.chipTemp:getTemplateById(v[1]).resId
    --         local _icon = self.resourceTemp:getResourceById(_temp)
    --         setChipWithFrame(img, "res/icon/equipment/".._icon, 1)
    --         labelNum:setString("X"..v[1])
    --     elseif k == "105" then -- item
    --         -- _temp = self.bagTemp:getItemResIcon(v[1])
    --         -- local quality = self.bagTemp:getItemQualityById(v[1])
    --         -- setItemImage(img, "res/icon/item/".._temp, quality)
    --         -- labelNum:setString(1)
    --         _temp = self.bagTemp:getItemResIcon(v[3])
    --         local quality = self.bagTemp:getItemQualityById(v[3])
    --         setItemImage(img, "res/icon/item/".._temp, quality)
    --         labelNum:setString("X"..v[1])
    --     elseif k == "106" then -- big_bag
    --         self:getDropBag(img, labelNum, v[3])
    --     elseif k == "107" then
    --         local _res = self.resourceTemp:getResourceById(v[3])
    --         setItemImage(img, "res/icon/resource/".._res, 1)
    --         labelNum:setString("X" .. v[1])
    --     else
    --         local _res = self.resourceTemp:getResourceById(k)
    --         print("GGGGG", _res)
    --         setItemImage(img, "#".._res, 1)
    --         labelNum:setString("X" .. v[1])
    --     end

    -- end
end

function DialogGetCard:getDropBag(img, label, dropId)
    local _smallDropId = self.dropTemp:getBigBagById(dropId).smallPacketId[1]
    local _itemList = self.dropTemp:getAllItemsByDropId(_smallDropId)
    
    table.print(_itemList)

    -- 查出物品类型type,分类处理1，继续查表 2，直接获取图片
    local _index = 1
    for k,v in pairs(_itemList) do  -- _itemList = {[1]={type = v.type, detailId = v.detailID},...}
        if v.type < 100 then  -- 可直接读的资源图
            local _icon = self.resourceTemp:getResourceById(v.type)
            setItemImage(img, "#".._icon, 1)
        else  -- 需要继续查表
            if v.type == 101 then -- 武将
                local _temp = self.soldierTemp:getSoldierIcon(v.detailId)
                local quality = self.soldierTemp:getHeroQuality(v.detailId)
                changeNewIconImage(img,_temp,quality)
            elseif v.type == 102 then -- equpment
                local _temp = self.equipTemp:getEquipResIcon(v.detailId)
                local quality = self.equipTemp:getQuality(v.detailId)
                changeEquipIconImageBottom(img, _temp, quality)
            elseif v.type == 103 then -- hero chips
                local _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self.resourceTemp:getResourceById(_temp)

                local quality = self.chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(img,"res/icon/hero/".._icon, quality)
            elseif v.type == 104 then -- equipment chips
                local _temp = self.chipTemp:getTemplateById(v.detailId).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local quality = self.chipTemp:getTemplateById(v.detailId).quality
                setChipWithFrame(img,"res/icon/equipment/".._icon, quality)
            elseif v.type == 105 then  -- item 
                local _temp = self.bagTemp:getItemResIcon(v.detailId)
                local quality = self.bagTemp:getItemQualityById(v.detailId)
                setItemImage3(img,_temp, quality)
            end
        end
        label:setString("X "..v.count)
    end 
end

function DialogGetCard:createDropList(tabList,layerView)
    layerView:removeAllChildren()
   
   local function tableCellTouched( tbl, cell )
        print("-----cell:getIdx()-----",cell:getIdx())
        local reward = nil
        if table.nums(tabList) == 1 then
            reward = tabList
        else
            reward = tabList[cell:getIdx()+1]
        end
        table.print(reward)
        for k,v in pairs(reward) do
            if tonumber(k) < 100 then  -- 可直接读的资源图
                getOtherModule():showOtherView("PVCommonDetail", 2, tonumber(k), 1)   
            elseif k == "101" then -- 武将
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", v[3], 101)
            elseif k == "102" then -- 装备
                 for k,_v in pairs(self.dayReward) do
                     if _v.detailId == v[3] then
                        local _equipment = self.c_EquipmentData:getEquipById(_v.id)
                        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", _equipment, 101)
                    end
                 end   
            elseif k == "103" then -- 武将碎片
                local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(v[3])
                getOtherModule():showOtherView("PVCommonChipDetail", 1, v[3], nowPatchNum, 1)
            elseif k == "104" then -- 装备碎片
                local nowPatchNum = self.c_EquipmentData:getPatchNumById(v[3])
                getOtherModule():showOtherView("PVCommonChipDetail", 2, v[3], nowPatchNum, 1)
            elseif k == "105" then  -- 道具
                getOtherModule():showOtherView("PVCommonDetail", 1, v[3], 1)
            elseif k == "107" then  -- 道具
                getOtherModule():showOtherView("PVCommonDetail", 2, v[3], 1)
            elseif k == "108" then
                local runeItem = {}
                runeItem.runt_id = v[3]
                runeItem.inRuneType = getTemplateManager():getStoneTemplate():getStoneItemById(v[3]).type
                runeItem.runePos = 0
                getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)
            
            end
        end
   end 

    local function numberOfCellsInTableView(tab)
        cclog("这里是创建掉落列表"..table.nums(tabList))
        -- local count = table.nums(tabList)
       return table.nums(tabList)
    end
    local function cellSizeForTable(tbl, idx)
        return 135,105
    end
    local function tableCellAtIndex(tbl, idx)
        cclog("-------------DialogGetCard:createDropList--------")
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["UICommonGetCard"] = {}
            local node = CCBReaderLoad("common/ui_card_withnumber2.ccbi", proxy, cell.itemInfo)
            --node:setScale(0.85)
            cell:addChild(node)
            cell.img = cell.itemInfo["UICommonGetCard"]["img_card"]
            cell.labelNum = cell.itemInfo["UICommonGetCard"]["label_number"]
        end
        cclog("-------------DialogGetCard:createDropList--------")
        table.print(tabList)
        local reward = {}
        if table.nums(tabList) == 1 then
           reward = tabList
            cclog("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-")
            table.print(reward)
        else
            reward = tabList[idx+1]
        end

        --if reward == nil 
        --local reward = tabList
        for k,v in pairs(reward) do
            --index = index + 1
            if k == "101" then -- hero
                local _temp = self.soldierTemp:getSoldierIcon(v[3])
                local quality = self.soldierTemp:getHeroQuality(v[3])
                changeNewIconImage(cell.img, _temp, quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "102" then -- equipment
                local _temp = self.equipTemp:getEquipResIcon(v[3])
                local quality = self.equipTemp:getQuality(v[3])
                changeEquipIconImageBottom(cell.img, _temp, quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "103" then -- hero chip
                local _temp = self.chipTemp:getTemplateById(v[3]).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local _quality = self.chipTemp:getTemplateById(v[3]).quality
                setChipWithFrame(cell.img, "res/icon/hero/".._icon, _quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "104" then -- equipment chip
                local _temp = self.chipTemp:getTemplateById(v[3]).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local quality = self.chipTemp:getTemplateById(v[3]).quality
                setChipWithFrame(cell.img, "res/icon/equipment/".._icon, quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "105" then -- item
                _temp = self.bagTemp:getItemResIcon(v[3])
                local quality = self.bagTemp:getItemQualityById(v[3])
                setItemImage(cell.img, "res/icon/item/".._temp, quality)
               cell.labelNum:setString("X "..v[1])
            --elseif k == "106" then -- big_bag
                --这个大包应该不会用到了吧
                --self:getDropBag(cell.img, cell.labelNum, v[3])
            -- elseif k == "107" then
            --     local _res = self.resourceTemp:getResourceById(v[3])
            --     setItemImage(img, "res/icon/resource/".._res, 1)
            elseif k == "106" then -- big_bag
                self:getDropBag(cell.img, cell.labelNum, v[3])
            elseif k == "107" then
            local _res = self.resourceTemp:getResourceById(v[3])
                setItemImage(cell.img, "res/icon/resource/".._res, 1)
                cell.labelNum:setString("X" .. v[1])  
            elseif k == "108" then
                local res,quality= self.stoneTemp:getStoneIconByID(v[3])
                setItemImage(cell.img, res, quality)
                cell.labelNum:setString("X" .. v[1])
            else
                local _res = self.resourceTemp:getResourceById(k)
                print("GGGGG", _res)
                setItemImage(cell.img, "#".._res, 1)
                cell.labelNum:setString("X "..v[1])
            end
            
        end

       return cell
    end

    local layerSize = layerView:getContentSize()
    local tabView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    local itemCount = table.nums(tabList)
    print("-----------table.nums(tabList)++++++++++++++"..itemCount)
    if itemCount ~= nil and itemCount < 4 then
        tabView:setPosition(cc.p((4 - itemCount) * 105 / 2, -10))
    else
        tabView:setPosition(cc.p(0 , -10))
    end

    tabView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    --tabView:setPosition(cc.p(0, -10))
    tabView:setDelegate()
    tabView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    layerView:addChild(tabView)

    tabView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tabView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tabView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tabView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    tabView:reloadData()
end


return DialogGetCard
