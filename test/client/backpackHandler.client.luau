const backpack = require("../VideBackpackLoader/VideBackpack")

-- Set theme

task.spawn(function()
	local themes = { "default", "white" }
	local index = 1
	while true do
		task.wait(10)
		backpack.setTheme(backpack.themes[themes[index]])
		index = index + 1
		if index > #themes then
			index = 1
		end
	end
end)

-- Add categories

backpack.createCategory("Swords", function(tool)
	return tool:HasTag("Sword")
end)

backpack.createCategory("Guns", function(tool)
	return tool:HasTag("Gun")
end)

-- Events

backpack.onInventoryOpened(function()
	print("Inventory opened!")
end)

backpack.onInventoryClosed(function()
	print("Inventory closed!")
end)

backpack.onBackpackEquipped(function(tool)
	print("equipped", tool)
end)

backpack.onBackpackUnequipped(function(tool)
	print("unequipped", tool)
end)

backpack.onBackpackAdded(function(tool)
	print("added", tool)
end)

backpack.onBackpackRemoved(function(tool)
	print("removed", tool)
end)

backpack.onBackpackEmpty(function()
	print("Backpack empty!")
end)
