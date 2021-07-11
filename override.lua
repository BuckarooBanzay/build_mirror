
minetest.register_on_placenode(function(pos, _, player)
    build_mirror.place_mirrored(player, pos)
end)

minetest.register_on_dignode(function(pos, _, player)
    build_mirror.dig_mirrored(player, pos)
end)