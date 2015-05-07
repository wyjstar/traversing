-- 传承
-- 装备主页面
local PVInheritZBList = class("PVInheritZBList", BaseUIView)


function PVInheritZBList:ctor(id)
    PVInheritZBList.super.ctor(self, id)

    self.equipTemp = getTemplateManager():getEquipTemplate()
    self.c_EquipmentData = getDataManager():getEquipmentData()
    self.chipTemp = getTemplateManager():getChipTemplate()
    self.soldierTemp = getTemplateManager():getSoldierTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()  -- 中文
    self.resourceTemp = getTemplateManager():getResourceTemplate()
    self.lineupData = getDataManager():getLineupData()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.c_CommonData = getDataManager():getCommonData()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

end

function PVInheritZBList:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_equip.plist")

    self.UIInheritEquipment = {}

    self.currSubMenuIdx = 1
    self.level = self:getTransferData()[1]           --等级， 0 代表选择材料卡牌，等级大于1     ；其他代表小于该等级
    self.quality = self:getTransferData()[2]         --品质，必须品质相同

    self:initData()
    self:sortList()

    self:initTouchListener()
    self:loadCCBI("inherit/ui_inherit_equip.ccbi", self.UIInheritEquipment)
    self:initView()

    self.strengTableView:setVisible(true)
    self.strengTableView:reloadData()
    self:updateItemNumber()
end 

function PVInheritZBList:initData()
    
    self.allEquipments = self.c_EquipmentData:getEquipList()

    -- 将table的结构改成：{[1]={id,..},...}
    self.equipmentTable = {}  

    -- 初始化数据
    local index = 1
    for k,v in pairs(self.allEquipments) do
        local etype = self.equipTemp:getTypeById(v.no)
        local equality = self.equipTemp:getQuality(v.no)
        -- print(">>>>>>"..equality)
        if self.level == 0 then
            if v.strengthen_lv > 1 and etype ~= 5 and etype ~= 6  then 
                self.equipmentTable[index] = v
                index = index + 1
            end
        else
            local level = self.c_CommonData:getLevel() + self.c_BaseTemplate:getEquipStrengthMax()
            local etype = self.equipTemp:getTypeById(v.no)
            if v.strengthen_lv < self.level and equality == self.quality and etype ~= 5 and etype ~= 6 then 
                self.equipmentTable[index] = v
                index = index + 1
            end
        end
    end
    if self.level == 0 then
        if index == 1 then 
            cclog("没有大于等级1的装备")
        end
    else
        if index == 1 then 
            cclog("品质为"..self.quality.."的装备内，没有小于等级"..self.level.."的装备")
        end
    end
end

function PVInheritZBList:initView()

    self.qitaNode = self.UIInheritEquipment["UIInheritEquipment"]["qita"]

    self.listLayer = self.UIInheritEquipment["UIInheritEquipment"]["listLayer"]

    self.labelItemNum = self.UIInheritEquipment["UIInheritEquipment"]["equip_num"]

    self.nodeMenuBottom = self.UIInheritEquipment["UIInheritEquipment"]["botNode"]  --底部一排小按钮的Node，用来控制按钮们是否可见
    self.subMenuA = self.UIInheritEquipment["UIInheritEquipment"]["subMenuA"]       --底部小按钮
    self.subMenuB = self.UIInheritEquipment["UIInheritEquipment"]["subMenuB"]
    self.subMenuC = self.UIInheritEquipment["UIInheritEquipment"]["subMenuC"]
    self.subMenuD = self.UIInheritEquipment["UIInheritEquipment"]["subMenuD"]
    self.subMenuE = self.UIInheritEquipment["UIInheritEquipment"]["subMenuE"]

    self.subMenuTable = {} -- 存子菜单的按钮
    table.insert(self.subMenuTable, self.subMenuA)
    table.insert(self.subMenuTable, self.subMenuB)
    table.insert(self.subMenuTable, self.subMenuC)
    table.insert(self.subMenuTable, self.subMenuD)
    table.insert(self.subMenuTable, self.subMenuE)
    self.subMenuA:setEnabled(false)
    
    self.nodeNumber = self.UIInheritEquipment["UIInheritEquipment"]["num_node"]    --数量label的Node

    self:createEquipListView()
end


function PVInheritZBList:getIsEquip(id)
    local _equipedWho = self.lineupData:getEquipTo(id)  
    if _equipedWho == Localize.query("equip.1") then 
        return 0
    else
        return 1
    end
end

--给装备排序
-- @ param _equipList : 用EquipData中的数据
function PVInheritZBList:sortList()
    cclog("---- 给装备排序 ----")

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

end

--更新子tab，进行分类 
function PVInheritZBList:updateSubMenuState(idx)
    self.currSubMenuIdx = idx
    --更新界面
    local size = table.getn(self.subMenuTable)
    for i = 1, size do 
        local item = self.subMenuTable[i]
        if i == idx then
            item:setEnabled(false)
        else
            item:setEnabled(true)
        end
    end

    --更新数据
    self.equipmentTable = {}

    local index = 1
    if idx == 1 then
        for k,v in pairs(self.allEquipments) do
            local etype = self.equipTemp:getTypeById(v.no)
            local equality = self.equipTemp:getQuality(v.no)
            -- print(">>>>>>"..equality)
            if self.level == 0 then
                if v.strengthen_lv > 1 then 
                    self.equipmentTable[index] = v
                    index = index + 1
                end
            else
                if v.strengthen_lv < self.level and equality == self.quality then 
                    self.equipmentTable[index] = v
                    index = index + 1
                end
            end
        end
        if self.level == 0 then
            if index == 1 then 
                print("没有大于等级1的装备")
            end
        else
            if index == 1 then 
                print("品质为"..self.quality.."的装备内，没有小于等级"..self.level.."的装备")
            end
        end

    else
        --将所有装备中的选中的类型的装备取出
        local _index = 1
            for k,v in pairs(self.allEquipments) do
                local etype = self.equipTemp:getTypeById(v.no)
                local equality = self.equipTemp:getQuality(v.no)
                -- print(">>>>>>"..equality)
                if self.level == 0 then
                    if v.strengthen_lv > 1 and etype == idx-1 then 
                        self.equipmentTable[index] = v
                        index = index + 1
                    end
                else
                    if v.strengthen_lv < self.level and equality == self.quality and etype == idx-1 then 
                        self.equipmentTable[index] = v
                        index = index + 1
                    end
                end
            end
            if self.level == 0 then
                if index == 1 then 
                    print("没有大于等级1的装备")
                end
            else
                if index == 1 then 
                    print("品质为"..self.quality.."的装备内，没有小于等级"..self.level.."的装备")
                end
            end

    end

    --排序
    self:sortList()

    self.strengTableView:reloadData()

    self:updateItemNumber()

    -- self:resetSelectSmeltItem()
end

function PVInheritZBList:updateItemNumber()
    -- 更新列表中的数量
    local _num = table.nums(self.equipmentTable)
    self.labelItemNum:setString(string.format(_num))
end

-- 给界面添加触控事件
function PVInheritZBList:initTouchListener()

    local function backMenuClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    ---- 分类显示 ----
    local function subMenuClickA()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(1)
    end
    local function subMenuClickB()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(2)
    end
    local function subMenuClickC()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(3)
    end
    local function subMenuClickD()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(4)
    end
    local function subMenuClickE()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(5)
    end
    local function subMenuClickF()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(6)
    end
    local function subMenuClickG()
        getAudioManager():playEffectButton2()
        self:updateSubMenuState(7)
    end
   

    self.UIInheritEquipment["UIInheritEquipment"] = {}
    self.UIInheritEquipment["UIInheritEquipment"]["backMenuClick"] = backMenuClick

    self.UIInheritEquipment["UIInheritEquipment"]["subMenuClickA"] = subMenuClickA
    self.UIInheritEquipment["UIInheritEquipment"]["subMenuClickB"] = subMenuClickB
    self.UIInheritEquipment["UIInheritEquipment"]["subMenuClickC"] = subMenuClickC
    self.UIInheritEquipment["UIInheritEquipment"]["subMenuClickD"] = subMenuClickD
    self.UIInheritEquipment["UIInheritEquipment"]["subMenuClickE"] = subMenuClickE
    self.UIInheritEquipment["UIInheritEquipment"]["subMenuClickF"] = subMenuClickF
    self.UIInheritEquipment["UIInheritEquipment"]["subMenuClickG"] = subMenuClickG

end

--创建装备的列表
function PVInheritZBList:createEquipListView()
    cclog("－－－－－－ createEquipListView －－－－－－")
    
    local function tableCellTouched(tbl, cell)
        print("PVInheritZBList cell touched at index: " .. cell:getIdx())
    end
    local function numberOfCellsInTableView(tab)
        -- cclog(table.nums(self.equipmentTable))
       return table.nums(self.equipmentTable)
    end
    local function cellSizeForTable(tbl, idx)
        return self.itemSizeA.height,self.itemSizeA.width
    end
    local function tableCellAtIndex(tbl, idx)
        local cell = tbl:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function inheritMenuClick()
                local equipment = table.getValueByIndex(self.equipmentTable, cell:getIdx()+1)
                -- table.print(equipment)

                local _equipedWho = self.lineupData:getEquipTo(equipment.id)  
                if _equipedWho == Localize.query("equip.1") then 
                    if self.level == 0 then
                        getDataManager():getInheritData():setequId1(equipment)
                    else
                        getDataManager():getInheritData():setequId2(equipment)
                    end

                    local event = cc.EventCustom:new(UPDATE_VIEW)
                    self:getEventDispatcher():dispatchEvent(event)
                    self:onHideView()
                else
                    local  sure = function()
                        if self.level == 0 then
                            getDataManager():getInheritData():setequId1(equipment)
                        else
                            getDataManager():getInheritData():setequId2(equipment)
                        end

                        local event = cc.EventCustom:new(UPDATE_VIEW)
                        self:getEventDispatcher():dispatchEvent(event)
                        self:onHideView()
                    end
                    local cancel = function()
                        getOtherModule():clear()
                    end
                    getOtherModule():showConfirmDialog(sure, cancel, "该装备目前被武将穿戴，确定选择？")
                    return
                end
   
            end
            cell.cardinfo = {}
            local proxy = cc.CCBProxy:create()
            cell.cardinfo["UIInheritEquipItem"] = {}
            cell.cardinfo["UIInheritEquipItem"]["strengMenuClick"] = detailMenuClick
            cell.cardinfo["UIInheritEquipItem"]["inheritMenuClick"] = inheritMenuClick
            local node = CCBReaderLoad("inherit/ui_inherit_equip_item.ccbi", proxy, cell.cardinfo)

            -- 获取Item上的控件
            cell.icon = cell.cardinfo["UIInheritEquipItem"]["headIcon"]
            cell.equipName = cell.cardinfo["UIInheritEquipItem"]["equipName"]
            cell.mainAttrLabel = cell.cardinfo["UIInheritEquipItem"]["descripLabel"]
            cell.main_attr_label = cell.cardinfo["UIInheritEquipItem"]["main_attr_label"]
            cell.labelZBY = cell.cardinfo["UIInheritEquipItem"]["label_zby"]
            cell.equipTo = cell.cardinfo["UIInheritEquipItem"]["equipTo"]
            -- cell.menuIcon = cell.cardinfo["UIInheritEquipItem"]["iconMenu"]
            cell.labelLevel = cell.cardinfo["UIInheritEquipItem"]["label_lv"]
            cell.inheritMenu = cell.cardinfo["UIInheritEquipItem"]["inheritMenu"]
            cell.strengMenu = cell.cardinfo["UIInheritEquipItem"]["strengMenu"]
            cell.equipPrefix = cell.cardinfo["UIInheritEquipItem"]["equipPrefix"]
            cell.itemBg = cell.cardinfo["UIInheritEquipItem"]["itemBg"]
            
            cell.inheritMenu:setVisible(true)
            cell.strengMenu:setVisible(false)

            cell:addChild(node)
        end

        cell.index = idx
        -- 获取数据中的值
        local equipData = table.getValueByIndex(self.equipmentTable, idx+1)
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

        if _equipPrefix ~= 0 then
            cell.equipPrefix:setSpriteFrame(_equipPrefixRes)
        end

        ---------------------------------------------------
        local _descrip = ""

        -- 传承前主属性
        local main_attr = self.c_Calculation:EquMainAttr(equipData)
        local nowValue = 0
        local mainNum = table.nums(main_attr)
        if mainNum == 0 then 
            print("没有主属性")
        else
            _descrip = main_attr.AttrName.. "   +" .. main_attr.Value
            nowValue = main_attr.Value
        end
        cell.main_attr_label:setString(_descrip)

        
        --次属性
        local _descrip = ""
        table.print(equipData.minor_attr)
        -- local minor_attr = equipData.minor_attr
        local minor_attr = self.c_Calculation:EquMinorAttr(equipData)
        local ciNum = table.nums(minor_attr)
        if ciNum == 0 then 
            print("没有次属性")
        else
            for i=1,ciNum do
                _descrip = _descrip .. minor_attr[i].AttrName.. " +" .. minor_attr[i].Value
                if i%2 == 0 then
                    _descrip = _descrip.."\n"
                else
                    _descrip = _descrip.."  \t"
                end
            end
        end
        cell.mainAttrLabel:setString(_descrip)
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质
        local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
        cell.mainAttrLabel:setColor(color)

        -- local _equipedWho = self.lineupData:getEquipTo(equipData.id)  
        local _equipedWho, color = self.lineupData:getEquipTo(equipData.id)
        local _icon = self.equipTemp:getEquipResIcon(equipData.no)  -- 资源名
        local _quality = self.equipTemp:getQuality(equipData.no)    -- 装备品质

        local resIcon = self.equipTemp:getEquipResHD(equipData.no)        -- 新版本icon
        
        if _quality == 5 or _quality == 6 then cell.icon:setScale(0.5) 
        elseif _quality == 3 or _quality == 4 then  cell.icon:setScale(0.6)
        else cell.icon:setScale(0.65) end

        cell.icon:setTexture("res/equipment/"..resIcon)   -- 新版本路径
        local imgBg = setNewEquipQualityWithFrame(_quality)
        game.setSpriteFrame(cell.itemBg, imgBg )

        cell.labelLevel:setString(equipData.strengthen_lv)
        cell.equipName:setString(_name)
        cell.equipName:setColor(color)

        if _equipedWho == Localize.query("equip.1") then
            cell.labelZBY:setVisible(false)
            cell.equipTo:setString(_equipedWho)
            cell.equipTo:setColor(ui.COLOR_WHITE)
        else
            cell.labelZBY:setVisible(true)
            cell.equipTo:setString(_equipedWho)
            cell.equipTo:setColor(color)
        end

        return cell
    end


    local tempTab = {}
    local proxy = cc.CCBProxy:create()
    CCBReaderLoad("inherit/ui_inherit_equip_item.ccbi", proxy, tempTab)
    local node = tempTab["UIInheritEquipItem"]["sizeLayer"]
    local layerSize = self.listLayer:getContentSize()
    self.itemSizeA = node:getContentSize()
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
end

function PVInheritZBList:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_equip.plist")
end

--@return
return PVInheritZBList
