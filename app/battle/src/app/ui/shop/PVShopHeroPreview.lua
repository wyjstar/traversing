--武将预览界面

local CustomScrollView = import("...util.CustomScrollView")
local PVShopPreviewHeroItem = import(".PVShopPreviewHeroItem")

--CustomScrollView 参数设置
local COLUMN_NUM = 3
local COLUMN_SPACE = 10

local PVShopHeroPreview = class("PVShopHeroPreview", BaseUIView)

function PVShopHeroPreview:ctor(id)
    self.super.ctor(self, id)
end

function PVShopHeroPreview:onMVCEnter()
    self:init()
    self:initTouchListener()
    self:loadCCBI("shop/ui_shop_hero_preview.ccbi", self.ccbiNode)
    self:initView()
end

function PVShopHeroPreview:init()
	self.ccbiNode = {}
	assert(self.funcTable[1], "must to give data to PVShopHeroPreview View !")
    self.allHeroesTable = self.funcTable[1]   --英雄列表
    print("self.heroesTable====")
    table.print(self.heroesTable)
    self.heroesTable = self.allHeroesTable
    self.heroTemp = getTemplateManager():getSoldierTemplate()
end

function PVShopHeroPreview:initView()
    --武将列表
    self.contentLayer = self.ccbiNode["UIShopHeroPreview"]["contentLayer"]
	--下边的职业菜单
	self.jobImgSelect = {1,2,3,4,5,6}
    self.jobImgNormal = {1,2,3,4,5,6}
    --全部
    self.jobImgSelect[1] = self.ccbiNode["UIShopHeroPreview"]["selected1"]
    self.jobImgNormal[1] = self.ccbiNode["UIShopHeroPreview"]["normal1"]
    --猛将
    self.jobImgSelect[2] = self.ccbiNode["UIShopHeroPreview"]["selected2"]
    self.jobImgNormal[2] = self.ccbiNode["UIShopHeroPreview"]["normal2"]
    --禁卫
    self.jobImgSelect[3] = self.ccbiNode["UIShopHeroPreview"]["selected3"]
    self.jobImgNormal[3] = self.ccbiNode["UIShopHeroPreview"]["normal3"]
    --游侠
    self.jobImgSelect[4] = self.ccbiNode["UIShopHeroPreview"]["selected4"]
    self.jobImgNormal[4] = self.ccbiNode["UIShopHeroPreview"]["normal4"]
    --谋士
    self.jobImgSelect[5] = self.ccbiNode["UIShopHeroPreview"]["selected5"]
    self.jobImgNormal[5] = self.ccbiNode["UIShopHeroPreview"]["normal5"]
    --方士
    self.jobImgSelect[6] = self.ccbiNode["UIShopHeroPreview"]["selected6"]
    self.jobImgNormal[6] = self.ccbiNode["UIShopHeroPreview"]["normal6"]

    for i=1,6 do
        self.jobImgSelect[i]:setScale(0.9)
        self.jobImgNormal[i]:setScale(0.9)
    end

    self.subMenuTable = {}
    for i=1,6 do
        local strMenu = "subMenu"..tostring(i)
        local menu = self.ccbiNode["UIShopHeroPreview"][strMenu]  --底部小按钮
        table.insert(self.subMenuTable, menu)
    end

    self:updateSubMenuSate(1)
    --武将显示设置
    self.itemNodeTable = {}
    for k,v in pairs(self.heroesTable) do
        print("heroItem========",k)
        table.print(v)
        local node = PVShopPreviewHeroItem.new(v)
        table.insert(self.itemNodeTable,node)
    end

    --初始化CustomScrollView
    self.itemCount = #self.itemNodeTable
    local otherCondition = {}
    otherCondition.columns = COLUMN_NUM
    if self.itemCount % COLUMN_NUM ~= 0 then
        otherCondition.rows = self.itemCount / COLUMN_NUM + 1
    else
        otherCondition.rows = self.itemCount / COLUMN_NUM
    end
    otherCondition.columnspace = COLUMN_SPACE
    self.scrollView = CustomScrollView.new(self.contentLayer, otherCondition)
    self.scrollView:setDelegate(self)
    if self.scrollView ~= nil then
        for i = 1 , tonumber(self.itemCount) do
            local item = self.itemNodeTable[i]
            self.scrollView:addCell(item)
        end
    end

end

function PVShopHeroPreview:reloadHeroList()
    self.itemNodeTable = {}
    for k,v in pairs(self.heroesTable) do
        local node = PVShopPreviewHeroItem.new(v)
        table.insert(self.itemNodeTable,node)
    end
    self.itemCount = #self.itemNodeTable
    if self.scrollView ~= nil then
        self.scrollView:clear()
        for i = 1 , tonumber(self.itemCount) do
            local item = self.itemNodeTable[i]
            self.scrollView:addCell(item)
        end
    end
end

function PVShopHeroPreview:initTouchListener()
	local function clickSubMenuA()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(1)
    end
    local function clickSubMenuB()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(2)
    end
    local function clickSubMenuC()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(3)
    end
    local function clickSubMenuD()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(4)
    end
    local function clickSubMenuE()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(5)
    end
    local function clickSubMenuF()
        getAudioManager():playEffectButton2()
        self:updateSoldierData(6)
    end
    local function onClickCloseBtn()
    	getAudioManager():playEffectButton2()
        self:onHideView()
    end
    self.ccbiNode["UIShopHeroPreview"] = {}
    self.ccbiNode["UIShopHeroPreview"]["subMenuClickA"] = clickSubMenuA
    self.ccbiNode["UIShopHeroPreview"]["subMenuClickB"] = clickSubMenuB
    self.ccbiNode["UIShopHeroPreview"]["subMenuClickC"] = clickSubMenuC
    self.ccbiNode["UIShopHeroPreview"]["subMenuClickD"] = clickSubMenuD
    self.ccbiNode["UIShopHeroPreview"]["subMenuClickE"] = clickSubMenuE
    self.ccbiNode["UIShopHeroPreview"]["subMenuClickF"] = clickSubMenuF
    self.ccbiNode["UIShopHeroPreview"]["onClickCloseBtn"] = onClickCloseBtn
end

function PVShopHeroPreview:onClickScrollViewCell(cell, curData)
    print("onClickScrollViewCell")

end

function PVShopHeroPreview:updateSubMenuSate(idx)
    if idx ~= nil then
        self.currSubMenuIdx = idx
    else
        idx = 1
    end
    print("self.currSubMenuIdx", self.currSubMenuIdx)

    --更新界面
    local size = table.getn(self.subMenuTable)
    for i = 1, size do
        local item = self.subMenuTable[i]
        if i == self.currSubMenuIdx then
            item:setEnabled(false)
            self.jobImgSelect[i]:setVisible(true)
            self.jobImgNormal[i]:setVisible(false)
        else
            item:setEnabled(true)
            self.jobImgSelect[i]:setVisible(false)
            self.jobImgNormal[i]:setVisible(true)
        end
    end
end

function PVShopHeroPreview:updateSoldierData(idx)
	self:updateSubMenuSate(idx)
    --更新数据
    if idx == 1 then
        self.heroesTable = self.allHeroesTable
    elseif idx == 2 then
        self.heroesTable = {}
        for k,v in pairs(self.allHeroesTable) do
            if self.heroTemp:getHeroTypeId(v) == 1 then
                table.insert(self.heroesTable,v)
            end
        end
    elseif idx == 3 then
        self.heroesTable = {}
        for k,v in pairs(self.allHeroesTable) do
            if self.heroTemp:getHeroTypeId(v) == 2 then
                table.insert(self.heroesTable,v)
            end
        end
    elseif idx == 4 then
        self.heroesTable = {}
        for k,v in pairs(self.allHeroesTable) do
            if self.heroTemp:getHeroTypeId(v) == 3 then
                table.insert(self.heroesTable,v)
            end
        end
    elseif idx == 5 then
        self.heroesTable = {}
        for k,v in pairs(self.allHeroesTable) do
            if self.heroTemp:getHeroTypeId(v) == 4 then
                table.insert(self.heroesTable,v)
            end
        end
    elseif idx == 6 then
        self.heroesTable = {}
        for k,v in pairs(self.allHeroesTable) do
            if self.heroTemp:getHeroTypeId(v) == 5 then
                table.insert(self.heroesTable,v)
            end
        end
    else
        assert("错误的武将类型")
    end

    self:reloadHeroList()

end




















return PVShopHeroPreview