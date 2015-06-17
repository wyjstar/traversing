--
-- 装备合成的新装备展示界面

local PVEquipShowCard = class("PVEquipShowCard", BaseUIView)


function PVEquipShowCard:ctor(id)
    self.super.ctor(self, id)
end

function PVEquipShowCard:onMVCEnter()
         
    --初始化属性
    self:init()
    
    --绑定事件
    self:initTouchListener()
    
    --加载本界面的ccbi
    self:loadCCBI("equip/ui_equipShowCard.ccbi", self.ccbiNode)

    --获取控件
    self:initView()

end


function PVEquipShowCard:init()

    self.ccbiNode = {}
    self.ccbiRootNode = {}

    assert(self.funcTable[1] ~= nil, "show page must have data !")
    self.data = self.funcTable[1]

    -- print("DDDDDD")
    -- table.print(self.data)

    local num = table.nums(self.data)
    assert(num == 1, "show one page must have only one card data !")
end

--绑定事件
function PVEquipShowCard:initTouchListener()
    
    local function menuClickBack()
        getAudioManager():playEffectButton2()
        print("menuclickBack ...")
        self:onHideView()
    end

    self.ccbiNode["UIShopChestThird"] = {}
    self.ccbiNode["UIShopChestThird"]["menuClickBack"] = menuClickBack
end

--获取控件
function PVEquipShowCard:initView()

    self.ccbiRootNode = self.ccbiNode["UIShopChestThird"]
    self.imgBg = self.ccbiRootNode["imgBg"]
    self.imgStarBg = self.ccbiRootNode["star_bg"]
    self.imgStarBg:setVisible(false)
    self.labelName = self.ccbiRootNode["labelName"]
    self.imgFntAgain = self.ccbiRootNode["sprite_fnt_call"]
    self.imgFntBack = self.ccbiRootNode["sprite_fnt_back"]
    self.menuBack = self.ccbiRootNode["menuBack"]
    self.menuAgain = self.ccbiRootNode["menuAgain"]
    self.card = self.ccbiRootNode["exampleSprite1"]
    self.imgPJ = self.ccbiRootNode["img_pingjie"]

    local _winSize = cc.Director:getInstance():getWinSize()

    -- 设置属性
    local languageTemp = getTemplateManager():getLanguageTemplate()
    local equipTemp = getTemplateManager():getEquipTemplate()

    local _equipNameId = equipTemp:getTemplateById(self.data[1].no).name
    local _name = languageTemp:getLanguageById(_equipNameId)
    -- change Card Image
    local _icon = equipTemp:getEquipResHD(self.data[1].no)  -- 资源名
    local _quality = equipTemp:getQuality(self.data[1].no)    -- 装备品质
    local _pingjie = getIconHDByQuality(_quality)

    local color = getTemplateManager():getStoneTemplate():getColorByQuality(_quality)
    self.labelName:setColor(color)

    self.card:setTexture("res/equipment/".._icon)
    self.labelName:setString(_name)
    -- self:showStar(_quality)
    game.setSpriteFrame(self.imgPJ, "#".._pingjie)

end

-- 显示星级
function PVEquipShowCard:showStar(number)
    
    -- local _starTable = {}
    -- for i=1,number do
    --     local _star = game.newSprite("#ui_common_startup.png")
    --     self.imgStarBg:addChild(_star)
    --     table.insert(_starTable, _star)
    -- end

    -- -- 找到第一颗星星的初始点，之后的往后面移位
    -- local _starSize = _starTable[1]:getContentSize()
    -- local _bgSize = self.imgStarBg:getContentSize()
    -- local posX = self.imgStarBg:getPositionX()
    -- if number%2 == 0 then  -- 偶数
    --     posX = _bgSize.width/2 - math.floor(number/2) * _starSize.width + _starSize.width/2
    -- else    -- 奇数
    --     posX = _bgSize.width/2 - math.floor(number/2) * _starSize.width
    -- end

    -- for i,v in ipairs(_starTable) do
    --     v:setPositionX( posX + (i-1)*_starSize.width )
    --     v:setPositionY( _bgSize.height/2 )
    --     -- print("v:getPositionX()", v:getPositionX())
    -- end
end


--@return 
return PVEquipShowCard
