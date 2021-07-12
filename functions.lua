
--- Mirrors the given coordinate around the specified axis
-- @param pos the position to mirror
-- @param mirror_pos the mirror position
-- @param axis the axis to mirrror
-- @return the mirrrored position
function build_mirror.mirror_pos(pos, mirror_pos, axis)
    local pos_value = assert(pos[axis])
    local mirror_value = assert(mirror_pos[axis])
    local delta = mirror_value - pos_value

    local mirrored_pos = {
        x=pos.x,
        y=pos.y,
        z=pos.z
    }
    mirrored_pos[axis] = mirror_pos[axis] + delta
    return mirrored_pos
end

local wallmounted = {
    [90]  = {0, 1, 5, 4, 2, 3, 0, 0},
    [180] = {0, 1, 3, 2, 5, 4, 0, 0},
    [270] = {0, 1, 4, 5, 3, 2, 0, 0}
}

local facedir = {
    [90]  = { 1,  2,  3,  0, 13, 14, 15, 12, 17, 18, 19, 16,
              9, 10, 11,  8,  5,  6,  7,  4, 23, 20, 21, 22},
    [180] = { 2,  3,  0,  1, 10, 11,  8,  9,  6,  7,  4,  5,
             18, 19, 16, 17, 14, 15, 12, 13, 22, 23, 20, 21},
    [270] = { 3,  0,  1,  2, 19, 16, 17, 18, 15, 12, 13, 14,
              7,  4,  5,  6, 11,  8,  9, 10, 21, 22, 23, 20}
}

function build_mirror.rotate_node(node, axis, degrees)
    if axis ~= "y" then
        -- can't rotate any other axis than y at the moment
        return node
    end

    local def = minetest.registered_nodes[node.name]
    if not def then
        return node
    end
    local paramtype2 = def.paramtype2

    local rotation_catalog, orient
    if paramtype2 == "wallmounted" or paramtype2 == "colorwallmounted" then
        rotation_catalog = wallmounted
        orient = node.param2 % 8
    elseif paramtype2 == "facedir" or paramtype2 == "colorfacedir" then
        rotation_catalog = facedir
        orient = node.param2 % 32
    else
        -- can't rotate this
        return node
    end

    local substitution = rotation_catalog[degrees]
    if not substitution then
        return node
    end

    local param2 = node.param2 - orient + substitution[orient + 1]

    return {
        name = node.name,
        param2 = param2
    }
end

--- Returns the mirrored positions as a table
-- @param pos the position to mirror
-- @param node the node to mirror
-- @param mirror_pos the mirror position
-- @param mirrored_axes the axes to mirrror as a table
-- @return the mirrrored positions as table
-- @return the mirrrored nodes as table
function build_mirror.get_mirrored_positions(pos, node, mirror_pos, mirrored_axes)
    local pos_list = {}
    local node_list = {}

    if mirrored_axes.x then
        local mirrored_node = build_mirror.rotate_node(node, "y", 180)
        table.insert(pos_list, build_mirror.mirror_pos(pos, mirror_pos, "x"))
        table.insert(node_list, mirrored_node)
    end

    if mirrored_axes.y then
        table.insert(pos_list, build_mirror.mirror_pos(pos, mirror_pos, "y"))
        table.insert(node_list, node)
    end

    if mirrored_axes.z then
        local mirrored_node = build_mirror.rotate_node(node, "y", 180)
        table.insert(pos_list, build_mirror.mirror_pos(pos, mirror_pos, "z"))
        table.insert(node_list, mirrored_node)
    end

    if mirrored_axes.x and mirrored_axes.y then
        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        table.insert(pos_list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "y"))
        table.insert(node_list, node)
    end

    if mirrored_axes.x and mirrored_axes.z then
        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        table.insert(pos_list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
        table.insert(node_list, node)
    end

    if mirrored_axes.y and mirrored_axes.z then
        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "y")
        table.insert(pos_list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
        table.insert(node_list, node)
    end

    if mirrored_axes.x and mirrored_axes.y and mirrored_axes.z then
        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        mirrored_pos = build_mirror.mirror_pos(mirrored_pos, mirror_pos, "y")
        table.insert(pos_list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
        table.insert(node_list, node)
    end

    return pos_list, node_list
end

function build_mirror.place_mirrored(player, pos, node)
    if not player then
        return
    end

    local playername = player:get_player_name()
    local player_data = build_mirror.mirrors[playername]
    if not player_data then
        return
    end

    local pos_list, node_list = build_mirror.get_mirrored_positions(pos, node, player_data.pos, player_data)
    for i, mirror_pos in ipairs(pos_list) do
        local mirror_node = node_list[i]
        minetest.set_node(mirror_pos, mirror_node)
    end
    -- TODO: param2
end

function build_mirror.dig_mirrored(player, pos)
    if not player then
        return
    end

    local playername = player:get_player_name()
    local player_data = build_mirror.mirrors[playername]
    if not player_data then
        return
    end

    local pos_list = build_mirror.get_mirrored_positions(pos, {}, player_data.pos, player_data)
    for _, mirror_pos in ipairs(pos_list) do
        minetest.set_node(mirror_pos, { name="air" })
    end
end