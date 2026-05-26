local events = require("../events")
local states = require("../states")

local function openInventory()
	states.opened(true)
	for _, listener in events.inventoryOpened.callbacks do
		task.spawn(listener)
	end
end

return openInventory
