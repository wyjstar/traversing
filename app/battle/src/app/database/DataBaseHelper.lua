
-- local sqlite3 = require("lsqlite3")

-- local DataBaseHelper = class("DataBaseHelper")

-- function DataBaseHelper:ctor()

-- 	cclog("--DataBaseHelper:ctor----")
-- 	local _dbfile = cc.FileUtils:getInstance():getWritablePath()
-- 	_dbfile = _dbfile .. "config.db"

-- 	self.db = sqlite3.open(_dbfile)

-- 	-- for row in self.db:nrows("SELECT * FROM  language_config ") do
-- 	--     -- print(row.id, row.content)
-- 	--    -- local _language_text = json.decode(row.content)
-- 	--    print(row.cn)
-- 	-- end

-- 	-- for i=1,10 do
-- 	-- 	for row in self.db:nrows("SELECT * FROM  language_config ") do
-- 	--     -- print(row.id, row.content)
-- 	--    -- local _language_text = json.decode(row.content)
-- 	-- 	   print(row.cn)
-- 	-- 	   row = nil
-- 	-- 	end
-- 	-- end


-- 	-- local _sqlfile = cc.FileUtils:getInstance():fullPathForFilename("res/database/config.sql")
-- 	-- local _sql_content = io.readfile(_sqlfile)

-- 	-- -- 测试列子
-- 	-- local db = sqlite3.open_memory()

-- 	-- print(tostring(_sql_content))

-- 	-- db:exec(_sql_content)
-- 	-- db:exec([=[
-- 	-- 	CREATE TABLE Hello_hello_test5 (id INTEGER PRIMARY KEY, content);
-- 	-- 	INSERT INTO Hello_hello_test5 VALUES (NULL, "Hello World");
-- 	-- ]=])

-- 	-- for row in db:nrows("SELECT * FROM Hello_hello_test7") do
-- 	--     print(row.id, row.content)
-- 	-- end

-- 	-- db:close()
-- end

-- -- 查询数据库表
-- -- @param tableName 数据表名字
-- -- @param condition 条件
-- function  DataBaseHelper:queryTable(tableName, condition)
-- 	local _tableName = string.trim(tableName)
-- 	if tableName ~=nil and string.len(_tableName)<=0 then
-- 		cclog("没有此表")
-- 		return
-- 	end

-- 	local _sql = " SELECT * FROM "..tableName
-- 	if condition ~=nil and string.len(condition)>0 then
-- 		_sql = _sql .." where "..condition
-- 	end
	
-- 	cclog("sql:".._sql)
-- 	local _queryTable = nil

-- 	for row in self.db:nrows(_sql) do
-- 	    _queryTable = row
-- 	    row = nil
-- 	    break
-- 	end

-- 	return _queryTable
-- end

-- -- 获取数据数量
-- function DataBaseHelper:getTableCount(tableName)
-- 	local _tableName = string.trim(tableName)
-- 	if tableName ~=nil and string.len(_tableName)<=0 then
-- 		cclog("没有此表")
-- 		return
-- 	end

-- 	local _sql = " SELECT count(id) FROM "..tableName
-- 	if condition ~=nil and string.len(condition)>0 then
-- 		_sql = _sql .." where "..condition
-- 	end
	
-- 	cclog("sql:".._sql)

-- 	local _count = self.db:nrows(_sql)

-- 	return _count
-- end

-- return DataBaseHelper