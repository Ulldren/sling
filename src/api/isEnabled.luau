local states = require("../core/states")

local function isEnabled()
	return states.enabled()
end

return isEnabled
