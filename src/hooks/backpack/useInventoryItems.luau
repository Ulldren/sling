local states = require("../../states")
local vide = require("../../../vide")

local derive = vide.derive

local function useInventoryItems()
	return derive(function()
		local slots = states.slots()
		local items = states.items()

		local newInventory = {}
		local count = 0
		for i = slots + 1, #items do
			local entry = items[i]
			if entry and entry.item ~= nil then
				count += 1
				newInventory[count] = entry
			end
		end
		return newInventory
	end)
end

return useInventoryItems
