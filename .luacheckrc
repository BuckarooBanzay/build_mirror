
globals = {
	"build_mirror"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump", "VoxelArea",

	-- mineunit
	"sourcefile",
	"mineunit",

	-- deps
	"minetest",
	"worldedit"
}
