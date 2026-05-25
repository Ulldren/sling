local vide = require("../../vide")
local states = require("../states")
local usePreferredTransparency = require("./usePreferredTransparency")

local function useTransparency(): () -> number
	local preferredTransparency = usePreferredTransparency()

	return vide.derive(function()
		return states.attributes.BackgroundTransparency() * preferredTransparency()
	end)
end

return useTransparency
