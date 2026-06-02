local states = require("../../states")
local vide = require("../../../vide")

local derive = vide.derive

local function useHotbarItems()
	return derive(function()
		local slots = states.slots()
		local items = states.items()

		local newHotbar = table.create(slots)
		for i = 1, slots do
			local item = items[i]
			newHotbar[i] = { item = item }
		end
		return newHotbar
	end)
end

return useHotbarItems
