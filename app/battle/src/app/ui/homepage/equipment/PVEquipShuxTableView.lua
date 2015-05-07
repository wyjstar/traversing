-- 装备属性（ +1000 ）的tableview
--[[
   @ 必须先调用setViewSize(size)
   @ 后调用initTableView()
]]

-- type == 1   装备属性


local PVEquipShuxTableView = class("PVEquipShuxTableView",function ()
    return cc.Node:create()
end)


function PVEquipShuxTableView:ctor()
    self.c_BaseTemplate = getTemplateManager():getBaseTemplate()
    -- self.c_ShopTemplate = getTemplateManager():getShopTemplate()
    self.c_EquipTemplate = getTemplateManager():getEquipTemplate()
    self.c_Calculation = getCalculationManager():getCalculation()
    self.c_EquipTemplate = getTemplateManager():getEquipTemplate()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()

    self:init()
   -- self:initTableView()

end


function PVEquipShuxTableView:init(size)

    self.listData = {}

    self.tableViewSize = nil

    -- self:initData(equipData, type)

end


--初始化属性
function PVEquipShuxTableView:initData(equipData, type)
    print("--------initData---------")
    print(equipData)
    table.print(equipData)
    print(type)


    local minor_attr = self.c_Calculation:EquMinorAttr(equipData)  --self.equipData.minor_attr
    -- local equipData = self.equipData
    local _maxLevel =  self.c_BaseTemplate:getMaxLevel()
    local minor_attr_temp = nil
    if  equipData.strengthen_lv < _maxLevel then 
        equipData.strengthen_lv = equipData.strengthen_lv + 1
        minor_attr_temp = self.c_Calculation:EquMinorAttr(equipData)
        equipData.strengthen_lv = equipData.strengthen_lv - 1
    else
        minor_attr_temp = self.c_Calculation:EquMinorAttr(equipData)
    end

    if self.level ~= nil and self.isAddNode == true then
        local _level = equipData.strengthen_lv
        equipData.strengthen_lv = self.level
        minor_attr_temp = self.c_Calculation:EquMinorAttr(equipData)
        equipData.strengthen_lv = _level
    end


    local ciNum = table.nums(minor_attr)
    if ciNum == 0 then 
        print("没有次属性")
        return
    else
        for i=1,ciNum do
            local _date = {}

            local str = minor_attr[i].AttrName
            -- print(str)

            local _num1 = minor_attr[i].Value
            local _num = minor_attr_temp[i].Value
            local _addNum = _num - _num1

            if self.isAddNode == true then
                _date.str = tostring(str.."    +".._num)
            else
                _date.str = tostring(str.."    +".._num1)
            end

            _date._addNum = _addNum
            self.listData[i] = _date
        end
    end
    cclog("-------------------qianghua---------"..equipData.no)
    local _quality = self.c_EquipTemplate:getQuality(equipData.no)    -- 装备品质
    self._color = self.c_StoneTemplate:getColorByQuality(_quality)

    -- self.labelOtherAttr1:setColor(_color)
    -- self.labelOtherAttr2:setColor(_color)

end

--创建TableView
function PVEquipShuxTableView:initTableView(equipData, type, _isAddNode, _level)
    self.isAddNode = _isAddNode
    self.level = _level
   
    self:initData(equipData, type)
    

    assert(self.tableViewSize ~= nil, "tableView size can not be nil ")
    self.tableView = cc.TableView:create(self.tableViewSize)
    --self.tableView:ignoreAnchorPointForPosition(false)
    -- self.tableView:setAnchorPoint(0,0)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    -- self.tableView:setPosition(7, -10)
    self.tableView:setDelegate()

    self:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  --Table数量
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)  --Index处Cell大小
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)   --Index处Cell

    self.tableView:setBounceable(false)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(self.tableViewSize.width,self.tableViewSize.height/2))
    self:addChild(scrBar,2)

    self.tableView:reloadData()
end


function PVEquipShuxTableView:setViewSize(size)

    self.tableViewSize = size
end


--列表单元个数
function PVEquipShuxTableView:numberOfCellsInTableView(table)

    return #self.listData
end

--单元大小
function PVEquipShuxTableView:cellSizeForTable(table, idx)

    -- return self.itemSize.height, self.width
    return 25, 250
end

--返回单元
function PVEquipShuxTableView:tableCellAtIndex(table, idx)

    local _date = self.listData[idx+1]
    local cell = table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    end

    local RGItem = {}
    RGItem["UIShuxNode"] = {}
   
    local proxy = cc.CCBProxy:create()
    local cellItem = CCBReaderLoad("equip/ui_shux_node.ccbi", proxy, RGItem)
    cell:addChild(cellItem)

    local shuxLabel = RGItem["UIShuxNode"]["shuxLabel"]
    local addLabel = RGItem["UIShuxNode"]["addLabel"]
    local addnode = RGItem["UIShuxNode"]["addnode"]

    -- if self.isAddNode == true then
    addnode:setVisible(self.isAddNode)
    
    shuxLabel:setString(_date.str)
    shuxLabel:setColor(self._color)
    addLabel:setString(_date._addNum)

    return cell
end




return PVEquipShuxTableView
