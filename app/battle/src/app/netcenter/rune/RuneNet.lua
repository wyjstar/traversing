RUNE_ADD = 841                      --符文镶嵌
RUNE_DELETE  = 842                  --符文摘除
BAG_RUNES = 843                     --符文背包
RUNE_BUILD_REFRESH = 844            --打造刷新
RUNE_BUILD = 846
RUNE_SMELT = 845                    --符文炼化

local RuneNet =  class("RuneNet", BaseNetWork)

function RuneNet:ctor()
    self.super.ctor(self, "RuneNet")
    self:init()
end

function RuneNet:init()
    self.runeData = getDataManager():getRuneData()
    self:registerNetCallBack()
end

--符文背包数据
function RuneNet:sendBagRunes()
    print("net ========== 发送 ====== BAG_RUNES")
    self:sendMsg(BAG_RUNES)
end

--符文镶嵌 841
function RuneNet:sendAddRune(heroNo, runeType, runePos, runeNo)
    -- print("heroNo, runeType, runePos, runeNo ======== ", heroNo, runeType, runePos, runeNo)
    local data =
                {
                    hero_no = heroNo,
                    runt_type = runeType,
                    runt_po = runePos,
                    runt_no = runeNo
                }
    self:sendMsg(RUNE_ADD, "RuntSetRequest", data)
end

--符文摘除 842
function RuneNet:sendDeleRune(heroNo, runeType, runePos)
    -- print("发送摘除符文协议 =============== ", heroNo,      runeType,      runePos)
    local data =
                {
                    hero_no = heroNo,
                    runt_type = runeType,
                    runt_po = runePos
                }
    self:sendMsg(RUNE_DELETE, "RuntPickRequest", data)
end

--打造符文刷新 844
function RuneNet:sendRefreshRunes()
    print("刷新 ========== ")
    self:sendMsg(RUNE_BUILD_REFRESH)
end

--符文炼化 845
function RuneNet:sendSmeltRunes(smeltRunes)
    -- print("发送炼化符文消息 ============ ", table.getn(smeltRunes))
    -- table.print(smeltRunes)
    local data = { runt_no = smeltRunes }
    self:sendMsg(RUNE_SMELT, "RefiningRuntRequest", data)
end

--符文打造
function RuneNet:sendBuildRune()
    self:sendMsg(RUNE_BUILD)
end

function RuneNet:registerNetCallBack()
    --符文镶嵌返回 841
    local function addRuneCallBack(data)
        print("镶嵌返回 =============== ")
        table.print(data.res)
        print("data.res.result ======== ", data.res.result)
        print("data.res.result ======== ", data.res.result_no)
    end
    self:registerNetMsg(RUNE_ADD, "RuntSetResponse", addRuneCallBack)

    --符文摘除返回 842
    local function deleRuneCallBack(data)
        print("摘除返回 ============ ")
        print("data.res.result ======== ", data.res.result)
        print("data.res.result ======== ", data.res.result_no)
    end
    self:registerNetMsg(RUNE_DELETE, "RuntPickResponse", deleRuneCallBack)

    --背包数据 843
    local function getBagRunesCallBack(data)
        print("背包初始化返回 ============== ")
        self.runeData:setStone1(data.stone1)
        self.runeData:setStone2(data.stone2)
        self.runeData:setRefreshFreeTimes(data.refresh_times)
        -- self.runeData:setRefreshRuneId(data.refresh_runt.runt_id)
        self.runeData:setRefreshRuneItem(data.refresh_runt)
        print("data.refresh_runt ========= ", data.refresh_runt)
        print("data.refresh_runt ========= ", table.getn(data.refresh_runt))
        self.runeData:setBagRunes(data.runt)
    end

    self:registerNetMsg(BAG_RUNES, "InitRuntResponse", getBagRunesCallBack)

    --打造符文 符文刷新返回 844
    local function getRefreshCallBack(data)
        print("刷新返回 ============ ")
        self.runeData:setRefreshRuneItem(data.refresh_runt)
    end

    self:registerNetMsg(RUNE_BUILD_REFRESH, "RefreshRuntResponse", getRefreshCallBack)

    --炼化符文返回 845
    local function getSmeltCallBack(data)
    end

    self:registerNetMsg(RUNE_SMELT, "RefiningRuntResponse", getSmeltCallBack)

    --符文打造返回 846
    local function getBuildRuneCallBack(data)
        -- self.runeData:setRefreshRuneItem(data.refresh_runt)
    end

    self:registerNetMsg(RUNE_BUILD, "BuildRuntResponse", getBuildRuneCallBack)

end

return RuneNet
