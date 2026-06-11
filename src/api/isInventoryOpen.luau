local states = require("../core/states")

local function isInventoryOpen()
	return states.opened()
end

return isInventoryOpen
