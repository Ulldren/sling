local states = require("../core/states")

local function closeInventory()
	states.opened(false)
end

return closeInventory
