local vide = require("../../vide")

local spring = vide.spring

local function colorSpring(source: () -> Color3)
	return spring(source, 0.3)
end

return colorSpring
