const states = require("../states")
const usePreferredTransparency = require("./usePreferredTransparency")
const vide = require("../../vide")

const function useBackgroundTransparency(): () -> number
	const preferredTransparency = usePreferredTransparency()

	return vide.derive(function()
		return states.attributes.BackgroundTransparency() * preferredTransparency()
	end)
end

return useBackgroundTransparency
