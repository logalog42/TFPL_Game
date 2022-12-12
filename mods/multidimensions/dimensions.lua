function table.removekey(table, key)
	local element = table[key]
	table[key] = nil
	return element
 end
local ores={
	["default:stone_with_coal"]=200,
	["default:stone_with_iron"]=400,
	["default:stone_with_copper"]=500,
	["default:stone_with_gold"]=2000,
	["default:stone_with_mese"]=10000,
	["default:stone_with_diamond"]=20000,
	["default:mese"]=40000,
	["default:gravel"]={chance=3000,chunk=2,}
}

local plants = {
	["flowers:mushroom_brown"] = 1000,
	["flowers:mushroom_red"] = 1000,
	["flowers:rose"] = 1000,
	["flowers:tulip"] = 1000,
	["flowers:dandelion_yellow"] = 1000,
	["flowers:geranium"] = 1000,
	["flowers:viola"] = 1000,
	["flowers:dandelion_white"] = 1000,
	["default:junglegrass"] = 2000,
	["default:papyrus"] = 2000,
	["default:grass_3"] = 10,

	["multidimensions:tree"] = 1000,
	["multidimensions:aspen_tree"] = 1000,
	["multidimensions:pine_tree"] = 1000,
}

minetest.register_node("multidimensions:tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:pine_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:pine_treesnow", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:jungle_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:aspen_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:acacia_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})

multidimensions.register_dimension("hub",{
	ground_ores = table.copy(plants),
	stone_ores = table.copy(ores),
	sand_ores={["default:clay"]={chunk=2,chance=5000}},
	grass_ores={
		["default:dirt_with_snow"]={chance=1,max_heat=20},
	},
	water_ores={
		["default:ice"]={chance=1,max_heat=20},
	},
	node={description="hub"},
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:wood","default:mese","default:wood",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})


multidimensions.register_dimension("floatandlike",{
	ground_ores = table.copy(plants),
	stone_ores = table.copy(ores),
	node={description="Alternative floatand"},
	ground_limit=550,
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:dirt","default:mese","default:dirt",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	},
	map={
		spread={x=30,y=30,z=30},
		octaves=3,
		persist=0.2,
		lacunarity=2,
		flags="eased",
	},
	terrain_density=0.2,
	enable_water=false,
	self={
		blocking="multidimensions:blocking",
		killing = "multidimensions:killing",
	},
	on_generate=function(self,data,id,area,x,y,z)
		if y <= self.dirt_start-70 then
			data[id] = self.killing
		elseif y <= self.dirt_start-100 then
			data[id] = self.blocking
		elseif y <= self.dirt_start+5 then
			data[id] = self.air
		else
			return
		end
		return data
	end,
	on_enter=function(player)
		local name = player.get_player_name(player)
		local privs = minetest.get_player_privs(name)
		--for i, v in pairs(privs) do minetest.log('none', tostring(i) .. " = " .. tostring(v)) end
		table.removekey(privs,'interact')		
		--for i, v in pairs(privs) do minetest.log('none', tostring(i) .. " = " .. tostring(v)) end
		minetest.set_player_privs(name, privs)
		minetest.notify_authentication_modified(name)
		minetest.auth_reload(name)
	end
})


minetest.register_lbm({
	name = "multidimensions:lbm",
	run_at_every_load = true,
	nodenames = {"group:multidimensions_tree"},
	action = function(pos, node)
		minetest.set_node(pos, {name = "air"})
		local tree=""
		if node.name=="multidimensions:tree" then
			tree=minetest.get_modpath("default") .. "/schematics/apple_tree.mts"
		elseif node.name=="multidimensions:pine_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/pine_tree.mts"
		elseif node.name=="multidimensions:pine_treesnow" then
			tree=minetest.get_modpath("default") .. "/schematics/snowy_pine_tree_from_sapling.mts"
		elseif node.name=="multidimensions:jungle_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/jungle_tree.mts"
		elseif node.name=="multidimensions:aspen_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/aspen_tree.mts"
		elseif node.name=="multidimensions:acacia_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/acacia_tree.mts"
		end
		minetest.place_schematic({x=pos.x,y=pos.y,z=pos.z}, tree, "random", {}, true)
	end,
})