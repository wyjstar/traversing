require("src.app.ui.homepage.arena.PVBossRankParticle")

local PVBossRank = class("PVBossRank", BaseUIView)


function PVBossRank:ctor(id)
    self.super.ctor(self, id)

end

function PVBossRank:onMVCEnter()
    --加载相关plist文件
    game.addSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")
    game.addSpriteFramesWithFile("res/ccb/resource/ui_friend.plist")
    self:registerDataBack()

    self.c_commonData = getDataManager():getCommonData()
    self.c_bossData = getDataManager():getBossData()
    self.c_arenaData = getDataManager():getArenaData()

    self.c_bossNet = getNetManager():getBossNet()

    self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()

    self:initData()
    self:initView()

end

--网络返回
function PVBossRank:registerDataBack()
    --查看返回
    local function getCheckCallBack()
        local data = self.c_arenaData:getArenaRankCheck()
        if data ~= nil then
            getModule(MODULE_NAME_HOMEPAGE):showUIViewAndInTop("PVArenaCheckInfo", self.curTeamName)
        end
    end
    self:registerMsg(BOSS_PLAYER_INFO, getCheckCallBack)
end

--相关数据初始化
function PVBossRank:initData()
    self.rankList = self.c_bossData:getHurtRankList()
    print("排行界面 ================= ")
    table.print(self.rankList)
    self.itemCount = table.getn(self.rankList)
end

--界面加载以及初始化
function PVBossRank:initView()
    self.UIBossRankView = {}
    self:initTouchListener()
    self:loadCCBI("boss/ui_boss_chart.ccbi", self.UIBossRankView)

    self.contentLayer = self.UIBossRankView["UIBossRankView"]["contentLayer"]

    self:initTable()
end

--界面监听事件
function PVBossRank:initTouchListener()
    --返回
    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    self.UIBossRankView["UIBossRankView"] = {}

    self.UIBossRankView["UIBossRankView"]["onCloseClick"] = onCloseClick                          --关闭
end

function PVBossRank:initTable()
    local layerSize = self.contentLayer:getContentSize()
    self.tableView = cc.TableView:create(cc.size(layerSize.width, layerSize.height))

    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()

    self.contentLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(function(table) return self:numberOfCellsInTableView(table) end, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:registerScriptHandler(function(table, cell) self:tableCellTouched(table, cell) end, cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(function(table, idx) return self:cellSizeForTable(table, idx) end, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(function(table, idx) return self:tableCellAtIndex(table, idx) end, cc.TABLECELL_SIZE_AT_INDEX)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.contentLayer:addChild(scrBar,2)
    
    self.tableView:reloadData()
end

function PVBossRank:tableCellTouched(table, cell)
end

function PVBossRank:cellSizeForTable(table, idx)
    return 180, 640
end

local ParticleTag = 10000

function PVBossRank:tableCellAtIndex(tabl, idx)
    local cell = tabl:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()

        --阵容查看
        local function onLineUpClick()
            print("当前点击的查看 ============ ", idx + 1)
            self.c_bossNet:sendGetTeamInfo(idx + 1)
            self.curTeamName = self.rankList[idx + 1].nickname
        end

        cell.UIBossRankItem = {}
        cell.UIBossRankItem["UIBossRankItem"] = {}

        -- cell.UIBossRankItem["UIBossRankItem"]["onItemClick"] = onLineUpClick

        local proxy = cc.CCBProxy:create()
        local boosRankItem = CCBReaderLoad("boss/ui_boss_item.ccbi", proxy, cell.UIBossRankItem)

        cell.rankicon = cell.UIBossRankItem["UIBossRankItem"]["rankicon"]                           --排名图片
        cell.bossIcon = cell.UIBossRankItem["UIBossRankItem"]["bossIcon"]                           --玩家头像
        cell.nameLabel = cell.UIBossRankItem["UIBossRankItem"]["nameLabel"]                         --玩家名称
        cell.groupLabel = cell.UIBossRankItem["UIBossRankItem"]["groupLabel"]                       --军团名称
        cell.burtNum = cell.UIBossRankItem["UIBossRankItem"]["burtNum"]                             --伤害血量
        cell.rankNumLabel = cell.UIBossRankItem["UIBossRankItem"]["rankNumLabel"]                   --排名显示

        cell.rankNode1 = cell.UIBossRankItem["UIBossRankItem"]["rankNode1"] 
        cell.rankNode2 = cell.UIBossRankItem["UIBossRankItem"]["rankNode2"] 
        
        cell.rankBg1 = cell.UIBossRankItem["UIBossRankItem"]["rankBg1"] 

        cell.heroLevel = cell.UIBossRankItem["UIBossRankItem"]["heroLevel"]
        cell.rank_num = cell.UIBossRankItem["UIBossRankItem"]["rank_num"]
        cell.rankLabel = cell.UIBossRankItem["UIBossRankItem"]["rankLabel"]
        cell.heroFrameIcon = cell.UIBossRankItem["UIBossRankItem"]["heroFrameIcon"]
        cell.topBar = cell.UIBossRankItem["UIBossRankItem"]["rewardItemType1Bar"]
        cell.rankItem1 = cell.UIBossRankItem["UIBossRankItem"]["rankItem1"]
        cell.rankItem2 = cell.UIBossRankItem["UIBossRankItem"]["rankItem2"]
        cell:addChild(boosRankItem)
    end

    cell:removeChildByTag(ParticleTag,true)

    if idx < 3 then

        local func = {UI_Jianglipaihangbiankuang_frist,UI_Jianglipaihangbiankuang_second,UI_Jianglipaihangbiankuang_third}
        local noder = func[idx+1]()
        cell:addChild(noder,40,ParticleTag)

        cell.rankNode1:setVisible(true)
        cell.rankNode2:setVisible(false)
        cell.rankItem1:setVisible(true)
        cell.rankItem2:setVisible(false)
        local res = {"#ui_boss_title_bg_gold.png","#ui_boss_title_bg_silver.png","#ui_boss_title_bg_copper.png"}
        local res2 = {"#ui_boss_hero_fr_gold.png","#ui_boss_hero_fr_silver.png","#ui_boss_hero_fr_copper.png"}
        local res3 = {"#ui_boss_linebar_gold.png","#ui_boss_linebar_silver.png","#ui_boss_linebar_copper.png"}
        game.setSpriteFrame(cell.rankBg1,res[idx+1])
        game.setSpriteFrame(cell.rank_num,"#ui_boss_rank_reward_"..(idx+1)..".png")
        game.setSpriteFrame(cell.heroFrameIcon,res2[idx+1])
        game.setSpriteFrame(cell.rankItem1,res3[idx+1])

    else
        cell.rankNode1:setVisible(false)
        cell.rankNode2:setVisible(true)
        cell.rankItem1:setVisible(false)
        cell.rankItem2:setVisible(true)
        cell.rankLabel:setString(string.format(Localize.query("boss.2"),getCNNum(idx+1)))
        game.setSpriteFrame(cell.heroFrameIcon,"#ui_boss_hero_fr_iron.png")
        -- game.setSpriteFrame(cell.topBar,"#ui_comNew_tan_bg.png")
    end


    local player = self.rankList[idx+1]

    local nickName = player.nickname
    local demageHp = player.demage_hp

    local player_head = player.now_head

    -- local heroId = player.first_hero_no

    local heroLevel = player.level

    cell.heroLevel:addChild(getLevelNode(heroLevel))

    cell.nameLabel:setString(nickName)
    -- local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(heroId)
    -- local quality = soldierTemplateItem.quality
    -- local resIcon = self.c_SoldierTemplate:getSoldierIcon(heroId)

    -- changeNewIconImage(cell.bossIcon, resIcon, quality)                                    --更新icon
    local headRes = getTemplateManager():getSoldierTemplate():getSoldierHead(player_head)
    setSpritePlayerHead(cell.bossIcon,headRes)
    cell.bossIcon:setScale(0.7)
    -- TODO:需要显示用户的武将阵容
    print("BEGIN：需要显示用户的武将阵容")
    for i = 1,6 do
        local heroi = cell.UIBossRankItem["UIBossRankItem"]["hero"..i]
        if heroi ~= nil then
            heroi:removeAllChildren()
            local hero = player.line_up_info.slot[i].hero
            if hero ~= nil and hero.hero_no ~= 0 then --无武将信息 对应的是HeroPB
                local localproxy = cc.CCBProxy:create()
                heroi.heroItem = {}
                heroi.heroItem["BOSSITEMHERO"] = {}

                local nodeA  =  CCBReaderLoad("boss/ui_boss_item_hero.ccbi", localproxy, heroi.heroItem) 
                heroi:addChild(nodeA)
                local soldierTemplateItem = self.c_SoldierTemplate:getHeroTempLateById(hero.hero_no)
                local quality = soldierTemplateItem.quality
                local resIcon = self.c_SoldierTemplate:getSoldierIcon(hero.hero_no)
                nodeA:setScale(0.6)
                changeNewIconImage(heroi.heroItem["BOSSITEMHERO"]["heroIcon"], resIcon, quality,false)
                heroi.heroItem["BOSSITEMHERO"]["HeroLevel"]:setString("Lv."..hero.level)
            end
        end
    end
    print("End：需要显示用户的武将阵容")
    cell.burtNum:setString(demageHp)

    return cell
end

function PVBossRank:numberOfCellsInTableView(table)
    -- return 10
    if self.itemCount > 10 then
        return 10
    else
        return self.itemCount 
    end
end

function PVBossRank:clearResource()
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")
    -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_friend.plist")
end

return PVBossRank
