local states = require("../states")

local function isInventoryOpen()
	return states.opened()
end

return isInventoryOpen
