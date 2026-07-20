local Sling = require("./Sling")

Sling.createCategory("Swords", function(tool)
	return tool:HasTag("Sword")
end)

Sling.createCategory("Knifes", function(tool)
	return tool:HasTag("Knife")
end)

Sling.createCategory("Guns", function(tool)
	return tool:HasTag("Gun")
end)

Sling.createCategory("Explosives", function(tool)
	return tool:HasTag("Explosive")
end)

Sling.createCategory("Food", function(tool)
	return tool:HasTag("Food")
end)

Sling.createCategory("Building", function(tool)
	return tool:HasTag("Building")
end)
