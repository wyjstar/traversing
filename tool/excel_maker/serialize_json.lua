json = require("cjson")

function serialize (o)
  if type(o) == "number" then
    io.write(o)
  elseif type(o) == "string" then
    io.write(string.format("%q", o))
  elseif type(o) == "table" then
    io.write("{\n")
    for k,v in pairs(o) do
      io.write("  ["); serialize(k); io.write("] = ")
      serialize(v)
      io.write(",")
    end
    io.write("}\n")
  else
    error("cannot serialize a " .. type(o))
  end
end


function save_to_file(json_data, path, name)
	print ("start decode....", os.date(), name)
    local data = json.decode(json_data)
    print ("end decode....", os.date(), name)
	local finalDataTable = {}

	for k, v in pairs(data) do

		local id = nil

		if name == "hero_exp" or name == "equipment_strengthen_config" or name == "guild_config"
		or name == "hero_exp_config" or name == "player_exp_config"

		then
		id = v.level
		else
		id = v.id
		end
		finalDataTable[id] = v		
	end
	print("start write...", os.date(), name)
	local fw = io.open(path, "w")
	io.output(fw)
	io.write(name.."=")
	serialize(finalDataTable)
	fw:close()
	print("end write...", os.date(), name)
end

function save_to_file_prop(json_data, path, name)

    local data = json.decode(json_data)
	local fw = io.open(path, "w")
	io.output(fw)
	io.write(name.."=")
	serialize(data)
	fw:close()
end

