local events = require("../core/events")
local slotManager = require("../core/slotManager")

--[=[
	Sets the hotbar to the specified items.
	
	```luau
	-- Places specific items in the hotbar (swapping if occupied) and leaves other slots unchanged.
	sling.setHotbar({ [2] = itemA, [4] = itemB })
	-- Forces the hotbar to match this exact layout, clearing all other slots.
	sling.setHotbar({ [1] = itemA, [5] = itemB }, true)
	-- Clears the entire hotbar.
	sling.setHotbar({}, true)
	```
]=]
local function setHotbar(items: { BackpackItem }, force: boolean?)
	slotManager.setHotbarItems(items, force)
	events.hotbarChanged.fire(items)
end

return setHotbar
