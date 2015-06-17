-- 小伙伴雇佣弹窗界面
-- 每次显示10个，刷新可以显示下10个
local PVEmploySoldier = PVEmploySoldier or class("PVEmploySoldier", BaseUIView)


function PVEmploySoldier:ctor(id)
    self.super.ctor(self,id)

    self.heroTemp = getTemplateManager():getSoldierTemplate()
    self.languageTemp = getTemplateManager():getLanguageTemplate()

    print("PVEmploySoldier:ctor end")
end

function PVEmploySoldier:onMVCEnter()
   --初始化属性
    self:init()
    self:showAttributeView()
    --绑定事件
    self:initTouchListener()
    
    --加载本界面的ccbi
    self:loadCCBI("instance/ui_employ_soldier.ccbi", self.ccbiNode)

    --添加可购买的列表TableView
    self:addTableView()
end

--初始化属性
function PVEmploySoldier:init()

    self.ccbiNode = {}
    self.ccbiRootNode = {}

    self.listLayer = nil --tableView的背景
    self.tableView = nil --
    self.itemSize = nil

    local _list = getDataManager():getFriendData():getListData()
    -- print("-----------000--------")
    -- table.print(_list)
    -- print("----------11---------")

    self.allFriendList = _list.friends -- 好友列表 {{id,nickname,...},{}...}
    
    if self.allFriendList ~= nil then self.allNumber = table.nums(self.allFriendList) else self.allNumber = 0 end
    self.currListPos = self.allNumber
    self.showNumber = 10

    self:updataFriendListData()
end

-- 跟换显示下一列十个好友
function PVEmploySoldier:updataFriendListData()
    if self.allNumber == 0 then 
        -- getOtherModule():showToastView( Localize.query("instance.4") )
        getOtherModule():showAlertDialog(nil, Localize.query("instance.4"))

        return
    end
    self.friendList = {}
    if self.allNumber <= self.showNumber then 
        self.friendList = self.allFriendList
    else 
        local _leftNum = self.allNumber - self.currListPos
        if _leftNum <= self.showNumber then 
            for i=1, self.showNumber - _leftNum do
                table.insert(self.friendList, self.allFriendList[i])
            end
            for i=self.currListPos, self.allNumber do
                table.insert(self.friendList, 1, self.allFriendList[i])
            end
        else
            for i=self.currListPos, self.currListPos+self.showNumber do
                table.insert(self.friendList, self.allFriendList[i])
            end
        end
    end

end

--绑定事件
function PVEmploySoldier:initTouchListener()
    local function backMenuClick()
        print("menuClick Back")
        getAudioManager():playEffectButton2()
        self:onHideView()
    end

    local function refreshMenuClick()
        print("menuClick refresh")
        getAudioManager():playEffectButton2()
        self:updataFriendListData()
        self.tableView:reloadData()
    end

    local function onZhiyuanGuizeClick( ... )
        -- body
        --支援规则 id 3300060001
        getOtherModule():showAlertDialog(nil, self.languageTemp:getLanguageById(3300060001))
    end

    self.ccbiNode["UISelectWS"] = {}
    self.ccbiNode["UISelectWS"]["backMenuClick"] = backMenuClick
    self.ccbiNode["UISelectWS"]["refreshMenuClick"] = refreshMenuClick
    self.ccbiNode["UISelectWS"]["onZhiyuanGuizeClick"] = onZhiyuanGuizeClick

end

--添加tableView的雇佣玩家列表
function PVEmploySoldier:addTableView()

    self.ccbiRootNode = self.ccbiNode["UISelectWS"]
    self.listLayer = self.ccbiRootNode["listLayer"]

    --获取itemSize大小
    local tempTab = {}
    local proxy = cc.CCBProxy:create()
    CCBReaderLoad("instance/ui_employ_item.ccbi", proxy, tempTab)
    local node = tempTab["UIEmployItem"]["itemBg"]
    self.itemSize = cc.size(self.listLayer:getContentSize().width, node:getContentSize().height)

    --雇佣武将的列表
    local function numberOfCellsInTableView(table)
        if self.showNumber < self.allNumber then return self.showNumber
        else return self.allNumber end
    end

    local function cellSizeForTable(table, idx)

        return self.itemSize.height, self.itemSize.width
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()

            local function employMenuClick()
                print("雇佣好友：", cell.id)
                -- stepCallBack(G_GUIDE_20111)
                groupCallBack(GuideGroupKey.BTN_CLICK_ZHIYUAN)
                getDataManager():getStageData():setCurrFriend(cell.id)
                self:onHideView()
            end

            cell.emloyInfo = {}

            local proxy = cc.CCBProxy:create()
            cell.emloyInfo["UIEmployItem"] = {}
            cell.emloyInfo["UIEmployItem"]["employMenuClick"] = employMenuClick

            local node = CCBReaderLoad("instance/ui_employ_item.ccbi", proxy, cell.emloyInfo)

            cell.labelPlayer = cell.emloyInfo["UIEmployItem"]["playerName"]
            cell.labelFightNum =  cell.emloyInfo["UIEmployItem"]["powerValue"]
            cell.labelEmployMoney = cell.emloyInfo["UIEmployItem"]["employMoney"]
            cell.labelLife = cell.emloyInfo["UIEmployItem"]["lifeValue"]
            cell.labelAtk = cell.emloyInfo["UIEmployItem"]["attackValue"]
            cell.labelPhyDef = cell.emloyInfo["UIEmployItem"]["phyValue"]
            cell.labelMajDef = cell.emloyInfo["UIEmployItem"]["lastValue"]
            cell.iconMenu = cell.emloyInfo["UIEmployItem"]["iconMenu"]

            -- headIcon
            -- zhiyuanLevelNumLabelNode_1
            -- zhiyuanSkillNameLabel
            -- zhiyuanSkillDetailLabel
            -- sodierName
            -- soldierKindSp

            -- starSelect1_1  ~  starSelect6_1
            cell.headIcon = cell.emloyInfo["UIEmployItem"]["headIcon"]
            cell.zhiyuanLevelNumLabelNode_1 = cell.emloyInfo["UIEmployItem"]["zhiyuanLevelNumLabelNode_1"]
            cell.zhiyuanSkillNameLabel = cell.emloyInfo["UIEmployItem"]["zhiyuanSkillNameLabel"]
            cell.zhiyuanSkillDetailLabel = cell.emloyInfo["UIEmployItem"]["zhiyuanSkillDetailLabel"]
            cell.sodierName = cell.emloyInfo["UIEmployItem"]["sodierName"]
            cell.soldierKindSp = cell.emloyInfo["UIEmployItem"]["soldierKindSp"]

            cell.starSelect1_1 = cell.emloyInfo["UIEmployItem"]["starSelect1_1"]
            cell.starSelect2_1 = cell.emloyInfo["UIEmployItem"]["starSelect2_1"]
            cell.starSelect3_1 = cell.emloyInfo["UIEmployItem"]["starSelect3_1"]
            cell.starSelect4_1 = cell.emloyInfo["UIEmployItem"]["starSelect4_1"]
            cell.starSelect5_1 = cell.emloyInfo["UIEmployItem"]["starSelect5_1"]
            cell.starSelect6_1 = cell.emloyInfo["UIEmployItem"]["starSelect6_1"]
            print("测试=========")
            print(cell.starSelect1_1)
            cell.starTable_1 = {cell.starSelect1_1,cell.starSelect2_1,cell.starSelect3_1,cell.starSelect4_1,cell.starSelect5_1,cell.starSelect6_1}

            cell:addChild(node)
        end

        --设置支援武将信息
        local item = self.friendList[idx+1]
        local _name = item.nickname
        local _fightValue = item.power
        local _hp = item.hp
        local _atk = item.atk
        local _physic_def = item.physical_def
        local _magic_def = item.magic_def
        local hero_no = item.buddy_head
        -- local _icon = self.heroTemp:getSoldierIcon(item.hero_no)
        -- local _quality = self.heroTemp:getHeroQuality(item.hero_no)
        local _icon = self.heroTemp:getSoldierIcon(item.buddy_head)         --支援列表显示的好友阵容第一个武将头像
        local _quality = self.heroTemp:getHeroQuality(item.buddy_head)
        local _heroName = self.heroTemp:getHeroName(item.buddy_head)

        cell.id = item.id
        if _hp == 0 then _hp = 2000 end
        cell.labelPlayer:setString(_name)
        cell.labelFightNum:setString(string.format("%d", roundNumber(_fightValue) ))
        cell.labelLife:setString(string.format("%d", roundNumber(_hp) ))
        cell.labelAtk:setString(string.format("%d", roundNumber(_atk) ))
        cell.labelPhyDef:setString(string.format("%d", roundNumber(_physic_def) ))
        cell.labelMajDef:setString(string.format("%d", roundNumber(_magic_def) ))
        -- local img = game.newSprite()
        -- changeNewIconImage(img, _icon, _quality)
        -- cell.iconMenu:setNormalImage(img)

        self:changeWujiangIconImage(cell.headIcon, _icon, _quality)
        -- cell.zhiyuanLevelNumLabelNode_1   暂无，需要修改协议
        local soliderItem = self.heroTemp:getHeroTempLateById(hero_no)
        local rageSkill = soliderItem.rageSkill  
        local rageSkillItem = self.heroTemp:getSkillTempLateById(rageSkill)
        local rageName = rageSkillItem.name
        local rageDescribe = rageSkillItem.describe
        local nameLanguage = self.languageTemp:getLanguageById(rageName)

        local function setSkillAttri(str)
            local _describeLanguage = str
            for findStr in string.gmatch(str, "%$%d+:%w+%$") do  -- 模式匹配“$id:字段$”
            
                local repStr = nil
                for _var in string.gmatch(findStr, "%d+:%w+") do
                  
                    local _pos, _end = string.find(_var, ":")
                    local buffId = string.sub(_var, 1, _pos-1)
                    local key = string.sub(_var, _end+1)
                    print("^^^^^^^^^^^", buffId)
                    local buffItem = self.heroTemp:getSkillBuffTempLateById(tonumber(buffId))
                    -- table.print(buffItem)
                    local value = buffItem[key]
                    repStr = value
                   
                end
                _describeLanguage = string.gsub(_describeLanguage, "%$%d+:%w+%$", repStr, 1)
            end
            return _describeLanguage
        end

        local describeLanguage = self.languageTemp:getLanguageById(rageDescribe)
        describeLanguage = setSkillAttri(describeLanguage)
        
        cell.zhiyuanSkillNameLabel:setString("["..nameLanguage.."]")
        cell.zhiyuanSkillDetailLabel:setString(describeLanguage)
        cell.sodierName:setString(_heroName)
        cell.sodierName:setColor(getColorByQuality(_quality))
        local _type = self.heroTemp:getHeroTypeId(hero_no)
        setNewHeroTypeName(cell.soldierKindSp,_type)

        updateStarLV(cell.starTable_1, _quality)


        return cell
    end

    local layerSize = self.listLayer:getContentSize()
    self.tableView = cc.TableView:create(layerSize)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listLayer:addChild(self.tableView)

    self.tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    local scrBar = PVScrollBar:new()
    scrBar:init(self.tableView,1)
    scrBar:setPosition(cc.p(layerSize.width,layerSize.height/2))
    self.listLayer:addChild(scrBar,2)
    
    self.tableView:reloadData()

end

--新版头像但是不加品质框
function PVEmploySoldier:changeWujiangIconImage(sprite, res, quality)
    local heroSprite = cc.Sprite:create()
    heroSprite:setTexture("res/icon/hero_new/"..res)   -- 新版本路径
    heroSprite:setScale(0.9)
    sprite:removeAllChildren()
    sprite:addChild(heroSprite, 1)
    heroSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end




--@return
return PVEmploySoldier
