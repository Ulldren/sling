const types = require("./types")

type Listener<Args... = ...any> = (Args...) -> ()
type Event<Args... = ...any> = {
	callbacks: { Listener<Args...> },
	on: (listener: Listener<Args...>) -> () -> (),
}

const function createEvent<Args...>()
	const callbacks: { Listener<Args...> } = {}

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
	backpackEquipped = createEvent() :: Event<types.InventoryItem>,
	backpackUnequipped = createEvent() :: Event<types.InventoryItem>,
	backpackAdded = createEvent() :: Event<types.InventoryItem>,
	backpackRemoved = createEvent() :: Event<types.InventoryItem>,
	inventoryOpened = createEvent(),
	inventoryClosed = createEvent(),
}
