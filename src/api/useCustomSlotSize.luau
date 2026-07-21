local config = require("../core/config")

--[=[
	Uses the provided custom slot size.

	```luau
	sling.useCustomSlotSize(px.udim2(50, 50))
	```
]=]
local function useCustomSlotSize(customSlotSize: config.CustomSlotSize)
	config.customSlotSize = customSlotSize
end

return useCustomSlotSize
