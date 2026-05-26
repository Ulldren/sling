const GuiService = game:GetService("GuiService")

const useEventListener = require("./useEventListener")
const vide = require("../../vide")

const function usePreferredTransparency(): () -> number
	const preferredTransparency = vide.source(GuiService.PreferredTransparency)

	useEventListener(GuiService:GetPropertyChangedSignal("PreferredTransparency"), function()
		preferredTransparency(GuiService.PreferredTransparency)
	end)

	return preferredTransparency
end

return usePreferredTransparency
