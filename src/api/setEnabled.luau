local events = require("../events")
local states = require("../states")

local function setEnabled(value: boolean)
	states.enabled(value)
	for _, listener in events.backpackEnabled.callbacks do
		task.spawn(listener, value)
	end
end

return setEnabled
