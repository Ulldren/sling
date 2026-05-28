const vide = require("../../vide")

const function colorSpring(source: () -> Color3)
	return vide.spring(source, 0.3)
end

return colorSpring
