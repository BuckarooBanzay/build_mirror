_G.build_mirror = {}
dofile("./functions.lua")

describe("mirror_pos", function()
	it("returns the proper coordinates", function()
		local test_set = {
			{
				pos = { x=5, y=5, z=5, param2=0 },
				mirror_pos = { x=0, y=0, z=0 },
				expected = { x=-5, y=5, z=5, param2=0 },
				axis = "x"
			},{
				pos = { x=5, y=5, z=5, param2=0 },
				mirror_pos = { x=0, y=0, z=0 },
				expected = { x=5, y=-5, z=5, param2=0 },
				axis = "y"
			},{
				pos = { x=5, y=5, z=5, param2=0 },
				mirror_pos = { x=0, y=0, z=0 },
				expected = { x=5, y=5, z=-5, param2=0 },
				axis = "z"
			},{
				pos = { x=-10, y=5, z=5, param2=0 },
				mirror_pos = { x=1, y=0, z=0 },
				expected = { x=12, y=5, z=5, param2=0 },
				axis = "x"
			}
		}

		for i, set in ipairs(test_set) do
			local msg = "testset #" .. i
			local mirrored_pos = build_mirror.mirror_pos(set.pos, set.mirror_pos, set.axis)
			assert.equal(set.expected.x, mirrored_pos.x, msg)
			assert.equal(set.expected.y, mirrored_pos.y, msg)
			assert.equal(set.expected.z, mirrored_pos.z, msg)
		end
	end)
end)
