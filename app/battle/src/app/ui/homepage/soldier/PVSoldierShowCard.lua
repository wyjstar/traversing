--
-- 装备合成的新装备展示界面

local PVSoldierShowCard = class("PVSoldierShowCard", BaseUIView)


function PVSoldierShowCard:ctor(id)
    self.super.ctor(self, id)
end

function PVSoldierShowCard:onMVCEnter()

    self.isMusic = false
         
    --初始化属性
    self:init()
    
    --绑定事件
    self:initTouchListener()
    
    --加载本界面的ccbi
    self:loadCCBI("equip/ui_equipShowCard.ccbi", self.ccbiNode)

    --获取控件
    self:initView()

end
 

function PVSoldierShowCard:init()
    self.ccbiNode = {}
    self.ccbiRootNode = {}

    assert(self.funcTable[1] ~= nil, "show page must have data !")
    self.data = self.funcTable[1]
end

--绑定事件
function PVSoldierShowCard:initTouchListener() 
    local function menuClickBack()
        self:stopMusicHero()
        getAudioManager():playEffectButton2()
        print("menuclickBack ...")
        self:onHideView()
        groupCallBack(GuideGroupKey.BTN_CLOSE_CARD)
    end

    self.ccbiNode["UIShopChestThird"] = {}
    self.ccbiNode["UIShopChestThird"]["menuClickBack"] = menuClickBack
end

function PVSoldierShowCard:stopMusicHero()
    if self.isMusic then
        print("关闭音效")
        -- cc.SimpleAudioEngine:getInstance():stopMusic(true)
        -- cc.SimpleAudioEngine:getInstance():stopEffect(self.musicEffect)
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        self.isMusic = false
    else
    end
end

    

--获取控件
function PVSoldierShowCard:initView()
    self.ccbiRootNode = self.ccbiNode["UIShopChestThird"]
    self.imgBg = self.ccbiRootNode["imgBg"]
    self.imgStarBg = self.ccbiRootNode["star_bg"]
    self.labelName = self.ccbiRootNode["labelName"]
    self.imgFntAgain = self.ccbiRootNode["sprite_fnt_call"]
    self.imgFntBack = self.ccbiRootNode["sprite_fnt_back"]
    self.menuBack = self.ccbiRootNode["menuBack"]
    self.menuAgain = self.ccbiRootNode["menuAgain"]
    self.card = self.ccbiRootNode["exampleSprite1"]
    self.imgPJ = self.ccbiRootNode["img_pingjie"]

    -- addHeroHDSpriteFrame(self.data)

    -- 设置属性
    local languageTemp = getTemplateManager():getLanguageTemplate()
    local soldierTemp = getTemplateManager():getSoldierTemplate()

    local _name = soldierTemp:getHeroName(self.data)
    -- change Card Image
    local heroImg, frameImg = soldierTemp:getSoldierImageName(self.data)  -- 资源名
    print("----------- soldierTemp:getSoldierImageName(self.data) ------------------")
    print(heroImg)
    print(frameImg)
    local _quality = soldierTemp:getHeroQuality(self.data)    -- 装备品质
    local _pingjie = getIconHDByQuality(_quality)

    -- _img = string.gsub(_icon, "all%.", "2.", 1)

    self.card:setSpriteFrame(frameImg)
    self.labelName:setString(_name)
    local qidd = soldierTemp:getHeroQuality(self.data)
    local color = getTemplateManager():getStoneTemplate():getColorByQuality(qidd)
    self.labelName:setColor(color)
    self:showStar(_quality)
    game.setSpriteFrame(self.imgPJ, "#".._pingjie)

    ----------
    if self.data > 0 then
        local res = getTemplateManager():getSoldierTemplate():getHeroAudio(self.data)
        if res == 0 then
            print("没有音效")
        else
            print("播放音效")
            self.isMusic = true
            getAudioManager():playHeroEffect(res)
        end
    end
    ----------
end

-- 显示星级
function PVSoldierShowCard:showStar(number)
    local _starTable = {}
    for i=1,number do
        local _star = game.newSprite("#ui_common_startup.png")
        self.imgStarBg:addChild(_star)
        table.insert(_starTable, _star)
    end

    -- 找到第一颗星星的初始点，之后的往后面移位
    local _starSize = _starTable[1]:getContentSize()
    local _bgSize = self.imgStarBg:getContentSize()
    local posX = self.imgStarBg:getPositionX()
    if number%2 == 0 then  -- 偶数
        posX = _bgSize.width/2 - math.floor(number/2) * _starSize.width + _starSize.width/2
    else    -- 奇数
        posX = _bgSize.width/2 - math.floor(number/2) * _starSize.width
    end

    for i,v in ipairs(_starTable) do
        v:setPositionX( posX + (i-1)*_starSize.width )
        v:setPositionY( _bgSize.height/2 )
    end
end


--@return 
return PVSoldierShowCard
