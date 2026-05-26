local states = require("../states")
local usePreferredTransparency = require("./usePreferredTransparency")
local vide = require("../../vide")

local function useBackgroundTransparency(): () -> number
	local preferredTransparency = usePreferredTransparency()

	return vide.derive(function()
		return states.attributes.BackgroundTransparency() * preferredTransparency()
	end)
end

return useBackgroundTransparency
