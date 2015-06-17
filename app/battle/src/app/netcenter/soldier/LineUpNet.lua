--武将网络
local LineUpNet = class("LineUpNet", BaseNetWork)


function LineUpNet:ctor()
    self.super.ctor(self, self.__cname)
    self:init()
    self:initRegisterNet()
end

NET_ID_GET_LINEUP = 701
NET_ID_CHANGE_HERO = 702
NET_ID_CHANGE_EQUIPMENT = 703
NET_ID_CHANGE_MULTI_EQUIPMENT = 704
NET_ID_WS_UPGRADE = 705

NET_ID_SEAL = 118
NET_STRENGTH_EQUIP_LINEUP = 707

function LineUpNet:init()

    self.lineUpData = getDataManager():getLineupData()
end

--发送获取武将列表
function LineUpNet:sendGetLineUpMsg()
    print("----------------------- sendGetLineUpMsg ----------------------------")
    self:sendMsg(NET_ID_GET_LINEUP)
end

--更换武将
-- required int32 slot_no = 1; // 位置编号
--     optional int32 change_type = 2; // 更换类型：0：阵容 1：助威
--     optional int32 hero_no = 3; // 英雄编号
function LineUpNet:sendChangeHeroMsg(seat_no, hero_id)

    print(seat_no.."--"..hero_id)

    local data = {slot_no = seat_no,
                change_type = 0,
                hero_no = hero_id
        }

    self:sendMsg(NET_ID_CHANGE_HERO, "ChangeHeroRequest", data)
end

--发送更换助威武将
function LineUpNet:sendChangeCheerHeroMsg(seat_no, hero_id)
    local data = {slot_no = seat_no,
                change_type = 1,
                hero_no = hero_id
        }

    self:sendMsg(NET_ID_CHANGE_HERO, "ChangeHeroRequest", data)
end
--更换装备
    -- required int32 slot_no = 1; // 位置编号
    -- optional int32 no = 2;  //装备格子编号
    -- optional string equipment_id = 3; // 装备ID
function LineUpNet:sendChangeEquipmentMsg(slot_no, seat_no, equip_id)
    local data = {slot_no = slot_no,
                no = seat_no,
                equipment_id = equip_id
        }

    self:sendMsg(NET_ID_CHANGE_EQUIPMENT, "ChangeEquipmentsRequest", data)
end

--一键换装
    --repeated ChangeEquipmentsRequest equs = 1; //多个装备
function LineUpNet:sendChangeMultiEquipmentMsg(equs_data)
    print("-----sendChangeMultiEquipmentMsg----")
    table.print(equs_data)
    local data = equs_data
    self:sendMsg(NET_ID_CHANGE_MULTI_EQUIPMENT, "ChangeMultiEquipmentsRequest", data)
end


--冲穴协议
function LineUpNet:sendSealMsg(heroId, refineId)
    local data = {hero_no = heroId, refine = refineId}
    print("发送冲穴协议", heroId, refineId)
    self:sendMsg(NET_ID_SEAL, "HeroRefineRequest", data)
end

--发送无双升级
function LineUpNet:sendWSUpgrade( wsId, wsLevel )
    local data = {skill_id = wsId, skill_level = wsLevel}
    print("发送无双升级协议", wsId, wsLevel)
    self:sendMsg(NET_ID_WS_UPGRADE, "LineUpUnparUpgrade", data)
end

--发送一键强化装备
function LineUpNet:sendEquipStrength(slot_no)
    local data = {slot_no = slot_no}
    self:sendMsg(NET_STRENGTH_EQUIP_LINEUP, "AllEquipmentsStrengthRequest", data)
end

--注册接受网络协议
function LineUpNet:initRegisterNet()


    local function onGetLineUpCallBack(data)
        cclog("+++++++++++++++++++  onGetLineUpCallBack  ++++++++++++++++++++")
         -- table.print(data)
        table.remove(g_netResponselist)
        self.lineUpData:setSelectSoldierData(data.slot)
        self.lineUpData:setCheerData(data.sub)
        self.lineUpData:setWSListData(data.unpars)
        self.lineUpData:setEmbattleOrder(data.order)
        self.lineUpData:setEmbattleUnpar(data.unpar_id)
        self.lineUpData:setLegionLevel(data.guild_level)
        self.lineUpData:setTravelItemChapter(data.travel_item_chapter)
    end

    local function onChangeHeroCallBack(data)
        -- table.print(data)
        cclog("+++++++++++++++++++  onChangeHeroCallBack  ++++++++++++++++++++ ")
        self.lineUpData:setSelectSoldierData(data.slot)
        self.lineUpData:setCheerData(data.sub)
    end

    local function onChangeEquipmentCallBack(data)
        cclog("+++++++++++++++++++  onChangeEquipmentCallBack  ++++++++++++++++++++ ")
        table.print(data)
        self.lineUpData:setSelectSoldierData(data.slot)
        self.lineUpData:setCheerData(data.sub)
    end

    local function onChangeMultiEquipmentCallBack(data)
        cclog("+++++++++++++++++++  onChangeEquipmentCallBack  ++++++++++++++++++++ ")
        self.lineUpData:setSelectSoldierData(data.slot)
        self.lineUpData:setCheerData(data.sub)
    end

    local function onSealCallback(data)
        cclog("+++++++++++++++++++  onSealCallback  ++++++++++++++++++++  ")
        table.print(data)
        print("response : ", data.result, data.message)
    end

    local function onWSUpgradeCallback( data )
        cclog("+++++++++++++++++++  onWSUpgradeCallback  ++++++++++++++++++++  ")
    end

    local function onStrengthEquipmentCallBack(data)
        -- print("-------data.res.result-------",data.res.result)
        -- table.print(data)
        -- self.lineUpData:setEquipmentStrengthInfo(data)
        if data.res.result then
            self.lineUpData:setEquipmentStrengthInfo(data)
        else
            print("------result_no-------",result_no)
        end
    end

    self:registerNetMsg(NET_ID_GET_LINEUP, "LineUpResponse", onGetLineUpCallBack)
    self:registerNetMsg(NET_ID_CHANGE_HERO, "LineUpResponse", onChangeHeroCallBack)
    self:registerNetMsg(NET_ID_CHANGE_EQUIPMENT, "LineUpResponse", onChangeEquipmentCallBack)
    self:registerNetMsg(NET_ID_CHANGE_MULTI_EQUIPMENT, "LineUpResponse", onChangeMultiEquipmentCallBack)
    self:registerNetMsg(NET_ID_SEAL, "CommonResponse", onSealCallback)
    self:registerNetMsg(NET_ID_WS_UPGRADE, "CommonResponse", onWSUpgradeCallback)
    self:registerNetMsg(NET_STRENGTH_EQUIP_LINEUP, "AllEquipmentsStrengthResponse", onStrengthEquipmentCallBack)
end

return LineUpNet
