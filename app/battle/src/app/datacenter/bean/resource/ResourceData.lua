local ResourceData = class("ResourceData")

MAIN_BG_MUSIC = "res/sound/main.mp3"
FIGHT_BG_MUSIC = "res/sound/fight.mp3"
BOSS_FIGHT_BG_MUSIC = "res/sound/boss_fight.mp3"

local num = math.random(1,2)
MAIN_BG_MUSIC = string.format("res/sound/main%d.mp3", num)

function ResourceData:ctor(id)

    self.status = 0
    self.progress = 0
end

function ResourceData:loadResourceData()
    if self.status == 0 then
        require("src.app.appinit") --加载lua文件
        self.status = 10
    elseif self.status == 10 then
         game.addSpriteFramesWithFile("res/ccb/resource/ui_common.plist")
        self.status = 20
    elseif self.status == 20 then
        game.addSpriteFramesWithFile("res/ccb/resource/ui_soldier.plist")
        game.addSpriteFramesWithFile("res/ccb/resource/ui_equip.plist")

        self.status = 30
    elseif self.status == 30 then
        game.addSpriteFramesWithFile("res/ccb/resource/ui_common1.plist")

        self.status = 40
    elseif self.status == 40 then

        self.status = 50
    elseif self.status == 50 then
       game.addSpriteFramesWithFile("res/ccb/resource/ui_lineup.plist")

         self.status = 60
    elseif self.status == 60 then

     self.status = 70
    elseif self.status == 70 then
            game.addSpriteFramesWithFile("res/ccb/resource/ui_common2.plist")

        self.status = 80
    elseif self.status == 80 then

        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
        game.addSpriteFramesWithFile("res/ccb/resource/ui_activity.plist")
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)

     self.status = 85
    elseif self.status == 85 then
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)
        game.addSpriteFramesWithFile("res/resource/resource_icon1.plist")
        cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)


        self.status = 90
    elseif self.status == 90 then
        -- game.addSpriteFramesWithFile("res/ccb/resource/ui_homepage.plist")
        game.addSpriteFramesWithFile("res/ccb/resource/bg_home2_0.plist")
        game.addSpriteFramesWithFile("res/ccb/resource/bg_home2_1.plist")
        game.addSpriteFramesWithFile("res/ccb/resource/ui_home2.plist")

        self.status = 100

        math.randomseed(os.time())
        local num = math.random(2)

        MAIN_BG_MUSIC = string.format("res/sound/main%d.mp3", num)


        AudioEngine.preloadMusic(MAIN_BG_MUSIC)

    end


    return self.status
end

--根据id加载英雄纹理
--res/card/hero_10044_all.plist")
function ResourceData:loadHeroImageDataById(imageName)

    local url = "res/card/" .. imageName .. ".plist"
    print("loadHeroImageDataById========" .. url)

    game.addSpriteFramesWithFile(url)
end

function ResourceData:removeHeroImageDataById(imageName)

    local url = "res/card/" .. imageName .. ".plist"
    print("removeSpriteFramesWithFile========" .. url)
    game.removeSpriteFramesWithFile(url)

end

function ResourceData:removeHeroImagePVRDataById(imageName)

    local url = "res/card/" .. imageName .. ".pvr.ccz"
    local _textureCacheInstance = cc.Director:getInstance():getTextureCache()
    _textureCacheInstance:removeTextureForKey(url)

end

function ResourceData:clearResourcePlistTexture()
    if self.res_sendTimeTickScheduler ~= nil then
        timer.unscheduleGlobal(self.res_sendTimeTickScheduler)
        self.res_sendTimeTickScheduler = nil
    end

    local __sendTimeTick = function ()
        cclog("--ResourceData:clearResourcePlistTexture---")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_loading.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_login.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_logo.plist")
        game.removeSpriteFramesWithFile("res/ccb/manhua/ui_kaitoumanhuan16.plist")
        game.removeSpriteFramesWithFile("res/ccb/manhua/ui_kaitoumanhuan79.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_bag.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_head.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_mail.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_friend.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_activeDegree.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_sacrifice.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_shop_1.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_inherit.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_lianti.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_travelT.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel2.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_travel.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_notice.plist")

         game.removeSpriteFramesWithFile("res/ccb/resource/ui_legion.plist")

         -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_secretTerritory.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_equip_effect.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_smelt.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/effect_zhujiu.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/elite_copy.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/friend_effect.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_arena.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_boss.plist")

        -- game.removeSpriteFramesWithFile("res/ccb/resource/ui_rune.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_shopVip.plist")
        game.removeSpriteFramesWithFile("res/ccb/resource/ui_shop.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_fight.plist")


        -- if DEBUG == 1 then
        --     local _info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
        --     print(_info)
        -- end


        cc.Director:getInstance():getTextureCache():removeUnusedTextures()

        if self.res_sendTimeTickScheduler ~= nil then
            timer.unscheduleGlobal(self.res_sendTimeTickScheduler)
            self.res_sendTimeTickScheduler = nil
        end

         -- print(collectgarbage("count"))
        -- collectgarbage("collect")
    end

    self.res_sendTimeTickScheduler = timer.scheduleGlobal(__sendTimeTick, 0.01)

end

function ResourceData:clearResourcePlistTexture2()
    if self.res_sendTimeTickScheduler2 ~= nil then
        timer.unscheduleGlobal(self.res_sendTimeTickScheduler2)
        self.res_sendTimeTickScheduler2 = nil
    end

    local __sendTimeTick = function ()
        cclog("--ResourceData:clearResourcePlistTexture---")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_activity.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_chat.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_equip.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_instance2.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_legion.plist")

        game.removeSpriteFramesWithFile("res/ccb/resource/ui_lineup.plist")

        -- if DEBUG == 1 then
        --     local _info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
        --     print(_info)
        -- end


        cc.Director:getInstance():getTextureCache():removeUnusedTextures()

        if self.res_sendTimeTickScheduler2 ~= nil then
            timer.unscheduleGlobal(self.res_sendTimeTickScheduler2)
            self.res_sendTimeTickScheduler2 = nil
        end

         -- print(collectgarbage("count"))
        -- collectgarbage("collect")
    end

    self.res_sendTimeTickScheduler2 = timer.scheduleGlobal(__sendTimeTick, 0.01)

end

return ResourceData
