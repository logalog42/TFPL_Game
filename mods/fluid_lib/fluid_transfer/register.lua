
fluid_lib.register_extractor_node("fluid_transfer:fluid_transfer_pump", {
	description = "Fluid Transfer Pump\nPunch to start pumping",
	tiles = {"fluid_transfer_pump.png"},
	use_texture_alpha = "clip",
	drawtype = "mesh",
	mesh = "fluid_transfer_pump.obj",
	groups = {oddly_breakable_by_hand = 1, cracky = 1},
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.4375, -0.5000, 0.4375, 0.4375, 0.000},
			{-0.1875, -0.1875, 0.000, 0.1875, 0.1875, 0.5000}
		}
	}
})

fluid_lib.register_transfer_node("fluid_transfer:fluid_duct", {
	description = "Fluid Duct",
	tiles = {"fluid_transfer_duct.png"},
	groups = {oddly_breakable_by_hand = 1, cracky = 1}
})

minetest.register_node("fluid_transfer:fluid_trash", {
	description = "Fluid Trash Can",
	drawtype = "mesh",
	mesh = "fluid_transfer_trash.obj",
	tiles = {"fluid_transfer_trash.png"},
	use_texture_alpha = "clip",
	groups = {oddly_breakable_by_hand = 1, cracky = 1, fluid_container = 1},
	node_io_can_put_liquid = function (pos, node, side)
		return true
	end,
	node_io_accepts_millibuckets = function(pos, node, side) return true end,
	node_io_put_liquid = function(pos, node, side, putter, liquid, millibuckets)
		return 0
	end,
	node_io_room_for_liquid = function(pos, node, side, liquid, millibuckets)
		return millibuckets
	end,
	node_io_get_liquid_size = function (pos, node, side)
		return 1
	end,
	node_io_get_liquid_name = function(pos, node, side, index)
		return ""
	end,
	node_io_get_liquid_stack = function(pos, node, side, index)
		return ItemStack(nil)
	end,
})
