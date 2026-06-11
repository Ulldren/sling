local UserInputService = game:GetService("UserInputService")

local useEventListener = require("./useEventListener")
local vide = require("../../../vide")

local function usePreferredInput(): () -> Enum.PreferredInput
	local preferredInput = vide.source(UserInputService.PreferredInput)

	useEventListener(UserInputService:GetPropertyChangedSignal("PreferredInput"), function()
		preferredInput(UserInputService.PreferredInput)
	end)

	return preferredInput
end

return usePreferredInput
