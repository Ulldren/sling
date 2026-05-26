const UserInputService = game:GetService("UserInputService")

const useEventListener = require("./useEventListener")
const vide = require("../../vide")

const function usePreferredInput(): () -> Enum.PreferredInput
	const preferredInput = vide.source(UserInputService.PreferredInput)

	useEventListener(UserInputService:GetPropertyChangedSignal("PreferredInput"), function()
		preferredInput(UserInputService.PreferredInput)
	end)

	return preferredInput
end

return usePreferredInput
