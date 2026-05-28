const states = require("../states")
const vide = require("../../vide")

const function useInventoryItems()
	return vide.derive(function()
		const slots = states.slots()
		const items = states.items()

		const newInventory = {}
		local count = 0
		for i = slots + 1, #items do
			const entry = items[i]
			if entry and entry.item ~= nil then
				count += 1
				newInventory[count] = entry
			end
		end
		return newInventory
	end)
end

return useInventoryItems
