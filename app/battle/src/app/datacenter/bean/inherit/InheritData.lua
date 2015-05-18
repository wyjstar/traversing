 --传承

local InheritData = class("InheritData")

function InheritData:ctor(id)

    self.InheritResponse = {}
    self.lt1 = {}
    self.lt2 = {}
    self.equId1 = {}
    self.equId2 = {}
    self.ws1 = {}
    self.ws2 = {}

end
-- if not self:handelCommonResResult(_fastFinish.res) then
--         return
--     end
function InheritData:setInheritResponse(data)
    
    self.InheritInitResponse = data
end

function InheritData:getInheritResponse()

    return self.InheritInitResponse
end

function InheritData:setlt1(lt1)
    self.lt1 = lt1
    print("+++++++++++++++")
    print(table.nums(self.lt1))
end
function InheritData:setlt2(lt2)

    self.lt2 = lt2
    print("+++++++++++++++")
    print(table.nums(self.lt2))
end

function InheritData:setequId1(equId1)
    self.equId1 = equId1
    print("+++++++++++++++")
    print(table.nums(self.equId1))
end
function InheritData:setequId2(equId2)

    self.equId2 = equId2
    print("+++++++++++++++")
    print(table.nums(self.equId2))
end
function InheritData:setws1(ws1)

    self.ws1 = ws1
    print("+++++++++++++++")
end
function InheritData:setws2(ws2)

    self.ws2 = ws2
    print("+++++++++++++++")
end
function InheritData:getInheritInit()

    return self.lt1, self.lt2,self.equId1, self.equId2, self.ws1, self.ws2
end


return InheritData

