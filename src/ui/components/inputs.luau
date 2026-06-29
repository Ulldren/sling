local cond = require("../../core/utils/cond")
local config = require("../../core/config")
local states = require("../../core/states")
local vide = require("../../../vide")

local create = vide.create
local values = vide.values

type InputProps = {
	key: Enum.KeyCode?,
	button: (() -> GuiButton)?,
}

type BoolInputActionProps = {
	name: string,
	enabled: (() -> boolean)?,
	action: (boolean) -> any,
	inputs: { InputProps },
}

local function BoolInputAction(props: BoolInputActionProps)
	return create("InputAction")({
		StateChanged = props.action,
		Name = props.name,
		Type = Enum.InputActionType.Bool,
		Enabled = props.enabled,

		values(function()
			return props.inputs
		end, function(input: InputProps)
			return create("InputBinding")({
				Name = if input.key then input.key.Name else "UIButton",
				KeyCode = input.key,
				UIButton = input.button,
			})
		end),
	})
end

local function inputs()
	local isGamepadInput = cond.eq(states.preferredInput, Enum.PreferredInput.Gamepad)

	return create("Folder")({
		Name = "inputs",

		create("InputContext")({
			Name = "HotbarContext",
			Priority = 2000,
			Enabled = isGamepadInput,

			BoolInputAction({
				name = "SlotLeftAction",
				action = states.inputs.slotLeft,
				inputs = { { key = Enum.KeyCode.ButtonL1 } },
			}),
			BoolInputAction({
				name = "SlotRightAction",
				action = states.inputs.slotRight,
				inputs = { { key = Enum.KeyCode.ButtonR1 } },
			}),
		}),

		create("InputContext")({
			Name = "InventoryContext",
			Priority = 2000,
			Enabled = cond.all(states.opened, isGamepadInput),

			BoolInputAction({
				name = "CloseInventoryAction",
				action = states.inputs.closeInventory,
				inputs = { { key = config.gamepadCloseKey } },
			}),
			BoolInputAction({
				name = "RemoveFromHotbarAction",
				action = states.inputs.removeFromHotbar,
				inputs = { { key = config.gamepadRemoveKey } },
			}),
			BoolInputAction({
				name = "SelectSwapAction",
				action = states.inputs.selectSwap,
				inputs = { { key = config.gamepadSwapKey } },
			}),
		}),
	})
end

return inputs
