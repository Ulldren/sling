local Players = game:GetService("Players")

local useEventListener = require("./useEventListener")
local vide = require("../../vide")

local source = vide.source

local function useCharacter(): () -> Model?
	local character = source(Players.LocalPlayer.Character)

	useEventListener(Players.LocalPlayer.CharacterAdded, function(model: Model)
		character(model)
	end)

	useEventListener(Players.LocalPlayer.CharacterRemoving, function()
		character(nil)
	end)

	return character
end

return useCharacter
