local Sling = require("./Sling")

Sling.onInventoryOpened(function()
	print("Inventory opened!")
end)

Sling.onInventoryClosed(function()
	print("Inventory closed!")
end)

Sling.onBackpackItemEquipped(function(item)
	print("Item equipped:", item.Name)
end)

Sling.onBackpackItemUnequipped(function(item)
	print("Item unequipped:", item.Name)
end)

Sling.onBackpackItemAdded(function(item)
	print("Item added:", item.Name)
end)

Sling.onBackpackItemRemoved(function(item)
	print("Item removed:", item.Name)
end)

Sling.onBackpackEmpty(function()
	print("Backpack empty!")
end)
