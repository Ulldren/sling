local Sling = require("../Sling")

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
		if list and #list > 0 then
			newHotbar[slotIndex] = table.remove(list)
		end
	end

	-- Force-set the hotbar to overwrite any existing items
	Sling.setHotbar(newHotbar, true)
end)
