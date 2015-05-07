--HotUpdateHttp.lua 用于热更新HTTP请求信息

--lua http 请求管理管理类

-- 热更新地址
HTTP_SERVER_URL = HOST_SERVER..device.platform.."/"..CHANNEL_ID.."/index.json"

local HotUpdateHttp = HotUpdateHttp or class("HotUpdateHttp")

function HotUpdateHttp:ctor(controller)

    self.response = {}
    self.delegate = nil
    self.assetsManager = nil

end

function HotUpdateHttp:setDelegate(delegate)
    self.delegate = delegate
end

-- 发送中心
function HotUpdateHttp:sendCenter(params, isShowLoading)

    if self.delegate ~= nil and isShowLoading then
        self.delegate:onNetLoading()
    end
    self.httpRequest = cc.XMLHttpRequest:new()
    self.httpRequest.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON

    self.httpRequest:open(SEND_TYPE, params[2])

    local function onHttpResponse()
        print("Http Status Code:"..self.httpRequest.statusText)

        -- 回调函数
        -- callfunc(self.httpRequest.status, self.httpRequest.response)
        if self.delegate ~= nil and isShowLoading then
            self.delegate:onRemoveNetLoading()
        end

         params[1](self.httpRequest.status, self.httpRequest.response)
    end

    self.httpRequest:registerScriptHandler(onHttpResponse)
    self.httpRequest:send()
end

-- 获取更新列表
-- @param callfunc  回调函数
function HotUpdateHttp:sendGetUpdateList(callfunc)
    print(HTTP_SERVER_URL)
    self:sendCenter({callfunc, HTTP_SERVER_URL}, false)
end

-- 检查网络
function HotUpdateHttp:checkNetwork()

    local isAvailable = cc.CCNetwork:isLocalWiFiAvailable() or cc.CCNetwork:isInternetConnectionAvailable()

    return isAvailable
end



-- 下载更新
function HotUpdateHttp:downLoadFileList(downFileList, onError, onProgress, onSuccess)
    local downFile = downFileList[1]

    if not downFile then 
        onError()
        return
    end

    --拼接地址下载
    local url = HOST_SERVER..device.platform.."/"..CHANNEL_ID.."/"..downFile.address
    --url = 'http://192.168.1.100/transfer/android/'..downFile.address --test  zft 3.28需要删除当前行
    print("DownloadURL:"..url)
    local datapackPath =downFile.datapackpath
    --将文件的存储路径传递过去
    self.assetsManager = cc.AssetsManager:new(url,
                                            datapackPath,
                                           cc.FileUtils:getInstance():getWritablePath() .. "update/")
    local function success()
        onSuccess()
    end    
    self.assetsManager:retain()
    self.assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
    self.assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
    self.assetsManager:setDelegate(success, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
    self.assetsManager:setConnectionTimeout(HTTP_CONNECT_TIMEOUT)
    self.assetsManager:update()
end


--@return
return HotUpdateHttp
