--首页
local PVHomePage = import("...ui.homepage.PVHomePage")
--活动
local PVActivityPage = import("...ui.homepage.activity.PVActivityPage")
-- local PVSignEveryDay = import("...ui.homepage.activity.PVSignEveryDay")
-- local PVBuyTL = import("...ui.homepage.activity.PVBuyStamina")

--common相关
-- local PVSystemTips = import("...ui.homepage.common.SystemTips")
local PVDialogGetcard = import("...ui.homepage.common.DialogGetCard")
local PVDialogGetcardUpdate = import("...ui.homepage.common.DialogGetCardUpdate")

--商城相关
local PVShopBuyByNum = import("...ui.homepage.shop.PVShopBuyByNum")

--装备相关
local PVEquipmentMain = import("...ui.homepage.equipment.PVEquipmentMain")
local PVEquipmentAttribute = import("...ui.homepage.equipment.PVEquipmentAttribute")
local PVOtherEquipAttribute = import("...ui.homepage.equipment.PVOtherEquipAttribute")
local PVEquipmentStrengthen = import("...ui.homepage.equipment.PVEquipmentStrengthen")
local PVEquipmentSmelting = import("...ui.homepage.equipment.PVSelectSmeltEquip")
local PVEquipmentAwaken = import("...ui.homepage.equipment.PVEquipmentAwaken")
local PVShowCard = import("...ui.homepage.equipment.PVEquipShowCard")
-- local PVGetPath = import("...ui.homepage.equipment.PVChipGetDetail")
-- local PVEquipShop = import("...ui.homepage.equipment.PVEquipShop")

--武将相关
local PVSoldierMain = import("...ui.homepage.soldier.PVSoldierMain")
local PVSoldierMyLookDetail = import("...ui.homepage.soldier.PVSoldierMyLookDetail")
-- local PVSoldierOtherDetail = import("...ui.homepage.soldier.PVSoldierOtherDetail")
local PVSoldierBreakDetail = import("...ui.homepage.soldier.PVSoldierBreakDetail")
local PVSoldierUpgradeDetail = import("...ui.homepage.soldier.PVSoldierUpgradeDetail")
local PVShowCardSoldier = import("...ui.homepage.soldier.PVSoldierShowCard")

--副本相关
local PVChapters = import("...ui.homepage.instance.PVChapters")             --章节选择
local PVChapterIntroduce = import("...ui.homepage.instance.PVChapterIntroduce")  --章节介绍
local PVStageDetails = import("...ui.homepage.instance.PVStageDetails")     --关卡详情
local PVEmbattle = import("...ui.homepage.instance.PVEmbattle")             --站前准备：布阵
local PVEmploy = import("...ui.homepage.instance.PVEmploySoldier")          --雇佣士兵
local PVSelectWS = import("...ui.homepage.instance.PVSelectWS")             --无双选择
local PVStageEntry = import("...ui.homepage.instance.PVStageEntry")         --武将乱入

--武将献祭、武魂相关
local PVSacrificePanel = import("...ui.homepage.soul.PVSacrificePanel")          --武将献祭页面
local PVGeneralList = import("...ui.homepage.soul.PVGeneralList")                --武魂兑换界面
local PVSecretShop = import("...ui.homepage.soul.PVSecretShop")                  --神秘商店
local PVExchangeDialog = import("...ui.homepage.soul.PVExchangeDialog")          --兑换结果

--军团相关
local PVLegionApply = import("...ui.homepage.legion.PVLegionApply")              --军团申请页面
-- local PVCommonDialog = import("...ui.homepage.legion.PVCommonDialog")            --元宝不足页面
local PVLegionPanel = import("...ui.homepage.legion.PVLegionPanel")              --军团首页
-- local PVLegionWorship = import("...ui.homepage.legion.PVLegionWorship")          --军团膜拜
local PVLegionRank = import("...ui.homepage.legion.PVLegionRank")                --军团排行
local PVLegionApplyList = import("...ui.homepage.legion.PVLegionApplyList")      --申请列表
local PVLegionMemberList = import("...ui.homepage.legion.PVLegionMemberList")    --成员列表
local PVLegionKillOut = import("...ui.homepage.legion.PVLegionKillOut")          --踢出军团
local PVLegionTransfer = import("...ui.homepage.legion.PVLegionTransfer")        --转让军团
-- local PVLegionAnnouncement = import("...ui.homepage.legion.PVLegionAnnouncement")   --编辑公告
local PVShopPage = import("...ui.shop.PVShopPage2")                                  --商城界面

--聊天相关
local PVChatPanel = import("...ui.homepage.chat.PVChatPanel")                    --聊天

--社交(好友)相关
local PVFriendPanel = import("...ui.homepage.friend.PVFriendPanel")              --好友界面
local PVFriendApply = import("...ui.homepage.friend.PVFriendApply")              --好友申请
local PVFriendSecondMenu = import("...ui.homepage.friend.PVFriendSecondMenu")    --好友二级菜单
local PVFriendPrivateChat = import("...ui.homepage.friend.PVFriendPrivateChat")    --好友  私聊

--创建战队名称
-- local PVCreateTeam = import("...platform.PVCreateTeam")

--竞技场
local PVArenaPanel = import("...ui.homepage.arena.PVArenaPanel")                --竞技场
local PVArenaCheckInfo = import("...ui.homepage.arena.PVArenaCheckInfo")        --竞技场排行查看战队信息
-- local PVArenaWarPanel = import("...ui.homepage.arena.PVArenaWarPanel")          --竞技场入口争霸界面
local PVTimeWorldBoss = import("...ui.homepage.arena.PVTimeWorldBoss")          --世界boss开启界面
local PVTimeBossWait = import("...ui.homepage.arena.PVTimeBossWait")            --世界boss未开启界面
local PVBossRank = import("...ui.homepage.arena.PVBossRank")                  --排行

--游历
local PVTravelPanel = import("...ui.homepage.travel.PVTravelPanel")            --游历
local PVTravelPlace = import("...ui.homepage.travel.PVTravelPlace")            --桃花园
local PVTravelTraveling = import("...ui.homepage.travel.PVTravelTraveling")
local PVTravelFengwuzhi = import("...ui.homepage.travel.PVTravelFengwuzhi")
local PVTravelMeet = import("...ui.homepage.travel.PVTravelMeet")

--活跃度
local PVActiveDegree = import("...ui.homepage.active.PVActiveDegree")           --活跃度

--战斗特效
local PVPeerless = import("...ui.Effect.PVPeerless")

--符文
local PVRunePanel = import("...ui.homepage.rune.PVRunePanel")                   --符文界面
local PVSmeltPanel = import("...ui.homepage.rune.PVSmeltPanel")                 --炼化界面
local PVRuneBagPanel = import("...ui.homepage.rune.PVRuneBagPanel2")             --符文背包
local PVRuneBagCheck = import("...ui.homepage.rune.PVRuneBagCheck")             --符文背包查看
local PVRuneBuildPanel = import("...ui.homepage.rune.PVRuneBuildPanel")         --符文打造
local PVRuneChangeSoldier = import("...ui.homepage.rune.PVRuneChangeSoldier")         --符文打造


local PVSecretPlacePanel = import("...ui.homepage.secretplace.PVSecretPlacePanel")             --符文秘境


local PVSecretPlaceMyMineInfo = import("...ui.homepage.secretplace.PVSecretPlaceMyMineInfo")   --符文秘境查看自己信息
local PVSecretPlaceSeizeMineInfo = import("...ui.homepage.secretplace.PVSecretPlaceSeizeMineInfo")

-- local PVSignEveryDay = import("...ui.homepage.activity.PVSignEveryDay")


--传承
local PVInheritView = import("...ui.homepage.inherit.PVInheritView")            --传承
-- local PVInheritLTList = import("...ui.homepage.inherit.PVInheritLTList")        --传承武将列表
-- local PVInheritZBList = import("...ui.homepage.inherit.PVInheritZBList")        --传承装备列表
-- local PVInheritWSList = import("...ui.homepage.inherit.PVInheritWSList")        --传承无双列表
local HomePageModule = class("HomePageModule", BaseModuleView)

function HomePageModule:ctor()
    self.super.ctor(self)
    self.moduleName = self.__cname
    -- self:loadBaseModuleUi(PVHomePage)

    --活动
    self:pushModule(PVActivityPage)
    self:pushModule(require("src.app.ui.homepage.activity.PVSignEveryDay"))
    -- self:pushModule(PVBuyTL)

    --common
    -- self:pushModule(PVSystemTips)
    self:pushModule(PVDialogGetcard)
    self:pushModule(PVDialogGetcardUpdate)

    self:pushModule(PVShopBuyByNum)

    --装备
    self:pushModule(PVEquipmentMain)
    self:pushModule(PVEquipmentAttribute)
    self:pushModule(require("src.app.ui.homepage.equipment.PVOtherEquipAttribute"))
    self:pushModule(require("src.app.ui.homepage.equipment.PVOtherPlayerEquipAttribute"))
    self:pushModule(PVEquipmentStrengthen)
    self:pushModule(PVEquipmentSmelting)
    self:pushModule(PVEquipmentAwaken)
    self:pushModule(PVShowCard)
    self:pushModule(require("src.app.ui.homepage.equipment.PVChipGetDetail"))--(PVGetPath)
    self:pushModule(require("src.app.ui.homepage.equipment.PVEquipShop"))

    --武将
    self:pushModule(PVSoldierMain)
    self:pushModule(PVSoldierMyLookDetail)
    self:pushModule(PVSoldierBreakDetail)
    self:pushModule(PVSoldierUpgradeDetail)
    self:pushModule(PVShowCardSoldier)
    self:pushModule(require("src.app.ui.homepage.soldier.PVSoldierOtherDetail"))
    self:pushModule(require("src.app.ui.homepage.soldier.PVSoldierBreakSuccessDetail"))

    --副本
    self:pushModule(PVChapters)
    self:pushModule(PVChapterIntroduce)
    self:pushModule(PVStageDetails)
    self:pushModule(PVEmbattle)
    self:pushModule(PVEmploy)
    self:pushModule(PVSelectWS)
    self:pushModule(PVStageEntry)
    self:pushModule(require("src.app.ui.homepage.instance.PVMopUp"))
    -- self:pushModule(require("src.app.ui.homepage.instance.PVStarAwardShow"))
    self:pushModule(require("src.app.ui.homepage.instance.PVStarAwardView"))
    self:pushModule(require("src.app.ui.homepage.instance.PVStarAwardResult"))
    self:pushModule(require("src.app.ui.homepage.instance.PVCorpsUpgrade"))

    --武将献祭、武魂相关
    self:pushModule(PVSacrificePanel)
    self:pushModule(PVGeneralList)
    self:pushModule(PVSecretShop)
    self:pushModule(PVExchangeDialog)


    --军团相关
    self:pushModule(PVLegionApply)
    -- self:pushModule(PVCommonDialog)
    self:pushModule(PVLegionPanel)
    -- self:pushModule(PVLegionWorship)
    self:pushModule(PVLegionRank)
    self:pushModule(PVLegionApplyList)
    self:pushModule(PVLegionMemberList)
    self:pushModule(PVLegionExit)
    self:pushModule(PVLegionTransfer)
    self:pushModule(PVLegionKillOut)
    -- self:pushModule(PVLegionAnnouncement)

    --聊天相关
    self:pushModule(PVChatPanel)

    --社交(好友)相关
    self:pushModule(PVFriendPanel)
    self:pushModule(PVFriendApply)
    self:pushModule(PVFriendSecondMenu)
    self:pushModule(PVFriendPrivateChat)

    --创建战队名称
    -- self:pushModule(PVCreateTeam)

    self:pushModule(PVPeerless)

    --商城界面
    self:pushModule(PVShopPage)

    -----------------
    -- self:pushModule(PVShopPage)
    -- self:pushModule(PVChargePage)  --充值模块加入
    -- self:pushModule(PVVIPPage)     --vip特权模块加入
    -- self:pushModule(PVRCBUYPage)     --良将招募弹出框
    -- self:pushModule(PVRCBUYGODPage)     --神将招募弹出框
    -- self:pushModule(PVRCSHOWPage)     --获得将卡牌展示页
    -- self:pushModule(PVRChest1Page)     --抽取宝箱界面
    -- self:pushModule(PVRPropNumPage)    --输入购买道具的数量界面
    -----------------

    --竞技场
    self:pushModule(PVArenaPanel)
    self:pushModule(PVArenaCheckInfo)
    -- self:pushModule(PVArenaWarPanel)
    self:pushModule(PVTimeWorldBoss)
    self:pushModule(PVTimeBossWait)
    self:pushModule(PVBossRank)
    self:pushModule(import("src.app.ui.homepage.arena.PVBossReward"))
    self:pushModule(import("src.app.ui.homepage.arena.PVArenaShop"))

    -- 游历
    self:pushModule(PVTravelPanel)
    self:pushModule(PVTravelPlace)
    self:pushModule(PVTravelTraveling)

    --活跃度
    self:pushModule(PVActiveDegree)

    --风物志
    self:pushModule(PVTravelFengwuzhi)
    self:pushModule(PVTravelMeet)

    --符文相关
    self:pushModule(PVRunePanel)
    self:pushModule(PVSmeltPanel)
    self:pushModule(import("src.app.ui.homepage.rune.PVRuneBagCheck"))
    self:pushModule(PVRuneBagPanel)
    self:pushModule(PVRuneBuildPanel)
    self:pushModule(PVRuneChangeSoldier)

    -- 符文秘境相关
    self:pushModule(PVSecretPlacePanel)
    self:pushModule(PVSecretPlaceMyMineInfo)
    self:pushModule(PVSecretPlaceSeizeMineInfo)


     --传承
    self:pushModule(import("src.app.ui.homepage.inherit.PVInheritLTList"))
    self:pushModule(import("src.app.ui.homepage.inherit.PVInheritZBList"))
    self:pushModule(import("src.app.ui.homepage.inherit.PVInheritWSList"))
    self:pushModule(PVInheritView)

    self:pushModule(import(("src.app.ui.homepage.head.PVHeadView")))
    -- self:pushModule(import(("src.app.ui.homepage.head.PVHeadChange")))
    -- self:pushModule(import(("src.app.ui.homepage.head.PVHeadSet")))

    -- PVSecretPlaceShop  = import("...ui.homepage.secretplace.PVSecretPlaceShop")             --符文秘境商人
    self:pushModule(import("src.app.ui.homepage.secretplace.PVSecretPlaceShop"))
    self:pushModule(import("src.app.ui.lineup.PVLineUp"))


    self:pushModule(import("src.app.ui.homepage.soul.PVSmeltView"))
    self:pushModule(import("src.app.ui.bag.PVBag"))

    self:pushModule(import("src.app.ui.email.PVEmailView"))

    --排行相关
    self:pushModule(import("src.app.ui.homepage.rank.PVRankPanel"))

end

return HomePageModule

