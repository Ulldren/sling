local events = require("../events")
local states = require("../states")

local function closeInventory()
	states.opened(false)
	states.gamepadSwapIdx(nil)
	for _, listener in events.inventoryClosed.callbacks do
		task.spawn(listener)
	end
end

return closeInventory
