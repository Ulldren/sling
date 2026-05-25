--!strict
local types = require("./types")

type Listener<Args... = ...any> = (Args...) -> ()

local function createEvent<Args...>()
	local callbacks: { Listener<Args...> } = {}

	return table.freeze({
		callbacks = callbacks,
		on = function(listener: Listener<Args...>)
			table.insert(callbacks, listener)
			return function()
				table.remove(callbacks, table.find(callbacks, listener))
			end
		end,
	})
end

return {
	backpackEmpty = createEvent(),
	backpackEquipped = createEvent<<(types.InventoryItem)>>(),
	backpackUnequipped = createEvent<<(types.InventoryItem)>>(),
	backpackRemoved = createEvent<<(types.InventoryItem)>>(),
	inventoryOpened = createEvent(),
	inventoryClosed = createEvent(),

	-- internal
	backpackEnabled = createEvent<<(boolean)>>(),
	categoryAdded = createEvent<<(types.Category)>>(),
	attributeChanged = createEvent<<(string, any)>>(),
}
