
--lua层音效管理类

AudioManager = AudioManager or class("AudioManager")

EFFECT_BUTTON1 = "res/sound/effect/Button1.mp3"
EFFECT_BUTTON2 = "res/sound/effect/Button2.mp3"

EFFECT_PAGE = "res/sound/effect/Page.mp3"

function AudioManager:ctor(controller)
    self.soldierTemplate = getTemplateManager():getSoldierTemplate()
    self.resourceTemplate = getTemplateManager():getResourceTemplate()
end

-- 武将音效
function AudioManager:playHeroEffect(res)
    local isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)
    if isMusicEffect == true then
        local n = AudioEngine.getMusicVolume()
        print("-----------------")
        print(n)

        self:stopAllEffect()
        --AudioEngine.setMusicVolume(0.5)
        --AudioEngine.setEffectsVolume(1)

        local n = AudioEngine.getMusicVolume()
        print("-----------------")
        print(n)
           
        AudioEngine.playEffect(res)
    end
end

-- 主界面菜单音效
function AudioManager:playEffectButton1()
    local isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)
    if isMusicEffect == true then
        AudioEngine.playEffect(EFFECT_BUTTON1)
    end
end

-- 界面里面的按钮音效
function AudioManager:playEffectButton2()
    local isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)
    if isMusicEffect == true then
        self:stopAllEffect()
        AudioEngine.playEffect(EFFECT_BUTTON2)
    end
end

-- tab切换的按钮音效
function AudioManager:playEffectPage()
    local isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)
    if isMusicEffect == true then
        self:stopAllEffect()
        AudioEngine.playEffect(EFFECT_PAGE)
    end
    
end

-- skill buffer  effect
function AudioManager:playEffectSkillBuff(skillID)
	local sillbuff = getTemplateManager():getSoldierTemplate():getSkillBuffTempLateById(skillID)
	if sillbuff == nil then
		return
	end
	local _audioId = sillbuff.audioId
	local _audioFileName = getTemplateManager():getResourceTemplate():getPathNameById(_audioId)
	if _audioFileName == nil then
		return
	end
	_audioFileName = CONFIG_RES_SOUND_EFFECT_PAHT.._audioFileName

    local isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)
    if isMusicEffect == true then
        --AudioEngine.stopAllEffects()
        AudioEngine.playEffect(_audioFileName)
    end
	-- AudioEngine.playEffect(_audioFileName)
end

function AudioManager:playBgMusic(buffno)
    -- 音量大小调节
    AudioEngine.setMusicVolume(0.6)
    AudioEngine.setEffectsVolume(1)

    -- 背景音乐
    -- AudioEngine.playMusic(MAIN_BG_MUSIC, true)
    self.isMusic = cc.UserDefault:getInstance():getBoolForKey("isMusic", true)
    if self.isMusic then
        AudioEngine.playMusic(MAIN_BG_MUSIC, true)
    else
        cc.SimpleAudioEngine:getInstance():stopMusic(true)
    end
end

function AudioManager:playFightBgMusic(buffno)
    --  战斗背景音乐
    self.isMusic = cc.UserDefault:getInstance():getBoolForKey("isMusic", true)
    if self.isMusic then
        AudioEngine.playMusic(FIGHT_BG_MUSIC, true)
    else
        cc.SimpleAudioEngine:getInstance():stopMusic(true)
    end
end



--buffno
function AudioManager:playBufffAudio(buffno)

    --print("playBufffAudio=======buffno===" .. buffno)
    --print(self)
    local item = self.soldierTemplate:getSkillBuffTempLateById(buffno)
    local _audioId = item.audioId
    --print("_audioId====" .. _audioId)
    local _audioFileName = self.resourceTemplate:getPathNameById(_audioId)
    if _audioFileName == nil then
        return
    end
    _audioFileName = CONFIG_RES_SOUND_EFFECT_PAHT .. "fight/" .. _audioFileName
    --print("_audioFileName============" .. _audioFileName)
    print(_audioFileName)

    local isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)
    if isMusicEffect == true then
        --AudioEngine.stopAllEffects()
        AudioEngine.playEffect(_audioFileName)
    end


    -- AudioEngine.playEffect(_audioFileName)
end

-- 死亡音效
function AudioManager:playHeroDeadAudio(heroId)

    local _audioFilePath = self.soldierTemplate:getHeroDeadAudio(heroId)
    
    if _audioFilePath == nil then
        return
    end
    
    print("======AudioManager:playHeroDeadAudio======")
    print(_audioFilePath)

    local isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)
    if isMusicEffect == true then
        --AudioEngine.stopAllEffects()
        AudioEngine.playEffect(_audioFilePath)
    end

end

function AudioManager:playMonsterDeadAudio(no)

    local _audioFilePath = self.soldierTemplate:getMonsterDeadAudio(no)
    
    if _audioFilePath == nil then
        return
    end
    
    print("======AudioManager:playMonsterDeadAudio======")
    print(_audioFilePath)

    local isMusicEffect = cc.UserDefault:getInstance():getBoolForKey("isMusicEffect", true)
    if isMusicEffect == true then
        --AudioEngine.stopAllEffects()
        AudioEngine.playEffect(_audioFilePath)
    end

end

function AudioManager:stopAllEffect()
    AudioEngine:stopAllEffects()
end


return AudioManager
















