
local old_set = worldedit.set

function worldedit.set(pos1, pos2, node_names)
    local count = old_set(pos1, pos2, node_names)

    local playername = "singleplayer"
    local player_data = build_mirror.mirrors[playername]
    if not player_data then
        return count
    end

    local pos1_list = build_mirror.get_mirrored_positions(pos1, {}, player_data.pos, player_data)
    local pos2_list = build_mirror.get_mirrored_positions(pos2, {}, player_data.pos, player_data)

    assert(#pos1_list, #pos2_list)

    for i, mirror_pos1 in ipairs(pos1_list) do
        local mirror_pos2 = pos2_list[i]
        count = count + old_set(mirror_pos1, mirror_pos2, node_names)
    end

    return count
end