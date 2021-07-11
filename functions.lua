
--- Mirrors the given coordinate around the specified axis
-- @param pos_with_param2 the position to mirror with a param2 field
-- @param mirror_pos the mirror position
-- @param axis the axis to mirrror
-- @return the mirrrored position
function build_mirror.mirror_pos(pos_with_param2, mirror_pos, axis)
    assert(pos_with_param2.param2)
    local pos_value = assert(pos_with_param2[axis])
    local mirror_value = assert(mirror_pos[axis])
    local delta = mirror_value - pos_value

    local mirrored_pos = {
        x=pos_with_param2.x,
        y=pos_with_param2.y,
        z=pos_with_param2.z,
        param2=pos_with_param2.param2
    }
    mirrored_pos[axis] = mirror_pos[axis] + delta
    return mirrored_pos
end

--- Returns the mirrored positions as a table
-- @param pos the position to mirror
-- @param mirror_pos the mirror position
-- @param mirrored_axes the axes to mirrror as a table
-- @return the mirrrored positions as table
function build_mirror.get_mirrored_positions(pos, mirror_pos, mirrored_axes)
    local list = {}

    if mirrored_axes.x then
        table.insert(list, build_mirror.mirror_pos(pos, mirror_pos, "x"))
    end

    if mirrored_axes.y then
        table.insert(list, build_mirror.mirror_pos(pos, mirror_pos, "y"))
    end

    if mirrored_axes.z then
        table.insert(list, build_mirror.mirror_pos(pos, mirror_pos, "z"))
    end

    if mirrored_axes.x and mirrored_axes.y then
        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        table.insert(list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "y"))
    end

    if mirrored_axes.x and mirrored_axes.z then
        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        table.insert(list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
    end

    if mirrored_axes.y and mirrored_axes.z then
        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "y")
        table.insert(list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
    end

    if mirrored_axes.x and mirrored_axes.y and mirrored_axes.z then
        local mirrored_pos = build_mirror.mirror_pos(pos, mirror_pos, "x")
        mirrored_pos = build_mirror.mirror_pos(mirrored_pos, mirror_pos, "y")
        table.insert(list, build_mirror.mirror_pos(mirrored_pos, mirror_pos, "z"))
    end

    return list
end

function build_mirror.place_mirrored(player)
    if not player then
        return
    end
    -- TODO
end

function build_mirror.dig_mirrored()
    -- TODO
end