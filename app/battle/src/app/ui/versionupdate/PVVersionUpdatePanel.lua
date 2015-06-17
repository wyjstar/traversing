--PVVersionUpdatePanel
local HotUpdateHttp = require("src.app.netcenter.HotUpdateHttp")

local g_HotUpdateHttp = g_HotUpdateHttp or HotUpdateHttp.new()

local PVVersionUpdatePanel = class("PVVersionUpdatePanel", function ()
    return cc.Node:create()
end)

-- 本地保存的版本信息
local updatePackAllSize = 0    --需要更新的包的总大小
local packInfo = nil
local skipDownload = nil

curversion = nil

local _filePackPath = FileUtilExc:getHLManagerWirtePath().."src/packageinfo.json"
local packagePath = cc.FileUtils:getInstance():fullPathForFilename("src/packageinfo.json")

local packIsExist = cc.FileUtils:getInstance():isFileExist(_filePackPath)
if  packIsExist then
    packagePath = _filePackPath
end
local f = io.open(packagePath, "r")
if f then
    packInfo = json.decode(f:read("*a"))
    f:close()
else
    local s = cc.FileUtils:getInstance():getStringFromFile("src/packageinfo.json")
    packInfo = json.decode(s)
end

DIFF_MAX = 3

skipDownload = (packInfo == nil or false)
if skipDownload then
    curversion = "1.0.0.0"
else
    curversion = packInfo.version --本地版本信息
end

print("PVVersionUpdatePanel:",curversion)

function PVVersionUpdatePanel:ctor(id)

    self.UILoading = {}
    self.response = {}
    self.downFileList = {}
    self:initView()
    self.updateFiles = {}--更新本地md5
    self.upConfigZip = false;
    -- self.c_LanguageTemplate = getTemplateManager():getLanguageTemplate()
    -- 获取更新列表
    -- 跳过热更新初始化网络数据
    -- self:initConnect()
    g_currentSceneStatus = menu_scene

    local function showAnimation()
        -- 获取更新列表
        self:getUpdateList()
    end 

    local action = cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(showAnimation))
    self:runAction(action)

    local layer = createBlockLayer()
    if layer then
        self:addChild(layer)
    end
end
function PVVersionUpdatePanel:initView()
    
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA4444)

    game.addSpriteFramesWithFile("res/ccb/resource/ui_loading.plist")
   
    local sharedDirector = cc.Director:getInstance()
    local glsize = sharedDirector:getWinSize()
    self.adapterLayer = cc.Layer:create()
    self.adapterLayer:setContentSize(cc.size(CONFIG_SCREEN_SIZE_WIDTH, CONFIG_SCREEN_SIZE_HEIGHT))
    self.adapterLayer:setPosition(cc.p(glsize.width / 2 - CONFIG_SCREEN_SIZE_WIDTH / 2, glsize.height / 2 - CONFIG_SCREEN_SIZE_HEIGHT / 2))

    self:addChild(self.adapterLayer)

    local proxy = cc.CCBProxy:create()
    local updateView = CCBReaderLoad("loading/ui_loading_panel.ccbi", proxy, self.UILoading)
    self.adapterLayer:addChild(updateView)

    self.preVersion = self.UILoading["UILoading"]["preVersion"]
    self.newVersion = self.UILoading["UILoading"]["newVersion"]
    self.progressNumber = self.UILoading["UILoading"]["progressNumber"]
    self.downloadNumber = self.UILoading["UILoading"]["downloadNumber"]
    self.useSpriteProgress = self.UILoading["UILoading"]["useSpriteProgress"]

    self.checkversionLayer = self.UILoading["UILoading"]["checkversionLayer"]
    self.checkversionLabel = self.UILoading["UILoading"]["checkversionLabel"]

    self.resloadLayer = self.UILoading["UILoading"]["resloadLayer"]
    self.resloadProgress = self.UILoading["UILoading"]["resloadProgress"]
    self.resloadProgressBG = self.UILoading["UILoading"]["resloadProgressBG"]
    self.resloadLabel = self.UILoading["UILoading"]["resloadLabel"]

    self.resupdateLayer = self.UILoading["UILoading"]["resupdateLayer"]

    self.resloadProgressBG:setVisible(false)
    self.resloadProgress = cc.ProgressTimer:create(self.resloadProgressBG)
    self.resloadProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)

    self.resloadProgress:setMidpoint(cc.p(0, 0))
    self.resloadProgress:setBarChangeRate(cc.p(1, 0))
    self.resloadProgress:setPosition(self.resloadProgressBG:getPosition())
    -- left:runAction(cc.ProgressTo:create(time, progress))
    self.resloadProgressBG:getParent():addChild(self.resloadProgress)

    self.useSpriteProgress:setVisible(false)
    self.useSpriteProgressTimer = cc.ProgressTimer:create(self.useSpriteProgress)
    self.useSpriteProgressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)

    self.useSpriteProgressTimer:setMidpoint(cc.p(0, 0))
    self.useSpriteProgressTimer:setBarChangeRate(cc.p(1, 0))
    self.useSpriteProgressTimer:setPosition(self.useSpriteProgress:getPosition())
    -- left:runAction(cc.ProgressTo:create(time, progress))
    self.useSpriteProgress:getParent():addChild(self.useSpriteProgressTimer)

    self.checkversionLayer:setVisible(false)
    self.resupdateLayer:setVisible(false)
    self.resloadLayer:setVisible(false)

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.PixelFormat.RGBA8888)
end

-- 获取更新列表
function PVVersionUpdatePanel:getUpdateList()
    -- 添加等待提示
    local _label = ui.newTTFLabel({text = NET_LOCALIZE["cn"]["checknet"], font = MINI_BLACK_FONT_NAME, size = 24, stroke = {color = cc.c4b(0, 0, 0, 255), size = 1}, })
    _label:setPosition(cc.p(320,150))
    self:addChild(_label)

    -- status 200 正常  其他获取错误
    local function httpResponse(status, response)
        _label:setVisible(false)
        if status == 200 then  -- 成功
            print("PVVersionUpdatePanel:getUpdateList:response==================="..response)
            if skipVersionUpdate() then
                print('PVVersionUpdatePanel.lua :skipVersionUpdate')
                -- 资源加载
                self:startLoadResource()
            else
                self:parseJson(response)
            end
            
        else
         -- 更新失败 给个提示框 是否继续更新 or 进入游戏
            self:updateListFail()
        end
    end

    g_HotUpdateHttp:sendGetUpdateList(httpResponse)
end

-- 解析更新列表
function PVVersionUpdatePanel:parseJson(response)

    self.response = json.decode(response)

    -- 更新公告url
    NOTICE_URL = self.response.notice_url

    -- 服务器列表
    SERVER_LIST = self.response.serverlist
    -- 检查版本
    self:checkversion()
end
--检查数值
function PVVersionUpdatePanel:checkDataVersion()
    print("PVVersionUpdatePanel:checkDataVersion")
    if packInfo.datacode ~= self.response.datacode then
        local addressTable = {}
        addressTable.address = self.response.datadir .. self.response.datapack
        addressTable.datapackpath = self.response.datapackpath
        table.insert(self.downFileList, addressTable)
        --数据包大小
        updatePackAllSize = self.response.datapacksize + updatePackAllSize + 5
        self.upConfigZip = true
        for k, v in pairs(self.response.dataversion) do
            --if packInfo.dataversion[k] ~= v["md5"] then
                self.updateFiles[k] = v["md5"]   
            --end
        end
    else
        for k, v in pairs(self.response.dataversion) do
            if packInfo.dataversion[k] ~= v["md5"] then
                local addressTable = {}
                addressTable.address = self.response.datadir .. v["md5"]
                addressTable.datapackpath = self.response.datapackpath
                table.insert(self.downFileList, addressTable)
                self.updateFiles[k] = v["md5"] 
                --数据包大小
                updatePackAllSize = self.response.datapacksize + v["filesize"]
                self.upConfigZip = true         
            end
        end
    end

    if table.nums(self.downFileList) == 0 then
        self:loadResource()
        return
    else
         --添加网络状态判断，如果不是wifi网络要提示 
        local isAvailable = cc.CCNetwork:isLocalWiFiAvailable() 
        if not isAvailable then
            print("当前网络不是wift")
            self:showNoWiftPanel()
        else--去检查磁盘大小 
            local sdFreeSize = accessDiffPlatform("getFreeSize") 
            local iosFreeSize = tonumber(sdFreeSize) * 1024 * 1024
            if iosFreeSize < updatePackAllSize then
                self:showNoMemory()
            else
               self:initDownLoadInfo()
               self:downLoadFileList()   
            end
        end                     
    end         
end

-- 检查版本
function PVVersionUpdatePanel:checkversion()
    if skipDownload then
        print("PVVersionUpdatePanel:checkVersion:skipDownload")
        self:loadResource()        
        return
    end
    self.downFileList = {}
    local curversionList =  string.split(curversion,".")
    local newversionList = string.split(self.response.version, ".")
    local f_cur_version = tonumber(curversionList[1]) or 1
    local f_new_version = tonumber(newversionList[1]) or 1
    local s_cur_version = tonumber(curversionList[2]) or 0
    local s_new_version = tonumber(newversionList[2]) or 0
    
    local t_cur_version = tonumber(curversionList[3]) or 0
    local t_new_version = tonumber(newversionList[3]) or 0

    local build_cur_version = tonumber(curversionList[4]) or 0
    local build_new_version = tonumber(newversionList[4]) or 0


    if curversion == self.response.version then -- 版本号没有更改，不需要更新，检查数值更新
        self:checkDataVersion()
        return
    elseif f_cur_version ~= f_new_version then--更新客户端                                                                                                                                                                                                                                                                                   then --端更新
        print(self.response.updateurl)
        return
    
    elseif build_cur_version < build_new_version then --增量包更新 只比较build_cur_version

        local buildDiff = build_new_version - build_cur_version --版本差距

        if buildDiff >= DIFF_MAX then --更新全量包
            local addressTable = {}
            addressTable.address = self.response.resdir .. self.response.restotalpack
            addressTable.datapackpath = ""
            table.insert(self.downFileList, addressTable)           
            updatePackAllSize = updatePackAllSize + self.response.respacksize 
        else
            local fileCount = #self.response.resdiffpack
            for num = buildDiff,1,-1 do
                local fileInfo = self.response.resdiffpack[fileCount-(buildDiff-num)]
                local diff_fileName = fileInfo.file

                local _addFileSize = fileInfo.filesize
                updatePackAllSize = updatePackAllSize + _addFileSize 


                print(diff_fileName)
                local address = self.response.resdir .. diff_fileName
                local addressTable = {}
                addressTable.address = address
                addressTable.datapackpath = ""
                table.insert(self.downFileList,1,addressTable) --每次都在第一个位置添加
            end
        end
    end
    
    self:checkDataVersion()
end

-- 初始化下载信息
function PVVersionUpdatePanel:initDownLoadInfo()
    self.preVersion:setString(curversion)
    self.newVersion:setString(self.response.version)
    self.progressNumber:setString("0%%")
    self.downloadNumber:setString("0/0")
    -- cc.UserDefault:getInstance():setStringForKey("UPDATE_RES_VERSION", self.response.newversion)
    -- cc.UserDefault:getInstance():flush()
end

-- 更新列表失败
function PVVersionUpdatePanel:updateListFail()
    print("-更新失败-")
    -- 资源加载
    self:startLoadResource()
end

-- 根据更新列表，下载对应的版本
function PVVersionUpdatePanel:downLoadFileList()
    self.checkversionLayer:setVisible(false)
    self.resupdateLayer:setVisible(true)

     local function onError(errorCode)
        print("errorCode" ..errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            print("no new version")
            self:updateListFail()
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            print("network error")
            self:updateListFail()
        elseif errorCode == cc.ASSETSMANAGER_NOZIPFILE then
            print("no zip file")
            self:updateListFail()
        elseif errorCode == cc.ASSETSMANAGER_UNCOMPRESS then
            print("uncompress  download zip error,please check version diff")
            self:updateListFail()
        end
    end

    local function onProgress( percent , nowDownNum, totalDownNum)
        -- local progress = string.format("lua downloading %d%%==%f＝＝%f",percent, nowDownNum, totalDownNum)
        -- print(progress)
        local timer = 0.1
        local isComplete = false
        self.progressNumber:setString(string.format("%d%%", percent))
    
        local _nowDownNum = tonumber(nowDownNum)/1024/1024
        local _totalDownNum = tonumber(totalDownNum)/1024/1024
        -- print(_totalDownNum.."_nowDownNum==".._nowDownNum)
        self.downloadNumber:setString(string.format("%.2fM/%.2fM", _nowDownNum, _totalDownNum))
        -- self.progressNumber:setString(percent)

        -- local function downloadProgressCallback()
        --     if isComplete then
        --         return
        --     end

        --     isComplete = true
        --     self:startLoadResource()
        -- end

        -- if percent == 100 then
        --     self.useSpriteProgressTimer:runAction(cc.Sequence:create(cc.ProgressTo:create(timer, percent), cc.CallFunc:create(downloadProgressCallback)))
        -- else
            self.useSpriteProgressTimer:runAction(cc.ProgressTo:create(timer, percent))
        -- end

    end

    local function onSuccess()
        print("2downloading ok")

        cc.UserDefault:getInstance():setIntegerForKey("new_notice", 0)
        cc.UserDefault:getInstance():flush()

        table.remove(self.downFileList, 1)
        if table.nums(self.downFileList) > 0 then
            self:downLoadFileList()
        else
            if self.upConfigZip then
                self:changeDataFileName()
            end
            self:saveNewPackageJson()
            self.useSpriteProgressTimer:stopAllActions()
            --cc.UserDefault:getInstance():setStringForKey("current_version", self.response.newversion)
            -- cc.UserDefault:getInstance():flush()
            -- local f = io.open(_versionPath,"w")
            -- f:write(self.response.newversion)
            -- f:close()
            
            function downloadProgressCallback()
                -- 资源加载
                self:startLoadResource()
            end

            self.useSpriteProgressTimer:runAction(cc.Sequence:create(cc.ProgressTo:create(0.1, 100), cc.CallFunc:create(downloadProgressCallback)))
            -- self.useSpriteProgressTimer:runAction(cc.Sequence:create(cc.ProgressTo:create(timer, 100)))
        end
        curversion = self.response.version
    end
    g_HotUpdateHttp:downLoadFileList(self.downFileList, onError, onProgress, onSuccess)

end

function PVVersionUpdatePanel:startLoadResource()
     local resLoadTimeTick = function ()
        timer.unscheduleGlobal(self.resLoadTimeTickScheduler)
        self:loadResource()
    end

    self.resLoadTimeTickScheduler = timer.scheduleGlobal(resLoadTimeTick, 1)
    
end

function PVVersionUpdatePanel:initConnect( ... )
    -- body
end

-- 资源加载
function PVVersionUpdatePanel:loadResource()

    local _ResourceData = require("src.app.datacenter.bean.resource.ResourceData")
    local resourceData = _ResourceData.new()
    
    self.checkversionLayer:setVisible(false)
    self.resupdateLayer:setVisible(false)
    self.resloadLayer:setVisible(true)

    self.resloadLabel:setString("资源加载 ......")
    self.resloadProgress:runAction(cc.ProgressTo:create(0, 0))

    local resLoadTimeTick = function ()
        local _progress = resourceData:loadResourceData()
        self:updateResLoadProgressBar(1, _progress)

        if _progress == 100 then
            timer.unscheduleGlobal(self.resLoadTimeTickScheduler)
        end
    end

    self.resLoadTimeTickScheduler = timer.scheduleGlobal(resLoadTimeTick, 0.3)

end

-- 平台登录
function PVVersionUpdatePanel:startPlatformLogin()
    g_PlatformLuaManager = require("src.app.platform.PlatformLuaManager")
    g_PlatformLuaManager.new("PlatformLuaManager")
end

-- 更新资源加载进度条
function PVVersionUpdatePanel:updateResLoadProgressBar(time, progress)
    function callfunc()
        --  资源加载完毕进入登录界面
        self:startPlatformLogin()

        -- if DEBUG == 1 then
        --     local _info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
        --     print(_info)
        -- end
    end
    
    -- self.resloadProgress:stopAllActions()

    if progress == 100 then
        self.resloadProgress:runAction(cc.Sequence:create(cc.ProgressTo:create(time, progress), cc.CallFunc:create(callfunc)))
        -- require("src.app.controller.GameController")
    else
        self.resloadProgress:runAction(cc.ProgressTo:create(time, progress))
    end
end

-- 初始化网络数据
function PVVersionUpdatePanel:initConnect()
    -- TODO 对网络进行监控
    
    require("src.app.controller.GameController")
    self.checkversionLayer:setVisible(false)
    self.resloadLayer:setVisible(true)

    self.resloadLabel:setString("初始化网络数据 ......")

    local function callfunc()
        -- 资源加载
        self:loadResource()
    end

    initConnectNet()

    self.resloadProgress:runAction(cc.Sequence:create(cc.ProgressTo:create(2, 100), cc.CallFunc:create(callfunc)))

end
--保存最新版本json
function PVVersionUpdatePanel:saveNewPackageJson()
        local _filename = FileUtilExc:getHLManagerWirtePath().."src/packageinfo.json"
        local _isExists = cc.FileUtils:getInstance():isFileExist(_filename)
        local openType = "w"
        if _isExists then  
            openType = "w+"
            print("PVVersionUpdatePanel:saveNewPackageJson W+:".._filename)
        else 
            FileUtilExc:createDirWithName("src")
            print("PVVersionUpdatePanel:saveNewPackageJson W:".._filename)
        end
        f = io.open(_filename, openType)
        if f then
            --组织保存最新的
            packInfo.version = self.response.version
            packInfo.datacode = self.response.datacode
            for k,v in pairs(self.updateFiles) do
               packInfo.dataversion[k] = v
            end
            f:write(json.encode(packInfo))
            f:close()
        else
            cclog("AERROR open packageJson:" .. _filename) 
        end
end
--没有wift联网提示框
function PVVersionUpdatePanel:showNoWiftPanel()
    self:initNoWitfPanelTouchListener()
    local proxy = cc.CCBProxy:create()
    local noWiftView = CCBReaderLoad("common/ui_common_tips.ccbi", proxy, self.ccbiNode)
    self.ccbiNode["UICommonTipsView"]["menu_close"]:setVisible(false)
    self.ccbiNode["UICommonTipsView"]["oneBtnLayer"]:setVisible(false)
    local tipText = NET_LOCALIZE[Localize.language][3300010008] --self.c_LanguageTemplate:getLanguageById(3300010008)
    self.ccbiNode["UICommonTipsView"]["detailLabel1"]:setString(tipText)
    self.noWiftView = noWiftView
    self:addChild(noWiftView)
end
--磁盘不足提示框
function PVVersionUpdatePanel:showNoMemory()
    local function menuClickOk()
        self.noMemoryView:removeFromParent()
        self.noMemoryView = nil
        self.ccbiNoMemoryNode = nil
        --退出游戏
        cc.Director:getInstance():endToLua()
    end
    self.ccbiNoMemoryNode = {}
    self.ccbiNoMemoryNode["UICommonTipsView"] = {}
    self.ccbiNoMemoryNode["UICommonTipsView"]["menuClickOk"] = menuClickOk
    self.ccbiNoMemoryNode["UICommonTipsView"]["onMenuOk"] = menuClickOk
    local proxy = cc.CCBProxy:create()
    local noMemoryView = CCBReaderLoad("common/ui_common_tips.ccbi", proxy, self.ccbiNoMemoryNode)
    self.ccbiNoMemoryNode["UICommonTipsView"]["menu_close"]:setVisible(false)
    self.ccbiNoMemoryNode["UICommonTipsView"]["twoBtnLayer"]:setVisible(false)
    local tipText = NET_LOCALIZE[Localize.language][3300010009] --self.c_LanguageTemplate:getLanguageById(3300010009)--3300010009
    self.ccbiNoMemoryNode["UICommonTipsView"]["detailLabel1"]:setString(tipText)
    self.noMemoryView = noMemoryView
    self:addChild(noMemoryView)
end
function PVVersionUpdatePanel:initNoWitfPanelTouchListener()
    local function onCloseClick()
        print("onCloseMenu")
        --退出游戏
        cc.Director:getInstance():endToLua()
    end
    local function onConfrimClick()
        self.noWiftView:removeFromParent()
        self.noWiftView = nil
        self.ccbiNode = nil
        local sdFreeSize = accessDiffPlatform("getFreeSize") 
        local iosFreeSize = tonumber(sdFreeSize) *1024 * 1024
        print("------------------"..iosFreeSize)
        if iosFreeSize < updatePackAllSize then
            print("#############存储空间不足############")
            self:showNoMemory()
        else
            self:initDownLoadInfo()
            self:downLoadFileList()   
        end
    end
    self.ccbiNode = {}
    self.ccbiNode["UICommonTipsView"] = {}
    self.ccbiNode["UICommonTipsView"]["onSureClick"] = onConfrimClick
    self.ccbiNode["UICommonTipsView"]["onCancleClick"] = onCloseClick
end
--根据md5值获取文件名字
function PVVersionUpdatePanel:getDataFileName(_md5)
    for k, v in pairs(self.response.dataversion) do
        if packInfo.dataversion[k] ~= v["md5"] then
            _md5 = v["md5"]
            return k   
        end
    end 
    return nil
end
function PVVersionUpdatePanel:changeDataFileName()
    print("PVVersionUpdatePanel: changeDataFileName start")
    for k,v in pairs(self.updateFiles) do
        local _oldfilename = FileUtilExc:getHLManagerWirtePath()..self.response.datapackpath..v
        local _newfilename = FileUtilExc:getHLManagerWirtePath()..self.response.datapackpath..k..'.luac'
        local _isExists = cc.FileUtils:getInstance():isFileExist(_oldfilename)     
        if _isExists then
            os.rename(_oldfilename, _newfilename)
            print('_oldfilename:'.._oldfilename.."   _newfilename:".._newfilename)
        end
    end
end
return PVVersionUpdatePanel
