
mvc = mvc or {}

mvc.App = class("App")

function mvc.App:ctor(appName, packageRoot)
    self.packageRoot = packageRoot or "app"
end

function mvc.App:run()
end

function mvc.App:exit()
    cc.Director:getInstance():endToLua()
    os.exit()
end

function mvc.App:enterScene(sceneName, args, transitionType, time, more)
    local scenePackageName = self.packageRoot .. ".scenes." .. sceneName
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(args)

    game.replaceScene(scene, transitionType, time, more)
end

function mvc.App:onEnterBackground()
end

function mvc.App:onEnterForeground()
end
