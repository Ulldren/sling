--!nonstrict
const backpack = require("../components/backpack")
const states = require("../states")
const vide = require("../../vide")

const effect = vide.effect

const controls = {
	slots = 10,
	rows = 4,
	opened = true,
	keyboardHint = true,
}

type Props = {
	controls: typeof(controls),
}

return {
	vide = vide,
	controls = controls,
	story = function(props: Props)
		const function createSword()
			const tool = Instance.new("Tool")
			tool.Name = "Sword"
			tool.TextureId = "rbxasset://Textures/Sword128.png"
			tool.ToolTip = "A cool sword"
			return { item = tool }
		end

		effect(function()
			states.opened(props.controls.opened())
			states.slots(math.floor(props.controls.slots()))
			states.rows(math.floor(props.controls.rows()))
			states.keyboardHint(props.controls.keyboardHint())
			states.items({ createSword() })
		end)

		return vide.apply(backpack())({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end,
}
