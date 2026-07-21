local config = require("../core/config")

--[=[
	Uses the provided custom slot size.

	```luau
	sling.customSlotCornerRadius(UDim.new(0.1, 0))
	```
]=]
local function useCustomSlotCornerRadius(cornerRadius: UDim)
	config.customSlotCornerRadius = cornerRadius
end

return useCustomSlotCornerRadius
