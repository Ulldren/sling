local states = require("../core/states")

--- Sets whether the backpack is enabled. When disabled, the `BackpackGui` is unmounted.
local function setEnabled(value: boolean)
	states.enabled(value)
end

return setEnabled
