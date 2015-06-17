--选择装备页面
local PVSelectEquipment = class("PVSelectEquipment", BaseUIView)

function PVSelectEquipment:ctor(id)
    PVSelectEquipment.super.ctor(self, id)
    self.selectEquipId = -1
end

function PVSelectEquipment:onMVCEnter()
    self.UISelectEquip = {}

    self:initTouchListener()

    self:loadCCBI("lineup/ui_select_equipment.ccbi", self.UISelectEquip)

    self.lineupData = getDataManager():getLineupData()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()  -- 中文
    self.soldierTemp = getTemplateManager():getSoldierTemplate()

    -- self.basicAttributeView = createBasicAttributeView()
    -- self:addChild(self.basicAttributeView)
    -- self.basicAttributeView:showView()

    self.c_Calculation = getCalculationManager():getCalculation()


    self.seat = self.funcTable[1]
    self.fromType = self.funcTable[2]
    self.equipData = self.funcTable[3]
    print("------------g_equipData-------")
    --table.print(self.equipData)
    if self.equipData ~= nil then
        self.SingleEquCombatPower = self.c_Calculation:SingleEquCombatPower(self.equipData)
    end

    print("seat=="..self.seat)

    self:initView()
    self:createListView()
    self:updateData()
end

function PVSelectEquipment:updateData()

    self.equipmentTable = self.lineupData:getChangeEquip(self.seat)

    -- 如果是符文秘境进入的阵容
    if self.fromType ~= nil and self.fromType == FROM_TYPE_MINE then
        self.equipmentTable = self.lineupData:filterMineSelectedEquipment(self.seat)
    end

    for k,v in pairs(self.equipmentTable) do
        if v ~= nil then
            local _quality = getTemplateManager():getEquipTemplate():getTemplateById(v.no)
            v.power = self.c_Calculation:SingleEquCombatPower(v)
            v.quality = _quality.quality
            --table.print(v)
        end
    end

    -- table.print(self.equipmentTable)

    local function compairByQuality(item1, item2)
        equipmentPower1 = item1.power --self.c_Calculation:SingleEquCombatPower(item1.id)
        equipmentPower2 = item2.power --self.c_Calculation:SingleEquCombatPower(item2.id)
        return equipmentPower1 > equipmentPower2
    end

     table.sort(self.equipmentTable, compairByQuality)

    -- local function compairByLevel(item1, item2)
    --     if item1.quality == item2.quality then

    --         return item1.strengthen_lv > item2.strengthen_lv
    --     end

    --     return item1.quality > item2.quality
    -- end

    --  table.sort(self.equipmentTable, compairByLevel)
    local _num = table.nums(self.equipmentTable)
    self.equip_num:setString(tostring(_num))
    self.tableView:reloadData()
end

function PVSelectEquipment:initView()
    self.animationManager = self.UISelectEquip["UISelectEquip"]["mAnimationManager"]
    self.selectEquipLayer = self.UISelectEquip["UISelectEquip"]["selectEquipLayer"]
    self.equip_num = self.UISelectEquip["UISelectEquip"]["equip_num"]


end

function PVSelectEquipment:initTouchListener()
    local function backMenuClick()
       self:onHideView(-1)
    end
    self.UISelectEquip["UISelectEquip"] = {}
    self.UISelectEquip["UISelectEquip"]["backMenuClick"] = backMenuClick
end

function PVSelectEquipment:createListView()
    local function tableCellTouched(table, cell)
        print("PVSelectEquipment cell touched at index: " .. cell:getIdx())
    end

    local function numberOfCellsInTableView(tab)
       return table.nums(self.equipmentTable)
    end

    local function cellSizeForTable(table, idx)

        return self.itemSize.height,self.itemSize.width
    end

    local function tableCellAtIndex(tab, idx)
        local cell = tab:dequeueCell()
        if nil == cell then
            local function equipMenuClick()
                self:onHideView(cell.selectEquipId)
            end

            local function onItemClick()
                local equipData = table.getValueByIndex(self.equipmentTable, idx + 1)
                local equipment = getTemplateManager():getEquipTemplate():getTemplateById(equipData.no)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, nil)
            end

            cell = cc.TableViewCell:new()
            local typeName = "selectEquipType" .. idx
            cell.equipInfo = {}
            local proxy = cc.CCBProxy:create()
            cell.equipInfo["UISelectEquipItem"] = {}
            cell.equipInfo["UISelectEquipItem"]["equipMenuClick"] = equipMenuClick
            cell.equipInfo["UISelectEquipItem"]["onItemClick"] = onItemClick
            local node = CCBReaderLoad("lineup/ui_select_equip_item.ccbi", proxy, cell.equipInfo)
            cell:addChild(node)
        end
            cell.index = idx

            local equipData = table.getValueByIndex(self.equipmentTable, idx + 1)

            local equipmentItem = self.equipTemp:getTemplateById(equipData.no)

            local _equipedWho = self.lineupData:getEquipTo(equipData.id)
            local _Strenglevel = string.format(equipData.strengthen_lv)

            cell.dataId = equipmentItem.id  -- 将装备id绑定上
            cell.selectEquipId = equipData.id    --gid
            -- 获取Item上的控件
            local equipPrefix = cell.equipInfo["UISelectEquipItem"]["equipPrefix"]
            local equipName = cell.equipInfo["UISelectEquipItem"]["equipName"]
            local equipTo = cell.equipInfo["UISelectEquipItem"]["equipTo"]
            local lvLabel = cell.equipInfo["UISelectEquipItem"]["label_lv"]
            local iconSprite = cell.equipInfo["UISelectEquipItem"]["itemBg"]

            local yiZhuShouSprite = cell.equipInfo["UISelectEquipItem"]["yiZhuShouSprite"]
            local zhuangbeiBtn = cell.equipInfo["UISelectEquipItem"]["zhuangbeiBtn"]
            local mainAttrLabel = cell.equipInfo["UISelectEquipItem"]["mainLabel"]
            local otherAttrLabel = cell.equipInfo["UISelectEquipItem"]["descripLabel"]
            local arrowSpriteUp = cell.equipInfo["UISelectEquipItem"]["arrowSpriteUp"]
            local arrowSpriteDown = cell.equipInfo["UISelectEquipItem"]["arrowSpriteDown"]

            ---------------------------------------------------
            local _descrip = ""
            table.print(equipData.main_attr)
            local main_attr = self.c_Calculation:EquMainAttr(equipData)
            local mainNum = table.nums(main_attr)
            if mainNum == 0 then
                print("没有主属性")
            else
                _descrip = _descrip .. main_attr.AttrName.. " +" .. main_attr.Value
            end
            mainAttrLabel:setString(_descrip)

            --次属性
            local _descrip = ""
            table.print(equipData.minor_attr)
            local minor_attr = self.c_Calculation:EquMinorAttr(equipData)
            local ciNum = table.nums(minor_attr)
            if ciNum == 0 then
                print("没有次属性")
            else
                for i=1,ciNum do
                    _descrip = _descrip .. minor_attr[i].AttrName.. " +" .. minor_attr[i].Value
                    if i%2 == 0 then
                        _descrip = _descrip.."\n"
                    end
                end
            end
            otherAttrLabel:setString(_descrip)

            local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质
            local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
            otherAttrLabel:setColor(color)
            ------------------------------------------------------


            if self.fromType ~=nil and self.fromType == FROM_TYPE_MINE and equipmentItem.is_guard~= nil and equipmentItem.is_guard == true then
                yiZhuShouSprite:setVisible(true)
                zhuangbeiBtn:setEnabled(false)
                SpriteGrayUtil:drawSpriteTextureGray(zhuangbeiBtn:getNormalImage())
            end

            local _name = self.languageTemp:getLanguageById(equipmentItem.name)
            local _equipPrefix = equipData.prefix
            -- local _equipPrefixRes = _equipPrefix .. ".png"


            local _nameImage = "ui_equip_kind_6"
            if _equipPrefix == 3300030006 then _nameImage = "ui_equip_kind_6" end
            if _equipPrefix == 3300030005 then _nameImage = "ui_equip_kind_5" end
            if _equipPrefix == 3300030004 then _nameImage = "ui_equip_kind_4" end
            if _equipPrefix == 3300030003 then _nameImage = "ui_equip_kind_3" end
            if _equipPrefix == 3300030002 then _nameImage = "ui_equip_kind_2" end
            if _equipPrefix == 3300030001 then _nameImage = "ui_equip_kind_1" end
            -- print(">>>>>>>>>>>>>> _nameImage  " .. _nameImage)
            -- print(">>>>>>>>>>>>>> _equipPrefix  " .. _equipPrefix)
            local _equipPrefixRes = _nameImage .. ".png"

    
            equipName:setString(_name)

            if _equipPrefix ~= 0 then
                equipPrefix:setSpriteFrame(_equipPrefixRes)
            end

            equipTo:setString(_equipedWho)
            -- lvLabel:setString(_Strenglevel)

            lvLabel:removeAllChildren()
            local levelNode = getLevelNode(_Strenglevel)
            lvLabel:addChild(levelNode)

            local resIconStr = self.equipTemp:getEquipResIcon(equipData.no)

            local quality = equipmentItem.quality
            local _color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
            equipName:setColor(_color)
            -- setItemImage(iconSprite, resIconStr, quality) --全局()
            changeEquipIconImage(iconSprite, resIconStr, quality)
            --判断装备战斗力是否提升/下降
            if self.equipData ~= nil then
                self.SingleCurrEquCombatPower = self.c_Calculation:SingleEquCombatPower(equipData)
                if self.SingleCurrEquCombatPower < self.SingleEquCombatPower then
                    arrowSpriteDown:setVisible(true)
                    arrowSpriteUp:setVisible(false)
                elseif self.SingleCurrEquCombatPower > self.SingleEquCombatPower then
                    arrowSpriteUp:setVisible(true)
                    arrowSpriteDown:setVisible(false)
                else
                    arrowSpriteUp:setVisible(false)
                    arrowSpriteDown:setVisible(false)
                end
            end
        return cell
    end
    local layerSize = self.selectEquipLayer:getContentSize()
    self.itemSize = cc.size(layerSize.width, layerSize.height/5)
    self.tableView = cc.TableView:create(layerSize)

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.selectEquipLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.selectEquipLayer:addChild(scrBar,2)

end


return PVSelectEquipment
