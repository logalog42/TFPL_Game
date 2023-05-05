multidimensions.register_dimension=function(name,def,self)

	local y = multidimensions.first_dimensions_appear_at
	for i,v in pairs(multidimensions.registered_dimensions) do
		if v.dim_y >= multidimensions.calculating_dimensions_from_min_y then
			y = y + v.dim_height
		end
	end

	def = def or				{}
	def.self = def.self or			{}

	def.dim_y = def.dim_y or			y
	def.dim_height = 2000

	def.bedrock_depth = 50
	def.dirt_start = def.dim_y +			(def.dirt_start or 501)
	def.dirt_depth =				(def.dirt_depth or 3)
	def.ground_limit = def.dim_y +		(def.ground_limit or 530)
	def.water_depth = def.water_depth or		8
	def.enable_water = def.enable_water == nil
	def.terrain_density = def.terrain_density or	0.4
	def.flatland = def.flatland		
	def.gravity = def.gravity or			1
	--def.sky = def.sky

	def.map = def.map or {}
	def.map.offset = def.map.offset or 0
	def.map.scale = def.map.scale or 1
	def.map.spread = def.map.spread or {x=100,y=18,z=100}
	def.map.seeddiff = def.map.seeddiff or 24
	def.map.octaves = def.map.octaves or 5
	def.map.persist = def.map.persist or 0.7
	def.map.lacunarity = def.map.lacunarity or 1
	def.map.flags = def.map.flags or "absvalue"

	def.self.stone = def.stone or "mcl_core:stone"
	def.self.dirt = def.dirt or "mcl_core:dirt"
	def.self.grass = def.grass or "mcl_core:dirt_with_grass"
	def.self.air = def.air or "air"
	def.self.water = def.water or "mcl_core:water_source"
	def.self.sand = def.sand or "mcl_core:sand"
	def.self.bedrock = def.bedrock or "multidimensions:bedrock"

	def.self.dim_start = def.dim_y
	def.self.dim_end = def.dim_y+def.dim_height
	def.self.dim_height = def.dim_height
	def.self.ground_limit = def.ground_limit
	def.self.dirt_start = def.dirt_start
	--def.stone_ores {}
	--def.dirt_ores {}
	--def.grass_ores {}
	--def.ground_ores {}
	--def.air_ores {}
	--def.water_ores {}
	--def.sand_ores {}
	--on_generate=function(data,id,cdata,area,x,y,z)


	for i,v in pairs(table.copy(def.self)) do
		def.self[i] = minetest.registered_items[v] and minetest.get_content_id(v) or def.self[i]
	end

	--Generator basics for each of the tables

	for i1,v1 in pairs(table.copy(def)) do
		if  i1:sub(-5,-1)== "_ores" then
			for i2,v2 in pairs(v1) do
				local n = minetest.get_content_id(i2)
				def[i1][n] = {}
				local t = type(v2)
				if t == "number" then
					def[i1][n] = {chance=v2}
				elseif t ~="table" then
					error("Multidimensions: ("..name..") ore "..i2.." defines as number (chance) or table, is: ".. t)
				else
					def[i1][n] = v2
					local ndef = def[i1][n]
					ndef.chance = ndef.chance or 1000
					if ndef.min_heat and not ndef.max_heat then
						ndef.max_heat = 1000
					elseif ndef.max_heat and not ndef.min_heat then
						ndef.min_heat = -1000
					end
				end
				def[i1][i2]=nil
			end
		end
	end

	def.teleporter = def.teleporter == nil

	local node = def.teleporter and table.copy(def.node or {})
	local craft = def.teleporter and def.craft and table.copy(def.craft) or nil

	def.node = nil
	def.craft = nil

	multidimensions.registered_dimensions[name]=def

	if def.teleporter then
		node.description = node.description or		"Teleport to dimension " .. name
		node.tiles = node.tiles or			{"default_steel_block.png"}
		node.groups = node.groups or		{cracky=2,not_in_creative_inventory=multidimensions.craftable_teleporters and 0 or 1}
		node.sounds = node.sounds or		mcl_sounds.node_sound_wood_defaults()
		node.after_place_node = function(pos, placer, itemstack)
			local meta=minetest.get_meta(pos)
			meta:set_string("owner",placer:get_player_name())
			meta:set_string("infotext",node.description)		
		end
		node.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			local owner=minetest.get_meta(pos):get_string("owner")
			local pos2={x=pos.x,y=def.dirt_start+def.dirt_depth+2,z=pos.z}
			if not minetest.is_protected(pos2, owner) then
				multidimensions.move(player,pos2)
			end
		end
		node.mesecons = {
			receptor = {state = "off"},
			effector={
				action_on=function(pos, node)
					local owner=minetest.get_meta(pos):get_string("owner")
					local pos2={x=pos.x,y=def.dirt_start+def.dirt_depth+2,z=pos.z}
					for i, ob in pairs(minetest.get_objects_inside_radius(pos, 5)) do
						multidimensions.move(ob,pos2)
					end
					return false
				end
			}
		}
		minetest.register_node("multidimensions:teleporter_" .. name, node)

		if multidimensions.craftable_teleporters and craft then
			minetest.register_craft({
				output = "multidimensions:teleporter_" .. name,
				recipe = craft,
			})
		end
	end
	if def.dim_y > 0 and def.dim_y < multidimensions.earth.above then
		multidimensions.earth.above = def.dim_y
	elseif def.dim_y < 0 and def.dim_y+def.dim_height > multidimensions.earth.under then
		multidimensions.earth.under = def.dim_y+def.dim_height
	end
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	for i,d in pairs(multidimensions.registered_dimensions) do
		if minp.y >= d.dim_y and maxp.y <= d.dim_y+d.dim_height then
			local depth = 18
			local height = d.dirt_start
			local water_depth = d.water_depth
			local ground_limit = d.ground_limit
			local lenth = maxp.x-minp.x+1
			local cindx = 1
			local map = minetest.get_perlin_map(d.map,{x=lenth,y=lenth,z=lenth}):get_3d_map_flat(minp)
			local enable_water = d.enable_water
			local terrain_density = d.terrain_density
			local flatland = d.flatland
			local heat = minetest.get_heat(minp)
			local humidity = minetest.get_humidity(minp)

			local miny = d.dim_y
			local maxy = d.dim_y+d.dim_height
			local bedrock_depth = d.bedrock_depth

			local sand = d.self.sand
			local c_stone =d.self.stone
			local air = d.self.air
			local c_water = d.self.water
			local bedrock = d.self.bedrock

			d.self.heat = heat
			d.self.humidity = humidity

			local vm,min,max = minetest.get_mapgen_object("voxelmanip")
			local area = VoxelArea:new({MinEdge = min, MaxEdge = max})
			local data = vm:get_data()

			mcl_mapgen_core.register_generator("block_fixes", block_fixes, nil, 9999, true)

			-- Set the 3D noise parameters for the terrain.

			local np_terrain = {
				offset = 0,
				scale = 1,
				spread = {x = 384, y = 192, z = 384},
				seed = 5900033,
				octaves = 5,
				persist = 0.63,
				lacunarity = 2.0,
				--flags = ""
			}

			-- Initialize noise object to nil. It will be created once only during the
			-- generation of the first mapchunk, to minimise memory use.

			local nobj_terrain = nil


			-- Localise noise buffer table outside the loop, to be re-used for all
			-- mapchunks, therefore minimising memory use.

			local nvals_terrain = {}


			-- Localise data buffer table outside the loop, to be re-used for all
			-- mapchunks, therefore minimising memory use.

			local data = {}

			-- Detect the biomegen mod if loaded, in order to generate biomes
			-- and decorations

			local use_biomegen = true

			-- On generated function.

			-- Start time of mapchunk generation.
			local t0 = os.clock()
			
			-- Noise stuff.

			-- Side length of mapchunk.
			local sidelen = maxp.x - minp.x + 1
			-- Required dimensions of the 3D noise perlin map.
			local permapdims3d = {x = sidelen, y = sidelen, z = sidelen}
			-- Create the perlin map noise object once only, during the generation of
			-- the first mapchunk when 'nobj_terrain' is 'nil'.
			nobj_terrain = nobj_terrain or
				minetest.get_perlin_map(np_terrain, permapdims3d)
			-- Create a flat array of noise values from the perlin map, with the
			-- minimum point being 'minp'.
			-- Set the buffer parameter to use and reuse 'nvals_terrain' for this.
			nobj_terrain:get_3d_map_flat(minp, nvals_terrain)

			-- Voxelmanip stuff.

			-- Load the voxelmanip with the result of engine mapgen. Since 'singlenode'
			-- mapgen is used this will be a mapchunk of air nodes.
			local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
			-- 'area' is used later to get the voxelmanip indexes for positions.
			local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
			-- Get the content ID data from the voxelmanip in the form of a flat array.
			-- Set the buffer parameter to use and reuse 'data' for this.
			vm:get_data(data)

			-- Generation loop.

			-- Noise index for the flat array of noise values.
			local ni = 1
			-- Process the content IDs in 'data'.
			-- The most useful order is a ZYX loop because:
			-- 1. This matches the order of the 3D noise flat array.
			-- 2. This allows a simple +1 incrementing of the voxelmanip index along x
			-- rows.
			for z = minp.z, maxp.z do
			for y = minp.y, maxp.y do
				-- Voxelmanip index for the flat array of content IDs.
				-- Initialise to first node in this x row.
				local vi = area:index(minp.x, y, z)
				for x = minp.x, maxp.x do
					-- Consider a 'solidness' value for each node,
					-- let's call it 'density', where
					-- density = density noise + density gradient.
					local density_noise = nvals_terrain[ni]
					-- Density gradient is a value that is 0 at water level (y = 1)
					-- and falls in value with increasing y. This is necessary to
					-- create a 'world surface' with only solid nodes deep underground
					-- and only air high above water level.
					-- Here '128' determines the typical maximum height of the terrain.
					local density_gradient = (height - y) / ground_limit
					-- Place solid nodes when 'density' > 0.
					if density_noise + density_gradient > 0  and y <= ground_limit then
						data[vi] = c_stone
					-- Otherwise if at or below water level place water.
					elseif y <= height and y >= (height - 100) then
						data[vi] = c_water
					end

					--todo need to create generation for sand

					-- Increment noise index.
					ni = ni + 1
					-- Increment voxelmanip index along x row.
					-- The voxelmanip index increases by 1 when
					-- moving by 1 node in the +x direction.
					vi = vi + 1
				end
			end
			end

			if use_biomegen then
				if maxp.y < (height - 100) then
					local undergroundmin = {x = minp.x, y = -48, z = minp.z}
					local undergroundmax = {x = minp.x, y = -31, z = minp.z}
					biomegen.generate_biomes(data, area, undergroundmin, undergroundmax)
				elseif maxp.y < (height - 80) then
					local deepoceanmin = {x = minp.x, y = -32, z = minp.z}
					local deepoceanmax = {x = minp.x, y = -11, z = minp.z}
					biomegen.generate_biomes(data, area, deepoceanmin, deepoceanmax)
				elseif maxp.y < (height + 1) then
					local oceanmin = {x = minp.x, y = -12, z = minp.z}
					local oceanmax = {x = minp.x, y = -1, z = minp.z}
					biomegen.generate_biomes(data, area, oceanmin, oceanmax)
				else
					-- Generate biomes in 'data', using biomegen mod
					local overworldmin = {x = minp.x, y = 1, z = minp.z}
					local overworldmax = {x = minp.x, y = 100, z = minp.z}
					biomegen.generate_biomes(data, area, overworldmin, overworldmax)
				end
				-- Write content ID data back to the voxelmanip.
				vm:set_data(data)
				-- Generate ores using core's function
				minetest.generate_ores(vm, minp, maxp)
				-- Generate decorations in VM (needs 'data' for reading)
				biomegen.place_all_decos(data, area, vm, minp, maxp, blockseed)
				-- Update data array to have ores/decorations
				vm:get_data(data)
				-- Add biome dust in VM (needs 'data' for reading)
				biomegen.dust_top_nodes(data, area, vm, minp, maxp)
			else
				-- If biomegen is not present, just write content ID data back to the VM.
				vm:set_data(data)
			end

			-- Calculate lighting for what has been created.
			vm:calc_lighting()
			-- Write what has been created to the world.
			vm:write_to_map()
			-- Liquid nodes were placed so set them flowing.
			vm:update_liquids()

			-- Print generation time of this mapchunk.
			local chugent = math.ceil((os.clock() - t0) * 1000)
			print ("[lvm_example] Mapchunk generation time " .. chugent .. " ms")
		end
	end
end)

minetest.register_alias("mcl_core:bedrock", "multidimensions:bedrock")

minetest.register_node("multidimensions:blocking", {
	description = "Blocking",
	drawtype="airlike",
	groups = {unbreakable=1,not_in_creative_inventory = 1,fall_damage_add_percent=1000},
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	pointable=false,
	diggable = false,
})

minetest.register_node("multidimensions:killing", {
	description = "Killing",
	drawtype="airlike",
	groups = {unbreakable=1,not_in_creative_inventory = 1},
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	walkable=false,
	damage_per_second = 9000,
	pointable=false,
	diggable = false,
})


if multidimensions.limited_chat then
minetest.register_on_chat_message(function(name, message)
	local msger = minetest.get_player_by_name(name)
	local pos1 = msger:get_pos()
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos2 = player:get_pos()
		if player:get_player_name()~=name and vector.distance(pos1,pos2)<multidimensions.max_distance_chatt then
			minetest.chat_send_player(player:get_player_name(), "<"..name.."> "..message)
		end
	end
	return true
end)
end


minetest.register_node("multidimensions:teleporter0", {
	description = "Teleport to dimension earth",
	tiles = {"default_steel_block.png","default_steel_block.png"},
	groups = {choppy=2,oddly_breakable_by_hand=1},
	is_ground_content = false,
	sounds = mcl_sounds.node_sound_wood_defaults(),
	after_place_node = function(pos, placer, itemstack)
		local meta=minetest.get_meta(pos)
		meta:set_string("owner",placer:get_player_name())
		meta:set_string("infotext","Teleport to dimension earth")
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local owner=minetest.get_meta(pos):get_string("owner")
		local pos2={x=pos.x,y=0,z=pos.z}
		if minetest.is_protected(pos2, owner)==false then
			multidimensions.move(player,pos2)
		end
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
		local owner=minetest.get_meta(pos):get_string("owner")
		local pos2={x=pos.x,y=0,z=pos.z}
		for i, ob in pairs(minetest.get_objects_inside_radius(pos, 5)) do
			multidimensions.move(ob,pos2)
		end
		return false
	end}},
})

if multidimensions.limeted_nametag==true and minetest.settings:get_bool("unlimited_player_transfer_distance")~=false then
	minetest.settings:set_bool("unlimited_player_transfer_distance",false)
	minetest.settings:set_bool("player_transfer_distance",multidimensions.max_distance)
	--minetest.settings:save()
elseif multidimensions.limeted_nametag==false and minetest.settings:get_bool("unlimited_player_transfer_distance")==false then
	minetest.settings:set_bool("unlimited_player_transfer_distance",true)
	minetest.settings:set_bool("player_transfer_distance",0)
end