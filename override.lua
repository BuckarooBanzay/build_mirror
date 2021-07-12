
minetest.register_on_placenode(function(pos, node, player)
    build_mirror.place_mirrored(player, pos, node)
end)

minetest.register_on_dignode(function(pos, node, player)
    build_mirror.dig_mirrored(player, pos, node)
end)