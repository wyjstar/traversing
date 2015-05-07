
local PVRankPowerItem = class("PVRankPowerItem",function()
    return game.newNode()
end)

function PVRankPowerItem:ctor(curType,index, data)
    self:initView(curType, index, data)
end

--界面相关内容初始化
function PVRankPowerItem:initView(curType, index, data)
    game.addSpriteFramesWithFile("res/ccb/resource/ui_rank.plist")

    self.UITopRankItem = {}

    local proxy = cc.CCBProxy:create()
    local node = CCBReaderLoad("rank/ui_rank_powerItem.ccbi", proxy, self.UITopRankItem)

    local node1 = self.UITopRankItem["UITopRankItem"]["node1"]
    local powerNum = self.UITopRankItem["UITopRankItem"]["powerNum"]

    local node2 = self.UITopRankItem["UITopRankItem"]["node2"]
    local starNum = self.UITopRankItem["UITopRankItem"]["starNum"]
    local processLabel2 = self.UITopRankItem["UITopRankItem"]["processLabel2"]

    local headBg = self.UITopRankItem["UITopRankItem"]["headBg"]
    local headIcon = self.UITopRankItem["UITopRankItem"]["headIcon"]
    local rankBottomBg = self.UITopRankItem["UITopRankItem"]["rankBottomBg"]
    local rankNum = self.UITopRankItem["UITopRankItem"]["rankNum"]
    local nameLabel = self.UITopRankItem["UITopRankItem"]["nameLabel"]
    local heroLevel = self.UITopRankItem["UITopRankItem"]["heroLevel"]
    print("data.id ======== ", data.id)
    local resIcon = getTemplateManager():getSoldierTemplate():getSoldierHead(data.user_icon)
    print("resIcon ======== ", resIcon)
    headIcon:setTexture("res/icon/hero_head/"..resIcon)
    headIcon:setScale(0.7)

    nameLabel:setString(data.nickname)

    local levelNode = getLevelNode(data.level)
    heroLevel:addChild(levelNode)

    local headBgStr = "ui_common_rankhead" .. index .. ".png"
    headBg:setSpriteFrame(headBgStr)

    rankBottomBg:setSpriteFrame("ui_common_rankbot" .. index .. ".png")
    rankNum:setSpriteFrame("ui_common_rank_reward_" .. index .. ".png")

    if curType == 1 or curType == 3 then
        node1:setVisible(true)
        node2:setVisible(false)
        powerNum:setString(data.fight_power)
    elseif curType == 2 then
        node1:setVisible(false)
        node2:setVisible(true)
        starNum:setString(data.star_num)
        local _chapterNo, _stageNo = getTemplateManager():getInstanceTemplate():getIndexofStage(data.stage_id)
        processLabel2:setString(_chapterNo .. "-" .. _stageNo)
    end

    self:addChild(node)
end

return PVRankPowerItem
