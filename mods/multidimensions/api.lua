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
	def.dim_height = def.dim_height or		1000
	def.deep_y = def.deep_y or		200

	def.bedrock_depth = 50
	def.dirt_start = def.dim_y + (def.dirt_start or 501)
	def.dirt_depth = (def.dirt_depth or 3)
	def.ground_limit = def.dim_y + (def.ground_limit or 530)
	def.water_depth = def.water_depth or 8
	def.enable_water = def.enable_water == nil
	def.terrain_density = def.terrain_density or 0.4
	def.flatland = def.flatland
	def.gravity = def.gravity or			1
	def.cave_threshold = def.cave_threshold or 0.1 --CBN 22/10/2022 Added cave threshold to dimension definition.
	--def.sky = def.sky

	def.ridges = def.ridges or {}
	def.ridges.offset = def.ridges.offset or 0
	def.ridges.scale = def.ridges.scale or 5
	def.ridges.spread = def.ridges.spread or {x=40,y=40,z=40}
	def.ridges.seeddiff = def.ridges.seeddiff or 24
	def.ridges.octaves = def.ridges.octaves or 6
	def.ridges.persist = def.ridges.persist or 1
	def.ridges.lacunarity = def.ridges.lacunarity or 1.6
	def.ridges.flags = def.ridges.flags or ""

	def.erosion = def.erosion or {}
	def.erosion.offset = def.erosion.offset or 0
	def.erosion.scale = def.erosion.scale or 1
	def.erosion.spread = def.erosion.spread or {x=100,y=18,z=100}
	def.erosion.seeddiff = def.erosion.seeddiff or 24
	def.erosion.octaves = def.erosion.octaves or 5
	def.erosion.persist = def.erosion.persist or 0.7
	def.erosion.lacunarity = def.erosion.lacunarity or 1
	def.erosion.flags = def.erosion.flags or "absvalue"

	def.landmass = def.landmass or {}
	def.landmass.offset = def.landmass.offset or 30
	def.landmass.scale = def.landmass.scale or 80
	def.landmass.spread = def.landmass.spread or {x=100,y=90,z=100}
	def.landmass.seeddiff = def.landmass.seeddiff or 24
	def.landmass.octaves = def.landmass.octaves or 5
	def.landmass.persist = def.landmass.persist or 0.7
	def.landmass.lacunarity = def.landmass.lacunarity or 1
	def.landmass.flags = def.landmass.flags or ""

	--Basic multidimensions generate settings
	def.map = def.map or {}
	def.map.offset = def.map.offset or 0
	def.map.scale = def.map.scale or 1
	def.map.spread = def.map.spread or {x=100,y=18,z=100}
	def.map.seeddiff = def.map.seeddiff or 24
	def.map.octaves = def.map.octaves or 5
	def.map.persist = def.map.persist or 0.7
	def.map.lacunarity = def.map.lacunarity or 1
	def.map.flags = def.map.flags or "absvalue"

	def.cavemap = def.cavemap or {} --CBN 22/10/2022 Added cave noise parameters to dimension definition
	def.cavemap.offset = def.cavemap.offset or 0
	def.cavemap.scale = def.cavemap.scale or 1
	def.cavemap.spread = def.cavemap.spread or {x=60,y=35,z=60}
	def.cavemap.seeddiff = def.cavemap.seeddiff or 128
	def.cavemap.octaves = def.cavemap.octaves or 5
	def.cavemap.persist = def.cavemap.persist or 0.2
	def.cavemap.lacunarity = def.cavemap.lacunarity or 1.4
	def.cavemap.flags = def.cavemap.flags or "defaults, absvalue"

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

	def.self.generate_multiores = def.generate_multiores or false
	def.self.generate_biomes = def.generate_biomes or true


	for i,v in pairs(table.copy(def.self)) do
		def.self[i] = minetest.registered_items[v] and minetest.get_content_id(v) or def.self[i]
	end

	
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
		node.description = node.description or "Teleport to dimension " .. name
		node.tiles = node.tiles or {"default_steel_block.png"}
		node.groups = node.groups or {cracky=2,not_in_creative_inventory=multidimensions.craftable_teleporters and 0 or 1}
		node.sounds = node.sounds or mcl_sounds.node_sound_wood_defaults()
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

-- Set the 3D noise parameters for the terrain.
-- Initialize noise object to nil. It will be created once only during the
-- generation of the first mapchunk, to minimise memory use.

local nobj_terrain = nil

-- Localise noise buffer table outside the loop, to be re-used for all
-- mapchunks, therefore minimising memory use.

-- Localise data buffer table outside the loop, to be re-used for all
-- mapchunks, therefore minimising memory use.

local data = {}

-- Detect the biomegen mod if loaded, in order to generate biomes
-- and decorations

local use_biomegen = false

if minetest.global_exists("biomegen") then
	use_biomegen = true
end

minetest.register_on_generated(function(minp, maxp, seed)
	for i,d in pairs(multidimensions.registered_dimensions) do
		if minp.y >= d.dim_y and maxp.y <= d.dim_y+d.dim_height then
			local depth = 18
			local height = d.dirt_start
			local ground_limit = d.ground_limit
			local dirt_depth = d.dirt_depth
			local water_depth = d.water_depth
			local cave_threshold = d.cave_threshold
			local lenth = maxp.x-minp.x+1
			local cindx = 1
			--Default map creation
			local map = minetest.get_perlin_map(d.map,{x=lenth,y=lenth,z=lenth}):get_3d_map_flat(minp)
			local cavemap = minetest.get_perlin_map(d.cavemap,{x=lenth,y=lenth,z=lenth}):get_3d_map_flat(minp)
			--Added special generated 2d perlin_noise
			local landmass = minetest.get_perlin(d.landmass)
			local ridges = minetest.get_perlin(d.ridges)
			local erosion = minetest.get_perlin(d.erosion)
			local enable_water = d.enable_water
			local terrain_density = d.terrain_density
			local flatland = d.flatland
			local blank = d.blank
			local heat = minetest.get_heat(minp)
			local humidity = minetest.get_humidity(minp)

			local miny = d.dim_y
			local maxy = d.dim_y+d.dim_height
			local deep_y = d.dim_y + d.deep_y --CBN 22/10/2022 Added a param to change the max height of deep stone ores
			local bedrock_depth = d.bedrock_depth

			local dirt = d.self.dirt
			local stone = minetest.get_content_id("mcl_core:stone")
			local grass = d.self.grass
			local air = d.self.air
			local water = d.self.water
			local sand = d.self.sand
			local bedrock = d.self.bedrock

			local multidimensions_ores = d.self.multidimensions_ores
			local generate_biomes = d.self.generate_biomes

			d.self.heat = heat
			d.self.humidity = humidity

			-- Voxelmanip stuff.

			-- Load the voxelmanip with the result of engine mapgen. Since 'singlenode'
			-- mapgen is used this will be a mapchunk of air nodes.
			local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
			-- 'area' is used later to get the voxelmanip indexes for positions.
			local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
			-- Get the content ID data from the voxelmanip in the form of a flat array.
			-- Set the buffer parameter to use and reuse 'data' for this.
			vm:get_data(data)

			if flatland == true then
				for z=minp.z,maxp.z do
					for y=minp.y,maxp.y do
						local id = area:index(minp.x,y,z)
						for x=minp.x,maxp.x do
							if y <= miny+bedrock_depth then
								data[id] = bedrock
							elseif y < height then
								data[id] = stone
							elseif y >= height and y < height + dirt_depth then
								data[id] = dirt
							else
								data[id] = air
							end

							--minetest.log("default", "landmass_noise = " .. landmass_noise .. " ridges_noise = " .. ridges_noise)
							
							--if y < ground_limit and y > miny + bedrock_depth and cavemap[cindx] <= cave_threshold then --CBN 22/10/2022 Cave carving
							--	data[id] = air
							--end
							
							if d.on_generate then
								data = d.on_generate(d.self,data,id,area,x,y,z) or data
							end
				
							cindx=cindx+1
							id=id+1
						end
					end
				end
			else
				for z=minp.z,maxp.z do
					for y=minp.y,maxp.y do
						local id = area:index(minp.x,y,z)
					for x=minp.x,maxp.x do
						if blank == nil then
							local flat = {x=x,y=z}
							local landmass_noise = math.floor(landmass:get_2d(flat))
							local ridges_noise =  math.floor(ridges:get_2d(flat))
							local erosion_noise = erosion:get_2d(flat)
							local stone_layer = math.floor((landmass_noise * erosion_noise) + height) - dirt_depth
							local dirt_layer = math.floor((landmass_noise * erosion_noise) + height)
							if y <= miny+bedrock_depth then
								data[id] = bedrock
							elseif y <= stone_layer then
								data[id] = stone
							elseif stone_layer <= y and y <= dirt_layer and y < height - 1 then
								data[id] = sand
							else
								if y < height and enable_water then
									data[id] = water
								else
									data[id] = air
								end
							end
						else
							data[id] = air
						end

						--minetest.log("default", "landmass_noise = " .. landmass_noise .. " ridges_noise = " .. ridges_noise)
						
						--if y < ground_limit and y > miny + bedrock_depth and cavemap[cindx] <= cave_threshold then --CBN 22/10/2022 Cave carving
						--	data[id] = air
						--end
						
						if d.on_generate then
							data = d.on_generate(d.self,data,id,area,x,y,z) or data
						end
			
						cindx=cindx+1
						id=id+1
					end
					end
				end
			end
			local node_y = minp.y

			if multidimensions_ores == true then
				for i1,v1 in pairs(data) do
					if i1%area.ystride == 0 then
						node_y = node_y + 1
					end
					if i1%area.zstride == 0 then --CBN 22/10/2022 data moves in the x axis first, then y axis then z axis, thus when a full zstride has been completed, it goes back to the base of the area
						node_y = minp.y
					end
					local da = data[i1]
					local typ
					if da == air and d.ground_ores and data[i1-area.ystride] == grass then
						typ = "ground"
					elseif da == grass and d.grass_ores then
						typ = "grass"
					elseif da == dirt and d.dirt_ores then
						typ = "dirt"
					elseif da == stone and d.deep_stone_ores and node_y <= miny + deep_y then
						typ = "deep_stone" --CBN 22/10/2022 Added deep stone ores, so that you can set two layers of ores with different chances, to encourage deep mining
					elseif da == stone and d.stone_ores then
						typ = "stone"
					elseif da == air and d.air_ores then
						typ = "air"
					elseif da == water and d.water_ores then
						typ = "water"
					elseif da == sand and d.sand_ores then
						typ = "sand"
					end
					if typ then
						for i2,v2 in pairs(d[typ.."_ores"]) do
							if math.random(1,v2.chance) == 1 and not (v2.min_heat and (heat < v2.min_heat or heat > v2.max_heat)) then
								if v2.chunk then
									for x=-v2.chunk,v2.chunk do
									for y=-v2.chunk,v2.chunk do
									for z=-v2.chunk,v2.chunk do
										local id = i1 + x + (y * area.ystride) + (z * area.zstride)
										if da == data[id] then
											data[id]=i2
										end
									end
									end
									end
								else
									data[i1]=i2
								end
							end
						end
					end
				end
			end

			if generate_biomes == true then
				if maxp.y < (height - 160) then
					local undergroundmin = {x = minp.x, y = -48, z = minp.z}
					local undergroundmax = {x = minp.x, y = -31, z = minp.z}
					-- Generate biomes in 'data', using biomegen mod
					biomegen.generate_biomes(data, area, undergroundmin, undergroundmax)
				elseif maxp.y < (height - 80) then
					local deepoceanmin = {x = minp.x, y = -32, z = minp.z}
					local deepoceanmax = {x = minp.x, y = -11, z = minp.z}
					-- Generate biomes in 'data', using biomegen mod
					biomegen.generate_biomes(data, area, deepoceanmin, deepoceanmax)
				elseif maxp.y < (height + 1) then
					local oceanmin = {x = minp.x, y = -12, z = minp.z}
					local oceanmax = {x = minp.x, y = -1, z = minp.z}
					-- Generate biomes in 'data', using biomegen mod
					biomegen.generate_biomes(data, area, oceanmin, oceanmax)
				else
					-- Generate biomes in 'data', using biomegen mod
					biomegen.generate_biomes(data, area, minp, maxp)
				end
				-- Write content ID data back to the voxelmanip.
				vm:set_data(data)
				-- Generate ores using core's function
				minetest.generate_ores(vm, minp, maxp)
				-- Generate decorations in VM (needs 'data' for reading)
				biomegen.place_all_decos(data, area, vm, minp, maxp, seed)
				-- Update data array to have ores/decorations
				vm:get_data(data)
				-- Add biome dust in VM (needs 'data' for reading)
				biomegen.dust_top_nodes(data, area, vm, minp, maxp)

				-- Calculate lighting for what has been created.
				vm:calc_lighting()
				-- Write what has been created to the world.
				vm:write_to_map()
				-- Liquid nodes were placed so set them flowing.
				vm:update_liquids()
			else
				vm:set_data(data)
				vm:write_to_map()
				vm:update_liquids()
			end
		end
	end
end)

minetest.register_node("multidimensions:bedrock", {
	description = "Bedrock",
	tiles = {"default_stone.png","default_cloud.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png",},
	groups = {unbreakable=1,not_in_creative_inventory = 1},
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	diggable = false,
	sounds = mcl_sounds.node_sound_stone_defaults(),
})

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
	tiles = {"default_steel_block.png","default_steel_block.png","redstone_redstone_block.png^[colorize:#1e6600cc"},
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