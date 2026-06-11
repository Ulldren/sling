local states = require("../core/states")

local function openInventory()
	states.opened(true)
end

return openInventory
