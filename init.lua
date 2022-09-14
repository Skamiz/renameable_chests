local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- dofile(modpath .. "/other_file.lua")
local S = default.get_translator

local function get_hotbar_background(x, y)
	local f = ""
	for i = 0, 7 do
		f = f .."image[" .. x + i*1.25 .. "," .. y .. ";1,1;gui_hb_bg.png]"
	end
	return f
end

-- override
default.chest.get_chest_formspec = function(pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	local meta = minetest.get_meta(pos)
	local name = meta:get("name")

	local f = ""
			.. "formspec_version[6]"
			.. "size[10.75,11.75]"
			.. get_hotbar_background(0.5, 6.5)
			.. "field[0.5,0.5;2.25,0.5;chest_name;;" .. minetest.formspec_escape(name or "Chest") .. "]"
			.. "list[nodemeta:" .. spos .. ";main;0.5,1.25;8,4;]"
			.. "list[current_player;main;0.5,6.5;8,4]"
			.. "listring[]"
			.. "set_focus[save;true]"
			.. "button[-1,-1;0,0;save;]"
	return f
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.chest_name then
		local pn = player:get_player_name()
		local pos = default.chest.open_chests[pn].pos
		local meta = minetest.get_meta(pos)
		meta:set_string("name", fields.chest_name)

		local owner = meta:get("owner")
		if not owner then
			meta:set_string("infotext", fields.chest_name)
		else
			meta:set_string("infotext", fields.chest_name .. "\n" .. S("Locked Chest (owned by @1)", owner))
			-- meta:set_string("infotext", fields.chest_name .. "\n(owned by " .. owner .. ")")
		end

	end
end)
