local states = require("../states")

local function closeInventory()
	states.opened(false)
end

return closeInventory
