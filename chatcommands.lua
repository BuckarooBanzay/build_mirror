
local valid_axes = {
    x = true,
    y = true,
    z = true
}

minetest.register_chatcommand("mirror_here", {
    privs = { build_mirror = true },
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "not a valid player: " .. name
        end

        local player_data = build_mirror.mirrors[name]
        if not player_data then
            player_data = {}
            build_mirror.mirrors[name] = player_data
        end

        player_data.pos = vector.round(player:get_pos())

        return true, "mirror set at " .. minetest.pos_to_string(player_data.pos)
    end
})

minetest.register_chatcommand("mirror_on", {
    privs = { build_mirror = true },
    func = function(name, axis)
        if not valid_axes[axis] then
            return false, "not a valid axis: " .. axis
        end
        local player_data = build_mirror.mirrors[name]
        if not player_data then
            return false, "choose a mirror-position first with /mirror_here"
        end
        player_data[axis] = true
    end
})

minetest.register_chatcommand("mirror_off", {
    privs = { build_mirror = true },
    func = function(name, axis)
        if not valid_axes[axis] then
            return false, "not a valid axis: " .. axis
        end
        local player_data = build_mirror.mirrors[name]
        if not player_data then
            return false, "choose a mirror-position first with /mirror_here"
        end
        player_data[axis] = false
    end
})
