from lupa import LuaRuntime
lua = LuaRuntime()
lua.require("app/battle/src/test_main")
#reload_func = lua.eval('''function() reload_lua_config(); end''')
#reload_func()
#print("lua runtime")
