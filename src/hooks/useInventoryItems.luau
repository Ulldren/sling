const states = require("../states")
const vide = require("../../vide")

const function useInventoryItems()
	return vide.derive(function()
		const slots = states.slots()
		const items = states.items()

		local maxIdx = slots
		for idx in items do
			if idx > maxIdx then
				maxIdx = idx
			end
		end

		const newInventory = {}
		for i = slots + 1, maxIdx do
			const item = items[i]
			if item then
				table.insert(newInventory, item)
			end
		end
		return newInventory
	end)
end

return useInventoryItems
