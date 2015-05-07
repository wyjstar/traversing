-- 
local PVHeadSet = class("PVHeadSet", BaseUIView)

function PVHeadSet:ctor(id)
    PVHeadSet.super.ctor(self, id)
end

function PVHeadSet:onMVCEnter()
    print("++++++++++++++++++++++++++++++++++++++++")

    -- self.c_BaseTemplate = getTemplateManager():getBaseTemplate()

    self:initData()
 	self.ccbiNode = {}
  
	self:initTouchListener()

    self:loadCCBI("head/ui_head_set.ccbi", self.ccbiNode)
  
    self:initView()
    -- self:updateData()
end

function PVHeadSet:initData()

    self.isPhysicalStrengthNotify = cc.UserDefault:getInstance():getBoolForKey("isPhysicalStrengthNotify", true)
    self.isPhysicalStrengthIsFull = cc.UserDefault:getInstance():getBoolForKey("isPhysicalStrengthIsFull", true)
    self.isRuntFullNotify = cc.UserDefault:getInstance():getBoolForKey("isRuntFullNotify", true)
    self.isRuntPointFight = cc.UserDefault:getInstance():getBoolForKey("isRuntPointFight", true)
    self.isWineTimesReplace = cc.UserDefault:getInstance():getBoolForKey("isWineTimesReplace", true)
    self.isBossOpen = cc.UserDefault:getInstance():getBoolForKey("isBossOpen", true)
    self.isEquipShopRefresh = cc.UserDefault:getInstance():getBoolForKey("isEquipShopRefresh", true)
    self.isMusic = cc.UserDefault:getInstance():getBoolForKey("isMusic", true)
    self.isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)

    print("---self.isPhysicalStrengthNotify----")
    print(self.isPhysicalStrengthNotify)

    self.setTabel = {}
    table.insert(self.setTabel, {str = "isPhysicalStrengthNotify", value = self.isPhysicalStrengthNotify} )
    table.insert(self.setTabel, {str = "isPhysicalStrengthIsFull", value = self.isPhysicalStrengthIsFull} )
    table.insert(self.setTabel, {str = "isRuntFullNotify", value = self.isRuntFullNotify} )
    table.insert(self.setTabel, {str = "isRuntPointFight", value = self.isRuntPointFight} )
    table.insert(self.setTabel, {str = "isWineTimesReplace", value = self.isWineTimesReplace} ) 
    table.insert(self.setTabel, {str = "isBossOpen", value = self.isBossOpen} )
    table.insert(self.setTabel, {str = "isEquipShopRefresh", value = self.isEquipShopRefresh} )
    table.insert(self.setTabel, {str = "isMusic", value = self.isMusic} )
    table.insert(self.setTabel, {str = "isMusicEffect", value = self.isMusicEffect} )
end

function PVHeadSet:initTouchListener()

    local function onCloseClick()
        getAudioManager():playEffectButton2()
        self:onHideView()
    end
    local function onSelectClick1()
        getAudioManager():playEffectButton2()
        self:updateUI(1)
    end
    local function onSelectClick2()
        getAudioManager():playEffectButton2()
        self:updateUI(2)
    end
    local function onSelectClick3()
        getAudioManager():playEffectButton2()
        self:updateUI(3)
    end
    local function onSelectClick4()
        getAudioManager():playEffectButton2()
        self:updateUI(4)
    end
    local function onSelectClick5()
        getAudioManager():playEffectButton2()
        self:updateUI(5)
    end
    local function onSelectClick6()
        getAudioManager():playEffectButton2()
        self:updateUI(6)
    end
    local function onSelectClick7()
        getAudioManager():playEffectButton2()
        self:updateUI(7)
    end
    local function onSelectClick8()
        getAudioManager():playEffectButton2()
        self:updateUI(8)
    end
    local function onSelectClick9()
        getAudioManager():playEffectButton2()
        self:updateUI(9)
    end

    self.ccbiNode["UIHeadSet"] = {}
    self.ccbiNode["UIHeadSet"]["onCloseClick"] = onCloseClick
    self.ccbiNode["UIHeadSet"]["onSelectClick1"] = onSelectClick1
    self.ccbiNode["UIHeadSet"]["onSelectClick2"] = onSelectClick2
    self.ccbiNode["UIHeadSet"]["onSelectClick3"] = onSelectClick3
    self.ccbiNode["UIHeadSet"]["onSelectClick4"] = onSelectClick4
    self.ccbiNode["UIHeadSet"]["onSelectClick5"] = onSelectClick5
    self.ccbiNode["UIHeadSet"]["onSelectClick6"] = onSelectClick6
    self.ccbiNode["UIHeadSet"]["onSelectClick7"] = onSelectClick7
    self.ccbiNode["UIHeadSet"]["onSelectClick8"] = onSelectClick8
    self.ccbiNode["UIHeadSet"]["onSelectClick9"] = onSelectClick9
end


function PVHeadSet:initView()

    self.subSpTable = {}
    for i=1,9 do
        local strSp = "starSprite"..tostring(i)
        local sp = self.ccbiNode["UIHeadSet"][strSp]    --对号  
        table.insert(self.subSpTable, sp)
    end

    self.subMenuTable = {}
    for i=1,9 do
        local strMenu = "selectMenuItem"..tostring(i)
        local menu = self.ccbiNode["UIHeadSet"][strMenu]  --对号底图   
        table.insert(self.subMenuTable, menu)
    end

    for i=1,9 do
        if self.setTabel[i].value == true then 
            self.subSpTable[i]:setVisible(true) 
        else 
            self.subSpTable[i]:setVisible(false) 
        end
    end
end

function PVHeadSet:updateUI(idx)

    -- self.isPhysicalStrengthNotify

    if self.setTabel[idx].value == true then 
        self.subSpTable[idx]:setVisible(false)

        cc.UserDefault:getInstance():setBoolForKey(self.setTabel[idx].str, false)
        self.setTabel[idx].value = false
        if idx == 8 then 
            print("关闭音乐")
            cc.SimpleAudioEngine:getInstance():stopMusic(true)
    
        end
        if idx == 9 then 
            print("关闭音效")
            cc.SimpleAudioEngine:getInstance():stopAllEffects()
        end

    else 
        self.subSpTable[idx]:setVisible(true)
        cc.UserDefault:getInstance():setBoolForKey(self.setTabel[idx].str, true)
        self.setTabel[idx].value = true
        if idx == 8 then 
            print("打开音乐")
            AudioEngine.playMusic(MAIN_BG_MUSIC, true)
        end
        if idx == 9 then 
            print("打开音乐")
            -- cc.SimpleAudioEngine:getInstance():stopAllEffects()
        end
    end

end

-- AudioEngine.playMusic(MAIN_BG_MUSIC, true)



return PVHeadSet
