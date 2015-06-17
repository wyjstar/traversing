local PVShopPreviewHeroItem = class("PVShopPreviewHeroItem", function()
	return game.newNode()
end)

function PVShopPreviewHeroItem:ctor(heroId_)
    self.heroId = heroId_
    table.print(self.heroId)
	self.UIBuzhenWujiangInfo = {}
    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("instance/ui_buzhen_wujiang_info.ccbi", proxy, self.UIBuzhenWujiangInfo)
    node:setScale(0.9)
    self.touchRect = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["itemTouchLayer"]
    self:addChild(node)
    self:setContentSize(node:getContentSize())
    self.touchBox = node

    self.soldierTemp = getTemplateManager():getSoldierTemplate()

    self:initView()
end

function PVShopPreviewHeroItem:initView()
    self.starAndNameNode_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starAndNameNode_1"]
    self.starSelect6_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect6_1"]
    self.levelNumLabel_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["levelNumLabel_1"]
    self.levelNumLabelNode_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["levelNumLabelNode_1"]
    self.starSelect1_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect1_1"]
    self.starSelect2_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect2_1"]
    self.starSelect3_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect3_1"]
    self.starSelect4_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect4_1"]
    self.starSelect5_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect5_1"]
    self.starSelect6_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starSelect6_1"]

    self.starTable_1 = {}
    table.insert(self.starTable_1, self.starSelect1_1)
    table.insert(self.starTable_1, self.starSelect2_1)
    table.insert(self.starTable_1, self.starSelect3_1)
    table.insert(self.starTable_1, self.starSelect4_1)
    table.insert(self.starTable_1, self.starSelect5_1)
    table.insert(self.starTable_1, self.starSelect6_1)

    self.heroTypeBMLabel_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["heroTypeBMLabel_1"]
    self.typeSprite_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["typeSprite_1"]
    self.heroNameLabel_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["heroNameLabel_1"]
    self.bgFrame = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["bgFrame"]
    self.wujiangImg = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["wujiangImg"]
    self.frameAnimateNode = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["frameAnimateNode"]
    self.breakLvBg_1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["breakLvBg_1"]
    self.levelBgSprite = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["levelBgSprite"]
    self.starLayer1 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starLayer1"]
    self.starLayer2 = self.UIBuzhenWujiangInfo["UIBuzhenWujiangInfo"]["starLayer2"]

    self.breakLvBg_1:setVisible(false)
    self.levelBgSprite:setVisible(false)
    --设置英雄信息
    local quality = self.soldierTemp:getHeroQuality(self.heroId)

    if quality == 1 or quality == 2 then
        game.setSpriteFrame(self.bgFrame,"#ui_common_g_frame.png")
        local lvtejiNode = UI_buzhenjiemiankuangLvka()
        lvtejiNode:setPosition(self.bgFrame:getPosition())
        self.frameAnimateNode:addChild(lvtejiNode)
        print("lvframe")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(self.bgFrame,"#ui_common_b_frame.png")
        local lantejiNode = UI_buzhenjiemiankuangLanka()
        lantejiNode:setPosition(self.bgFrame:getPosition())
        self.frameAnimateNode:addChild(lantejiNode)
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(self.bgFrame,"#ui_common_p_frame.png")
        local zitejiNode = UI_buzhenjiemiankuangZika()
        zitejiNode:setPosition(self.bgFrame:getPosition())
        self.frameAnimateNode:addChild(zitejiNode)
    end

    local heroNode = self.soldierTemp:getHeroBigImageById(self.heroId)
    local x,y = self.wujiangImg:getPosition()
    heroNode:setScale(0.7)
    heroNode:setPosition(x*2,y+40)
    self.wujiangImg:setOpacity(0)
    self.wujiangImg:addChild(heroNode)

    updateStarLV(self.starTable_1, quality) --更新星级

    local jobId = self.soldierTemp:getHeroTypeId(self.heroId)
    local _spriteJob = nil
    print("----jobId-----",jobId)
    if jobId == 1 then              -- 1：猛将
        _spriteJob = "ui_comNew_kind_001.png"
    elseif jobId == 2 then          -- 2：禁卫
        _spriteJob = "ui_comNew_kind_002.png"
    elseif jobId == 3 then          -- 3：游侠
        _spriteJob = "ui_comNew_kind_003.png"
    elseif jobId == 4 then          -- 4：谋士
        _spriteJob = "ui_comNew_kind_004.png"
    elseif jobId == 5 then          -- 5：方士
        _spriteJob = "ui_comNew_kind_005.png"
    end
    self.typeSprite_1:setSpriteFrame(_spriteJob)

    local nameStr = self.soldierTemp:getHeroName(self.heroId)
    self.heroNameLabel_1:setString(nameStr)

end

function PVShopPreviewHeroItem:isTouched(x, y)
    local pos = self.touchBox:convertToNodeSpace(cc.p(x, y))
    if cc.rectContainsPoint(self.touchRect:getBoundingBox(), pos) then
        return true
    else
    	return false
    end
end

return PVShopPreviewHeroItem