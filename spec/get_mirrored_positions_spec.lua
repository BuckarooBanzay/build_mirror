_G.build_mirror = {}
_G.minetest = {
	registered_nodes = {}
}
dofile("./functions.lua")

local function pos_to_string(pos)
	return pos.x .. "/" .. pos.y .. "/" .. pos.z
end

describe("get_mirrored_positions", function()
	it("returns the proper coordinates", function()
		local test_set = {
			{
				pos = { x=5, y=5, z=5, param2=0 },
				mirror_pos = { x=0, y=0, z=0 },
				axes = {
					x = true,
					y = true
				},
				expected = {
					{ x=-5, y=5, z=5, param2=0 },
					{ x=5, y=-5, z=5, param2=0 },
					{ x=-5, y=-5, z=5, param2=0 }
				}
			},{
				pos = { x=5, y=5, z=5, param2=0 },
				mirror_pos = { x=0, y=0, z=0 },
				axes = {
					x = true,
					z = true
				},
				expected = {
					{ x=-5, y=5, z=5, param2=0 },
					{ x=5, y=5, z=-5, param2=0 },
					{ x=-5, y=5, z=-5, param2=0 }
				}
			},{
				pos = { x=5, y=5, z=5, param2=0 },
				mirror_pos = { x=0, y=0, z=0 },
				axes = {
					x = true,
					y = true,
					z = true
				},
				expected = {
					{ x=-5, y=5, z=5, param2=0 },
					{ x=5, y=5, z=-5, param2=0 },
					{ x=5, y=-5, z=5, param2=0 },
					{ x=-5, y=-5, z=5, param2=0 },
					{ x=5, y=-5, z=-5, param2=0 },
					{ x=-5, y=5, z=-5, param2=0 },
					{ x=-5, y=-5, z=-5, param2=0 }
				}
			}
		}

		for i, set in ipairs(test_set) do
			local msg = "testset #" .. i
			local expected_positions = {}
			for _, pos in ipairs(set.expected) do
				expected_positions[pos_to_string(pos)] = true
			end
			local list = build_mirror.get_mirrored_positions(set.pos, {}, set.mirror_pos, set.axes)
			assert.equal(#set.expected, #list, msg)
			for j, pos in ipairs(list) do
				assert.equal(true, expected_positions[pos_to_string(pos)], msg .. " expected#" .. j)
			end
		end
	end)
end)
