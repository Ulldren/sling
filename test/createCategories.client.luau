local Sling = require("../Sling")

Sling.createCategory("Swords", function(tool)
	return tool:HasTag("Sword")
end)

Sling.createCategory("Guns", function(tool)
	return tool:HasTag("Gun")
end)
