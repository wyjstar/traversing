--显示一行奖品
local GiftListShowNode = class("GiftListShowNode",function ()
	return game.newNode()
end)
-- 初始化模版
function GiftListShowNode:ctor(id)
	
	print("GiftListShowNode------ctor")
    
    self.resourceTemp = getTemplateManager():getResourceTemplate()
	self.soldierTemp = getTemplateManager():getSoldierTemplate()
	self.equipTemp = getTemplateManager():getEquipTemplate()
	self.chipTemp = getTemplateManager():getChipTemplate()
	self.bagTemp = getTemplateManager():getBagTemplate()
	self.dropTemp = getTemplateManager():getDropTemplate()
	-- body
end

function GiftListShowNode:onMVCEnter(data,isHasName)
    
    self:initDate()
    self:initTouchListener()
    
    print("GiftListShowNode------onMVCEnter")
    table.print(data)
    self.m_isHasName = isHasName
    self:initView(data)
	-- body
end
function GiftListShowNode:initTouchListener()
	-- body
end
function GiftListShowNode:initDate()
    function ccbMenuLeft()
        if self.mainTableView == nil then return end 
        local pos = self.mainTableView:getContentOffset()
        local addnum = roundNumber(pos.x/(-110))
        local cellNum = 5 + addnum
        if pos.x%(-110) ~= 0 then cellNum = cellNum + 1 end
        if cellNum > 5 then 
            cellNum = cellNum - 1
            if cellNum <= 5 then self.leftBtn:setVisible(false) end
            self.rightBtn:setVisible(true) 
            self.mainTableView:setContentOffset((cc.p(-110*(cellNum - 5),0)))
        end
        -- body
    end
    function ccbMenuRight()
        if self.mainTableView == nil then return end 
        local pos = self.mainTableView:getContentOffset()
        local addnum = roundNumber(pos.x/(-110))
        local cellNum = 5 + addnum
        if cellNum < table.getn(self.reward) then
            cellNum = cellNum + 1
            if cellNum >= table.getn(self.reward) then self.rightBtn:setVisible(false) end
            self.leftBtn:setVisible(true) 
            self.mainTableView:setContentOffset((cc.p(-110*(cellNum - 5),0)))
            
        end
        -- body
    end
    local proxy = cc.CCBProxy:create()
    self.itemInfo = {}
    self.itemInfo["ui_common_giftshow"] = {}
    self.itemInfo["ui_common_giftshow"]["ui_activity_vipgift_left"] =ccbMenuLeft
    self.itemInfo["ui_common_giftshow"]["ui_activity_vipgift_right"] =ccbMenuRight
    local node = CCBReaderLoad("common/ui_common_giftshow.ccbi", proxy, self.itemInfo)
    self.leftBtn = self.itemInfo["ui_common_giftshow"]["ui_activity_vipgift_left"]
    self.rightBtn = self.itemInfo["ui_common_giftshow"]["ui_activity_vipgift_right"]
    self:addChild(node)
	--assert(self.funcTable ~= nil, "if you used DialogGetCard UI, you must to give a text in !")
	-- body
end
function GiftListShowNode:initView(data)
	local  num = table.getn(data)
	for k,v in pairs(data) do
		self.reward = self:getDropList(v[3])
	end
	self:createTableView(self.reward,self)
	-- body
end
function GiftListShowNode:getDropList(dropId)
	cclog("getDropList  "..dropId)
	local _smallDrop = self.dropTemp:getBigBagById(dropId).smallPacketId
    local _smallCount = self.dropTemp:getBigBagById(dropId).smallPacketTimes
	
	local  num  = table.getn(_smallDrop)
	local dropList = {}
	for k,_smallDropId in pairs(_smallDrop) do
		local _itemList = self.dropTemp:getAllItemsByDropId(_smallDropId)
		
		local dropType = _itemList[1].type
		dropList[k] = {[tostring(dropType)] = {_smallCount[k],_itemList[1].type,_itemList[1].detailId} }

	end
	return dropList
end
function GiftListShowNode:checkArrowShow()
    if self.mainTableView == nil then return end 
    local pos = self.mainTableView:getContentOffset()
    local addnum = roundNumber(pos.x/(-110))
    local cellNum = 5 + addnum
    self.leftBtn:setVisible(true)
    self.rightBtn:setVisible(true) 
    if cellNum >= table.getn(self.reward) then 
        self.rightBtn:setVisible(false) 
    end
    if pos.x%(-110) ~= 0 then cellNum = cellNum + 1 end
    if cellNum <= 5 then 
        self.leftBtn:setVisible(false) 
    end
    
end
function GiftListShowNode:createTableView(tableList,layerView)

	layerView:removeAllChildren()
	local function tableCellTouched(tbl,cell)
		local reward = tableList[cell:getIdx()+1]
		cclog("tableCellTouched    len")
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
		-- tableCellTouched body
	end

	local function numberOfCellsInTableView( tab )
        cclog("createTableView    len"..table.nums(tableList))
        self:checkArrowShow()
		return table.nums(tableList)
		-- body
	end 

	local  function cellSizeForTable(tbl, idx)
		return 135,105
		-- body
	end
	local function tableCellAtIndex(tbl, idx)
        cclog("tableCellAtIndex    000000")
		local cell = tbl:dequeueCell()
         
		if nil == cell then
			cell = cc.TableViewCell:new()
			cell.itemInfo = {}
			local proxy = cc.CCBProxy:create()
			cell.itemInfo["ui_common_giftitem"] = {}
			local node = CCBReaderLoad("common/ui_common_giftitem.ccbi", proxy, cell.itemInfo)
            cell:addChild(node)
            cell.img = cell.itemInfo["ui_common_giftitem"]["rewardIcon"]
            cell.labelNum = cell.itemInfo["ui_common_giftitem"]["activeJLItemNum"]
            cell.labelName = cell.itemInfo["ui_common_giftitem"]["activeJLItemName"]
            cell.labelNamebg = cell.itemInfo["ui_common_giftitem"]["ui_common_giftnamebg"]
            if self.m_isHasName  == false then
                cell.labelName:removeFromParent(true)
                cell.labelNamebg:removeFromParent(true)
                node:setPositionY(node:getPositionY()-42)
            end
        end
        
        cclog("tableCellAtIndex    111111")
        table.print(tableList)
        reward = tableList[idx+1]
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
                setChipWithFrameNew(cell.img, _icon, _quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "104" then -- equipment chip
                local _temp = self.chipTemp:getTemplateById(v[3]).resId
                local _icon = self.resourceTemp:getResourceById(_temp)
                local quality = self.chipTemp:getTemplateById(v[3]).quality
                setChipWithFrameN(cell.img, "res/icon/equipment/".._icon, quality)
                cell.labelNum:setString("X "..v[1])
            elseif k == "105" then -- item
                local _temp = self.bagTemp:getItemResIcon(v[3])
                cclog("reward".._temp)
                local quality = self.bagTemp:getItemQualityById(v[3])
                cclog("reward"..quality)
                setItemImageNew(cell.img, "res/icon/item/".._temp, quality)
               cell.labelNum:setString("X "..v[1])
               cclog("reward"..v[1])
            elseif k == "106" then -- big_bag
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
       cclog("tableCellAtIndex   ------------------------ 000000")
        return cell
		-- body
	end
	local layerSize = cc.size(500, 150)
    cclog("layerSize    "..layerSize.width.."    kkkkk"..layerSize.height)
    self.mainTableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    local itemCount = table.nums(tableList)
    if itemCount ~= nil and itemCount < 4 then
        self.mainTableView:setPosition(cc.p((4 - itemCount) * 105 / 2, 0))
    else
        self.mainTableView:setPosition(cc.p(0 , 0))
    end

    self.mainTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    --tabView:setPosition(cc.p(0, -10))
    self.mainTableView:setDelegate()
    self.mainTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    layerView:addChild(self.mainTableView)

    self.mainTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.mainTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.mainTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.mainTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    self.mainTableView:reloadData()
	-- body
end

return GiftListShowNode






















