
ui = ui or {}

ui.DEFAULT_TTF_FONT      = "Arial"
ui.DEFAULT_TTF_FONT_SIZE = 24

ui.COLOR_WHITE = cc.c3b(255,255,255)
ui.COLOR_BLACK = cc.c3b(0,0,0)
-- ui.COLOR_YELLOW = cc.c3b(255,180,0)
ui.COLOR_RED   = cc.c3b(255,0,0)
-- ui.COLOR_GREEN = cc.c3b(131,239,15)
-- ui.COLOR_BLUE  = cc.c3b(0,156,255)
ui.COLOR_GREY  = cc.c3b(166,167,159)
ui.COLOR_DARK_GREY  = cc.c3b(169,169,169)
ui.COLOR_PINK  = cc.c3b(233,160,230)
-- ui.COLOR_PURPLE = cc.c3b(255,0,255)


ui.COLOR_BLUE2  = cc.c3b(28,252,252)       -- 新版 高粱字体颜色  蓝色
ui.COLOR_YELLOW  = cc.c3b(255,186,0)      -- 新版 高粱字体颜色   黄色
ui.COLOR_MISE  = cc.c3b(254,225,180)       -- 新版 普通字体颜色  米色
ui.COLOR_RED_NEW  = cc.c3b(170,70,70)      -- 新版 说明字体颜色   红色
ui.COLOR_ORANGE  = cc.c3b(240,110,30)      -- 新版 羁绊字体颜色   橙色


ui.COLOR_PURPLE = cc.c3b(190,120,255)   -- 新版本紫色
ui.COLOR_BLUE  = cc.c3b(28,252,255)    -- 新版本蓝色
ui.COLOR_GREEN = cc.c3b(28,200,122)    -- 新版本绿色



function ui.newEditBox(params)
    local imageNormal = params.image
    local imagePressed = params.imagePressed
    local imageDisabled = params.imageDisabled

    if type(imageNormal) == "string" then
        imageNormal = game.newScale9Sprite(imageNormal)
    end
    if type(imagePressed) == "string" then
        imagePressed = game.newScale9Sprite(imagePressed)
    end
    if type(imageDisabled) == "string" then
        imageDisabled = game.newScale9Sprite(imageDisabled)
    end

    local editbox = cc.EditBox:create(params.size, imageNormal, imagePressed, imageDisabled)

    if editbox then
        editbox:registerScriptEditBoxHandler(params.listener)
        if params.x and params.y then
            editbox:setPosition(params.x, params.y)
        end
    end

    return editbox
end

function ui.newMenu(items)
    local menu
    menu = cc.Menu:create()

    for k, item in pairs(items) do
        if not tolua.isnull(item) then
            menu:addChild(item, 0, item:getTag())
        end
    end

    menu:setPosition(0, 0)
    return menu
end

function ui.newImageMenuItem(params)
    local imageNormal   = params.image
    local imageSelected = params.imageSelected
    local imageDisabled = params.imageDisabled
    local listener      = params.listener
    local tag           = params.tag
    local x             = params.x
    local y             = params.y
    local scale         = params.scale
    local sound         = params.sound

    if type(imageNormal) == "string" then
        imageNormal = game.newSprite(imageNormal)
    end
    if type(imageSelected) == "string" then
        imageSelected = game.newSprite(imageSelected)
    end
    if type(imageDisabled) == "string" then
        imageDisabled = game.newSprite(imageDisabled)
    end

    local item = cc.MenuItemSprite:create(imageNormal, imageSelected, imageDisabled)
    if item then
        if type(listener) == "function" then
            item:registerScriptTapHandler(function(tag)
                if sound then audio.playSound(sound) end
                listener(tag)
            end)
        end
        if x and y then item:setPosition(x, y) end
        if scale then item:setScale(scale) end
        if tag then item:setTag(tag) end
    end

    return item
end

function ui.newTTFLabelMenuItem(params)
    local p = clone(params)
    p.x, p.y = nil, nil
    local label = ui.newTTFLabel(p)

    local listener = params.listener
    local tag      = params.tag
    local x        = params.x
    local y        = params.y
    local sound    = params.sound

    local item = cc.MenuItemLabel:create(label)
    if item then
        if type(listener) == "function" then
            item:registerScriptTapHandler(function(tag)
                if sound then audio.playSound(sound) end
                listener(tag)
            end)
        end
        if x and y then item:setPosition(x, y) end
        if tag then item:setTag(tag) end
    end

    return item
end

function ui.newBMFontLabel(params)
    assert(type(params) == "table",
           "[framework.ui] newBMFontLabel() invalid params")

    local text      = tostring(params.text)
    local font      = params.font
    local textAlign = params.align or cc.TEXT_ALIGNMENT_CENTER
    local x, y      = params.x, params.y
    assert(font ~= nil, "ui.newBMFontLabel() - not set font")

    local label = cc.LabelBMFont:create(text, font, cc.LABEL_AUTOMATIC_WIDTH, textAlign)
    if not label then return end

    if type(x) == "number" and type(y) == "number" then
        label:setPosition(x, y)
    end

    return label
end

function ui.newTTFLabel(params)
    assert(type(params) == "table",
           "[framework.ui] newTTFLabel() invalid params")

    local text          = tostring(params.text)
    local font          = params.font or ui.DEFAULT_TTF_FONT
    local size          = params.size or ui.DEFAULT_TTF_FONT_SIZE
    local color         = params.color or ui.COLOR_WHITE
    local textAlign     = params.align or cc.TEXT_ALIGNMENT_LEFT
    local textValign    = params.valign or cc.VERTICAL_TEXT_ALIGNMENT_CENTER
    local x, y          = params.x, params.y
    local dimensions    = params.dimensions
    local stroke        = params.stroke
    local shadow        = params.shadow

    assert(type(size) == "number",
           "[framework.ui] newTTFLabel() invalid params.size")

    local label
    if dimensions then
        label = cc.LabelTTF:create(text, font, size, dimensions, textAlign, textValign)
    else
        label = cc.LabelTTF:create(text, font, size)
    end

    if label then
        label:setColor(color)

        if stroke then label:enableStroke(stroke.color, stroke.size) end
        if shadow then label:enableShadow(shadow.offset, shadow.opacity, shadow.blur) end

        function label:realign(x, y)
            if textAlign == cc.TEXT_ALIGNMENT_LEFT then
                label:setPosition(math.round(x + label:getContentSize().width / 2), y)
            elseif textAlign == cc.TEXT_ALIGNMENT_LEFT then
                label:setPosition(x - math.round(label:getContentSize().width / 2), y)
            else
                label:setPosition(x, y)
            end
        end

        if x and y then label:realign(x, y) end
    end

    return label
end


function ui.newTextField(params )
    assert(type(params) == "table",
           "[framework.ui] newTTFLabel() invalid params")
    local placeHoder = params.placeHoder or "Please input Text"
    local fontName = tostring(params.fontName) or const.FONT_NAME
    local fontSize = params.fontSize or 28
    local maxlength = params.maxLength or 0
    local size = params.size or {}
    local txt = ccui.TextField:create(placeHoder,fontName,fontSize)

    if maxlength > 0 then
        txt:setMaxLengthEnabled(true)
        txt:setMaxLength(maxlength)
    end

    if params.verticalAlignment ~= nil then --0是TOP 1是CENTER 2：BOTTOM
        txt:setTextVerticalAlignment(params.verticalAlignment)
    end

    txt:setTextAreaSize(size)
    txt:ignoreContentAdaptWithSize(false)
    txt:setSize(size)
    txt:setPosition(params.x or 0, params.y or 0)

    -- local function txtFieldEvent(sender,t)
    --     print("type:",type)
    --     if t == ccui.TextField.EVENT_ATTACH_WITH_ME then
    --         print("打开ime")
    --     elseif t == ccui.TextField.EVENT_DETACH_WITH_ME then
    --         txt.setAreaSize(size)
    --         print("end ime")
    --     end
    -- end

    -- txt:addEventListener(txtFieldEvent)

    return txt
end






