
globals = {
	"build_mirror",
	"worldedit"
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
	"minetest"
}
