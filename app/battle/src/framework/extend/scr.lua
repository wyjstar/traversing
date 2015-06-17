
scr = scr or {}

local sharedDirector = cc.Director:getInstance()
local glview = sharedDirector:getOpenGLView()
local glsize = glview:getFrameSize()

if CONFIG_PROJECTION == "2D" then
    sharedDirector:setProjection(cc.DIRECTOR_PROJECTION_2D)
elseif CONFIG_PROJECTION == "3D" then
    sharedDirector:setProjection(cc.DIRECTOR_PROJECTION_3D)
end

local w = glsize.width
local h = glsize.height

local winSize = sharedDirector:getWinSize()

if CONFIG_SCREEN_WIDTH == nil or CONFIG_SCREEN_HEIGHT == nil then
    CONFIG_SCREEN_WIDTH = w
    CONFIG_SCREEN_HEIGHT = h
end

if not CONFIG_SCREEN_AUTOSCALE then
    if w > h then
        CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
    else
        CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
    end
else
    CONFIG_SCREEN_AUTOSCALE = string.upper(CONFIG_SCREEN_AUTOSCALE)
end

local scale, scaleX, scaleY

if CONFIG_SCREEN_AUTOSCALE then
    if type(CONFIG_SCREEN_AUTOSCALE_CALLBACK) == "function" then
        scaleX, scaleY = CONFIG_SCREEN_AUTOSCALE_CALLBACK(w, h, device.model)
    end

    if not scaleX or not scaleY then
        scaleX, scaleY = w / CONFIG_SCREEN_WIDTH, h / CONFIG_SCREEN_HEIGHT
    end

    if CONFIG_SCREEN_AUTOSCALE == "FIXED_WIDTH" then
        scale = scaleX
        CONFIG_SCREEN_HEIGHT = h / scale
    elseif CONFIG_SCREEN_AUTOSCALE == "FIXED_HEIGHT" then
        scale = scaleY
        CONFIG_SCREEN_WIDTH = w / scale
    else
        scale = 1.0
        --printError(string.format("display - invalid CONFIG_SCREEN_AUTOSCALE \"%s\"", CONFIG_SCREEN_AUTOSCALE))
    end

    glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.NO_BORDER)
end
scr.size               = {width = CONFIG_SCREEN_WIDTH, height = CONFIG_SCREEN_HEIGHT}
scr.width              = scr.size.width
scr.height             = scr.size.height
scr.cx                 = scr.width / 2
scr.cy                 = scr.height / 2
scr.left               = 0
scr.right              = scr.width
scr.top                = scr.height
scr.bottom             = 0
scr.contentScaleFactor = scale
scr.sizeInPixels       = {width = glsize.width, height = glsize.height}
scr.widthInPixels      = scr.sizeInPixels.width
scr.heightInPixels     = scr.sizeInPixels.height
scr.sizeInWin          = {width = winSize.width, height = winSize.height}
scr.widthInWin         = scr.sizeInWin.width
scr.heightInWin        = scr.sizeInWin.height

debug.echoInfo(string.format("# CONFIG_SCREEN_WIDTH      = %0.2f", CONFIG_SCREEN_WIDTH))
debug.echoInfo(string.format("# CONFIG_SCREEN_HEIGHT     = %0.2f", CONFIG_SCREEN_HEIGHT))
debug.echoInfo(string.format("# scr.width                = %0.2f", scr.width))
debug.echoInfo(string.format("# scr.height               = %0.2f", scr.height))
debug.echoInfo(string.format("# scr.cx                   = %0.2f", scr.cx))
debug.echoInfo(string.format("# scr.cy                   = %0.2f", scr.cy))
debug.echoInfo(string.format("# scr.left                 = %0.2f", scr.left))
debug.echoInfo(string.format("# scr.right                = %0.2f", scr.right))
debug.echoInfo(string.format("# scr.top                  = %0.2f", scr.top))
debug.echoInfo(string.format("# scr.bottom               = %0.2f", scr.bottom))
debug.echoInfo(string.format("# scr.contentScaleFactor   = %0.2f", scr.contentScaleFactor))
debug.echoInfo(string.format("# scr.widthInPixels        = %0.2f", scr.widthInPixels))
debug.echoInfo(string.format("# scr.heightInPixels       = %0.2f", scr.heightInPixels))
debug.echoInfo(string.format("# scr.widthInWin           = %0.2f", scr.widthInWin))
debug.echoInfo(string.format("# scr.heightInWin          = %0.2f", scr.heightInWin))
-- debug.echoInfo(string.format("# scr.sceneRootX           = %0.2f", scr.sceneRootPoint.x))
-- debug.echoInfo(string.format("# scr.sceneRootY           = %0.2f", scr.sceneRootPoint.y))
-- debug.echoInfo(string.format("# scr.sceneRootRotate      = %0.2f", scr.sceneRootRotate))
debug.echoInfo("#")

scr.CENTER        = 1
scr.LEFT_TOP      = 2; scr.TOP_LEFT      = 2
scr.CENTER_TOP    = 3; scr.TOP_CENTER    = 3
scr.RIGHT_TOP     = 4; scr.TOP_RIGHT     = 4
scr.CENTER_LEFT   = 5; scr.LEFT_CENTER   = 5
scr.CENTER_RIGHT  = 6; scr.RIGHT_CENTER  = 6
scr.BOTTOM_LEFT   = 7; scr.LEFT_BOTTOM   = 7
scr.BOTTOM_RIGHT  = 8; scr.RIGHT_BOTTOM  = 8
scr.BOTTOM_CENTER = 9; scr.CENTER_BOTTOM = 9

scr.ANCHOR_POINTS = {
    {x = 0.5, y = 0.5},  -- CENTER
    {x = 0, y = 1},      -- TOP_LEFT
    {x = 0.5, y = 1},    -- TOP_CENTER
    {x = 1, y = 1},      -- TOP_RIGHT
    {x = 0, y = 0.5},    -- CENTER_LEFT
    {x = 1, y = 0.5},    -- CENTER_RIGHT
    {x = 0, y = 0},      -- BOTTOM_LEFT
    {x = 1, y = 0},      -- BOTTOM_RIGHT
    {x = 0.5, y = 0},    -- BOTTOM_CENTER
}
