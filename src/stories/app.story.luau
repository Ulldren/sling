--!nonstrict
const app = require("../components/app")
const states = require("../states")
const types = require("../types")
const vide = require("../../vide")

const derive = vide.derive
const effect = vide.effect

const controls = {
	keyboardHint = true,
	gamepadHint = true,
	opened = true,
	slots = 10,
	rows = 4,
	categories = 4,
}

type Props = {
	controls: typeof(controls),
}

return {
	vide = vide,
	controls = controls,
	summary = "Inventory Plus",
	story = function(props: Props)
		const function createSword()
			const tool = Instance.new("Tool")
			tool.Name = "Sword"
			tool.TextureId = "rbxasset://Textures/Sword128.png"
			tool.ToolTip = "A cool sword"
			return tool
		end

		const function category(name: string): types.Category
			return {
				category = name,
				predicate = function()
					return true
				end,
			}
		end

		const getCategories = derive(function()
			const count = props.controls.categories()
			const categories = {}
			if count < 1 then
				return categories
			end
			for i = 1, count do
				const categoryVal = category("category " .. i)
				table.insert(categories, categoryVal)
			end
			return categories
		end)

		effect(function()
			states.opened(props.controls.opened())
			states.slots(props.controls.slots())
			states.rows(props.controls.rows())
			states.keyboardHint(props.controls.keyboardHint())
			states.gamepadHint(props.controls.gamepadHint())
			states.categories(getCategories())
		end)

		states.items({ [1] = createSword(), [11] = createSword(), [12] = createSword() })

		return app()
	end,
}
