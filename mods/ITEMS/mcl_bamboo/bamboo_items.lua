---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by michieal.
--- DateTime: 12/29/22 12:38 PM -- Restructure Date
--- Copyright (C) 2022 - 2023, Michieal. See License.txt

-- CONSTS
-- Due to door fix #2736, doors are displayed backwards. When this is fixed, set this variable to false.
local BROKEN_DOORS = true

--	FUTURE USE VARIABLE. MUST REMAIN FALSE UNTIL IT HAS BEEN FULLY IMPLEMENTED. DO NOT ENABLE.
local SIDE_SCAFFOLDING = false
local SIDE_SCAFFOLD_NAME = "mcl_bamboo:scaffolding_horizontal"
-- ---------------------------------------------------------------------------
local SCAFFOLDING_NAME = "mcl_bamboo:scaffolding"
-- Used everywhere. Often this is just the name, but it makes sense to me as BAMBOO, because that's how I think of it...
-- "BAMBOO" goes here.
local BAMBOO = "mcl_bamboo:bamboo"
local BAMBOO_PLANK = BAMBOO .. "_plank"

-- LOCALS
local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
local adj_nodes = {
	vector.new(0, 0, 1),
	vector.new(1, 0, 0),
	vector.new(0, 0, -1),
	vector.new(-1, 0, 0),
}
local node_sound = mcl_sounds.node_sound_wood_defaults()

-- specific bamboo nodes (Items)... Pt. 1
if minetest.get_modpath("mcl_flowerpots") then
	mcl_bamboo.mcl_log("FlowerPot Section Entrance. Modpath exists.")
	if mcl_flowerpots ~= nil then
		-- Flower-potted Bamboo...
		local flwr_name = BAMBOO
		local flwr_def = { name = "bamboo_plant",
						   desc = S("Bamboo"),
						   image = "mcl_bamboo_bamboo_fpm.png", -- use with "register_potted_cube"
			-- "mcl_bamboo_flower_pot.png", -- use with "register_potted_flower"
		}

		-- Chose cube over "potted_flower" as "potted flower" looks bad.
		mcl_flowerpots.register_potted_cube(flwr_name, flwr_def)  --	mcl_flowerpots.register_potted_flower(flwr_name, flwr_def)
		minetest.register_alias("bamboo_flower_pot", "mcl_flowerpots:flower_pot_bamboo_plant")
	end
end

if minetest.get_modpath("mcl_doors") then
	if mcl_doors then
		local top_door_tiles = {}
		local bot_door_tiles = {}

		if BROKEN_DOORS then
			top_door_tiles = { "mcl_bamboo_door_top_alt.png", "mcl_bamboo_door_top.png" }
			bot_door_tiles = { "mcl_bamboo_door_bottom_alt.png", "mcl_bamboo_door_bottom.png" }
		else
			top_door_tiles = { "mcl_bamboo_door_top.png", "mcl_bamboo_door_top.png" }
			bot_door_tiles = { "mcl_bamboo_door_bottom.png", "mcl_bamboo_door_bottom.png" }
		end

		local name = "mcl_bamboo:bamboo_door"
		local def = {
			description = S("Bamboo Door."),
			inventory_image = "mcl_bamboo_door_wield.png",
			wield_image = "mcl_bamboo_door_wield.png",
			groups = { handy = 1, axey = 1, material_wood = 1, flammable = -1 },
			_mcl_hardness = 3,
			_mcl_blast_resistance = 3,
			tiles_bottom = bot_door_tiles,
			tiles_top = top_door_tiles,
			sounds = mcl_sounds.node_sound_wood_defaults(),
		}

		mcl_doors:register_door(name, def)

		name = "mcl_bamboo:bamboo_trapdoor"
		local trap_def = {
			description = S("Bamboo Trapdoor."),
			inventory_image = "mcl_bamboo_door_complete.png",
			groups = {},
			tile_front = "mcl_bamboo_trapdoor_side.png",
			tile_side = "mcl_bamboo_trapdoor_side.png",
			_doc_items_longdesc = S("Wooden trapdoors are horizontal barriers which can be opened and closed by hand or a redstone signal. They occupy the upper or lower part of a block, depending on how they have been placed. When open, they can be climbed like a ladder."),
			_doc_items_usagehelp = S("To open or close the trapdoor, rightclick it or send a redstone signal to it."),
			wield_image = "mcl_bamboo_trapdoor_side.png",
			inventory_image = "mcl_bamboo_trapdoor_side.png",
			groups = { handy = 1, axey = 1, mesecon_effector_on = 1, material_wood = 1, flammable = -1 },
			_mcl_hardness = 3,
			_mcl_blast_resistance = 3,
			sounds = mcl_sounds.node_sound_wood_defaults(),
		}

		mcl_doors:register_trapdoor(name, trap_def)

		minetest.register_alias("bamboo_door", "mcl_bamboo:bamboo_door")
		minetest.register_alias("bamboo_trapdoor", "mcl_bamboo:bamboo_trapdoor")
	end
end

if minetest.get_modpath("mcl_stairs") then
	if mcl_stairs ~= nil then
		mcl_stairs.register_stair_and_slab_simple(
				"bamboo_block",
				"mcl_bamboo:bamboo_block",
				S("Bamboo Stair"),
				S("Bamboo Slab"),
				S("Double Bamboo Slab")
		)
		mcl_stairs.register_stair_and_slab_simple(
				"bamboo_stripped",
				"mcl_bamboo:bamboo_block_stripped",
				S("Stripped Bamboo Stair"),
				S("Stripped Bamboo Slab"),
				S("Double Stripped Bamboo Slab")
		)
		mcl_stairs.register_stair_and_slab_simple(
				"bamboo_plank",
				BAMBOO_PLANK,
				S("Bamboo Plank Stair"),
				S("Bamboo Plank Slab"),
				S("Double Bamboo Plank Slab")
		)

		-- let's add plank slabs to the wood_slab group.
		local bamboo_plank_slab = "mcl_stairs:slab_bamboo_plank"
		local node_groups = {
			wood_slab = 1,
			building_block = 1,
			slab = 1,
			axey = 1,
			handy = 1,
			stair = 1,
			flammable = 1,
			fire_encouragement = 5,
			fire_flammability = 20
		}

		minetest.override_item(bamboo_plank_slab, { groups = node_groups })
	end
end

if minetest.get_modpath("mesecons_pressureplates") then

	if mesecon ~= nil and mesecon.register_pressure_plate ~= nil then
		-- make sure that pressure plates are installed.

		-- Bamboo Pressure Plate...

		-- Register a Pressure Plate (api command doc.)
		-- basename:    base name of the pressure plate
		-- description:	description displayed in the player's inventory
		-- textures_off:textures of the pressure plate when inactive
		-- textures_on:	textures of the pressure plate when active
		-- image_w:	wield image of the pressure plate
		-- image_i:	inventory image of the pressure plate
		-- recipe:	crafting recipe of the pressure plate
		-- sounds:	sound table (like in minetest.register_node)
		-- plusgroups:	group memberships (attached_node=1 and not_in_creative_inventory=1 are already used)
		-- activated_by: optimal table with elements denoting by which entities this pressure plate is triggered
		--		Possible table fields:
		--		* player=true: Player
		--		* mob=true: Mob
		--		By default, is triggered by all entities
		-- longdesc:	Customized long description for the in-game help (if omitted, a dummy text is used)

		mesecon.register_pressure_plate(
				"mcl_bamboo:pressure_plate_bamboo_wood",
				S("Bamboo Pressure Plate"),
				{ "mcl_bamboo_bamboo_plank.png" },
				{ "mcl_bamboo_bamboo_plank.png" },
				"mcl_bamboo_bamboo_plank.png",
				nil,
				{ { BAMBOO_PLANK, BAMBOO_PLANK } },
				mcl_sounds.node_sound_wood_defaults(),
				{ axey = 1, material_wood = 1 },
				nil,
				S("A wooden pressure plate is a redstone component which supplies its surrounding blocks with redstone power while any movable object (including dropped items, players and mobs) rests on top of it."))

		minetest.register_craft({
			type = "fuel",
			recipe = "mcl_bamboo:pressure_plate_bamboo_wood_off",
			burntime = 15
		})
		minetest.register_alias("bamboo_pressure_plate", "mcl_bamboo:pressure_plate_bamboo_wood")

	end
end

if minetest.get_modpath("mcl_signs") then
	mcl_bamboo.mcl_log("Signs Section Entrance. Modpath exists.")
	if mcl_signs ~= nil then
		-- Bamboo Signs...
		mcl_signs.register_sign_custom("mcl_bamboo", "_bamboo", "mcl_bamboo_bamboo_sign.png",
				"#ffffff", "mcl_bamboo_bamboo_sign_wield.png", "mcl_bamboo_bamboo_sign_wield.png",
				"Bamboo Sign")
		mcl_signs.register_sign_craft("mcl_bamboo", BAMBOO_PLANK, "_bamboo")
		minetest.register_alias("bamboo_sign", "mcl_signs:wall_sign_bamboo")
	end
end

if minetest.get_modpath("mcl_fences") then
	mcl_bamboo.mcl_log("Fences Section Entrance. Modpath exists.")

	local id = "bamboo_fence"
	local wood_groups = { handy = 1, axey = 1, flammable = 2, fence_wood = 1, fire_encouragement = 5, fire_flammability = 20 }
	local wood_connect = { "group:fence_wood" }

	local fence_id = mcl_fences.register_fence(id, S("Bamboo Fence"), "mcl_bamboo_fence_bamboo.png", wood_groups,
			2, 15, wood_connect, node_sound)
	local gate_id = mcl_fences.register_fence_gate(id, S("Bamboo Fence Gate"), "mcl_bamboo_fence_gate_bamboo.png",
			wood_groups, 2, 15, node_sound) -- note: about missing params.. will use defaults.

	mcl_bamboo.mcl_log(dump(fence_id))
	mcl_bamboo.mcl_log(dump(gate_id))
end

if minetest.get_modpath("mesecons_button") then
	if mesecon ~= nil then
		mesecon.register_button(
				"bamboo",
				S("Bamboo Button"),
				"mcl_bamboo_bamboo_plank.png",
				BAMBOO_PLANK,
				node_sound,
				{ material_wood = 1, handy = 1, pickaxey = 1, flammable = 3, fire_flammability = 20, fire_encouragement = 5, },
				1,
				false,
				S("A bamboo button is a redstone component made out of stone which can be pushed to provide redstone power. When pushed, it powers adjacent redstone components for 1 second."),
				"mesecons_button_push")
	end
end

if minetest.get_modpath("mcl_stairs") then
	if mcl_stairs ~= nil then
		mcl_stairs.register_stair_and_slab_simple(
				"bamboo_mosaic",
				"mcl_bamboo:bamboo_mosaic",
				S("Bamboo Mosaic Stair"),
				S("Bamboo Mosaic Slab"),
				S("Double Bamboo Mosaic Slab")
		)
	end
end

local disallow_on_rotate
if minetest.get_modpath("screwdriver") then
	disallow_on_rotate = screwdriver.disallow
end

minetest.register_node(SCAFFOLDING_NAME, {
	description = S("Scaffolding"),
	doc_items_longdesc = S("Scaffolding block used to climb up or out across areas."),
	doc_items_hidden = false,
	tiles = { "mcl_bamboo_scaffolding_top.png", "mcl_bamboo_scaffolding_top.png", "mcl_bamboo_scaffolding_bottom.png" },
	drawtype = "nodebox",
	paramtype = "light",
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, 0.375, -0.5, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.375, 0.5, -0.375 },
			{ 0.375, -0.5, -0.5, 0.5, 0.5, -0.375 },
			{ 0.375, -0.5, 0.375, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, 0.375, -0.375, 0.5, 0.5 },
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
		},
	},
	buildable_to = false,
	is_ground_content = false,
	walkable = false,
	climbable = true,
	physical = true,
	node_placement_prediction = "",
	groups = { handy = 1, axey = 1, flammable = 3, building_block = 1, material_wood = 1, fire_encouragement = 5, fire_flammability = 20, dig_by_piston = 1, falling_node = 1, stack_falling = 1 },
	sounds = mcl_sounds.node_sound_wood_defaults(),
	_mcl_blast_resistance = 0,
	_mcl_hardness = 0,

	on_rotate = disallow_on_rotate,

	on_place = function(itemstack, placer, pointed)
		mcl_bamboo.mcl_log("Checking for protected placement of scaffolding.")
		local node = minetest.get_node(pointed.under)
		local pos = pointed.under
		local h = 0
		local current_base_node = node -- Current Base Node.
		local below_node = minetest.get_node(vector.offset(pos, 0, -1, 0)) -- current node below the current_base_node.

		mcl_bamboo.mcl_log("Below Node: " .. below_node.name)

		-- check protected placement.
		if mcl_bamboo.is_protected(pos, placer) then
			return
		end
		mcl_bamboo.mcl_log("placement of scaffolding is not protected.")
		-- place on solid nodes
		-- Need to add in a check here... to prevent placing scaffolds against doors, chests, etc.
		-- Added in a quick check. need to test it.
		if node.name ~= SCAFFOLDING_NAME then
			-- Start temp fix: This is a temp fix... will NOT work in final scaffolding implementation.
			-- Use pointed node's on_rightclick function first, if present
			if placer and not placer:get_player_control().sneak then
				if minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_rightclick then
					mcl_bamboo.mcl_log("attempting placement of bamboo via targeted node's on_rightclick.")
					return minetest.registered_nodes[node.name].on_rightclick(pointed.under, node, placer, itemstack) or itemstack
				end
			end
			-- End: Temp fix

			-- A quick check, that may or may not work, to attempt to prevent placing things on the side of other nodes.
			local dir = vector.subtract(pointed.under, pointed.above)
			local wdir = minetest.dir_to_wallmounted(dir)
			if wdir == 1 then
				minetest.set_node(pointed.above, { name = SCAFFOLDING_NAME, param2 = 0 })
				if not minetest.is_creative_enabled(placer:get_player_name()) then
					itemstack:take_item(1)
				end
				return itemstack
			else
				return
			end
		end

		--build up when placing on existing scaffold
		--[[
			Quick explanation. scaffolding should be placed at the ground level ONLY. To do this, we look at a few
			different nodes. Current node (current_node) is the top node being placed - make sure that it is air / unoccupied.
			below_node (below node) is the node below the bottom node; Used to check to see if we are up in the air putting
			more scaffolds on the top.. current_base_node (Current Base Node) is the targeted node for placement; we can only place
			scaffolding on this one, to stack them up in the air.
		--]]
		repeat -- loop through, allowing placement.
			pos = vector.offset(pos, 0, 1, 0) -- cleaned up vector.
			local current_node = minetest.get_node(pos) -- current node.
			if current_node.name == "air" then
				-- first step to making scaffolding work like scaffolding should.
				-- Prevent running up, and putting down new scaffolding
				if current_base_node.name == SCAFFOLDING_NAME and below_node == SCAFFOLDING_NAME and SIDE_SCAFFOLDING == false then
					return itemstack
				end

				-- Make sure that the uppermost scaffolding doesn't violate protected areas.
				if mcl_bamboo.is_protected(pos, placer) then
					return itemstack
				end

				-- okay, we're good. place the node and take the item unless we are in creative mode.
				minetest.set_node(pos, node)
				if not minetest.is_creative_enabled(placer:get_player_name()) then
					itemstack:take_item(1)
				end
				-- set the wielded item to the correct itemstack. (possibly unneeded code. but, works.)
				placer:set_wielded_item(itemstack)
				return itemstack -- finally, return the itemstack to finish on_place.
			end
			h = h + 1
		until current_node.name ~= node.name or itemstack:get_count() == 0 or h >= 128 -- loop check.
	end,
	on_destruct = function(pos)
		-- Node destructor; called before removing node.
		local new_pos = vector.offset(pos, 0, 1, 0)
		local node_above = minetest.get_node(new_pos)
		if node_above and node_above.name == SCAFFOLDING_NAME then
			local sound_params = {
				pos = new_pos,
				gain = 1.0, -- default
				max_hear_distance = 10, -- default, uses a Euclidean metric
			}

			minetest.remove_node(new_pos)
			minetest.sound_play(node_sound.dug, sound_params, true)
			local istack = ItemStack(SCAFFOLDING_NAME)
			minetest.add_item(new_pos, istack)
		end
	end,
})

--	FOR FUTURE USE. DO NOT ENABLE. DO NOT UNCOMMENT OUT. THIS WILL BREAK THE SCAFFOLDING, IF NOT FINISHED.
--	YOU HAVE BEEN WARNED.
--[[
if SIDE_SCAFFOLDING then
minetest.register_node(SCAFFOLDING_NAME, {
	description = S("Scaffolding"),
	doc_items_longdesc = S("Scaffolding block used to climb up or out across areas."),
	doc_items_hidden = false,
	tiles = {"mcl_bamboo_scaffolding_top.png", "mcl_bamboo_scaffolding_top.png", "mcl_bamboo_scaffolding_bottom.png"},
	drawtype = "nodebox",
	paramtype = "light",
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.375, 0.5, -0.375},
			{0.375, -0.5, -0.5, 0.5, 0.5, -0.375},
			{0.375, -0.5, 0.375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, 0.375, -0.375, 0.5, 0.5},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	},
	buildable_to = false,
	is_ground_content = false,
	walkable = false,
	climbable = true,
	physical = true,
	node_placement_prediction = "",
	groups = {handy = 1, axey = 1, flammable = 3, building_block = 1, material_wood = 1, fire_encouragement = 5, fire_flammability = 20, falling_node = 1, stack_falling = 1},
	sounds = mcl_sounds.node_sound_wood_defaults(),
	_mcl_blast_resistance = 0,
	_mcl_hardness = 0,

	on_rotate = disallow_on_rotate,

	on_place = function(itemstack, placer, pointed)
		mcl_bamboo.mcl_log("Checking for protected placement of scaffolding.")
		local node = minetest.get_node(pointed.under)
		local pos = pointed.under
		local dir = vector.subtract(pointed.under, pointed.above)
		local wdir = minetest.dir_to_wallmounted(dir)
		local h = 0
		mcl_bamboo.mcl_log("WDIR: " .. wdir)
		local fdir = minetest.dir_to_facedir(dir, true)
		mcl_bamboo.mcl_log("FDIR: " .. fdir)

		local down_two = minetest.get_node(vector.offset(pointed.under, 0, -1, 0))

		if wdir == 1 then
			-- standing placement.

			if mcl_bamboo.is_protected(pos, placer) then
				return
			end
			mcl_bamboo.mcl_log("placement of scaffolding is not protected.")
			-- place on solid nodes
			if node.name ~= SCAFFOLDING_NAME then
				minetest.set_node(pointed.above, {name = SCAFFOLDING_NAME, param2 = 0})
				if not minetest.is_creative_enabled(placer:get_player_name()) then
					itemstack:take_item(1)
				end
				return itemstack
			end
			--build up when placing on existing scaffold
			repeat
				pos.y = pos.y + 1
				local current_node = minetest.get_node(pos)
				local current_base_node = node
				local below_node = down_two
				if current_node.name == "air" then
					-- first step to making scaffolding work like Minecraft scaffolding.
					if current_base_node.name == SCAFFOLDING_NAME and below_node == SCAFFOLDING_NAME and SIDE_SCAFFOLDING == false then
						return itemstack
					end

					if mcl_bamboo.is_protected(pos, placer) then
						return
					end

					minetest.set_node(pos, node)
					if not minetest.is_creative_enabled(placer:get_player_name()) then
						itemstack:take_item(1)
					end
					placer:set_wielded_item(itemstack)
					return itemstack
				end
				h = h + 1
			until current_node.name ~= node.name or itemstack:get_count() == 0 or h >= 128

			--  Commenting out untested code, for commit.
			if SIDE_SCAFFOLDING == true then
				local meta = minetest.get_meta(pos)

				if not meta then
					return false
				end
				-- 	local count = meta:get_int("count", 0)

				h = minetest.get_node(pointed.under).param2
				local new_pos = pointed.under
				repeat
					local ctrl = placer:get_player_control()
					if ctrl and ctrl.sneak then
						if node.name == SCAFFOLDING_NAME or node.name == SIDE_SCAFFOLD_NAME then
							local param_2 = h

							local node_param2 = param_2 + 1
							fdir = fdir + 1 -- convert fdir to a base of one.
							local target_offset = adj_nodes[fdir]

							new_pos = vector.offset(new_pos, target_offset.x, 0, target_offset.z)
							if mcl_bamboo.is_protected(new_pos, placer) then
								-- disallow placement in protected area
								return
							end

							itemstack:take_item(1)
							if minetest.get_node(new_pos).name == "air" then
								minetest.set_node(new_pos, {name = SIDE_SCAFFOLD_NAME, param2 = node_param2})
								if node_param2 >= 6 then
									node_param2 = 6
									minetest.minetest.dig_node(new_pos)
								end
							end
							return itemstack

						end

						h = h + 1

					end
				until h >= 7 or itemstack.get_count() <= 0
			end
		end
	end,
	on_destruct = function(pos)
		-- Node destructor; called before removing node.
		local new_pos = vector.offset(pos, 0, 1, 0)
		local node_above = minetest.get_node(new_pos)
		if node_above and node_above.name == SCAFFOLDING_NAME then
			local sound_params = {
				pos = new_pos,
				gain = 1.0, -- default
				max_hear_distance = 10, -- default, uses a Euclidean metric
			}

			minetest.remove_node(new_pos)
			minetest.sound_play(node_sound.dug, sound_params, true)
			local istack = ItemStack(SCAFFOLDING_NAME)
			minetest.add_item(new_pos, istack)
		end
	end,
})

minetest.register_node(SIDE_SCAFFOLD_NAME, {
	description = S("Scaffolding"),
	doc_items_longdesc = S("Scaffolding block used to climb up or out across areas."),
	doc_items_hidden = false,
	tiles = {"mcl_bamboo_scaffolding_top.png", "mcl_bamboo_scaffolding_top.png", "mcl_bamboo_scaffolding_bottom.png"},
	drop = "mcl_bamboo:scaffolding",
	drawtype = "nodebox",
	paramtype = "light",
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.375, 0.5, -0.375},
			{0.375, -0.5, -0.5, 0.5, 0.5, -0.375},
			{0.375, -0.5, 0.375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, 0.375, -0.375, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {handy = 1, axey = 1, flammable = 3, building_block = 1, material_wood = 1, fire_encouragement = 5, fire_flammability = 20, not_in_creative_inventory = 1, falling_node = 1},
	_mcl_after_falling = function(pos)
		if minetest.get_node(pos).name == "mcl_bamboo:scaffolding_horizontal" then
			if minetest.get_node(vector.offset(pos, 0, 0, 0)).name ~= SCAFFOLDING_NAME then
				minetest.remove_node(pos)
				minetest.add_item(pos, SCAFFOLDING_NAME)
			else
				minetest.set_node(vector.offset(pos, 0, 1, 0), {name = SIDE_SCAFFOLD_NAME})
			end
		end
	end,
	buildable_to = false,
	is_ground_content = false,
	walkable = false,
	climbable = true,
	physical = true,

	on_rotate = disallow_on_rotate,

	on_place = function(itemstack, placer, pointed_thing)
		-- this function shouldn't be called, as this is never placed by the user.
		-- it's placed only as a variant of regular scaffolding.
		return false
	end


})
end
--]]
