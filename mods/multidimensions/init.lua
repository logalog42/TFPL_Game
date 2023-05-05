multidimensions={
	start_y=4000,
	max_distance=50, --(50 is 800)
	max_distance_chatt=800,
	limited_chat=true,
	limeted_nametag=true,
	remake_home=true,
	remake_bed=true,
	user={},
	player_pos={},
	earth = {
		above=1008,
		under=-996,
	},
	craftable_teleporters=true,
	registered_dimensions={},
	first_dimensions_appear_at = 1088,
	calculating_dimensions_from_min_y = 0,
	map={
		offset = 0.5,
		scale = 0.5,
		spread = {x = 210, y = 210, z = 210},
		seed = minetest.get_mapgen_setting("seed") + 99999,
		octaves = 4,
		persist = 0.85,
	},
}

for index, value in ipairs(minetest.registered_biomes) do
	minetest.log('default', index)
end


dofile(minetest.get_modpath("multidimensions") .. "/api.lua")
dofile(minetest.get_modpath("multidimensions") .. "/dimensions.lua")
dofile(minetest.get_modpath("multidimensions") .. "/tools.lua")