local states = require("../states")

local function isEnabled()
	return states.enabled()
end

return isEnabled
