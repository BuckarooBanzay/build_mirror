

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