

local PVBag = class("PVBag", BaseUIView)

function PVBag:ctor(id)
    PVBag.super.ctor(self, id)
end

function PVBag:onMVCEnter()
    game.addSpriteFramesWithFile("res/ccb/resource/ui_bag.plist")

    self:registerDataBack()

    self:initView()         --背包界面初始化

    self:initData()
    self:initTable()

end


function PVBag:registerDataBack()
end

--背包道具数据初始化
function PVBag:initData()
end

--界面初始化
function PVBag:initView()
    self.UIBagView = {}
    self:initTouchListener()
    self:loadCCBI("bag/ui_bag_view.ccbi", self.UIBagView)

    self.bagContentLayer = self.UIBagView["UIBagView"]["bagContentLayer"]
    self.animationManager = self.UIBagView["UIBagView"]["mAnimationManager"]
    self.totalNumber = self.UIBagView["UIBagView"]["totalNumber"]
end

function PVBag:initTable()
    local layerSize = self.bagContentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width - 20, layerSize.height))

    -- self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.bagContentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(self.scrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(self.scrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    self.tableView:reloadData()
end

function PVBag:initTouchListener()
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        showModuleView(MODULE_NAME_HOMEPAGE)
    end

    self.UIBagView["UIBagView"] = {}
    self.UIBagView["UIBagView"]["onCloseClick"] = onCloseClick

end

function PVBag:scrollViewDidScroll(view)
end

function PVBag:scrollViewDidZoom(view)
end

function PVBag:tableCellTouched(table, cell)
    print("cell:getIdx() =========== ", cell:getIdx())
end

function PVBag:cellSizeForTable(table, idx)
    return 100, 100
end

function PVBag:tableCellAtIndex(tabl, idx)
    local cell = tabl:dequeueCell()

    if nil == cell then
        cell = cc.TableViewCell:new()
        local x = 5
        for i = 1,  5 do
            cell.sprite = game.newSprite("#ui_common_pro.png")
            cell.sprite:setAnchorPoint(cc.p(0, 0))
            cell.sprite:setPosition(cc.p(x, 0))
            cell.sprite:setTag(idx * 5 + i)
            cell:addChild(cell.sprite)
            x = x + cell.sprite:getContentSize().width + 10
        end
    end

    for i = 1, 5 do
        local index = idx * 5 + i
        if index > 24 then
            cell.sprite:setVisible(false)
        else
            print()
            cell.sprite:setVisible(true)
        end
    end

    return cell
end

function PVBag:numberOfCellsInTableView(table)
    local count  = 24 / 5 + 1
   return count
end

return PVBag
