--选择熔炼

local NUM_ITEMS = 8  -- 允许最大的熔炼数

local PVSelectSmeltEquip = class("PVSelectSmeltEquip", BaseUIView)

function PVSelectSmeltEquip:ctor(id)
    PVSelectSmeltEquip.super.ctor(self, id)

    self.lineupData = getDataManager():getLineupData()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.equipData = getDataManager():getEquipmentData()
    self.languageTemp = getTemplateManager():getLanguageTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()
end

function PVSelectSmeltEquip:onMVCEnter()

    self:initTouchListener()
    self:loadCCBI("equip/ui_equip_select_smeltitem.ccbi", self.ccbiNode)
    self:initData()
    self:initView()

    self.tableViewTable = {}
    self:createGreen()
    self:createBlue()
    self:createPurple()

    self:updateMenu(1)
    self:updateSelectData()
end 

function PVSelectSmeltEquip:initData()

    self.allEquipments = self.equipData:getEquipList()
    --SORT
    for k,v in pairs(self.allEquipments) do
        if v ~= nil then
            v.power = self.c_Calculation:SingleEquCombatPower(v)
        end
    end

    local function compairByPower(item1, item2)
        equipmentPower1 = item1.power 
        equipmentPower2 = item2.power 
        return equipmentPower1 < equipmentPower2
    end

    
    self.equipGreen = {}
    self.equipBlue = {}
    self.equipPurple = {}
    local index1 = 1
    local index2 = 1
    local index3 = 1
    for k,v in pairs(self.allEquipments) do
        if self:getIsEquip(v.id) == 0 then -- 未穿戴
            local quality = self.equipTemp:getQuality(v.no)
            if quality == 1 or quality == 2 then
                self.equipGreen[index1] = v
                index1 = index1 + 1
            elseif quality == 3 or quality == 4 then
                self.equipBlue[index2] = v
                index2 = index2 + 1
            elseif quality == 5 or quality == 6 then
                self.equipPurple[index3] = v
                index3 = index3 + 1
            end
        end 
    end

    --number of tables
    self._numGreen = table.nums(self.equipGreen)
    self._numBlue = table.nums(self.equipBlue)
    self._numPurple = table.nums(self.equipPurple)

    table.sort(self.equipGreen,compairByPower)
    table.sort(self.equipBlue,compairByPower)
    table.sort(self.equipPurple,compairByPower)

    --被选中的Id
    self.selectIDTable = {}  -- 这个要缓存
    local index = 0
    for k,v in pairs(self.equipGreen) do
        index = index + 1
        self.selectIDTable[v.id] = {["index"]=index,["selected"] = false}
    end

    for k,v in pairs(self.equipBlue) do
        index = index + 1
        self.selectIDTable[v.id] = {["index"]=index,["selected"] = false}
    end

    for k,v in pairs(self.equipPurple) do
        index = index + 1
        self.selectIDTable[v.id] = {["index"]=index,["selected"] = false}
    end

    local _dataList = self.equipData:getSmeltIDs()
    if _dataList ~= nil and table.getn(_dataList) ~= 0 then
        for k,v in pairs(_dataList) do
            self.selectIDTable[v]["selected"] = true
        end
    end

    -- print("1print selectIDTable")
    -- table.print(self.selectIDTable)
    -- local function sortByIndex( item1,item2)
    --     return item1["index"]<item2["index"]
    -- end
    -- table.sort(self.selectIDTable, sortByIndex )
    -- print("2print selectIDTable")
    -- table.print(self.selectIDTable)

    self.mySelectList = {}  -- 最终选择的
end

function PVSelectSmeltEquip:getIsEquip(id)
    local _equipedWho = self.lineupData:getEquipTo(id)  
    if _equipedWho == Localize.query("equip.1") then 
        return 0
    else
        return 1
    end
end

function PVSelectSmeltEquip:initTouchListener()
    local function onCloseMenu()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    local function onGreen()
        getAudioManager():playEffectButton2()
        self:updateMenu(1)
    end
    local function onBlue()
        getAudioManager():playEffectButton2()
        self:updateMenu(2)
    end
    local function onPurple()
        getAudioManager():playEffectButton2()
        self:updateMenu(3)
    end
    local function onSure()
        print("on sure ..")
        
        self.equipData:setSmeltIDs(self.mySelectList)

        self:onHideView()
    end
    self.ccbiNode = {}
    self.ccbiNode["UISelectSmelt"] = {}
    self.ccbiNode["UISelectSmelt"]["backMenuClick"] = onCloseMenu
    self.ccbiNode["UISelectSmelt"]["onGreen"] = onGreen
    self.ccbiNode["UISelectSmelt"]["onBlue"] = onBlue
    self.ccbiNode["UISelectSmelt"]["onPurple"] = onPurple
    self.ccbiNode["UISelectSmelt"]["onSure"] = onSure
end

-- 获取控件与设置属性
function PVSelectSmeltEquip:initView()
    self.ccbiRootNode = self.ccbiNode["UISelectSmelt"]
    self.contentLayer = self.ccbiRootNode["listLayer"]
    self.oweEquipsoul = self.ccbiRootNode["owe_equipsoul_num"]
    self.oweCoin = self.ccbiRootNode["owe_coin"]

    self.oweCoin:setString(getDataManager():getCommonData():getFinance(1))
    self.oweEquipsoul:setString(getDataManager():getCommonData():getFinance(21))

    self.menuTable = {}
    self.normalTable = {}
    self.selectTable = {}
    for i=1,3 do
        local strmenu = "Menu"..tostring(i)
        local strNor = "nor"..tostring(i)
        local strSelect = "select"..tostring(i)
        table.insert(self.menuTable, self.ccbiRootNode[strmenu])
        self.menuTable[i]:setAllowScale(false)
        table.insert(self.normalTable, self.ccbiRootNode[strNor])
        table.insert(self.selectTable, self.ccbiRootNode[strSelect])
    end
    self.labelItemNum = self.ccbiRootNode["equip_num"]
    self.menuOk = self.ccbiRootNode["menu_ok"]
end

function PVSelectSmeltEquip:updateItemNumber()
    -- 更新列表中的数量
    local num
    if self.currMenuIdx == 1 then num = self._numGreen
    elseif self.currMenuIdx == 2 then num = self._numBlue
    elseif self.currMenuIdx == 3 then num = self._numPurple
    end
    self.labelItemNum:setString(string.format(num))
end

-- 限制选择的个数
function PVSelectSmeltEquip:checkLimitNum()
    if table.nums(self.mySelectList) >= NUM_ITEMS then
        -- self:toastShow(Localize.query("equip.9"))
        getOtherModule():showAlertDialog(nil, Localize.query("equip.9"))
        return true
    end
    return false
end

--
function PVSelectSmeltEquip:updateSelectData()
    self.mySelectList = {}

    local function pairsByIndex( t )
        local a = {}  
        for n in pairs(t) do  
            a[#a+1] = n  
        end  
        table.sort(a)  
        local i = 0  
        return function()  
            i = i + 1  
            return a[i], t[a[i]]  
        end  
    end 

    local tmpTable = {}


    for k,v in pairs(self.selectIDTable) do --保证按证品质Power等顺序
        if v["selected"] == true then 
            tmpTable[v["index"]]=k
        end
    end

    for k,v in pairsByIndex(tmpTable) do
        table.insert(self.mySelectList,v)
    end

    local num = table.nums(self.mySelectList)

    self.menuOk:setEnabled(num > 0)
end

-- 创建列表
function PVSelectSmeltEquip:createGreen()
    
    local function tableCellTouched(tbl, cell)
        print("cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.equipGreen)
    end
    local function cellSizeForTable(tbl, idx)
        return 145, 555
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function selectMenuClick()
                local id = self.equipGreen[cell.index+1].id
                print(".................", id)

                if self.selectIDTable[id]["selected"] == true then
                    cell.selectMenu:setVisible(false)
                    self.selectIDTable[id]["selected"] = false
                else 
                    if self:checkLimitNum() == true then return end
                    cell.selectMenu:setVisible(true)
                    self.selectIDTable[id]["selected"] = true
                end
                self:updateSelectData()
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIEquipSmeltingItem"] = {}
            cell.cardinfo["UIEquipSmeltingItem"]["selectMenuClick"] = selectMenuClick
            local node = CCBReaderLoad("equip/ui_equip_smelting_item_new.ccbi", proxy, cell.cardinfo)

            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIEquipSmeltingItem"]["headIcon"]
            cell.equipPrefix = cell.cardinfo["UIEquipSmeltingItem"]["equipPrefix"]
            cell.equipName = cell.cardinfo["UIEquipSmeltingItem"]["equipName"]
            cell.mainAttrLabel = cell.cardinfo["UIEquipSmeltingItem"]["main_attr_label"]
            cell.otherAttrLabel = cell.cardinfo["UIEquipSmeltingItem"]["other_attr_label"]
            cell.labelLevel = cell.cardinfo["UIEquipSmeltingItem"]["label_lv"]
            cell.coinValue = cell.cardinfo["UIEquipSmeltingItem"]["coin_value"]
            cell.equipValue = cell.cardinfo["UIEquipSmeltingItem"]["equip_value"]
            cell.selectMenu = cell.cardinfo["UIEquipSmeltingItem"]["selectMenu"]
            cell.itemBg = cell.cardinfo["UIEquipSmeltingItem"]["itemBg"]

            cell:addChild(node)
        end
        cell.index = idx
        -- 获取数据中的值
        local equipData = self.equipGreen[idx+1]
        local equipmentItem = self.equipTemp:getTemplateById(equipData.no)
        local _name = self.languageTemp:getLanguageById(equipmentItem.name)
        local _equipPrefix = equipData.prefix

        local _nameImage = "ui_equip_kind_6"
        if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_6" end
        if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_5" end
        if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_4" end
        if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_3" end
        if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_2" end
        if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_1" end
        local _equipPrefixRes = _nameImage .. ".png"
        ------------ 属性 新表使用方式-----------
        --主属性
        local _descrip = ""
        --table.print(equipData.main_attr)
        local main_attr = self.c_Calculation:EquMainAttr(equipData)       --equipData.main_attr
        local mainNum = table.nums(main_attr)
        -- local zhuNum = main_attr[1].attr_increment * equipData.strengthen_lv + main_attr[1].attr_value
        -- zhuNum = math.floor(zhuNum * 10) / 10
        if mainNum == 0 then
            print("没有主属性")
        else
            -- local str = self.equipTemp:setSXName(main_attr[1].attr_type)
            -- _descrip = _descrip .. str .. string.format(main_attr.Value)
            _descrip = _descrip .. main_attr.AttrName.. " +" .. main_attr.Value
        end
        --次属性
        local _descrip2 = ""
        --table.print(equipData.minor_attr)
        local minor_attr = self.c_Calculation:EquMinorAttr(equipData)       --equipData.minor_attr
        local ciNum = table.nums(minor_attr)
        if ciNum == 0 then 
            print("没有次属性")
        else
            -- for i=1,ciNum do
            --     local str = self.equipTemp:setSXName(minor_attr[i].attr_type)
            --     local ciAddNum =  minor_attr[i].attr_value + minor_attr[i].attr_increment * equipData.strengthen_lv
            --     ciAddNum = math.floor(ciAddNum * 10) / 10
            --     _descrip2 = _descrip2 .. str .. " +" .. ciAddNum  .."  "
            --     if i%2 == 0 then 
            --         _descrip2 = _descrip2.."\n"
            --     end
            -- end
            for i=1,ciNum do
                _descrip2 = _descrip2 .. minor_attr[i].AttrName.. " +" .. minor_attr[i].Value
                if i%2 == 0 then
                    _descrip2 = _descrip2.."\n"
                end
            end
        end
        --------------------------老设备表使用方式---------------------
        -- local str, valueB, valueG, other = self.equipTemp:getMainAttributeById(equipData.no)
        -- local _descrip = ""
        -- local _descrip2 = ""
        -- if str ~= nil then 
        --     _descrip = str .. string.format( " + %d", roundNumber(valueB + valueG * equipData.strengthen_lv) )  -- 提升属性描述
        -- end
        -- for k,v in pairs(other) do
        --     local _value = string.format(" + %d", v[2])
        --     _descrip2 = _descrip2 .. v[1] .. _value .. "\n"
        -- end
        -------------------------老设备表使用方式---------------------
        local _equipedWho = self.lineupData:getEquipTo(equipData.id)  
        -- local _icon = self.equipTemp:getEquipResIcon(equipData.no)  -- 资源名
        local _icon = self.equipTemp:getEquipResHD(equipData.no)
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质

        -- changeEquipIconImageBottom(cell.icon, _icon, _quality)  -- 设置卡的图片
        -- cell.labelLevel:setString("Lv."..equipData.strengthen_lv)
        if _quality == 5 or _quality == 6 then cell.icon:setScale(0.5) 
        elseif _quality == 3 or _quality == 4 then  cell.icon:setScale(0.6)
        else cell.icon:setScale(0.65) end

        cell.icon:setTexture("res/equipment/".._icon)   -- 新版本路径
        local imgBg = setNewEquipQualityWithFrame(_quality)
        game.setSpriteFrame(cell.itemBg, imgBg)

        cell.labelLevel:removeAllChildren()
        local levelNode = getLevelNode(equipData.strengthen_lv)
        cell.labelLevel:addChild(levelNode)

        local _gain = self.equipTemp:getGains(equipData.no)
        cell.equipValue:setString(table.getValueByIndex(_gain, 1)[1])
        print("1-----equipData.id----",equipData.id)
        -- table.print(equipData)
        cell.coinValue:setString(self.equipData:getStrengCoin(equipData.id))
        cell.equipName:setString(_name)
        cell.mainAttrLabel:setString(_descrip)
        cell.otherAttrLabel:setString(_descrip2)
        if _equipPrefix ~= 0 then
            cell.equipPrefix:setSpriteFrame(_equipPrefixRes)
        end

        cell.selectMenu:setVisible(self.selectIDTable[equipData.id]["selected"])

        return cell
    end

    local layerSize = self.contentLayer:getContentSize()
    self.greenTableView = cc.TableView:create(layerSize)

    self.greenTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.greenTableView:setDelegate()
    self.greenTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.greenTableView)

    self.greenTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.greenTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.greenTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.greenTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.greenTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableViewTable[1] = self.greenTableView  
end

function PVSelectSmeltEquip:createBlue()
    local function tableCellTouched(tbl, cell)
        print("cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.equipBlue)
    end
    local function cellSizeForTable(tbl, idx)
        return 145,555
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function selectMenuClick()
                local id = self.equipBlue[cell.index+1].id
                print(".................", id)

                if self.selectIDTable[id]["selected"] == true then
                    cell.selectMenu:setVisible(false)
                    self.selectIDTable[id]["selected"] = false
                else 
                    if self:checkLimitNum() == true then return end
                    cell.selectMenu:setVisible(true)
                    self.selectIDTable[id]["selected"] = true
                end
                self:updateSelectData()
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIEquipSmeltingItem"] = {}
            cell.cardinfo["UIEquipSmeltingItem"]["selectMenuClick"] = selectMenuClick
            local node = CCBReaderLoad("equip/ui_equip_smelting_item_new.ccbi", proxy, cell.cardinfo)

            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIEquipSmeltingItem"]["headIcon"]
            cell.equipPrefix = cell.cardinfo["UIEquipSmeltingItem"]["equipPrefix"]
            cell.equipName = cell.cardinfo["UIEquipSmeltingItem"]["equipName"]
            cell.mainAttrLabel = cell.cardinfo["UIEquipSmeltingItem"]["main_attr_label"]
            cell.otherAttrLabel = cell.cardinfo["UIEquipSmeltingItem"]["other_attr_label"]
            cell.labelLevel = cell.cardinfo["UIEquipSmeltingItem"]["label_lv"]
            cell.coinValue = cell.cardinfo["UIEquipSmeltingItem"]["coin_value"]
            cell.equipValue = cell.cardinfo["UIEquipSmeltingItem"]["equip_value"]
            cell.selectMenu = cell.cardinfo["UIEquipSmeltingItem"]["selectMenu"]
            cell.itemBg = cell.cardinfo["UIEquipSmeltingItem"]["itemBg"]

            cell:addChild(node)
        end
        cell.index = idx
        -- 获取数据中的值
        local equipData = table.getValueByIndex(self.equipBlue, idx+1)
        local equipmentItem = self.equipTemp:getTemplateById(equipData.no)
        local _name = self.languageTemp:getLanguageById(equipmentItem.name)
        local _equipPrefix = equipData.prefix

        local _nameImage = "ui_equip_kind_6"
        if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_6" end
        if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_5" end
        if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_4" end
        if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_3" end
        if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_2" end
        if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_1" end
        local _equipPrefixRes = _nameImage .. ".png"
        ------------ 属性 新表使用方式-----------
        --主属性
        local _descrip = ""
        local main_attr = self.c_Calculation:EquMainAttr(equipData)       --equipData.main_attr
        local mainNum = table.nums(main_attr)
        if mainNum == 0 then
            print("没有主属性")
        else
            _descrip = _descrip .. main_attr.AttrName.. " +" .. main_attr.Value
        end
        --次属性
        local _descrip2 = ""
        local minor_attr = self.c_Calculation:EquMinorAttr(equipData)       --equipData.minor_attr
        local ciNum = table.nums(minor_attr)
        if ciNum == 0 then 
            print("没有次属性")
        else
            for i=1,ciNum do
                _descrip2 = _descrip2 .. minor_attr[i].AttrName.. " +" .. minor_attr[i].Value
                if i%2 == 0 then
                    _descrip2 = _descrip2.."\n"
                end
            end
        end

        local _equipedWho = self.lineupData:getEquipTo(equipData.id)  
        -- local _icon = self.equipTemp:getEquipResIcon(equipData.no)  -- 资源名
        local _icon = self.equipTemp:getEquipResHD(equipData.no)
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质

        if _quality == 5 or _quality == 6 then cell.icon:setScale(0.5) 
        elseif _quality == 3 or _quality == 4 then  cell.icon:setScale(0.6)
        else cell.icon:setScale(0.65) end

        -- changeEquipIconImageBottom(cell.icon, _icon, _quality)  -- 设置卡的图片
        cell.icon:setTexture("res/equipment/".._icon)   -- 新版本路径
        local imgBg = setNewEquipQualityWithFrame(_quality)
        game.setSpriteFrame(cell.itemBg, imgBg )

        -- cell.labelLevel:setString("Lv."..equipData.strengthen_lv)
        cell.labelLevel:removeAllChildren()
        local levelNode = getLevelNode(equipData.strengthen_lv)
        cell.labelLevel:addChild(levelNode)

        local _gain = self.equipTemp:getGains(equipData.no)
        cell.equipValue:setString(table.getValueByIndex(_gain, 1)[1])
        if _equipPrefix ~= 0 then
            cell.equipPrefix:setSpriteFrame(_equipPrefixRes)
        end
        print("2-----equipData.id----",equipData.id)
        -- table.print(equipData)
        cell.coinValue:setString(self.equipData:getStrengCoin(equipData.id))
        cell.equipName:setString(_name)
        cell.mainAttrLabel:setString(_descrip)
        cell.otherAttrLabel:setString(_descrip2)

        if self.selectIDTable[equipData.id]["selected"] == true then 
            cell.selectMenu:setVisible(true)
        else
            cell.selectMenu:setVisible(false)
        end

        return cell
    end

    local layerSize = self.contentLayer:getContentSize()
    self.blueTableView = cc.TableView:create(layerSize)

    self.blueTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.blueTableView:setDelegate()
    self.blueTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.blueTableView)

    self.blueTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.blueTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.blueTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.blueTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.blueTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableViewTable[2] = self.blueTableView  
end

function PVSelectSmeltEquip:createPurple()
    local function tableCellTouched(tbl, cell)
        print("cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
       return table.nums(self.equipPurple)
    end
    local function cellSizeForTable(tbl, idx)
        return 145, 555
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function selectMenuClick()
                local id = self.equipPurple[cell.index+1].id
                print(".................", id)

                if self.selectIDTable[id]["selected"] == true then
                    cell.selectMenu:setVisible(false)
                    self.selectIDTable[id]["selected"] = false
                else 
                    if self:checkLimitNum() == true then return end
                    cell.selectMenu:setVisible(true)
                    self.selectIDTable[id]["selected"] = true
                end
                self:updateSelectData()
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIEquipSmeltingItem"] = {}
            cell.cardinfo["UIEquipSmeltingItem"]["selectMenuClick"] = selectMenuClick
            local node = CCBReaderLoad("equip/ui_equip_smelting_item_new.ccbi", proxy, cell.cardinfo)

            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIEquipSmeltingItem"]["headIcon"]
            cell.equipPrefix = cell.cardinfo["UIEquipSmeltingItem"]["equipPrefix"]
            cell.equipName = cell.cardinfo["UIEquipSmeltingItem"]["equipName"]
            cell.mainAttrLabel = cell.cardinfo["UIEquipSmeltingItem"]["main_attr_label"]
            cell.otherAttrLabel = cell.cardinfo["UIEquipSmeltingItem"]["other_attr_label"]
            cell.labelLevel = cell.cardinfo["UIEquipSmeltingItem"]["label_lv"]
            cell.coinValue = cell.cardinfo["UIEquipSmeltingItem"]["coin_value"]
            cell.equipValue = cell.cardinfo["UIEquipSmeltingItem"]["equip_value"]
            cell.selectMenu = cell.cardinfo["UIEquipSmeltingItem"]["selectMenu"]
            cell.itemBg = cell.cardinfo["UIEquipSmeltingItem"]["itemBg"]

            cell:addChild(node)
        end
        cell.index = idx
        -- 获取数据中的值
        local equipData = table.getValueByIndex(self.equipPurple, idx+1)
        local equipmentItem = self.equipTemp:getTemplateById(equipData.no)
        local _name = self.languageTemp:getLanguageById(equipmentItem.name)
        local _equipPrefix = equipData.prefix

        local _nameImage = "ui_equip_kind_6"
        if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_6" end
        if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_5" end
        if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_4" end
        if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_3" end
        if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_2" end
        if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_1" end
        local _equipPrefixRes = _nameImage .. ".png"
        ------------ 属性 新表使用方式-----------
         --主属性
        local _descrip = ""
        local main_attr = self.c_Calculation:EquMainAttr(equipData)       --equipData.main_attr
        local mainNum = table.nums(main_attr)
        if mainNum == 0 then
            print("没有主属性")
        else
            _descrip = _descrip .. main_attr.AttrName.. " +" .. main_attr.Value
        end
        --次属性
        local _descrip2 = ""
        local minor_attr = self.c_Calculation:EquMinorAttr(equipData)       --equipData.minor_attr
        local ciNum = table.nums(minor_attr)
        if ciNum == 0 then 
            print("没有次属性")
        else
            for i=1,ciNum do
                _descrip2 = _descrip2 .. minor_attr[i].AttrName.. " +" .. minor_attr[i].Value
                if i%2 == 0 then
                    _descrip2 = _descrip2.."\n"
                end
            end
        end
        --[[
        local str, valueB, valueG, other = self.equipTemp:getMainAttributeById(equipData.no)
        -- print("@", str, valueB, valueG, other)
        -- if other ~= nil then table.print(other) end

        local _descrip = ""
        local _descrip2 = ""
        if str ~= nil then 
            _descrip = str .. string.format( " + %d", roundNumber(valueB + valueG * equipData.strengthen_lv) )  -- 提升属性描述
        end
        for k,v in pairs(other) do
            local _value = string.format(" + %d", v[2])
            _descrip2 = _descrip2 .. v[1] .. _value .. "\n"
        end
        ]]
        local _equipedWho = self.lineupData:getEquipTo(equipData.id)  
        -- local _icon = self.equipTemp:getEquipResIcon(equipData.no)  -- 资源名
        local _icon = self.equipTemp:getEquipResHD(equipData.no)
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质

        -- changeEquipIconImageBottom(cell.icon, _icon, _quality)  -- 设置卡的图片
        -- cell.labelLevel:setString("Lv."..equipData.strengthen_lv)

        if _quality == 5 or _quality == 6 then cell.icon:setScale(0.5) 
        elseif _quality == 3 or _quality == 4 then  cell.icon:setScale(0.6)
        else cell.icon:setScale(0.65) end
        
        -- changeEquipIconImageBottom(cell.icon, _icon, _quality)  -- 设置卡的图片
        cell.icon:setTexture("res/equipment/".._icon)   -- 新版本路径
        local imgBg = setNewEquipQualityWithFrame(_quality)
        game.setSpriteFrame(cell.itemBg, imgBg )

        cell.labelLevel:removeAllChildren()
        local levelNode = getLevelNode(equipData.strengthen_lv)
        cell.labelLevel:addChild(levelNode)

        local _gain = self.equipTemp:getGains(equipData.no)
        cell.equipValue:setString(table.getValueByIndex(_gain, 1)[1])
        if _equipPrefix ~= 0 then
            cell.equipPrefix:setSpriteFrame(_equipPrefixRes)
        end
        print("3-----equipData.id----",equipData.id)
        -- table.print(equipData)
        cell.coinValue:setString(self.equipData:getStrengCoin(equipData.id))
        cell.equipName:setString(_name)
        cell.mainAttrLabel:setString(_descrip)
        cell.otherAttrLabel:setString(_descrip2)

        if self.selectIDTable[equipData.id]["selected"] == true then 
            cell.selectMenu:setVisible(true)
        else
            cell.selectMenu:setVisible(false)
        end

        return cell
    end

    local layerSize = self.contentLayer:getContentSize()
    self.purpleTableView = cc.TableView:create(layerSize)

    self.purpleTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.purpleTableView:setDelegate()
    self.purpleTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.contentLayer:addChild(self.purpleTableView)

    self.purpleTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.purpleTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.purpleTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.purpleTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.purpleTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)

    self.tableViewTable[3] = self.purpleTableView  
end

function PVSelectSmeltEquip:updateMenu(index)
    
    -- 设置currMenuIdx
    if index == nil then index = self.currMenuIdx
    else self.currMenuIdx = index 
    end

    -- 主菜单变色处理
    local size = table.getn(self.menuTable)
    for i = 1, size do 
        local item = self.menuTable[i]
        local norImg = self.normalTable[i]
        local selImg = self.selectTable[i]
        if i == index then
            item:setEnabled(false)
            norImg:setVisible(false)
            selImg:setVisible(true)
        else
            item:setEnabled(true)  
            norImg:setVisible(true)
            selImg:setVisible(false)
        end
    end

    -- tableview更新
    for k, v in pairs(self.tableViewTable) do
        if k == self.currMenuIdx then
            v:setVisible(true)
            v:reloadData()
            self:tableViewItemAction(v)
        else
            v:setVisible(false)
        end
    end

    -- update number
    self:updateItemNumber()

end

return PVSelectSmeltEquip

