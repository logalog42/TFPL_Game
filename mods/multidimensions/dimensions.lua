local ores={
}

local plants = {
	["multidimensions:tree"] = 1000,
	["multidimensions:aspen_tree"] = 1000,
	["multidimensions:pine_tree"] = 1000,
}

multidimensions.register_dimension("FreeBuild",{
	
	self = {},		    	-- can contain everything, var like dirt="default:dirt" will be remade to dirt=content_id
	
	dim_y = 2000,           -- dimension start (don't change if you don't know what you're doing)
	dim_height =  1000,	    -- dimension height
	deep_y = 240,
	
	dirt_start = 501,       -- when dirt begins to appear (default is 501)
	dirt_depth = 5,	    	-- dirt depth
	ground_limit = 530,		-- ground y limit (ground ends here)
	bedrock_depth = 5,	    -- How many layers of the bottom bedrock should cover
	water_depth = 50,	    -- depth from ground and down
	enable_water = nil,     -- (nil = true)
	terrain_density = 0.3,  -- or ground density
	cave_threshold = 0.075, -- threshold below which caves carved
	flatland = nil,         -- (nil = false)
	blank = nil,
	generate_multiores = false,
	generate_biomes = true,
	teleporter = nil,       -- (nil = true) dimension teleporter
	gravity = 1,		    -- (1 = default) dimension gravity
	
	sand_ores = {
		["mcl_core:gravel"] = {
			chance = 1000,
			chunk = 5,
		},
		["mcl_core:clay"] = {
			chance = 1000,
			chunk = 3,
		}
	},

	map = {
		offset = 0,
		scale = 1,
		spread = {x = 384, y = 192, z = 384},
		seed = 5900033,
		octaves = 5,
		persist = 0.63,
		lacunarity = 2.0,
		flags = ""
	},
	
	cavemap = {
		offset = 0,
		scale = 1,
		spread = {x=70,y=30,z=70},
		seeddiff = 128,
		octaves = 5,
		persist = 0.2,
		lacunarity = 1.4,
		flags = "defaults, absvalue",
	},
	

	ridges = {
		offset = 0,
		scale = 5,
		spread = {x=40,y=40,z=40},
		seeddiff = 24,
		octaves = 6,
		persist = 1,
		lacunarity = 1.6,
		flags = ""
	},

	erosion = {
		offset = 0,
		scale = 0.37,
		spread = {x=100,y=100,z=100},
		seeddiff = 24,
		octaves = 5,
		persist = 0.7,
		lacunarity = 1,
		flags = "absvalue"
	},

	landmass = {
		offset = 30,
		scale = 80,
		spread = {x=500,y=450,z=500},
		seeddiff = 24,
		octaves = 6,
		persist = 0.7,
		lacunarity = 1,
		flags = ""
	},

	craft = { -- teleport craft recipe
	{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	{"default:wood","default:mese","default:wood",},
	{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	},

	on_enter=function(player) --on enter dimension
		local name = player:get_player_name()
		minetest.set_player_privs(name, {
			dimensions=true,
			shout=true,
			interact=true,
			fly=true,
			teleport=true,
			creative=true,
			basic_privs=true,	
		})
	end,
	
	on_leave=function(player) --on leave dimension
	end,

})

multidimensions.register_dimension("City",{

	self = {},		    	-- can contain everything, var like dirt="default:dirt" will be remade to dirt=content_id
	
	dim_y = 3000,           -- dimension start (don't change if you don't know what you're doing)
	dim_height =  2000,	    -- dimension height
	deep_y = 0,
	
	dirt_start = 500,       -- when dirt begins to appear (default is 501)
	dirt_depth = 3,	   		-- dirt depth
	flatland = true,        -- (nil = false)
	teleporter = nil,       -- (nil = true) dimension teleporter
	gravity = 1,		    -- (1 = default) dimension gravity
	generate_multiores = false,
	generate_biomes = false,

	 craft = { -- teleport craft recipe
	  {"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	  {"default:wood","default:mese","default:wood",},
	  {"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	 },
  
	 on_generate=function(self,data,id,area,x,y,z)
	 end,
	 
	 on_enter=function(player) --on enter dimension
		local name = player:get_player_name()
		minetest.set_player_privs(name, {
			dimensions=true,
			shout=true,
			interact=true,
			fly=true,
			teleport=true,
			creative=true,
			basic_privs=true,
		})
	 end,
	 
	 on_leave=function(player) --on leave dimension
	 end,
	 
  })

--[[ DIMENSION BASE API
multidimensions.register_dimension("name",{

	ground_ores = {
	  ["default:tree"] = 1000,            -- (chance) ... spawns on ground, used by trees, grass, flowers...
	  ["default:stone"] = {chance=1000}, 	-- same as above
	  ["default:dirt_with_snow"] = {	-- names will be remade to content_id
		  chance=5000,	     -- chance
	  min_heat=10,	     -- min heat
	  max_heat=40,	     -- max heat
	  chunk=3,	     -- chunk size
	  },
	},
	stone_ores = {},     	     -- works as above, but in stone
	deep_stone_ores = {},
	dirt_ores = {},
	grass_ores = {},
	air_ores = {},
	water_ores = {},
	sand_ores = {},
	
	self = {},		    -- can contain everything, var like dirt="default:dirt" will be remade to dirt=content_id
	
	dim_y = 2000,             -- dimension start (don't change if you don't know what you're doing)
	dim_height =  1000,	    -- dimension height
	deep_y = 240,
	
	dirt_start 501,           -- when dirt begins to appear (default is 501)
	dirt_depth = 3,	    -- dirt depth
	ground_limit = 530,	    -- ground y limit (ground ends here)
	water_depth = 8,	    -- depth fron ground and down
	enable_water = nil,       -- (nil = true)
	terrain_density = 0.4,    -- or ground density
	cave_threshold = 0.075,   -- threshold below which caves carved
	flatland = nil,           -- (nil = false)
	teleporter = nil,         -- (nil = true) dimension teleporter
	gravity = 1,		    -- (1 = default) dimension gravity
	
	stone = "default:stone",
	dirt = "default:dirt",
	grass = "default:dirt_with_grass",
	air = "air",
	water = "default:water_source",
	sand = "default:sand",
	bedrock = "multidimensions:bedrock", -- at dimension edges
	
	map = {
	  offset = 0,
	  scale = 1,
	  spread = {x=100,y=18,z=100},
	  seeddiff = 24,
	  octaves = 5,
	  persist = 0.7,
	  lacunarity = 1,
	  flags = "absvalue",
	 },
	 
	 cavemap = {
	  offset = 0,
	  scale = 1,
	  spread = {x=70,y=30,z=70},
	  seeddiff = 128,
	  octaves = 5,
	  persist = 0.2,
	  lacunarity = 1.4,
	  flags = "defaults, absvalue",
	 },
	 
	 craft = { -- teleport craft recipe
	  {"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	  {"default:wood","default:mese","default:wood",},
	  {"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	 }
  
	 on_generate=function(self,data,id,area,x,y,z)
	  if y <= self.dirt_start+5 then
		  data[id] = self.air
	  else
		  return
	  end
	  return data -- to return changes
	 end,
	 
	 -- data: active generating area (VoxelArea)
	 -- index: data index
	 -- self: {dim_start, dim_end, dim_height, ground_limit, heat, humidity, dirt, stone, grass, air, water, sand, bedrock ... and your inputs
	  area: (VoxelArea:new({MinEd...)
	 
	 sky = {{r=219, g=168, b=117},"plain",{}}, -- same as:set_sky()
	 
	 on_enter=function(player) --on enter dimension
		local name = player:get_player_name()
		minetest.set_player_privs(name, {
			dimensions=true,
			shout=true,
			interact=true,
			fast=true,
			fly=true,
			noclip=true,
			teleport=true,
			creative=true,
			bring=true,
			give=true,
			settime=true,
			debug=true,
			privs=true,
			basic_privs=true,
			kick=true,
			ban=true,
			password=true,
			protection_bypass=true,
			server=true,
			rollback=true
		
		})
	 end,
	 
	 on_leave=function(player) --on leave dimension
	 end,
	 
  })
]]--



minetest.register_node("multidimensions:tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:pine_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:pine_treesnow", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:jungle_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:aspen_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})
minetest.register_node("multidimensions:acacia_tree", {drawtype="airlike",groups = {multidimensions_tree=1,not_in_creative_inventory=1},})

