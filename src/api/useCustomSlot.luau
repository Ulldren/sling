local config = require("../core/config")
local slot = require("../ui/components/slot")

--[=[
	Uses the provided custom slot display.

	```luau
	local CustomSlotFrame = require(path_to_component)
	sling.useCustomSlot(CustomSlotFrame)
	```
]=]
local function useCustomSlot(customSlotComponent: (slot.SlotFrameProps) -> (GuiObject))
	config.customSlotComponent = customSlotComponent
end

return useCustomSlot
