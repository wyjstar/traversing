
--lua层数据管理类，管理动态数据实例

DataManage = DataManage or class("DataManage")

local SodierData = import(".sodiers.SoldierData")
local EquipmentData = import(".equipment.EquipmentData")
local LineupData = import(".sodiers.LineupData")
local BagData = import(".bag.BagData")
local ResourceData = import(".resource.ResourceData")
local CommonData = import(".CommonData")
local FriendData = import(".friend.FriendData")
local LegionData = import(".legion.LegionData")
local ShopData = import(".shop.ShopData")
local SacrificeData = import(".sacrifice.SacrificeData")
local ChatData = import(".chat.ChatData")
local StageData = import(".instance.StageData")
local EmailData = import(".email.EmailData")
local FightData = import(".fight.FightData")
local ArenaData = import(".arena.ArenaData")
local BossData = import(".arena.BossData")
local ActiveDegreeData = import(".active.ActiveDegreeData")
local TravelData = import(".travel.TravelData")
local RuneData = import(".rune.RuneData")
local SecretPlaceData = import(".SecretPlace.SecretPlaceData")
local InheritData = import(".inherit.InheritData")
local RankData = import(".rank.RankData")

function DataManage:ctor(controller)
    self.itemsData = nil --物品数据类
    self:init()
end

--初始化类的实例
function DataManage:init()
	self.c_sodierData = nil         --英雄数据
    self.c_equipmentData = nil      --装备数据
    self.c_lineupData = nil         --阵容数据
    self.c_bagData = nil            --背包数据
    self.c_resourceData = nil       --资源数据
    self.c_commonData = nil         --通用数据资源
    self.c_friendData = nil         --社交数据
    self.c_legionData = nil         --公会数据
    self.c_sacrificeData = nil      --献祭数据
    self.c_chatData = nil           --聊天数据
    self.c_stageData = nil          --关卡数据
    self.c_emailData = nil          --邮箱数据
    self.c_fightData = nil          --战斗数据
    self.c_arenaData = nil          --竞技场数据
    self.c_bossData = nil           --世界boss
    self.c_activeData = nil         --活跃度
    self.c_travelData = nil         --游历
    self.c_runeData = nil           --符文数据
    self.c_inheritData = nil        --传承
    self.c_rankData = nil           --排行

    self.c_mineData = nil           --秘境

end


--获取游历
function DataManage:getTravelData()
    if self.c_travelData == nil then
        self.c_travelData = TravelData.new()
    end

    return self.c_travelData
end

--获取传承
function DataManage:getInheritData()
    if self.c_inheritData == nil then
        self.c_inheritData = InheritData.new()
    end

    return self.c_inheritData
end

--获取邮箱
function DataManage:getEmailData()
    if self.c_emailData == nil then
        self.c_emailData = EmailData.new()
    end

    return self.c_emailData
end

--获取献祭数据管理
function DataManage:getSacrificeData()
    if self.c_sacrificeData == nil then
        self.c_sacrificeData = SacrificeData.new()
    end

    return self.c_sacrificeData
end

--清除献祭数据
function DataManage:clearSacrificeData()
    if self.c_sacrificeData then
        self.c_sacrificeData:clearData()
    end
end


--获取社交数据
function DataManage:getFriendData()
    if self.c_friendData == nil then
        self.c_friendData = FriendData.new()
    end
    return self.c_friendData
end

-- 清除好友社交数据
function DataManage:clearFriendData()
    if self.c_friendData then
        self.c_friendData:clearData()
    end
end

--获得英雄有关数据
function DataManage:getSoldierData()
    if self.c_sodierData == nil then
        self.c_sodierData = SodierData.new()
    end
    return self.c_sodierData
end

--获得装备有关数据
function DataManage:getEquipmentData()
    if self.c_equipmentData == nil then
        self.c_equipmentData = EquipmentData.new()
    end
    return self.c_equipmentData
end

--获得阵容有关数据
function DataManage:getLineupData()
    if self.c_lineupData == nil then
        self.c_lineupData = LineupData.new()
    end
    return self.c_lineupData
end

--获得背包有关数据
function DataManage:getBagData()
    if self.c_bagData == nil then
        self.c_bagData = BagData.new()
    end
    return self.c_bagData
end

--获得商城数据实例
function DataManage:getShopData()
    if self.c_shopData == nil then
        self.c_shopData = ShopData.new()
    end
    return self.c_shopData
end

--资源数据
function DataManage:getResourceData()
    if self.c_resourceData == nil then
        self.c_resourceData = ResourceData.new()
    end
    return self.c_resourceData
end

--通用数据资源
function DataManage:getCommonData()
    if self.c_commonData == nil then
        self.c_commonData = CommonData.new()
    end
    return self.c_commonData
end

--公会数据
function DataManage:getLegionData()
    if self.c_legionData == nil then
        self.c_legionData = LegionData.new()
    end
    return self.c_legionData
end

--聊天数据
function DataManage:getChatData()
    if self.c_chatData == nil then
        self.c_chatData = ChatData.new()
    end
    return self.c_chatData
end

--关卡数据
function DataManage:getStageData()
    if self.c_stageData == nil then
        self.c_stageData = StageData.new()
    end
    return self.c_stageData
end

--战斗数据
function DataManage:getFightData()
    if self.c_fightData == nil then
        self.c_fightData = FightData.new()
    end
    return self.c_fightData
end

--获得竞技场数据
function DataManage:getArenaData()
    if self.c_arenaData == nil then
        self.c_arenaData = ArenaData.new()
    end
    return self.c_arenaData
end

--世界boss数据
function DataManage:getBossData()
    if self.c_bossData == nil then
        self.c_bossData = BossData.new()
    end
    return self.c_bossData
end

--活跃度数据
function DataManage:getActiveData()
    if self.c_activeData == nil then
        self.c_activeData = ActiveDegreeData.new()
    end
    return self.c_activeData
end

--符文数据
function DataManage:getRuneData()
    if self.c_runeData == nil then
        self.c_runeData = RuneData.new()
    end
    return self.c_runeData
end


--游历数据
--function DataManage:getTravelData()
--    if self.c_travelData == nil then
--        self.c_travelData = TravelData.new()
--    end
--    return self.c_travelData
--end

--秘境数据
function DataManage:getMineData()
    if self.c_mineData == nil then
        self.c_mineData = SecretPlaceData.new()
    end
    return self.c_mineData
end

--排行数据
function DataManage:getRankData()
    if self.c_rankData == nil then
        self.c_rankData = RankData.new()
    end
    return self.c_rankData
end

--初始化加载数据加载
function DataManage:loadData()

end


--清除当前用户的数据
--loginout 时需要清楚当前用户的数据
function DataManage:clearCurrentPlayerData()
    print("DataManage:clearCurrentPlayerData===============================>")
    --self.c_equipmentData:resetData()--装备信息
    self.c_equipmentData = nil      --装备信息
    self.c_sodierData = nil         --英雄数据
    self.c_equipmentData = nil      --装备数据
    self.c_lineupData = nil         --阵容数据
    self.c_bagData = nil            --背包数据
    self.c_resourceData = nil       --资源数据
    self.c_commonData = nil         --通用数据资源
    self.c_friendData = nil         --社交数据
    self.c_legionData = nil         --公会数据
    self.c_sacrificeData = nil      --献祭数据
    self.c_chatData = nil           --聊天数据
    self.c_stageData = nil          --关卡数据
    self.c_emailData = nil          --邮箱数据
    self.c_fightData = nil          --战斗数据
    self.c_arenaData = nil          --竞技场数据
    self.c_bossData = nil           --世界boss
    self.c_activeData = nil         --活跃度
    self.c_travelData = nil         --游历
    self.c_runeData = nil           --符文数据
    self.c_inheritData = nil        --传承
    self.c_mineData = nil           --秘境
    self.c_rankData = nil
    g_DataProcessor = nil            -- 通用掉落

end

return DataManage
