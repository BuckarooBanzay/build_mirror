
build_mirror = {
    -- playername => { pos={}, x=true, y=false, z=true }
    mirrors = {}
}

local MP = minetest.get_modpath("build_mirror")

dofile(MP.."/functions.lua")
dofile(MP.."/hud.lua")
dofile(MP.."/privs.lua")
dofile(MP.."/chatcommands.lua")
dofile(MP.."/override.lua")
