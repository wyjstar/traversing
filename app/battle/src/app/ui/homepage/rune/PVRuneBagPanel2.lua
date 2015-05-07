local CustomScrollView = import("....util.CustomScrollView")
local CustomLabelMenu = import("....util.CustomLabelMenu")
local CustomLabelItem = import("....util.CustomLabelItem")

local PVRuneItem = import(".PVRuneItem")
local PVRuneBagPanel = class("PVRuneBagPanel", BaseUIView)

local TypeIndex = {
    XIANGQIAN = 1,
    LIANHUA = 2,
    CHANGE = 3
}

function PVRuneBagPanel:ctor(id)
    self.super.ctor(self, id)
    self.scrollView = nil
    self.UIRuneBagPanel = {}
    self.c_runeData = getDataManager():getRuneData()
    self.c_StoneTemplate = getTemplateManager():getStoneTemplate()
    self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    self.c_ResourceTemplate = getTemplateManager():getResourceTemplate()
    self.c_runeNet = getNetManager():getRuneNet()
end

function PVRuneBagPanel:onMVCEnter()
    self.typeIndex = self.funcTable[1]      --typeIndex 1:从符文镶嵌界面跳转  2:从符文炼化界面跳转  3:查看界面 更换符文    
    if self.typeIndex == TypeIndex.CHANGE then
        self.runeObj = self.c_runeData:getPreRuneItem()
    else
        self.runeObj = self.funcTable[2]        --{rune_no=符文id, runeType=符文类型, runePos=符文位置}            
    end
    --初始化顺序不可更换
    self:initData()
    self:initTouch()
	self:initView()
end

function PVRuneBagPanel:initData()
    local runeList = self.c_runeData:getBagRunes()
    --1 生命 2 攻击 3 物防  4 法防
    self.soldierRunes = {{},{},{},{}}
    self.selectRunes = self.c_runeData:getSelectRunes()

    for k, v in pairs(runeList) do
        local runeData = self.c_StoneTemplate:getStoneItemById(v.runt_id)
        local runeName = self.c_LanguageTemplate:getLanguageById(runeData.name)
        local runeIcon = self.c_ResourceTemplate:getResourceById(runeData.res)
        local ston1Num = self.c_StoneTemplate:getStone1ById(v.runt_id)--原石
        local ston2Num = self.c_StoneTemplate:getStone2ById(v.runt_id)--精石
        local runeItem = {runt_no=v.runt_no,
                          runt_id=v.runt_id,                          
                          runeType=runeData.type,
                          quality = runeData.quality,
                          rune_icon = runeIcon,
                          rune_name = runeName,
                          main_attr = v.main_attr,
                          minor_attr = v.minor_attr, 
                          selected = false,                        
                          stone1=ston1Num,stone2=ston2Num}
        --是否已选择                  
        runeItem["selected"] = self:isSelectedRune(runeItem)
        
        --需要特殊处理，显示不同效果
        if self.runeObj and self.runeObj.runt_no and self.runeObj.runt_no == v.runt_no then
        end
        table.insert(self.soldierRunes[runeItem.runeType], runeItem)
    end
    --背包一次性选择最大数值初始化
    if self.typeIndex == TypeIndex.XIANGQIAN or self.typeIndex == TypeIndex.CHANGE then
        self.maxCount = 1
    elseif self.typeIndex == TypeIndex.LIANHUA then
        self.maxCount = 8 - #self.selectRunes
    end
end

function PVRuneBagPanel:isSelectedRune(runeItem)
    --已经选择的符文
    for i = 1, #self.selectRunes do
        if self.selectRunes[i].runt_no == runeItem.runt_no then
            return true
        end 
    end
    return false
end

function PVRuneBagPanel:initView()
    self:loadCCBI("rune/ui_rune_select.ccbi", self.UIRuneBagPanel)
    --标签头
    --自己的原石和精石数量
    self.UIRuneBagPanel["SelectRunePanel"]["yuanbao_num"]:setString(self.c_runeData:getStone2())
    self.UIRuneBagPanel["SelectRunePanel"]["yinding_num"]:setString(self.c_runeData:getStone1())
    --头部标签
    self.labelMenu = CustomLabelMenu.new(self.UIRuneBagPanel["SelectRunePanel"]["btn_node"])
    --生命
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIRuneBagPanel["SelectRunePanel"]["btn_life"], function()
        self:initRuneView(self.soldierRunes[1])
    end))
    --攻击
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIRuneBagPanel["SelectRunePanel"]["btn_attack"], function()
        self:initRuneView(self.soldierRunes[2])
    end))
    --物理防御
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIRuneBagPanel["SelectRunePanel"]["btn_pdef"], function()
        self:initRuneView(self.soldierRunes[3])
    end))
    --法术防御
    self.labelMenu:addMenuItem(CustomLabelItem.new(self.UIRuneBagPanel["SelectRunePanel"]["btn_fdef"], function()
        self:initRuneView(self.soldierRunes[4])
    end))
    --传递了符文对象
    if self.runeObj and self.runeObj.runeType then
        assert(self.runeObj.runeType <= 4 and self.runeObj.runeType >= 1, "rune type error:"..self.runeObj.runeType)
        self.labelMenu:changeLabel(self.runeObj.runeType)
    else
        self.labelMenu:changeLabel(1)
    end
end

function PVRuneBagPanel:initRuneView(runes)
    --初始化符文
    if self.scrollView then
        self.scrollView:clear()
    elseif #runes > 0 then
        self.scrollView = CustomScrollView.new(self.UIRuneBagPanel["SelectRunePanel"]["scrollRect"])
        self.scrollView:setDelegate(self)
    end

    for i =1 , #runes do
        local item = PVRuneItem.new(runes[i])
        self.scrollView:addCell(item)
    end
end

function PVRuneBagPanel:onClickScrollViewCell(cell)
    --查看处理
    local data = cell:getData()
    if cell:isClickStone() then
        getOtherModule():showOtherView("PVRuneLook", data, 3)
        return
    end
    --选择处理    
    if not self.maxCount or self.maxCount == 0 then return end

    if cell:isClickCheck() then
        cell:clickCheck()
        if self.maxCount and self.maxCount > #self.selectRunes and cell:isChecked() then
            self.selectRunes[#self.selectRunes + 1] = data                          
        elseif not cell:isChecked() then --取消选择
            for i = 1, #self.selectRunes do
                if self.selectRunes[i].runt_no == data.runt_no then
                    table.remove(self.selectRunes, i)
                    break
                end 
            end            
        end
    end
end

function PVRuneBagPanel:initTouch()
    local function onClickBack()
        self.c_runeData:setSelectRunes(nil)
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    local function onClickConfirm()
        getAudioManager():playEffectButton2()
        --符文镶嵌
        if self.typeIndex == TypeIndex.XIANGQIAN then
            local selectedItem = self.selectRunes[1]
            if selectedItem and self.runeObj.runePos then
                self.c_runeData:setCurRuneItem(selectedItem)
                self.c_runeData:setSelectRunes(nil)                
                local curSoldierId = self.c_runeData:getCurSoliderId()               
                self.c_runeNet:sendAddRune(curSoldierId, selectedItem.runeType, self.runeObj.runePos, selectedItem.runt_no)               
            end
        --更换
        elseif self.typeIndex == TypeIndex.CHANGE then
            local selectedItem = self.selectRunes[1]
            if selectedItem then
                local haveCoin = getDataManager():getCommonData():getCoin()
                local pickPrice = self.c_StoneTemplate:getPickPriceById(self.runeObj.runt_id)
                local curSoldierId = self.c_runeData:getCurSoliderId()

                if haveCoin >= pickPrice then
                    local changeItem = clone(selectedItem)
                    changeItem.deleteType = 3
                    changeItem.runePos = self.runeObj.runePos
                    self.c_runeData:setChangeRune(changeItem)
                    self.c_runeData:setSelectRunes(nil)                     
                    self.c_runeNet:sendDeleRune(curSoldierId, self.runeObj.runeType, self.runeObj.runePos)
                else
                    getOtherModule():showAlertDialog(nil, Localize.query(101))
                end      
            end
        --符文炼化
        elseif self.typeIndex == TypeIndex.LIANHUA then
            self.c_runeData:setSelectRunes(self.selectRunes)
        end
        self:onHideView()
    end
    self.UIRuneBagPanel["SelectRunePanel"] = {}
    self.UIRuneBagPanel["SelectRunePanel"]["onClickBack"] = onClickBack
    self.UIRuneBagPanel["SelectRunePanel"]["onClickConfirm"] = onClickConfirm
end

return PVRuneBagPanel
