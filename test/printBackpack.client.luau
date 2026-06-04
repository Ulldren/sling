local backpack = require("../VideBackpackLoader/VideBackpack")

backpack.onInventoryOpened(function()
	print("Inventory opened!")
end)

backpack.onInventoryClosed(function()
	print("Inventory closed!")
end)

backpack.onBackpackEquipped(function(tool)
	print("Item equipped:", tool.Name)
end)

backpack.onBackpackUnequipped(function(tool)
	print("Item unequipped:", tool.Name)
end)

backpack.onBackpackAdded(function(tool)
	print("Item added:", tool.Name)
end)

backpack.onBackpackRemoved(function(tool)
	print("Item removed:", tool.Name)
end)

backpack.onBackpackEmpty(function()
	print("Backpack empty!")
end)
