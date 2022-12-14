local safe_region_callback = {}
local safe_region_param = {}

worldeditadditions._override_safe_regions = false -- internal use ONLY!

local function check_region(name, param)
	local pos1, pos2 = worldedit.pos1[name], worldedit.pos2[name] --obtain positions
	if pos1 == nil or pos2 == nil then
		worldedit.player_notify(name, "no region selected")
		return nil
	end
	return worldedit.volume(pos1, pos2)
end

--`callback` is a callback to run when the user confirms
--`nodes_needed` is a function accepting `param`, `pos1`, and `pos2` to calculate the number of nodes needed
local function safe_region(callback, nodes_needed)
	--default node volume calculation
	nodes_needed = nodes_needed or check_region

	return function(name, param)
		--check if the operation applies to a safe number of nodes
		local count = nodes_needed(name, param)
		if count == nil then return end --invalid command
		if worldeditadditions._override_safe_regions or count < 10000 then
			return callback(name, param)
		end

		--save callback to call later
		safe_region_callback[name], safe_region_param[name] = callback, param
		worldedit.player_notify(name, "WARNING: this operation could affect up to " .. count .. " nodes; type //yy to continue or //nn to cancel")
	end
end

local function reset_pending(name)
	safe_region_callback[name], safe_region_param[name] = nil, nil
end

minetest.register_chatcommand("/yy", {
	params = "",
	description = "Confirm a pending operation",
	func = function(name)
		local callback, param = safe_region_callback[name], safe_region_param[name]
		if not callback then
			worldedit.player_notify(name, "no operation pending")
			return
		end

		reset_pending(name)
		callback(name, param)
	end,
})

minetest.register_chatcommand("/nn", {
	params = "",
	description = "Abort a pending operation",
	func = function(name)
		if not safe_region_callback[name] then
			worldedit.player_notify(name, "no operation pending")
			return
		end

		reset_pending(name)
	end,
})


return safe_region, check_region, reset_pending
