local types = require("../core/types")
local vide = require("../../vide")

local source = vide.source

type SlotContext = types.SlotContext
type SlotProperties = types.SlotProperties

local slotRender = source({ callback = nil :: ((context: SlotContext) -> SlotProperties)? })

--[=[
	Registers a callback to customize the appearance of slots.

	```luau
	sling.onSlotRender(function(context)
		local properties = {} :: sling.SlotProperties

		if context.item:HasTag("Rare") then
			properties.BackgroundColor = Color3.fromHex("#ffd700")
		end

		return properties
	end)
	```
]=]
local function onSlotRender(callback: (context: SlotContext) -> SlotProperties)
	if slotRender().callback then
		error("[Sling] onSlotRender can only be set once.", 0)
	end
	slotRender({ callback = callback })
end

return function()
	return slotRender, onSlotRender
end
