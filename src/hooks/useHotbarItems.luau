const states = require("../states")
const vide = require("../../vide")

const function useHotbarItems()
	return vide.derive(function()
		const slots = states.slots()
		const items = states.items()

		const newHotbar = table.create(slots)
		for i = 1, slots do
			const entry = items[i] or { item = nil }
			newHotbar[i] = entry
		end
		return newHotbar
	end)
end

return useHotbarItems
