# Managing Hotbar

Sling provides a simple yet powerful API to manage and interact with the Hotbar. You can track when the user rearranges items and programmatically set which items should be placed in the Hotbar.

## `onHotbarChanged`

The `onHotbarChanged` event is fired whenever the hotbar layout changes. This happens when:
- A player drags an item from the inventory into the hotbar.
- A player rearranges items within the hotbar slots.
- A player removes an item from the hotbar.

You can use this hook to keep track of the layout and save it.

```luau
Sling.onHotbarChanged(function(items: { BackpackItem })
    -- `items` is a dictionary where the key is the slot index and the value is the BackpackItem.
end)
```

## `setHotbar`

The `setHotbar` function allows you to force a specific layout for the Hotbar. It takes two parameters:
1. `layout`: A dictionary mapping the slot index (`number`) to the `BackpackItem` instance.
2. `force`: A boolean. If `true`, any existing items currently in the Hotbar that are not present in the new layout will be safely moved back to the inventory.

```luau
Sling.setHotbar(newLayout, true)
```

## Example: Saving and Loading Hotbars

Because tools and items can be given or removed from the player's character during gameplay, or even destroyed upon character death, saving the hotbar using the item's direct `Instance` is not reliable across respawns. Instead, you should save the hotbar by the item's `Name`.

Here is a complete example of how to save a player's hotbar layout and restore it whenever their backpack is reloaded.

```luau
local savedHotbarLayout: { string } = {}

-- Save the hotbar layout by item name, because the item's Instance can change, but the Name usually doesn't
Sling.onHotbarChanged(function(items)
	savedHotbarLayout = {}
	for index, item in items do
		savedHotbarLayout[index] = item.Name
	end
end)

-- Apply saved hotbar when the backpack is loaded
Sling.onBackpackLoaded(function(items)
	-- Don't apply saved hotbar if savedHotbarLayout is empty
	if table.maxn(savedHotbarLayout) == 0 then
		return
	end

	-- Group available items by their name
	local itemsByName: { [string]: { BackpackItem } } = {}
	for _, item in items do
		local list = itemsByName[item.Name]
		if not list then
			list = {}
			itemsByName[item.Name] = list
		end
		table.insert(list, item)
	end

	-- Build the new hotbar by consuming items from the grouped lists
	local newHotbar: { BackpackItem } = {}
	for slotIndex, savedName in savedHotbarLayout do
		local list = itemsByName[savedName]
		if list then
			newHotbar[slotIndex] = table.remove(list)
		end
	end

	-- Force-set the hotbar to move any existing items to inventory and apply the saved hotbar layout
	Sling.setHotbar(newHotbar, true)
end)
```
