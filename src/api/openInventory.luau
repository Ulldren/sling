local states = require("../states")

local function openInventory()
	states.opened(true)
end

return openInventory
