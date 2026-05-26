local states = require("../states")
local vide = require("../../vide")

local function useInventoryItems()
	return vide.derive(function()
		local slots = states.slots()
		local items = states.items()

		local maxIdx = slots
		for idx in items do
			if idx > maxIdx then
				maxIdx = idx
			end
		end

		local newInventory = {}
		for i = slots + 1, maxIdx do
			local item = items[i]
			if item then
				table.insert(newInventory, item)
			end
		end
		return newInventory
	end)
end

return useInventoryItems
