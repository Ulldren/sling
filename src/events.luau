type Listener<Args... = ...any> = (Args...) -> ()
type Event<Args... = ...any> = {
	callbacks: { Listener<Args...> },
	on: (listener: Listener<Args...>) -> () -> (),
}

local function createEvent<Args...>()
	local callbacks: { Listener<Args...> } = {}

	return table.freeze({
		callbacks = callbacks,
		on = function(listener: Listener<Args...>)
			table.insert(callbacks, listener)
			return function()
				local index = table.find(callbacks, listener)
				if index then
					table.remove(callbacks, index)
				end
			end
		end,
	})
end

return {
	backpackEmpty = createEvent(),
	backpackEquipped = createEvent() :: Event<BackpackItem>,
	backpackUnequipped = createEvent() :: Event<BackpackItem>,
	backpackAdded = createEvent() :: Event<BackpackItem>,
	backpackRemoved = createEvent() :: Event<BackpackItem>,
	inventoryOpened = createEvent(),
	inventoryClosed = createEvent(),

	-- internal
	gamepadRemove = createEvent(),
}
