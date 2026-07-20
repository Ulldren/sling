local ContextActionService = game:GetService("ContextActionService")

local vide = require("../../../vide")

local effect = vide.effect
local cleanup = vide.cleanup

local function boolAction(props: {
	name: string,
	enabled: (() -> boolean)?,
	actions: { [Enum.KeyCode]: (boolean) -> any },
})
	local keycodes = {}
	for keycode in props.actions do
		table.insert(keycodes, keycode)
	end

	effect(function()
		if props.enabled == nil or props.enabled() then
			ContextActionService:BindAction(props.name, function(_name, state, input)
				local action = props.actions[input.KeyCode]
				if action then
					action(state == Enum.UserInputState.Begin)
				end
			end, false, table.unpack(keycodes))

			cleanup(function()
				ContextActionService:UnbindAction(props.name)
			end)
		end
	end)
end

return boolAction
