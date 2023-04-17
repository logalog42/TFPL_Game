
local plants = {
	["multidimensions:tree"] = 1000,
	["multidimensions:pine_tree"] = 1000,
}

minetest.register_node("multidimensions:tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:pine_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})

multidimensions.register_dimension("earthlike1",{
	dirt_start = 1040,
	dirt_depth = 3,
	ground_limit = 1200,
	water_depth = 80,
	node={description="Alternative earth"},
	craft = {
		{"mcl_core:obsidianbrick", "mcl_core:iron_ingot", "mcl_core:obsidianbrick"},
		{"mcl_core:wood","","mcl_core:wood",},
		{"mcl_core:obsidianbrick", "mcl_core:iron_ingot", "mcl_core:obsidianbrick"},
	}
})

multidimensions.register_dimension("earthlike2",{
	ground_ores = table.copy(plants),
	stone_ores = none,
	sand_ores={["mcl_core:clay"]={chunk=2,chance=5000}},
	node={description="Alternative earth 2"},
	map={spread={x=20,y=18,z=20}},
	ground_limit=550,
	gravity=0.5,
	craft = {
		{"mcl_core:obsidianbrick", "mcl_core:iron_ingot", "mcl_core:obsidianbrick"},
		{"mcl_core:wood","mcl_core:iron_ingot","mcl_core:wood",},
		{"mcl_core:obsidianbrick", "mcl_core:iron_ingot", "mcl_core:obsidianbrick"},
	}
})

--[[minetest.register_lbm({
	name = "multidimensions:lbm",
	run_at_every_load = true,
	nodenames = {"group:multidimensions_tree"},
	action = function(pos, node)
		minetest.set_node(pos, {name = "air"})
		local tree=""
		if node.name=="multidimensions:tree" then
			mcl_core.generate_oak_tree(pos)
		elseif node.name=="multidimensions:pine_tree" then
			mcl_core.generate_spruce_tree(pos)
		end
	end,
})]]--