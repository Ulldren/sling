local GuiService = game:GetService("GuiService")

local useEventListener = require("./useEventListener")
local vide = require("@game/ReplicatedStorage/Packages/vide")

local function usePreferredTransparency(): () -> number
	local preferredTransparency = vide.source(GuiService.PreferredTransparency)

	useEventListener(GuiService:GetPropertyChangedSignal("PreferredTransparency"), function()
		preferredTransparency(GuiService.PreferredTransparency)
	end)

	return preferredTransparency
end

return usePreferredTransparency
