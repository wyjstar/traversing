local TravelData = class("TravelData")

function TravelData:ctor(id)
    
    -- self.c_SoldierData = getDataManager():getSoldierData()
    -- self.c_SoldierTemplate = getTemplateManager():getSoldierTemplate()
    -- self.c_EquipmentData = getDataManager():getEquipmentData()

    -- self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self.TravelResponse = {}
    self.TravelInitResponse = {}
    self.BuyShoesResponse = {}
    self.TravelSettleResponse = {}
    self.EventStartResponse = {}
    self.NoWaitResponse = {}
    self.OpenChestResponse = {}
    self.AutoTravelResponse = {}
    self.SettleAutoResponse = {}
    self.FastFinishAutoResponse = {}

    self.travelFengWuZhiNewList = {}

    self.chaTag = 1

end

function TravelData:setTravelInitResponse(data)
    self.TravelInitResponse = data

    self:setStageID()  --设置关卡
    self:setStageIsOpen() -- 设置关卡是否开启

    self.chaTag = self:getNowTravelChaTag()
end

function TravelData:getTravelInitResponse()

    return self.TravelInitResponse
end

function TravelData:setTravelResponse(data)
    self.TravelResponse = data
end

function TravelData:getTravelResponse()
    
    return self.TravelResponse
end

function TravelData:setTravelResponseEvent(event_id)
  
  self.TravelResponse = event_id
end

function TravelData:setOpenChestResponse(data)
    self.OpenChestResponse = data
end

function TravelData:getOpenChestResponse()
    
    return self.OpenChestResponse
end

function TravelData:setBuyShoesResponse(data)
    self.BuyShoesResponse = data
end

function TravelData:getBuyShoesResponse()
    
    return self.BuyShoesResponse
end

function TravelData:setTravelSettleResponse(data)
    self.TravelSettleResponse = data
end

function TravelData:getTravelSettleResponse()
    
    return self.TravelSettleResponse
end

function TravelData:setWaitEventStartResponse(data)

    self.EventStartResponse = data
end

function TravelData:getWaitEventStartResponse()
    
    return self.EventStartResponse
end

function TravelData:setNoWaitResponse(data)
    self.NoWaitResponse = data
end

function TravelData:getNoWaitResponse()
    
    return self.NoWaitResponse
end

function TravelData:setAutoTravelResponse(data)
  
    self.AutoTravelResponse = data
end

function TravelData:getAutoTravelResponse()
    
    return self.AutoTravelResponse
end

function TravelData:setSettleAutoResponse(data)
  
    self.SettleAutoResponse = data
end

function TravelData:getSettleAutoResponse()
    
    return self.SettleAutoResponse
end

function TravelData:setFastFinishAutoResponse(data)
  
    self.FastFinishAutoResponse = data
end

function TravelData:getFastFinishAutoResponse()
    
    return self.FastFinishAutoResponse
end


function TravelData:setTravelChaTag(num)
    self.chaTag = num
end
function TravelData:getTravelChaTag()
    return self.chaTag
end

-- 添加今日购买鞋子的次数
function TravelData:addBuyShoesNum(num)
    self.TravelInitResponse.buy_shoe_times = self.TravelInitResponse.buy_shoe_times + num
end

function TravelData:getNowTravelChaTag()
    local chapters = self.TravelInitResponse.travel_item_chapter
    if chapters == nil then return 1 end

    self.chaTag = 1

    for k,v in pairs(chapters) do
        if v.stage_id > 0 then

            if v.isOpen == true then
              self.chaTag = k
            end
       end
    end
    return self.chaTag
end

-- 增加游历事件
function TravelData:addChapterTravel(travel, tag)

    local _stage_id = self.TravelInitResponse.travel_item_chapter[tag].stage_id
    local _chapters = self.TravelInitResponse.chapter


     if table.nums(_chapters) > 0 then
        for k,v in pairs(_chapters) do

            if _stage_id == v.stage_id then

                table.insert(v.travel, travel)
                break
            end
        end
    else
        _travelInitResponse.chapter = {}
        local  chapter = {}
        chapter.stage_id = _stage_id
        chapter.travel = {}
        table.insert(chapter.travel, travel)
        table.insert(_travelInitResponse.chapter, chapter)
    end

    -- local timeAutoList = self:addTableAutoTime(self.TravelInitResponse.stage_travel)
    -- if timeAutoList == nil then
    --   return
    -- else
    -- end


end

-- 删除游历事件
function TravelData:subChapterTravel(travel, tag)
  local _stage_id = self.TravelInitResponse.travel_item_chapter[tag].stage_id
    local _chapters = self.TravelInitResponse.chapter

    for k,v in pairs(_chapters) do

        if _stage_id == v.stage_id then

            for k1,v1 in pairs(v.travel) do
              if v1.event_id == travel.event_id then
                table.remove(v.travel, k1)
                break
              end
            end

            break
        end
    end
end



-- 根据鞋子类型增加鞋子数量
-- @param shoes_type 鞋子类型
-- @param num  鞋子数量
function TravelData:addShoes(shoes_type, num)
  local _shoes = self.TravelInitResponse.shoes

  if shoes_type == CAO_SHOES then
        _shoes.shoe1 = _shoes.shoe1 + num
    elseif shoes_type == BU_SHOES then
        _shoes.shoe2 = _shoes.shoe2 + num
    elseif shoes_type == PI_SHOES then
        _shoes.shoe3 = _shoes.shoe3 + num
    end
end
-- 添加游历已经游历次数
function TravelData:addUseNum()
  local _shoes = self.TravelInitResponse.shoes
  local caoxieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe1")       
  local buxieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe2")
  local pixieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe3")
  local x = _shoes.shoe1*caoxieTimes + _shoes.shoe2*buxieTimes + _shoes.shoe3*pixieTimes
  if x == _shoes.use_no then print ("游历次数已用完")
  else
    _shoes.use_no = _shoes.use_no + 1 
  end
  -- print("_shoes.use_type.................".._shoes.use_type)
  print("_shoes.use_type.................".._shoes.use_type)
  print("_shoes.use_no.................".._shoes.use_no)
  -- 
  if _shoes.use_type == 1 then   --标识鞋子为草鞋
    if _shoes.shoe1 > 0 then
      -- print("................".._shoes.use_no)
      if caoxieTimes == _shoes.use_no then _shoes.shoe1 = _shoes.shoe1 - 1  _shoes.use_no = 0 _shoes.use_type = 0 end 
    else
      _shoes.use_type = 0
    end
  end

  if _shoes.use_type == 2 then --标识鞋子为布鞋
    if _shoes.shoe2 > 0 then
      if buxieTimes == _shoes.use_no then _shoes.shoe2 = _shoes.shoe2 - 1  _shoes.use_no = 0 _shoes.use_type = 0 end 
    else
      _shoes.use_type = 0
    end
  end

  if _shoes.use_type == 3  then --标识鞋子为皮鞋
    if _shoes.shoe3 > 0 then
      if pixieTimes == _shoes.use_no then _shoes.shoe3 = _shoes.shoe3 - 1  _shoes.use_no = 0 _shoes.use_type = 0 end 
    else
      _shoes.use_type = 0
    end
  end

  if _shoes.use_type == 0 then --没有标识的鞋子
    if _shoes.shoe3 ~=0 then 
      _shoes.use_type = 3  --把已经开始消耗的鞋子标识为标志位
      if pixieTimes == _shoes.use_no then _shoes.shoe3 = _shoes.shoe3 - 1  _shoes.use_no = 0 end 
    end
    if _shoes.shoe3 == 0 and _shoes.shoe2 ~= 0 then
      _shoes.use_type = 2  --把已经开始消耗的鞋子标识为标志位
      if buxieTimes == _shoes.use_no then _shoes.shoe2 = _shoes.shoe2 - 1  _shoes.use_no = 0 end 
    end 
    if _shoes.shoe3 == 0 and _shoes.shoe2 == 0 and _shoes.shoe1 ~= 0 then 
      _shoes.use_type = 1  --把已经开始消耗的鞋子标识为标志位
      if caoxieTimes == _shoes.use_no then _shoes.shoe1 = _shoes.shoe1 - 1  _shoes.use_no = 0 end 
    end
  end
  print("-------- _shoes.use_type ------------".._shoes.use_type)

end


function TravelData:isWhichShoes()
  local _shoes = self.TravelInitResponse.shoes
  local caoxieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe1") --  一只草鞋代表的游历次数  
  local buxieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe2")  --  一只布鞋代表的游历次数
  local pixieTimes = getTemplateManager():getBaseTemplate():getCaoXieDeg("travelShoe3")  --  一只皮鞋代表的游历次数

  local x = _shoes.shoe1*caoxieTimes + _shoes.shoe2*buxieTimes + _shoes.shoe3*pixieTimes -- 假如是没有使用过的鞋子，可以游历的总次数
  if x == _shoes.use_no then    -- 游历次数全部用完
      print ("游历次数已用完")
      return 0   
  end
  print("标志位.................".._shoes.use_type)
  print("使用的游历次数.................".._shoes.use_no)
  -- 
  if _shoes.use_type == 1 then   --标识鞋子为草鞋

    if _shoes.shoe1 > 0 then
        if caoxieTimes == _shoes.use_no then   -- 如果标志的使用次数于标志位鞋子的代表游历次数相同，表示这双鞋子被消耗完了
            _shoes.shoe1 = _shoes.shoe1 - 1 
            _shoes.use_no = 0 
            _shoes.use_type = 0 -- 标识鞋子为空
        end 
    else  -- 标志位鞋子的个数为0
        _shoes.use_type = 0
    end
  end

  if _shoes.use_type == 2 then --标识鞋子为布鞋
    if _shoes.shoe2 > 0 then
      if buxieTimes == _shoes.use_no then _shoes.shoe2 = _shoes.shoe2 - 1  _shoes.use_no = 0 _shoes.use_type = 0 end 
    else
      _shoes.use_type = 0
    end
  end

  if _shoes.use_type == 3  then --标识鞋子为皮鞋
    if _shoes.shoe3 > 0 then
      if pixieTimes == _shoes.use_no then _shoes.shoe3 = _shoes.shoe3 - 1  _shoes.use_no = 0 _shoes.use_type = 0 end 
    else
      _shoes.use_type = 0
    end
  end

  if _shoes.use_no == 0 then _shoes.use_type = 0 end

  if _shoes.use_type == 0 then --没有标识的鞋子
    if _shoes.shoe3 ~=0 then 
        _shoes.use_type = 3  --把已经开始消耗的鞋子标识为标志位
        if pixieTimes == _shoes.use_no then 
            print("-------- 一双皮鞋消耗完 ----------------")
            _shoes.shoe3 = _shoes.shoe3 - 1
            if _shoes.shoe3 == 0 then _shoes.use_no = 0 end
        end 
    end
    if _shoes.shoe3 == 0 and _shoes.shoe2 ~= 0 then
      _shoes.use_type = 2  --把已经开始消耗的鞋子标识为标志位
      if buxieTimes == _shoes.use_no then 
        _shoes.shoe2 = _shoes.shoe2 - 1 
        print("-------- 一双布鞋消耗完 ----------------") 
        if _shoes.shoe2 == 0 then _shoes.use_no = 0 end 
      end 
    end 
    if _shoes.shoe3 == 0 and _shoes.shoe2 == 0 and _shoes.shoe1 ~= 0 then 
      _shoes.use_type = 1  --把已经开始消耗的鞋子标识为标志位
      if caoxieTimes == _shoes.use_no then 
        print("-------- 一双草鞋消耗完 ----------------")
        _shoes.shoe1 = _shoes.shoe1 - 1  if _shoes.shoe1 == 0 then _shoes.use_no = 0 end end 
    end
  end

  print("-------- _shoes.use_type ------------".._shoes.use_type)

  return _shoes.use_type

end


-- 根据掉落包更新鞋子数量
function TravelData:updateShoesNumsByShoesInfo()
   local _shoes_info = self.OpenChestResponse.drops.shoes_info
   local _shoes = self.TravelInitResponse.shoes

   for k,v in pairs(_shoes_info) do
        if v.shoes_type == CAO_SHOES then
            _shoes.shoe1 = _shoes.shoe1 + v.shoes_no
        elseif v.shoes_type == BU_SHOES then
            _shoes.shoe2 = _shoes.shoe2 + v.shoes_no
        elseif v.shoes_type == PI_SHOES then
            _shoes.shoe3 = _shoes.shoe3 + v.shoes_no
        end
   end
end

-- 宝箱领取时间
function TravelData:resetChesttime()

    self.TravelInitResponse.chest_time = getDataManager():getCommonData():getTime()

end

-- 根据关卡ID读取配置表设置是第几关卡
function TravelData:setStageID()
   local chapters = self.TravelInitResponse.travel_item_chapter
   if chapters == nil then return end

   for k,v in pairs(chapters) do
        -- print("=========="..v.stage_id)
        if v.stage_id > 0 then
            v.stage_num = self:getStageInfo(v.stage_id).chapter
       end
   end

   local function sort_chapter(chapter1, chapter2)
        
        return chapter1.stage_num < chapter2.stage_num
   end

   table.sort(self.TravelInitResponse.travel_item_chapter, sort_chapter)
end

-- 设置是否开启
function TravelData:setStageIsOpen()
   local chapters = self.TravelInitResponse.travel_item_chapter
   if chapters == nil then return end

   local curNum = 0
   for k,v in pairs(chapters) do
        if v.stage_id > 0 then

            v.isOpen = false

            if k == 1 then
              v.isOpen = true
              curNum = table.nums(v.travel_item)
            else
                -- curNum = table.nums(chapters[k-1].travel_item)

                -- v.isOpen = self:isOpenStage(curNum, v.stage_id)
                v.isOpen = self:getIsEqual(k-1)


                curNum = table.nums(v.travel_item)
            end

       end
   end

end

-- 判断风物质是否已经存在
function TravelData:setIsHaveFengWuZhi(id)
    local chapters = self.TravelInitResponse.travel_item_chapter
    if chapters == nil then return end
    local isHave = false

    local curNum = 0
    for k,v in pairs(chapters) do
        if v.stage_id > 0 then
            if v.travel_item ~= nil then
                for k1,v1 in pairs(v.travel_item) do
                  -- curNum = table.nums(v.travel_item)
                    if v1.id == id then
                        isHave = true
                    end
                end
            end
        end
    end
    -- print("++++++++++++++++++++++++++")
    -- print(isHave)
    return isHave
end

function TravelData:getIsEqual(tag)
    local _curNum = table.nums(self.TravelInitResponse.travel_item_chapter[tag].travel_item)
    local _totalNum = getDataManager():getTravelData():getTotalNumFengwuzhi(self.TravelInitResponse.travel_item_chapter[tag].stage_id)
    return _curNum >= _totalNum
end

-- 获取章节数据信息
-- @param stage_id 关卡ID
function TravelData:getStageInfo(stage_id)
    
    return getTemplateManager():getInstanceTemplate():getTemplateById(stage_id)
end

-- 判断关卡是否开启（根据获得上一个章节风物志数量）
-- @param num 上一个章节获得的风物志数量
-- @param stage_id 当前章节ID
function TravelData:isOpenStage(num, stage_id)

    local _num = self:getStageInfo(stage_id).condition

    return num == _num
end

-- 获取章节风物志总数量
-- @param stage_id 当前章节ID
function TravelData:getTotalNumFengwuzhi(stage_id)

    return self:getStageInfo(stage_id).sectionCount
end

-- 判断是否已经领过宝箱奖励
function TravelData:isHasGain()
    local _server_time = getDataManager():getCommonData():getData().server_time
    local _last_gaintime = self.TravelInitResponse.chest_time
    
    local _year = os.date("%Y", _server_time)
    local _month = os.date("%m", _server_time)
    local _day = os.date("%d", _server_time)

    local _year2 = os.date("%x", _last_gaintime)

     local _year2 = os.date("%Y", _last_gaintime)
    local _month2 = os.date("%m", _last_gaintime)
    local _day2 = os.date("%d", _last_gaintime)

    return _year==_year2 and _month==_month2 and _day==_day2
end


function TravelData:addTravelItem(stage_Id, travelItems)
    --print(">>>>>>>>>>>stage_id:"..stage_Id)
    --table.print(travelItems)
    local _travel_item_chapter = nil
    for k,v in pairs(self.TravelInitResponse.travel_item_chapter) do
        if stage_Id == v.stage_id then
          _travel_item_chapter = v
          break
        end
    end

    local itemId = travelItems[1].id
    local _travelInitResponse = getDataManager():getTravelData():getTravelInitResponse()
    local chapter = math.ceil(itemId/10000)-1
    local travel_item = _travelInitResponse.travel_item_chapter[chapter].travel_item
    local n = 0
    for i=1,table.nums(travel_item) do
      --print(">>"..travel_item[i].id.."     >>"..travel_item[i].num)
      if itemId ~= travel_item[i].id then 
        n = n+1 
      else 
        print("风物志，该风物志已经存在") 
        travel_item[i].num = travel_item[i].num+1
      end
    end
    if n == table.nums(travel_item) then 
      local travel_item = {}
      travel_item.num = travelItems[1].num
      travel_item.id = travelItems[1].id 
      travel_item.stage = stage_Id
      travel_item.type = getTemplateManager():getTravelTemplate():getItemTypeByDetailID(travel_item.id)

      
      local n = table.nums(self.travelFengWuZhiNewList)
      local m = true
      for k,v in pairs(self.travelFengWuZhiNewList) do
        if v.id == travel_item.id then
            m = false
        end
      end
      if m == true then 
          table.insert(self.travelFengWuZhiNewList, travel_item) 
      end
      
      -- 是否集齐一组新的风物志组
      local isY = self:getIsToGroup(travel_item.id)
      if isY == true then
        print("------------------------------------")
        print("------------------------------------")
        print("-------  收集新的风物志组 -------------")
        
        table.insert(_travel_item_chapter.travel_item, travel_item)
        local lineupData = getDataManager():getLineupData()
        lineupData:setTravelItemChapter(self.TravelInitResponse.travel_item_chapter)
        getDataManager():getCommonData().updateCombatPower()

        print("------------------------------------")
        print("------------------------------------")
        -- getDataManager():getCommonData().
        return
      end
      
      table.insert(_travel_item_chapter.travel_item, travel_item)
    end
end

function TravelData:removeFromNewFengWuZhi(_id)
  print("-----------removeFromNewFengWuZhi--------------".._id)
  for k,v in pairs(self.travelFengWuZhiNewList) do
    if v.id == _id then
      table.remove(self.travelFengWuZhiNewList, k)
    end
  end
end


function TravelData:isHaveRedPointFeng(stage_Id, _type)   -- 奇物  人物 生灵  风景
  print("-----------isHaveRedPointFeng--------------"..stage_Id.."----------".._type)
  for k,v in pairs(self.travelFengWuZhiNewList) do
      if v.stage == stage_Id and v.type == _type then
          return true
      end
  end
  return false  
end

function TravelData:isHaveRedPointZhi(_id)   
  print("-----------isHaveRedPointZhi--------------".._id)
  for k,v in pairs(self.travelFengWuZhiNewList) do
      if v.id == _id then
          return true
      end
  end
  return false  
end

-- 
function TravelData:getIsToGroup(itemId)
  -- print("------getIsToGroup---------  "..itemId)
    local groupId = getTemplateManager():getTravelTemplate():getItemGroupByDetailID(itemId)
    local list = getTemplateManager():getTravelTemplate():getGroupItems(groupId)
    local listNUm = table.nums(list)
    local num = 0
    for k,v in pairs(list) do
        -- print("------getIsToGroup---------  "..v)
        if v == itemId then
          -- print("------v == itemId---------  "..v)
        else
          -- print("------else---------  "..v)
          if self:setIsHaveFengWuZhi(v) == true then

            num = num + 1
            -- print("------num = num + 1---------  "..num)

          end
        end
    end
    -- print(num.. " ....... " ..listNUm .. " ....... ")
    -- print(self:setIsHaveFengWuZhi(itemId))

    if num == listNUm-1 and self:setIsHaveFengWuZhi(itemId)==false then
      -- local hp, atk, physicalDef, magicDef = getTemplateManager():getTravelTemplate():getAddByGroupId(groupId)
      -- local data
      -- data.hp = hp
      -- data.atk = atk
      -- data.physicalDef = physicalDef
      -- data.magicDef = magicDef
      return true--, data
    else
      return false--, nil
    end
end

--sprite:要替换的英雄
--dropID:掉落id
function TravelData:changeNewIconImage(sprite, dropID)   -- 暂时没用
    if dropID <=0 then
      sprite:setTexture("res/icon/resource/resource_1.png")
      return
    end

    local _resPath = ""
    local bgSprite = cc.Sprite:create()
    sprite:removeAllChildren()
    sprite:addChild(bgSprite, 1)


    local dropItem = getTemplateManager():getTravelTemplate():getItemByDetailID(dropID)
    local _type = dropItem.type
    local quality = dropItem.quality

    -- print(_type.."==dropItem.icon=="..dropItem.icon.."==dropID=="..dropID)

    local resIcon = getTemplateManager():getResourceTemplate():getResourceById(dropItem.icon)

    if _type == 1 then
      _resPath = "res/icon/item/"..resIcon
    elseif _type == 2 then
      _resPath = "res/icon/hero/"..resIcon
    elseif _type == 3 then
      _resPath = "res/icon/item/"..resIcon
    elseif _type == 4 then
      _resPath = "res/icon/item/"..resIcon
    end

    local _isExists = cc.FileUtils:getInstance():isFileExist(_resPath)

    -- cclog("_resPath==".._resPath)
    if not _isExists then
      
    end

    sprite:setTexture(_resPath)

    if quality == 1 or quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common_frameg.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common_framebu.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common_framep.png")
    end
    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

-- -sprite:要替换的
--dropID:掉落id
function TravelData:changeFengIconImage(sprite, dropID, isGray, isSmall)

    sprite:removeAllChildren()

    if dropID <=0 then
      local _icon = cc.Sprite:create()
      local bgSprite = cc.Sprite:create()
      _icon:setTag(100001)
      bgSprite:setTag(100002)
      _icon:setTexture("res/icon/resource/resource_1.png")
      game.setSpriteFrame(bgSprite, "#ui_common2_bg2_bai.png")
      sprite:addChild(_icon, 2)
      sprite:addChild(bgSprite, 1)
      _icon:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
      bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
      -- sprite:setScale(0.73)
      return
    end

    local _resPath = ""

    sprite:removeChildByTag(100001)
    sprite:removeChildByTag(100002)

    local _icon = cc.Sprite:create()
    local bgSprite = cc.Sprite:create()
    _icon:setTag(100001)
    bgSprite:setTag(100002)

    sprite:addChild(_icon, 2)
    sprite:addChild(bgSprite, 1)

    local dropItem = getTemplateManager():getTravelTemplate():getItemByDetailID(dropID)
    local _type = dropItem.type
    local quality = dropItem.quality

    local resIcon = getTemplateManager():getResourceTemplate():getResourceById(dropItem.icon)

    resIcon = string.gsub(resIcon, ".png", ".webp")

    if _type == 1 then
      _resPath = "res/fengwuzhi/"..resIcon
    elseif _type == 2 then
      _resPath = "res/fengwuzhi/"..resIcon
    elseif _type == 3 then
      _resPath = "res/fengwuzhi/"..resIcon
    elseif _type == 4 then
      _resPath = "res/fengwuzhi/"..resIcon
    end

    local _isExists = cc.FileUtils:getInstance():isFileExist(_resPath)
    if _isExists == false then
      _resPath = "res/fengwuzhi/item_80001.webp"
    end

    _icon:setScale(0.4)
    _icon:setTexture(_resPath)
    _icon:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2-5)
    if _type == 4 then  
      _icon:setScale(0.38)
      _icon:setPosition(sprite:getContentSize().width / 2 , sprite:getContentSize().height / 2)
    end
    
    --图标变暗
    local _travelInitResponse = getDataManager():getTravelData():getTravelInitResponse()
    local chapter = math.ceil(dropID/10000)-1
    local travel_item = _travelInitResponse.travel_item_chapter[chapter].travel_item
    local n = 0
    for i=1,table.nums(travel_item) do
      if dropID ~= travel_item[i].id then n = n+1 end
    end
    if n == table.nums(travel_item) and isGray then 
      SpriteGrayUtil:drawSpriteTextureGray(_icon)
      SpriteGrayUtil:drawSpriteTextureGray(bgSprite)
    end
  
    if quality == 1 then 
        game.setSpriteFrame(bgSprite, "#ui_common2_bg_bai.png")
    elseif quality == 2 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg_lv.png")
    elseif quality == 3 or quality == 4 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg_lan.png")
    elseif quality == 5 or quality == 6 then
        game.setSpriteFrame(bgSprite, "#ui_common2_bg_zi.png")
    end
    

    bgSprite:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
end

-- 设置风物志大图
function TravelData:setBigFengPng(sprite, dropID)
  local dropItem = getTemplateManager():getTravelTemplate():getItemByDetailID(dropID)
  local resIcon = getTemplateManager():getResourceTemplate():getResourceById(dropItem.icon)
  resIcon = string.gsub(resIcon, ".png", ".webp")

  -- local _type = dropItem.type

  local _resPath = "res/fengwuzhi/"..resIcon


  local _isExists = cc.FileUtils:getInstance():isFileExist(_resPath)

  -- cclog("_resPath==".._resPath)
  if _isExists == false then
    _resPath = "res/fengwuzhi/item_80001.webp"

  end

  local dropItem = getTemplateManager():getTravelTemplate():getItemByDetailID(dropID)
  local _type = dropItem.type
  if _type == 4 then
      print("_________4")
      sprite:setScale(0.6)
  elseif _type == 3 then
    print("_________3")
      sprite:setScale(0.8)
  elseif _type == 2 then
    print("_________2")
      sprite:setScale(0.9)
    -- sprite:setPosition(_sprite:getContentSize().width / 2 , _sprite:getContentSize().height / 2)
  end

  sprite:setTexture(_resPath)
end


function TravelData:getIsInto(auto_travel)
  -- local auto_travel = auto_travel
    -- local startTime = auto_travel.start_time
    local alreadyTimes = auto_travel.already_times    -- 已经领取的事件个数
    local continuedTime = auto_travel.continued_time  -- 自动游历持续时间

    --还没有完成游历事件
    if alreadyTimes ~= getTemplateManager():getBaseTemplate():getAutoTimeTimes(tostring(continuedTime)) then
        -- print("还没有完成游历事件")
        return 1  
    end
    
    local num = table.nums(auto_travel.travel)
    -- if num == 0 then 
    --     print("完成了游历事件，并且奖励领取成功，没有遗留的等待事件")
    --     return 3    --完成了游历事件，并且奖励领取成功，没有遗留的等待事件 
    -- end

    --完成了游历事件
    for i=1,num do
        -- print(i)
        local id = auto_travel.travel[i].event_id
        local state = auto_travel.travel[i].state
        local eventType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(id)
        if eventType ~= 1 and state == 0 then --如果有未领取的事件的类型不是等待事件， state == 0表示没有领取    则说明有未领取，需要进入游历中界面将其领取
            -- print("完成了游历事件，有没有领取的奖励")
            return 2  --完成了游历事件，有没有领取的奖励
        end
    end
    -- int n = 0
    -- for k,v in pairs(auto_travel.travel) do
    --   local id = auto_travel.travel[i].event_id
    --   local state = auto_travel.travel[i].state
    --   local eventType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(id)
    --   if state == 0 
    --   if eventType ~= 1 then n = n+1 end
    -- end
    -- if n == num then return 


    -- print("完成了游历事件，并且奖励领取成功，有遗留的等待事件")
    return 4   --完成了游历事件，并且奖励领取成功，有遗留的等待事件
end

--返回自动游历类型
-- 1 还没有完成游历事件
-- 2 完成了游历事件，有没有领取的奖励
function TravelData:getIsIntoTraveling(stage_travel, tag)
    -- print("---------------目前游历状态----------------")
---------------
    local _travelInit = getDataManager():getTravelData():getTravelInitResponse()
    if _travelInit.travel_item_chapter[tag] == nil then
      return 0
    end

    local tag = _travelInit.travel_item_chapter[tag].stage_id 

    -- local timelist = {}

    local auto_travel = nil
    -- stage_travel = self.TravelInitResponse.stage_travel
    for k,v in pairs(stage_travel) do
        if v.stage_id == tag then
            -- table.print(v.auto_travel)
            auto_travel = v.auto_travel
        end
    end

    -- print("---------------目前自动游历选择第几个----------------")
    if auto_travel == nil or auto_travel[1] == nil then 
        -- print("空的,没有 zidong游历事件") 
        return 0 
        -- return timelist  
    end
-----------------


    -- if stage_travel[tag] == nil or stage_travel[tag].auto_travel == nil then 
    --     -- print("空的,没有 zidong游历事件") 
    --     return 0   
    -- end
    local a = auto_travel--stage_travel[tag].auto_travel--[1]
    local num = table.nums(a)
    local x = 0
    -- print("=========================  个数："..num)

    for i = 1,num do
      -- print(i)
      local b = auto_travel[i]--stage_travel[tag].auto_travel[i]
      -- print("-------------------")
      -- table.print(b)
      -- print("-------------------")
      local s = self:getIsInto(b)
      if s == 1 or s == 2 then 
        x = s  
        -- print("返回"..x)
        return x
      end
    end
    -- print("返回0")
    return 0
end
--返回自动游历等待事件列表
function TravelData:addTableAutoTime(stage_travel, tag)
  ---------------
    local _travelInit = getDataManager():getTravelData():getTravelInitResponse()
    local tag = _travelInit.travel_item_chapter[tag].stage_id 

    local timelist = {}

    local auto_travel = nil
    stage_travel = self.TravelInitResponse.stage_travel
    for k,v in pairs(stage_travel) do
        if v.stage_id == tag then
            -- table.print(v.auto_travel)
            auto_travel = v.auto_travel
        end
    end

    -- print("---------------目前自动游历选择第几个----------------")
    if auto_travel == nil or auto_travel[1] == nil then 
        -- print("空的,没有 zidong游历事件") 
        -- return 0 
        return timelist  
    end
  -----------------
  -- stage_travel = self.TravelInitResponse.stage_travel
  -- local timelist = {}
  -- if stage_travel[tag] == nil or stage_travel[tag].auto_travel == nil then 
  --   -- print("空的,没有 zidong游历事件") 
  --   return timelist
  -- end
  
  local num = table.nums(auto_travel)--stage_travel[tag].auto_travel)
  -- print("=========================  个数："..num)

  for i = 1,num do

    -- print("-------------------")
    -- table.print(stage_travel[1].auto_travel[i])
    -- print("-------------------")
    if self:getIsInto(auto_travel[i]) == 4 then 
      for k,v in pairs(auto_travel[i].travel) do
        local eventType = getTemplateManager():getTravelTemplate():getEventTypeByEventID(v.event_id)
        if eventType == 1 and v.state == 0 then
          local traavel = {
              event_id = v.event_id,
              start_time = auto_travel[i].start_time,
              time = v.time,
              drops = v.drops,
              isauto = true
              }
          table.insert(timelist, traavel)
        end
      end
    end

  end
  if timelist ~= nil then 
    -- print(">>>>>>>>>>>>>>>>>等待时间的事件列表：：：：：：：")
    -- table.print(timelist)
  end

  return timelist

end

--返回否false不进入自动游历，进入桃花林页面;返回true,进入自动游历
function TravelData:getIsIntoTravelingNum(stage_travel, tag)

    ---------------
    local _travelInit = getDataManager():getTravelData():getTravelInitResponse()
    local tag = _travelInit.travel_item_chapter[tag].stage_id 

    local auto_travel = nil
    for k,v in pairs(stage_travel) do
        if v.stage_id == tag then
            -- table.print(v.auto_travel)
            auto_travel = v.auto_travel
        end
    end

    -- print("---------------目前自动游历选择第几个----------------")
    if auto_travel == nil or auto_travel[1] == nil then 
        -- print("空的,没有 zidong游历事件") 
        return 0   
    end
   -----------------


    local a = auto_travel  --stage_travel[tag].auto_travel--[1]
    local num = table.nums(a)
    
    -- print("=========================  个数："..num)

    for i = 1,num do
      -- print(i)
      local b = auto_travel[i]   --stage_travel[tag].auto_travel[i]
      -- print("-------------------")
      -- table.print(b)
      -- print("-------------------")
      local s = self:getIsInto(b)
      if s == 1 or s == 2 then 
        return i
      end
    end
    return 0
end

--获取所有风物志no
function TravelData:getItemNos()
    local item_nos = {}
    for _, chapter in pairs(self.TravelInitResponse) do
        for _, item in pairs(chapter) do
            if item.num > 0 then
                table.insert(item.id)
            end
        end
    end
    return item_nos
end

function TravelData:setDropSp(drops, sp)

    local _resourceTemp = getTemplateManager():getResourceTemplate()
    local c_TravelTemplate = getTemplateManager():getTravelTemplate()

    local meetNum = 0
    local detailName = "银两"
    local isNew = false
    if drops.type == "finance" then
        if drops.coin ~= nil and drops.coin > 0 then
            meetNum = drops.coin
            detailName = "银两"
            setItemImage2(sp, "res/icon/resource/resource_1.png", 1)
        end

        if drops.hero_soul ~= nil and drops.hero_soul>0 then 
            
            meetNum = drops.hero_soul
            detailName = "武魂"
            setItemImage2(sp, "res/icon/resource/resource_3.png", 1)
        end

        if drops.finance_changes ~= nil then
            for k,v in pairs(drops.finance_changes) do
                meetNum = v.item_num
                local _icon = _resourceTemp:getResourceById(v.item_no)
                setItemImage2(sp, "res/icon/resource/".._icon, 1)
                detailName = _resourceTemp:getResourceName(v.item_no)
            end
        end
    end

    if drops.type == "travel_item" then
        meetNum = drops[1].num
        detailName = c_TravelTemplate:getFentWuzhiByAwardId(drops[1].id)
        self:changeFengIconImage(sp, drops[1].id)

        if self:setIsHaveFengWuZhi(drops[1].id) then
            isNew = false
        else
            isNew = true
        end
    end
    return meetNum , detailName , isNew
end


return TravelData

