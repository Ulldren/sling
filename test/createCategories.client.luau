local backpack = require("../VideBackpackLoader/VideBackpack")

backpack.createCategory("Swords", function(tool)
	return tool:HasTag("Sword")
end)

backpack.createCategory("Guns", function(tool)
	return tool:HasTag("Gun")
end)
