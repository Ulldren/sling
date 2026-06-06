local Sling = require("../Sling")

Sling.onInventoryOpened(function()
	print("Inventory opened!")
end)

Sling.onInventoryClosed(function()
	print("Inventory closed!")
end)

Sling.onBackpackEquipped(function(tool)
	print("Item equipped:", tool.Name)
end)

Sling.onBackpackUnequipped(function(tool)
	print("Item unequipped:", tool.Name)
end)

Sling.onBackpackAdded(function(tool)
	print("Item added:", tool.Name)
end)

Sling.onBackpackRemoved(function(tool)
	print("Item removed:", tool.Name)
end)

Sling.onBackpackEmpty(function()
	print("Backpack empty!")
end)
