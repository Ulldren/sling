local states = require("../states")
local vide = require("../../vide")

local function useHotbarItems()
	return vide.derive(function()
		local slots = states.slots()
		local items = states.items()

		local newHotbar = table.create(slots)
		for i = 1, slots do
			newHotbar[i] = { item = items[i] }
		end
		return newHotbar
	end)
end

return useHotbarItems
