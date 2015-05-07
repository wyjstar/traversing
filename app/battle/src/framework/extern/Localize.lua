
local Localize = {}

Localize.strings = {}
Localize.language = "cn"
Localize.localizeName = "Localize_cn"
Localize.localizeStrings = {}


require("src.app.datacenter.template.config.language_config")
Localize.localizeStrings = require("src.app.language."..Localize.localizeName)


function Localize.loadStrings(strings, lang)
    print(strings,lang)
    Localize.strings = strings
    Localize.language = lang

end

function Localize.query(key, default)
    if not default then default = key end

    local _text = nil

    -- 读language_config
    if language_config[key] ~= nil and language_config[key][Localize.language] ~= nil then

        _text = language_config[key][Localize.language]

        if _text ~= nil then return _text end
    end

    -- 读取Localize_cn.lua
    if not Localize.localizeStrings[Localize.language] or not Localize.localizeStrings[Localize.language][key] then return default end

    _text = Localize.localizeStrings[Localize.language][key]

    if _text == nil then
    	return "don't know!"
    end

    return _text
end

function Localize.filename(filenameOrigin)
    local fi = io.pathinfo(filenameOrigin)
    return fi.dirname .. fi.basename .. "_" .. device.language .. fi.extname
end

cc = cc or {}
cc.utils = cc.utils or {}
cc.utils.Localize = Localize

return Localize