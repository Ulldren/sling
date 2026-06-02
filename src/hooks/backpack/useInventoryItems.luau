local slotUtils = require("../../utils/slotUtils")
local states = require("../../states")
local vide = require("../../../vide")

local derive = vide.derive

local function useInventoryItems()
	return derive(function()
		local slots = states.slots()
		local items = states.items()
		local initialCount = slots + 1
		local maxIndex = math.max(slotUtils.getMaxIndex(), initialCount)

		local newInventory = {}
		local count = 0
		for i = initialCount, maxIndex do
			local item = items[i]
			if item then
				count += 1
				newInventory[count] = item
			end
		end
		return newInventory
	end)
end

return useInventoryItems
