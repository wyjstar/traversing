local action = import("src.app.fightview.modeldata.action")
local buff_action = import("src.app.fightview.modeldata.buff_action")
local ActionUtil = class("ActionUtil")

function ActionUtil:ctor()
    self.file = ""
    self.data = {}
    self.bufffile = ""
    self.buffdata = {}
    --self:init()
end

function ActionUtil:init()
    -- if TEST_ISSHOW_EDIT then
    --     if device.platform == "ios" and string.find(device.writablePath, "Simulator") then
    --         self.file = string.sub(device.writablePath, string.find(device.writablePath, "^/Users/.-/")) .. "GameData/action.json"
    --         self.bufffile = string.sub(device.writablePath, string.find(device.writablePath, "^/Users/.-/")) .. "GameData/buff_action.json"
    --     elseif device.platform == "windows" then
    --         self.file = "D:\\GameData\\action.json"
    --         self.bufffile = "D:\\GameData\\buff_action.json"
    --     else
    --         self.file = "res/data/action.json"
    --         self.bufffile = "res/data/buff_action.json"
    --     end
    -- else
    --     self.file = cc.FileUtils:getInstance():fullPathForFilename("res/data/action.json")
    --     self.bufffile = cc.FileUtils:getInstance():fullPathForFilename("res/data/buff_action.json")
    -- end
    self:load()
    self:update()
    self:loadbuff()
end

function ActionUtil:update()
    for _, v in pairs(self.data) do
        v.target = nil
        v.card = v.card or {}
        v.board = v.board or {}
        v.hero = v.hero or {}
        v.bullet1 = v.bullet1 or {}
        v.bullet2 = v.bullet2 or {}
        v.bullet3 = v.bullet3 or {}
    end
end

function ActionUtil:load()
    -- if self.file == "" then return end

    -- local f = io.open(self.file, "r")
    -- if f then
    --     local s = f:read("*a")
    --     f:close()

    --     self.data = json.decode(s)

    -- else
    --     local s = cc.FileUtils:getInstance():getStringFromFile(self.file)
    --     self.data = json.decode(s)
    -- end
    self.data = action
end

function ActionUtil:save()
    -- if self.file == "" then return end

    -- local f = io.open(self.file, "w")
    -- if not f then return end

    -- local s = f:write(json.encode(self.data))
    
    -- f:close()
end

function ActionUtil:loadbuff()
    self.buffdata = buff_action
    print("loadbuff=========a", self.buffdata["30006"])
    -- if self.bufffile == "" then return end

    -- local f = io.open(self.bufffile, "r")
    -- if f then
    --     local s = f:read("*a")
    --     f:close()
    --     self.buffdata = json.decode(s)
    -- else
    --     local s = cc.FileUtils:getInstance():getStringFromFile(self.bufffile)
    --     self.buffdata = json.decode(s)
    -- end
end

function ActionUtil:getUsedFiles()
    local ret = {}

    for _, v in pairs(self.data) do
        for _, v2 in pairs(v) do
            for _, v3 in pairs(v2) do
                if v3 and v3.animate then
                    ret[string.sub(v3.animate.file, 1, -3)] = 0
                end
                if v3 and v3.animateS then
                    ret[string.sub(v3.animateS.file, 1, -3)] = 0
                end
            end
        end
    end

    return ret
end

function ActionUtil:clearData()
    self.buffdata = nil
    self.buffdata = {}
end

return ActionUtil











