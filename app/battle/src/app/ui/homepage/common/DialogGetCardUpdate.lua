-- 公共UI
-- 使用：getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("DialogGetCard", data)

local DialogGetCardUpdate = class("DialogGetCardUpdate", BaseUIView)

function DialogGetCardUpdate:ctor(id)
    DialogGetCardUpdate.super.ctor(self, id)
    print("DialogGetCardUpdate, ctor ...")

    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.bagTemp = getTemplateManager():getBagTemplate()
    self.dropTemp = getTemplateManager():getDropTemplate()
    self.c_EquipmentData = getDataManager():getEquipmentData()
    self.stoneTemp = getTemplateManager():getStoneTemplate()
end

function DialogGetCardUpdate:onMVCEnter()
    self:initData()
	self.ccbiNode = {}
	self:initTouchListener()
    self:loadCCBI("common/ui_common_getcard.ccbi", self.ccbiNode)
    self:initView()
end

function DialogGetCardUpdate:initData()
	assert(self.funcTable ~= nil, "if you used DialogGetCardUpdate UI, you must to give a text in !")
	-- self.reward = self.funcTable[1]
    self.reward = self.funcTable[1]
    self.levelReward = getDataManager():getActiveData():getLevelReward()

    -- print("this is DialogGetCardUpdate~~~~~~~~~~~哈哈啊哈哈")
    -- table.print(self.levelReward)
    -- table.print(self.reward)
end

function DialogGetCardUpdate:initTouchListener()

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

function DialogGetCardUpdate:initView()

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

function DialogGetCardUpdate:getDropBag(img, label, dropId)
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
                setCardWithFrame(img,"res/icon/item/".._temp, quality)
            end
        end
        label:setString("X "..v.count)
    end 
end

function DialogGetCardUpdate:createDropList(tabList,layerView)
    layerView:removeAllChildren()

    local function tableCellTouched(tbl, cell)
        cclog("cell item ================ ")
        local reward = tabList[cell:getIdx() + 1]
        for k,v in pairs(reward) do
            if tonumber(k) < 100 then  -- 可直接读的资源图
                getOtherModule():showOtherView("PVCommonDetail", 2, tonumber(k), 1)   
            elseif k == "101" then -- 武将
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", v[3], 101)
            elseif k == "102" then -- 装备
                 for k,_v in pairs(self.levelReward) do
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
            end
        end
    end

    local function numberOfCellsInTableView(tab)
        cclog("这里是创建掉落列表"..table.getn(tabList))
       return table.getn(tabList)
    end
    local function cellSizeForTable(tbl, idx)
        return 135,105
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            cell.itemInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.itemInfo["ui_common_giftitem"] = {}
            local node = CCBReaderLoad("common/ui_common_giftitem.ccbi", proxy, cell.itemInfo)
            --node:setScale(0.85)
            cell:addChild(node)
            cell.img = cell.itemInfo["ui_common_giftitem"]["rewardIcon"]
            cell.labelNum = cell.itemInfo["ui_common_giftitem"]["activeJLItemNum"]
            cell.labelName = cell.itemInfo["ui_common_giftitem"]["activeJLItemName"]
            cell.labelNamebg = cell.itemInfo["ui_common_giftitem"]["ui_common_giftnamebg"]
            cell.labelName:removeFromParent(true)
            cell.labelNamebg:removeFromParent(true)
          
        end

        local reward = tabList[idx+1]
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
                setChipWithFrameN(cell.img, "res/icon/hero_new/".._icon, _quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "104" then -- equipment chip
                local _temp = self.chipTemp:getTemplateById(v[3]).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local quality = self.chipTemp:getTemplateById(v[3]).quality
                setChipWithFrameN(cell.img, "res/icon/equipment/".._icon, quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "105" then -- item
                _temp = self.bagTemp:getItemResIcon(v[3])
                local quality = self.bagTemp:getItemQualityById(v[3])
                setItemImageNew(cell.img, "res/icon/item/".._temp, quality)
               cell.labelNum:setString("X "..v[1])
            elseif k == "106" then -- big_bag
                --这个大包应该不会用到了吧
                self:getDropBag(cell.img, cell.labelNum, v[3])
            elseif k == "107" then
                local _res = self.resourceTemp:getResourceById(v[3])
                setItemImageNew(cell.img, "res/icon/resource/".._res, 1)
                cell.labelNum:setString("X" .. v[1])
            elseif k == "108" then
                local res,quality= self.stoneTemp:getStoneIconByID(v[3])
                setItemImageNew(cell.img, res, quality)
                cell.labelNum:setString("X" .. v[1])
            else
                local _res = self.resourceTemp:getResourceById(k)
                print("GGGGG", _res)
                setItemImageNew(cell.img, "#".._res, 1)
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
        tabView:setPosition(cc.p((4 - itemCount) * 121 / 2, -10))
    else
        tabView:setPosition(cc.p(0 , -10))
    end

    tabView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    --tabView:setPosition(cc.p(0, -10))
    tabView:setDelegate()
    tabView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    layerView:addChild(tabView)

    tabView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    tabView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tabView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tabView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    tabView:reloadData()
end


return DialogGetCardUpdate
