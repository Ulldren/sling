local states = require("../core/states")

local function setEnabled(value: boolean)
	states.enabled(value)
end

return setEnabled
