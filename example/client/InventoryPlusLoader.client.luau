local inventoryplus = require("@game/ReplicatedStorage/Packages/inventoryplus")

inventoryplus.createCategory("Swords", function(tool)
	return tool:HasTag("Sword")
end)
