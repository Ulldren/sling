--!nonstrict
local app = require("../components/app")
local states = require("../states")
local types = require("../types")
local vide = require("../../vide")

local derive = vide.derive
local effect = vide.effect

local controls = {
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
	story = function(props: Props)
		local function createSword()
			local tool = Instance.new("Tool")
			tool.Name = "Sword"
			tool.TextureId = "rbxasset://Textures/Sword128.png"
			tool.ToolTip = "A cool sword"
			return tool
		end

		local function category(name: string): types.Category
			return {
				category = name,
				predicate = function(item)
					return true
				end,
			}
		end

		local getCategories = derive(function()
			local count = props.controls.categories()
			local categories = {}
			if count < 1 then
				return categories
			end
			for i = 1, count do
				local category = category("category " .. i)
				table.insert(categories, category)
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
