
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

local function invert_map(m)
    local inv = {}
    for k, v in pairs(m) do
        inv[v] = k
    end
    return inv
end

-- x- to x+
local param2_x_mapping = {
    [1] = 3,
    [3] = 1,
    [5] = 7,
    [9] = 11,
    [16] = 11,
    [18] = 14,
    [23] = 21,
    [21] = 23
}

-- x- to x+
local param2_x_mapping_inv = invert_map(param2_x_mapping)

-- y- to y+
local param2_y_mapping = {
    [20] = 0,
    [23] = 1,
    [22] = 2,
    [21] = 3
}

-- y+ to y-
local param2_y_mapping_inv = invert_map(param2_y_mapping)

-- z- to z+
local param2_z_mapping = {
    [0] = 2,
    [2] = 0,
    [9] = 5,
    [11] = 14,
    [12] = 14,
    [16] = 18,
    [20] = 22,
    [22] = 20
}

-- z- to z+
local param2_z_mapping_inv = invert_map(param2_z_mapping)

function build_mirror.rotate_node(node, axis_direction)
    local def = minetest.registered_nodes[node.name]
    if not def then
        return node
    end
    local paramtype2 = def.paramtype2

    if paramtype2 ~= "facedir" and paramtype2 ~= "colorfacedir" then
        -- can't rotate this
        return node
    end

    print("rotate_node param2=" .. node.param2 .. " axis_direction=" .. axis_direction)

    local param2

    if axis_direction == "x+" then
        param2 = param2_x_mapping[node.param2]
    elseif axis_direction == "x-" then
        param2 = param2_x_mapping_inv[node.param2]
    elseif axis_direction == "y+" then
        param2 = param2_y_mapping[node.param2]
    elseif axis_direction == "y-" then
        param2 = param2_y_mapping_inv[node.param2]
    elseif axis_direction == "z+" then
        param2 = param2_z_mapping[node.param2]
    elseif axis_direction == "z-" then
        param2 = param2_z_mapping_inv[node.param2]
    else
        error("not a valid axis-direction: " .. axis_direction)
    end

    print("rotate_node(II) param2=" .. (param2 or "nil"))

    return {
        name = node.name,
        param2 = param2 or node.param2
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
        local axis_direction = (mirror_pos.x - pos.x < 0) and "x-" or "x+"
        local mirrored_node = build_mirror.rotate_node(node, axis_direction)

        table.insert(pos_list, build_mirror.mirror_pos(pos, mirror_pos, "x"))
        table.insert(node_list, mirrored_node)
    end

    if mirrored_axes.y then
        local axis_direction = (mirror_pos.y - pos.y < 0) and "y-" or "y+"
        local mirrored_node = build_mirror.rotate_node(node, axis_direction)

        table.insert(pos_list, build_mirror.mirror_pos(pos, mirror_pos, "y"))
        table.insert(node_list, mirrored_node)
    end

    if mirrored_axes.z then
        local axis_direction = (mirror_pos.z - pos.z < 0) and "z-" or "z+"
        local mirrored_node = build_mirror.rotate_node(node, axis_direction)

        table.insert(pos_list, build_mirror.mirror_pos(pos, mirror_pos, "z"))
        table.insert(node_list, mirrored_node)
    end

    if mirrored_axes.x and mirrored_axes.y then
        local x_axis_direction = (mirror_pos.x - pos.x < 0) and "x-" or "x+"
        local y_axis_direction = (mirror_pos.y - pos.y < 0) and "y-" or "y+"

        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        local mirrored_node = build_mirror.rotate_node(node, x_axis_direction)

        table.insert(pos_list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "y"))
        table.insert(node_list, build_mirror.rotate_node(mirrored_node, y_axis_direction))
    end

    if mirrored_axes.x and mirrored_axes.z then
        local x_axis_direction = (mirror_pos.x - pos.x < 0) and "x-" or "x+"
        local z_axis_direction = (mirror_pos.z - pos.z < 0) and "z-" or "z+"

        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        local mirrored_node = build_mirror.rotate_node(node, x_axis_direction)

        table.insert(pos_list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
        table.insert(node_list, build_mirror.rotate_node(mirrored_node, z_axis_direction))
    end

    if mirrored_axes.y and mirrored_axes.z then
        local y_axis_direction = (mirror_pos.y - pos.y < 0) and "y-" or "y+"
        local z_axis_direction = (mirror_pos.z - pos.z < 0) and "z-" or "z+"

        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "y")
        local mirrored_node = build_mirror.rotate_node(node, y_axis_direction)

        table.insert(pos_list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
        table.insert(node_list, build_mirror.rotate_node(mirrored_node, z_axis_direction))
    end

    if mirrored_axes.x and mirrored_axes.y and mirrored_axes.z then
        local x_axis_direction = (mirror_pos.x - pos.x < 0) and "x-" or "x+"
        local y_axis_direction = (mirror_pos.y - pos.y < 0) and "y-" or "y+"
        local z_axis_direction = (mirror_pos.z - pos.z < 0) and "z-" or "z+"

        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        mirrored_pos = build_mirror.mirror_pos(mirrored_pos, mirror_pos, "y")

        local mirrored_node = build_mirror.rotate_node(node, x_axis_direction)
        mirrored_node = build_mirror.rotate_node(mirrored_node, y_axis_direction)

        table.insert(pos_list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
        table.insert(node_list, build_mirror.rotate_node(mirrored_node, z_axis_direction))
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