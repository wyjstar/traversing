
--商城里装备全部购买后现实列表
local PVShopEquBuySuccess = class("PVShopEquBuySuccess", BaseUIView)

function PVShopEquBuySuccess:ctor(id)
    PVShopEquBuySuccess.super.ctor(self, id)
    self.shopData = getDataManager():getShopData()
    self.commonData = getDataManager():getCommonData()
    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.equipData = getDataManager():getEquipmentData()
    self.languageTemp = getTemplateManager():getLanguageTemplate()  -- 中文
    self.c_Calculation = getCalculationManager():getCalculation()
end

function PVShopEquBuySuccess:onMVCEnter()
    self.allEquipments = self.funcTable[1]
    self.type = self.funcTable[2]
    cclog("-----PVShopEquBuySuccess:onMVCEnter------"..table.getn(self.allEquipments))
    game.addSpriteFramesWithFile("res/ccb/resource/ui_equip.plist")
    self.ccbiNode = {}       -- ccbi加载后返回的node
    self.ccbiRootNode = {}   -- ccb界面上的根节点
    -- self:initData()
    self:initTouchListener()
    if table.getn(self.allEquipments) > 1 then
        self:loadCCBI("shop/ui_shop_equ_success.ccbi", self.ccbiNode)
    else
        self:loadCCBI("shop/ui_shop_equ_success_2.ccbi", self.ccbiNode)
    end
    self:initView()
    if self.type ~= nil then
        
        self.curRuneList = self.allEquipments
        self:createRuneListView()
    else

        self:initData()
        self:createEquipListView()  --创建装备列表
    end

end

function PVShopEquBuySuccess:initTouchListener()
    local function onEnterClick()
        cclog("点击确定按钮")
        getAudioManager():playEffectButton2()
        self:onHideView()

        groupCallBack(GuideGroupKey.BTN_CLOSE_BUY_KUANG)
    end 
    local function menuBackClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end 
    self.ccbiNode["UIShopEquSuccess"] = {}
    self.ccbiNode["UIShopEquSuccess"]["backMenuClick"] = menuBackClick
    self.ccbiNode["UIShopEquSuccess"]["onEnter"] = onEnterClick

end

function PVShopEquBuySuccess:initView()
    self.ccbiRootNode = self.ccbiNode["UIShopEquSuccess"] 
    self.listLayer = self.ccbiRootNode["conLayer"]
    self.titleSpr = self.ccbiRootNode["titleSpr"]

    if self.type ~= nil then
        game.setSpriteFrame(self.titleSpr, "#ui_stage_s_gxnhd.png")
    end
end

function PVShopEquBuySuccess:initData()
    -- self.allEquipments = self.funcTable[1]
    --self.allEquipments = self.equipData:getEquipList()
    self.equipmentTable = {}
    local index = 1
    for k,v in pairs(self.allEquipments) do
        -- print("## equip no ", v.no)
        local etype = self.equipTemp:getTypeById(v.no)
        self.equipmentTable[index] = v
        index = index + 1
    end
    -- print("_+_+_+_+_+self.equipmentTable_+__+_+_+_+_+_+_+")
    -- table.print(self.equipmentTable)
    -- print("_+_+_+_+_+self.equipmentTable_+__+_+_+_+_+_+_+")

end

--给装备排序
-- @ param _equipList : 用EquipData中的数据
function PVShopEquBuySuccess:sortList()

    local function isEquip(id)
        return self:getIsEquip(id)
    end

    local function cmp1(a,b)  -- 已经装配的至于未装配上方 按照等级大>小，品质大>小 降序排序,
        local _isEquipedA = isEquip(a.id)
        local _isEquipedB = isEquip(b.id)
        if _isEquipedA > _isEquipedB then return true
        elseif _isEquipedA == _isEquipedB then
            if a.strengthen_lv > b.strengthen_lv then return true
            elseif a.strengthen_lv == b.strengthen_lv then
                local _qualityA = self.equipTemp:getQuality(a.no)
                local _qualityB = self.equipTemp:getQuality(b.no)
                if _qualityA > _qualityB then return true
                else return false end
            else return false
            end
        else return false
        end
    end

    table.sort(self.equipmentTable, cmp1)
    -- table.sort(self.equipCanSmeltTable, cmp1)
end

--创建装备的列表
function PVShopEquBuySuccess:createEquipListView()
  
    local function tableCellTouched(tbl, cell)
        print("PVEquipmentMain cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
        return table.nums(self.equipmentTable)
    end
    local function cellSizeForTable(tbl, idx)
        return 125,400
    end
    local function tableCellAtIndex(tbl, idx)
       
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local function onItemClick()
                self.curType = 1
                getAudioManager():playEffectButton2()
                self.shopData:setShopEquipTips(self.equipmentTable)   --------------------------
                local equipment = table.getValueByIndex(self.equipmentTable, cell:getIdx()+1)
                getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment, 2)
            end
           
            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIShopSucItem"] = {}
            cell.cardinfo["UIShopSucItem"]["onItemClick"] = onItemClick
            local node = CCBReaderLoad("shop/ui_shop_suc_item.ccbi", proxy, cell.cardinfo)
     
            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIShopSucItem"]["headIcon"]
            cell.equipPrefix = cell.cardinfo["UIShopSucItem"]["equipPrefix"]
            cell.equipName = cell.cardinfo["UIShopSucItem"]["equipName"]
            cell.minor_attr_label = cell.cardinfo["UIShopSucItem"]["descripLabel"]
            cell.main_attr_label = cell.cardinfo["UIShopSucItem"]["main_attr_label"]
            cell.labelLevel = cell.cardinfo["UIShopSucItem"]["label_lv"]
            cell.itemMenuItem = cell.cardinfo["UIShopSucItem"]["itemMenuItem"]
            cell:addChild(node)
        end
        cell.index = idx
        -- 获取数据中的值
        local equipData = table.getValueByIndex(self.equipmentTable, idx+1)
        local equipmentItem = self.equipTemp:getTemplateById(equipData.no)
        local _name = self.languageTemp:getLanguageById(equipmentItem.name)
        local _equipPrefix = equipData.prefix
        local _equipPrefixRes = _equipPrefix .. ".png"
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
        cell.main_attr_label:setString(_descrip)

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
                if i%3 == 0 then
                    _descrip = _descrip.."\n"
                end
            end
        end
        cell.minor_attr_label:setString(_descrip)
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质
        local _color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
        cell.minor_attr_label:setColor(_color)
     
        ------------------------------------------------------
        local _icon = self.equipTemp:getEquipResIcon(equipData.no)  -- 资源名
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质
       
        changeEquipIconImageBottom(cell.icon, _icon, _quality)  -- 设置卡的图片
     
        cell.labelLevel:setString("Lv."..equipData.strengthen_lv)
        cell.equipName:setString(_name)
        if _equipPrefix ~= 0 then
            -- cell.equipPrefix:setSpriteFrame(_equipPrefixRes)
        end
        cell.equipName:setColor(color)
        
            
        return cell
    end
    local tempTab = {}
    local proxy = cc.CCBProxy:create()
    local layerSize = self.listLayer:getContentSize()
    self.strengTableView = cc.TableView:create(layerSize)

    self.strengTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.strengTableView:setDelegate()
    self.strengTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.strengTableView)

    self.strengTableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.strengTableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.strengTableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.strengTableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.strengTableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.listLayer:addChild(scrBar,2)
    
    self.strengTableView:reloadData()

end

function PVShopEquBuySuccess:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_equip.plist")
    cclog("_+_+_+_+_+_+_+_+_+_+_+_+_+_+clearResource_+_+_+_+_+_+_+_+_+_+_+_+_")
end



function PVShopEquBuySuccess:createRuneListView()

    self.c_runeData = getDataManager():getRuneData()
    -- self.commonData = getDataManager():getCommonData()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()

    local function tableCellTouched(table, cell)
    end

    local function numberOfCellsInTableView(tab)
       return table.getn(self.curRuneList)
    end

    local function cellSizeForTable(table, idx)
        return 125,400
    end

    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:cellAtIndex(idx)

        if nil == cell then
            cell = cc.TableViewCell:new()
            local function onItemClick()
                -- self.curType = 1
                -- getAudioManager():playEffectButton2()
                -- self.shopData:setShopEquipTips(self.equipmentTable)   --------------------------
                -- local equipment = table.getValueByIndex(self.equipmentTable, cell:getIdx()+1)
                -- getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVEquipmentAttribute", equipment, 2)
            end

            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIShopSucItem"] = {}
            cell.cardinfo["UIShopSucItem"]["onItemClick"] = onItemClick
            local node = CCBReaderLoad("shop/ui_shop_suc_item.ccbi", proxy, cell.cardinfo)
            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIShopSucItem"]["headIcon"]
            cell.equipPrefix = cell.cardinfo["UIShopSucItem"]["equipPrefix"]
            cell.equipName = cell.cardinfo["UIShopSucItem"]["equipName"]
            cell.minor_attr_label = cell.cardinfo["UIShopSucItem"]["descripLabel"]
            cell.main_attr_label = cell.cardinfo["UIShopSucItem"]["main_attr_label"]
            cell.labelLevel = cell.cardinfo["UIShopSucItem"]["label_lv"]
            cell.labelLevel:setVisible(false)
            cell.itemMenuItem = cell.cardinfo["UIShopSucItem"]["itemMenuItem"]
            cell:addChild(node)
        end

        if table.nums(self.curRuneList) > 0 then
            --符文名称
            local nameId = self.c_StoneTemplate:getStoneItemById(self.curRuneList[idx + 1].runt_id).name
            local nameStr = self.c_LanguageTemplate:getLanguageById(nameId)
            cell.equipName:setString(nameStr)
            --符文icon
            local resId = self.c_StoneTemplate:getStoneItemById(self.curRuneList[idx + 1].runt_id).res
            local resIcon = self.c_ResourceTemplate:getResourceById(resId)
            local quality = self.c_StoneTemplate:getStoneItemById(self.curRuneList[idx + 1].runt_id).quality
            local icon = "res/icon/rune/" .. resIcon
            self.c_runeData:setItemImage(cell.icon, icon, quality)
            --符文属性
            local mainAttribute = self.curRuneList[idx + 1].main_attr
            local minorAttribute = self.curRuneList[idx + 1].minor_attr

            for k, v in pairs(mainAttribute) do
                
                local attr_type = v.attr_type
                local attr_value = v.attr_value
                attr_value = math.floor(attr_value * 10) / 10
                local typeStr = self.c_StoneTemplate:getAttriStrByType(attr_type)
                local mainAttriStr = typeStr .. "+" .. attr_value

                cell.main_attr_label:setString(mainAttriStr)
            end
             --次属性
            local _descrip = ""
            local ciNum = table.nums(minorAttribute)
            if ciNum == 0 then
                print("没有次属性")
            else
                local color = self.c_StoneTemplate:getColorByQuality(quality)
                cell.minor_attr_label:setColor(color)
                for i=1,ciNum do
                    local typeStr = self.c_StoneTemplate:getAttriStrByType(minorAttribute[i].attr_type)
                    local attr_value = math.floor(minorAttribute[i].attr_value * 10) / 10
                    -- local attriStr = typeStr .. "+" .. attr_value

                    _descrip = _descrip .. typeStr .. "+" .. attr_value
                    if i%3 == 0 then
                        _descrip = _descrip.."\n"
                    end
                end
            end
            
            cell.minor_attr_label:setString(_descrip)
        end

        return cell
    end


    local layerSize = self.listLayer:getContentSize()
    self.tableView = cc.TableView:create(layerSize)

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.listLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.listLayer:addChild(scrBar,2)

    self.tableView:reloadData()
    self:tableViewItemAction(self.tableView)
end



--@return
return PVShopEquBuySuccess
