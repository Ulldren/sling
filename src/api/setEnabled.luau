local states = require("../states")

local function setEnabled(value: boolean)
	states.enabled(value)
end

return setEnabled
