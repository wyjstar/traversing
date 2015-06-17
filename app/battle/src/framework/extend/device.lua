
device = device or {}

device.platform    = "unknown"
device.model       = "unknown"

local sharedApplication = cc.Application:getInstance()
local target = sharedApplication:getTargetPlatform()
if target == cc.PLATFORM_OS_WINDOWS then
    device.platform = "windows"
elseif target == cc.PLATFORM_OS_MAC then
    device.platform = "mac"
elseif target == cc.PLATFORM_OS_ANDROID then
    device.platform = "android"
elseif target == cc.PLATFORM_OS_IPHONE then
    device.platform = "ios"
    device.model = "iphone"
elseif target == cc.PLATFORM_OS_IPAD then
    device.platform = "ios"
    device.model = "ipad"
end

local language_ = sharedApplication:getCurrentLanguage()
if language_ == cc.LANGUAGE_CHINESE then
    language_ = "cn"
elseif language_ == cc.LANGUAGE_ENGLISH then
    language_ = "en"
elseif language_ == cc.LANGUAGE_FRENCH then
    language_ = "fr"
elseif language_ == cc.LANGUAGE_ITALIAN then
    language_ = "it"
elseif language_ == cc.LANGUAGE_GERMAN then
    language_ = "gr"
elseif language_ == cc.LANGUAGE_SPANISH then
    language_ = "sp"
elseif language_ == cc.LANGUAGE_RUSSIAN then
    language_ = "ru"
else
    language_ = "cn"
end

device.language = language_
device.writablePath = cc.FileUtils:getInstance():getWritablePath()
device.directorySeparator = "/"
device.pathSeparator = ":"
if device.platform == "windows" then
    device.directorySeparator = "\\"
    device.pathSeparator = ";"
end

debug.echoInfo("# device.platform              = " .. device.platform)
debug.echoInfo("# device.model                 = " .. device.model)
debug.echoInfo("# device.language              = " .. device.language)
debug.echoInfo("# device.writablePath          = " .. device.writablePath)
debug.echoInfo("# device.directorySeparator    = " .. device.directorySeparator)
debug.echoInfo("# device.pathSeparator         = " .. device.pathSeparator)
debug.echoInfo("#")
