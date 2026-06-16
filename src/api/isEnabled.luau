local states = require("../core/states")

--- Returns whether the backpack is enabled.
local function isEnabled()
	return states.enabled()
end

return isEnabled
