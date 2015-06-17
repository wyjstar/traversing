local PVCorpsUpgrade = class("PVCorpsUpgrade", BaseUIView)

function PVCorpsUpgrade:ctor(id)
    PVCorpsUpgrade.super.ctor(self, id)
end

function PVCorpsUpgrade:onMVCEnter()
    self:registerNetCallback()
    self:initData()
    self:initView()
end

function PVCorpsUpgrade:initView()
    self.UIGoUpView = {}
    -- self:initTouchListener()
    self:loadCCBI("instance/ui_goup_view.ccbi", self.UIGoUpView)


    self.goupSp = self.UIGoUpView["UIGoUpView"]["goupSp"]   
    self.soldierGoupSp = self.UIGoUpView["UIGoUpView"]["soldierGoupSp"]   
    self.equipGoupSp = self.UIGoUpView["UIGoUpView"]["equipGoupSp"]   

end

function PVCorpsUpgrade:registerNetCallback()

    local function callBack(id, data)
        if data.res.result then
            self.dropData = data.drops
            self.awardInfo.dragon_gift = 1
            self:startRunEffect()
        end
    end

    -- self:registerMsg(INST_STAR_RAFFLES_FULL, callBack)
end


function PVCorpsUpgrade:initData()
    --self.data = self.funcTable[1]
    self.chapperIndex = self.funcTable[1]
    self.isFullStar = self.funcTable[2]

end


return PVCorpsUpgrade

















