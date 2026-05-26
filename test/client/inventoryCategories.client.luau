local VideBackpack = require("../VideBackpackLoader/VideBackpack")

VideBackpack.createCategory("Swords", function(tool)
	return tool:HasTag("Sword")
end)

VideBackpack.createCategory("Guns", function(tool)
	return tool:HasTag("Gun")
end)
