
function getLevelTips(level)
    local PVCommonTipsLevel = require("src.app.ui.homepage.common.PVCommonTipsLevel")   -- 功能等级弹框
    local entryView = PVCommonTipsLevel:new()
    entryView:initDate(level)
    return entryView
end

-- 根据关卡开启功能
function getStageTips(stageId)
    local _stageItem = getTemplateManager():getInstanceTemplate():getTemplateById(stageId)
    local _name = getTemplateManager():getLanguageTemplate():getLanguageById(_stageItem.name)
    local _chapterNo, _stageNo = getTemplateManager():getInstanceTemplate():getIndexofStage(stageId)
    local _strDes = "通关" .. _chapterNo .. "-" .. _stageNo .. "关卡开启"
    -- cclog(_strDes)
    getOtherModule():showToastView( _strDes)
end

--获取根据关卡开启功能提示文字
function getStageTipStr(stageId)
    local _stageItem = getTemplateManager():getInstanceTemplate():getTemplateById(stageId)
    local _name = getTemplateManager():getLanguageTemplate():getLanguageById(_stageItem.name)
    local _chapterNo, _stageNo = getTemplateManager():getInstanceTemplate():getIndexofStage(stageId)
    local _strDes = "通关" .. _chapterNo .. "-" .. _stageNo .. "关卡开启"
    return _strDes
end

function getLevelNode(level)      -- 新版本等级
    local _label = cc.LabelAtlas:_create(string.format("%d", level), "res/ui/ui_level_num.png", 14, 22, string.byte("0"))
    -- _label:setRotation(-25)
    _label:setAnchorPoint(cc.p(0.5, 0.5))
    return _label
    -- cell.levelLayer:addChild(_label)
end

function getVipLevelLabel(viplevel)      -- 新版本vip等级
    local _label = cc.LabelAtlas:_create(string.format("%d", viplevel), "res/ui/vip_num_new.png", 20, 34, string.byte("0"))
    _label:setAnchorPoint(cc.p(0.5, 0.5))
    return _label
end

function userDefault_setStringForKey(key, value)
    cc.UserDefault:getInstance():setStringForKey(key, value)
    cc.UserDefault:getInstance():flush()
end

function clearLoginuserAndPwd()
    -- cc.UserDefault:getInstance():setStringForKey("user_name", "")
    cc.UserDefault:getInstance():setStringForKey("password", "")

    cc.UserDefault:getInstance():flush()
end

function userDefault_setIntegerForKey(key, value)
    cc.UserDefault:getInstance():setIntegerForKey(key, value)
    cc.UserDefault:getInstance():flush()
end


-- 5：方士

--获得英雄职业类型图片
function getHeroTypeName(_type)
    if _type == 1 then   -- 1：猛将
        return "猛\n将"
        -- game.setSpriteFrame(sprite, "#job_soldier.png")
    elseif _type == 2 then  -- 2：禁卫
        return "禁\n卫"
        -- game.setSpriteFrame(sprite, "#job_tank.png")
    elseif _type == 3 then  -- 3：游侠
        return "游\n侠"
        -- game.setSpriteFrame(sprite, "#job_cike.png")
    elseif _type == 4 then  -- 4：谋士
        return "谋\n士"
        -- game.setSpriteFrame(sprite, "#job_mushi.png")
    elseif _type == 5 then  -- 5：方士
        return "方\n士"
        -- game.setSpriteFrame(sprite, "#job_fashi.png")
    end
end

--获得英雄职业类型图片  新版
function setNewHeroTypeName(sprite,_type)
    local _spriteJob = nil
    if _type == 1 then              -- 1：猛将
        _spriteJob = "ui_comNew_kind_0011.png"
    elseif _type == 2 then          -- 2：禁卫
        _spriteJob = "ui_comNew_kind_0022.png"
    elseif _type == 3 then          -- 3：游侠
        _spriteJob = "ui_comNew_kind_0033.png"
    elseif _type == 4 then          -- 4：谋士
        _spriteJob = "ui_comNew_kind_0044.png"
    elseif _type == 5 then          -- 5：方士
        _spriteJob = "ui_comNew_kind_0055.png"
    end
    sprite:setSpriteFrame(_spriteJob)
end
--获得英雄图片  新版武将列表使用
--sprite:要替换的英雄
--res:资源id
--quality;品质
--bgSprite:品质背景
function changeNewSoldierIconImage(sprite, res, quality, bgSprite)
    bgSprite:removeAllChildren()
    sprite:setTexture("res/icon/hero_new2/"..res)   -- 新版本路径
    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_soldier_bg_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_soldier_bg_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_soldier_bg_zi.png")
    end
end

--获得英雄图片   新版阵容使用
--sprite:要替换的英雄
--res:资源id
--quality;品质
function changeNewIconImage(sprite, res, quality,blRemoveChild)
    local heroSprite = cc.Sprite:create()
    heroSprite:setTexture("res/icon/hero_new/"..res)   -- 新版本路径
    heroSprite:setScale(1.1)
    if not blRemoveChild == false then
        sprite:removeAllChildren()
    end

    if quality == 1 or quality == 2 then
        game.setSpriteFrame(sprite, "#ui_comNew_icon_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(sprite, "#ui_comNew_icon_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(sprite, "#ui_comNew_icon_zi.png")
    end
    sprite:addChild(heroSprite, 1)
    heroSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end


--武将Icon
--sprite:要替换的英雄
--res:资源id
--quality;品质
function changeHeroChipIcon(sprite, res, quality)
    sprite:removeAllChildren()

    local heroSprite = cc.Sprite:create()
    heroSprite:setTexture("res/icon/hero_new/"..res)   -- 新版本路径
    local heroSprite_sui = cc.Sprite:create()
    game.setSpriteFrame(heroSprite_sui, "#ui_equip_b_cuipian.png")
    heroSprite_sui:setPosition(100, 95)


    if quality == 1 or quality == 2 then
        game.setSpriteFrame(sprite, "#ui_comNew_icon_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(sprite, "#ui_comNew_icon_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(sprite, "#ui_comNew_icon_zi.png")
    end

    sprite:addChild(heroSprite, 1)
    sprite:addChild(heroSprite_sui, 1)
    heroSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--恭喜获得中用到的，，有四方的底托的武将Icon
--sprite:要替换的英雄
--res:资源id
--quality;品质
function changeNewIconImageBottom(sprite, res, quality)
    local heroSprite = cc.Sprite:create()
    heroSprite:setTexture("res/icon/hero_new/"..res)   -- 新版本路径
    heroSprite:setScale(1.1)

    local heroSprite_bottom = cc.Sprite:create()


    sprite:removeAllChildren()

    if quality == 1 or quality == 2 then
        game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_lv.png")
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_lan.png")
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_zi.png")
        game.setSpriteFrame(sprite, "#ui_common2_bg2_zi.png")
    end

    sprite:addChild(heroSprite, 1)
    sprite:addChild(heroSprite_bottom, 1)

    heroSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--恭喜获得中用到的，，有四方的底托的武将Icon
--sprite:要替换的英雄
--res:资源id
--quality;品质
function changeHeroChipIconBottom(sprite, res, quality)
    sprite:removeAllChildren()

    local heroSprite = cc.Sprite:create()
    heroSprite:setTexture("res/icon/hero_new/"..res)   -- 新版本路径
    heroSprite:setScale(0.9)

    local heroSprite_bottom = cc.Sprite:create()
    heroSprite_bottom:setScale(0.85)
    local heroSprite_sui = cc.Sprite:create()
    game.setSpriteFrame(heroSprite_sui, "#ui_equip_b_cuipian.png")
    heroSprite_sui:setPosition(108, 91)


    if quality == 1 or quality == 2 then
        game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_lv.png")
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_lan.png")
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_zi.png")
        game.setSpriteFrame(sprite, "#ui_common2_bg2_zi.png")
    end

    sprite:addChild(heroSprite, 1)
    sprite:addChild(heroSprite_bottom, 1)
    sprite:addChild(heroSprite_sui, 1)

    heroSprite_bottom:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
    heroSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--获得英雄图片
--sprite:要替换的英雄
--res:资源id
--quality;品质
function changeMonsterIconImage(sprite, res, quality)
    -- game.setSpriteFrame(sprite, res)
    sprite:setTexture("res/icon/stage/"..res)
    local bgSprite = cc.Sprite:create()
    sprite:removeAllChildren()
    sprite:addChild(bgSprite, 1)
    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

function getHeroIconQuality(quality)
    if quality == 1 or quality == 2 then
        return "ui_common_frameg.png"
    elseif quality == 3 or quality == 4 then
        return "ui_common_framebu.png"
    elseif quality == 5 or quality == 6 then
        return "ui_common_framep.png"
    else
        return "ui_common_frameg.png"
    end
end

function getIconByQuality(quality_number)
    if quality_number == 1 then
        spriteIcon = "ui_common_kuang.png"
    elseif quality_number == 2 then
        spriteIcon = "ui_common_frameg.png"
    elseif quality_number == 3 or quality_number == 4 then
        spriteIcon = "ui_common_framebu.png"
    elseif quality_number == 5 or quality_number == 6 then
        spriteIcon = "ui_common_framep.png"
    end
    return spriteIcon
end

function getNewIconByQuality(quality_number)
    if quality_number == 1 then
        spriteIcon = "ui_common2_bg2_jin.png"
    elseif quality_number == 2 then
        spriteIcon = "ui_common2_bg2_lv.png"
    elseif quality_number == 3 or quality_number == 4 then
        spriteIcon = "ui_common2_bg2_lan.png"
    elseif quality_number == 5 or quality_number == 6 then
        spriteIcon = "ui_common2_bg2_zi.png"
    end
    return spriteIcon
end

function getIconHDByQuality(quality_number)
    if quality_number == 1 then
        spriteIcon = ""
    elseif quality_number == 2 then
        spriteIcon = "ui_equip_bgg.png"
    elseif quality_number == 3 or quality_number == 4 then
        spriteIcon = "ui_equip_bgb.png"
    elseif quality_number == 6 or quality_number == 5 then
        spriteIcon = "ui_equip_bgp.png"
    end
    return spriteIcon
end

--更新星级
function updateStarLV(starTable, level)

    for k, v in pairs(starTable) do
        if k > level then
            v:setVisible(false)
        else
            v:setVisible(true)
        end
    end
end

function changeLabelBreakColor(label, breakLevel)

    --label2:setColor(cc.c3b(255, 0, 0 ))
end

function getQualityBgImg(quality)
    if quality == 1 then
        return "#ui_common2_bg2_jin.png"
    elseif quality == 2 then
        return "#ui_common2_bg2_lv.png"
    elseif quality == 3 or quality == 4 then
        return "#ui_common2_bg2_lan.png"
    elseif quality == 5 or quality == 6 then
        return "#ui_common2_bg2_zi.png"
    else
        return "#ui_common2_bg2_jin.png"
    end
end

function setItemImageNew(sprite, res, quality)
    game.addSpriteFramesWithFile("res/resource/resource_icon1.plist")

    sprite:removeAllChildren()

    local _icon = cc.Sprite:create()
    _icon:setTag(100001)
    _icon:setScale(0.8)
    game.setSpriteFrame(_icon, res)
    local bgSprite = cc.Sprite:create()
    bgSprite:setTag(100002)
    sprite:addChild(bgSprite, 1)
    sprite:addChild(_icon, 2)

    if quality == 1 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg2_jin.png")
    elseif quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg2_zi.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
    _icon:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end
--根据品质和底图，设置卡牌的图片和品质框
function setItemImage(sprite, res, quality)
    game.addSpriteFramesWithFile("res/resource/resource_icon1.plist")

    sprite:removeAllChildren()

    local _icon = cc.Sprite:create()
    _icon:setTag(100001)
    game.setSpriteFrame(_icon, res)
    local bgSprite = cc.Sprite:create()
    bgSprite:setTag(100002)
    sprite:addChild(_icon, 1)
    sprite:addChild(bgSprite, 1)

    if quality == 1 then
        game.setSpriteFrame(bgSprite, "#ui_common_kuang.png")
    elseif quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
    _icon:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--根据品质和底图，设置卡牌的图片和品质框
--新版道具 (风物志底，纸)
function setItemImage2(sprite, res, quality)
    game.addSpriteFramesWithFile("res/resource/resource_icon1.plist")

    sprite:removeAllChildren()

    local _icon = cc.Sprite:create()
    _icon:setTag(100001)
    game.setSpriteFrame(_icon, res)
    local bgSprite = cc.Sprite:create()
    bgSprite:setTag(100002)
    sprite:addChild(_icon, 2)
    sprite:addChild(bgSprite, 1)


    if quality == 1 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg_bai.png")
    elseif quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg_zi.png")
    end

    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
    _icon:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end
--根据品质和底图，设置卡牌的图片和品质框
--新版道具 (道具底)
function setItemImage3(sprite, res, quality)
    game.addSpriteFramesWithFile("res/resource/resource_icon1.plist")

    sprite:removeAllChildren()

    local _icon = cc.Sprite:create()
    _icon:setScale(0.8)
    _icon:setTag(100001)
    game.setSpriteFrame(_icon, res)
    local bgSprite = cc.Sprite:create()
    bgSprite:setTag(100002)
    sprite:addChild(_icon, 2)
    sprite:addChild(bgSprite, 1)


    if quality == 1 or quality == nil then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg2_bai.png")
    elseif quality == 2 then
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(sprite, "#ui_common2_bg2_zi.png")
    end

    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
    _icon:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end
--上面方法导致item不可点击
function setItemImageClick(sprite, res, quality)
    game.addSpriteFramesWithFile("res/resource/resource_icon1.plist")

    sprite:removeAllChildren()
    game.setSpriteFrame(sprite, res)
    local bgSprite = cc.Sprite:create()
    sprite:addChild(bgSprite)
    if quality == 1 then
        game.setSpriteFrame(bgSprite, "#ui_common_kuang.png")
    elseif quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end
function setNewItemImageClick(bgSprite, res, quality)
    game.addSpriteFramesWithFile("res/resource/resource_icon1.plist")
    bgSprite:removeAllChildren()
    local sprite = cc.Sprite:create()
    game.setSpriteFrame(sprite, res)
    bgSprite:addChild(sprite)
    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite,"#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite,"#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite,"#ui_common2_bg2_zi.png")
    end
    sprite:setPosition(bgSprite:getContentSize().width / 2, bgSprite:getContentSize().height / 2)
end

--商城十连抽英雄碎片的图片和品质框以及外框
function setShopHeroChip(sprite, res, quality)
    sprite:removeAllChildren()

    local frSprite = cc.Sprite:create()
    game.setSpriteFrame(frSprite, res)
    sprite:addChild(frSprite)

    local bgSprite = cc.Sprite:create()
    frSprite:addChild(bgSprite)

    if quality == 1 or quality == 2 then
        game.setSpriteFrame(sprite, "#ui_kuang_green.png")
        game.setSpriteFrame(bgSprite, "#ui_common_card_green.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(sprite, "#ui_kuang_blue.png")
        game.setSpriteFrame(bgSprite, "#ui_common_card_blue.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(sprite, "#ui_kuang_p.png")
        game.setSpriteFrame(bgSprite, "#ui_common_card_purple.png")
    end
    bgSprite:setPosition(frSprite:getContentSize().width / 2, frSprite:getContentSize().height / 2)
    frSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--商城十连抽卡牌的图片和品质框
function setShopItemImage(sprite, res, quality)
    sprite:removeAllChildren()

    local frSprite = cc.Sprite:create()
    game.setSpriteFrame(frSprite, res)
    sprite:addChild(frSprite)

    local bgSprite = cc.Sprite:create()
    frSprite:addChild(bgSprite)

    if quality == 1 or quality == 2 then
        game.setSpriteFrame(sprite, "#ui_kuang_green.png")
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(sprite, "#ui_kuang_blue.png")
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(sprite, "#ui_kuang_p.png")
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(frSprite:getContentSize().width / 2, frSprite:getContentSize().height / 2)
    frSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--设置装备卡牌图
function changeEquipIconImage(sprite, res, quality)
    sprite:removeAllChildren()
    local equSprite = cc.Sprite:create()

     equSprite:setTexture("res/equipment/"..res)   -- 新版本路径
    if quality == 1 or quality == 2 then
        equSprite:setScale(0.55)
        game.setSpriteFrame(sprite, "#ui_equip_bg_lv.png")
    elseif quality == 3 or quality == 4 then
        equSprite:setScale(0.5)
        game.setSpriteFrame(sprite, "#ui_equip_bg_lan.png")
    elseif quality == 5 or quality == 6 then
        equSprite:setScale(0.45)
        game.setSpriteFrame(sprite, "#ui_equip_bg_zi.png")
    end
    sprite:addChild(equSprite, 1)

    equSprite:setPosition(sprite:getContentSize().width / 10, sprite:getContentSize().height / 2)
end

--设置装备卡牌图
--恭喜获得中用到的，，有四方的底托的装备碎片Icon
function changeEquipChipIconImageBottom(sprite, res, quality)
    sprite:removeAllChildren()
    -- game.setSpriteFrame(sprite, res)

    local equSprite = cc.Sprite:create()

     equSprite:setTexture("res/equipment/"..res)   -- 新版本路径

     local equSprite_sui = cc.Sprite:create()
    game.setSpriteFrame(equSprite_sui, "#ui_equip_b_cuipian.png")
    equSprite_sui:setPosition(108, 91)


    if quality == 1 or quality == 2 then
        equSprite:setScale(0.55)
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        equSprite:setScale(0.5)
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        equSprite:setScale(0.45)
        game.setSpriteFrame(sprite, "#ui_common2_bg2_zi.png")
    end

    sprite:addChild(equSprite, 1)
    sprite:addChild(equSprite_sui, 1)

    equSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--设置装备卡牌图
--恭喜获得中用到的，，有四方的底托的装备Icon
function changeEquipIconImageBottom(sprite, res, quality)
    sprite:removeAllChildren()
    -- game.setSpriteFrame(sprite, res)

    local equSprite = cc.Sprite:create()

     equSprite:setTexture("res/equipment/"..res)   -- 新版本路径
    if quality == 1 or quality == 2 then
        equSprite:setScale(0.55)
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        equSprite:setScale(0.5)
        game.setSpriteFrame(sprite, "#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        equSprite:setScale(0.45)
        game.setSpriteFrame(sprite, "#ui_common2_bg2_zi.png")
    end

    sprite:addChild(equSprite, 1)

    equSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--设置装备卡牌图
--装备羁绊使用
function changeEquipIconImageCircleBottom(sprite, res, quality)
    sprite:removeAllChildren()
    -- game.setSpriteFrame(sprite, res)

    local equSprite = cc.Sprite:create()

     equSprite:setTexture("res/equipment/"..res)   -- 新版本路径
    if quality == 1 or quality == 2 then
        equSprite:setScale(0.55)
        game.setSpriteFrame(sprite, "#ui_comNew_icon_lv.png")
    elseif quality == 3 or quality == 4 then
        equSprite:setScale(0.5)
        game.setSpriteFrame(sprite, "#ui_comNew_icon_lan.png")
    elseif quality == 5 or quality == 6 then
        equSprite:setScale(0.45)
        game.setSpriteFrame(sprite, "#ui_comNew_icon_zi.png")
    end
    sprite:addChild(equSprite, 1)

    equSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

-- local heroSprite = cc.Sprite:create()
--     heroSprite:setTexture("res/icon/hero_new/"..res)   -- 新版本路径
--     heroSprite:setScale(1.1)

--     local heroSprite_bottom = cc.Sprite:create()


--     sprite:removeAllChildren()

--     if quality == 1 or quality == 2 then
--         game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_lv.png")
--         game.setSpriteFrame(sprite, "#ui_common2_bg2_lv.png")
--     elseif quality == 3 or quality == 4 then
--         game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_lan.png")
--         game.setSpriteFrame(sprite, "#ui_common2_bg2_lan.png")
--     elseif quality == 5 or quality == 6 then
--         game.setSpriteFrame(heroSprite_bottom, "#ui_comNew_icon_zi.png")
--         game.setSpriteFrame(sprite, "#ui_common2_bg2_zi.png")
--     end

--     sprite:addChild(heroSprite, 1)
--     sprite:addChild(heroSprite_bottom, 1)

--     heroSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)

--新版设置装备卡牌图
function setNewEquipCardWithFrame(sprite, res, quality)
    -- game.setSpriteFrame(sprite, res)
    sprite:removeAllChildren()
    local equSprite = cc.Sprite:create()

    equSprite:setTexture("res/equipment/"..res)   -- 新版本路径
    if quality == 1 or quality == 2 then
        equSprite:setScale(0.55)
        game.setSpriteFrame(sprite, "#ui_lineup2_zb_lv.png")
    elseif quality == 3 or quality == 4 then
        equSprite:setScale(0.5)
        game.setSpriteFrame(sprite, "#ui_lineup2_zb_lan.png")
    elseif quality == 5 or quality == 6 then
        equSprite:setScale(0.45)
        game.setSpriteFrame(sprite, "#ui_lineup2_zb_zi.png")
    end
    sprite:addChild(equSprite, 1)
    equSprite:setPosition(sprite:getContentSize().width * 0.45, sprite:getContentSize().height * 0.55)
end

--新版设置装备卡牌图
function setNewEquipQualityWithFrame(quality)
    -- sprite:removeAllChildren()
    if quality == 1 or quality == 2 then
        return "#ui_equip_bg_lv.png"
    elseif quality == 3 or quality == 4 then
        return "#ui_equip_bg_lan.png"
    elseif quality == 5 or quality == 6 then
        return "#ui_equip_bg_zi.png"
    end
end

--设置装备卡牌图
function setCardWithFrame(sprite, res, quality)
    sprite:removeAllChildren()
    -- game.setSpriteFrame(sprite, res)
    sprite:setTexture(res)
    local bgSprite = cc.Sprite:create()
    sprite:addChild(bgSprite)
    if quality == 1 then
        game.setSpriteFrame(bgSprite, "#ui_common_kuang.png")
    elseif quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

--根据品质获取武将名字文本颜色
function getColorByQuality(curQuality)
    local color = ui.COLOR_WHITE
    if curQuality == 1 then
        color = ui.COLOR_WHITE
    elseif curQuality == 2 then
        color = ui.COLOR_GREEN
    elseif curQuality == 3 or curQuality == 4 then
        color = ui.COLOR_BLUE
    elseif curQuality == 5 or curQuality == 6 then
        color = ui.COLOR_PURPLE
    end
    return color
end


--set chips image
function setChipWithFrame(sprite, res, quality)
    sprite:removeAllChildren()
    -- game.setSpriteFrame(sprite, res)
    sprite:setTexture(res)
    local bgSprite = cc.Sprite:create()
    sprite:addChild(bgSprite)
    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_card_green.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_card_blue.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_card_purple.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end
function setChipWithFrameN(bgSprite, res, quality)
    bgSprite:removeAllChildren()
    -- game.setSpriteFrame(sprite, res)
    local sprite = cc.Sprite:create()
    sprite:setTexture(res)
    bgSprite:addChild(sprite)
    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg2_zi.png")
    end
    sprite:setPosition(bgSprite:getContentSize().width / 2, bgSprite:getContentSize().height / 2)
    local chipTag = cc.Sprite:create()
    game.setSpriteFrame(chipTag,"#ui_common2_cuipian.png")
    chipTag:setPosition(bgSprite:getContentSize().width * 3/4, bgSprite:getContentSize().height * 3/4)
    bgSprite:addChild(chipTag)
end

function setChipWithFrameNew(bgSprite, res, quality)
    bgSprite:removeAllChildren()
    -- game.setSpriteFrame(sprite, res)
    local sprite = cc.Sprite:create()
    sprite:setTexture("res/icon/hero_new/"..res)
    bgSprite:addChild(sprite)
    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite,"#ui_common2_bg2_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite,"#ui_common2_bg2_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite,"#ui_common2_bg2_zi.png")
    end
    sprite:setPosition(bgSprite:getContentSize().width / 2, bgSprite:getContentSize().height / 2)
    local chipTag = cc.Sprite:create()
    game.setSpriteFrame(chipTag,"#ui_common2_cuipian.png")
    chipTag:setPosition(bgSprite:getContentSize().width * 3/4, bgSprite:getContentSize().height * 3/4)
    bgSprite:addChild(chipTag)
end

--set chips image 新版
function setNewChipWithFrame(sprite, res, quality, bgSprite)
    bgSprite:removeAllChildren()
    sprite:setTexture("res/icon/hero_new/"..res)   -- 新版本路径
    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_soldier_bg_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_soldier_bg_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_soldier_bg_zi.png")
    end
end

--获得英雄图片
--sprite:要替换的英雄
--res:资源id
--quality;品质
--带有label
function changeHeroImageWithLabel(sprite, res, quality, strA, strB)
    sprite:setTexture("icon/ui_lu_user.png")

    local  bgSprite = cc.Sprite:create()
    sprite:removeAllChildren()
    sprite:addChild(bgSprite, -1)
    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end

    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
    local finalStr = strA .. "+" .. strB
    local label = cc.Label:createWithSystemFont(strValue, "Helvetica", 20.0)
end

function changeHeroQualityWithFrame(quality)
    if quality == 1 or quality == 2 then
        return "#ui_soldier_bg_lv.png"
    elseif quality == 3 or quality == 4 then
        return "#ui_soldier_bg_lan.png"
    elseif quality == 5 or quality == 6 then
        return "#ui_soldier_bg_zi.png"
    end
end

function changeHeroQualityWithFrame2(quality)
    local kuang = "#ui_common_icon_lan"
    if quality == 1 or quality == 2 then
        return "#ui_common_icon_lan.png"
    elseif quality == 3 or quality == 4 then
        return "#ui_common_icon_lan.png"
    elseif quality == 5 or quality == 6 then
        return "#ui_common_icon_zi.png"
    end
end

--加载英雄大图
function addHeroHDSpriteFrame(heroId)
    game.addSpriteFramesWithFile("res/card/hero_"..heroId.."_all.plist")
end

--移除英雄大图
function removeHeroHDSpriteFrame(heroId)
    -- game.removeSpriteFramesWithFile("res/card/hero_"..heroId.."_all.plist")
end

-- 解析json数据
-- @param json数据格式
function parseJson(data)
     return json.decode(data)
end


-- 数值处理小数点的数值
function roundNumber(number)
    -- return math.round(number)        -- 四舍五入
    return math.floor(number)           -- 舍去小数点
end

-- 处理主属性的数据
function roundAttriNum(number)
    --number = number * 10
    number = math.floor(number)
    --number = number / 10
    return number
end
-- 保留1位小数
function round1(number)
    number = number * 10
    number = math.floor(number)
    number = number / 10
    return number
end

function getUnparaNode(unparaId)
    print("getUnparaNode====")
    print(unparaId)

    -- unparaId = 5026

    const.FIGHT_POS_UNPARA_ICON = const.POS_UNPARA_ICON_FIGHT
    if unparaId == 5001 then
        return UI_wushuang1()
    elseif unparaId == 5002 then
        return UI_wushuang2()
    elseif unparaId == 5003 then
        return UI_wushuang3()
    elseif unparaId == 5004 then
        return UI_wushuang4()
    elseif unparaId == 5005 then
        return UI_wushuang5()
    elseif unparaId == 5006 then
        return UI_wushuang6()
    elseif unparaId == 5007 then
        return UI_wushuang7()
    elseif unparaId == 5008 then
        return UI_wushuang8()
    elseif unparaId == 5009 then
        return UI_wushuang9()
    elseif unparaId == 5010 then
        return UI_ws_01()
    elseif unparaId == 5012 then
        return UI_ws_03()
    elseif unparaId == 5027 then
        return UI_ws_15()
    elseif unparaId == 5014 then
        return UI_ws_02()
    elseif unparaId == 5013 then
        return UI_ws_04()
    elseif unparaId == 5017 then
        return UI_ws_06()
    elseif unparaId == 5021 then
        return UI_ws_07()
    elseif unparaId == 5020 then
        return UI_ws_08()
    elseif unparaId == 5023 then
        return UI_ws_09()
    elseif unparaId == 5016 then
        return UI_ws_10()
    elseif unparaId == 5028 then
        return UI_ws_11()
    elseif unparaId == 5026 then
        return UI_ws_12()
    elseif unparaId == 5025 then
        return UI_ws_13()
    elseif unparaId == 5024 then
        return UI_ws_14()
    elseif unparaId == 5011 then
        return UI_ws_05()
    elseif unparaId == 5024 then
        return UI_ws_14()
    elseif unparaId == 5018 then
        return UI_ws_16()
     elseif unparaId == 5022 then
        return UI_ws_17()
    end

end

function stringLen( str )
    local len  = #str
    local left = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local t = {}
    local start = 1
    local wordLen = 0
    local strLen = 0
    while len ~= left do
        local tmp = string.byte(str, start)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                break
            end
            i = i - 1
        end
        if i >=2 then
            strLen = 2 + strLen
        else
            strLen = 1 + strLen
        end

        wordLen = i + wordLen
        local tmpString = string.sub(str, start, wordLen)
        start = start + i
        left = left + i
        t[#t + 1] = tmpString
    end

    return strLen, t
end

function IsContainPunctu(strPunctu)

    local len, text = stringLen(strPunctu)
    if len > 12 then
        return false
    end

    local str = string.match(strPunctu, "[%p]+", 1)
    if str ~= nil then
        return false
    end

    -- cclog(str)

    local sigs = {"《","》","。","”","“","，","：","；","、","？","～","！","【","】","｝","｛"}
    for k,v in pairs(sigs) do
        str = string.match(strPunctu, v)
        if str ~= nil then
            return false
        end
    end

    -- print(string.match("hello。w！“", "“"))

    return true
end

function createErrorLayer(msg)
    if ISSHOWLOG then
        local runningScene = game.getRunningScene()
        local layer = runningScene:getChildByTag(11000)
        if layer == nil then
            local label = cc.Label:create()
            label:setColor(cc.c3b(255, 255, 0))
            label:setDimensions(640, 960)
            label:setString(msg)
            label:setPosition(320, 480)
            label:setSystemFontSize(22)
            local colorlayer = cc.LayerColor:create(cc.c4b(128,128,128,125))
            colorlayer:addChild(label)
            colorlayer:setTag(11000)
            runningScene:addChild(colorlayer, 11000)
        else

        end
    end

end

function createFile()
    local filename = cc.FileUtils:getInstance():getWritablePath().."output"
    local f = io.open(filename, "w")
    f:close()
end


function appendFile(hero_no, title, message)
    local filename = cc.FileUtils:getInstance():getWritablePath().."output"
    print(filename)
    print("a-------")
    f = io.open(filename, "a")
    f:write("----------------------\n")
    f:write(title..hero_no)
    if type(message) == "table" then
        for k,v in pairs(message) do
            f:write(k.."----"..v.."\n")
        end
    else
        if message ~= nil then
            f:write(message.."\n")
        end
    end
    f:write("----------------------")
    f:close()
end

function appendFile2(message, tab_num)
     local filename = cc.FileUtils:getInstance():getWritablePath().."output"
     f = io.open(filename, "a")

     if not tab_num then
         tab_num = 0
     end
     local tab = ""
     for i=1,tab_num do
         tab = tab.."\t"
     end
     if message ~= nil then 
         f:write(tab..message.."\n") 
     end    
     f:close()
end

function stringEndsWith(str, ends)
    return ends=='' and string.sub(str, -string.len(ends))==ends
end

--通用掉落接口
--
function setCommonDrop(itemType, itemId, itemSprite, itemName, itemDes)
    print("itemType ============ ", itemType)
    print("itemId ============== ", itemId)
    local name = ""
    local des = ""
    if itemType < 100 then  -- 可直接读的资源图
        local _icon = getTemplateManager():getResourceTemplate():getResourceById(itemType)
        setItemImage3(itemSprite,"res/icon/resource/".._icon,1)
        if itemName ~= nil then
            name = getTemplateManager():getResourceTemplate():getResourceName(itemId)
        end
        if itemDes ~= nil then
            local desId = getTemplateManager():getResourceTemplate():getDesIdById(itemId)
            des = getTemplateManager():getLanguageTemplate():getLanguageById(desId)
        end
    else  -- 需要继续查表
        if itemType == 101 then -- 武将
            local _temp = getTemplateManager():getSoldierTemplate():getSoldierIcon(itemId)
            local quality = getTemplateManager():getSoldierTemplate():getHeroQuality(itemId)
            name = getTemplateManager():getSoldierTemplate():getHeroName(itemId)
            -- changeNewIconImage(itemSprite,_temp,quality)
            des = getTemplateManager():getSoldierTemplate():getDescribe(itemId)
            changeNewIconImageBottom(itemSprite,_temp,quality)

        elseif itemType == 102 then -- equpment
            local _temp = getTemplateManager():getEquipTemplate():getEquipResIcon(itemId)
            local quality = getTemplateManager():getEquipTemplate():getQuality(itemId)
            name = getTemplateManager():getEquipTemplate():getEquipName(itemId)
            des = getTemplateManager():getEquipTemplate():getDescribe(itemId)
            -- changeEquipIconImageBottom(itemSprite, _temp, quality)
            changeEquipIconImageBottom(itemSprite, _temp, quality)

        elseif itemType == 103 then -- hero chips
            local _temp = getTemplateManager():getChipTemplate():getTemplateById(itemId).resId
            local _icon = getTemplateManager():getResourceTemplate():getResourceById(_temp)
            local _quality = getTemplateManager():getChipTemplate():getTemplateById(itemId).quality
            name = getTemplateManager():getChipTemplate():getChipName(itemId)

            local patchTempLate = getTemplateManager():getSoldierTemplate():getChipTempLateById(itemId)
            local combineResult = patchTempLate.combineResult                   --合成结果
            local soldierTemplateItem = getTemplateManager():getSoldierTemplate():getHeroTempLateById(combineResult)
             _quality = patchTempLate.quality
            local resultName =  getTemplateManager():getLanguageTemplate():getLanguageById(soldierTemplateItem.nameStr)        --合成武将名称
            local needNum = patchTempLate.needNum                               --需要的碎片数量

            des = needNum .. "个碎片可合成武将" .. resultName

            changeHeroChipIconBottom(itemSprite, _icon, _quality)

        elseif itemType == 104 then -- equipment chips
            local _temp = getTemplateManager():getChipTemplate():getTemplateById(itemId).resId
            local _icon = getTemplateManager():getResourceTemplate():getResourceById(_temp)
            local _quality = getTemplateManager():getChipTemplate():getTemplateById(itemId).quality
            name = getTemplateManager():getChipTemplate():getChipName(itemId)

            local combineResult = getTemplateManager():getChipTemplate():getTemplateById(itemId).combineResult
            local equipmentItem = getTemplateManager():getEquipTemplate():getTemplateById(combineResult)
            local resultName =  getTemplateManager():getLanguageTemplate():getLanguageById(equipmentItem.name)        --合成装备名称
            local needNum = getTemplateManager():getChipTemplate():getTemplateById(itemId).needNum

            des = needNum .. "个碎片可合成装备" .. resultName

            changeEquipChipIconImageBottom(itemSprite, _icon, _quality)

        elseif itemType == 105 then  -- item
            local _temp = getTemplateManager():getBagTemplate():getItemResIcon(itemId)
            local quality = getTemplateManager():getBagTemplate():getItemQualityById(itemId)
            name = getTemplateManager():getBagTemplate():getItemName(itemId)
            des = getTemplateManager():getBagTemplate():getDescribe(itemId)
            setItemImage3(itemSprite,"res/icon/item/".._temp,quality)
        elseif itemType == 107 then
            local _icon = getTemplateManager():getResourceTemplate():getResourceById(itemId)
            setItemImage3(itemSprite,"res/icon/resource/".._icon,1)
            name = getTemplateManager():getResourceTemplate():getResourceName(itemId)
            local desId = getTemplateManager():getResourceTemplate():getDesIdById(itemId)
            des = getTemplateManager():getLanguageTemplate():getLanguageById(desId)
        elseif itemType == 108 then
            local resId = getTemplateManager():getStoneTemplate():getStoneItemById(itemId).res
            local resIcon = getTemplateManager():getResourceTemplate():getResourceById(resId)
            local quality = getTemplateManager():getStoneTemplate():getStoneItemById(itemId).quality
            local icon = "res/icon/rune/" .. resIcon
            name = getTemplateManager():getStoneTemplate():getStoneNameByID(itemId)
            getDataManager():getRuneData():setItemImage(itemSprite, icon, quality)
            des = getTemplateManager():getStoneTemplate():getDesById(itemId)
        end
    end

    if itemName ~= nil then
        itemName:setString(name)
    end
    if itemDes ~= nil then
        itemDes:setString(des)
    end
end

--通用掉落详细信息查看
function checkCommonDetail(itemType, itemId)
    if itemType < 100 then
        getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 2)
    elseif itemType == 101 then -- 武将
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVSoldierOtherDetail", itemId, 2, nil, 1)
    elseif itemType == 102 then -- 装备
        local equipment = getTemplateManager():getEquipTemplate():getTemplateById(itemId)
        getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVOtherEquipAttribute", equipment, 2)
    elseif itemType == 103 then -- 武将碎片
        local nowPatchNum = getDataManager():getSoldierData():getPatchNumById(itemId)
        getOtherModule():showOtherView("PVCommonChipDetail", 1, itemId, nowPatchNum)
    elseif itemType == 104 then -- 装备碎片
        local nowPatchNum = getDataManager():getEquipmentData():getPatchNumById(itemId)
        getOtherModule():showOtherView("PVCommonChipDetail", 2, itemId, nowPatchNum)
    elseif itemType == 105 then  -- 道具
        getOtherModule():showOtherView("PVCommonDetail", 1, itemId, 1)
    elseif itemType == 107 then
        getOtherModule():showOtherView("PVCommonDetail", 2, itemId, 2)
    elseif itemType == 108 then
        print("v.type == 108 ========== ", itemId)
        local runeItem = {}
        runeItem.runt_id = itemId
        runeItem.inRuneType = getTemplateManager():getStoneTemplate():getStoneItemById(itemId).type
        runeItem.runePos = 0
        getOtherModule():showOtherView("PVRuneLook", runeItem, 0, 2)
    end
end

--返回0到10的中文输出
--例如1返回1
function getCNNum(num)
    if num > 10 or num < 0 then
        print("error less than 10")
        return ""
    end
    local num_cn = {"〇","一","二","三","四","五","六","七","八","九","十"}
    return num_cn[num+1]
end

--设置玩家自己的头像
--created by Q
--created in 20150420
function setSpritePlayerHead(headIcon,headRes)
    print("headRes:")
    assert(headIcon ~= nil,"nil headIcon")

    game.setSpriteFrame(headIcon,"res/icon/hero_head/"..headRes)
end

function getIconByType(id, type_)
    if type_ == 101 or type_ == 103 then--英雄
        if type_ == 103 then--碎片
            id = getTemplateManager():getSoldierTemplate():getChipTempLateById(id).combineResult
        end
        return CONFIG_RES_ICON_HERO_PAHT..getTemplateManager():getSoldierTemplate():getSoldierIcon(id)
    elseif type_ == 102 then--装备
        return CONFIG_RES_EQUIPMENT_PAHT..getTemplateManager():getEquipTemplate():getEquipResIcon(id)
    elseif type_ == 104 then--装备碎片
        local temp = getTemplateManager():getChipTemplate():getTemplateById(id)
        if temp then
            return CONFIG_RES_EQUIPMENT_PAHT .. getTemplateManager():getResourceTemplate():getResourceById(temp.resId)
        end
        return nil
    elseif type_ == 105 then--道具
        return CONFIG_RES_ICON_ITEM_PAHT..getTemplateManager():getBagTemplate():getItemResIcon(id)
    elseif type_ == 107 then--资源
        return CONFIG_RES_ICON_RES_PAHT .. getTemplateManager():getResourceTemplate():getResourceById(id)
    elseif type_ == 108 then--符文
        local icon, _ = getTemplateManager():getStoneTemplate():getStoneIconByID(id)
        return icon
    elseif type_ == 109 then--风物志
        return CONFIG_RES_ICON_RES_PAHT .. getTemplateManager():getTravelTemplate():getResIconByeventID(id)
    end
end

function getQualityByType(id, tpye_)
    if type_ == 101 then --英雄
        local temp = getTemplateManager():getSoldierTemplate():getHeroTempLateById(id)
        if temp then 
            return temp.quality 
        else
            return 1
        end 
    elseif type_ == 103 then--英雄碎片
        local temp = getTemplateManager():getSoldierTemplate():getChipTempLateById(id)
        if temp then
            return temp.quality
        else
            return 1
        end
    elseif type_ == 102 then--装备
        return getTemplateManager():getEquipTemplate():getQuality(id)
    elseif type_ == 104 then--装备碎片
        local temp = getTemplateManager():getChipTemplate():getTemplateById(id)
        if temp then
            return temp.quality
        else
            return 1
        end
    elseif type_ == 105 then--道具
        return getTemplateManager():getBagTemplate():getQuality(id)
    elseif type_ == 107 then--资源 
        return 1 
    elseif type_ == 108 then--符文
        local _, quality = getTemplateManager():getStoneTemplate():getStoneIconByID(id)
        return quality
    elseif type_ == 109 then--风物志
        return 1          
    end
end
